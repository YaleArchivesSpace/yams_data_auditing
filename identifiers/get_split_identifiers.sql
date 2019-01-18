select CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as uri
	, identifier
	, resource.title
from resource
where resource.identifier not like '%,null,null,null%'
and resource.suppressed = 0