SELECT CONCAT('/subjects/', subject.id) as subject_uri
	, subject.title as subject
	, subject.created_by
	, subject.create_time
	, resource.title as title
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) as uri
FROM subject_rlshp sr
JOIN subject on sr.subject_id = subject.id
JOIN resource on sr.resource_id = resource.id
UNION ALL
SELECT CONCAT('/subjects/', subject.id) as subject_uri
	, subject.title as subject
	, subject.created_by
	, subject.create_time
	, ao.title as title
	, CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) as uri
FROM subject_rlshp sr
JOIN subject on sr.subject_id = subject.id
JOIN archival_object ao on sr.archival_object_id = ao.id
UNION ALL
SELECT CONCAT('/subjects/', subject.id) as subject_uri
	, subject.title as subject
	, subject.created_by
	, subject.create_time
	, accession.title as title
	, CONCAT('/repositories/', accession.repo_id, '/accessions/', accession.id) as uri
FROM subject_rlshp sr
JOIN subject on sr.subject_id = subject.id
JOIN accession on sr.accession_id = accession.id
ORDER BY subject