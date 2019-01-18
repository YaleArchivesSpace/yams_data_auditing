#/usr/bin/python3
#~/anaconda3/bin/python

'''a collection of file handling and other functions'''

import csv, logging, subprocess, os, time, sys

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

def login():
    import requests, json
    try:
        url = input('Please enter the ArchivesSpace API URL: ')
        username = input('Please enter your username: ')
        password = input('Please enter your password: ')
        auth = requests.post(url+'/users/'+username+'/login?password='+password).json()
        #if session object is returned then login was successful; if not it failed.
        if 'session' in auth:
            session = auth["session"]
            h = {'X-ArchivesSpace-Session':session, 'Content_Type': 'application/json'}
            print('Login successful!')
            logging.debug('Success!')
            return (url, h)
        else:
            print('Login failed! Check credentials and try again.')
            logging.debug('Login failed')
            logging.debug(auth.get('error'))
            #try again
            u, heads = login()
            return u, heads
    except:
        print('Login failed! Check credentials and try again!')
        logging.exception('Error: ')
        u, heads = login()
        return u, heads

#Open a CSV in reader mode
def opencsv():
    try:
        input_csv = input('Please enter path to CSV: ')
        file = open(input_csv, 'r', encoding='utf-8')
        csvin = csv.reader(file)
        headline = next(csvin, None)
        return headline, csvin
    except:
        logging.exception('Error: ')
        logging.debug('Trying again...')
        print('CSV not found. Please try again.')
        h, c = opencsv()
        return h, c

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

def opentxt():
    filepath = input('Please enter path to output text file: ')
    filename = open(filepath, 'a', encoding='utf-8')
    return filename

#check if the directory exists. If not, make dir
def setdirectory():
    directory = input('Please enter path to output directory: ')
    if os.path.isdir(directory):
        pass
    else:
        os.mkdir(directory)
    return directory

def openjson(directory, filename):
    filepath = open(directory + '/' + filename + '.json', 'w', encoding='utf-8')
    return filepath

def openxml(directory, filename):
    filepath = open(directory + '/' + filename.strip() + '.xml', 'w', encoding='utf-8')
    return filepath

def keeptime(start):
    elapsedtime = time.time() - start
    m, s = divmod(elapsedtime, 60)
    h, m = divmod(m, 60)
    logging.debug('Total time elapsed: ' + '%d:%02d:%02d' % (h, m, s) + '\n')

def open_outfile(filepath):
    if sys.platform == "win32":
        os.startfile(filepath)
    else:
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        subprocess.call([opener, filepath])