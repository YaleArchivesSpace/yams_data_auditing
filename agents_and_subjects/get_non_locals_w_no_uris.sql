SELECT CONCAT('/agents/people/', ap.id) as uri
	, np.sort_name
	, nai.authority_id
	, ev.value as source
	, np.is_display_name
from agent_person ap
left join name_person np on np.agent_person_id = ap.id
left join name_authority_id nai on nai.name_person_id = np.id
left join enumeration_value ev on ev.id = np.source_id
where nai.authority_id is null
and ev.value not like '%local%'
and np.is_display_name is not null
UNION ALL
SELECT CONCAT('/agents/corporate_entities/', ace.id) as uri
	, nce.sort_name
	, nai.authority_id
	, ev.value as source
	, nce.is_display_name
FROM agent_corporate_entity ace
left join name_corporate_entity nce on nce.agent_corporate_entity_id = ace.id
left join name_authority_id nai on nai.name_corporate_entity_id = nce.id
left join enumeration_value ev on ev.id = nce.source_id
where nai.authority_id is null
and ev.value not like '%local%'
and nce.is_display_name is not null
UNION ALL
SELECT CONCAT('/agents/families/', af.id) as uri
	, nf.sort_name
	, nai.authority_id
	, ev.value as source
	, nf.is_display_name
FROM agent_family af
left join name_family nf on nf.agent_family_id = af.id
left join name_authority_id nai on nai.name_family_id = nf.id
left join enumeration_value ev on ev.id = nf.source_id
where nai.authority_id is null
and ev.value not like '%local%'
and nf.is_display_name is not null
UNION ALL
SELECT CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, ev.value as source
	, NULL
FROM subject
left join enumeration_value ev on ev.id = subject.source_id
where subject.authority_id is null
and ev.value not like '%local%'