#/usr/bin/python3
#~/anaconda3/bin/python

'''This script loops through an input CSV and runs Alex Duryee's Timetwister application against a 
    CSV of unstructured date expressions. Written for use with the output of a date query against the 
    ArchivesSpace database - 
    https://github.com/YaleArchivesSpace/yams_data_auditing/blob/master/dates/get_unstructured_dates.sql

    Written for OSX, but might work on a PC? Will test soon. Requires Ruby and the timetwister gem - 
    https://github.com/alexduryee/timetwister'''

import csv, json, logging, traceback, sys, shutil, time
from subprocess import Popen, PIPE
from utilities import utilities, dbssh

'''question: would it be faster to save this into a CSV and then open the CSV?? That way it'd be stored in a generator
rather than a list.'''
def run_db_query():
    config_file = utilities.get_config()
    as_db = dbssh.DBConn(config_file=config_file)
    open_query = open('get_unstructured_dates.sql', 'r', encoding='utf-8')
    query_data = as_db.run_query(open_query.read())
    q = query_data.values.tolist()
    return q

#Checks if application is installed before running
def find_timetwister():
    logging.debug('Checking requirements')
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
def parse_dates():
    try:
        #starttime = time.time()
        command = find_timetwister()
        #header_row, csvfile = utilities.opencsv()
        fileobject, csvoutfile = utilities.opencsvout(output_csv='parsed_date_expressions.csv')
        q_data = run_db_query()
        yes_to_continue = input('Enter "Y" to split output into multiple spreadsheets by date type, or any key to continue: ')
        headers = ['date_id', 'uri', 'expression', 'original_string', 'date_start', 'date_end']
        csvoutfile.writerow(headers)
        for row_number, row in enumerate(q_data, 1):
            try:
                counter_range = list(range(0, 5500000, 1000))
                if row_number in counter_range:
                    logging.debug('Row: ' + str(row_number))
                date_id = row[0]
                uri = row[1]
                date_expression = row[2]
                #runs timetwister against each date expression
                process = Popen([command, str(date_expression)], stdout=PIPE, encoding='utf-8')
                #first reads the output and then converts the list items into JSON
                result_list = json.loads(process.stdout.read())
                '''output stored in a list with one or more JSON items (timetwister can parse a 
                    single expression field into multiple dates, eachwith its own JSON bit); this 
                    comprehension loops through each JSON bit in the list (usually just the one), 
                    and then each kay/value in the JSON bit, and appends the original, begin, and end 
                    values to the row of input data'''
                parse_json_into_list = [str(json_value) for json_bit in result_list 
                                        for json_key, json_value in json_bit.items() 
                                        if json_key in ['original_string', 'date_start', 'date_end']]
                row.extend(parse_json_into_list)
                if yes_to_continue == 'Y':
                    proc = process_output(row, datadict)
                else:
                    continue
            except Exception as exc:
                 print(traceback.format_exc())
                 row.extend(['ERROR'])
                 if date_id:
                    logging.debug(date_id + ' ' + uri)
                 logging.exception('Error: ')
            finally:
                csvoutfile.writerow(row)
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
    data_dictionary = {'begin_single': [], 'inclusive':[], 'begin_inclusive': [], 'end_inclusive': [],
                    'multiples': [], 'errors': [], 'unparsed': []}
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
    log_file_name = input('Please enter path to log file: ')
    utilities.error_log(filepath=log_file_name)
    try:
        logging.debug('Started')
        parse_dates()
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

