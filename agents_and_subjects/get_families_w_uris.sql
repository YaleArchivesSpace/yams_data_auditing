select CONCAT('/agents/families/', af.id) as uri
	, nf.sort_name
	, nai.authority_id
	, ev.value as source
	, af.created_by
from agent_family af
left join name_family nf on nf.agent_family_id = af.id
left join name_authority_id nai on nai.name_family_id = nf.id
left join enumeration_value ev on ev.id = nf.source_id
where nai.authority_id like '%id.loc.gov/authorities/subjects/%'