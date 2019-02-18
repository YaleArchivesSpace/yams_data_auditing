SELECT CONCAT('/repositories/', do.repo_id, '/digital_objects/', do.id) AS uri
	, do.publish
	, do.digital_object_id
	, fv.file_uri
    , do.title as digital_object_title
    , ao.title as ao_title
    , resource.title as resource_title
FROM digital_object do
LEFT JOIN file_version fv on fv.digital_object_id = do.id
LEFT JOIN instance_do_link_rlshp idlr on idlr.digital_object_id = do.id
LEFT JOIN instance on instance.id = idlr.instance_id
LEFT JOIN archival_object ao on ao.id = instance.archival_object_id
LEFT JOIN resource on resource.id = ao.root_record_id
#WHERE fv.file_uri is null #gets all digital objects without file URIs
#WHERE (do.digital_object_id like '%digcoll%' and fv.file_uri is null) #gets all digital objects without file uris and with a digital library reference in the digital object ID field
#WHERE (do.digital_object_id like '%http%' and do.digital_object_id not like '%kaltura%') #gets all dos with a URL in the digital object ID field
#WHERE fv.file_uri is not null #gets all digital objects with file uris