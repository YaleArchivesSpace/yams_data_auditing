SELECT ap.id as agent_id
	, CONCAT('/agents/people/', ap.id) as agent_uri
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as record_uri
	, replace(replace(replace(replace(replace(replace(resource.title, '<emph render="bold">', ''), '</emph>', ''), '<persname>', ''), '</persname>', ''), '<title render="italic">', ''), '</title>', '') AS title
	, NULL as parent_uri
	, NULL as parent_title
    , resource.repo_id
    , ev1.value as role
    , ev2.value as relator
    , term.term as term
    , ev3.value as tem_type
    , resource.user_mtime
    , resource.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN resource on resource.id = lar.resource_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , ao.user_mtime
    , ao.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , accession.user_mtime
    , accession.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_person ap on lar.agent_person_id = ap.id
JOIN accession on accession.id = lar.accession_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , resource.user_mtime
    , resource.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN resource on resource.id = lar.resource_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , ao.user_mtime
    , ao.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , accession.user_mtime
    , accession.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_corporate_entity ace on lar.agent_corporate_entity_id = ace.id
JOIN accession on accession.id = lar.accession_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , resource.user_mtime
    , resource.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN resource on resource.id = lar.resource_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , ao.user_mtime
    , ao.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id
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
    , term.term as term
    , ev3.value as tem_type
    , accession.user_mtime
    , accession.last_modified_by
FROM linked_agents_rlshp lar
JOIN agent_family af on lar.agent_family_id = af.id
JOIN accession on accession.id = lar.accession_id
LEFT JOIN enumeration_value ev1 on ev1.id = lar.role_id
LEFT JOIN enumeration_value ev2 on ev2.id = lar.relator_id
LEFT JOIN linked_agent_term lat on lat.linked_agents_rlshp_id = lar.id
LEFT JOIN term on lat.term_id = term.id
LEFT JOIN enumeration_value ev3 on ev3.id = term.term_type_id