SELECT CONCAT('/agents/families/', nf.agent_family_id) as uri
	, nf.sort_name
	, nf.family_name
	, nf.prefix
	, nf.dates
	, nf.qualifier
	, nai.authority_id
	, nf.is_display_name
	, nf.created_by
	, nf.create_time
	, nf.last_modified_by
	, nf.user_mtime
/* 	, date.expression
	, date.begin
	, date.end */
FROM name_family nf
LEFT JOIN name_authority_id nai on nai.name_family_id = nf.id
WHERE nai.authority_id is not null
AND nai.authority_id not like '%loc%'
#LEFT JOIN date on date.agent_family_id = nf.agent_family_id

/* SELECT CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as uri
	, nce.sort_name
	, nce.primary_name
	, nce.subordinate_name_1
	, nce.subordinate_name_2
	, nce.number
	, nce.dates
	, nce.qualifier
	, nai.authority_id
	, nce.is_display_name
	, nce.created_by
	, nce.create_time
	, nce.last_modified_by
	, nce.user_mtime
	, date.expression
	, date.begin
	, date.end
FROM name_corporate_entity nce
LEFT JOIN name_authority_id nai on nai.name_corporate_entity_id = nce.id
LEFT JOIN date on date.agent_corporate_entity_id = nce.agent_corporate_entity_id
WHERE date.id is not null
AND nce.dates is null */
/* WHERE nce.qualifier is not null
AND nce.qualifier not like '$%'
OR nce.qualifier like '%(%' */
#and nce.primary_name not rlike '^[A-Za-z]'
#ORDER BY nce.qualifier


/* SELECT CONCAT('/agents/people/', np.agent_person_id) as uri
	, np.sort_name
	, np.primary_name
	, np.title
	, np.prefix
	, np.rest_of_name
	, np.suffix
	, np.fuller_form
	, np.number
	, np.dates
	, np.qualifier
	, nai.authority_id
	, np.is_display_name
	, np.created_by
	, np.create_time
	, np.last_modified_by
	, np.user_mtime
	, date.expression
	, date.begin
	, date.end
FROM name_person np
LEFT JOIN name_authority_id nai on nai.name_person_id = np.id
LEFT JOIN user on user.agent_record_id = np.agent_person_id
LEFT JOIN date on date.agent_person_id = np.agent_person_id
WHERE user.id is null
#AND nai.authority_id is not null
#AND np.qualifier is not null
#AND np.qualifier not rlike '^[A-Za-z]'
#AND np.qualifier not like '$%'
#AND (nai.authority_id not like '%loc%')
AND date.id is not null
AND np.dates is null */

#np.primary_name
#np.title
#np.prefix
#np.rest_of_name
#np.suffix
#np.fuller_form
#np.number
#np.dates
#np.qualifier
#also look for bad authority IDs