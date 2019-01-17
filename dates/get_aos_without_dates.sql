select archival_object.id
	, archival_object.title
	, date.expression
	, date.begin
	, date.end
from archival_object
left join date on date.archival_object_id = archival_object.id
where (date.expression is null and date.begin is null and date.end is null)