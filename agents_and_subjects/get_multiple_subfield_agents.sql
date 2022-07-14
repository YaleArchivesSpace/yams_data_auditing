SELECT DISTINCT CONCAT('/agents/people/', np.agent_person_id) as uri
	, np.sort_name
	, CONCAT(np.rest_of_name, ' ', np.primary_name) as name_concat
	, nai.authority_id
	, np.primary_name
	, np.rest_of_name
	, np.dates
	, np.qualifier
	, np.suffix
	, np.prefix
	, np.number
	, np.fuller_form 
	, np.user_mtime
FROM name_person np
LEFT JOIN name_authority_id nai on nai.name_person_id = np.id
LEFT JOIN user on user.agent_record_id = np.agent_person_id
WHERE np.is_display_name is not null
AND user.id is null
AND np.qualifier rlike '\\$.*\\$'
UNION
SELECT DISTINCT CONCAT('/agents/people/', np.agent_person_id) as uri
	, np.sort_name
	, CONCAT(np.rest_of_name, ' ', np.primary_name) as name_concat
	, nai.authority_id
	, np.primary_name
	, np.rest_of_name
	, np.dates
	, np.qualifier
	, np.suffix
	, np.prefix
	, np.number
	, np.fuller_form 
	, np.user_mtime
FROM name_person np
LEFT JOIN name_authority_id nai on nai.name_person_id = np.id
LEFT JOIN user on user.agent_record_id = np.agent_person_id
WHERE np.is_display_name is not null
AND user.id is null
AND np.qualifier rlike '\\$.*\\$'
UNION
SELECT DISTINCT CONCAT('/agents/people/', np.agent_person_id) as uri
	, np.sort_name
	, CONCAT(np.rest_of_name, ' ', np.primary_name) as name_concat
	, nai.authority_id
	, np.primary_name
	, np.rest_of_name
	, np.dates
	, np.qualifier
	, np.suffix
	, np.prefix
	, np.number
	, np.fuller_form 
	, np.user_mtime
FROM name_person np
LEFT JOIN name_authority_id nai on nai.name_person_id = np.id
LEFT JOIN user on user.agent_record_id = np.agent_person_id
WHERE np.is_display_name is not null
AND user.id is null
AND np.qualifier rlike '\\$.*\\$'
order by name_concat