#/usr/bin/python3
#~/anaconda3/bin/python

'''This script loops through an input CSV and runs Alex Duryee's Timetwister application against a 
    CSV of unstructured date expressions. Written for use with the output of a date query against the 
    ArchivesSpace database - 
    https://github.com/YaleArchivesSpace/yams_data_auditing/blob/master/dates/get_unstructured_dates.sql

    Written for OSX, but might work on a PC? Will test soon. Requires Ruby and the timetwister gem - 
    https://github.com/alexduryee/timetwister'''

import csv, json, logging, traceback, sys, shutil, time, os
from collections import defaultdict
from subprocess import Popen, PIPE, DEVNULL
from utilities import utilities, dbssh




'''question: would it be faster to save this into a CSV and then open the CSV?? That way it'd be stored in a generator
rather than a list. Try it both ways and see what happens. Also it might just be good to have those
unparsed dates in a CSV so I can look at them or something.

Side note - this function does a bunch of different things, should it be split up into different funcs?


Also maybe change this to a with open so don't have to close the file before opening it again?


Also also I think there has to be a better way to do all of this...like some way to just return a generator
from the actual query results and then use that. Just have to keep experimenting and maybe find some way
to time the scripts so that I can see which is most efficient.


'''
def run_db_query(query_data=None):
    try:
        as_db = dbssh.DBConn()
        print(as_db)
        open_query = open('get_unstructured_dates.sql', 'r', encoding='utf-8')
        query_data = as_db.run_query_gen(open_query.read())
        print(type(query_data))
    finally:
        as_db.close_conn()
        return query_data

#Checks if application is installed before running
def find_timetwister():
    logging.debug('Checking requirements')
    #if not ...?
    if shutil.which('timetwister') is None:
        logging.debug('Requirements not OK. Trying again.')
        c = input('Could not find application. Please locate and try again. Enter "quit" to exit: ')
        if c == 'quit':
            quit()
        if shutil.which(c) is not None:
            logging.debug('Requirements OK')
            return c
        else:
            find_timetwister()
    else:
        logging.debug('Requirements OK')
        return 'timetwister'

# Date parser Function
def parse_dates(command, query_data, fileobject, csvoutfile):
    try:
        #starttime = time.time()
        #header_row, csvfile = utilities.opencsv()
        yes_to_continue = input('Enter "Y" to split output into multiple spreadsheets by date type, or any key to continue: ')
        headers = ['date_id', 'uri', 'expression', 'original_string', 'date_start', 'date_end']
        csvoutfile.writerow(headers)
        DEVNULL = open(os.devnull, 'wb')
        for row_number, row in enumerate(query_data, 1):
            try:
                counter_range = range(0, 5500000, 1000)
                if row_number in counter_range:
                    logging.debug('Row: ' + str(row_number))
                date_id = row[0]
                uri = row[1]
                date_expression = row[2]
                #runs timetwister against each date expression
                process = Popen([command, str(date_expression)], stdout=PIPE, stderr=DEVNULL, encoding='utf-8')
                #first reads the output and then converts the list items into JSON
                result_list = json.loads(process.stdout.read())
                '''output stored in a list with one or more JSON items (timetwister can parse a 
                    single expression field into multiple dates, eachwith its own JSON bit); this 
                    comprehension loops through each JSON bit in the list (usually just the one), 
                    and then each kay/value in the JSON bit, and appends the original, begin, and end 
                    values to the row of input data'''
                parse_json_into_list = tuple(str(json_value) for json_bit in result_list 
                                        for json_key, json_value in json_bit.items() 
                                        if json_key in ['original_string', 'date_start', 'date_end'])
                new_row = row + parse_json_into_list
                if yes_to_continue == 'Y':
                    proc = process_output(new_row, datadict)
                else:
                    continue
            except Exception as exc:
                 print(traceback.format_exc())
                 row.append('ERROR')
                 if date_id:
                    logging.debug(date_id + ' ' + uri)
                 logging.exception('Error: ')
            finally:
                csvoutfile.writerow(new_row)
    finally:
        '''This is for creating multiple CSV files from the original file. I guess it also creates a single file??'''
        if 'proc' in vars():
            for key, value in datadict.items():
                fob, outfile = utilities.opencsvout(output_csv=key + '.csv')
                outfile.writerow(headers + ['date_type_id'])
                outfile.writerows(value)
                fob.close()
                logging.debug('Outfile closed: ' + key + '.csv')
        '''checks if these variables exist; if so does cleanup work no matter what else happens; if variables don't 
        exist there's something wrong with the input or output files'''
        if 'row_number' in vars():
            if date_id:
                logging.debug('Last row: ' + str(row_number) + ' ' + str(date_id) + ' ' + str(uri))
        if 'fileobject' in vars():
            fileobject.close()
            logging.debug('Outfile closed')
        #keeptime(starttime)

#Organizes output by date type
def process_output(data_list):
    #use a default_dict here???
    data_dictionary = defaultdict(list)
    if len(data_list) > 6:
        data_dictionary['multiples'].append(data_list)
    elif len(data_list) < 6:
        data_dictionary['errors'].append(data_list)
    elif len(data_list) == 6:
        date_begin = data_list[4]
        date_end = data_list[5]
        if date_begin == date_end:
            if date_begin != 'None':
                data_list.append('903')
                data_dictionary['begin_single'].append(data_list)
            else:
                data_dictionary['unparsed'].append(data_list)
        else:
            if date_end == 'None' and date_begin != 'None':
                data_list.append('905')
                data_dictionary['begin_inclusive'].append(data_list)
            if date_begin == 'None' and date_end != 'None':
                data_list.append('905')
                data_dictionary['end_inclusive'].append(data_list)
            if date_begin != 'None' and date_end != 'None':
                data_list.append('905')
                data_dictionary['inclusive'].append(data_list)

#@utilities.keeptime
def main():
    command = find_timetwister()
    fileobject, csvoutfile = utilities.opencsvout(output_csv='parsed_date_expressions.csv')
    #config_file = utilities.get_config(cfg='/Users/aliciadetelich/as_tools_config.yml')
    q_data = run_db_query()
    #need to pull stuff out of the parse_dates function into main function.
    log_file_name = input('Please enter path to log file: ')
    utilities.error_log(filepath=log_file_name)
    try:
        logging.debug('Started')
        parse_dates(command, q_data, fileobject, csvoutfile)
        logging.debug('Finished')
        print('All Done!')
    except (KeyboardInterrupt, SystemExit):
        logging.exception('Error: ')
        logging.debug('Aborted')
        print('Aborted!')   

if __name__ == '__main__':        
    main()

'''To-Do
Consider csvdicts
'''

