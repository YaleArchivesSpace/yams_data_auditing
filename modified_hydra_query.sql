Use pamoja
select distinct
tbl1.oid as FirstThumbOid,
tbl1.hydraid as FirstThumbHydra,
tbl1._oid as ParentOID, 
tbl2.HydraID as ParentHydraId ,
'http://imageserver.library.yale.edu/'+tbl1.hydraid+'/300.jpg' as FirstThumbPath,
CONCAT('http://hdl.handle.net/10079/digcoll/', replace(tbl2.hydraid, 'digcoll:', '')) as ParentLibLink,
 tbl1.cid as collection_id,
 tbl1.pid as project_id,
 project.label as project_name
from hydra_publish as tbl1
left join hydra_publish as tbl2 on tbl1._oid = tbl2.oid
left join hydra_accessCondition_oid on hydra_accessCondition_oid.oid = tbl2.oid
left join project on project.pid = tbl1.pid
WHERE tbl1.cid in (19, 4, 24)
AND tbl1.zindex = 1
ORDER BY tbl1.hydraid desc