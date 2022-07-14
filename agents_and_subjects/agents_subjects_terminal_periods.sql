select CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.created_by
from subject
where subject.title like '%.%'
#UNION ALL */
/* select CONCAT('/agents/people/', name_person.agent_person_id) as uri
	, name_person.sort_name
	, name_person.created_by
	, name_person.primary_name
	, name_person.rest_of_name
	, name_person.title
	, name_person.prefix
	, name_person.suffix
	, name_person.fuller_form
	, name_person.number
from name_person
where name_person.sort_name like '%.%'
and name_person.qualifier is null
UNION ALL
select CONCAT('/agents/corporate_entities/', name_corporate_entity.agent_corporate_entity_id) as uri
	, name_corporate_entity.sort_name
	, name_corporate_entity.created_by
	, name_corporate_entity.primary_name
	, name_corporate_entity.subordinate_name_1
	, name_corporate_entity.subordinate_name_2
	, NULL
	, NULL
	, NULL
	, name_corporate_entity.number
from name_corporate_entity
where name_corporate_entity.sort_name like '%.%'
and name_corporate_entity.qualifier is null
UNION ALL
select CONCAT('/agents/families/', name_family.agent_family_id) as URI
	, name_family.sort_name
	, name_family.created_by
	, name_family.family_name
	, NULL
	, NULL
	, name_family.prefix
	, NULL
	, NULL
	, NULL
from name_family
where name_family.sort_name like '%.%'
and name_family.qualifier is null */