#/usr/bin/python3
#~/anaconda3/bin/python

import requests,json,csv, traceback

def login():
    api_url = input('Please enter the ArchivesSpace API URL: ')
    username = input('Please enter your username: ')
    password = input('Please enter your password: ')
    auth = requests.post(api_url+'/users/'+username+'/login?password='+password).json()
    #if session object is returned then login was successful; if not it failed.
    if 'session' in auth:
        session = auth["session"]
        headers = {'X-ArchivesSpace-Session':session, 'Content_Type': 'application/json'}
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

def opencsvout():
    output_csv = input('Please enter path to output CSV: ')
    fileob = open(output_csv, 'a', encoding='utf-8', newline='')
    csvout = csv.writer(fileob)
    return fileob, csvout

api_url, headers = login()
csvfile = opencsv()
fileobject, csvoutfile = opencsvout()

def get_subjects(csvfile, csvoutfile, api_url, headers)
    csvoutfile.writerow(['uri', 'title', 'authority_id', 'source', 'is_linked_to_published_record', 'terms', 'used_within_repositories', 'created_by'])
    for row in csvfile:
        terms = []
        uri = row[0]
        subject_json = requests.get(api_url + uri, headers=headers).json()
        if 'title' in subject_json:
            row.append(subject_json['title'])
        else:
            row.append('NO_VALUE')
        if 'authority_id' in subject_json:
            row.append(subject_json['authority_id'])
        else:
            row.append('NO_VALUE')
        if 'source' in subject_json:
            row.append(subject_json['source'])
        else:
            row.append('NO_VALUE')
        if 'is_linked_to_published_record' in subject_json:
            row.append(subject_json['is_linked_to_published_record'])
        else:
            row.append('NO_VALUE')
        if 'terms' in subject_json:
            for term in subject_json['terms']:
                terms.append([term['term'], term['term_type']])
            row.append(terms)
        else:
            row.append('NO_VALUE')
        if 'used_within_repositories' in subject_json:
            row.append(subject_json['used_within_repositories'])
        else:
            row.append('NO_VALUE')
        if 'created_by' in subject_json:
            row.append(subject_json['created_by'])
        else:
            row.append('NO_VALUE')
        csvoutfile.writerow(row)
    fileobject.close()

def get_agents(csvfile, csvoutfile, api_url, headers):
    headers = ['agent_type', 'create_time','created_by', 'authority_id', 'sort_name', 'primary_name', 'rest_of_name', 'dates', 'source', 'qualifier', 'is_linked_to_published_record', 'linked_agent_roles', 'title', 'is_linked_to_record', 'used_within_repositories', 'uri']
    csvoutfile.writerow(headers)
    for i, row in enumerate(csvfile, 1):
        data = []
        uri = row[0]
        print('working on row ' + str(i) + ': ' + str(uri))
        try:
            agent_json = requests.get(api_url + uri, headers=headers).json()
            if 'agent_type' in agent_json:
                data.append(agent_json['agent_type'])
            else:
                data.append('no_agent_type')
            if 'create_time' in agent_json:
                data.append(agent_json['create_time'])
            else:
                data.append('no_create_time')
            if 'created_by' in agent_json:
                data.append(agent_json['created_by'])
            else:
                data.append('no_created_by')
            if 'display_name'in agent_json:
                if 'authority_id' in agent_json['display_name']:
                    data.append(agent_json['display_name']['authority_id'])
                else:
                    data.append('no_authority_id')
                if 'sort_name' in agent_json['display_name']:
                    data.append(agent_json['display_name']['sort_name'])
                    print(agent_json['display_name']['sort_name'])
                else:
                    data.append('no_sort_name')
                if 'primary_name' in agent_json['display_name']:
                    data.append(agent_json['display_name']['primary_name'])
                else:
                    data.append('no_primary_name')
                if 'corporate_entities' in uri:
                    if 'subordinate_name_1' in agent_json['display_name']:
                        data.append(agent_json['display_name']['subordinate_name_1'])
                    else:
                        data.append('no_subordinate_name')
                if 'people' in uri:
                    if 'rest_of_name' in agent_json['display_name']:
                        data.append(agent_json['display_name']['rest_of_name'])
                    else:
                        data.append('no_rest_of_name')
                if 'families' in uri:
                    data.append('family_name')
                if 'dates' in agent_json['display_name']:
                    data.append(agent_json['display_name']['dates'])
                else:
                    data.append('no_dates')
                if 'source' in agent_json['display_name']:
                    data.append(agent_json['display_name']['source'])
                else:
                    data.append('no_source')
                if 'qualifier' in agent_json['display_name']:
                    data.append(agent_json['display_name']['qualifier'])
                else:
                    data.append('no_qualifier')
            else:
                data.append('no_display_name_')
            if 'is_linked_to_published_record' in agent_json:
                data.append(agent_json['is_linked_to_published_record'])
            else:
                data.append('no_is_linked_to_pub_rec')
            if 'linked_agent_roles' in agent_json:
                data.append(agent_json['linked_agent_roles'])
            else:
                data.append('no_linked_agent_roles')
            if 'title' in agent_json:
                data.append(agent_json['title'])
            else:
                data.append('no_title')
            if 'is_linked_to_record' in agent_json:
                data.append(agent_json['is_linked_to_record'])
            else:
                data.append('no_link_to_record')
            if 'used_within_repositories' in agent_json:
                data.append(agent_json['used_within_repositories'])
            else:
                data.append('not_used_within_repos')
            if 'uri' in agent_json:
                data.append(agent_json['uri'])
            else:
                data.append('no_uri')
            csvoutfile.writerow(data)
        except Exception as exc:
            print(uri)
            print(traceback.format_exc())
            csvoutfile.writerow([uri])
    fileobject.close()