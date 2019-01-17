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

# A few logging, file handling functions

#Sets up error logging; change logging level for more or less logging
def error_log(filepath=None):
    if sys.platform == "win32":
        if filepath == None:
            logger = '\\Windows\\Temp\\error_log.log'
        else:
            logger = filepath
    else:
        if filepath == None:
            logger = '/tmp/error_log.log'
        else:
            logger = filepath
    logging.basicConfig(filename=logger, level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s %(name)s %(message)s')
    return logger

#Open a CSV in reader mode
def opencsv():
    try:
        input_csv = input('Please enter path to CSV: ')
        if input_csv == 'quit':
            quit()
        else:
            file = open(input_csv, 'r', encoding='utf-8')
            csvin = csv.reader(file, quoting=csv.QUOTE_MINIMAL)
            next(csvin)
            logging.debug('File opened: ' + input_csv)
            return csvin
    except FileNotFoundError:
        logging.exception('Error: ')
        logging.debug('Trying again...')
        print('CSV not found. Please try again. Enter "quit" to exit')
        c = opencsv()
        return c

#Open a CSV file in writer mode
def opencsvout():
    try:
        output_csv = input('Please enter path to output CSV: ')
        if output_csv == 'quit':
            quit()
        else:
            fileob = open(output_csv, 'a', encoding='utf-8', newline='')
            csvout = csv.writer(fileob)
            logging.debug('Outfile opened: ' + output_csv)
            return (fileob, csvout)
    except Exception:
        logging.exception('Error: ')
        print('Error creating outfile. Please try again. Enter "quit" to exit')
        f, c = opencsvout()
        return (f, c)

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

#Keeps time
def keeptime(start):
    elapsedtime = time.time() - start
    m, s = divmod(elapsedtime, 60)
    h, m = divmod(m, 60)
    logging.debug('Total time elapsed: ' + '%d:%02d:%02d' % (h, m, s))

# Date parser Function

def parse_dates():
    try:
        starttime = time.time()
        command = find_timetwister()
        csvfile = opencsv()
        fileobject, csvoutfile = opencsvout()
        headers = ['date_id', 'URI', 'expression', 'original_string', 'index_dates', 'date_start', 
            'date_end', 'date_start_full', 'date_end_full', 'inclusive_range', 'certainty']
        csvoutfile.writerow(headers)
        for row_number, row in enumerate(csvfile, 1):
            try:
                date_id = row[0]
                uri = row[1]
                date_expression = row[2]
                #uncomment for even more logging
                #logging.debug('Working on row ' + str(row_number) + ': ' + uri + ' ' + date_id)
                #runs timetwister against each date expression
                process = Popen([command, str(date_expression)], stdout=PIPE, encoding='utf-8')
                #first reads the output and then converts the list items into JSON
                result_list = json.loads(process.stdout.read())
                '''output stored in a list with one or more JSON items (timetwister can parse a single expression field 
                    into multiple dates, eachwith its own JSON bit); this comprehension loops through each JSON bit in the list
                    (usually just the one), and then each kay/value in the JSON bit, and appends the values to the row of 
                    input data (except for the test_data value)'''
                parse_json_into_list = [str(json_value) for json_bit in result_list 
                                        for json_key, json_value in json_bit.items() if json_key != 'test_data']
                row.extend(parse_json_into_list)             
            except Exception as exc:
                 print(traceback.format_exc())
                 row.append('ERROR')
                 logging.debug(date_id + ' ' + uri)
                 logging.exception('Error: ')
            finally:
                csvoutfile.writerow(row)
    finally:
        '''checks if these variables exist; if so does cleanup work no matter what else happens; if variables don't 
        exist there's something wrong with the input or output files'''
        if 'row_number' in vars():
            logging.debug('Last row: ' + str(row_number) + ' ' + date_id + ' ' + uri)
        if 'fileobject' in vars():
            fileobject.close()
            logging.debug('Outfile closed')
        keeptime(starttime)

if __name__ == '__main__':        
    log_file_name = input('Please enter path to log file: ')
    error_log(filepath=log_file_name)
    try:
        logging.debug('Started')
        parse_dates()
        logging.debug('Finished')
        print('All Done!')
    except (KeyboardInterrupt, SystemExit):
        logging.exception('Error: ')
        logging.debug('Aborted')
        print('Aborted!')

