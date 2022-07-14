select CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, ev.value as source
	, term.term
	, ev2.value as term_type
from subject
left join subject_term st on st.subject_id = subject.id
left join term on st.term_id = term.id
left join enumeration_value ev on ev.id = subject.source_id
left join enumeration_value ev2 on ev2.id = term.term_type_id
where ev2.value like 'genre_form'
#this eliminates subdivisions where one is a genre-form term
and subject.title = term.term
order by ev.value