select *
from name_person
where (primary_name like '%[%' or rest_of_name like '%[%')
