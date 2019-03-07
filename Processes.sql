select distinct
@@servername as serverName, 
D.name as DBname, 
P.spid,
P.Kpid,
P.cmd,
TA.transaction_id,
TA.name as transac,
TL.request_type,
TL.request_owner_type,
TL.request_status,
TL.request_mode,
P.status,
P.blocked,
P.waittype,
P.waittime,
P.program_name,
P.hostname,
P.loginame,
P.login_time
from sys.sysprocesses P
inner join sys.sysdatabases D
	on P.dbid = D.dbid
left outer join sys.dm_tran_session_transactions TS
on P.spid = TS.session_id
left outer join sys.dm_tran_active_transactions TA
on TS.transaction_id = TA.transaction_id
left outer join sys.dm_tran_locks TL
on P.spid = TL.request_session_id
where D.name = 'Fashion'
and P.loginame = 'Yoox\conteu'

order by P.spid,TA.transaction_id