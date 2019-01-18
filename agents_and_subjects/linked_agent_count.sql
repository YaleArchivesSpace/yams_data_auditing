SELECT resource.title
    , count(resource.title) as count
    , 'person' as agent_type
FROM agent_person ap
LEFT JOIN linked_agents_rlshp lar on lar.agent_person_id = ap.id
LEFT JOIN resource on resource.id = lar.resource_id
LEFT JOIN user_defined ud on ud.resource_id = resource.id
WHERE lar.resource_id is not null
AND ud.string_2 is not null
GROUP BY resource.title
UNION ALL
SELECT resource.title
    , count(resource.title) as count
    , 'family' as agent_type
FROM agent_family af
LEFT JOIN linked_agents_rlshp lar on lar.agent_family_id = af.id
LEFT JOIN resource on resource.id = lar.resource_id
LEFT JOIN user_defined ud on ud.resource_id = resource.id
WHERE lar.resource_id is not null
AND ud.string_2 is not null
GROUP BY resource.title
UNION ALL
SELECT resource.title
    , count(resource.title) as count
    , 'corp' as agent_type
FROM agent_corporate_entity ace
LEFT JOIN linked_agents_rlshp lar on lar.agent_corporate_entity_id = ace.id
LEFT JOIN resource on resource.id = lar.resource_id
LEFT JOIN user_defined ud on ud.resource_id = resource.id
WHERE lar.resource_id is not null
AND ud.string_2 is not null
GROUP BY resource.title
UNION ALL
SELECT resource.title
    , count(resource.title) as count
    , 'software' as agent_type
FROM agent_software asw
LEFT JOIN linked_agents_rlshp lar on lar.agent_software_id = asw.id
LEFT JOIN resource on resource.id = lar.resource_id
LEFT JOIN user_defined ud on ud.resource_id = resource.id
WHERE lar.resource_id is not null
AND ud.string_2 is not null
GROUP BY resource.title
ORDER BY count desc