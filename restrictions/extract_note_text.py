import csv
import json

csvin = input('Please enter path to input CSV: ')
file = open(csvin, 'r', encoding='utf-8')
reader = csv.reader(file)
next(reader, None)

output_file = input('Please enter path to output CSV: ')
newfile = open(output_file, 'a', encoding='utf-8', newline='')
writer = csv.writer(newfile)
headers = ['uri', 'id', 'text', '[type, label]']
writer.writerow(headers)

#Do something to get labels
for row in csvlist:
    data = []
    uri = row[0]
    pid = row[1]
    note_json = row[2]
    data.append(uri)
    data.append(pid)
    parsed = json.loads(note_json)
    if parsed['jsonmodel_type'] == 'note_singlepart':
        if 'content' in parsed:
            data.append(parsed['content'])
        if 'type' in parsed:
            data.append(parsed['type'])
     elif parsed['jsonmodel_type'] == 'note_multipart':
        if 'subnotes' in parsed:
            for subnote in parsed['subnotes']:
                if 'content' in subnote:
                    data.append(subnote['content'])
        if 'type' in parsed:
            data.append(parsed['type'])
    csvoutfile.writerow(data)