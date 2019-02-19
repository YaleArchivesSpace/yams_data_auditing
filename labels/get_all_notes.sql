#doesn't get ALL notes - about 100ish of 690k are missing - investigate

select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/repositories/', resource.repo_id, '/resources/', resource.id) AS URI
    , npi.persistent_id as persistent_id
from resource
JOIN note on note.resource_id = resource.id
LEFT JOIN note_persistent_id npi on npi.note_id = note.id
UNION ALL
select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) AS URI
    , npi.persistent_id as persistent_id
from archival_object ao
JOIN note on note.archival_object_id = ao.id
LEFT JOIN note_persistent_id npi on npi.note_id = note.id
UNION ALL
select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/repositories/', do.repo_id, 'digital_objects/', do.id) AS URI
    , npi.persistent_id as persistent_id
from digital_object do 
JOIN note on note.digital_object_id = do.id
LEFT JOIN note_persistent_id npi on npi.note_id = note.id
UNION ALL
select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/repositories/', doc.repo_id, '/digital_object_components/', doc.id) AS URI
    , npi.persistent_id as persistent_id
from digital_object_component doc
JOIN note on note.digital_object_component_id = doc.id
LEFT JOIN note_persistent_id npi on npi.note_id = note.id
UNION ALL
select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/agents/people/', ap.id) AS URI
    , npi.persistent_id as persistent_id
from agent_person ap
JOIN note on note.agent_person_id = ap.id
LEFT JOIN note_persistent_id npi on npi.note_id = note.id
UNION ALL
select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/agents/families/', af.id) AS URI
    , npi.persistent_id as persistent_id
from agent_family af
JOIN note on note.agent_family_id = af.id
LEFT JOIN note_persistent_id npi on npi.note_id = note.id
UNION ALL
select CONVERT(note.notes using 'utf8') AS note_text
	, CONCAT('/agents/corporate_entities/', ace.id) AS URI
    , npi.persistent_id as persistent_id
from agent_corporate_entity ace
LEFT JOIN note on note.agent_corporate_entity_id = ace.id
JOIN note_persistent_id npi on npi.note_id = note.id
