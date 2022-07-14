# /usr/bin/python3
# ~/anaconda3/bin/python

'''This script loops through an input CSV and runs Alex Duryee's Timetwister application against a
    CSV of unstructured date expressions. Written for use with the output of a date query against
    the ArchivesSpace database

    Written for OSX, but might work on a PC? Will test soon. Requires Ruby and the timetwister gem
    https://github.com/alexduryee/timetwister'''

# To Check:
# Faster with CSV or query?

#import cProfile
import json
import logging
import traceback
import shutil
import multiprocessing
import re
import sys
import time
#import tracemalloc
from functools import partial, wraps
from subprocess import Popen, PIPE, DEVNULL
from collections import defaultdict
from utilities import utilities
from utilities import db as dbssh

# what about some pre-processing functions???

# Print iterations progress


def print_progress(iteration, total, prefix='', suffix='', bar_length=50):
    # fix this so it only goes to one decimal
    percents = f'{100 * (iteration / float(total)):.0f}'
    filled_length = int(round(bar_length * iteration / float(total)))
    bar = f'{"█" * filled_length}{"-" * (bar_length - filled_length)}'
    sys.stdout.write(f'\r{prefix} |{bar}| {percents}% {suffix}')
    # Print New Line on Complete
    if iteration == total:
        sys.stdout.write('\n')
    sys.stdout.flush()


