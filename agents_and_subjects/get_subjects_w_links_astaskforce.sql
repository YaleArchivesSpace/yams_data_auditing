select CONCAT('/subjects/', subject.id) as subject_uri
	, subject.title
    , CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as resource_uri
    , ev.value as source
    , subject.create_time
    , ud.string_2
from subject
left join subject_rlshp sr on sr.subject_id = subject.id
join resource on sr.resource_id = resource.id
left join user_defined ud on ud.resource_id = resource.id
left join enumeration_value ev on ev.id = subject.source_id
where sr.resource_id is not null
and ud.string_2 is not  null
and ev.value in ('Art and Architechture Thesaurus','aat','att','Library of Congress Subject Headings','lcsh','lcsh.','lsch')
ORDER BY ud.string_2