SELECT ap.id as agent_id
	, CONCAT('/agents/people/', ap.id) as agent_uri
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as record_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , resource.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN resource on resource.id = lar.resource_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ap.id as agent_id
	, CONCAT('/agents/people/', ap.id) as agent_uri
	, CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) as record_uri
	, replace(replace(replace(replace(replace(replace(ao.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as parent_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS parent_title
    , ao.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ap.id as agent_id 
	, CONCAT('/agents/people/', ap.id) as agent_uri
	, CONCAT('/repositories/', accession.repo_id, '/accessions/', accession.id) as record_uri
	, replace(replace(replace(replace(replace(replace(accession.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , accession.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN accession on accession.id = lar.accession_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ap.id as agent_id
	, CONCAT('/agents/people/', ap.id) as agent_uri
	, CONCAT('/repositories/', dobj.repo_id, '/digital_objects/', dobj.id) as record_uri
	, dobj.title as title
	, NULL as parent_uri
	, NULL as parent_title
    , dobj.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN digital_object dobj on dobj.id = lar.digital_object_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
WHERE ev1.value = 'subject'
UNION ALL
SELECT ap.id as agent_id
	, CONCAT('/agents/people/', ap.id) as agent_person_uri
	, CONCAT('/repositories/', doc.repo_id, '/digital_object_components/', doc.id) as record_uri
	, doc.title as title
	, CONCAT('/repositories/', dobj.repo_id, '/digital_objects/', dobj.id) as parent_uri
	, dobj.title as parent_title
    , doc.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN digital_object_component doc on doc.id = lar.digital_object_component_id
JOIN digital_object dobj on dobj.id = doc.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
WHERE ev1.value = 'subject'
UNION ALL
SELECT ap.id as agent_id
	, CONCAT('/agents/people/', ap.id) as agent_uri
	, CONCAT('/repositories/', event.repo_id, '/events/', event.id) as record_uri
	, 'EVENT' as title
	, NULL as parent_uri
	, NULL as parent_title
    , event.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN event on event.id = lar.event_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ace.id as agent_id 
	, CONCAT('/agents/corporate_entities/', ace.id) as agent_uri
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as record_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , resource.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN resource on resource.id = lar.resource_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
WHERE ev1.value = 'subject'
UNION ALL
SELECT ace.id as agent_id 
	, CONCAT('/agents/corporate_entities/', ace.id) as agent_uri
	, CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) as record_uri
	, replace(replace(replace(replace(replace(replace(ao.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as parent_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS parent_title
    , ao.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ace.id as agent_id 
	, CONCAT('/agents/corporate_entities/', ace.id) as agent_uri
	, CONCAT('/repositories/', accession.repo_id, '/accessions/', accession.id) as record_uri
	, replace(replace(replace(replace(replace(replace(accession.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , accession.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN accession on accession.id = lar.accession_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ace.id as agent_id 
	, CONCAT('/agents/corporate_entities/', ace.id) as agent_uri
	, CONCAT('/repositories/', dobj.repo_id, '/digital_objects/', dobj.id) as record_uri
	, dobj.title as title
	, NULL as parent_uri
	, NULL as parent_title
    , dobj.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN digital_object dobj on dobj.id = lar.digital_object_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ace.id as agent_id 
	, CONCAT('/agents/corporate_entities/', ace.id) as agent_uri
	, CONCAT('/repositories/', doc.repo_id, '/digital_object_components/', doc.id) as record_uri
	, doc.title as title
	, CONCAT('/repositories/', dobj.repo_id, '/digital_objects/', dobj.id) as parent_uri
	, dobj.title as parent_title
    , doc.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN digital_object_component doc on doc.id = lar.digital_object_component_id
JOIN digital_object dobj on dobj.id = doc.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT ace.id as agent_id 
	, CONCAT('/agents/corporate_entities/', ace.id) as agent_uri
	, CONCAT('/repositories/', event.repo_id, '/events/', event.id) as record_uri
	, 'EVENT' as title
	, NULL as parent_uri
	, NULL as parent_title
    , event.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN event on event.id = lar.event_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT af.id as agent_id 
	, CONCAT('/agents/families/', af.id) as agent_uri
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as record_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , resource.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN resource on resource.id = lar.resource_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT af.id as agent_id 
	, CONCAT('/agents/families/', af.id) as agent_uri
	, CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) as record_uri
	, replace(replace(replace(replace(replace(replace(ao.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as parent_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS parent_title
    , ao.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT af.id as agent_id 
	, CONCAT('/agents/families/', af.id) as agent_uri
	, CONCAT('/repositories/', accession.repo_id, '/accessions/', accession.id) as record_uri
	, replace(replace(replace(replace(replace(replace(accession.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , accession.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN accession on accession.id = lar.accession_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT af.id as agent_id
	, CONCAT('/agents/families/', af.id) as agent_uri
	, CONCAT('/repositories/', dobj.repo_id, '/digital_objects/', dobj.id) as record_uri
	, dobj.title as title
	, NULL as parent_uri
	, NULL as parent_title
    , dobj.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN digital_object dobj on dobj.id = lar.digital_object_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT af.id as agent_id 
	, CONCAT('/agents/families/', af.id) as agent_uri
	, CONCAT('/repositories/', doc.repo_id, '/digital_object_components/', doc.id) as record_uri
	, doc.title as title
	, CONCAT('/repositories/', dobj.repo_id, '/digital_objects/', dobj.id) as parent_uri
	, dobj.title as parent_title
    , doc.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN digital_object_component doc on doc.id = lar.digital_object_component_id
JOIN digital_object dobj on dobj.id = doc.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
UNION ALL
SELECT af.id as agent_id 
	, CONCAT('/agents/families/', af.id) as agent_uri
	, CONCAT('/repositories/', event.repo_id, '/events/', event.id) as record_uri
	, 'EVENT' as title
	, NULL as parent_uri
	, NULL as parent_title
    , event.repo_id
    , ev1.value as role
    , ev2.value as relator
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN event on event.id = lar.event_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id