SELECT CONCAT('/subjects/', subject.id) as uri
	, subject.authority_id
	, subject.title
	, term.term
	, ev.value as term_type
	, ev2.value as source
FROM subject
left join subject_term st on st.subject_id = subject.id
left join term on st.term_id = term.id
left join enumeration_value ev on ev.id = term.term_type_id
left join enumeration_value ev2 on ev2.id = subject.source_id
order by subject.title