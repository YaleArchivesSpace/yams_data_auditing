#/usr/bin/python3
#~/anaconda3/bin/python

#This script unpublishes notes based on a list of URIs and note persistent IDs

import requests,json,logging, sys,os, time, csv, subprocess, traceback

def error_log():
    if sys.platform == "win32":
        log_file = '\\Windows\\Temp\\error_log.log'
    else:
        log_file = '/tmp/error_log.log'
    logging.basicConfig(filename=log_file, level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s %(name)s %(message)s')
    return log_file

def open_outfile(filepath):
    if sys.platform == "win32":
        os.startfile(filepath)
    else:
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        subprocess.call([opener, filepath])

def login():
    try:
        url = input('Please enter the ArchivesSpace API URL: ')
        username = input('Please enter your username: ')
        password = input('Please enter your password: ')
        auth = requests.post(url+'/users/'+username+'/login?password='+password).json()
        #if session object is returned then login was successful; if not it failed.
        if 'session' in auth:
            session = auth["session"]
            h = {'X-ArchivesSpace-Session':session, 'Content_Type': 'application/json'}
            print('\nLogin successful!\n')
            logging.debug('Success!')
            return (url, h)
        else:
            print('\nLogin failed! Check credentials and try again\n')
            logging.debug('Login failed')
            logging.debug(auth.get('error'))
            u, heads = login()
            return u, heads
    except:
        print('\nLogin failed! Check credentials and try again!\n')
        logging.exception('Error: ')
        u, heads = login()
        return u, heads

#Open a CSV in reader mode
def opencsv():
    try:
        input_csv = input('Please enter path to CSV: ')
        file = open(input_csv, 'r', encoding='utf-8')
        csvin = csv.reader(file)
        next(csvin, None)
        return csvin
    except:
        logging.exception('Error: ')
        logging.debug('Trying again...')
        print('\nCSV not found. Please try again.\n')
        c = opencsv()
        return c

#check if the directory exists. If not, make dir
def setdirectory():
    directory = input('Please enter path to backup directory: ')
    if os.path.isdir(directory):
        logging.debug('Using existing directory')
    else:
        os.mkdir(directory)
    return directory

def openjson(directory, filename):
    filepath = open(directory + '/' + filename + '.json', 'w', encoding='utf-8')
    return filepath

def keeptime(start):
    elapsedtime = time.time() - start
    m, s = divmod(elapsedtime, 60)
    h, m = divmod(m, 60)
    logging.debug('Total time elapsed: ' + '%d:%02d:%02d' % (h, m, s) + '\n')
    print('Total time elapsed: ' + '%d:%02d:%02d' % (h, m, s) + '\n')

def update_note_pub_status():
    logger = error_log()
    starttime = time.time()
    api_url, headers = login()
    csvfile = opencsv()
    dirpath = setdirectory()
    x = 0
    for i, row in enumerate(csvfile, 1):
        try: 
            record_uri = row[0]
            persistent_id = row[1]
            updated_status = row[2]
            record_json = requests.get(api_url + record_uri, headers=headers).json()
            if 'error' in record_json:
                logging.debug('error: could not retrieve ' + str(record_uri))
                logging.debug(str(record_json.get('error')))
            outfile = openjson(dirpath, record_uri[1:].replace('/','_'))
            json.dump(record_json, outfile)
            for note in record_json['notes']:
                if note['persistent_id'] == persistent_id:
                    if updated_status == '1':
                        note['publish'] = True
                    elif updated_status == '0':
                        note['publish'] = False
            data = json.dumps(record_json)
            record_update = requests.post(api_url + record_uri, headers=headers, data=data).json()
            if 'status' in record_update.keys():
                x += 1
            if 'error' in record_update:
                logging.debug('error: could not update ' + str(record_uri))
                logging.debug(str(record_update.get('error')))
                print(record_update)
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
    keeptime(starttime)
    open_outfile(logger)

if __name__ == "__main__":
    update_note_pub_status()
