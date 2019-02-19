SELECT np.sort_name
	, CONCAT('/agents/people/', np.agent_person_id) as uri
FROM name_person np
LEFT JOIN linked_agents_rlshp lar on np.agent_person_id = lar.agent_person_id
LEFT JOIN user on user.agent_record_id = np.agent_person_id
WHERE np.is_display_name is not null
AND (lar.accession_id is null
		and lar.archival_object_id is null
		and lar.digital_object_id is null
		and lar.digital_object_component_id is null
		and lar.event_id is null
		and lar.resource_id is null)
AND user.id is null
UNION ALL
SELECT nf.sort_name
	, CONCAT('/agents/families/', nf.agent_family_id) as uri
FROM name_family nf
LEFT JOIN linked_agents_rlshp lar on nf.agent_family_id = lar.agent_family_id
WHERE nf.is_display_name is not null
AND (lar.accession_id is null
		and lar.archival_object_id is null
		and lar.digital_object_id is null
		and lar.digital_object_component_id is null
		and lar.event_id is null
		and lar.resource_id is null)
UNION ALL
SELECT nce.sort_name
	, CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as uri
FROM name_corporate_entity nce
LEFT JOIN linked_agents_rlshp lar on nce.agent_corporate_entity_id = lar.agent_corporate_entity_id
WHERE nce.is_display_name is not null
AND (lar.accession_id is null
		and lar.archival_object_id is null
		and lar.digital_object_id is null
		and lar.digital_object_component_id is null
		and lar.event_id is null
		and lar.resource_id is null)