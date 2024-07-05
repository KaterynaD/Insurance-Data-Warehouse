with log as 
(select
SystemId,
UpdateCount,
UpdateUser,
UpdateTimestamp,
json_parse(lower(kdlab.xml_to_json(XMLContent))) JSonContent
from prodcse.logentry 
where SystemId > 113737508-100)
select
l.SystemId,
l.UpdateCount,
l.UpdateUser,
l.UpdateTimestamp,
l.JSonContent.logentry."@systemid",
l.JSonContent.logentry."@id",
l.JSonContent.logentry."@updatecount",
l.JSonContent.logentry."@userid",
l.JSonContent.logentry."@operationdttm",
l.JSonContent.logentry."@status",
l.JSonContent.logentry."@operationdt",
l.JSonContent.logentry."@operationtm",
l.JSonContent.logentry."@templateidref",
l.JSonContent.logentry."@description",
l.JSonContent.logentry."@text",
l.JSonContent.logentry."@internalind",
l.JSonContent.logentry."@type",
l.JSonContent.logentry."@subtype",
l.JSonContent.logentry."@severity",
l.JSonContent.logentry."@updateuser",
l.JSonContent.logentry."@updatetimestamp",
coalesce(l.JSonContent.logentry.logbean."@id", o."@id")  "@id",
coalesce(l.JSonContent.logentry.logbean."@container", o."@container")  "@container",
coalesce(l.JSonContent.logentry.logbean."@modelname", o."@modelname")  "@modelname",
coalesce(l.JSonContent.logentry.logbean."@systemid", o."@systemid")  "@systemid",
coalesce(l.JSonContent.logentry.logbean."@idref", o."@idref")  "@idref",
coalesce(l.JSonContent.logentry.logbean."@quickkey", o."@quickkey")  "@quickkey"
from 
log l
,l.jsoncontent.logentry.logbean o