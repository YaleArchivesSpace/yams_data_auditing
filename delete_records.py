#/usr/bin/python3
#~/anaconda3/bin/python

import utilities, requests, json, logging, time, traceback

#this can work for any kind of AS object that has its own URI - i.e. agents, subjects, archobjs, resource, dos, classifications, etc.
def delete_records():
    starttime = time.time()
    api_url, headers = utilities.login()
    csvheaders, csvfile = utilities.opencsv()
    dirpath = utilities.setdirectory()
    x = 0
    for i, row in enumerate(csvfile, 1):
        record_uri = row[0]
        try:
            record_json = requests.get(api_url + record_uri, headers=headers).json()
            if 'error' in record_json:
                logging.debug('error: could not retrieve ' + str(record_uri))
                logging.debug(str(record_json.get('error')))
            outfile = utilities.openjson(dirpath, record_uri[1:].replace('/','_'))
            json.dump(record_json, outfile)
            record_data = json.dumps(record_json)
            delete = requests.delete(api_url + record_uri, headers=headers, data=record_data).json()
            print(delete)
            if 'status' in delete.keys():
                x += 1
            if 'error' in delete.keys():
                logging.debug(str(record_uri))
                logging.debug('log: ' + str(delete.get('error')))   
        except Exception as exc:
            print(record_uri)
            print(traceback.format_exc())
            logging.debug(record_uri)
            logging.exception('Error: ')
            continue
    logging.debug('Total update attempts: ' + str(i))
    #add count of successful updates to log file
    logging.debug('Records updated successfully: ' + str(x))
    utilities.keeptime(starttime)  
    print('All Done!')

if __name__ == "__main__":
    log_file_name = input('Please enter path to log file: ')
    utilities.error_log(filepath=log_file_name)
    delete_records()