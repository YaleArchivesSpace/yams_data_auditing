#/usr/bin/python3
#~/anaconda3/bin/python

import requests, csv, json, time, traceback

#Log in to the ArchivesSpace API
def login():
    api_url = input('Please enter the ArchivesSpace API URL: ')
    username = input('Please enter your username: ')
    password = input('Please enter your password: ')
    auth = requests.post(api_url+'/users/'+username+'/login?password='+password).json()
    #if session object is returned then login was successful; if not it failed.
    if 'session' in auth:
        session = auth["session"]
        headers = {'X-ArchivesSpace-Session':session}
        print('Login successful!')
        return (api_url, headers)
    else:
        print('Login failed! Check credentials and try again')
        return

#Open a CSV in reader mode
def opencsv():
    input_csv = input('Please enter path to CSV: ')
    file = open(input_csv, 'r', encoding='utf-8')
    csvin = csv.reader(file)
    next(csvin, None)
    return csvin

#Open a text file in writer mode
def opentxt():
    filepath = input('Please enter path to output text file: ')
    filename = open(filepath, 'a', encoding='utf-8')
    return filename

#Keeps script runtime
def keeptime(start, outfile):
    elapsedtime = time.time() - start
    m, s = divmod(elapsedtime, 60)
    h, m = divmod(m, 60)
    outfile.write('Total time elapsed: ')
    outfile.write('%d:%02d:%02d' % (h, m, s) + '\n')

def create_file_uris():
    starttime = time.time()
	#execute login function, return api url and headers
    values = login()
	#opens the csv containing data to be added to AS
    csvfile = opencsv()
	#opens log file
    txtfile = opentxt()
	#First attempt to use enumerate to calculate success did not work, so using this for now
    x = 0
	#using enumerate to calculate total attempts
    for i, row in enumerate(csvfile, 1):
        record_uri = row[0]
        thumbnail_url = row[1]
        try:
            record_json = requests.get(values[0] + record_uri, headers=values[1]).json()
            thumbnail_file_version = {'file_uri': thumbnail_url, 'jsonmodel_type': 'file_version', 
                                      'xlink_show_attribute': 'embed', 'publish': True}
            record_json['file_versions'].append(thumbnail_file_version)
            record_data = json.dumps(record_json)
            record_update = requests.post(values[0]+ record_uri, headers=values[1], data=record_data).json()
    		#print(record_update)
            if 'status' in record_update.keys():
                x += 1
            elif 'error' in record_update.keys():
                txtfile.write('error: could not update ' + str(record_uri) + '\n')
                txtfile.write('log: ' + str(record_update.get('error')) + '\n')
                print(record_update)
        except Exception as exc:
            print(record_uri)
            print(traceback.format_exc())
            print(exc)
            txtfile.write(record_uri + '\n')
            txtfile.write(str(traceback.format_exc()) + '\n')
            txtfile.write(str(exc) + '\n')
            continue
    txtfile.write('Total number of records attempted: ' + str(i) + '\n')
    txtfile.write('Successful updates: ' + str(x) + '\n')
    keeptime(starttime, txtfile)
    print('All Done!')


