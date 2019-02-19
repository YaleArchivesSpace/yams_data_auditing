/* select * from name_person
where rest_of_name is null */

BETTER WAY TO GET NAMES


select CAST(ap.id as unsigned) as id
	, CONCAT('/agents/people/', np.agent_person_id) as agent_uri
	, np.sort_name as sort_name
	, np.primary_name as primary_name
	, np.rest_of_name as rest_of_name
	, NULL as rest_of_name_2
	, np.dates as dates
	, np.qualifier as qualifier
	, np.number as number
	, np.prefix as prefix
	, np.title as title
	, np.suffix as suffix
	, np.fuller_form as fuller_form
	, nai.authority_id
	, ev.value as source
	, ev2.value as rules
	, ap.create_time
	, ap.user_mtime
	, ap.created_by
	, ap.last_modified_by
	, ap.publish
	, user.username
from name_person np
LEFT JOIN enumeration_value ev on ev.id = np.source_id
LEFT JOIN enumeration_value ev2 on ev2.id = np.rules_id
LEFT JOIN name_authority_id nai on nai.name_person_id = np.id
JOIN agent_person ap on ap.id = np.agent_person_id
LEFT JOIN user on user.agent_record_id = ap.id
where np.is_display_name is not null
UNION ALL
SELECT CAST(ace.id as unsigned) as id
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as agent_uri
	, nce.sort_name as sort_name
	, nce.primary_name as primary_name
	, nce.subordinate_name_1 as rest_of_name
	, nce.subordinate_name_2 as rest_of_name_2
	, nce.dates as dates
	, nce.qualifier as qualifier
	, nce.number as number
	, NULL as prefix
	, NULL as title
	, NULL as suffix
	, NULL as fuller_form
	, nai.authority_id
	, ev.value as source
	, ev2.value as rules
	, ace.create_time
	, ace.user_mtime
	, ace.created_by
	, ace.last_modified_by
	, ace.publish
	, NULL as username
from name_corporate_entity nce
LEFT JOIN enumeration_value ev on ev.id = nce.source_id
LEFT JOIN enumeration_value ev2 on ev2.id = nce.rules_id
LEFT JOIN name_authority_id nai on nai.name_corporate_entity_id = nce.id
JOIN agent_corporate_entity ace on ace.id = nce.agent_corporate_entity_id
where nce.is_display_name is not null
UNION ALL
SELECT CAST(af.id as unsigned) as id
	, CONCAT('/agents/families/', nf.agent_family_id) as agent_uri
	, nf.sort_name as sort_name
	, nf.family_name as primary_name
	, NULL as rest_of_name
	, NULL as rest_of_name_2
	, nf.dates as dates
	, nf.qualifier as qualifier
	, NULL as number
	, nf.prefix as prefix
	, NULL as title
	, NULL as suffix
	, NULL as fuller_form
	, nai.authority_id
	, ev.value as source
	, ev2.value as rules
	, af.create_time
	, af.user_mtime
	, af.created_by
	, af.last_modified_by
	, af.publish
	, NULL as username
from name_family nf
LEFT JOIN enumeration_value ev on ev.id = nf.source_id
LEFT JOIN enumeration_value ev2 on ev2.id = nf.rules_id
LEFT JOIN name_authority_id nai on nai.name_family_id = nf.id
JOIN agent_family af on af.id = nf.agent_family_id
where nf.is_display_name is not null
ORDER BY id

