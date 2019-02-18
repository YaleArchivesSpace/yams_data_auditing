#/usr/bin/python3
#~/anaconda3/bin/python

import yaml
import os
import db_conn_ssh as dcs

'''This script loops through a directory and retrieves the paths of all files which end with .sql. It
then establishes an SSH connection to the ArchivesSpace database and runs all queries, saving the outputs
in a directory set in a YML config file.

Can set this script to run as a crontab job in mac OS

'''

config_file = yaml.load(open('config.yml', 'r', encoding='utf-8'))

input_dir = config_file['input_dir']
output_dir = config_file['output_dir']
#Add a list of sql files you don't want to run to your YML config file
exclusions = config_file['exclusions']

def get_sql_paths(input_dir, exclusions):
	sql_files = []
	for dirpath, dirnames, filenames in os.walk(input_dir):
		for filename in filenames:
			if filename.endswith('.sql') and filename not in exclusions:
				sql_files.append([dirpath, filename])
	return sql_files

if __name__ == "__main__":
	sql_list = get_sql_paths(input_dir, exclusions)
	as_db = dcs.DBConn(config_file)
	for qpath, qname in sql_list:
		q = qpath + '/' + qname
		open_query = open(q, 'r', encoding='utf-8')
		run_query = as_db.run_query(open_query.read())
		as_db.write_output(run_query, output_dir, qname)
	as_db.close_conn()

