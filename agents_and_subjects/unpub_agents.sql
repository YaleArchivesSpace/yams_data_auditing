select * from agent_person
where publish = 0
UNION ALL
select * from agent_corporate_entity
where publish = 0
UNION ALL
select * from agent_family
where publish = 0