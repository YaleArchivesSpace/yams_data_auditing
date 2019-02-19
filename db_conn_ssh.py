#Connect to ArchivesSpace database through SSH Tunnel

import paramiko
import pymysql
import sshtunnel
import yaml
import csv
import pandas as pd

#add error handling, logging
#don't forget to close the connection
class DBConn():
	#maybe add the config file as an argument
	def __init__(self, config_file=None):
		self.config_file = self._get_config(config_file)
		self.path_to_key = self.config_file['path_to_key']
		self.pkey = paramiko.RSAKey.from_private_key_file(self.path_to_key)
		self.sql_hostname = self.config_file['sql_hostname']
		self.sql_username = self.config_file['sql_username']
		self.sql_password = self.config_file['sql_password']
		self.sql_database = self.config_file['sql_database']
		self.sql_port = self.config_file['sql_port']
		self.ssh_host = self.config_file['ssh_host']
		self.ssh_user = self.config_file['ssh_user']
		self.ssh_port = self.config_file['ssh_port']
		self.conn, self.tunnel = self._start_conn()

	#looks for user-provided config file. If not present looks in cwd
	def _get_config(self, cfg):
		if cfg != None:
			return cf
		else:
			cfg = yaml.load(open('config.yml', 'r', encoding='utf-8'))
			return cfg

	def _start_conn(self):
		tunnel = sshtunnel.SSHTunnelForwarder((self.ssh_host, self.ssh_port), ssh_username=self.ssh_user, ssh_pkey=self.pkey, remote_bind_address=(self.sql_hostname, self.sql_port))
		tunnel.start()
		conn = pymysql.connect(host='127.0.0.1', user=self.sql_username, passwd=self.sql_password, db=self.sql_database, port=tunnel.local_bind_port)
		return conn, tunnel

	def run_query(self, query):
		data = pd.read_sql_query(query, self.conn)
		return(data)

	def close_conn(self):
		'''close both db connection and ssh server. Must do this before quitting Python.
		Need to find a way to do this even if user does not call method.
		'''
		self.conn.close()
		self.tunnel.stop()

	#This works well, but not if the query data requires additional processing
	def write_output(self, query_data, output_dir, filename):
		column_list = list(query_data.columns)
		datalist = query_data.values.tolist()
		newfile = open(output_dir + '/' + filename + '_results.csv', 'a', encoding='utf-8', newline='')
		writer = csv.writer(newfile)
		writer.writerow(column_list)
		writer.writerows(datalist)
		newfile.close()

	#Should do the cgi thing to process HTML tags and remove
