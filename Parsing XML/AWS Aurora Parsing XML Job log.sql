create or replace view etl.LogsStatus as
select
SystemId,
Updatetimestamp,
JobIdDaily,
JobStatusDaily,
JobIdIncrement,
JobStatusIncrement
from (
select
j.SystemId
, j.Updatetimestamp
, extractvalue(j.XmlContent,'/Job/JobActions/JobAction[@id="ActionReportmartDailyLoad"]/@id') JobIdDaily
, extractvalue(j.XmlContent,'Job/JobActions/JobAction[@id="ActionReportmartDailyLoad"]/@Status') JobStatusDaily
, extractvalue(j.XmlContent,'/Job/JobActions/JobAction[@id="ActionIncrementalExport"]/@id') JobIdIncrement
, extractvalue(j.XmlContent,'Job/JobActions/JobAction[@id="ActionIncrementalExport"]/@Status') JobStatusIncrement
from prodcse.Job j
) data
where (JobIdDaily='ActionReportmartDailyLoad' and JobStatusDaily='Completed') or
(JobIdDaily='ActionIncrementalExport' and JobStatusDaily='Completed')
and SystemId>=44818;
