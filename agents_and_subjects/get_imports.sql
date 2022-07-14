SELECT CONCAT('/agents/people/', ap.id) as uri
	, np.sort_name
	, np.dates
	, nai.authority_id
from agent_person ap
left join name_person np on np.agent_person_id = ap.id
join name_authority_id nai on nai.name_person_id = np.id
where ap.created_by like 'amd243'
and ap.create_time like '2018-11%'
UNION ALL
SELECT CONCAT('/agents/corporate_entities/', ace.id) as uri
	, nce.sort_name
	, nce.dates
	, nai.authority_id
FROM agent_corporate_entity ace
left join name_corporate_entity nce on nce.agent_corporate_entity_id = ace.id
join name_authority_id nai on nai.name_corporate_entity_id = nce.id
where ace.created_by like 'amd243'
and ace.create_time like '2018-11%'