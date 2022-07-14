#Retrieves all unstructured date records, except for those linked to deaccession, 
#agent_software, linked_agents_rlshp and name_software records

#archival objects
SELECT date.id
	, CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) AS uri
	, date.expression 
FROM archival_object ao
JOIN date on ao.id = date.archival_object_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#resources
SELECT date.id
	, CONCAT('/repositories/', r.repo_id, '/resources/', r.id) AS uri
	, date.expression 
FROM resource r
JOIN date on r.id = date.resource_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#accessions
SELECT date.id
	, CONCAT('/repositories/', acc.repo_id, '/accessions/', acc.id) AS uri
	, date.expression 
FROM accession acc
JOIN date on acc.id = date.accession_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#digital objects
SELECT date.id
	, CONCAT('/repositories/', do.repo_id, '/digital_objects/', do.id) AS uri
	, date.expression 
FROM digital_object do
JOIN date on do.id = date.digital_object_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#digital object components
SELECT date.id
	, CONCAT('/repositories/', doc.repo_id, '/digital_object_components/', doc.id) AS uri
	, date.expression
FROM digital_object_component doc
JOIN date on doc.id = date.digital_object_component_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#agents - people
SELECT date.id
	, CONCAT('/agents/people/', ap.id) AS uri
	, date.expression
FROM agent_person ap
JOIN date on ap.id = date.agent_person_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#agents - corporate entities
SELECT date.id
	, CONCAT('/agents/corporate_entities/', ace.id) AS uri
	, date.expression
FROM agent_corporate_entity ace
JOIN date on ace.id = date.agent_corporate_entity_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#agents - families
SELECT date.id
	, CONCAT('/agents/families/', af.id) AS uri
	, date.expression
FROM agent_family af
JOIN date on af.id = date.agent_family_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#names - people
SELECT date.id
	, CONCAT('/agents/people/', np.agent_person_id) AS uri
	, date.expression
FROM name_person np
JOIN date on np.id = date.name_person_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#names - corporate entities
SELECT date.id
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) AS uri
	, date.expression
FROM name_corporate_entity nce
JOIN date on nce.id = date.name_corporate_entity_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#names - families
SELECT date.id
	, CONCAT('/agents/families/', nf.agent_family_id) AS uri
	, date.expression
FROM name_family nf
JOIN date on nf.id = date.name_family_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
UNION ALL
#events
SELECT date.id
	, CONCAT('/repositories/', e.repo_id, '/events/', e.id) AS uri
	, date.expression
FROM event e
JOIN date on e.id = date.event_id
WHERE date.expression IS NOT NULL
AND date.begin IS NULL
AND date.end IS NULL
#LIMIT 10000