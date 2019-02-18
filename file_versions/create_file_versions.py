#/usr/bin/python3
#~/anaconda3/bin/python

import requests, csv, json, time, traceback, logging

#generic thumbnail
#"https://libweb.library.yale.edu/pui-assets/access_thumb.jpg"

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

def openjson(directory, filename):
    filepath = open(directory + '/' + filename + '.json', 'w', encoding='utf-8')
    return filepath

#Keeps script runtime
def keeptime(start, outfile):
    elapsedtime = time.time() - start
    m, s = divmod(elapsedtime, 60)
    h, m = divmod(m, 60)
    outfile.write('Total time elapsed: ')
    outfile.write('%d:%02d:%02d' % (h, m, s) + '\n')


#add some kind of status update thing so i know it's still going...
def create_file_uris():
    starttime = time.time()
    #execute login function, return api url and headers
    values = login()
    #opens the csv containing data to be added to AS
    csvfile = opencsv()
    #opens log file - CHANGE TO LOGGING!!!
    txtfile = opentxt()
    dirpath = input('Please enter path to backup directory: ')
    #First attempt to use enumerate to calculate success did not work, so using this for now
    x = 0
    #using enumerate to calculate total attempts
    for i, row in enumerate(csvfile, 1):
        #retrieve this data from Ladybird or AS database
        record_uri = row[0]
        #for the open with permission this is still in the digital object ID. For the others have it on
        #a csv
        find_it_url = row[1]
        #use the generic thumbnail for the open with permissions, and thumbs from Ladybird for others; some failed. Will
        #need a webscrape report of diffs
        thumbnail_url = row[2]
        #this will eventually be the OID...for now it is the dig coll ID...
        dig_object_id = row[3]
        try:
        #can add more data here depending on needs
        #retrieves digital object JSON for each digital object URI in the input CSV
           record_json = requests.get(values[0] + record_uri, headers=values[1]).json()
           outfile = openjson(dirpath, record_uri[1:].replace('/','_'))
           json.dump(record_json, outfile)
           record_json['publish'] = True
           record_json['digital_object_id'] = dig_object_id
           find_it_file_version = {'file_uri': find_it_url, 'jsonmodel_type': 'file_version', 
                                   'xlink_show_attribute': 'new', 'publish': True}
           thumbnail_file_version = {'file_uri': thumbnail_url, 'jsonmodel_type': 'file_version', 
                                  'xlink_show_attribute': 'embed', 'publish': True}
           #record_json['file_versions'].append(thumbnail_file_version)
           record_json['file_versions'].extend([find_it_file_version, thumbnail_file_version])
           record_data = json.dumps(record_json)
           record_update = requests.post(values[0]+ record_uri, headers=values[1], data=record_data).json()
        #print(record_update)
           if 'status' in record_update:
               x += 1
               y = list(range(0, 50000, 100))
               if x in y:
                   print(str(x))
           elif 'error' in record_update:
               txtfile.write('error: could not update ' + str(record_uri) + '\n')
               txtfile.write('log: ' + str(record_update.get('error')) + '\n')
               print(record_update)
        except Exception as exc:
            print(record_uri)
            print(traceback.format_exc())
            txtfile.write(record_uri + '\n')
            txtfile.write(str(traceback.format_exc()) + '\n')
            txtfile.write(str(exc) + '\n')
            continue
    txtfile.write('Total number of records attempted: ' + str(i) + '\n')
    txtfile.write('Successful updates: ' + str(x) + '\n')
    keeptime(starttime, txtfile)
    print('All Done!')


