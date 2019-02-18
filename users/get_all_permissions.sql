select CONCAT('/agents/people/', user.agent_record_id) as agent_uri
	, CONCAT('/users/', user.id) as user_uri
	, np.sort_name as name_person
	, user.name as user
	, user.username as username
	, permission.permission_code as permission_code
	, permission.description as permission_description
	, g.repo_id as group_repo_id
	, g.group_code as group_code
	, g.description as group_description
	, user.create_time as user_create_time
	, user.system_mtime as user_mod_time
from group_user gu
join user on user.id = gu.user_id
join `group` g on gu.group_id = g.id
join group_permission gp on gp.group_id = g.id
join permission on gp.permission_id = permission.id
left join agent_person ap on ap.id = user.agent_record_id
left join name_person np on np.agent_person_id = ap.id
order by agent_uri