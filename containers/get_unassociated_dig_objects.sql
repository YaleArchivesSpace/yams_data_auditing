#This query is used to locate digital objects which are not linked to archival objects
SELECT CONCAT('/repositories/', do.repo_id, '/digital_objects/', do.id) AS uri
	, do.publish
	, do.digital_object_id
    , do.title as digital_object_title
    , ao.title as ao_title
    , resource.title as resource_title
FROM digital_object do
LEFT JOIN instance_do_link_rlshp idlr on idlr.digital_object_id = do.id
LEFT JOIN instance on instance.id = idlr.instance_id
LEFT JOIN archival_object ao on ao.id = instance.archival_object_id
LEFT JOIN resource on resource.id = ao.root_record_id
WHERE idlr.instance_id is null