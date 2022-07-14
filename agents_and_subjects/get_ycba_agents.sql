SELECT DISTINCT np.agent_person_id as agent_id
	, np.sort_name as agent_name
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
    , resource.repo_id
FROM linked_agents_rlshp lar
JOIN name_person np on lar.agent_person_id = np.agent_person_id
JOIN resource on resource.id = lar.resource_id
where np.is_display_name is not null
and resource.repo_id = 2
UNION ALL
SELECT DISTINCT np.agent_person_id as agent_id
	, np.sort_name as agent_name
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
    , ao.repo_id
FROM linked_agents_rlshp lar
JOIN name_person np on lar.agent_person_id = np.agent_person_id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
where np.is_display_name is not null
AND resource.repo_id = 2
UNION ALL
SELECT DISTINCT np.agent_person_id as agent_id
	, np.sort_name as agent_name
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
    , accession.repo_id
FROM linked_agents_rlshp lar
JOIN name_person np on lar.agent_person_id = np.agent_person_id
JOIN accession on accession.id = lar.accession_id
where np.is_display_name is not null
and accession.repo_id = 2
UNION ALL
SELECT DISTINCT np.agent_person_id as agent_id
	, np.sort_name as agent_name
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
    , dobj.repo_id
FROM linked_agents_rlshp lar
JOIN name_person np on lar.agent_person_id = np.agent_person_id
JOIN digital_object dobj on dobj.id = lar.digital_object_id
where np.is_display_name is not null
and dobj.repo_id = 2
UNION ALL
SELECT DISTINCT np.agent_person_id as agent_id
	, np.sort_name as agent_name
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
    , doc.repo_id
FROM linked_agents_rlshp lar
JOIN name_person np on lar.agent_person_id = np.agent_person_id
JOIN digital_object_component doc on doc.id = lar.digital_object_component_id
JOIN digital_object dobj on dobj.id = doc.root_record_id
where np.is_display_name is not null
and doc.repo_id = 2
UNION ALL
SELECT DISTINCT np.agent_person_id as agent_id
	, np.sort_name as agent_name
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
    , event.repo_id
FROM linked_agents_rlshp lar
JOIN name_person np on lar.agent_person_id = np.agent_person_id
JOIN event on event.id = lar.event_id
where np.is_display_name is not null
and event.repo_id = 2
UNION ALL
SELECT DISTINCT nce.agent_corporate_entity_id as agent_id 
	, nce.sort_name as agent_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
    , resource.repo_id
FROM linked_agents_rlshp lar
JOIN name_corporate_entity nce on lar.agent_corporate_entity_id = nce.agent_corporate_entity_id
JOIN resource on resource.id = lar.resource_id
where nce.is_display_name is not null
and resource.repo_id = 2
UNION ALL
SELECT DISTINCT nce.agent_corporate_entity_id as agent_id 
	, nce.sort_name as agent_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
    , ao.repo_id
FROM linked_agents_rlshp lar
JOIN name_corporate_entity nce on lar.agent_corporate_entity_id = nce.agent_corporate_entity_id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
where nce.is_display_name is not null
and resource.repo_id = 2
UNION ALL
SELECT DISTINCT nce.agent_corporate_entity_id as agent_id 
	, nce.sort_name as agent_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
    , accession.repo_id
FROM linked_agents_rlshp lar
JOIN name_corporate_entity nce on lar.agent_corporate_entity_id = nce.agent_corporate_entity_id
JOIN accession on accession.id = lar.accession_id
where nce.is_display_name is not null
and accession.repo_id = 2
UNION ALL
SELECT DISTINCT nce.agent_corporate_entity_id as agent_id 
	, nce.sort_name as agent_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
    , dobj.repo_id
FROM linked_agents_rlshp lar
JOIN name_corporate_entity nce on lar.agent_corporate_entity_id = nce.agent_corporate_entity_id
JOIN digital_object dobj on dobj.id = lar.digital_object_id
where nce.is_display_name is not null
and dobj.repo_id = 2
UNION ALL
SELECT DISTINCT nce.agent_corporate_entity_id as agent_id 
	, nce.sort_name as agent_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
    , doc.repo_id
FROM linked_agents_rlshp lar
JOIN name_corporate_entity nce on lar.agent_corporate_entity_id = nce.agent_corporate_entity_id
JOIN digital_object_component doc on doc.id = lar.digital_object_component_id
JOIN digital_object dobj on dobj.id = doc.root_record_id
where nce.is_display_name is not null
and doc.repo_id = 2
UNION ALL
SELECT DISTINCT nce.agent_corporate_entity_id as agent_id 
	, nce.sort_name as agent_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
    , event.repo_id
FROM linked_agents_rlshp lar
JOIN name_corporate_entity nce on lar.agent_corporate_entity_id = nce.agent_corporate_entity_id
JOIN event on event.id = lar.event_id
where nce.is_display_name is not null
and event.repo_id = 2
UNION ALL
SELECT DISTINCT nf.agent_family_id as agent_id 
	, nf.family_name as agent_name
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
    , resource.repo_id
FROM linked_agents_rlshp lar
JOIN name_family nf on lar.agent_family_id = nf.agent_family_id
JOIN resource on resource.id = lar.resource_id
where nf.is_display_name is not null
and resource.repo_id = 2
UNION ALL
SELECT DISTINCT nf.agent_family_id as agent_id 
	, nf.family_name as agent_name
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
    , ao.repo_id
FROM linked_agents_rlshp lar
JOIN name_family nf on lar.agent_family_id = nf.agent_family_id
JOIN archival_object ao on ao.id = lar.archival_object_id
JOIN resource on resource.id = ao.root_record_id
where nf.is_display_name is not null
and resource.repo_id = 2
UNION ALL
SELECT DISTINCT nf.agent_family_id as agent_id 
	, nf.family_name as agent_name
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
    , accession.repo_id
FROM linked_agents_rlshp lar
JOIN name_family nf on lar.agent_family_id = nf.agent_family_id
JOIN accession on accession.id = lar.accession_id
where nf.is_display_name is not null
and accession.repo_id = 2
UNION ALL
SELECT DISTINCT nf.agent_family_id as agent_id 
	, nf.family_name as agent_name
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
    , dobj.repo_id
FROM linked_agents_rlshp lar
JOIN name_family nf on lar.agent_family_id = nf.agent_family_id
JOIN digital_object dobj on dobj.id = lar.digital_object_id
where nf.is_display_name is not null
and dobj.repo_id = 2
UNION ALL
SELECT DISTINCT nf.agent_family_id as agent_id 
	, nf.family_name as agent_name
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
    , doc.repo_id
FROM linked_agents_rlshp lar
JOIN name_family nf on lar.agent_family_id = nf.agent_family_id
JOIN digital_object_component doc on doc.id = lar.digital_object_component_id
JOIN digital_object dobj on dobj.id = doc.root_record_id
where nf.is_display_name is not null
and doc.repo_id = 2
UNION ALL
SELECT DISTINCT nf.agent_family_id as agent_id 
	, nf.family_name as agent_name
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
    , event.repo_id
FROM linked_agents_rlshp lar
JOIN name_family nf on lar.agent_family_id = nf.agent_family_id
JOIN event on event.id = lar.event_id
where nf.is_display_name is not null
and event.repo_id = 2