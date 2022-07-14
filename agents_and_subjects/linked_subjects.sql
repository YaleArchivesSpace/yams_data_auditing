select CONCAT('https://archivesspace.library.yale.edu/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, ev.value as source
	, resource.repo_id
	, resource.title
	, ud.string_2
from subject
left join enumeration_value ev on ev.id = subject.source_id
left join subject_rlshp on subject.id = subject_rlshp.subject_id
join resource on resource.id = subject_rlshp.resource_id
left join user_defined ud on ud.resource_id = resource.id
where ud.string_2 is not null
#and subject_rlshp.resource_id is not null
