select CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, term.term
	, ev.value as term_type
from term
join subject_term st on st.term_id = term.id
join subject on subject.id = st.subject_id
left join enumeration_value ev on ev.id = term.term_type_id
where term.term like '%--%'
order by uri desc