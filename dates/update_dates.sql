#This script can be used to update single (no end date), single/inclusive (no begin date), 
#and inclusive dates (both), with slight modifications for each:
#	Comment out date.end line when updating single dates 
#	Comment out date.begin line when updating single/inclusive dates
#	Leave both lines in when updating inclusive dates

UPDATE date, dateTemp
SET begin=dateTemp.begin,
	, date.end=dateTemp.end, 
	, date.date_type_id=dateTemp.date_type_id
WHERE date.id = dateTemp.id 
AND dateTemp.id <> 0