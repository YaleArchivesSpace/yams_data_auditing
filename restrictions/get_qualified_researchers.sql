select note.notes
	#can't do this bc MySQL version is too old; how about just move this into Python
	#, REGEXP_SUBSTR(note.notes, '["content":]"(.*?)"[,"]')
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as uri
	, resource.create_time
from note
join resource on resource.id = note.resource_id
where (note.notes like '%ualified%' and note.notes like '%restrict%')


#use an rlike to just get the note content

