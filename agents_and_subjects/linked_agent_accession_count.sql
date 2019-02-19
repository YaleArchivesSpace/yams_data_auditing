SELECT accession.title
    , count(accession.title) as count
    , 'person' as agent_type
FROM agent_person ap
#do inner joins and remove where clause
LEFT JOIN linked_agents_rlshp lar on lar.agent_person_id = ap.id
LEFT JOIN accession on accession.id = lar.accession_id
WHERE lar.accession_id is not null
GROUP BY accession.title
UNION ALL
SELECT accession.title
    , count(accession.title) as count
    , 'family' as agent_type
FROM agent_family af
LEFT JOIN linked_agents_rlshp lar on lar.agent_family_id = af.id
LEFT JOIN accession on accession.id = lar.accession_id
WHERE lar.accession_id is not null
GROUP BY accession.title
UNION ALL
SELECT accession.title
    , count(accession.title) as count
    , 'corp' as agent_type
FROM agent_corporate_entity ace
LEFT JOIN linked_agents_rlshp lar on lar.agent_corporate_entity_id = ace.id
LEFT JOIN accession on accession.id = lar.accession_id
WHERE lar.accession_id is not null
GROUP BY accession.title
UNION ALL
SELECT accession.title
    , count(accession.title) as count
    , 'software' as agent_type
FROM agent_software asw
LEFT JOIN linked_agents_rlshp lar on lar.agent_software_id = asw.id
LEFT JOIN accession on accession.id = lar.accession_id
WHERE lar.accession_id is not null
GROUP BY accession.title
ORDER BY count desc