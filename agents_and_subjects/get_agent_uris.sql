select concat('/agents/people/', ap.id) as uri
from agent_person ap
UNION ALL
select concat('/agents/corporate_entities/', ace.id) as uri
from agent_corporate_entity ace
UNION ALL
select concat('/agents/families/', af.id) as uri
from agent_family af