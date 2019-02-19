SELECT ao.title
    , count(ao.title) as count
    , 'person' as agent_type
FROM agent_person ap
#do inner joins and remove where clause
LEFT JOIN linked_agents_rlshp lar on lar.agent_person_id = ap.id
LEFT JOIN archival_object ao on ao.id = lar.archival_object_id
WHERE lar.archival_object_id is not null
GROUP BY ao.title
UNION ALL
SELECT ao.title
    , count(ao.title) as count
    , 'family' as agent_type
FROM agent_family af
LEFT JOIN linked_agents_rlshp lar on lar.agent_family_id = af.id
LEFT JOIN archival_object ao on ao.id = lar.archival_object_id
WHERE lar.archival_object_id is not null
GROUP BY ao.title
UNION ALL
SELECT ao.title
    , count(ao.title) as count
    , 'corp' as agent_type
FROM agent_corporate_entity ace
LEFT JOIN linked_agents_rlshp lar on lar.agent_corporate_entity_id = ace.id
LEFT JOIN archival_object ao on ao.id = lar.archival_object_id
WHERE lar.archival_object_id is not null
GROUP BY ao.title
UNION ALL
SELECT ao.title
    , count(ao.title) as count
    , 'software' as agent_type
FROM agent_software asw
LEFT JOIN linked_agents_rlshp lar on lar.agent_software_id = asw.id
LEFT JOIN archival_object ao on ao.id = lar.archival_object_id
WHERE lar.archival_object_id is not null
GROUP BY ao.title
ORDER BY count desc