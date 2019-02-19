SELECT title as title
	, count(*) as count
FROM 
	(SELECT subject.title as title
	FROM subject_rlshp sr
	JOIN subject on sr.subject_id = subject.id
	JOIN resource on sr.resource_id = resource.id
	UNION ALL
	SELECT subject.title as title
	FROM subject_rlshp sr
	JOIN subject on sr.subject_id = subject.id
	JOIN archival_object ao on sr.archival_object_id = ao.id
	UNION ALL
	SELECT subject.title as title
	FROM subject_rlshp sr
	JOIN subject on sr.subject_id = subject.id
	JOIN accession on sr.accession_id = accession.id
	ORDER BY title) as title
GROUP by title
ORDER by title