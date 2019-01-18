#/usr/bin/python3
#~/anaconda3/bin/python

'''This script updates date records using the object URI and expression as a match point'''

import utilities, requests, json, csv, traceback, logging, sys, time

def update_dates_by_expression():
    starttime = time.time()
    api_url, headers = utilities.login()
    headers, csvfile = utilities.opencsv()
    dirpath = utilities.setdirectory()
    x = 0
    for i, row in enumerate(csvfile, 1):
    	uri = row[1]
    	date_expression = row[2]
    	original_date = row[3]
    	begin_date = row[4]
    	end_date = row[5]
    	date_type_id = row[6]
        try:
            record_json = requests.get(api_url + uri, headers=headers).json()
            if 'error' in record_json:
                logging.debug('error: could not retrieve ' + str(uri))
                logging.debug(str(record_json.get('error')))
            outfile = utilities.openjson(dirpath, uri[1:].replace('/','_'))
            json.dump(record_json, outfile)
            for date in record_json['dates']:
            	if 'expression' in date:
            		if date['expression'] == date_expression:
            			if begin_date != 'None':
            				date['begin'] = begin_date
            			if end_date != 'None':
            				date['end'] = end_date
            			if date_type_id != '':
            				date['date_type_id'] = int(date_type_id)
            record_data = json.dumps(record_json)
            record_update = requests.post(api_url + uri, headers=headers, data=record_data).json()
            print(record_update)
            if 'status' in record_update:
                x += 1
            if 'error' in record_update:
                logging.debug('error: could not update ' + str(uri) + '\n')
                logging.debug('log: ' + str(record_update.get('error')) + '\n')
                print(record_update)
        except Exception as exc:
            print(uri)
            print(traceback.format_exc())
            logging.debug(uri)
            logging.exception('Error: ')
            continue
    utilities.keeptime(starttime)
    logging.debug('Total update attempts: ' + str(i))
    logging.debug('Records updated successfully: ' + str(x) + '\n')
    print('All Done!')

if __name__ == "__main__":
    log_input = input('Please enter path to log file')
    utilities.error_log(filepath=log_input)
    update_dates_by_expression()