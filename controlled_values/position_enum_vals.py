#/usr/bin/python3
#~/anaconda3/bin/python

import utilities, requests, json, time

def position_enum_values():
    starttime = time.time()
    csvfile = utilities.opencsv()
    api_url, headers = utilities.login()
    for i, row in enumerate(csvfile, 1):
        try:
            enum_value_uri = row[0]
            desired_position = row[1]
            get_enum_value = requests.get(api_url + enum_value_uri, headers=headers).json()
            enum_value_json = requests.post(api_url + enum_value_uri + '/position?position=' + desired_position, headers=headers, data=json.dumps(get_enum_val)).json()
        except Exception as exc:
            logging.debug(record_uri)
            logging.exception('Error: ')
            print(record_uri)
            print(traceback.format_exc())
    logging.debug('Total update attempts: ' + str(i))
    logging.debug('Records updated successfully: ' + str(x))
    print('All Done!')
    print('Total update attempts: ' + str(i))
    print('Records updated successfully: ' + str(x))
    utilities.keeptime(starttime)

if __name__ == "__main__":
    utilities.error_log()
    position_enum_values()