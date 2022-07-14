/* select * from name_person np
where np.sort_name like '%irca%' or np.sort_name like '%ca.%' */
select *
from name_person np
where np.dates rlike '[A-Za-z]'