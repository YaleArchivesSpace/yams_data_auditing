#/usr/bin/python3
#~/anaconda3/bin/python

'''This script loops through an input CSV and runs Alex Duryee's Timetwister application against a 
    CSV of unstructured date expressions. Written for use with the output of a date query against the 
    ArchivesSpace database - 
    https://github.com/YaleArchivesSpace/yams_data_auditing/blob/master/dates/get_unstructured_dates.sql

    Written for OSX, but might work on a PC? Will test soon. Requires Ruby and the timetwister gem - 
    https://github.com/alexduryee/timetwister'''

import subprocess, csv, json, logging, traceback, sys

# A few logging, CSV handling functions

#Sets up error logging
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
        file = open(input_csv, 'r', encoding='utf-8')
        csvin = csv.reader(file, quoting=csv.QUOTE_MINIMAL)
        next(csvin)
        return csvin
    except:
        logging.exception('Error: ')
        logging.debug('Trying again...')
        print('CSV not found. Please try again.')
        c = opencsv()
        return c

#Open a CSV file in writer mode
def opencsvout():
    try:
        output_csv = input('Please enter path to output CSV: ')
        fileob = open(output_csv, 'a', encoding='utf-8', newline='')
        csvout = csv.writer(fileob)
        return (fileob, csvout)
    except:
        logging.exception('Error: ')
        print('\nError creating outfile. Please try again.\n')
        f, c = opencsvout()
        return (f, c)

# Date parser Function

def parse_dates(command):
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
            #Comment this out if you'd rather just get error reporting
            logging.debug('Working on row ' + str(row_number) + ': ' + uri + ' ' + date_id)
            #runs timetwister against each date expression
            process = subprocess.Popen([command, str(date_expression)], stdout=subprocess.PIPE, encoding='utf-8')
            #first reads the output and then converts the list items into JSON
            result_list = json.loads(process.stdout.read())
            '''output stored in a list with one or more JSON items (timetwister can parse a single expression field 
                into multiple dates, eachwith its own JSON bit); this comprehension loops through each JSON bit in the list,
                and then each value in the JSON bit, and appends the values to the row of input data'''
            parse_json_into_list = [str(json_value) for json_bit in result_list for json_key, json_value in json_bit.items() if json_key != 'test_data']
            row.extend(parse_json_into_list)
        except Exception as exc:
             print(traceback.format_exc())
             row.append('ERROR')
             logging.debug(date_id + ' ' + uri)
             logging.exception('Error: ')
        finally:
            csvoutfile.writerow(row)
    fileobject.close()

if __name__ == '__main__':        
    log_file_name = input('Please enter path to log file: ')
    error_log(filepath=log_file_name)
    command_path = input('Please enter command or path to application\n(i.e. "timetwister" or "/Users/username/.gem/ruby/2.0.0/bin/timetwister": ')
    parse_dates(command_path)
    print('All Done!')