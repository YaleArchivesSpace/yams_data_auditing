select ud.string_2
	, CONCAT('https://archivesspace.library.yale.edu/resources/', ud.resource_id)
    , resource.title
    , resource.identifier
    , repository.name as repo_name
from user_defined ud
left join resource on resource.id = ud.resource_id
left join repository on repository.id = resource.repo_id
where string_2 is not null
and resource_id is not null
and string_2 = 9590285
