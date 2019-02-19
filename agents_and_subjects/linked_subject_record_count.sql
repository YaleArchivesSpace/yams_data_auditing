#Add uris?

SELECT resource.title as title
	, count(resource.title) as count
FROM subject_rlshp sr
JOIN subject on sr.subject_id = subject.id
JOIN resource on sr.resource_id = resource.id
GROUP BY resource.title
UNION ALL
#add replace stuff here
SELECT ao.title as title
	, count(ao.title) as count
FROM subject_rlshp sr
JOIN subject on sr.subject_id = subject.id
JOIN archival_object ao on sr.archival_object_id = ao.id
GROUP BY ao.title
UNION ALL
SELECT accession.title as title
	, count(accession.title) as count
FROM subject_rlshp sr
JOIN subject on sr.subject_id = subject.id
JOIN accession on sr.accession_id = accession.id
GROUP BY accession.title
ORDER BY count DESC