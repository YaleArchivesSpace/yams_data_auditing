SELECT CONCAT('/agents/people/', ap.id) as uri
	, np.is_display_name
	, np.sort_name
	, np.qualifier
	, np.dates
	, nai.authority_id
	, ev.value as source
	, date.begin
	, date.end
	, ap.create_time
	, ap.created_by
from agent_person ap
left join name_person np on np.agent_person_id = ap.id
left join name_authority_id nai on nai.name_person_id = np.id
left join enumeration_value ev on ev.id = np.source_id
left join date on date.agent_person_id = ap.id
where np.qualifier is not null
and nai.authority_id is null
and np.is_display_name is not null
and np.qualifier not like '%$t%'
#where nai.authority_id like '%dts%'
UNION ALL
SELECT CONCAT('/agents/corporate_entities/', ace.id) as uri
	, nce.is_display_name
	, nce.sort_name
	, nce.qualifier
	, nce.dates
	, nai.authority_id
	, ev.value as source
	, date.begin
	, date.end
	, ace.create_time
	, ace.created_by
FROM agent_corporate_entity ace
left join name_corporate_entity nce on nce.agent_corporate_entity_id = ace.id
left join name_authority_id nai on nai.name_corporate_entity_id = nce.id
left join enumeration_value ev on ev.id = nce.source_id
left join date on date.agent_corporate_entity_id = ace.id
where nce.qualifier is not null
and nai.authority_id is null
and nce.is_display_name is not null
and nce.qualifier not like '%$t%'
#where nai.authority_id like '%dts%'
UNION ALL
SELECT CONCAT('/agents/families/', af.id) as uri
	, nf.is_display_name
	, nf.sort_name
	, nf.qualifier
	, nf.dates
	, nai.authority_id
	, ev.value as source
	, date.begin
	, date.end
	, af.create_time
	, af.created_by
FROM agent_family af
left join name_family nf on nf.agent_family_id = af.id
left join name_authority_id nai on nai.name_corporate_entity_id = nf.id
left join enumeration_value ev on ev.id = nf.source_id
left join date on date.agent_family_id = af.id
where nf.qualifier is not null
and nai.authority_id is null
and nf.is_display_name is not null
and nf.qualifier not like '%$t%'
#where nai.authority_id like '%dts%'
/* UNION ALL
SELECT CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, ev.value as source
FROM subject
left join enumeration_value ev on ev.id = subject.source_id
where subject.authority_id like '%dts%' */