select CONCAT('/agents/people/', np.agent_person_id) as uri
	, np.sort_name
	, np.qualifier
from name_person np
where np.qualifier is not null
and np.qualifier like '%.%'
UNION ALL
select CONCAT('/agents/families/', nf.agent_family_id) as uri
	, nf.sort_name
	, nf.qualifier
from name_family nf
where nf.qualifier is not null
and nf.qualifier like '%.%'
UNION ALL
select CONCAT('/agents/corporate_entities/', nce.agent_corporate_entity_id) as uri
	, nce.sort_name
	, nce.qualifier
from name_corporate_entity nce
where nce.qualifier is not null
and nce.qualifier like '%.%'