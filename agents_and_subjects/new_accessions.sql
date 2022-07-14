select CONCAT('https://archivesspace.library.yale.edu/accessions/', accession.id) as uri
	, accession.title
#	, identifier
	, accession.create_time 
	, accession.created_by
	, accession.last_modified_by
	, accession.user_mtime
	, repository.name
from accession
left join repository on repository.id = accession.repo_id
order by accession.create_time desc