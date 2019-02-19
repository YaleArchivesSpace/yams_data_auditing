import csv, requests, json, traceback, logging
import login, utilities

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

def opencsv():
    '''This function opens a csv file'''
    input_csv = input('Please enter path to CSV: ')
    file = open(input_csv, 'r', encoding='utf-8')
    csvin = csv.reader(file)
    next(csvin, None)
    return csvin

def opentxt():
    filepath = input('Please enter path to output text file: ')
    filename = open(filepath, 'a', encoding='utf-8')
    return filename

def setdirectory():
    directory = input('Please enter path to backup directory: ')
    return directory

def openjson(directory, filename):
    filepath = open(directory + '/' + filename + '.json', 'w', encoding='utf-8')
    return filepath

def replace_note_by_id():
    #replaces a note's content in ArchivesSpace using a persistent ID
    values = login()
    csvfile = opencsv()
    txtfile = opentxt()
    dirpath = setdirectory()
    for row in csvfile:
        record_uri = row[4]
        persistent_id = row[5]
        proposed_note_text = row[1]
        try:
            resource_json = requests.get(values[0] + record_uri, headers=values[1]).json()
            outfile = openjson(dirpath, record_uri[1:].replace('/','_'))
            json.dump(resource_json, outfile)
            for note in resource_json['notes']:
                if note['jsonmodel_type'] == 'note_multipart':
                    if note['persistent_id'] == persistent_id:
                        note['subnotes'][0]['content'] = proposed_note_text
            resource_data = json.dumps(resource_json)
            resource_update = requests.post(values[0] + record_uri, headers=values[1], data=resource_data).json()
            print(resource_update)
            if 'error' in resource_update.keys():
                txtfile.write('error: could not update ' + str(resource_uri) + '\n')
                txtfile.write('log: ' + str(resource_update.get('error')) + '\n')
                print(resource_update)
        except Exception as exc:
            print('Something went wrong. Could not update ' + str(record_uri))
            print(traceback.format_exc())
            print(exc)
            txtfile.write('Something went wrong. Could not update ' + str(record_uri) + '\n')
            txtfile.write(str(traceback.format_exc()) + '\n')
            txtfile.write(str(exc) + '\n')
            continue
    txtfile.close()

replace_note_by_id()
