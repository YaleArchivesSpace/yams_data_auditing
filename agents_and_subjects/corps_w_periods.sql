select CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as uri
	, nce.sort_name
	, nce.primary_name
	, nce.subordinate_name_1
	, nce.subordinate_name_2
	, nce.is_display_name
from name_corporate_entity nce
where sort_name like '%.'
and sort_name not like '%Inc.'
and sort_name not like '%Co.'
and sort_name not like '%Ltd.'
and sort_name not like '%Bros.'
and sort_name not like '%Dept.'