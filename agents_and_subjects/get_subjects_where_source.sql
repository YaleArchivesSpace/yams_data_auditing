select CONCAT('https://archivesspace.library.yale.edu/subjects/', s.id) as subject_url
	, s.title
#	, term.term
#	, ev2.value as term_type
	, s.authority_id
	, ev.value as source
	, s.created_by
	, s.last_modified_by
	, s.create_time
	, s.user_mtime
from subject s
left join enumeration_value ev on ev.id = source_id
#left join subject_term st on s.id = st.subject_id
#left join term on term.id = st.term_id
#left join enumeration_value ev2 on ev2.id = term.term_type_id
WHERE ev.value in ('Art and Architechture Thesaurus','aat','att','Library of Congress Subject Headings','lcsh','lcsh.','lsch')
order by title
