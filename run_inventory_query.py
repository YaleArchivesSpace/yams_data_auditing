from utilities import dbssh
from utilities import utilities as u


h1, c1 = u.opencsv(input_csv="/Users/aliciadetelich/Desktop/inventory_identifiers_for_query.csv")
dbconn = dbssh.DBConn()

for row in c1:
	parent_id = row[0]
	resource_id = row[1]
	query_text = f'''SELECT CONCAT('/repositories/', archival_object.repo_id, '/archival_objects/', archival_object.id) as uri
		, CONCAT('/repositories/', archival_object.repo_id, '/archival_objects/', archival_object.parent_id) as parent_uri
		, CONCAT('/repositories/', archival_object.repo_id, '/resources/', archival_object.root_record_id) as resource_uri
		, archival_object.position
		, enumeration_value.value as ao_level
	FROM archival_object
	LEFT JOIN enumeration_value on enumeration_value.id = archival_object.level_id
	WHERE archival_object.parent_id = {parent_id}
	UNION ALL
	SELECT CONCAT('/repositories/', archival_object.repo_id, '/archival_objects/', archival_object.id) as uri
		, archival_object.parent_id as parent_uri
		, CONCAT('/repositories/', archival_object.repo_id, '/resources/', archival_object.root_record_id) as resource_uri
		, archival_object.position
		, enumeration_value.value as ao_level
	FROM archival_object
	LEFT JOIN enumeration_value on enumeration_value.id = archival_object.level_id
	WHERE archival_object.parent_id is null
	AND archival_object.root_record_id = {resource_id}
	AND archival_object.display_string not like "Inventory"'''
	run_query = dbconn.run_query(query_text)
	dbconn.write_output(run_query, '/Users/aliciadetelich/Desktop/inventory_reports', str(resource_id))

dbconn.close_conn()