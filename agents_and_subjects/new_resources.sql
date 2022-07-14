select CONCAT('https://archivesspace.library.yale.edu/resources/', id) as uri
	, title
	, identifier
	, create_time 
	, created_by
	, last_modified_by
	, user_mtime
	, repo_id
from resource
order by create_time desc