def time_it(func):
    """a decorator that times the execution of a function

    TO DO - ADD A TIME PER RECORD CALCULATOR
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        elapsedtime = time.time() - start_time
        m, s = divmod(elapsedtime, 60)
        h, m = divmod(m, 60)
        total_time = 'Total time elapsed: ' + '%d:%02d:%02d' % (h, m, s)
        logging.debug(total_time)
        print(total_time)
        return result
    return wrapper


def find_timetwister(command='timetwister'):
    '''Finds the Timetwister gem in the user's directory. A check to make sure
    the gem is installed before the script tries to run it.

    To-Do: add KeyboardInterrupt try/except; interoperability'''
    if shutil.which(command) is None:
        logging.debug('Requirements not OK. Trying again.')
        command = input('Could not find application. Please try again. Enter "quit" to exit: ')
        if command == 'quit':
            quit()
        # this could be problematic
        if shutil.which(command) is not None:
            logging.debug('Requirements OK')
        else:
            find_timetwister()
    else:
        logging.debug('Requirements OK')
    return command


def exclusions_dict():
    '''Returns a dictionary containing various string patterns. Any date
    expressions which match these strings will not be parsed by timetwister.
    Excluding these in advance speeds up the program signficantly.'''
    months = ("january |february |march |april |may |june |july |august |september |october "
              "|november |december |jan |feb |mar |apr |jun |jul |aug |sep |sept |oct |nov |dec "
              "|jan. |feb. |mar. |apr. |jun. |jul. |aug. |sep. |sept. |oct. |nov. |dec. ")
    month_dd = f'^({months})[0-9]{{1,2}}$'
    # this will get 1/1, 1/10, 12/1, 12/15
    mm_dd = '^[0-9]{1,2}[/][0-9]{1,2}$'
    return {'undated_variations': ['undated', 'Undated', 'n.d.', 'no date',
                                   'No date', '[n.d.]', 'nd', 'unknown', 'unknown', 'n.d',
                                   'n. d.', '[undated]', '[no date]', 'N.d.', 'n.y.', '?',
                                   '0', 'Did Not Come', 'No Date', 'undated ', ' ', 'N/A',
                                   'various', 'n.d,', 'no show', 'Unknown', 'undate',
                                   'undated undated', 'various dates', '(undated)',
                                   'No unitdate', 'Various', '-', '[no year]', '[n.s.]',
                                   'Undated ', 'undated.', 'untitled', '[ca.', ' undated',
                                   '(?)', '(var.)', '[?]', '[n.y.]', '[no date].', 'var.',
                                   'Undated (2)', 'undatd', '[s.a.].', '[undated] [undated]',
                                   'no dates', 'no year', 'various years', 'var. dates',
                                   'unidentified', 'Varied dates', 'v.d.', ' n.d.',
                                   ' no date', ' undated', '--', '.undated', '????',
                                   '???', '??', '?-?', '(n.d.)', '', 's. a.', 's.a.',
                                   '[n.d.].', 'y', 'x', 'xx', 'xxx', 'XXX', 'w', 'Various dates',
                                   'uundated', 'udated', 'udnated', 'umdated', 'unated',
                                   'uncated', 'undaetd', 'Undate', 'Undateable', 'undateed',
                                   'undates', 'undatred', 'Undatted', 'undtaed', 'undted',
                                   'Undted', 'Not dated', 'None', 'empty', 'dates', 'circa',
                                   'Circa', 'circa [ ]', 'c', 'as dated', 'almost all undated',
                                   'active'],
            'months':  ['january', 'february', 'march', 'april', 'may', 'june',
                        'july', 'august', 'september', 'october', 'november',
                        'december', 'jan', 'feb', 'mar', 'apr', 'may', 'jun',
                        'jul', 'aug', 'sep', 'oct', 'nov', 'dec', 'sept',
                        'jan.', 'feb.', 'mar.', 'apr.', 'jun.', 'jul.', 'aug.',
                        'sep.', 'sept.', 'oct.', 'nov.', 'dec.'],
            'days':    ['monday', 'tuesday', 'wednesday', 'thursday', 'friday',
                        'saturday', 'sunday', 'mon', 'tue', 'wed', 'thu', 'fri',
                        'sat', 'sun'],
            'seasons': ['spring', 'summer', 'fall', 'winter'],
            'holidays': ['easter', 'christmas'],
            'mm_dd_regex': mm_dd,
            'month_dd_regex': month_dd}


def check_for_exclusions(date_expression, excl_dict):
    '''Returns an expression which will be evaluated as True or False
    against each date expression by the run_db_query function. If
    False the date expression will be parsed, if not it will be skipped
    and written to a CSV file. Takes the date expression and the exclusions
    dictionary as parameters.'''
    return (date_expression in excl_dict['undated_variations']
            or date_expression.lower() in excl_dict['months']
            or date_expression.lower() in excl_dict['days']
            or date_expression.lower() in excl_dict['seasons']
            or date_expression.lower().startswith('[n.y.]')
            or date_expression.lower().startswith('[no year]')
            or date_expression.lower().startswith('n.y.')
            or date_expression.lower().startswith('no date')
            or date_expression.lower().startswith('no year')
            or date_expression.lower().startswith('[?]')
            or date_expression.lower().startswith('undated')
            or date_expression.lower().startswith('n.d.')
            or date_expression.lower().startswith('?')
            or date_expression.lower().startswith('?')
            or date_expression.lower().startswith('[?')
            or date_expression.lower().startswith('[no yr]')
            or date_expression.lower().startswith('[unidentified year]')
            or date_expression.lower().startswith('ptolemaic')
            or date_expression.lower().startswith('roman')
            or date_expression.lower().startswith('pharaonic')
            or date_expression.lower().startswith('byzantine')
            or re.match(excl_dict['mm_dd_regex'], date_expression.lower())
            or re.match(excl_dict['month_dd_regex'], date_expression.lower()))


def get_row_count(dbconn):
    query_string = """
    select count(*) as count
    from date
    WHERE (date.begin is null and date.end is null)
    AND date.expression is not null
    """
    return dbconn.run_query_list(query_string)[0][0]


def run_date_query(dbconn, filename, csvfile=None):
    '''Runs the get_unstructured_dates query and checks the results against
    the exclusions disctionary. If the date expression is not in the dictionary
    it yields the query results. If the date expression is in the exclusions
    dictionary the result is written to a CSV.'''
    try:
        #open_query = open('get_unstructured_dates.sql', 'r', encoding='utf-8')
        logging.debug('Query started')
        #query_data = dbconn.write_query_gen(open_query.read())
        #query_data = dbconn.write_query_df(open_query.read(), filename)
        query_data = "/Users/aliciadetelich/Dropbox/git/yams_data_auditing/dates/unparsed_input.csv"
        header_row, csvfile = utilities.opencsv(input_csv=query_data)
        logging.debug('Query finished')
        # return query_data
    except Exception:
        print(traceback.format_exc())
        logging.exception('Error: ')
    finally:
        dbconn.close_conn()
        logging.debug('Connection closed')
    return csvfile


def parse_dates(query_row, exclusions_d, counter, row_count):
    '''Parses each date expression.'''
    # This works, but it has a lot of performance overhead. Might be a trade-off, otherwise
    # not sure how to indicate progress, which for a CSV with 350k rows is really necessary
    counter[0] += 1
    print_progress(counter[0], row_count, suffix=f'/{row_count}')
    try:
        date_expression = query_row[2]
        #exclusions_results = check_for_exclusions(query_row[2], exclusions_d)
        #if exclusions_results is None:
        process = Popen(['timetwister', str(date_expression)], stdout=PIPE, stderr=DEVNULL,
                        encoding='utf-8')
        result_list = json.loads(process.stdout.read())
        parse_json_into_tuple = [str(json_value) for json_bit in result_list
                                 for json_key, json_value in json_bit.items()
                                 if json_key in ['original_string', 'date_start', 'date_end']]
        query_row.extend(parse_json_into_tuple)
        # elif (exclusions_results is True or isinstance(exclusions_results, re.Match) is True):
    except Exception:
        print(traceback.format_exc())
        query_row.append("ERROR")
        logging.exception('Error: ')
        logging.debug(query_row)
    return query_row


def date_type_dict():
    '''Opens all the various types of CSVs that we'll be writing to and stores
    the files for use later.'''
    date_type_csvs = defaultdict(list)
    date_types = ['parsed_date_expressions', 'inclusive', 'begin_single', 'begin_inclusive',
                  'end_inclusive', 'unparsed', 'multiples', 'skipped']
    for date_type in date_types:
        fileobject, csvoutfile = utilities.opencsvout(date_type + '.csv')
        csvoutfile.writerow(['id', 'uri', 'expression', 'original_string', 'begin', 'end',
                             'date_type_id'])
        date_type_csvs[date_type].extend([fileobject, csvoutfile])
    return date_type_csvs


def process_output_helper(result, csv_store, report_type, date_type_id=None):
    '''Helper function for process_output function'''
    if date_type_id is not None:
        result.append(date_type_id)
    csv_file = csv_store[report_type][1]
    csv_file.writerow(result)


def process_output(result, csv_store):
    '''Processes input and writes to a series of CSV files.'''
    if len(result) > 6:
        process_output_helper(result, csv_store, 'multiples')
    elif len(result) < 6:
        # this will get all the skipped expressions and all timetwister errors
        process_output_helper(result, csv_store, 'skipped')
    elif len(result) == 6:
        # all parsed date expressions - i.e. the ones that were run through the
        # parser - except for the multipes
        process_output_helper(result, csv_store, 'parsed_date_expressions')
        date_begin = result[4]
        date_end = result[5]
        if date_begin == date_end:
            if date_begin != 'None':
                process_output_helper(result, csv_store, 'begin_single', '903')
            elif date_begin == 'None':
                process_output_helper(result, csv_store, 'unparsed')
        elif date_begin != date_end:
            if date_end == 'None' and date_begin != 'None':
                process_output_helper(result, csv_store, 'begin_inclusive', '905')
            elif date_begin == 'None' and date_end != 'None':
                process_output_helper(result, csv_store, 'end_inclusive', '905')
            elif date_begin != 'None' and date_end != 'None':
                process_output_helper(result, csv_store, 'inclusive', '905')


@time_it
def main():
    '''Bringing it all together.
    TODO: user input to get chunksize value'''
    # log_file_name = input('Please enter path to log file: ')
    utilities.error_log(filepath='parse_date_test_log.log')
    try:
        man = multiprocessing.Manager()
        counter = man.list([0])
        exclusions_d = exclusions_dict()
        dbconn = dbssh.DBConn()
        logging.debug(dbconn.sql_database)
        command = find_timetwister()
        #max_rows = get_row_count(dbconn)[0]
        max_rows = sum(1 for line in open("/Users/aliciadetelich/Dropbox/git/yams_data_auditing/dates/unparsed_input.csv").readlines()) - 1
        print(max_rows)
        #max_rows = 10000
        chunks = int(max_rows * .05)
        logging.debug('Row count: ' + str(max_rows))
        logging.debug('Chunksize: ' + str(chunks))
        csv_store = date_type_dict()
        if command == 'timetwister':
            logging.debug('Parsing started')
            with multiprocessing.Pool() as pool:
                print_progress(counter[0], max_rows, prefix='', suffix=f'/{max_rows}')
                data_output = pool.imap_unordered(partial(parse_dates, exclusions_d=exclusions_d, counter=counter, row_count=max_rows), run_date_query(
                    dbconn, filename='all_date_expressions.csv'), chunksize=chunks)
                logging.debug('Processing started')
                for item in data_output:
                    process_output(item, csv_store)
                logging.debug('Processing finished')
            logging.debug('Parsing finished')
            print('\n' + 'All Done!')
    except (KeyboardInterrupt, SystemExit):
        # make sure that this is working when pressing CTRL Z in both Atom and Terminal
        logging.exception('Error: ')
        logging.debug('Aborted')
        print('Aborted!')
    except Exception:
        logging.exception('Error: ')
        print(traceback.format_exc())
    finally:
        # this closes all of the CSVs in the dict
        for value in csv_store.values():
            value[0].close()
        logging.debug('Outfiles closed')


#tracemalloc.start()

if __name__ == '__main__':
    main()

# snapshot = tracemalloc.take_snapshot()
# statistics = snapshot.statistics('lineno')
# for statistic in statistics:
#     logging.debug(str(statistic))

# NOTE: aborted successfully with CTRL-C; does not work with CTRL-Z

# test db has 346726 unparsed dates
# 344.8 rows per minute when not suppressing deprecation warnings and only including dates
# not in exclusion list on CSV 449.5 rows per minute when not suppressing deprecation
# warnings and including all dates (but skipping those in exlcusion list before parsing)
# Almost 800 per minute when I did this in January - maybe running through the parser
# is no slower than doing the if checks? Or maybe the changes I've made slowed things down?
# Over 900 per minute with the multiprocessing module and not skipping anything...and also
# printing everything...and like a billion processes still running...
# 1724 per minute with multiprocessing and skipping and not printing - 50k, 10k chunk size
# scaled up to all 346k it did ~1450 per minute (chunksize 75k)
# with the separated CSVs, 5k records chunksize 1000: 1428 per minute
# 1851 per minute - 200k chunksize 10k
# 1561 per minute - 346k chunksize 10k
# 1444 per minute - 346k chunksize 40k
# 1210 per minute - 25k chunksize 5k with progress bar; did change a lot of other things, too, though...
# 1444 per minute - all records - 10k chunksize
# 1389 per minute all records - 20k chunksize
