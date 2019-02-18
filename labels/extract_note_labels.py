import csv
import json

csvin = input('Please enter path to input CSV: ')

#add way to run script on all files in a folder; same with pandas script
#extract persistent IDs, text

file = open(csvin, 'r', encoding='utf-8')
reader = csv.reader(file)
next(reader, None)

output_file = input('Please enter path to output CSV: ')
newfile = open(output_file, 'a', encoding='utf-8', newline='')
writer = csv.writer(newfile)
headers = ['uri', 'id', '[type, label]', 'type', 'label']
writer.writerow(headers)

#ALSO add one for a different kind of note - bioghist, etc. - will get empty stuff otherwise
#Don't quite know why the text is showing up as a list...maybe need a []?? Or would that add another list? wtf

for row in reader:
    note_text = row[0]
    uri = row[1]
    new_dict = json.loads(note_text)
    data = []
    note_label = []
    data.insert(0, uri)
    for key, value in new_dict.items():
        if 'note_singlepart' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
 #               data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
            # if key == 'content':
            #     data.insert(3, value)           
        elif 'note_multipart' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
#                data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
            # if type(value) is list:
            #     for member in value:
            #         for subkey, subvalue in member.items():
            #             if subkey == 'content':
            #                 #print(subvalue)
            #                 data.insert(3, subvalue)
        elif 'note_bioghist' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
#                data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
        elif 'note_index' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'jsonmodel_type':
                note_label.insert(0, value)
#                data.insert(4, value)
        elif 'note_definedlist' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
 #               data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
        elif 'note_outline' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
  #              data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
        elif 'note_chronology' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
 #               data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
        elif 'note_bibliography' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'jsonmodel_type':
                note_label.insert(0, value)
 #               data.insert(4, value)
        elif 'note_index_item' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
 #               data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
        elif 'note_outline_level' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
 #               data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
        elif 'note_digital_object' in new_dict.values():
            if key == 'persistent_id':
                data.insert(1, value)
            if key == 'type':
                note_label.insert(0, value)
   #             data.insert(4, value)
            if key == 'label':
                note_label.insert(1, value)
                data.insert(3, value)
    data.insert(2, note_label)
    writer.writerow(data)

print('All Done! Check outfile for details.')