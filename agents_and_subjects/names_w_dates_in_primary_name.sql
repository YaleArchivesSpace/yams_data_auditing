select CONCAT('/agents/people/', name_person.agent_person_id) as agent_uri
	, name_person.primary_name
	, name_person.rest_of_name
	, name_person.dates
	, name_person.title
	, name_person.prefix
	, name_person.suffix
	, name_person.qualifier
	, ev.value as source
from name_person
left join enumeration_value ev on ev.id = name_person.source_id
where is_display_name is not null
and dates is null
and rest_of_name is null
and title is null
#and primary_name regexp '.*[0-9]{4}$' or primary_name regexp '.*[0-9]{4}[-]$'