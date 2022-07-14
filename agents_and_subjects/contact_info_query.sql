select CONCAT('/agents/people/', agent_person_id) as uri
	, sort_name
from name_person
where sort_name in ('Acheson, David C.', 'Adams, John', 'Altman, Sidney', 'Altschul, Charles', 'Ameling, Ann', 'Anderson, Gerald H.')