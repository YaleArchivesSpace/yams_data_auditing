/* select ap.id as agent_id
	, CONCAT('https://archivesspace.library.yale.edu/agents/agent_person/', ap.id) as uri
	, ap.created_by
	, ap.create_time
	, nai.authority_id as authority_id
	, np.sort_name
	, np.qualifier
	, ev.value as source
from agent_person ap
left join name_person np on np.agent_person_id = ap.id
left join name_authority_id nai on nai.name_person_id = np.id
left join enumeration_value ev on ev.id = np.source_id
ORDER BY agent_id 
UNION ALL 
select af.id as agent_id
	, CONCAT('https://archivesspace.library.yale.edu/agents/agent_family/', af.id) as uri
	, af.created_by
	, af.create_time
	, nai.authority_id as authority_id
	, nf.sort_name
	, nf.qualifier
	, ev.value as source
from agent_family af
left join name_family nf on nf.agent_family_id = af.id
left join name_authority_id nai on nai.name_family_id = nf.id
left join enumeration_value ev on ev.id = nf.source_id 
UNION ALL*/
select  ace.id as agent_id
	, CONCAT('https://archivesspace.library.yale.edu/agents/agent_corporate_entity/', ace.id) as uri
	, ace.created_by
	, ace.create_time
	, nai.authority_id as authority_id
	, nce.sort_name
	, nce.qualifier
	, ev.value as source
from agent_corporate_entity ace
left join name_corporate_entity nce on nce.agent_corporate_entity_id = ace.id
left join name_authority_id nai on nai.name_corporate_entity_id = nce.id
left join enumeration_value ev on ev.id = nce.source_id 