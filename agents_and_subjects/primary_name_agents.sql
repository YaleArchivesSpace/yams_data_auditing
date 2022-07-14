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
	, np.title 
	, np.user_mtime
FROM name_person np
LEFT JOIN name_authority_id nai on nai.name_person_id = np.id
LEFT JOIN user on user.agent_record_id = np.agent_person_id
WHERE np.is_display_name is not null
AND user.id is null
#AND np.rest_of_name rlike '[0-9+]'
#AND np.primary_name rlike '[0-9+]'
#AND np.primary_name not rlike '\\([0-9]+\\)'
#AND np.primary_name not like '% -- %'
AND np.rest_of_name is null
AND np.primary_name not rlike '\\([0-9]+\\)'
AND (np.primary_name not like '%family' and np.primary_name not like '%Family%')
AND (np.primary_name not like '%Estate%' and np.primary_name not like '%Bequest%' and np.primary_name not like '%Trust%'
	and np.primary_name not like '%Descendants%')
AND np.primary_name like '%,%'
AND np.primary_name not like '% -- %'
/* AND (np.primary_name not like 'A.' and np.primary_name not like 'B.' and np.primary_name not like 'C.'
	and np.primary_name not like 'D.' and np.primary_name not like 'E.' and np.primary_name not like 'F.'
	and np.primary_name not like 'G.' and np.primary_name not like 'H.' and np.primary_name not like 'I.'
	and np.primary_name not like 'J.' and np.primary_name not like 'K.' and np.primary_name not like 'L.'
	and np.primary_name not like 'M.' and np.primary_name not like 'N.' and np.primary_name not like 'O.'
	and np.primary_name not like 'P.' and np.primary_name not like 'Q.' and np.primary_name not like 'R.'
	and np.primary_name not like 'S.' and np.primary_name not like 'T.' and np.primary_name not like 'U.'
	and np.primary_name not like 'V.' and np.primary_name not like 'W.' and np.primary_name not like 'X.'
	and np.primary_name not like 'Y.' and np.primary_name not like 'Z.' and np.primary_name not like '% A.'
	and np.primary_name not like '% B.' and np.primary_name not like '% H.' and np.primary_name not like '% W.'
	and np.primary_name not like '% V.' and np.primary_name not like '% T.')  */
/* AND (np.rest_of_name like '%.' and np.rest_of_name not like '% S.' and np.rest_of_name not like '% R.%'
	and np.rest_of_name not like '% T.' and np.rest_of_name not like '% M.' and np.rest_of_name not like '% B.'
	and np.rest_of_name not like '% L.' and np.rest_of_name not like '% D.' and np.rest_of_name not like '% W.'
	and np.rest_of_name not like '% H.' and np.rest_of_name not like '% A.' and np.rest_of_name not like '% J.'
	and np.rest_of_name not like '% P.' and np.rest_of_name not like '% N.' and np.rest_of_name not like '% C.'
	and np.rest_of_name not like '% F.' and np.rest_of_name not like '% E.' and np.rest_of_name not like '% G.'
	and np.rest_of_name not like '% K.' and np.rest_of_name not like '% O.' and np.rest_of_name not like '% V.'
	and np.rest_of_name not like 'J.' and np.rest_of_name not like 'M.' and np.rest_of_name not like 'F.'
	and np.rest_of_name not like 'T.' and np.rest_of_name not like 'E.' and np.rest_of_name not like 'V.'
	and np.rest_of_name not like 'A.' and np.rest_of_name not like 'R.' and np.rest_of_name not like 'N.'
	and np.rest_of_name not like 'W.' and np.rest_of_name not like 'H.' and np.rest_of_name not like 'D.'
	and np.rest_of_name not like 'S.' and np.rest_of_name not like 'I.' and np.rest_of_name not like 'B.'
	and np.rest_of_name not like 'L.' and np.rest_of_name not like 'P.' and np.rest_of_name not like 'O.'
	and np.rest_of_name not like 'K.' and np.rest_of_name not like 'C.' and np.rest_of_name not like 'G.')  */