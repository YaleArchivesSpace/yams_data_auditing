select CONCAT('/subjects/', id) as uri
	, title
from subject
WHERE SUBSTRING(title, 1, 1) REGEXP BINARY '[a-z]'