#/usr/bin/python3
#~/anaconda3/bin/python


'''
This script runs the two .SQL file which perform the date database updates. Step by step:

1.) 

To-do: modify update.dates.sql to replace empty strings w NULL vals

'''

from utilities import dbssh

query_files = ['update_dates.sql', 'create_datetemp_table.sql']

as_db = dbssh.DBConn(config_file=config_file)