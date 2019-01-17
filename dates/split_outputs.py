#/usr/bin/python3
#~/anaconda3/bin/python

#This script will loop through the parsed date spreadsheets and split different date
#types into their own spreadsheets

import csv

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

csvfile = opencsv()
inclusive_dates = opencsvout()
begin_only = opencsvout()
end_only = opencsvout()


begin_only_headers = ['id', 'expression', 'begin', 'date_type_id']
inclusive_headers = ['id', 'expression', 'begin', 'end', 'date_type_id']
end_only_headers = ['id', 'expression', 'end', 'date_type_id']

begin_only.writerow(begin_only_headers)
end_only.writerow(end_only_headers)
inclusive_dates.writerow(inclusive_headers)

for row in csvfile:
    newrow = []
    date_start = row[2]
    date_end = row[3]
    if date_start == date_end:
        row.insert(3, '903')
        newrow.append(row[:4])
        writer1.writerows(newrow)
    elif date_start == 'null':
        #this seems silly but it works...
        for item in row:
            if item != 'null':
                newrow.append(item)
        newrow.append('905')
        writer3.writerow(newrow)
    elif date_end == 'null':
        for item in row:
            if item != 'null':
                newrow.append(item)
        newrow.append('905')
        writer4.writerow(newrow)
    else:
        row.append('905')
        writer2.writerow(row)