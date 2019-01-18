select CONCAT('/config/enumeration_values/', ev.id) as uri
	, ev.value
	, ev.position
	, enumeration.name
	, enumeration.id
from enumeration_value ev
join enumeration on ev.enumeration_id = enumeration.id
where enumeration.name not in ('linked_agent_archival_record_relators', 'linked_agent_event_roles', 'accession_acquisition_type',
								'date_era', 'date_calendar', 'digital_object_level', 'agent_contact_salutation', 'resource_resource_type',
								'file_version_checksum_methods', 'language_iso639_2', 'linked_agent_role', 'agent_relationship_earlierlater_relator',
								'agent_relationship_associative_relator', 'agent_relationship_parentchild_relator', 								'agent_relationship_subordinatesuperior_relator', 'container_location_status', 'date_type', 'date_certainty',
								'deaccession_scope', 'extent_portion', 'file_version_xlink_actuate_attribute', 'file_version_xlink_show_attribute',
								'file_version_file_format_name', 'location_temporary', 'name_person_name_order', 'note_digital_object_type',
								'note_multipart_type', 'note_orderedlist_enumeration', 'note_singlepart_type', 'note_bibliography_type',
								'note_index_type', 'note_index_item_type', 'country_iso_3166', 'rights_statement_rights_type', 'rights_statement_ip_status',
								'accession_parts_relator', 'accession_parts_relator_type', 'accession_sibling_relator', 'accession_sibling_relator_type',
								'dimension_units', 'currency_iso_4217', 'payment_fund_code', 'rights_statement_external_document_identifier_type',
								'rights_statement_other_rights_basis', 'linked_event_archival_record_roles', 'accession_resource_type', 'telephone_number_type',
								'rights_statement_act_type', 'location_function_type', 'rights_statement_act_restriction', 'note_rights_statement_act_type',
								'note_rights_statement_type')
order by enumeration.id
