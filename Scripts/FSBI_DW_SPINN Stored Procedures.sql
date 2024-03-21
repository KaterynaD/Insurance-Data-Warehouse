CREATE OR REPLACE FUNCTION cse_bi.dmuu_policynumber_to_dwuu($1 varchar)
	RETURNS varchar
	LANGUAGE sql
	STABLE
AS $$
	
	
  select left($1,3)+'-'+
   case
    when right(left($1,4),1)='A' then '10'
    when right(left($1,4),1)='B' then '11'
    when right(left($1,4),1)='C' then '12'
    when right(left($1,4),1)='D' then '13'
    when right(left($1,4),1)='E' then '14'
    when right(left($1,4),1)='F' then '15'
    when right(left($1,4),1)='G' then '16'
    when right(left($1,4),1)='H' then '17'
	else
	'0'+right(left($1,4),1)
   end +right(left($1,5),1)
   +'-'+right($1,5)	 


$$
;

CREATE OR REPLACE PROCEDURE cse_bi.eris_snapshots(snapshot_scheama varchar, snapshot_table_name varchar, max_snapshots_age int4)
	LANGUAGE plpgsql
AS $$
															
DECLARE														
Table_To_Delete varchar(64);														
BEGIN														
														
/*1. Get old snapshot table name, which exists for max_snapshots_age months*/														
SELECT relname::text table_name														
into Table_To_Delete														
FROM pg_class c														
JOIN pg_namespace n														
ON n.oid = c.relnamespace														
WHERE nspname::text =snapshot_scheama														
AND relname::text like snapshot_table_name+'%'														
AND DateDiff(month,to_date(reverse(substring(reverse(table_name),3,4)) +														
case														
substring(table_name,len(table_name),1)														
when '1' then '0331'														
when '2' then '0630'														
when '3' then '0930'														
when '4' then '1231'														
end,'YYYYMMDD'), GetDate() )= max_snapshots_age;														
														
/*2. Dropping table if found what to delete*/														
if FOUND then														
	EXECUTE 'drop table if exists '+snapshot_scheama+'.'+Table_To_Delete;													
end if;														
														
/*3. Creating new snapshot*/														
														
/*3a. To re-run safely*/														
EXECUTE 'drop table if exists '+snapshot_scheama+'.'+snapshot_table_name+'_'+to_char(GetDate(),'YYYY')+'q'+to_char(GetDate(),'Q');														
														
/*3b. Creating...*/														
EXECUTE 'create table '+snapshot_scheama+'.'+snapshot_table_name+'_'+to_char(GetDate(),'YYYY')+'q'+to_char(GetDate(),'Q')+														
        ' as select * from reporting.'+snapshot_table_name;														
														
/*4. Comment*/														
														
EXECUTE   'comment on table '+snapshot_scheama+'.'+snapshot_table_name+'_'+to_char(GetDate(),'YYYY')+'q'+to_char(GetDate(),'Q') + 														
          ' is ''Historical snapshot of modeling data in reporting.'+snapshot_table_name+														
		  '. Use it if you neeed to know how the system looked like at the date in the snapshot table name. The table exists for '+												
		  cast(max_snapshots_age as varchar)+' months only''';												
														
														
														
END;														

$$
;

CREATE OR REPLACE FUNCTION cse_bi.ifempty($1 varchar, $2 varchar)
	RETURNS varchar
	LANGUAGE sql
	IMMUTABLE
AS $$
	
select
  case 
   when trim(coalesce($1,'')) = '' then
    $2 
   else
    $1
   end

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.modeldata_snapshots(snapshot_table_name varchar, max_snapshots_age int4)
	LANGUAGE plpgsql
AS $$
																
DECLARE															
Table_To_Delete varchar(64);															
BEGIN															
															
/*1. Get old snapshot table name, which exists for max_snapshots_age months*/															
with data as (															
SELECT relname::text table_name,															
to_date(reverse(substring(reverse(table_name),1,8)),'YYYYMMDD') Table_TimeStamp,															
DateDiff(month,Table_TimeStamp, GetDate() ) Diff															
FROM pg_class c															
JOIN pg_namespace n															
ON n.oid = c.relnamespace															
WHERE nspname::text ='modeling'															
AND relname::text like snapshot_table_name+'%'															
/* There are some issues in Redshift with using this approach in SP. Works in direct SQL "invalid value for "YYYY" in source string" error in SP															
AND DateDiff(month,to_date(reverse(substring(reverse(table_name),1,8)),'YYYYMMDD'), GetDate() )=max_snapshots_age;															
*/															
)															
,oldest as (															
select max(Diff) Diff 															
from Data															
having max(Diff)=max_snapshots_age															
)															
SELECT															
table_name															
into Table_To_Delete															
FROM data t															
join oldest o															
on DateDiff(month,to_date(reverse(substring(reverse(t.table_name),1,8)),'YYYYMMDD'), GetDate() ) =o.Diff;															
															
															
/*2. Dropping table if found what to delete*/															
if FOUND then															
	EXECUTE 'drop table if exists modeling.'+Table_To_Delete;														
end if;															
															
/*3. Creating new snapshot*/															
															
/*3a. To re-run safely*/															
EXECUTE 'drop table if exists modeling.'+snapshot_table_name+'_'+to_char(GetDate(),'YYYYMMDD');															
															
/*3b. Creating...*/															
EXECUTE 'create table modeling.'+snapshot_table_name+'_'+to_char(GetDate(),'YYYYMMDD')+															
        ' as select * from fsbi_dw_spinn.'+snapshot_table_name;															
															
/*4. Comment*/															
															
EXECUTE   'comment on table modeling.'+snapshot_table_name+'_'+to_char(GetDate(),'YYYYMMDD') + 															
          ' is ''Historical snapshot of modeling data in fsbi_dw_spinn.'+snapshot_table_name+															
		  '. Use it if you neeed to know how the system looked like at the date in the snapshot table name. The table exists for '+													
		  cast(max_snapshots_age as varchar)+' months only''';													
															
END;															

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.process_quote_auto()
	LANGUAGE plpgsql
AS $$
	
	
	
	
	
   DECLARE vMonthId INT;
   DECLARE vCount DATE;
   DECLARE vStartDate DATE;
   DECLARE vEndDate DATE;
   DECLARE vInsertDate DATE;
   DECLARE vUpdateDate DATE;

BEGIN 

   SELECT NVL(MAX(AddDt),CAST('1900-01-01' AS DATE)) into vStartDate FROM fsbi_dw_spinn.Quote_Auto; 
 
   SELECT CAST(GETDATE() AS DATE) into vEndDate;

   DROP TABLE IF EXISTS #quote_auto;

   SELECT *, CAST(NULL AS DATE) AS FirstTran
   INTO #quote_auto
   FROM FSBI_STG_SPINN.STG_quote_auto stg
   WHERE stg.UpdateDt >=vStartDate ;

  --SET to NULL the QuoteNumber_qi if this is not an application
   UPDATE #quote_auto
    SET QuoteNumber_qi = NULL
   FROM #quote_auto 
   WHERE LEFT(QuoteNumber_qi, 2) <> 'AP';

 --Add first transaciton dates
   UPDATE #quote_auto
   SET FirstTran = DT.TM_DATE
   FROM FSBI_DW_SPINN.FACT_POLICYTRANSACTION  fpt
   INNER JOIN FSBI_DW_SPINN.DIM_TIME  DT ON DT.TIME_ID = FPT.TRANSACTIONDATE_ID
   WHERE FPT.POLICY_UNIQUEID = #quote_auto.policyref and #quote_auto.policyref IS NOT null
   and  FPT.TransactionNumber = 1 AND FPT.TRANSACTIONSEQUENCE = 1;

   IF(SELECT COUNT(1) FROM #quote_auto) > 0
   then
  
   DELETE FROM fsbi_dw_spinn.Quote_Auto
   using #quote_auto
   where nullif(QuoteNumber,'')=nullif(QuoteNumber_bp,'');  
   
   vInsertDate= GETDATE();
   vUpdateDate= GETDATE();

   INSERT INTO fsbi_dw_spinn.Quote_Auto
   (
    linecd
    , subtypecd
    , systemid
    , CMMContainer
    , CarrierGroupCd
    , CarrierCd
    , CompanyCd
    , subtypecd_bp
    , ControllingStateCd
    , QuoteNumber
    , OriginalApplicationRef
    , id
    , policynumber
    , policyversion
    , EffectiveDt
    , ExpirationDt
    , RatedInd
    , RenewalTermCd
    , WrittenPremiumAmt
    , ProgramInd
    , BatchQuoteSourceCd
    , AffinityGroupCd
    , ApplicationNumber
    , Bridged
    , subtypecd_qi
    , uniqueid
    , adddt
    , addtm
    , adduser
    , Agent
    , Addr
    , City
    , ZipCode
    , MailingStateCD
    , PrimaryInsured
    , PrimaryPhoneNumber
    , PrimaryPhoneName
    , CustomerNumber
    , birthdt
    , UniqueCustomerKey
    , UniqueCustomerKey_app
    , updatetimestamp_app
    , updateDt
    , updateTm
    , updateuser
    , customerref
    , policyref
    , changeinforef
    , typecd
    , status
    , Description
    , VehIdentificationNumber
    , VehNumber
    , ComprehensiveDed
    , CollisionDed
    , BILImit
    , PDLimit
    , UMBILimit
    , MedPayLimit
    , MPD1
    , MPD2
    , Multicar
    , FullTermAmt
    , FinalPremiumAmt
    , insertdate 
    , insertby
    , updatedate 
    , updateby 
    , FirstTran
   )
    SELECT
     linecd
    , subtypecd
    , systemid
    , CMMContainer
    , CarrierGroupCd
    , CarrierCd
    , CompanyCd
    , subtypecd_bp
    , ControllingStateCd
    , QuoteNumber_bp
    , OriginalApplicationRef
    , id
    , policynumber
    , policyversion
    , EffectiveDt
    , ExpirationDt
    , RatedInd
    , RenewalTermCd
    , WrittenPremiumAmt
    , ProgramInd
    , BatchQuoteSourceCd
    , AffinityGroupCd
    , quotenumber_qi
    , Bridged
    , subtypecd_qi
    , uniqueid
    , adddt
    , addtm
    , adduser
    , Agent
    , Addr
    , City
    , ZipCode
    , MailingStateCD
    , PrimaryInsured
    , PrimaryPhoneNumber
    , PrimaryPhoneName
    , CustomerNumber
    , birthdt
    , UniqueCustomerKey
    , UniqueCustomerKey_app
    , updatetimestamp_app
    , updateDt
    , updateTm
    , updateuser
    , customerref
    , policyref
    , changeinforef
    , typecd
    , status
    , Description
    , VehIdentificationNumber
    , VehNumber
    , ComprehensiveDed
    , CollisionDed
    , BILImit
    , PDLimit
    , UMBILimit
    , MedPayLimit
    , MPD1
    , MPD2
    , Multicar
    , FullTermAmt
    , FinalPremiumAmt
    , vInsertDate
    , current_user
    , vUpdateDate
    , current_user 
    , FirstTran
   FROM #quote_auto;

  -- SET @inserted = @@ROWCOUNT;
 end if;

   UPDATE fsbi_dw_spinn.Quote_Auto 
     SET FirstTran = DT.TM_DATE
     from FSBI_DW_SPINN.FACT_POLICYTRANSACTION  fpt
	 INNER JOIN FSBI_DW_SPINN.DIM_TIME  DT ON DT.TIME_ID = FPT.TRANSACTIONDATE_ID
	 WHERE fsbi_dw_spinn.Quote_Auto.policynumber IS NOT null and  FPT.POLICY_UNIQUEID = fsbi_dw_spinn.Quote_Auto.policyref
	 AND fsbi_dw_spinn.Quote_Auto.FirstTran IS null and FPT.TransactionNumber = 1
	 AND FPT.TRANSACTIONSEQUENCE = 1;	 

 end;




$$
;

CREATE OR REPLACE PROCEDURE cse_bi.process_quote_building()
	LANGUAGE plpgsql
AS $$
	
   DECLARE vMonthId INT;
   DECLARE vCount INT;
   DECLARE vStartDate DATE;
   DECLARE vEndDate DATE;
   DECLARE vInsertDate DATE;
   DECLARE vUpdateDate DATE;

BEGIN 
   
   SELECT NVL(MAX(AddDt),CAST('1900-01-01' AS DATE)) into vStartDate FROM fsbi_dw_spinn.Quote_Building; 
   SELECT CAST(GETDATE() AS DATE) into vEndDate;

 
   DROP TABLE IF EXISTS #quote_building;

   SELECT *, CAST(NULL AS DATE) AS [FirstTran]
   INTO #quote_building
   FROM FSBI_STG_SPINN.STG_quote_building stg
   WHERE stg.UpdateDt >= vStartDate
   UNION 
   SELECT --distinct stg.QuoteNumber_bp 
   stg.*, CAST(NULL AS DATE) AS [FirstTran]
   FROM FSBI_STG_SPINN.STG_quote_building  stg
   LEFT JOIN fsbi_dw_spinn.Quote_Building  qb ON --qb.systemid =stg.systemid 
   nullif(qb.QuoteNumber,'') = nullif(stg.QuoteNumber_bp,'')
   WHERE nullif(qb.QuoteNumber,'') is null 
   UNION
   --Get missing policies from staging 
   SELECT stg.*, CAST(NULL AS DATE) AS [FirstTran]
   FROM FSBI_STG_SPINN.STG_quote_building  stg
   JOIN fsbi_dw_spinn.Quote_Building  qb ON ( nullif(qb.quotenumber,'') is not null and 
    nullif(qb.QuoteNumber,'') = nullif(stg.QuoteNumber_bp,''))
   WHERE nullif(stg.policynumber,'') is not null and nullif(qb.policynumber,'') IS null;


 --SET to NULL the QuoteNumber_qi if this is not an application
   UPDATE #quote_Building
   SET QuoteNumber_qi = NULL
   WHERE LEFT(QuoteNumber_qi, 2) <> 'AP';

 --Add first transaciton dates
   UPDATE #quote_Building
   SET FirstTran = DT.TM_DATE
   FROM FSBI_DW_SPINN.FACT_POLICYTRANSACTION  fpt
   INNER JOIN FSBI_DW_SPINN.DIM_TIME  DT ON DT.TIME_ID = FPT.TRANSACTIONDATE_ID
   WHERE #quote_Building.policyref IS NOT null and FPT.POLICY_UNIQUEID = #quote_Building.policyref
   AND FPT.TransactionNumber = 1
   AND FPT.TRANSACTIONSEQUENCE = 1;

   IF(SELECT COUNT(1) FROM #quote_Building) > 0
   then
 
   DELETE 
   FROM fsbi_dw_spinn.Quote_Building
   using #quote_Building T where (nullif(fsbi_dw_spinn.Quote_Building.QuoteNumber,'') IS NOT NULL 
   AND nullif(T.QuoteNumber_bp,'') = nullif(fsbi_dw_spinn.Quote_Building.QuoteNumber,''))
   OR (nullif(fsbi_dw_spinn.Quote_Building.ApplicationNumber,'') IS NOT NULL 
   AND nullif(T.quotenumber_qi,'') = nullif(fsbi_dw_spinn.Quote_Building.ApplicationNumber,''));
 
    
   vInsertDate= GETDATE();
   vUpdateDate= GETDATE();
  
   INSERT INTO fsbi_dw_spinn.Quote_Building
   (
   LineCd
   , subtypecd
   , systemid
   , CMMContainer
   , CarrierGroupCd
   , CarrierCd
   , CompanyCd
   , subtypecd_bp
   , ControllingStateCd
   , QuoteNumber
   , OriginalApplicationRef
   , id
   , policynumber
   , policyversion
   , EffectiveDt
   , ExpirationDt
   , RatedInd
   , RenewalTermCd
   , WrittenPremiumAmt
   , ProgramInd
   , BatchQuoteSourceCd
   , AffinityGroupCd
   , ApplicationNumber
   , Bridged
   , subtypecd_qi
   , uniqueid
   , adddt
   , addtm
   , adduser
   , updatedt
   , UpdateTm
   , UpdateUser
   , Agent
   , Addr
   , City
   , ZipCode
   , MailingStateCD
   , PrimaryInsured
   , PrimaryPhoneNumber
   , PrimaryPhoneName
   , CustomerNumber
   , birthdt
   , UniqueCustomerKey
   , UniqueCustomerKey_app
   , updatetimestamp_app
   , customerref
   , policyref
   , changeinforef
   , typecd
   , [status]
   , [Description]
   , CovALimit
   , SqFt
   , YearBuilt
   , RoofCd
   , Deductible
   , ProtectionClass
   , WaterDed
   , Stories
   , MPD1
   , MPD2
   , Multicar
   , FirstTran
   , SafeguardPlusInd
   , RatingTier
   , WaterRiskScore 
   , Building_Zipcode
   , insertdate
   , insertby
   , updatedate
   , updateby)
   
   SELECT
   LineCd
   , subtypecd
   , systemid
   , CMMContainer
   , CarrierGroupCd
   , CarrierCd
   , CompanyCd
   , subtypecd_bp
   , ControllingStateCd
   , QuoteNumber_bp
   , OriginalApplicationRef
   , id
   , policynumber
   , policyversion
   , EffectiveDt
   , ExpirationDt
   , RatedInd
   , RenewalTermCd
   , WrittenPremiumAmt
   , ProgramInd
   , BatchQuoteSourceCd
   , AffinityGroupCd
   , quotenumber_qi
   , Bridged
   , subtypecd_qi
   , uniqueid
   , adddt
   , addtm
   , adduser
   , updatedt
   , UpdateTm
   , UpdateUser
   , Agent
   , Addr
   , City
   , ZipCode
   , MailingStateCD
   , PrimaryInsured
   , PrimaryPhoneNumber
   , PrimaryPhoneName
   , CustomerNumber
   , birthdt
   , UniqueCustomerKey
   , UniqueCustomerKey_app
   , updatetimestamp_app
   , customerref
   , policyref
   , changeinforef
   , typecd
   , [status]
   , [Description]
   , CovALimit
   , SqFt
   , YearBuilt
   , RoofCd
   , Deductible
   , ProtectionClass
   , WaterDed
   , Stories
   , MPD1
   , MPD2
   , Multicar
   , FirstTran
   , SafeguardPlusInd
   , RatingTier
   , WaterRiskScore 
   , Building_Zipcode 
   , vInsertDate
   , current_user
   , vUpdateDate
   , current_user
   FROM #quote_building;

 end if;

   --UPDATE BACKDATED POLICIES
   UPDATE fsbi_dw_spinn.Quote_Building  
   SET FirstTran = DT.TM_DATE
   from FSBI_DW_SPINN.FACT_POLICYTRANSACTION  fpt
   INNER JOIN FSBI_DW_SPINN.DIM_TIME  DT ON DT.TIME_ID = FPT.TRANSACTIONDATE_ID
   WHERE fsbi_dw_spinn.Quote_Building .policynumber IS NOT NULL
   AND fsbi_dw_spinn.Quote_Building.FirstTran IS null and  FPT.POLICY_UNIQUEID = fsbi_dw_spinn.Quote_Building.policyref
   AND FPT.TransactionNumber = 1
   AND FPT.TRANSACTIONSEQUENCE = 1;
     
END; 
$$
;

CREATE OR REPLACE PROCEDURE cse_bi.purgefivetran_v2(pschema_name varchar)
	LANGUAGE plpgsql
AS $$
	
DECLARE vScriptNumber INT;
DECLARE vMaxSN INT;
DECLARE vScript VARCHAR(250);
begin
	


DROP TABLE IF EXISTS #TMP;
SELECT ROW_NUMBER() OVER() as [scriptNum], PurgeScript
INTO #TMP
FROM
(
SELECT DISTINCT 'DELETE FROM ' + fa.schema_name + '.' + fa.table_name  + ' WHERE _fivetran_deleted = TRUE;' AS PurgeScript
FROM cse_bi.vfivetran_audit fa
WHERE fa.schema_name ILIKE  pschema_name
)SQ;

vScriptNumber := 1;
SELECT MAX(scriptNum) INTO vMaxSN FROM #TMP;
WHILE vScriptNumber <= vMaxSN LOOP
SELECT PurgeScript INTO vScript FROM #TMP WHERE scriptNum = vScriptNumber;
--RAISE INFO 'EXECUTE %', vScript;
EXECUTE vScript;
vScriptNumber := vScriptNumber + 1;
END LOOP;
END;


$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_eris_claims(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
	
	
			
BEGIN		
	
/*-------Feature conversion is used in several parts of the process independently ------------------------------*/    		
drop table if exists covx;		
create temporary table covx as    		
select distinct   		
covx.covx_asl as aslob,   		
covx.act_rag  as rag,   		
left(covx.coveragetype,1) as feature_type,    		
covx.covx_code as feature,    		
isnull(covx.act_eris,'OTH') as feature_map    		
from public.dim_coverageextension covx;   		
    		
/*--slightly different way of getting policy and claims attributes in SPINN and WINS claims----------------------*/   		
/*--it's possible a claim has mix of WINs and SPINN transactions ------------------------------------------------*/   		
/*--some of them only DW based and WINs transaction has higher date then SPINN-----------------------------------*/   		
/*--attributes can be populated in SPINN transactions but not in WINs--------------------------------------------*/   		
/*--the final set up is in the main select ----------------------------------------------------------------------*/   		
/*--1. Latest transaction ---------------------------------------------------------------------------------------*/   		
drop table if exists tmp_da_spinn;		
create temporary table  tmp_da_spinn as   		
select    		
f.claim_number,   		
f.claimant,   		
f.feature,    		
max(acct_date) acct_date    		
from public.vmfact_claimtransaction_blended f   		
where (f.source_system='SPINN')   		
group by f.claim_number,    		
f.claimant,   		
f.feature;    		
    		
drop table if exists tmp_da_wins;    		
create temporary table  tmp_da_wins as    		
select f.claim_number,    		
f.claimant,   		
f.feature,    		
max(f.acct_date) acct_date    		
from public.vmfact_claimtransaction_blended f   		
left outer join tmp_da_spinn    		
on f.claim_number=tmp_da_spinn.claim_number   		
where (f.source_system='WINS')    		
and tmp_da_spinn.claim_number is null   		
group by f.claim_number,    		
f.claimant,   		
f.feature;    		
    		
    		
/*--2.SPINN based claims data -----------------------------------------------------------------------------------*/   		
drop table if exists tmp_dc_spinn;    		
create temporary table tmp_dc_spinn as    		
select distinct     		
f.claim_number,   		
f.claimant,   		
f.feature,    		
max(catastrophe_id) catastrophe_id,   		
max(loss_cause) loss_cause,   		
max(policy_state) policy_state,   		
max(company) company,   		
max(carrier) carrier,   		
max(policy_number) policy_number,   		
case    		
when upper(substring(max(policy_number),3,1))='A' then 'AU'   		
when upper(substring(max(policy_number),3,1))='B' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='E' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='F' then 'DF'   		
when upper(substring(max(policy_number),3,1))='H' then 'HO'   		
when upper(substring(max(policy_number),3,1))='M' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='Q' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='R' then 'AU'   		
when upper(substring(max(policy_number),3,1))='U' then 'OTH'    		
end LOB , 		
max(policyref) policyref,   		
max(poleff_date) poleff_date,   		
max(polexp_date) polexp_date,   		
max(v.producer_status) producer_status    		
from public.vmfact_claimtransaction_blended f   		
join fsbi_dw_spinn.vdim_producer_lookup v    		
on f.producer_code=v.prdr_number    		
join tmp_da_spinn tmp_da  		
on f.claim_number=tmp_da.claim_number   		
and f.acct_date=tmp_da.acct_date    		
where (f.source_system='SPINN')   		
group by f.claim_number,    		
f.claimant,   		
f.feature   		
having LOB is not null;   		
    		
    		
/*--2.WINs based claims data -----------------------------------------------------------------------------------*/   		
drop table if exists tmp_dc_wins;  		
create temporary table tmp_dc_wins as   		
select distinct     		
f.claim_number,   		
f.claimant,   		
f.feature,    		
max(catastrophe_id) catastrophe_id,   		
max(loss_cause) loss_cause,   		
max(policy_state) policy_state,   		
max(company) company,   		
max(carrier) carrier,   		
max(policy_number) policy_number,   		
case    		
when upper(substring(max(policy_number),3,1))='A' then 'AU'   		
when upper(substring(max(policy_number),3,1))='B' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='E' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='F' then 'DF'   		
when upper(substring(max(policy_number),3,1))='H' then 'HO'   		
when upper(substring(max(policy_number),3,1))='M' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='Q' then 'OTH'    		
when upper(substring(max(policy_number),3,1))='R' then 'AU'   		
when upper(substring(max(policy_number),3,1))='U' then 'OTH'    		
end LOB , 		
max(policyref) policyref,   		
max(poleff_date) poleff_date,   		
max(polexp_date) polexp_date,   		
isnull(max(v.producer_status),'Unknown') producer_status    		
from public.vmfact_claimtransaction_blended f   		
left outer join fsbi_dw_spinn.vdim_producer_lookup v   		
on f.producer_code=v.prdr_number    		
join tmp_da_wins    tmp_da		
on f.claim_number=tmp_da.claim_number   		
and f.acct_date=tmp_da.acct_date    		
where (f.source_system='WINS')    		
group by f.claim_number,    		
f.claimant,   		
f.feature   		
having LOB is not null;   		
    		
/*--2.SPINN and WINs based claims data together-----------------------------------------------------------------------------------*/    		
drop table if exists tmp_dc;      		
create temporary table tmp_dc as    		
select *, 'SPINN' source_system from  tmp_dc_spinn  		
union all   		
select *, 'WINS' source_system from tmp_dc_wins;    		

/*-------------------------------------Only Liability or Property Claims----------------*/   		
drop table if exists tmp_only_liab_170; 		
create temporary table tmp_only_liab_170 as     		
with a as (select claim_number, claimant    		
from public.vmfact_claimtransaction_blended   		
group by claim_number, claimant   		
having count(distinct feature_type)=1)    		
select distinct f.claim_number,f.claimant   		
from public.vmfact_claimtransaction_blended f   		
join a    		
on f.claim_number=a.claim_number    		
and f.claimant=a.claimant   		
where f.aslob='170'   		
and f.feature_type='L';   		
    		
drop table if exists tmp_only_liab_040;     		
create temporary table tmp_only_liab_040 as     		
with a as (select claim_number, claimant    		
from public.vmfact_claimtransaction_blended   		
group by claim_number, claimant   		
having count(distinct feature_type)=1)    		
select distinct f.claim_number,f.claimant   		
from public.vmfact_claimtransaction_blended f   		
join a    		
on f.claim_number=a.claim_number    		
and f.claimant=a.claimant   		
where f.aslob='040'   		
and f.feature_type='L';   	
    		
/*-------------------------------------Reported Count is based on transactional level----------------*/   		
drop table if exists tmp_reported_count;  		
create temporary table tmp_reported_count as    		
select    		
f.claim_number,   		
f.claimant,   		
case    		
  when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map    		
  when substring(tmp_dc.Policy_number,3,1) in ('F','H') then    		
   case   		
    when pe.AltSubTypeCd='DF1' then '03'    		
    when pe.AltSubTypeCd='DF3' then '03'    		
    when pe.AltSubTypeCd='DF6' then '06'    		
    when pe.AltSubTypeCd='FL1-Basic' then '03'    		
    when pe.AltSubTypeCd='FL1-Vacant' then '03'   		
    when pe.AltSubTypeCd='FL2-Broad' then '03'    		
    when pe.AltSubTypeCd='FL3-Special' then '03'    		
    when pe.AltSubTypeCd='Form3' then '03'    		
    when pe.AltSubTypeCd='HO3' then '03'    		
    when pe.AltSubTypeCd='HO4' then '04'    		
    when pe.AltSubTypeCd='HO6' then '06'   		
    when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3' 		
    when pe.AltSubTypeCd='PA' then 'OTH'    		
   end    		
  else 'OTH'    		
 end Feature,   		
case    		
when f.aslob='010' then 'SP'    		
when f.aslob='021' then 'SP'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'SP'    		
when f.aslob='120' then 'SP'    		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'SP'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'AC'    		
end LOB2,   		
case    		
when f.aslob='010' then 'DF'    		
when f.aslob='021' then 'DF'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'OTH'   		
when f.aslob='120' then 'OTH'   		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'DF'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'APD'   		
end LOB3,   	
case    		
when f.aslob='010' then 'PROP'    		
when f.aslob='021' then 'PROP'    		 		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is not null then 'LIAB'   		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is  null then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040'  then 'LIAB'   		
when f.aslob='090' then 'PROP'    		
when f.aslob='120' then 'PROP'    		
when f.aslob='160' then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is  null then 'PROP'   		
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'    		
when f.aslob='191' then 'LIAB'    		
when f.aslob='192' then 'LIAB'    		
when f.aslob='211' then 'PROP'    		
when f.aslob='220' then 'PROP'    		
end FeatureType,    		
min(cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar)) quarter_id,   		
min(acct_date) reported_count_date    		
from public.vmfact_claimtransaction_blended f   		
join tmp_dc   		
on tmp_dc.claim_number=f.claim_number   		
left outer join covx    		
on f.feature=covx.feature   		
and f.feature_type=covx.feature_type    		
and f.aslob=covx.aslob    		
and f.rag=covx.rag    		
left outer join fsbi_dw_spinn.dim_policyextension pe    		
on tmp_dc.PolicyRef=pe.policy_uniqueid    		
and tmp_dc.source_system='SPINN'  
left outer join tmp_only_liab_170 l   		
on f.claim_number=l.claim_number    		
and f.claimant=l.claimant   		
left outer join tmp_only_liab_040 l040    		
on f.claim_number=l040.claim_number   		
and f.claimant=l040.claimant    
where f.acct_date>=dateadd(year,-12, GetDate())   		
and (   		
f.loss_paid>=0.5 or f.loss_reserve>=0.5 or f.aoo_paid>=0.5 or f.aoo_reserve>=0.5 or f.dcc_paid>=0.5 or f.dcc_reserve>=0.5 or f.salvage_received>=0.5 or f.subro_received>=0.5   		
)   		
group by    		
f.claim_number,   		
f.claimant,   		
case    		
  when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map    		
  when substring(tmp_dc.Policy_number,3,1) in ('F','H') then    		
   case   		
    when pe.AltSubTypeCd='DF1' then '03'    		
    when pe.AltSubTypeCd='DF3' then '03'    		
    when pe.AltSubTypeCd='DF6' then '06'    		
    when pe.AltSubTypeCd='FL1-Basic' then '03'    		
    when pe.AltSubTypeCd='FL1-Vacant' then '03'   		
    when pe.AltSubTypeCd='FL2-Broad' then '03'    		
    when pe.AltSubTypeCd='FL3-Special' then '03'    		
    when pe.AltSubTypeCd='Form3' then '03'    		
    when pe.AltSubTypeCd='HO3' then '03'    		
    when pe.AltSubTypeCd='HO4' then '04'    		
    when pe.AltSubTypeCd='HO6' then '06'   		
    when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3' 		
    when pe.AltSubTypeCd='PA' then 'OTH'     		
   end    		
  else 'OTH' 
  end,
  case    		
when f.aslob='010' then 'SP'    		
when f.aslob='021' then 'SP'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'SP'    		
when f.aslob='120' then 'SP'    		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'SP'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'AC'    		
end,   		
case    		
when f.aslob='010' then 'DF'    		
when f.aslob='021' then 'DF'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'OTH'   		
when f.aslob='120' then 'OTH'   		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'DF'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'APD'   		
end,   	
case    		
when f.aslob='010' then 'PROP'    		
when f.aslob='021' then 'PROP'    		 		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is not null then 'LIAB'   		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is  null then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040'  then 'LIAB'   		
when f.aslob='090' then 'PROP'    		
when f.aslob='120' then 'PROP'    		
when f.aslob='160' then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is  null then 'PROP'   		
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'    		
when f.aslob='191' then 'LIAB'    		
when f.aslob='192' then 'LIAB'    		
when f.aslob='211' then 'PROP'    		
when f.aslob='220' then 'PROP'    		
 end;   		


/*-------------------------------------Closed Count is based on transactional level----------------*/   		
drop table if exists tmp_closed_count;     		
create temporary table tmp_closed_count as    		
with data as (    		
select    		
f.claim_number,   		
f.claimant,   		
 case   		
  when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map    		
  when substring(tmp_dc.Policy_number,3,1) in ('F','H') then    		
   case   		
    when pe.AltSubTypeCd='DF1' then '03'    		
    when pe.AltSubTypeCd='DF3' then '03'    		
    when pe.AltSubTypeCd='DF6' then '06'    		
    when pe.AltSubTypeCd='FL1-Basic' then '03'    		
    when pe.AltSubTypeCd='FL1-Vacant' then '03'   		
    when pe.AltSubTypeCd='FL2-Broad' then '03'    		
    when pe.AltSubTypeCd='FL3-Special' then '03'    		
    when pe.AltSubTypeCd='Form3' then '03'    		
    when pe.AltSubTypeCd='HO3' then '03'    		
    when pe.AltSubTypeCd='HO4' then '04'    		
    when pe.AltSubTypeCd='HO6' then '06'   		
    when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3' 		
    when pe.AltSubTypeCd='PA' then 'OTH'   		
   end    		
  else 'OTH'    		
 end Feature,    		
case    		
when f.aslob='010' then 'SP'    		
when f.aslob='021' then 'SP'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'SP'    		
when f.aslob='120' then 'SP'    		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'SP'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'AC'    		
end LOB2,   		
case    		
when f.aslob='010' then 'DF'    		
when f.aslob='021' then 'DF'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'OTH'   		
when f.aslob='120' then 'OTH'   		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'DF'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'APD'   		
end LOB3,   	
case    		
when f.aslob='010' then 'PROP'    		
when f.aslob='021' then 'PROP'    		 		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is not null then 'LIAB'   		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is  null then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040'  then 'LIAB'   		
when f.aslob='090' then 'PROP'    		
when f.aslob='120' then 'PROP'    		
when f.aslob='160' then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is  null then 'PROP'   		
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'    		
when f.aslob='191' then 'LIAB'    		
when f.aslob='192' then 'LIAB'    		
when f.aslob='211' then 'PROP'    		
when f.aslob='220' then 'PROP'    		
end FeatureType,    
f.acct_date acct_date,    		
cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar) quarter_id,    		
sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve) trn_reserve   		
from public.vmfact_claimtransaction_blended f   		
join tmp_dc   		
on tmp_dc.claim_number=f.claim_number   		
left outer join covx    		
on f.feature=covx.feature   		
and f.feature_type=covx.feature_type    		
and f.aslob=covx.aslob    		
and f.rag=covx.rag    		
left outer join fsbi_dw_spinn.dim_policyextension pe    		
on tmp_dc.PolicyRef=pe.policy_uniqueid    		
and tmp_dc.source_system='SPINN'    	
left outer join tmp_only_liab_170 l   		
on f.claim_number=l.claim_number    		
and f.claimant=l.claimant   		
left outer join tmp_only_liab_040 l040    		
on f.claim_number=l040.claim_number   		
and f.claimant=l040.claimant    
where f.acct_date>=dateadd(year,-12, GetDate()) 
group by    		
f.claim_number,   		
f.claimant,   		
 case   		
  when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map    		
  when substring(tmp_dc.Policy_number,3,1) in ('F','H') then    		
   case   		
    when pe.AltSubTypeCd='DF1' then '03'    		
    when pe.AltSubTypeCd='DF3' then '03'    		
    when pe.AltSubTypeCd='DF6' then '06'    		
    when pe.AltSubTypeCd='FL1-Basic' then '03'    		
    when pe.AltSubTypeCd='FL1-Vacant' then '03'   		
    when pe.AltSubTypeCd='FL2-Broad' then '03'    		
    when pe.AltSubTypeCd='FL3-Special' then '03'    		
    when pe.AltSubTypeCd='Form3' then '03'    		
    when pe.AltSubTypeCd='HO3' then '03'    		
    when pe.AltSubTypeCd='HO4' then '04'    		
    when pe.AltSubTypeCd='HO6' then '06'   		
    when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3' 		
    when pe.AltSubTypeCd='PA' then 'OTH'    		
   end    		
  else 'OTH'    		
 end,   		
case    		
when f.aslob='010' then 'SP'    		
when f.aslob='021' then 'SP'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'SP'    		
when f.aslob='120' then 'SP'    		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'SP'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'AC'    		
end,   		
case    		
when f.aslob='010' then 'DF'    		
when f.aslob='021' then 'DF'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'OTH'   		
when f.aslob='120' then 'OTH'   		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'DF'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'APD'   		
end,   	
case    		
when f.aslob='010' then 'PROP'    		
when f.aslob='021' then 'PROP'    		 		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is not null then 'LIAB'   		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is  null then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040'  then 'LIAB'   		
when f.aslob='090' then 'PROP'    		
when f.aslob='120' then 'PROP'    		
when f.aslob='160' then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is  null then 'PROP'   		
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'    		
when f.aslob='191' then 'LIAB'    		
when f.aslob='192' then 'LIAB'    		
when f.aslob='211' then 'PROP'    		
when f.aslob='220' then 'PROP'    		
end,   
 f.acct_date,   		
 cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar)   		
 having   		
 sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve)<0.5    		
)   		
select    		
claim_number,   		
claimant,   		
feature,  
LOB2,
LOB3,
FeatureType,
max(quarter_id) quarter_id,   		
max(acct_date) closed_count_date    		
from data   		
group by    		
claim_number,   		
claimant,   		
feature,
LOB2,
LOB3,
FeatureType;  


  		
	
    		
/*-------------------------------------Main select with attributes on monthly level ----------------*/		
truncate table reporting.vmERIS_Claims;		
insert into reporting.vmERIS_Claims		   
with    		
/*Calendar Quterly summaries*/    		
data as (   		
select    		
datediff(qtr, isnull(cl.dateofloss,f.loss_date), m.mon_enddate)+1 DevQ_tmp,   		
m.mon_year,   		
m.mon_quarter,    		
cast(m.mon_year as varchar)+'0'+cast(m.mon_quarter as varchar) quarter_id,    		
isnull(cl.dateofloss,f.loss_date) loss_date,    		
f.reported_date,    		
tmp_dc.Carrier,   		
tmp_dc.Company,   		
tmp_dc.Policy_number,   		
tmp_dc.PolicyRef policy_uniqueid,   		
lpad(isnull(clr.clrsk_number,1),3,'0') RiskCd,    		
tmp_dc.poleff_date,   		
tmp_dc.polexp_date,   		
pe.RenewalTermCd,   		
case    		
 when tmp_dc.source_system='WINS' or p.pol_policynumbersuffix='~' then 'New'    		
 when p.pol_policynumbersuffix='00' then 'Renewal'    		
 when cast(isnull(p.pol_policynumbersuffix,'0') as int)<2 then 'New'    		
 else 'Renewal'   		
end policyneworrenewal,   		
tmp_dc.policy_state PolicyState,    		
tmp_dc.producer_status,   		
f.claim_number,   		
f.claimant,   		
case when tmp_dc.catastrophe_id is null then 'No' else 'Yes' end Cat_Indicator,   		
tmp_dc.LOB LOB,   		
case    		
when f.aslob='010' then 'SP'    		
when f.aslob='021' then 'SP'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'SP'    		
when f.aslob='120' then 'SP'    		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'SP'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'AC'    		
end LOB2,   		
case    		
when f.aslob='010' then 'DF'    		
when f.aslob='021' then 'DF'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'OTH'   		
when f.aslob='120' then 'OTH'   		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'DF'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'APD'   		
end LOB3,   		
case    		
when upper(substring(tmp_dc.Policy_number,3,1))='A' then 'AU'   		
when upper(substring(tmp_dc.Policy_number,3,1))='B' then 'BO'   		
when upper(substring(tmp_dc.Policy_number,3,1))='E' then 'EQ'   		
when upper(substring(tmp_dc.Policy_number,3,1))='F' then 'DF'   		
when upper(substring(tmp_dc.Policy_number,3,1))='H' then 'HO'   		
when upper(substring(tmp_dc.Policy_number,3,1))='M' then 'MH'   		
when upper(substring(tmp_dc.Policy_number,3,1))='Q' then 'EQ'   		
when upper(substring(tmp_dc.Policy_number,3,1))='R' then 'AU'   		
when upper(substring(tmp_dc.Policy_number,3,1))='U' then 'PU'   		
end Product,    		
pe.PolicyFormCode,    		
case    		
when tmp_dc.Company in ('0019') then 'Select'   		
when pe.ProgramInd='Non-Civil Servant' then 'NC'    		
when pe.ProgramInd='Civil Servant' then 'CS'    		
when pe.ProgramInd='Affinity Group' then 'AG'   		
when pe.ProgramInd='Educator' then 'ED'   		
when pe.ProgramInd='Firefighter' then 'FF'    		
when pe.ProgramInd='Law Enforcement' then 'LE'    		
else tmp_dc.LOB   		
end ProgramInd,   		
case    		
when f.aslob='010' then 'PROP'    		
when f.aslob='021' then 'PROP'    		 		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is not null then 'LIAB'   		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is  null then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040'  then 'LIAB'   		
when f.aslob='090' then 'PROP'    		
when f.aslob='120' then 'PROP'    		
when f.aslob='160' then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is  null then 'PROP'   		
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'    		
when f.aslob='191' then 'LIAB'    		
when f.aslob='192' then 'LIAB'    		
when f.aslob='211' then 'PROP'    		
when f.aslob='220' then 'PROP'    		
end FeatureType,    		
 case   		
  when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map    		
  when substring(tmp_dc.Policy_number,3,1) in ('F','H') then    		
   case   		
    when pe.AltSubTypeCd='DF1' then '03'    		
    when pe.AltSubTypeCd='DF3' then '03'    		
    when pe.AltSubTypeCd='DF6' then '06'    		
    when pe.AltSubTypeCd='FL1-Basic' then '03'    		
    when pe.AltSubTypeCd='FL1-Vacant' then '03'   		
    when pe.AltSubTypeCd='FL2-Broad' then '03'    		
    when pe.AltSubTypeCd='FL3-Special' then '03'    		
    when pe.AltSubTypeCd='Form3' then '03'    		
    when pe.AltSubTypeCd='HO3' then '03'    		
    when pe.AltSubTypeCd='HO4' then '04'    		
    when pe.AltSubTypeCd='HO6' then '06'   		
    when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3' 		
    when pe.AltSubTypeCd='PA' then 'OTH'    		
   end    		
  else 'OTH'    		
 end Feature,     		
sum(aoo_paid + dcc_paid) Paid_Expense , 		
sum(dcc_paid) Paid_DCC_Expense  , 		
sum(aoo_paid + aoo_reserve + dcc_paid + dcc_reserve) Incurred_Expense , 		
sum(dcc_paid + dcc_reserve) Incurred_dcc_Expense,   		
sum(salvage_received + subro_received) Salvage_and_subrogation,   		
sum(loss_paid) Paid_Loss  , 		
sum(loss_paid + loss_reserve) Incurred_Loss , 		
sum(loss_reserve + aoo_reserve + dcc_reserve) Reserve,    		
sum(loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received) Paid,    		
sum(loss_paid + loss_reserve + aoo_paid + dcc_paid) Incurred,   		
sum(loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received) Incurred_net_Salvage_Subrogation,   		
sum(loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve) total_incurred_loss,    		
sum(loss_paid + aoo_paid + dcc_paid) Loss_and_ALAE_for_Paid_count,    		
case    		
when Reserve=0 then 'Closed'    		
else 'Open' end Claim_Status  , 		
tmp_dc.source_system    ,		
pe.AltSubTypeCd		
from public.vmfact_claim_blended  f     		
join fsbi_dw_spinn.dim_month m    		
on f.month_id=m.month_id    		
join tmp_dc   		
on tmp_dc.claim_number=f.claim_number   		
and tmp_dc.claimant=f.claimant    		
and tmp_dc.feature=f.feature    		
left outer join covx    		
on f.feature=covx.feature   		
and f.feature_type=covx.feature_type    		
and f.aslob=covx.aslob    		
and f.rag=covx.rag    		
left outer join fsbi_dw_spinn.dim_policyextension pe    		
on tmp_dc.PolicyRef=pe.policy_uniqueid    		
and tmp_dc.source_system='SPINN'    		
left outer join fsbi_dw_spinn.dim_policy p    		
on tmp_dc.PolicyRef=p.pol_uniqueid    		
and tmp_dc.source_system='SPINN'    		
left outer join fsbi_dw_spinn.dim_claimrisk clr   		
on tmp_dc.claim_number=clr.claimnumber    		
and tmp_dc.source_system='SPINN'    		
left outer join (select distinct clm_claimnumber, dateofloss from fsbi_dw_spinn.dim_claim) cl   		
on tmp_dc.claim_number=cl.clm_claimnumber   		
and tmp_dc.source_system='SPINN'    		
left outer join tmp_only_liab_170 l   		
on f.claim_number=l.claim_number    		
and f.claimant=l.claimant   		
left outer join tmp_only_liab_040 l040    		
on f.claim_number=l040.claim_number   		
and f.claimant=l040.claimant    		
where m.mon_year>=DATE_PART(year,Getdate())-12    	
group by    		
datediff(qtr, isnull(cl.dateofloss,f.loss_date), m.mon_enddate)+1,    		
m.mon_year,   		
m.mon_quarter,    		
cast(m.mon_year as varchar)+'0'+cast(m.mon_quarter as varchar),   		
isnull(cl.dateofloss,f.loss_date),    		
f.reported_date,    		
tmp_dc.Carrier,   		
tmp_dc.Company,   		
tmp_dc.Policy_number,   		
tmp_dc.PolicyRef,   		
lpad(isnull(clr.clrsk_number,1),3,'0'),   		
tmp_dc.poleff_date,   		
tmp_dc.polexp_date,   		
pe.RenewalTermCd,   		
case    		
 when tmp_dc.source_system='WINS'  or p.pol_policynumbersuffix='~' then 'New'   		
 when p.pol_policynumbersuffix='00' then 'Renewal'    		
 when cast(isnull(p.pol_policynumbersuffix,'0') as int)<2 then 'New'    		
 else 'Renewal'   		
end,    		
tmp_dc.policy_state,    		
tmp_dc.producer_status,   		
f.claim_number,   		
f.claimant,   		
case when tmp_dc.catastrophe_id is null then 'No' else 'Yes' end,   		
tmp_dc.LOB,   		
case    		
when f.aslob='010' then 'SP'    		
when f.aslob='021' then 'SP'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'SP'    		
when f.aslob='120' then 'SP'    		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'SP'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'AC'    		
end,    		
case    		
when f.aslob='010' then 'DF'    		
when f.aslob='021' then 'DF'    		
when f.aslob='040' then 'HO'    		
when f.aslob='090' then 'OTH'   		
when f.aslob='120' then 'OTH'   		
when f.aslob='160' then 'HO'    		
when f.aslob='170' then 'DF'    		
when f.aslob='191' then 'AL'    		
when f.aslob='192' then 'AL'    		
when f.aslob='211' then 'APD'   		
when f.aslob='220' then 'APD'   		
end,    		
case    		
when upper(substring(tmp_dc.Policy_number,3,1))='A' then 'AU'   		
when upper(substring(tmp_dc.Policy_number,3,1))='B' then 'BO'   		
when upper(substring(tmp_dc.Policy_number,3,1))='E' then 'EQ'   		
when upper(substring(tmp_dc.Policy_number,3,1))='F' then 'DF'   		
when upper(substring(tmp_dc.Policy_number,3,1))='H' then 'HO'   		
when upper(substring(tmp_dc.Policy_number,3,1))='M' then 'MH'   		
when upper(substring(tmp_dc.Policy_number,3,1))='Q' then 'EQ'   		
when upper(substring(tmp_dc.Policy_number,3,1))='R' then 'AU'   		
when upper(substring(tmp_dc.Policy_number,3,1))='U' then 'PU'   		
end,    		
pe.AltSubTypeCd,  		
pe.policyformcode,  		
case    		
when tmp_dc.Company in ('0019') then 'Select'   		
when pe.ProgramInd='Non-Civil Servant' then 'NC'    		
when pe.ProgramInd='Civil Servant' then 'CS'    		
when pe.ProgramInd='Affinity Group' then 'AG'   		
when pe.ProgramInd='Educator' then 'ED'   		
when pe.ProgramInd='Firefighter' then 'FF'    		
when pe.ProgramInd='Law Enforcement' then 'LE'    		
else tmp_dc.LOB   		
end ,   		
case    		
when f.aslob='010' then 'PROP'    		
when f.aslob='021' then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is not null then 'LIAB'   		
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040'  and l040.claim_number is  null then 'PROP'    		
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040'  then 'LIAB'   		
when f.aslob='090' then 'PROP'    		
when f.aslob='120' then 'PROP'    		
when f.aslob='160' then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'    		
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is  null then 'PROP'   		
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'    		
when f.aslob='191' then 'LIAB'    		
when f.aslob='192' then 'LIAB'    		
when f.aslob='211' then 'PROP'    		
when f.aslob='220' then 'PROP'    		
end ,   		
 case   		
  when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map    		
  when substring(tmp_dc.Policy_number,3,1) in ('F','H') then    		
   case   		
    when pe.AltSubTypeCd='DF1' then '03'    		
    when pe.AltSubTypeCd='DF3' then '03'    		
    when pe.AltSubTypeCd='DF6' then '06'    		
    when pe.AltSubTypeCd='FL1-Basic' then '03'    		
    when pe.AltSubTypeCd='FL1-Vacant' then '03'   		
    when pe.AltSubTypeCd='FL2-Broad' then '03'    		
    when pe.AltSubTypeCd='FL3-Special' then '03'    		
    when pe.AltSubTypeCd='Form3' then '03'    		
    when pe.AltSubTypeCd='HO3' then '03'    		
    when pe.AltSubTypeCd='HO4' then '04'    		
    when pe.AltSubTypeCd='HO6' then '06'   		
    when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3' 		
    when pe.AltSubTypeCd='PA' then 'OTH'    		
   end    		
  else 'OTH'    		
 end,     		
tmp_dc.source_system,		
pe.AltSubTypeCd    		
)   		
/*DevQ with limit to 120month/40 Qtr*/    		
,data1 as (   		
select    		
case    		
when DevQ_tmp>=40 then 40   		
else DevQ_tmp   		
end DevQ,   		
d.*,    		
/*--Reported_Count is calculated at this level because later we loss quarter_id--*/   		
/*--last_closed_count_flg is calculated at this level because later we loss quarter_id--*/    		
/*--for final calculations based on last_closed_count_flg we need ITD which are calculated later*/    		
case when first_reported_count.quarter_id=d.quarter_id then 1 else 0 end Reported_Count,    		
case when last_closed_count.quarter_id=d.quarter_id then 'Y' else 'N' end last_closed_count_flg   		
from data d   		
/*-------------------------------*/   		
left outer join tmp_reported_count first_reported_count     		
on    		
d.claim_number = first_reported_count.claim_number and    		
d.claimant = first_reported_count.claimant and    		
d.feature = first_reported_count.feature  and
d.LOB2 = first_reported_count.LOB2 and
d.LOB3 = first_reported_count.LOB3 and
d.FeatureType = first_reported_count.FeatureType
/*-------------------------------*/   		
left outer join tmp_closed_count last_closed_count    		
on    		
d.claim_number = last_closed_count.claim_number and   		
d.claimant = last_closed_count.claimant and   		
d.feature = last_closed_count.feature and
d.LOB2 = last_closed_count.LOB2 and
d.LOB3 = last_closed_count.LOB3 and
d.FeatureType = last_closed_count.FeatureType
/*-------------------------------*/   		
)   		
/*DevQ summaries*/    		
,data2 as (   		
select    		
3*DevQ DevQ,    		
mon_year Reported_Year,   		
mon_quarter Reported_Qtr,   		
loss_date,    		
reported_date,    		
Carrier,    		
Company,    		
Policy_number,    		
policy_uniqueid,    		
RiskCd,   		
poleff_date,    		
polexp_date,    		
RenewalTermCd,    		
policyneworrenewal,   		
PolicyState,    		
producer_status,    		
d.claim_number,   		
d.claimant,   		
Cat_Indicator,    		
LOB,    		
LOB2,   		
LOB3,   		
Product,    		
PolicyFormCode,   		
ProgramInd,   		
FeatureType,    		
Feature,    		
Claim_Status,   		
source_system,    		
/*---------------------------------------------*/   		
/*---------------------------------------------*/   		
sum(Paid_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr  rows unbounded preceding) as ITD_Paid_Expense,    		
sum(Paid_DCC_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Paid_DCC_Expense,   		
sum(Paid_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Paid_Loss,   		
sum(Incurred) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Incurred,   		
sum(Incurred_net_Salvage_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Incurred_net_Salvage_Subrogation,   		
sum(total_incurred_loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr  rows unbounded preceding) as ITD_Total_Incurred_Loss,    		
sum(Reserve) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Reserve,   		
sum(Loss_and_ALAE_for_Paid_count) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Loss_and_ALAE_for_Paid_count,   		
sum(Salvage_and_subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Salvage_and_subrogation,   		
/*added 03/01/2022*/    		
itd_paid_loss+ itd_paid_expense- itd_salvage_and_subrogation ITD_PAID ,   		
/*---------------------------------------------*/   		
/*This analytical aggregation may not needed and prev aggregation can be used as is or we need it for modified DevQ (40?)*/   		
/*---------------------------------------------*/   		
sum(Paid_DCC_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_DCC_Expense,    		
sum(Paid_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_Expense,    		
sum(Incurred_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_Expense,    		
sum(Incurred_dcc_Expense)  over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_dcc_Expense,   		
sum(Salvage_and_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows  unbounded preceding) as QTD_Paid_Salvage_and_Subrogation,    		
sum(Paid_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_Loss,    		
sum(Incurred_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_Loss,    		
sum(Paid) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid,    		
sum(Incurred) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred,    		
sum(Incurred_net_Salvage_Subrogation)  over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_net_Salvage_Subrogation,   		
sum(Total_Incurred_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Total_Incurred_Loss,    		
/*---------------------------------------------*/   		
case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 250000) else 0 end X_ITD_Incurred_net_Salvage_Subrogation_250k,   		
case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 500000) else 0 end X_ITD_Incurred_net_Salvage_Subrogation_500k,   		
/*---------------------------------------------*/   		
Reported_Count,   		
case when last_closed_count_flg='Y' then 1 else 0 end Closed_Count,   		
case when last_closed_count_flg='Y' and ITD_Paid_Loss + ITD_Paid_Expense<=0 then 1 else 0 end Closed_NoPay,   		
case when last_closed_count_flg='Y'  then ITD_Paid_Loss else 0 end Paid_On_Closed_Loss,   		
case when last_closed_count_flg='Y'  then ITD_Paid_Expense else 0 end Paid_On_Closed_Expense,   		
case when last_closed_count_flg='Y'  then ITD_Paid_DCC_Expense else 0 end Paid_On_Closed_DCC_Expense  , 		
case when last_closed_count_flg='Y'  then ITD_Salvage_and_subrogation else 0 end Paid_On_Closed_Salvage_Subrogation  ,		
AltSubTypeCd 		
from data1  d 		
)   		
/*One more level for analytical functions*/   		
,data3 as (   		
select    		
DevQ,   		
Reported_Year,    		
Reported_Qtr,   		
loss_date,    		
reported_date,    		
Carrier,    		
Company,    		
Policy_number,    		
policy_uniqueid,    		
RiskCd,   		
poleff_date,    		
polexp_date,    		
RenewalTermCd,    		
policyneworrenewal,   		
PolicyState,    		
producer_status,    		
claim_number,   		
claimant,   		
Cat_Indicator,    		
LOB,    		
LOB2,   		
LOB3,   		
Product,    		
PolicyFormCode,   		
ProgramInd,   		
FeatureType,    		
Feature,    		
Claim_Status,   		
source_system,    		
/*---------------------------------------------*/   		
ITD_Paid_Expense,   		
ITD_Paid_DCC_Expense,   		
ITD_Paid_Loss,    		
ITD_Incurred,   		
ITD_Incurred_net_Salvage_Subrogation,   		
isnull(lag(ITD_Incurred_net_Salvage_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr),0) prev_ITD_Incurred_net_Salvage_Subrogation,    		
ITD_Total_Incurred_Loss,    		
ITD_Reserve,    		
ITD_Loss_and_ALAE_for_Paid_count,   		
ITD_Salvage_and_subrogation,    		
ITD_PAID ,    		
isnull(lag(ITD_PAID) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr),0) prev_ITD_PAID,    		
/*---------------------------------------------*/   		
QTD_Paid_DCC_Expense,   		
QTD_Paid_Expense,   		
QTD_Incurred_Expense,   		
QTD_Incurred_dcc_Expense,   		
QTD_Paid_Salvage_and_Subrogation,   		
QTD_Paid_Loss,    		
QTD_Incurred_Loss,    		
QTD_Paid,   		
QTD_Incurred,   		
QTD_Incurred_net_Salvage_Subrogation,   		
QTD_Total_Incurred_Loss,    		
/*---------------------------------------------*/   		
/*---------------------------------------------*/   		
least(25000,ITD_PAID) - least(25000,prev_ITD_PAID) QTD_Paid_25k,    		
least(50000,ITD_PAID) - least(50000,prev_ITD_PAID) QTD_Paid_50k,    		
least(100000,ITD_PAID) - least(100000,prev_ITD_PAID) QTD_Paid_100k,   		
least(250000,ITD_PAID) - least(250000,prev_ITD_PAID) QTD_Paid_250k,   		
least(500000,ITD_PAID) - least(500000,prev_ITD_PAID) QTD_Paid_500k,   		
least(1000000,ITD_PAID) - least(1000000,prev_ITD_PAID) QTD_Paid_1M,   		
/*---------------------------------------------*/   		
least(25000,ITD_Incurred_net_Salvage_Subrogation) - least(25000,prev_ITD_Incurred_net_Salvage_Subrogation)  QTD_Incurred_net_Salvage_Subrogation_25k,   		
least(50000,ITD_Incurred_net_Salvage_Subrogation) - least(50000,prev_ITD_Incurred_net_Salvage_Subrogation)  QTD_Incurred_net_Salvage_Subrogation_50k,   		
least(100000,ITD_Incurred_net_Salvage_Subrogation) - least(100000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_100k,   		
least(250000,ITD_Incurred_net_Salvage_Subrogation) - least(250000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_250k,   		
least(500000,ITD_Incurred_net_Salvage_Subrogation) - least(500000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_500k,   		
least(1000000,ITD_Incurred_net_Salvage_Subrogation) - least(1000000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_1M,   		
/*---------------------------------------------*/   		
X_ITD_Incurred_net_Salvage_Subrogation_250k,    		
X_ITD_Incurred_net_Salvage_Subrogation_500k,    		
/*---------------------------------------------*/   		
Reported_Count,   			
sum(Reported_Count) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType ORDER BY reported_year, reported_qtr rows unbounded preceding) isReported,		
case when isReported=1 then Closed_Count else 0 end Closed_Count,   		
case when isReported=1 then Closed_NoPay  else 0 end  Closed_NoPay,		
Paid_On_Closed_Loss,    		
Paid_On_Closed_Expense,   		
Paid_On_Closed_DCC_Expense  , 		
Paid_On_Closed_Salvage_Subrogation  , 		
case    		
 when  min(case when ITD_Loss_and_ALAE_for_Paid_count>0 then concat(reported_year, reported_qtr) end) over(partition by claim_number, claimant, feature, LOB2, LOB3, FeatureType)=concat(reported_year, reported_qtr) 		
 then 1   		
 else 0     		
end Paid_Count  ,		
AltSubTypeCd  		
from data2 d    		
)   		
/*final*/   		
select    		
DevQ,   		
Reported_Year,    		
Reported_Qtr,   		
loss_date,    		
reported_date,    		
Carrier,    		
Company,    		
Policy_number,    		
policy_uniqueid,    		
RiskCd,   		
poleff_date,    		
polexp_date,    		
RenewalTermCd,    		
policyneworrenewal,   		
PolicyState,    		
producer_status,    		
claim_number,   		
claimant,   		
Cat_Indicator,    		
LOB,    		
LOB2,   		
LOB3,   		
Product,    		
PolicyFormCode,   		
ProgramInd,   		
FeatureType,    		
Feature,    		
Claim_Status,   		
source_system,    		
/*---------------------------------------------*/   		
ITD_Paid_Expense,   		
ITD_Paid_DCC_Expense,   		
ITD_Paid_Loss,    		
ITD_Incurred,   		
ITD_Incurred_net_Salvage_Subrogation,   		
ITD_Total_Incurred_Loss,    		
ITD_Reserve,    		
ITD_Loss_and_ALAE_for_Paid_count,   		
ITD_Salvage_and_subrogation,    		
/*---------------------------------------------*/   		
QTD_Paid_DCC_Expense,   		
QTD_Paid_Expense,   		
QTD_Incurred_Expense,   		
QTD_Incurred_dcc_Expense,   		
QTD_Paid_Salvage_and_Subrogation,   		
QTD_Paid_Loss,    		
QTD_Incurred_Loss,    		
QTD_Paid,   		
QTD_Incurred,   		
QTD_Incurred_net_Salvage_Subrogation,   		
QTD_Total_Incurred_Loss,    		
/*---------------------------------------------*/   		
/*---------------------------------------------*/   		
QTD_Paid_25k,   		
QTD_Paid_50k,   		
QTD_Paid_100k,    		
QTD_Paid_250k,    		
QTD_Paid_500k,    		
QTD_Paid_1M,    		
/*---------------------------------------------*/   		
QTD_Incurred_net_Salvage_Subrogation_25k,   		
QTD_Incurred_net_Salvage_Subrogation_50k,   		
QTD_Incurred_net_Salvage_Subrogation_100k,    		
QTD_Incurred_net_Salvage_Subrogation_250k,    		
QTD_Incurred_net_Salvage_Subrogation_500k,    		
QTD_Incurred_net_Salvage_Subrogation_1M,    		
/*---------------------------------------------*/   		
X_ITD_Incurred_net_Salvage_Subrogation_250k,    		
X_ITD_Incurred_net_Salvage_Subrogation_500k,    		
/*---------------------------------------------*/   		
Reported_Count,   		
Closed_Count,   		
Closed_NoPay,   		
Paid_On_Closed_Loss,    		
Paid_On_Closed_Expense,   		
Paid_On_Closed_DCC_Expense  , 		
Paid_On_Closed_Salvage_Subrogation  , 
/*2022-03-31 If a claim has closed_count or closed_nopay = 1 and reported_count = 0 then set closed_count or closed_nopay to 0 as well.*/	
case when sum(Closed_NoPay) over(partition by claim_number, claimant, feature, LOB2, LOB3, FeatureType)=0 then Paid_Count else 0 end Paid_Count,   		
pLoadDate LoadDate,    		
ITD_PAID ,		
AltSubTypeCd 		
from data3 d    		
order by DevQ,claim_number,claimant,feature;		

		
END;		




$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_eris_policies(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
	
	
BEGIN
/*full load takes 3 min*/
/*dim_policy_extension is a combination of dim_policy with dim_policyextension
with additional calculated fields (LOB) 
plus rate changes coefficients which are applied based on effective date and coverages
There are more lines per policy then just one in dim_policy
It depends on ERIS coverages*/
/*Because there is no regular aggregation function for multiplicateion 
- EXP(SUM(of lograthim LN)) is used*/
create temporary table dim_policy_extended as 
select 
p.policy_id,
p.pol_policynumber,
p.pol_uniqueid,
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_masterstate,
case 
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='E' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'OTH'
end LOB,
isnull(r.coverage,'All') coverage,
isnull(EXP(SUM(LN(cast((1+r.renewal_change/100) as float)))),1) renewal_change,
isnull(EXP(SUM(LN(cast((1+r.nb_change/100) as float)))),1) nb_change
from fsbi_dw_spinn.dim_policy p
join fsbi_dw_spinn.dim_policyextension pe 
on p.policy_id=pe.policy_id
join fsbi_dw_spinn.vdim_company co
on p.company_id=co.company_id
left outer join external_data_pricing.eris_ratechange r
on  r.startdt>pol_effectivedate
and r.carriercd=co.comp_name1
and r.AltSubTypeCd=pe.AltSubTypeCd
and r.statecd=p.pol_masterstate
where  upper(substring(p.pol_policynumber,3,1)) in ('A',
'B',
'E',
'F',
'H',
'M',
'Q',
'R',
'U' )
group by
p.policy_id,
p.pol_policynumber,
p.pol_uniqueid,
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_masterstate,
case 
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='E' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'OTH'
end,
isnull(r.coverage,'All');



/*main part*/
truncate table reporting.vmERIS_Policies;
insert into reporting.vmERIS_Policies 
select
m.mon_year report_year,
m.mon_quarter report_quarter,
p.pol_policynumber Policynumber,
p.policy_id,
p.pol_uniqueid policy_uniqueid,
lpad(cr.cvrsk_number,3,'0') RiskCd,
p.pol_policynumbersuffix PolicyVersion,
p.pol_effectivedate effectivedate,
p.pol_expirationdate expirationdate,
pe.RenewalTermCd,
f.policyneworrenewal,
p.pol_masterstate PolicyState,
co.comp_number CompanyNumber,
co.comp_name1 Company,
p.LOB,
c.cov_asl ASL,
case
when c.cov_asl='010' then 'SP'
when c.cov_asl='021' then 'SP'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'SP'
when c.cov_asl='120' then 'SP'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'SP'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'AC'
end LOB2,
case
when c.cov_asl='010' then 'DF'
when c.cov_asl='021' then 'DF'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'OTH'
when c.cov_asl='120' then 'OTH'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'DF'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'APD'
end LOB3,
case
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'BO'
when upper(substring(p.pol_policynumber,3,1))='E' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'MH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'PU'
end Product,
pe.PolicyFormCode,
case 
when co.comp_number in ('0019') then 'Select'
when pe.ProgramInd='Non-Civil Servant' then 'NC'
when pe.ProgramInd='Civil Servant' then 'CS'
when pe.ProgramInd='Affinity Group' then 'AG'
when pe.ProgramInd='Educator' then 'ED'
when pe.ProgramInd='Firefighter' then 'FF'
when pe.ProgramInd='Law Enforcement' then 'LE'
else p.LOB
end ProgramInd,
pr.producer_status,
case
when c.cov_asl='010' then 'PROP'
when c.cov_asl='021' then 'PROP'
when c.cov_asl='040' then 'PROP'
when c.cov_asl='090' then 'PROP'
when c.cov_asl='120' then 'PROP'
when c.cov_asl='160' then 'LIAB'
when c.cov_asl='170' then 'LIAB'
when c.cov_asl='191' then 'LIAB'
when c.cov_asl='192' then 'LIAB'
when c.cov_asl='211' then 'PROP'
when c.cov_asl='220' then 'PROP'
end CoverageType,
case when ce.codetype='Fee' then 'Fee' 
else 
 case
  when substring(p.pol_policynumber,3,1)='A' then isnull(ce.Act_ERIS,'OTH')
  when substring(p.pol_policynumber,3,1) in ('F','H') then
   case
    when pe.AltSubTypeCd='DF1' then '03'
    when pe.AltSubTypeCd='DF3' then '03'
    when pe.AltSubTypeCd='DF6' then '06'
    when pe.AltSubTypeCd='FL1-Basic' then '03'
    when pe.AltSubTypeCd='FL1-Vacant' then '03'
    when pe.AltSubTypeCd='FL2-Broad' then '03'
    when pe.AltSubTypeCd='FL3-Special' then '03'
    when pe.AltSubTypeCd='Form3' then '03'
    when pe.AltSubTypeCd like 'HO3%' then '03'
    when pe.AltSubTypeCd='HO4' then '04'
    when pe.AltSubTypeCd='HO6' then '06'
    when pe.AltSubTypeCd='PA' then 'OTH'
   end
  else 'OTH'
 end
end Coverage,
case when ce.codetype='Fee' then 'Y' else 'N' end FeeInd,
'SPINN' Source,
sum(wrtn_prem_amt + fees_amt) WP,
sum(earned_prem_amt) EP,
sum(case
 when f.policyneworrenewal='New' then p.nb_change*earned_prem_amt
 else p.renewal_change*earned_prem_amt
end) CLEP,
sum(
case
 when c.cov_code in ('F.30005B','F.31580A') then round(ee_rm/12,3) /*Umbrella*/
 when pe.AltSubTypeCd='PB' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*Boatowners - boats - CovA and Trailers covC*/
 when pe.AltSubTypeCd='EQ' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*In Earthquake policies if there are both CovA and CovC, then CovC do not have exposures*/
 when pe.AltSubTypeCd = 'DF3' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode<>'WF-DWELL') then round(ee_rm/12,3) 
 when pe.AltSubTypeCd = 'HO3-Homeguard' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode='EXWF-DWELL') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('DF6','DF1', 'FL1-Basic', 'FL1-Vacant', 'FL2-Broad', 'FL3-Special', 'Form3', 'HO3') and (c.cov_subline in ('410','402') and ce.covx_code='CovA') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('HO4', 'HO6') and ce.covx_code='CovC' then round(ee_rm/12,3)
 when substring(p.pol_policynumber,3,1)='A' and  (ce.covx_code in ('BI', 'COMP', 'COLL','MEDPAY', 'PD','RREIM', 'ROAD', 'UM','UMBI', 'UMPD' ) or isnull(ce.Act_ERIS,'OTH')='OTH') then round(ee_rm/12,3)
else 0
end
)  EE,
pLoadDate LoadDate,
pe.AltSubTypeCd
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_policyextension pe
on f.policy_id=pe.policy_id
join fsbi_dw_spinn.vdim_company co
on f.company_id=co.company_id
join fsbi_dw_spinn.dim_coverage c
on f.coverage_id=c.coverage_id
left outer join public.dim_coverageextension ce
on c.coverage_id=ce.coverage_id
join dim_policy_extended p
on f.policy_id=p.policy_id
and (isnull(ce.Act_ERIS,'OTH')=p.coverage or p.coverage='All')
join fsbi_dw_spinn.vdim_producer pr
on f.producer_id=pr.producer_id
join fsbi_dw_spinn.dim_month m
on f.month_id=m.month_id
join fsbi_dw_spinn.dim_coveredrisk cr
on f.primaryrisk_id=cr.coveredrisk_id
/*Only "meaningfull" coverages from ratin. The results of this join will help to filter out duplicates */
left outer join dim_policy_extended r
on f.policy_id=r.policy_id
and isnull(ce.Act_ERIS,'OTH')=r.coverage
where m.mon_year>cast(to_char(GetDate(),'yyyy') as int) - 12 
/*keep coverages only once*/
and not (p.coverage='All' and isnull(ce.Act_ERIS,'OTH')=isnull(r.coverage,'N/A'))
group by
m.mon_year,
m.mon_quarter,
p.pol_policynumber,
p.policy_id,
p.pol_uniqueid,
lpad(cr.cvrsk_number,3,'0'),
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
pe.RenewalTermCd,
f.policyneworrenewal,
p.pol_masterstate,
co.comp_number,
co.comp_name1,
p.LOB ,
c.cov_asl,
case
when c.cov_asl='010' then 'SP'
when c.cov_asl='021' then 'SP'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'SP'
when c.cov_asl='120' then 'SP'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'SP'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'AC'
end,
case
when c.cov_asl='010' then 'DF'
when c.cov_asl='021' then 'DF'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'OTH'
when c.cov_asl='120' then 'OTH'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'DF'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'APD'
end,
case
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'BO'
when upper(substring(p.pol_policynumber,3,1))='E' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'MH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'PU'
end,
pe.PolicyFormCode,
case 
when co.comp_number in ('0019') then 'Select'
when pe.ProgramInd='Non-Civil Servant' then 'NC'
when pe.ProgramInd='Civil Servant' then 'CS'
when pe.ProgramInd='Affinity Group' then 'AG'
when pe.ProgramInd='Educator' then 'ED'
when pe.ProgramInd='Firefighter' then 'FF'
when pe.ProgramInd='Law Enforcement' then 'LE'
else p.LOB
end,
pr.producer_status,
case
when c.cov_asl='010' then 'PROP'
when c.cov_asl='021' then 'PROP'
when c.cov_asl='040' then 'PROP'
when c.cov_asl='090' then 'PROP'
when c.cov_asl='120' then 'PROP'
when c.cov_asl='160' then 'LIAB'
when c.cov_asl='170' then 'LIAB'
when c.cov_asl='191' then 'LIAB'
when c.cov_asl='192' then 'LIAB'
when c.cov_asl='211' then 'PROP'
when c.cov_asl='220' then 'PROP'
end,
case when ce.codetype='Fee' then 'Fee' 
else 
 case
  when substring(p.pol_policynumber,3,1)='A' then isnull(ce.Act_ERIS,'OTH')
  when substring(p.pol_policynumber,3,1) in ('F','H') then
   case
    when pe.AltSubTypeCd='DF1' then '03'
    when pe.AltSubTypeCd='DF3' then '03'
    when pe.AltSubTypeCd='DF6' then '06'
    when pe.AltSubTypeCd='FL1-Basic' then '03'
    when pe.AltSubTypeCd='FL1-Vacant' then '03'
    when pe.AltSubTypeCd='FL2-Broad' then '03'
    when pe.AltSubTypeCd='FL3-Special' then '03'
    when pe.AltSubTypeCd='Form3' then '03'
    when pe.AltSubTypeCd like 'HO3%' then '03'
    when pe.AltSubTypeCd='HO4' then '04'
    when pe.AltSubTypeCd='HO6' then '06'
    when pe.AltSubTypeCd='PA' then 'OTH'
   end
  else 'OTH'
 end
end ,
case when ce.codetype='Fee' then 'Y' else 'N' end,
pe.AltSubTypeCd
having sum(wrtn_prem_amt + fees_amt)<>0 or sum(earned_prem_amt)<>0 or sum(ee_rm)<>0
order by report_year, report_quarter;

END;



$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_exposures_spinn()
	LANGUAGE plpgsql
AS $$
		
	
BEGIN 	

/*Incremental Load - update exposures only in a current month(s)*/

/*2. calculate exposures for all policy terms from incremental (month) part in all months*/		
/*==========================================Part 1 month/1 exposure ===================================================================*/		
/*2.1 One (1) month/1 exposure first*/		
/*2.1.1 Written exposure*/		
create temporary table WE_data1 as		
select		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
case 		
when f.term_amount<0 then -datediff(month, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate) 		
when f.term_amount=0 then 0		
else datediff(month, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate)		
end WE		
from fsbi_dw_spinn.fact_policytransaction f		 
join fsbi_dw_spinn.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_spinn.dim_policy p		
on f.policy_id=p.policy_id		
join fsbi_dw_spinn.dim_policyextension pe		
on f.policy_id=pe.policy_id		
join fsbi_dw_spinn.dim_policytransactiontype dptt 		
on f.POLICYTRANSACTIONTYPE_ID = dptt.POLICYTRANSACTIONTYPE_ID		
and dptt.ptrans_writtenprem = '+'		
join fsbi_dw_spinn.dim_time t		
on f.accountingdate_id=t.time_id		
where lower(c.cov_code) not like '%fee%'		
/*only policy terms from the incremental part*/		
and f.policy_id in (select policy_id from fsbi_stg_spinn.fact_policycoverage);		
		
/*2.1.2 Written exposure aggregated. Maybe not needed step*/		
create temporary table WE1 as		
select 		
month_id,		
policy_id, 		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
sum(WE) WE		
from we_data1		
group by 		
month_id,		
coverage_id,		
coverage_uniqueid,		
policy_id,		
policy_uniqueid ;		
		
/*2.1.3 For earned exposures and joining to fact_policycoverage we need months*/		
create temporary table mtd_data1 as 		
Select		
factpolicycoverage_id,		
month_id,		
row_number() over (partition by f.policy_id,f.coverage_id,f.coverage_uniqueid order by f.month_id) as month_num,		
f.policy_id, 		
f.policy_uniqueid,		
f.coverage_uniqueid,		
f.coverage_id,		
wrtn_prem_amt WP,		
earned_prem_amt EP	,	
pol_effectivedate,		
pol_expirationdate		
from fsbi_dw_spinn.fact_policycoverage f		
join fsbi_dw_spinn.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_spinn.dim_policy p		
on f.policy_id=p.policy_id		
where lower(c.cov_code) not like '%fee%'		
/*only policy terms from the incremental part*/		
and f.policy_id in (select policy_id from fsbi_stg_spinn.fact_policycoverage);		
		
/*2.1.4 unearned exposure, adjusting data with Diff for backdated transactions */		
create temporary table mtd1 as 		
select 		
factpolicycoverage_id,		
month_num,		
e.month_id,		
e.policy_id,		
e.policy_uniqueid,		
e.coverage_id,		
e.coverage_uniqueid,		
WP,		
EP,		
isnull(WE.WE,0) WE,		
case when e.month_id=we.month_id then WE else 0 end WE_adj,		
case 		
 when cast(cast(e.month_id as varchar)+'01'  as date)>e.pol_expirationdate then 0 --accounting date AFTER expiration		
 when month_num=1 and e.month_id > cast(to_char(e.pol_effectivedate, 'YYYYMM') as int) then 		
  isnull(datediff(month,e.pol_effectivedate,dateadd(day,-1,dateadd(month,1,cast(cast(e.month_id as varchar)+'01'  as date)))) - 1,0) 		
 else 0 		
end  Diff,		
sum(isnull(Diff,0)) over (partition by e.policy_id,e.coverage_id,e.coverage_uniqueid order by e.month_id rows unbounded preceding) Diff_ITD,		
sum(isnull(WE.WE,0)) over (partition by e.policy_id,e.coverage_id,e.coverage_uniqueid order by e.month_id rows unbounded preceding) WE_ITD,		
case 		
 when cast(cast(e.month_id as varchar)+'01'  as date)>e.pol_expirationdate then 0		
 when WE_ITD - month_num - Diff_ITD <0 then 0		
 else WE_ITD - month_num - Diff_ITD		
end  UE_ITD 		
from mtd_data1	e	
left outer join WE1 WE		
on e.month_id=WE.month_id		
and e.policy_id=WE.policy_id		
and e.coverage_id=WE.coverage_id		
and e.coverage_uniqueid=WE.coverage_uniqueid;		
		
/*2.1.5 earned exposure*/		
create temporary table mtd_term1 as select		
factpolicycoverage_id,		
month_num,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WP,		
EP,		
WE,		
WE_adj,		
WE_ITD,		
UE_ITD,		
isnull(lag(UE_ITD) over (partition by policy_id,coverage_id,coverage_uniqueid order by month_id),0) - UE_ITD + WE_adj  EE 		
from mtd1;		
		
/*==========================================Part 2 1 month/partial exposure based on dates ===================================================================*/		
/*2.2 One(1) month/partial exposure based on dates*/		
/*2.2.1 Written exposure*/		
create temporary table WE2 as 		
select		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
sum(case 		
when f.term_amount<0 then -datediff(day, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate) 		
when f.term_amount=0 then 0		
else datediff(day, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate)		
end/case when  pe.TermDays = 366 then 30.5 else 30.417 end) WE,		
p.pol_expirationdate expirationdate,		
cast(cast(effectivedate_id as varchar) as date) effectivedate		
from fsbi_dw_spinn.fact_policytransaction f		 
join fsbi_dw_spinn.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_spinn.dim_policy p		
on f.policy_id=p.policy_id		
join fsbi_dw_spinn.dim_policyextension pe		
on f.policy_id=pe.policy_id		
join fsbi_dw_spinn.dim_policytransactiontype dptt 		
on f.POLICYTRANSACTIONTYPE_ID = dptt.POLICYTRANSACTIONTYPE_ID		
and dptt.ptrans_writtenprem = '+'		
join fsbi_dw_spinn.dim_time t		
on f.accountingdate_id=t.time_id		
where lower(c.cov_code) not like '%fee%'		
/*only policy terms from the incremental part*/		
and f.policy_id in (select policy_id from fsbi_stg_spinn.fact_policycoverage)		
group by		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
p.pol_expirationdate,		
cast(cast(effectivedate_id as varchar) as date);		
		
/*2.2.2 For earned exposures and joining to fact_policycoverage we need months*/		
create temporary table mtd_data2 as 		
Select		
f.factpolicycoverage_id,		
f.month_id,		
m.mon_enddate,		
f.policy_id, 		
f.policy_uniqueid,		
f.coverage_uniqueid,		
f.coverage_id,		
wrtn_prem_amt WP,		
earned_prem_amt EP		
from fsbi_dw_spinn.fact_policycoverage f		
join fsbi_dw_spinn.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_spinn.dim_month m		
on f.month_id=m.month_id		
where lower(c.cov_code) not like '%fee%'		
/*only policy terms from the incremental part*/		
and f.policy_id in (select policy_id from fsbi_stg_spinn.fact_policycoverage)	;	
		
/*2.2.3 UnearnedFactor  based on days */		
create temporary table mtd2 as 		
select 		
factpolicycoverage_id,		
e.month_id,		
e.policy_id,		
e.policy_uniqueid,		
e.coverage_id,		
e.coverage_uniqueid,		
WP,		
EP,		
WE,		
case when e.month_id=we.month_id then WE else 0 end WE_adj,		
mon_enddate,		
WE.expirationdate,		
WE.effectivedate,		
case 		
when WE.expirationdate <= mon_enddate then 0		
when effectivedate> mon_enddate then 1		
else round((cast(datediff(day, mon_enddate,  expirationdate) as float) - 1.000)/cast(datediff(day, effectivedate,  expirationdate) as float),5)		
end UnearnedFactor		
from mtd_data2	e	
join WE2 WE		
on e.policy_id=WE.policy_id		
and e.coverage_id=WE.coverage_id		
and e.coverage_uniqueid=WE.coverage_uniqueid		
and WE.month_id<=e.month_id;		
		
/*2.2.4 Unearned Exposure */		
create temporary table mtd_term2_1 as		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
UnearnedFactor,		
sum(WE) WE,		
sum(WE_adj) WE_adj,		
sum(WE)*UnearnedFactor UE		
from mtd2		
group by		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
UnearnedFactor;		
		
/*2.2.5 Aggregating Unearned Exposure */		
create temporary table mtd_term2_2 as 		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
sum(WE_adj) WE,		
sum(UE) UE		
from mtd_term2_1		
group by factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid		
order by month_id;		
		
/*2.2.6 Earned Exposure */		
create temporary table mtd_term2 as 		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WE,		
UE	,	
lag(UE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid,month_id) UE_PRIOR,		
isnull(UE_PRIOR,0) - UE + WE EE		
from mtd_term2_2		
order by month_id;		
		
		
		
/*============================================================= FINAL =============================================================*/		
delete from fsbi_stg_spinn.stg_exposures where month_id in (select month_id from fsbi_stg_spinn.fact_policycoverage);		
insert into fsbi_stg_spinn.stg_exposures		
select 		
mtd_term1.factpolicycoverage_id,		
mtd_term1.month_id,		
mtd_term1.policy_id,		
mtd_term1.policy_uniqueid,		
mtd_term1.coverage_id,		
mtd_term1.coverage_uniqueid,		
mtd_term1.WE WE,		
mtd_term1.EE EE,		
null WE_YTD,		
null EE_YTD,		
null WE_ITD,		
null EE_ITD, 		
isnull(mtd_term2.WE,0) WE_RM,		
isnull(mtd_term2.EE,0) EE_RM,		
null WE_RM_YTD,		
null EE_RM_YTD,		
null WE_RM_ITD,		
null EE_RM_ITD		
from mtd_term1		
left outer join mtd_term2 on		
mtd_term1.factpolicycoverage_id=mtd_term2.factpolicycoverage_id		
where mtd_term1.month_id in (select month_id from fsbi_stg_spinn.fact_policycoverage);		
		
/*============================================================= YTD and ITD =============================================================*/		
		
create temporary table tmp_exposures as		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WE,		
EE,		
sum(WE) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) WE_YTD,		
sum(EE) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_YTD,		
sum(WE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding)  WE_ITD,		
sum(EE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_ITD, 		
WE_RM,		
EE_RM,		
sum(WE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) WE_RM_YTD,		
sum(EE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_RM_YTD,		
sum(WE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding)  WE_RM_ITD,		
sum(EE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_RM_ITD		
from fsbi_stg_spinn.stg_exposures		
where policy_id in (select policy_id from fsbi_stg_spinn.fact_policycoverage);		
		
update fsbi_stg_spinn.stg_exposures		
set 		
 WE_YTD=t.WE_YTD		
,EE_YTD=t.EE_YTD		
,WE_ITD=t.WE_ITD		
,EE_ITD=t.EE_ITD		
,WE_RM_YTD=t.WE_RM_YTD		
,EE_RM_YTD=t.EE_RM_YTD		
,WE_RM_ITD=t.WE_RM_ITD		
,EE_RM_ITD=t.EE_RM_ITD		
from tmp_exposures t		
join fsbi_stg_spinn.stg_exposures e		
on t.factpolicycoverage_id=e.factpolicycoverage_id;		
		
		
/*=============================================================FACT_POLICYCOVERAGE Update =============================================================*/		
		
update fsbi_dw_spinn.fact_policycoverage		
set		
we = e.we,		
ee = e.ee,		
we_ytd = e.we_ytd, 		
ee_ytd  = e.ee_ytd,		
we_itd  = e.we_itd,		
ee_itd  = e.ee_itd,		
we_rm  = e.we_rm,		
ee_rm  = e.ee_rm,		
we_rm_ytd  = e.we_rm_ytd,		
ee_rm_ytd  = e.ee_rm_ytd,		
we_rm_itd  = e.we_rm_itd,		
ee_rm_itd  = e.ee_rm_itd		
from fsbi_dw_spinn.fact_policycoverage f		
join fsbi_stg_spinn.stg_exposures e		
on f.factpolicycoverage_id=e.factpolicycoverage_id		
and f.policy_id=e.policy_id		
where e.month_id in (select month_id from fsbi_stg_spinn.fact_policycoverage);			
	
END;


$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_exposures_uu()
	LANGUAGE plpgsql
AS $$
			
BEGIN 		
		
/*Full update of full reload from MS SQL. takes ~ 10min*/		
/*1. Adjusting fact_policytransaction to the format we have in PolicyStats (SPINN) - 		
 For each coverage except New and Renewal transactions we should have 2 amounts for each transaction:		
 first which set the amount to 0 from the previous transaction		
 and the second the final value of the transaction itself		
 BI New Business 1 trn: 200 		
 BI Endorsement 2 trn: -200 		
 BI Endorsement 2 trn: 180		
 There is also an issue with the original transactionsequence in fact_policytransaction. It is not unique per transaction		
 */		
		
drop table if exists  adj_fact_policytransaction;		
create temporary table adj_fact_policytransaction as		
with data0 as (		
select 		
0 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
f.policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
case 		
 when policytransaction_uniqueid like 'UPU%' then		
 policytransaction_uniqueid		
 when policytransaction_uniqueid like 'UUA%' then		
 replace(substring(policytransaction_uniqueid,1,57),'-UU','-00')		
 else		
 reverse(substring(reverse(policytransaction_uniqueid), position('-' in reverse(policytransaction_uniqueid))+1, len(policytransaction_uniqueid)))		
end calc_pt_uid,		
dense_rank() over (partition by policy_uniqueid order by  calc_pt_uid) transactionsequence,		
ptrans_name,
amount term_amount,		
sum(amount) over(partition by coverage_uniqueid order by  calc_pt_uid rows UNBOUNDED PRECEDING) cum_term_amount		
from fsbi_dw_uu.fact_policytransaction	f	
join fsbi_dw_uu.dim_policytransactiontype tt		
on f.policytransactiontype_id=tt.policytransactiontype_id		
where ptrans_code <> 'FS'		
)		
,data1 as 		
(select 		
0 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
case when ptrans_name like 'Cancel%' then 0 else cum_term_amount end term_amount		
from data0		
union all		
select 		
1 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
0 term_amount		
from data0		
union all		
select 		
2 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
case when ptrans_name = 'Reinstate' then  0 else  - isnull(lag(cum_term_amount) over(partition by coverage_uniqueid order by   transactionsequence,accountingdate_id),0) end term_amount		
from data0	
)		
select *		
from data1		
where not(transactionsequence=1 and nord>0)		
order by 		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
nord;		
		
		
/*2. calculating exposures*/		
/*==========================================Part 1 month/1 exposure ===================================================================*/		
/*2.1 One (1) month/1 exposure first*/		
/*2.1.1 Written exposure*/		
drop table if exists  WE_data1;
create temporary table WE_data1 as		
select		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
case 		
when f.term_amount<=-0.05 then -datediff(month, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate) 		
when f.term_amount>0.05 then datediff(month, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate)		
else 0		
end WE		
from adj_fact_policytransaction f		 
join fsbi_dw_uu.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uu.dim_policy p		
on f.policy_id=p.policy_id		
join fsbi_dw_uu.dim_policytransactiontype dptt 		
on f.POLICYTRANSACTIONTYPE_ID = dptt.POLICYTRANSACTIONTYPE_ID		
and dptt.ptrans_writtenprem = '+'		
join fsbi_dw_uu.dim_time t		
on f.accountingdate_id=t.time_id;		
		
/*2.1.2 Written exposure aggregated. */		
drop table if exists  WE1;
create temporary table WE1 as		
select 		
month_id,		
policy_id, 		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
sum(WE) WE		
from we_data1		
group by 		
month_id,		
coverage_id,		
coverage_uniqueid,		
policy_id,		
policy_uniqueid ;		
		
/*2.1.3 For earned exposures and joining to fact_policycoverage we need months*/
drop table if exists  mtd_data1;
create temporary table mtd_data1 as 		
Select		
factpolicycoverage_id,		
month_id,		
row_number() over (partition by f.policy_id,f.coverage_id,f.coverage_uniqueid order by f.month_id) as month_num,		
f.policy_id, 		
f.policy_uniqueid,		
f.coverage_uniqueid,		
f.coverage_id,		
wrtn_prem_amt WP,		
earned_prem_amt EP	,	
pol_effectivedate,		
pol_expirationdate		
from fsbi_dw_uu.fact_policycoverage f		
join fsbi_dw_uu.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uu.dim_policy p		
on f.policy_id=p.policy_id;		
		
/*2.1.4 unearned exposure, adjusting data with Diff for backdated transactions */	
drop table if exists  mtd1;
create temporary table mtd1 as 		
select 		
factpolicycoverage_id,		
month_num,		
e.month_id,		
e.policy_id,		
e.policy_uniqueid,		
e.coverage_id,		
e.coverage_uniqueid,		
WP,		
EP,		
isnull(WE.WE,0) WE,		
case when e.month_id=we.month_id then WE else 0 end WE_adj,		
case 		
 when cast(cast(e.month_id as varchar)+'01'  as date)>e.pol_expirationdate then 0 --accounting date AFTER expiration		
 when month_num=1 and e.month_id > cast(to_char(e.pol_effectivedate, 'YYYYMM') as int) then 		
  isnull(datediff(month,e.pol_effectivedate,dateadd(day,-1,dateadd(month,1,cast(cast(e.month_id as varchar)+'01'  as date)))) - 1,0) 		
 else 0 		
end  Diff,		
sum(isnull(Diff,0)) over (partition by e.policy_id,e.coverage_id,e.coverage_uniqueid order by e.month_id rows unbounded preceding) Diff_ITD,		
sum(isnull(WE.WE,0)) over (partition by e.policy_id,e.coverage_id,e.coverage_uniqueid order by e.month_id rows unbounded preceding) WE_ITD,		
case 		
 when cast(cast(e.month_id as varchar)+'01'  as date)>e.pol_expirationdate then 0		
 when WE_ITD - month_num - Diff_ITD <0 then 0		
 else WE_ITD - month_num - Diff_ITD		
end  UE_ITD 		
from mtd_data1	e	
left outer join WE1 WE		
on e.month_id=WE.month_id		
and e.policy_id=WE.policy_id		
and e.coverage_id=WE.coverage_id		
and e.coverage_uniqueid=WE.coverage_uniqueid;		
		
/*2.1.5 earned exposure*/
drop table if exists  mtd_term1;
create temporary table mtd_term1 as select		
factpolicycoverage_id,		
month_num,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WP,		
EP,		
WE,		
WE_adj,		
WE_ITD,		
UE_ITD,		
isnull(lag(UE_ITD) over (partition by policy_id,coverage_id,coverage_uniqueid order by month_id),0) - UE_ITD + WE_adj  EE 		
from mtd1;		
		
/*==========================================Part 2 1 month/partial exposure based on dates ===================================================================*/		
/*2.2 One(1) month/partial exposure based on dates*/		
/*2.2.1 Written exposure*/		
drop table if exists  WE2;
create temporary table WE2 as 		
select		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
sum(case 		
when f.term_amount<-0.05 then -datediff(day, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate) 		
when f.term_amount>0.05 then  datediff(day, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate)		
else 0		
end/30.417) WE,		
p.pol_expirationdate expirationdate,		
cast(cast(effectivedate_id as varchar) as date) effectivedate		
from adj_fact_policytransaction f		 
join fsbi_dw_uu.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uu.dim_policy p		
on f.policy_id=p.policy_id		
join fsbi_dw_uu.dim_policytransactiontype dptt 		
on f.POLICYTRANSACTIONTYPE_ID = dptt.POLICYTRANSACTIONTYPE_ID		
and dptt.ptrans_writtenprem = '+'		
join fsbi_dw_uu.dim_time t		
on f.accountingdate_id=t.time_id		
group by		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
p.pol_expirationdate,		
cast(cast(effectivedate_id as varchar) as date);		
		
/*2.2.2 For earned exposures and joining to fact_policycoverage we need months*/
drop table if exists  mtd_data2;
create temporary table mtd_data2 as 		
Select		
f.factpolicycoverage_id,		
f.month_id,		
m.mon_enddate,		
f.policy_id, 		
f.policy_uniqueid,		
f.coverage_uniqueid,		
f.coverage_id,		
wrtn_prem_amt WP,		
earned_prem_amt EP		
from fsbi_dw_uu.fact_policycoverage f		
join fsbi_dw_uu.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uu.dim_month m		
on f.month_id=m.month_id;		
		
/*2.2.3 UnearnedFactor  based on days */	
drop table if exists  mtd2;
create temporary table mtd2 as 		
select 		
factpolicycoverage_id,		
e.month_id,		
e.policy_id,		
e.policy_uniqueid,		
e.coverage_id,		
e.coverage_uniqueid,		
WP,		
EP,		
WE,		
case when e.month_id=we.month_id then WE else 0 end WE_adj,		
mon_enddate,		
WE.expirationdate,		
WE.effectivedate,		
case 		
when WE.expirationdate <= mon_enddate then 0		
when effectivedate> mon_enddate then 1		
else round((cast(datediff(day, mon_enddate,  expirationdate) as float) - 1.000)/cast(datediff(day, effectivedate,  expirationdate) as float),5)		
end UnearnedFactor		
from mtd_data2	e	
join WE2 WE		
on e.policy_id=WE.policy_id		
and e.coverage_id=WE.coverage_id		
and e.coverage_uniqueid=WE.coverage_uniqueid		
and WE.month_id<=e.month_id;		
		
/*2.2.4 Unearned Exposure */
drop table if exists  mtd_term2_1;
create temporary table mtd_term2_1 as		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
UnearnedFactor,		
sum(WE) WE,		
sum(WE_adj) WE_adj,		
sum(WE)*UnearnedFactor UE		
from mtd2		
group by		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
UnearnedFactor;		
		
/*2.2.5 Aggregating Unearned Exposure */	
drop table if exists  mtd_term2_2;
create temporary table mtd_term2_2 as 		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
sum(WE_adj) WE,		
sum(UE) UE		
from mtd_term2_1		
group by factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid		
order by month_id;		
		
/*2.2.6 Earned Exposure */		
drop table if exists  mtd_term2;
create temporary table mtd_term2 as 		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WE,		
UE	,	
lag(UE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid,month_id) UE_PRIOR,		
isnull(UE_PRIOR,0) - UE + WE EE		
from mtd_term2_2		
order by month_id;		
		
		
		
/*============================================================= FINAL =============================================================*/		
truncate table fsbi_dw_uu.stg_exposures;		
insert into fsbi_dw_uu.stg_exposures		
select 		
mtd_term1.factpolicycoverage_id,		
mtd_term1.month_id,		
mtd_term1.policy_id,		
mtd_term1.policy_uniqueid,		
mtd_term1.coverage_id,		
mtd_term1.coverage_uniqueid,		
mtd_term1.WE WE,		
mtd_term1.EE EE,		
null WE_YTD,		
null EE_YTD,		
null WE_ITD,		
null EE_ITD, 		
isnull(mtd_term2.WE,0) WE_RM,		
isnull(mtd_term2.EE,0) EE_RM,		
null WE_RM_YTD,		
null EE_RM_YTD,		
null WE_RM_ITD,		
null EE_RM_ITD		
from mtd_term1		
left outer join mtd_term2 on		
mtd_term1.factpolicycoverage_id=mtd_term2.factpolicycoverage_id;		
/*============================================================= YTD and ITD =============================================================*/		
drop table if exists  tmp_exposures;		
create temporary table tmp_exposures as		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WE,		
EE,		
sum(WE) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) WE_YTD,		
sum(EE) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_YTD,		
sum(WE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding)  WE_ITD,		
sum(EE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_ITD, 		
WE_RM,		
EE_RM,		
sum(WE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) WE_RM_YTD,		
sum(EE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_RM_YTD,		
sum(WE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding)  WE_RM_ITD,		
sum(EE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_RM_ITD		
from fsbi_dw_uu.stg_exposures;		
		
update fsbi_dw_uu.stg_exposures		
set 		
 WE_YTD=t.WE_YTD		
,EE_YTD=t.EE_YTD		
,WE_ITD=t.WE_ITD		
,EE_ITD=t.EE_ITD		
,WE_RM_YTD=t.WE_RM_YTD		
,EE_RM_YTD=t.EE_RM_YTD		
,WE_RM_ITD=t.WE_RM_ITD		
,EE_RM_ITD=t.EE_RM_ITD		
from tmp_exposures t		
join fsbi_dw_uu.stg_exposures e		
on t.factpolicycoverage_id=e.factpolicycoverage_id;		
		
		
/*=============================================================FACT_POLICYCOVERAGE Update =============================================================*/		
		
update fsbi_dw_uu.fact_policycoverage		
set		
we = e.we,		
ee = e.ee,		
we_ytd = e.we_ytd, 		
ee_ytd  = e.ee_ytd,		
we_itd  = e.we_itd,		
ee_itd  = e.ee_itd,		
we_rm  = e.we_rm,		
ee_rm  = e.ee_rm,		
we_rm_ytd  = e.we_rm_ytd,		
ee_rm_ytd  = e.ee_rm_ytd,		
we_rm_itd  = e.we_rm_itd,		
ee_rm_itd  = e.ee_rm_itd		
from fsbi_dw_uu.fact_policycoverage f		
join fsbi_dw_uu.stg_exposures e		
on f.factpolicycoverage_id=e.factpolicycoverage_id		
and f.policy_id=e.policy_id	;	
		
END;		

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_exposures_uuico()
	LANGUAGE plpgsql
AS $$
			
BEGIN 		
		
/*1. Adjusting fact_policytransaction to the format we have in PolicyStats (SPINN) - 		
 For each coverage except New and Renewal transactions we should have 2 amounts for each transaction:		
 first which set the amount to 0 from the previous transaction		
 and the second the final value of the transaction itself		
 BI New Business 1 trn: 200 		
 BI Endorsement 2 trn: -200 		
 BI Endorsement 2 trn: 180*/		
drop table if exists  adj_fact_policytransaction;		
create temporary table adj_fact_policytransaction as		
with data0 as (		
select 		
0 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
f.policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
case 		
 when policytransaction_uniqueid like 'UPU%' then		
 policytransaction_uniqueid		
 when policytransaction_uniqueid like 'UUA%' then		
 replace(substring(policytransaction_uniqueid,1,57),'-UU','-00')		
 else		
 reverse(substring(reverse(policytransaction_uniqueid), position('-' in reverse(policytransaction_uniqueid))+1, len(policytransaction_uniqueid)))		
end calc_pt_uid,		
dense_rank() over (partition by policy_uniqueid order by  calc_pt_uid) transactionsequence,		
ptrans_name,		
amount term_amount,		
sum(amount) over(partition by coverage_uniqueid order by  calc_pt_uid rows UNBOUNDED PRECEDING) cum_term_amount		
from fsbi_dw_uuico.fact_policytransaction	f	
join fsbi_dw_uuico.dim_policytransactiontype tt		
on f.policytransactiontype_id=tt.policytransactiontype_id		
where ptrans_code <> 'FS'		
)		
,data1 as 		
(select 		
0 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
case when ptrans_name like 'Cancel%' then 0 else cum_term_amount end term_amount		
from data0		
union all		
select 		
1 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
0 term_amount		
from data0		
union all		
select 		
2 nord,		
policy_id,		
policy_uniqueid,		
coverage_id,		
policytransactiontype_id,		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
case when ptrans_name = 'Reinstate' then  0 else  - isnull(lag(cum_term_amount) over(partition by coverage_uniqueid order by   transactionsequence,accountingdate_id),0) end term_amount		
from data0		
)		
select *		
from data1		
where not(transactionsequence=1 and nord>0)		
order by 		
coverage_uniqueid,		
accountingdate_id,		
effectivedate_id,		
transactionsequence,		
nord;		
		
		
/*2. calculating exposures*/		
/*==========================================Part 1 month/1 exposure ===================================================================*/		
/*2.1 One (1) month/1 exposure first*/		
/*2.1.1 Written exposure*/		
create temporary table WE_data1 as		
select		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
case 		
when f.term_amount<-0.05 then -datediff(month, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate) 		
when f.term_amount>0.05 then datediff(month, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate)		
else 0		
end WE		
from adj_fact_policytransaction f		 
join fsbi_dw_uuico.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uuico.dim_policy p		
on f.policy_id=p.policy_id		
join fsbi_dw_uuico.dim_policytransactiontype dptt 		
on f.POLICYTRANSACTIONTYPE_ID = dptt.POLICYTRANSACTIONTYPE_ID		
and dptt.ptrans_writtenprem = '+'		
join fsbi_dw_uuico.dim_time t		
on f.accountingdate_id=t.time_id		
where lower(c.cov_code) not like '%fee%';		
		
/*2.1.2 Written exposure aggregated. */		
create temporary table WE1 as		
select 		
month_id,		
policy_id, 		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
sum(WE) WE		
from we_data1		
group by 		
month_id,		
coverage_id,		
coverage_uniqueid,		
policy_id,		
policy_uniqueid ;		
		
/*2.1.3 For earned exposures and joining to fact_policycoverage we need months*/		
create temporary table mtd_data1 as 		
Select		
factpolicycoverage_id,		
month_id,		
row_number() over (partition by f.policy_id,f.coverage_id,f.coverage_uniqueid order by f.month_id) as month_num,		
f.policy_id, 		
f.policy_uniqueid,		
f.coverage_uniqueid,		
f.coverage_id,		
wrtn_prem_amt WP,		
earned_prem_amt EP	,	
pol_effectivedate,		
pol_expirationdate		
from fsbi_dw_uuico.fact_policycoverage f		
join fsbi_dw_uuico.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uuico.dim_policy p		
on f.policy_id=p.policy_id		
where lower(c.cov_code) not like '%fee%';		
		
/*2.1.4 unearned exposure, adjusting data with Diff for backdated transactions */		
create temporary table mtd1 as 		
select 		
factpolicycoverage_id,		
month_num,		
e.month_id,		
e.policy_id,		
e.policy_uniqueid,		
e.coverage_id,		
e.coverage_uniqueid,		
WP,		
EP,		
isnull(WE.WE,0) WE,		
case when e.month_id=we.month_id then WE else 0 end WE_adj,		
case 		
 when cast(cast(e.month_id as varchar)+'01'  as date)>e.pol_expirationdate then 0 --accounting date AFTER expiration		
 when month_num=1 and e.month_id > cast(to_char(e.pol_effectivedate, 'YYYYMM') as int) then 		
  isnull(datediff(month,e.pol_effectivedate,dateadd(day,-1,dateadd(month,1,cast(cast(e.month_id as varchar)+'01'  as date)))) - 1,0) 		
 else 0 		
end  Diff,		
sum(isnull(Diff,0)) over (partition by e.policy_id,e.coverage_id,e.coverage_uniqueid order by e.month_id rows unbounded preceding) Diff_ITD,		
sum(isnull(WE.WE,0)) over (partition by e.policy_id,e.coverage_id,e.coverage_uniqueid order by e.month_id rows unbounded preceding) WE_ITD,		
case 		
 when cast(cast(e.month_id as varchar)+'01'  as date)>e.pol_expirationdate then 0		
 when WE_ITD - month_num - Diff_ITD <0 then 0		
 else WE_ITD - month_num - Diff_ITD		
end  UE_ITD 		
from mtd_data1	e	
left outer join WE1 WE		
on e.month_id=WE.month_id		
and e.policy_id=WE.policy_id		
and e.coverage_id=WE.coverage_id		
and e.coverage_uniqueid=WE.coverage_uniqueid;		
		
/*2.1.5 earned exposure*/		
create temporary table mtd_term1 as select		
factpolicycoverage_id,		
month_num,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WP,		
EP,		
WE,		
WE_adj,		
WE_ITD,		
UE_ITD,		
isnull(lag(UE_ITD) over (partition by policy_id,coverage_id,coverage_uniqueid order by month_id),0) - UE_ITD + WE_adj  EE 		
from mtd1;		
		
/*==========================================Part 2 1 month/partial exposure based on dates ===================================================================*/		
/*2.2 One(1) month/partial exposure based on dates*/		
/*2.2.1 Written exposure*/		
create temporary table WE2 as 		
select		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
sum(case 		
when f.term_amount<-0.05 then -datediff(day, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate) 		
when f.term_amount>0.05 then  datediff(day, cast(cast(effectivedate_id as varchar) as date),  p.pol_expirationdate)		
else 0		
end/30.417) WE,		
p.pol_expirationdate expirationdate,		
cast(cast(effectivedate_id as varchar) as date) effectivedate		
from adj_fact_policytransaction f		 
join fsbi_dw_uuico.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uuico.dim_policy p		
on f.policy_id=p.policy_id		
join fsbi_dw_uuico.dim_policytransactiontype dptt 		
on f.POLICYTRANSACTIONTYPE_ID = dptt.POLICYTRANSACTIONTYPE_ID		
and dptt.ptrans_writtenprem = '+'		
join fsbi_dw_uuico.dim_time t		
on f.accountingdate_id=t.time_id		
where lower(c.cov_code) not like '%fee%'		
group by		
t.month_id,		
f.policy_id,		
f.policy_uniqueid,		
f.coverage_id,		
f.coverage_uniqueid,		
p.pol_expirationdate,		
cast(cast(effectivedate_id as varchar) as date);		
		
/*2.2.2 For earned exposures and joining to fact_policycoverage we need months*/		
create temporary table mtd_data2 as 		
Select		
f.factpolicycoverage_id,		
f.month_id,		
m.mon_enddate,		
f.policy_id, 		
f.policy_uniqueid,		
f.coverage_uniqueid,		
f.coverage_id,		
wrtn_prem_amt WP,		
earned_prem_amt EP		
from fsbi_dw_uuico.fact_policycoverage f		
join fsbi_dw_uuico.dim_coverage c		
on f.coverage_id=c.coverage_id		
join fsbi_dw_uuico.dim_month m		
on f.month_id=m.month_id		
where lower(c.cov_code) not like '%fee%';		
		
/*2.2.3 UnearnedFactor  based on days */		
create temporary table mtd2 as 		
select 		
factpolicycoverage_id,		
e.month_id,		
e.policy_id,		
e.policy_uniqueid,		
e.coverage_id,		
e.coverage_uniqueid,		
WP,		
EP,		
WE,		
case when e.month_id=we.month_id then WE else 0 end WE_adj,		
mon_enddate,		
WE.expirationdate,		
WE.effectivedate,		
case 		
when WE.expirationdate <= mon_enddate then 0		
when effectivedate> mon_enddate then 1		
else round((cast(datediff(day, mon_enddate,  expirationdate) as float) - 1.000)/cast(datediff(day, effectivedate,  expirationdate) as float),5)		
end UnearnedFactor		
from mtd_data2	e	
join WE2 WE		
on e.policy_id=WE.policy_id		
and e.coverage_id=WE.coverage_id		
and e.coverage_uniqueid=WE.coverage_uniqueid		
and WE.month_id<=e.month_id;		
		
/*2.2.4 Unearned Exposure */		
create temporary table mtd_term2_1 as		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
UnearnedFactor,		
sum(WE) WE,		
sum(WE_adj) WE_adj,		
sum(WE)*UnearnedFactor UE		
from mtd2		
group by		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
UnearnedFactor;		
		
/*2.2.5 Aggregating Unearned Exposure */		
create temporary table mtd_term2_2 as 		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
sum(WE_adj) WE,		
sum(UE) UE		
from mtd_term2_1		
group by factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid		
order by month_id;		
		
/*2.2.6 Earned Exposure */		
create temporary table mtd_term2 as 		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WE,		
UE	,	
lag(UE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid,month_id) UE_PRIOR,		
isnull(UE_PRIOR,0) - UE + WE EE		
from mtd_term2_2		
order by month_id;		
		
		
		
/*============================================================= FINAL =============================================================*/		
truncate table fsbi_dw_uuico.stg_exposures;		
insert into fsbi_dw_uuico.stg_exposures		
select 		
mtd_term1.factpolicycoverage_id,		
mtd_term1.month_id,		
mtd_term1.policy_id,		
mtd_term1.policy_uniqueid,		
mtd_term1.coverage_id,		
mtd_term1.coverage_uniqueid,		
mtd_term1.WE WE,		
mtd_term1.EE EE,		
null WE_YTD,		
null EE_YTD,		
null WE_ITD,		
null EE_ITD, 		
isnull(mtd_term2.WE,0) WE_RM,		
isnull(mtd_term2.EE,0) EE_RM,		
null WE_RM_YTD,		
null EE_RM_YTD,		
null WE_RM_ITD,		
null EE_RM_ITD		
from mtd_term1		
left outer join mtd_term2 on		
mtd_term1.factpolicycoverage_id=mtd_term2.factpolicycoverage_id;		
/*============================================================= YTD and ITD =============================================================*/		
		
create temporary table tmp_exposures as		
select 		
factpolicycoverage_id,		
month_id,		
policy_id,		
policy_uniqueid,		
coverage_id,		
coverage_uniqueid,		
WE,		
EE,		
sum(WE) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) WE_YTD,		
sum(EE) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_YTD,		
sum(WE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding)  WE_ITD,		
sum(EE) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_ITD, 		
WE_RM,		
EE_RM,		
sum(WE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) WE_RM_YTD,		
sum(EE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid, substring(month_id,1,4) order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_RM_YTD,		
sum(WE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding)  WE_RM_ITD,		
sum(EE_RM) over (partition by policy_id,coverage_id,coverage_uniqueid order by policy_id,coverage_id,coverage_uniqueid, month_id rows unbounded preceding) EE_RM_ITD		
from fsbi_dw_uuico.stg_exposures;		
		
update fsbi_dw_uuico.stg_exposures		
set 		
 WE_YTD=t.WE_YTD		
,EE_YTD=t.EE_YTD		
,WE_ITD=t.WE_ITD		
,EE_ITD=t.EE_ITD		
,WE_RM_YTD=t.WE_RM_YTD		
,EE_RM_YTD=t.EE_RM_YTD		
,WE_RM_ITD=t.WE_RM_ITD		
,EE_RM_ITD=t.EE_RM_ITD		
from tmp_exposures t		
join fsbi_dw_uuico.stg_exposures e		
on t.factpolicycoverage_id=e.factpolicycoverage_id;		
		
		
/*=============================================================FACT_POLICYCOVERAGE Update =============================================================*/		
		
update fsbi_dw_uuico.fact_policycoverage		
set		
we = e.we,		
ee = e.ee,		
we_ytd = e.we_ytd, 		
ee_ytd  = e.ee_ytd,		
we_itd  = e.we_itd,		
ee_itd  = e.ee_itd,		
we_rm  = e.we_rm,		
ee_rm  = e.ee_rm,		
we_rm_ytd  = e.we_rm_ytd,		
ee_rm_ytd  = e.ee_rm_ytd,		
we_rm_itd  = e.we_rm_itd,		
ee_rm_itd  = e.ee_rm_itd		
from fsbi_dw_uuico.fact_policycoverage f		
join fsbi_dw_uuico.stg_exposures e		
on f.factpolicycoverage_id=e.factpolicycoverage_id		
and f.policy_id=e.policy_id	;	
		
		
END;		

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_extend_blended_claims_monthly(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
			
DECLARE 		
months RECORD;		
BEGIN		
FOR months IN 		
 select distinct 		
 month_id , 		
 cast(to_char(add_months(cast(cast(month_id as varchar) + '01' as date),-1),'YYYYMM') as int) prev_month_id		
 from fsbi_stg_spinn.fact_claim		
 order by month_id		
LOOP		
 drop table if exists tmp_data;		
 create temporary table tmp_data as 		
select		
         cast(to_char(acct_date,'yyyymm') as int) month_id		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part		
	   /*-----------------------*/	
       , sum(loss_paid) loss_paid		
       , sum(loss_reserve) loss_reserve		
       , sum(aoo_paid) aoo_paid		
       , sum(aoo_reserve) aoo_reserve		
       , sum(dcc_paid) dcc_paid		
       , sum(dcc_reserve) dcc_reserve		
       , sum(salvage_received) salvage_received		
       , sum(salvage_reserve) salvage_reserve		
       , sum(subro_received) subro_received		
       , sum(subro_reserve) subro_reserve		
	   /*-----------------------*/	   
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref		
       , poleff_date
       , polexp_date	   
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , source_system		
from public.vmfact_claimtransaction_blended f		
where cast(to_char(acct_date,'yyyymm') as int)=months.month_id		
group by		
         cast(to_char(acct_date,'yyyymm') as int)		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part	   	
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref	
       , poleff_date
       , polexp_date	   
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , changetype		
       , source_system;		
	   	
delete from public.vmfact_claim_blended		
where month_id=months.month_id;	   	
		
insert into public.vmfact_claim_blended		
with data as (		
select		
         md.month_id		
       , md.claim_number		
       , md.catastrophe_id		
       , md.claimant		
       , md.feature		
       , md.feature_desc		
       , md.feature_type		
       , md.aslob		
       , md.rag		
       , md.schedp_part		
/*---------------------------------------------------*/		
       , md.loss_paid		
       , md.loss_reserve		
       , md.aoo_paid		
       , md.aoo_reserve		
       , md.dcc_paid		
       , md.dcc_reserve		
       , md.salvage_received		
       , md.salvage_reserve		
       , md.subro_received		
       , md.subro_reserve		
/*---------------------------------------------------*/	   	
       , md.product_code		
       , md.product		
       , md.subproduct		
       , md.carrier		
       , md.carrier_group		
       , md.company		
       , md.policy_state		
       , md.policy_number		
       , md.policyref	
       , md.poleff_date
       , md.polexp_date	   
       , md.producer_code		
       , md.loss_date		
       , md.loss_year		
       , md.reported_date		
       , md.loss_cause		
       , md.source_system	   	
,pLoadDate LoadDate		
from tmp_data md		
union all		
select		
         months.month_id month_id		
       , coalesce(mdc.claim_number,md.claim_number) 	claim_number	
       , coalesce(mdc.catastrophe_id,md.catastrophe_id) catastrophe_id	
       , coalesce(mdc.claimant,md.claimant) claimant		
       , coalesce(mdc.feature,md.feature) feature		
       , coalesce(mdc.feature_desc,md.feature_desc) feature_desc		
       , coalesce(mdc.feature_type,md.feature_type) feature_type		
       , coalesce(mdc.aslob,md.aslob) aslob		
       , coalesce(mdc.rag,md.rag) rag		
       , coalesce(mdc.schedp_part,md.schedp_part) schedp_part		
/*---------------------------------------------------*/		
       , 0 loss_paid		
       , 0 loss_reserve		
       , 0 aoo_paid		
       , 0 aoo_reserve		
       , 0 dcc_paid		
       , 0 dcc_reserve		
       , 0 salvage_received		
       , 0 salvage_reserve		
       , 0 subro_received		
       , 0 subro_reserve		
/*---------------------------------------------------*/	   	
       , coalesce(mdc.product_code,md.product_code) product_code		
       , coalesce(mdc.product,md.product) product		
       , coalesce(mdc.subproduct,md.subproduct)subproduct		
       , coalesce(mdc.carrier,md.carrier) carrier		
       , coalesce(mdc.carrier_group,md.carrier_group) carrier_group		
       , coalesce(mdc.company,md.company) company		
       , coalesce(mdc.policy_state,md.policy_state) policy_state		
       , coalesce(mdc.policy_number,md.policy_number) policy_number		
       , coalesce(mdc.policyref,md.policyref) policyref		
       , coalesce(mdc.poleff_date,md.poleff_date) poleff_date
       , coalesce(mdc.polexp_date,md.polexp_date) polexp_date
       , coalesce(mdc.producer_code,md.producer_code) producer_code		
       , coalesce(mdc.loss_date,md.loss_date) loss_date		
       , coalesce(mdc.loss_year,md.loss_year) loss_year		
       , coalesce(mdc.reported_date,md.reported_date) reported_date		
       , coalesce(mdc.loss_cause,md.loss_cause)	loss_cause	
       , coalesce(mdc.source_system,md.source_system)	source_system   	
,pLoadDate LoadDate		
from public.vmfact_claim_blended	 md	
left outer join tmp_data mdc
on md.claim_number=mdc.claim_number
and md.claimant=mdc.claimant
and md.feature=mdc.feature
where md.month_id=months.prev_month_id		
)		
select		
         month_id		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part		
	   /*-----------------------*/	
       , sum(loss_paid) loss_paid		
       , sum(loss_reserve) loss_reserve		
       , sum(aoo_paid) aoo_paid		
       , sum(aoo_reserve) aoo_reserve		
       , sum(dcc_paid) dcc_paid		
       , sum(dcc_reserve) dcc_reserve		
       , sum(salvage_received) salvage_received		
       , sum(salvage_reserve) salvage_reserve		
       , sum(subro_received) subro_received		
       , sum(subro_reserve) subro_reserve		
	   /*-----------------------*/	   
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref	
       , poleff_date
       , polexp_date		   
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , source_system		
	   ,LoadDate	
from data		
group by		
         month_id		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part	   	
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref		
       , poleff_date
       , polexp_date		   
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , source_system		
	   , LoadDate;	
END LOOP;		
END;		

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_fact_auto_modeldata(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
	
												
											
BEGIN 											
											
											
/*											
Author: Kate Drogaieva											
Purpose: This script populate FACT_AUTO_MODELDATA											
Comment: Due to back dated transactions it was made as a full refresh.											
ToDo: incremental refresh ignoring changes in expired policies											
											
03/07/2023: Back to Redshift											
12/13/2019: Using DIM_POLICY_CHANGES instead of DIM_POLICY_DISCOUNT_CHANGES											
11/27/2019: Fixed error in the insert into fact table. Distint is added to avoide duplications by claimrisk_id											
10/25/2019: All coverages, Limit and deductible in Limit and deductible columns, BILimit1530, UMBILimit1530,	UIMBILimit1530										
*/											
											
											
											
/*2. BI, UMBI, PD Limits and Coll, Comp deductibles columns for easy filtering and producer ID*/											
											
drop table if exists stg_auto_modeldata0;											
create temporary table stg_auto_modeldata0 as											
select 											
 stg.*											
,isnull(p.producer_id,4) producer_id											
,dc.policy_changes_id											
 --											
 --											
,isnull(COLLcov.Deductible1,'~') coll_deductible											
,isnull(COMPcov.Deductible1,'~') comp_deductible											
,isnull(BIcov.Limit1,'~') bi_limit1											
,isnull(BIcov.Limit2,'~') bi_limit2											
,isnull(UMBIcov.Limit1,'~') umbi_limit1											
,isnull(UMBIcov.Limit2,'~') umbi_limit2											
,isnull(PDcov.Limit1,'~') pd_limit1											
,isnull(PDcov.Limit2,'~') pd_limit2											
 --											
from fsbi_stg_spinn.stg_auto_modeldata stg											
join fsbi_dw_spinn.dim_policy_changes dc											
on  stg.policy_uniqueid=dc.policy_uniqueid											
and stg.Startdatetm >= dc.valid_fromdate and stg.Startdatetm<dc.valid_todate											
 --											
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage	 BIcov										
on stg.policy_uniqueid=BIcov.policy_uniqueid											
and stg.SystemIdStart=BIcov.SystemId											
and stg.risk_uniqueid=BIcov.risk_uniqueid											
and BIcov.act_modeldata 	= 'BI'										
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage	 UMBIcov										
on stg.policy_uniqueid=UMBIcov.policy_uniqueid											
and stg.SystemIdStart=UMBIcov.SystemId											
and stg.risk_uniqueid=UMBIcov.risk_uniqueid											
and UMBIcov.act_modeldata 	= 'UMBI'										
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage	 PDcov										
on stg.policy_uniqueid=PDcov.policy_uniqueid											
and stg.SystemIdStart=PDcov.SystemId											
and stg.risk_uniqueid=PDcov.risk_uniqueid											
and PDcov.act_modeldata 	= 'PD'										
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage	 COLLcov										
on stg.policy_uniqueid=COLLcov.policy_uniqueid											
and stg.SystemIdStart=COLLcov.SystemId											
and stg.risk_uniqueid=COLLcov.risk_uniqueid											
and COLLcov.act_modeldata 	= 'COLL'										
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage	 COMPcov										
on stg.policy_uniqueid=COMPcov.policy_uniqueid											
and stg.SystemIdStart=COMPcov.SystemId											
and stg.risk_uniqueid=COMPcov.risk_uniqueid											
and COMPcov.act_modeldata 	= 'COMP'										
 --											
left outer join fsbi_dw_spinn.DIM_PRODUCER p											
on p.producer_uniqueid=isnull(stg.producer_uniqueid,'Unknown')
and stg.Startdatetm >= p.valid_fromdate and stg.Startdatetm<p.valid_todate;											
											
/*3 Extending STG_AUTO_MODELDATA for all coverages*/											
											
drop table if exists tmp_auto_modeldata;											
create temporary table tmp_auto_modeldata as											
select 											
 stg.*											
 --											
,cov.act_modeldata		coveragecd									
,isnull(cov.Limit1,'~') Limit1											
,isnull(cov.Limit2,'~') Limit2											
,isnull(cov.Deductible1,'~') Deductible											
,cov.FullTermAmt wp											
 --											
from stg_auto_modeldata0 stg											
join fsbi_stg_spinn.vstg_auto_modeldata_coverage cov											
on stg.policy_uniqueid=cov.policy_uniqueid											
and stg.SystemIdStart=cov.SystemId											
and stg.risk_uniqueid=cov.risk_uniqueid											
and cov.act_modeldata in ('APMP','BI','COLL','COMP','CUSTE','CWAIV','LOAN','MP','OEM','PD','RIDESH','ROAD',											
'RREIM','RRGAP','UIMBI','UIMPD','UMBI','UMPD')											
;											
											
drop table if exists stg_auto_modeldata0;											
											
/*4 Claims*/											
/*4.1 Only claims data. Non-claims not need aggregation and will be joined later*/											
											
drop table if exists stg_auto_modeldata_claims;											
create temporary table stg_auto_modeldata_claims as											
select 											
 stg.modeldata_id											
,stg.coveragecd 											
 --											
,Quality_ClaimOk_Flg											
,Quality_ClaimUnknownVIN_Flg											
,Quality_ClaimUnknownVINNotListedDriver_Flg											
,Quality_ClaimPolicyTermJoin_Flg											
 --											
,c.claimrisk_id 											
,c.CatFlg											
,c.AtFaultcd											
,c.lossinc											
,c.dcce											
,sum(c.lossinc) over(partition by c.claimrisk_id) allcov_lossinc											
,sum(c.dcce) over(partition by c.claimrisk_id) allcov_dcce											
,c.BIlossinc1530											
,c.UMBIlossinc1530											
,c.UIMBIlossinc1530											
from tmp_auto_modeldata stg											
join fsbi_stg_spinn.vstg_auto_modeldata_claims c											
on stg.claimrisk_id=c.claimrisk_id											
and stg.coveragecd=c.coveragecd	;										
											
											
											
											
/*											
4.2 Aggregate Claims data											
*/											
											
drop table if exists tmp_fact_auto_modeldataset_claims_grouped;											
create temporary table tmp_fact_auto_modeldataset_claims_grouped as											
select 											
modeldata_id	,										
--											
CoverageCd,											
--											
count(distinct case when AtFaultcd='At Fault' then  claimrisk_id else null end) AtFaultcdClaims_count,											
 --											
											
 --Cov Count											
count(distinct (case when 	lossinc	>0 and lossinc				<=	500	then claimrisk_id else null end))	COV_claim_count_le500,		
count(distinct (case when 	lossinc					>=	1000	then claimrisk_id else null end))	COV_claim_count_1000,		
count(distinct (case when 	lossinc					>=	1500	then claimrisk_id else null end))	COV_claim_count_1500,		
count(distinct (case when 	lossinc					>=	2000	then claimrisk_id else null end))	COV_claim_count_2000,		
count(distinct (case when 	lossinc					>=	2500	then claimrisk_id else null end))	COV_claim_count_2500,		
count(distinct (case when 	lossinc					>=	5000	then claimrisk_id else null end))	COV_claim_count_5k,		
count(distinct (case when 	lossinc					>=	10000	then claimrisk_id else null end))	COV_claim_count_10k,		
count(distinct (case when 	lossinc					>=	25000	then claimrisk_id else null end))	COV_claim_count_25k,		
count(distinct (case when 	lossinc					>=	50000	then claimrisk_id else null end))	COV_claim_count_50k,		
count(distinct (case when 	lossinc					>=	100000	then claimrisk_id else null end))	COV_claim_count_100k,		
count(distinct (case when 	lossinc					>=	250000	then claimrisk_id else null end))	COV_claim_count_250k,		
count(distinct (case when 	lossinc					>=	500000	then claimrisk_id else null end))	COV_claim_count_500k,		
count(distinct (case when 	lossinc					>=	750000	then claimrisk_id else null end))	COV_claim_count_750k,		
count(distinct (case when 	lossinc					>=	1000000	then claimrisk_id else null end))	COV_claim_count_1M,		
count(distinct (case when 	lossinc					>	0	then claimrisk_id else null end))	COV_claim_count	,	
 --Claim Count											
count(distinct (case when 	allcov_lossinc	> 0 and allcov_lossinc<=	500	then claimrisk_id else null end))	claim_count_le500,						
count(distinct (case when 	allcov_lossinc					>=	1000	then claimrisk_id else null end))		claim_count_1000,	
count(distinct (case when 	allcov_lossinc					>=	1500	then claimrisk_id else null end))		claim_count_1500,	
count(distinct (case when 	allcov_lossinc					>=	2000	then claimrisk_id else null end))		claim_count_2000,	
count(distinct (case when 	allcov_lossinc					>=	2500	then claimrisk_id else null end))		claim_count_2500,	
count(distinct (case when 	allcov_lossinc					>=	5000	then claimrisk_id else null end))		claim_count_5k,	
count(distinct (case when 	allcov_lossinc					>=	10000	then claimrisk_id else null end))		claim_count_10k,	
count(distinct (case when 	allcov_lossinc					>=	25000	then claimrisk_id else null end))		claim_count_25k,	
count(distinct (case when 	allcov_lossinc					>=	50000	then claimrisk_id else null end))		claim_count_50k,	
count(distinct (case when 	allcov_lossinc					>=	100000	then claimrisk_id else null end))		claim_count_100k,	
count(distinct (case when 	allcov_lossinc					>=	250000	then claimrisk_id else null end))		claim_count_250k,	
count(distinct (case when 	allcov_lossinc					>=	500000	then claimrisk_id else null end))		claim_count_500k,	
count(distinct (case when 	allcov_lossinc					>=	750000	then claimrisk_id else null end))		claim_count_750k,	
count(distinct (case when 	allcov_lossinc					>=	1000000	then claimrisk_id else null end))		claim_count_1M,	
count(distinct (case when 	allcov_lossinc					>	0	then claimrisk_id else null end))		claim_count	,
 --All coverages											
 --nc											
sum(case when CatFlg='N' then	allcov_lossinc	else 0.00 end) nc_inc_loss,									
 --cat											
sum(	case when CatFlg='Y' then 	allcov_lossinc	 else 0.00 end)	cat_inc_loss	,						
 --nc											
sum( case when CatFlg='N' then 	 allcov_dcce	 else 0.00 end)	nc_inc_loss_dcce	,							
 --cat											
sum( case when CatFlg='Y' then 	 allcov_dcce	 else 0.00 end)	cat_inc_loss_dcce	,							
 --nc											
sum(	case when CatFlg='N' then 	lossinc	 else 0.00 end)	nc_cov_inc_loss	,						
 --cat											
sum(	case when CatFlg='Y' then 	lossinc	 else 0.00 end)	cat_cov_inc_loss	,						
 --nc dcce											
sum( case when CatFlg='N' then 	dcce	 else 0.00 end)	nc_cov_inc_loss_dcce	,							
 --cat											
sum( case when CatFlg='Y' then 	dcce	 else 0.00 end)	cat_cov_inc_loss_dcce	,							
--											
sum(BIlossinc1530) BIlossinc1530,											
sum(UMBIlossinc1530) UMBIlossinc1530,											
sum(UIMBIlossinc1530) UIMBIlossinc1530,											
--											
count(distinct Quality_ClaimOk_Flg) Quality_ClaimOk_Flg,											
count(distinct Quality_ClaimUnknownVIN_Flg) Quality_ClaimUnknownVIN_Flg,											
count(distinct Quality_ClaimUnknownVINNotListedDriver_Flg) Quality_ClaimUnknownVINNotListedDriver_Flg,											
count(distinct Quality_ClaimPolicyTermJoin_Flg) Quality_ClaimPolicyTermJoin_Flg											
 --											
											
from stg_auto_modeldata_claims m											
group by 											
modeldata_id,											
CoverageCd;											
											
											
											
/*											
4.3  Capping Aggregated Claims data											
*/											
											
drop table if exists tmp_fact_auto_modeldataset_claims_capped;											
create temporary table 	tmp_fact_auto_modeldataset_claims_capped as										
select											
modeldata_id	,										
--											
CoverageCd,											
											
--											
AtFaultcdClaims_count,											
 --											
 --COV Claim Count											
COV_claim_count_le500,											
COV_claim_count_1000,											
COV_claim_count_1500,											
COV_claim_count_2000,											
COV_claim_count_2500,											
COV_claim_count_5k,											
COV_claim_count_10k,											
COV_claim_count_25k,											
COV_claim_count_50k,											
COV_claim_count_100k,											
COV_claim_count_250k,											
COV_claim_count_500k,											
COV_claim_count_750k,											
COV_claim_count_1M,											
COV_claim_count,											
 --Claim Count											
claim_count_le500,											
claim_count_1000,											
claim_count_1500,											
claim_count_2000,											
claim_count_2500,											
claim_count_5k,											
claim_count_10k,											
claim_count_25k,											
claim_count_50k,											
claim_count_100k,											
claim_count_250k,											
claim_count_500k,											
claim_count_750k,											
claim_count_1M,											
claim_count	,										
 --All coverages											
 --nc											
case when 	500>=nc_inc_loss then	nc_inc_loss else 0.00 end	nc_inc_loss_le500,								
case when 1000<nc_inc_loss then 1000 else nc_inc_loss end	nc_inc_loss_1000,										
case when 1500<nc_inc_loss then 1500 else nc_inc_loss end	nc_inc_loss_1500,										
case when 2000<nc_inc_loss then 2000 else nc_inc_loss end	nc_inc_loss_2000,										
case when 2500<nc_inc_loss then 2500 else nc_inc_loss end	nc_inc_loss_2500,										
case when 5000<nc_inc_loss then 5000 else nc_inc_loss end	nc_inc_loss_5k,										
case when 10000<nc_inc_loss then 10000 else nc_inc_loss end	nc_inc_loss_10k,										
case when 25000<nc_inc_loss then 25000 else nc_inc_loss end	nc_inc_loss_25k,										
case when 50000<nc_inc_loss then 50000 else nc_inc_loss end	nc_inc_loss_50k,										
case when 100000<nc_inc_loss then 100000 else nc_inc_loss end	nc_inc_loss_100k,										
case when 250000<nc_inc_loss then 250000 else nc_inc_loss end	nc_inc_loss_250k,										
case when 500000<nc_inc_loss then 500000 else nc_inc_loss end	nc_inc_loss_500k,										
case when 750000<nc_inc_loss then 750000 else nc_inc_loss end	nc_inc_loss_750k,										
case when 1000000<nc_inc_loss then 1000000 else nc_inc_loss end	nc_inc_loss_1M,										
nc_inc_loss,											
 --cat											
case when 	500>=cat_inc_loss then	cat_inc_loss else 0.00 end	cat_inc_loss_le500,								
case when 1000<cat_inc_loss then 1000 else cat_inc_loss end	cat_inc_loss_1000,										
case when 1500<cat_inc_loss then 1500 else cat_inc_loss end	cat_inc_loss_1500,										
case when 2000<cat_inc_loss then 2000 else cat_inc_loss end	cat_inc_loss_2000,										
case when 2500<cat_inc_loss then 2500 else cat_inc_loss end	cat_inc_loss_2500,										
case when 5000<cat_inc_loss then 5000 else cat_inc_loss end	cat_inc_loss_5k,										
case when 10000<cat_inc_loss then 10000 else cat_inc_loss end	cat_inc_loss_10k,										
case when 25000<cat_inc_loss then 25000 else cat_inc_loss end	cat_inc_loss_25k,										
case when 50000<cat_inc_loss then 50000 else cat_inc_loss end	cat_inc_loss_50k,										
case when 100000<cat_inc_loss then 100000 else cat_inc_loss end	cat_inc_loss_100k,										
case when 250000<cat_inc_loss then 250000 else cat_inc_loss end	cat_inc_loss_250k,										
case when 500000<cat_inc_loss then 500000 else cat_inc_loss end	cat_inc_loss_500k,										
case when 750000<cat_inc_loss then 750000 else cat_inc_loss end	cat_inc_loss_750k,										
case when 1000000<cat_inc_loss then 1000000 else cat_inc_loss end	cat_inc_loss_1M, 										
cat_inc_loss	,										
 --nc											
case when 	500>=nc_inc_loss then	nc_inc_loss+nc_inc_loss_dcce else 0.00 end	nc_inc_loss_dcce_le500,								
case when 1000<nc_inc_loss then 1000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_1000,										
case when 1500<nc_inc_loss then 1500 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_1500,										
case when 2000<nc_inc_loss then 2000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_2000,										
case when 2500<nc_inc_loss then 2500 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_2500,										
case when 5000<nc_inc_loss then 5000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_5k,										
case when 10000<nc_inc_loss then 10000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_10k,										
case when 25000<nc_inc_loss then 25000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_25k,										
case when 50000<nc_inc_loss then 50000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_50k,										
case when 100000<nc_inc_loss then 100000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_100k,										
case when 250000<nc_inc_loss then 250000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_250k,										
case when 500000<nc_inc_loss then 500000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_500k,										
case when 750000<nc_inc_loss then 750000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_750k,										
case when 1000000<nc_inc_loss then 1000000 else nc_inc_loss end+nc_inc_loss_dcce	nc_inc_loss_dcce_1M,										
nc_inc_loss+nc_inc_loss_dcce nc_inc_loss_dcce,											
 --cat											
case when 	500>=cat_inc_loss then	cat_inc_loss+cat_inc_loss_dcce else 0.00 end	cat_inc_loss_dcce_le500,								
case when 1000<cat_inc_loss then 1000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_1000,										
case when 1500<cat_inc_loss then 1500 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_1500,										
case when 2000<cat_inc_loss then 2000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_2000,										
case when 2500<cat_inc_loss then 2500 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_2500,										
case when 5000<cat_inc_loss then 5000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_5k,										
case when 10000<cat_inc_loss then 10000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_10k,										
case when 25000<cat_inc_loss then 25000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_25k,										
case when 50000<cat_inc_loss then 50000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_50k,										
case when 100000<cat_inc_loss then 100000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_100k,										
case when 250000<cat_inc_loss then 250000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_250k,										
case when 500000<cat_inc_loss then 500000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_500k,										
case when 750000<cat_inc_loss then 750000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_750k,										
case when 1000000<cat_inc_loss then 1000000 else cat_inc_loss end+cat_inc_loss_dcce	cat_inc_loss_dcce_1M,										
cat_inc_loss+cat_inc_loss_dcce cat_inc_loss_dcce, 											
 --COV											
 --nc											
case when 	500>=nc_COV_inc_loss then	nc_COV_inc_loss else 0.00 end	nc_COV_inc_loss_le500,								
case when 1000<nc_COV_inc_loss then 1000 else nc_COV_inc_loss end	nc_COV_inc_loss_1000,										
case when 1500<nc_COV_inc_loss then 1500 else nc_COV_inc_loss end	nc_COV_inc_loss_1500,										
case when 2000<nc_COV_inc_loss then 2000 else nc_COV_inc_loss end	nc_COV_inc_loss_2000,										
case when 2500<nc_COV_inc_loss then 2500 else nc_COV_inc_loss end	nc_COV_inc_loss_2500,										
case when 5000<nc_COV_inc_loss then 5000 else nc_COV_inc_loss end	nc_COV_inc_loss_5k,										
case when 10000<nc_COV_inc_loss then 10000 else nc_COV_inc_loss end	nc_COV_inc_loss_10k,										
case when 25000<nc_COV_inc_loss then 25000 else nc_COV_inc_loss end	nc_COV_inc_loss_25k,										
case when 50000<nc_COV_inc_loss then 50000 else nc_COV_inc_loss end	nc_COV_inc_loss_50k,										
case when 100000<nc_COV_inc_loss then 100000 else nc_COV_inc_loss end	nc_COV_inc_loss_100k,										
case when 250000<nc_COV_inc_loss then 250000 else nc_COV_inc_loss end	nc_COV_inc_loss_250k,										
case when 500000<nc_COV_inc_loss then 500000 else nc_COV_inc_loss end	nc_COV_inc_loss_500k,										
case when 750000<nc_COV_inc_loss then 750000 else nc_COV_inc_loss end	nc_COV_inc_loss_750k,										
case when 1000000<nc_COV_inc_loss then 1000000 else nc_COV_inc_loss end	nc_COV_inc_loss_1M,	 									
nc_COV_inc_loss	,										
 --cat											
case when 	500>=cat_COV_inc_loss then	cat_COV_inc_loss else 0.00 end	cat_COV_inc_loss_le500,								
case when 1000<cat_COV_inc_loss then 1000 else cat_COV_inc_loss end	cat_COV_inc_loss_1000,										
case when 1500<cat_COV_inc_loss then 1500 else cat_COV_inc_loss end	cat_COV_inc_loss_1500,										
case when 2000<cat_COV_inc_loss then 2000 else cat_COV_inc_loss end	cat_COV_inc_loss_2000,										
case when 2500<cat_COV_inc_loss then 2500 else cat_COV_inc_loss end	cat_COV_inc_loss_2500,										
case when 5000<cat_COV_inc_loss then 5000 else cat_COV_inc_loss end	cat_COV_inc_loss_5k,										
case when 10000<cat_COV_inc_loss then 10000 else cat_COV_inc_loss end	cat_COV_inc_loss_10k,										
case when 25000<cat_COV_inc_loss then 25000 else cat_COV_inc_loss end	cat_COV_inc_loss_25k,										
case when 50000<cat_COV_inc_loss then 50000 else cat_COV_inc_loss end	cat_COV_inc_loss_50k,										
case when 100000<cat_COV_inc_loss then 100000 else cat_COV_inc_loss end	cat_COV_inc_loss_100k,										
case when 250000<cat_COV_inc_loss then 250000 else cat_COV_inc_loss end	cat_COV_inc_loss_250k,										
case when 500000<cat_COV_inc_loss then 500000 else cat_COV_inc_loss end	cat_COV_inc_loss_500k,										
case when 750000<cat_COV_inc_loss then 750000 else cat_COV_inc_loss end	cat_COV_inc_loss_750k,										
case when 1000000<cat_COV_inc_loss then 1000000 else cat_COV_inc_loss end	cat_COV_inc_loss_1M,	 									
cat_COV_inc_loss	,										
 --nc dcce											
case when 	500>=nc_COV_inc_loss then	nc_COV_inc_loss+nc_COV_inc_loss_dcce else 0.00 end	nc_COV_inc_loss_dcce_le500,								
case when 1000<nc_COV_inc_loss then 1000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_1000,										
case when 1500<nc_COV_inc_loss then 1500 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_1500,										
case when 2000<nc_COV_inc_loss then 2000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_2000,										
case when 2500<nc_COV_inc_loss then 2500 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_2500,										
case when 5000<nc_COV_inc_loss then 5000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_5k,										
case when 10000<nc_COV_inc_loss then 10000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_10k,										
case when 25000<nc_COV_inc_loss then 25000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_25k,										
case when 50000<nc_COV_inc_loss then 50000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_50k,										
case when 100000<nc_COV_inc_loss then 100000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_100k,										
case when 250000<nc_COV_inc_loss then 250000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_250k,										
case when 500000<nc_COV_inc_loss then 500000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_500k,										
case when 750000<nc_COV_inc_loss then 750000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_750k,										
case when 1000000<nc_COV_inc_loss then 1000000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce	nc_COV_inc_loss_dcce_1M,										
nc_COV_inc_loss+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce, 											
 --cat											
case when 	500>=cat_COV_inc_loss then	cat_COV_inc_loss+cat_COV_inc_loss_dcce else 0.00 end	cat_COV_inc_loss_dcce_le500,								
case when 1000<cat_COV_inc_loss then 1000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_1000,										
case when 1500<cat_COV_inc_loss then 1500 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_1500,										
case when 2000<cat_COV_inc_loss then 2000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_2000,										
case when 2500<cat_COV_inc_loss then 2500 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_2500,										
case when 5000<cat_COV_inc_loss then 5000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_5k,										
case when 10000<cat_COV_inc_loss then 10000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_10k,										
case when 25000<cat_COV_inc_loss then 25000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_25k,										
case when 50000<cat_COV_inc_loss then 50000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_50k,										
case when 100000<cat_COV_inc_loss then 100000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_100k,										
case when 250000<cat_COV_inc_loss then 250000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_250k,										
case when 500000<cat_COV_inc_loss then 500000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_500k,										
case when 750000<cat_COV_inc_loss then 750000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_750k,										
case when 1000000<cat_COV_inc_loss then 1000000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce	cat_COV_inc_loss_dcce_1M,										
cat_COV_inc_loss+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce,											
--											
BIlossinc1530	,										
UMBIlossinc1530		,									
UIMBIlossinc1530	,										
--											
Quality_ClaimOk_Flg,											
Quality_ClaimUnknownVIN_Flg,											
Quality_ClaimUnknownVINNotListedDriver_Flg,											
Quality_ClaimPolicyTermJoin_Flg											
from tmp_fact_auto_modeldataset_claims_grouped m	;										
											
drop table if exists tmp_fact_auto_modeldataset_claims_grouped;											
drop table if exists stg_auto_modeldata_claims;											
											
											
											
											
											
											
											
/*5 Final join modeldata (changes) without claims  and claims aggregated data*/											
truncate table fsbi_dw_spinn.fact_auto_modeldata;											
insert into fsbi_dw_spinn.fact_auto_modeldata											
select 			distinct 								
stg.modeldata_id			,								
stg.SystemIdStart			,								
stg.SystemIdEnd			,								
stg.risk_id			,								
stg.risktype			,								
stg.policy_id			,								
stg.policy_changes_id			,								
stg.producer_id			,								
stg.policy_uniqueid			,								
stg.risk_uniqueid			,								
stg.vehicle_id			,								
stg.vehicle_uniqueid			,								
stg.vin			,								
stg.risknumber			,								
stg.driver_id			,								
stg.driver_uniqueid			,								
stg.driverlicense			,								
stg.drivernumber			,								
stg.startdatetm			,								
stg.enddatetm			,								
stg.startdate			,								
stg.enddate			,								
stg.CntVeh			,								
stg.CntDrv			,								
stg.CntNonDrv			,								
stg.CntExcludedDrv			,								
stg.mindriverage			,								
stg.VehicleInceptionDate			,								
stg.DriverInceptionDate			,								
stg.Liabilityonly_Flg			,								
stg.Componly_Flg			,								
stg.ExcludedDrv_Flg			,								
isnull(	f.atfaultcdclaims_count,	0)	atfaultcdclaims_count	,							
isnull(	f.claim_count_le500,	0)	claim_count_le500	,							
isnull(	f.claim_count_1000,	0)	claim_count_1000	,							
isnull(	f.claim_count_1500,	0)	claim_count_1500	,							
isnull(	f.claim_count_2000,	0)	claim_count_2000	,							
isnull(	f.claim_count_2500,	0)	claim_count_2500	,							
isnull(	f.claim_count_5k,	0)	claim_count_5k	,							
isnull(	f.claim_count_10k,	0)	claim_count_10k	,							
isnull(	f.claim_count_25k,	0)	claim_count_25k	,							
isnull(	f.claim_count_50k,	0)	claim_count_50k	,							
isnull(	f.claim_count_100k,	0)	claim_count_100k	,							
isnull(	f.claim_count_250k,	0)	claim_count_250k	,							
isnull(	f.claim_count_500k,	0)	claim_count_500k	,							
isnull(	f.claim_count_750k,	0)	claim_count_750k	,							
isnull(	f.claim_count_1m,	0)	claim_count_1m	,							
isnull(	f.claim_count,	0)	claim_count	,							
isnull(	f.nc_inc_loss_le500,	0)	nc_inc_loss_le500	,							
isnull(	f.nc_inc_loss_1000,	0)	nc_inc_loss_1000	,							
isnull(	f.nc_inc_loss_1500,	0)	nc_inc_loss_1500	,							
isnull(	f.nc_inc_loss_2000,	0)	nc_inc_loss_2000	,							
isnull(	f.nc_inc_loss_2500,	0)	nc_inc_loss_2500	,							
isnull(	f.nc_inc_loss_5k,	0)	nc_inc_loss_5k	,							
isnull(	f.nc_inc_loss_10k,	0)	nc_inc_loss_10k	,							
isnull(	f.nc_inc_loss_25k,	0)	nc_inc_loss_25k	,							
isnull(	f.nc_inc_loss_50k,	0)	nc_inc_loss_50k	,							
isnull(	f.nc_inc_loss_100k,	0)	nc_inc_loss_100k	,							
isnull(	f.nc_inc_loss_250k,	0)	nc_inc_loss_250k	,							
isnull(	f.nc_inc_loss_500k,	0)	nc_inc_loss_500k	,							
isnull(	f.nc_inc_loss_750k,	0)	nc_inc_loss_750k	,							
isnull(	f.nc_inc_loss_1m,	0)	nc_inc_loss_1m	,							
isnull(	f.nc_inc_loss,	0)	nc_inc_loss	,							
isnull(	f.cat_inc_loss_le500,	0)	cat_inc_loss_le500	,							
isnull(	f.cat_inc_loss_1000,	0)	cat_inc_loss_1000	,							
isnull(	f.cat_inc_loss_1500,	0)	cat_inc_loss_1500	,							
isnull(	f.cat_inc_loss_2000,	0)	cat_inc_loss_2000	,							
isnull(	f.cat_inc_loss_2500,	0)	cat_inc_loss_2500	,							
isnull(	f.cat_inc_loss_5k,	0)	cat_inc_loss_5k	,							
isnull(	f.cat_inc_loss_10k,	0)	cat_inc_loss_10k	,							
isnull(	f.cat_inc_loss_25k,	0)	cat_inc_loss_25k	,							
isnull(	f.cat_inc_loss_50k,	0)	cat_inc_loss_50k	,							
isnull(	f.cat_inc_loss_100k,	0)	cat_inc_loss_100k	,							
isnull(	f.cat_inc_loss_250k,	0)	cat_inc_loss_250k	,							
isnull(	f.cat_inc_loss_500k,	0)	cat_inc_loss_500k	,							
isnull(	f.cat_inc_loss_750k,	0)	cat_inc_loss_750k	,							
isnull(	f.cat_inc_loss_1m,	0)	cat_inc_loss_1m	,							
isnull(	f.cat_inc_loss,	0)	cat_inc_loss	,							
isnull(	f.nc_inc_loss_dcce_le500,	0)	nc_inc_loss_dcce_le500	,							
isnull(	f.nc_inc_loss_dcce_1000,	0)	nc_inc_loss_dcce_1000	,							
isnull(	f.nc_inc_loss_dcce_1500,	0)	nc_inc_loss_dcce_1500	,							
isnull(	f.nc_inc_loss_dcce_2000,	0)	nc_inc_loss_dcce_2000	,							
isnull(	f.nc_inc_loss_dcce_2500,	0)	nc_inc_loss_dcce_2500	,							
isnull(	f.nc_inc_loss_dcce_5k,	0)	nc_inc_loss_dcce_5k	,							
isnull(	f.nc_inc_loss_dcce_10k,	0)	nc_inc_loss_dcce_10k	,							
isnull(	f.nc_inc_loss_dcce_25k,	0)	nc_inc_loss_dcce_25k	,							
isnull(	f.nc_inc_loss_dcce_50k,	0)	nc_inc_loss_dcce_50k	,							
isnull(	f.nc_inc_loss_dcce_100k,	0)	nc_inc_loss_dcce_100k	,							
isnull(	f.nc_inc_loss_dcce_250k,	0)	nc_inc_loss_dcce_250k	,							
isnull(	f.nc_inc_loss_dcce_500k,	0)	nc_inc_loss_dcce_500k	,							
isnull(	f.nc_inc_loss_dcce_750k,	0)	nc_inc_loss_dcce_750k	,							
isnull(	f.nc_inc_loss_dcce_1m,	0)	nc_inc_loss_dcce_1m	,							
isnull(	f.nc_inc_loss_dcce,	0)	nc_inc_loss_dcce	,							
isnull(	f.cat_inc_loss_dcce_le500,	0)	cat_inc_loss_dcce_le500	,							
isnull(	f.cat_inc_loss_dcce_1000,	0)	cat_inc_loss_dcce_1000	,							
isnull(	f.cat_inc_loss_dcce_1500,	0)	cat_inc_loss_dcce_1500	,							
isnull(	f.cat_inc_loss_dcce_2000,	0)	cat_inc_loss_dcce_2000	,							
isnull(	f.cat_inc_loss_dcce_2500,	0)	cat_inc_loss_dcce_2500	,							
isnull(	f.cat_inc_loss_dcce_5k,	0)	cat_inc_loss_dcce_5k	,							
isnull(	f.cat_inc_loss_dcce_10k,	0)	cat_inc_loss_dcce_10k	,							
isnull(	f.cat_inc_loss_dcce_25k,	0)	cat_inc_loss_dcce_25k	,							
isnull(	f.cat_inc_loss_dcce_50k,	0)	cat_inc_loss_dcce_50k	,							
isnull(	f.cat_inc_loss_dcce_100k,	0)	cat_inc_loss_dcce_100k	,							
isnull(	f.cat_inc_loss_dcce_250k,	0)	cat_inc_loss_dcce_250k	,							
isnull(	f.cat_inc_loss_dcce_500k,	0)	cat_inc_loss_dcce_500k	,							
isnull(	f.cat_inc_loss_dcce_750k,	0)	cat_inc_loss_dcce_750k	,							
isnull(	f.cat_inc_loss_dcce_1m,	0)	cat_inc_loss_dcce_1m	,							
isnull(	f.cat_inc_loss_dcce,	0)	cat_inc_loss_dcce	,							
stg.coll_deductible			,								
stg.comp_deductible			,								
stg.bi_limit1			,								
stg.bi_limit2			,								
stg.umbi_limit1			,								
stg.umbi_limit2			,								
stg.pd_limit1			,								
stg.pd_limit2			,								
stg.coveragecd			,								
stg.Limit1			,								
stg.Limit2			,								
stg.Deductible			,								
stg.wp			,								
isnull(f.cov_claim_count_le500	,0)	cov_claim_count_le500	,								
isnull(f.cov_claim_count_1000 	,0)	cov_claim_count_1000 	,								
isnull(f.cov_claim_count_1500 	,0)	cov_claim_count_1500 	,								
isnull(f.cov_claim_count_2000 	,0)	cov_claim_count_2000 	,								
isnull(f.cov_claim_count_2500 	,0)	cov_claim_count_2500 	,								
isnull(f.cov_claim_count_5k 	,0)	cov_claim_count_5k 	,								
isnull(f.cov_claim_count_10k 	,0)	cov_claim_count_10k 	,								
isnull(f.cov_claim_count_25k 	,0)	cov_claim_count_25k 	,								
isnull(f.cov_claim_count_50k 	,0)	cov_claim_count_50k 	,								
isnull(f.cov_claim_count_100k 	,0)	cov_claim_count_100k 	,								
isnull(f.cov_claim_count_250k 	,0)	cov_claim_count_250k 	,								
isnull(f.cov_claim_count_500k 	,0)	cov_claim_count_500k 	,								
isnull(f.cov_claim_count_750k 	,0)	cov_claim_count_750k 	,								
isnull(f.cov_claim_count_1m 	,0)	cov_claim_count_1m 	,								
isnull(f.cov_claim_count 	,0)	cov_claim_count 	,								
isnull(f.nc_cov_inc_loss_le500 	,0)	nc_cov_inc_loss_le500 	,								
isnull(f.nc_cov_inc_loss_1000 	,0)	nc_cov_inc_loss_1000 	,								
isnull(f.nc_cov_inc_loss_1500 	,0)	nc_cov_inc_loss_1500 	,								
isnull(f.nc_cov_inc_loss_2000 	,0)	nc_cov_inc_loss_2000 	,								
isnull(f.nc_cov_inc_loss_2500 	,0)	nc_cov_inc_loss_2500 	,								
isnull(f.nc_cov_inc_loss_5k 	,0)	nc_cov_inc_loss_5k 	,								
isnull(f.nc_cov_inc_loss_10k 	,0)	nc_cov_inc_loss_10k 	,								
isnull(f.nc_cov_inc_loss_25k 	,0)	nc_cov_inc_loss_25k 	,								
isnull(f.nc_cov_inc_loss_50k 	,0)	nc_cov_inc_loss_50k 	,								
isnull(f.nc_cov_inc_loss_100k 	,0)	nc_cov_inc_loss_100k 	,								
isnull(f.nc_cov_inc_loss_250k 	,0)	nc_cov_inc_loss_250k 	,								
isnull(f.nc_cov_inc_loss_500k 	,0)	nc_cov_inc_loss_500k 	,								
isnull(f.nc_cov_inc_loss_750k 	,0)	nc_cov_inc_loss_750k 	,								
isnull(f.nc_cov_inc_loss_1m 	,0)	nc_cov_inc_loss_1m 	,								
isnull(f.nc_cov_inc_loss 	,0)	nc_cov_inc_loss 	,								
isnull(f.cat_cov_inc_loss_le500 	,0)	cat_cov_inc_loss_le500 	,								
isnull(f.cat_cov_inc_loss_1000 	,0)	cat_cov_inc_loss_1000 	,								
isnull(f.cat_cov_inc_loss_1500 	,0)	cat_cov_inc_loss_1500 	,								
isnull(f.cat_cov_inc_loss_2000 	,0)	cat_cov_inc_loss_2000 	,								
isnull(f.cat_cov_inc_loss_2500 	,0)	cat_cov_inc_loss_2500 	,								
isnull(f.cat_cov_inc_loss_5k 	,0)	cat_cov_inc_loss_5k 	,								
isnull(f.cat_cov_inc_loss_10k 	,0)	cat_cov_inc_loss_10k 	,								
isnull(f.cat_cov_inc_loss_25k 	,0)	cat_cov_inc_loss_25k 	,								
isnull(f.cat_cov_inc_loss_50k 	,0)	cat_cov_inc_loss_50k 	,								
isnull(f.cat_cov_inc_loss_100k 	,0)	cat_cov_inc_loss_100k 	,								
isnull(f.cat_cov_inc_loss_250k 	,0)	cat_cov_inc_loss_250k 	,								
isnull(f.cat_cov_inc_loss_500k 	,0)	cat_cov_inc_loss_500k 	,								
isnull(f.cat_cov_inc_loss_750k 	,0)	cat_cov_inc_loss_750k 	,								
isnull(f.cat_cov_inc_loss_1m 	,0)	cat_cov_inc_loss_1m 	,								
isnull(f.cat_cov_inc_loss 	,0)	cat_cov_inc_loss 	,								
isnull(f.nc_cov_inc_loss_dcce_le500 	,0)	nc_cov_inc_loss_dcce_le500 	,								
isnull(f.nc_cov_inc_loss_dcce_1000 	,0)	nc_cov_inc_loss_dcce_1000 	,								
isnull(f.nc_cov_inc_loss_dcce_1500 	,0)	nc_cov_inc_loss_dcce_1500 	,								
isnull(f.nc_cov_inc_loss_dcce_2000 	,0)	nc_cov_inc_loss_dcce_2000 	,								
isnull(f.nc_cov_inc_loss_dcce_2500 	,0)	nc_cov_inc_loss_dcce_2500 	,								
isnull(f.nc_cov_inc_loss_dcce_5k 	,0)	nc_cov_inc_loss_dcce_5k 	,								
isnull(f.nc_cov_inc_loss_dcce_10k 	,0)	nc_cov_inc_loss_dcce_10k 	,								
isnull(f.nc_cov_inc_loss_dcce_25k 	,0)	nc_cov_inc_loss_dcce_25k 	,								
isnull(f.nc_cov_inc_loss_dcce_50k 	,0)	nc_cov_inc_loss_dcce_50k 	,								
isnull(f.nc_cov_inc_loss_dcce_100k 	,0)	nc_cov_inc_loss_dcce_100k 	,								
isnull(f.nc_cov_inc_loss_dcce_250k 	,0)	nc_cov_inc_loss_dcce_250k 	,								
isnull(f.nc_cov_inc_loss_dcce_500k 	,0)	nc_cov_inc_loss_dcce_500k 	,								
isnull(f.nc_cov_inc_loss_dcce_750k 	,0)	nc_cov_inc_loss_dcce_750k 	,								
isnull(f.nc_cov_inc_loss_dcce_1m 	,0)	nc_cov_inc_loss_dcce_1m 	,								
isnull(f.nc_cov_inc_loss_dcce 	,0)	nc_cov_inc_loss_dcce 	,								
isnull(f.cat_cov_inc_loss_dcce_le500 	,0)	cat_cov_inc_loss_dcce_le500 	,								
isnull(f.cat_cov_inc_loss_dcce_1000 	,0)	cat_cov_inc_loss_dcce_1000 	,								
isnull(f.cat_cov_inc_loss_dcce_1500 	,0)	cat_cov_inc_loss_dcce_1500 	,								
isnull(f.cat_cov_inc_loss_dcce_2000 	,0)	cat_cov_inc_loss_dcce_2000 	,								
isnull(f.cat_cov_inc_loss_dcce_2500 	,0)	cat_cov_inc_loss_dcce_2500 	,								
isnull(f.cat_cov_inc_loss_dcce_5k 	,0)	cat_cov_inc_loss_dcce_5k 	,								
isnull(f.cat_cov_inc_loss_dcce_10k 	,0)	cat_cov_inc_loss_dcce_10k 	,								
isnull(f.cat_cov_inc_loss_dcce_25k 	,0)	cat_cov_inc_loss_dcce_25k 	,								
isnull(f.cat_cov_inc_loss_dcce_50k 	,0)	cat_cov_inc_loss_dcce_50k 	,								
isnull(f.cat_cov_inc_loss_dcce_100k 	,0)	cat_cov_inc_loss_dcce_100k 	,								
isnull(f.cat_cov_inc_loss_dcce_250k 	,0)	cat_cov_inc_loss_dcce_250k 	,								
isnull(f.cat_cov_inc_loss_dcce_500k 	,0)	cat_cov_inc_loss_dcce_500k 	,								
isnull(f.cat_cov_inc_loss_dcce_750k 	,0)	cat_cov_inc_loss_dcce_750k 	,								
isnull(f.cat_cov_inc_loss_dcce_1m 	,0)	cat_cov_inc_loss_dcce_1m 	,								
isnull(f.cat_cov_inc_loss_dcce	,0)	cat_cov_inc_loss_dcce	,								
isnull(f.BIlossinc1530	,0)	BIlossinc1530	,								
isnull(f.UMBIlossinc1530	,0)	UMBIlossinc1530	,								
isnull(f.UIMBIlossinc1530	,0)	UIMBIlossinc1530	,								
stg.Quality_PolAppInconsistency_Flg			,								
stg.Quality_RiskIdDuplicates_Flg			,								
stg.Quality_ExcludedDrv_Flg			,								
stg.Quality_ReplacedVIN_Flg			,								
stg.Quality_ReplacedDriver_Flg			,								
isnull(	f.Quality_claimok_Flg,	0)	Quality_claimok_Flg	,							
isnull(	f.Quality_claimunknownvin_Flg,	0)	Quality_claimunknownvin_Flg	,							
isnull(	f.Quality_claimunknownvinnotlisteddriver_Flg,	0)	Quality_claimunknownvinnotlisteddriver_Flg	,							
isnull(	f.Quality_claimpolicytermjoin_Flg,	0)	Quality_claimpolicytermjoin_Flg	,							
ploaddate loaddate 											
from tmp_auto_modeldata stg											
left outer join tmp_fact_auto_modeldataset_claims_capped f											
on f.modeldata_id=stg.modeldata_id											
and f.coveragecd=stg.coveragecd;											
											
drop table if exists tmp_fact_auto_modeldataset_claims_capped;											
drop table if exists tmp_auto_modeldata;											
											
											
END;											
											



$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_fact_customer_rel(sql_loaddate timestamp)
	LANGUAGE plpgsql
AS $$
		
	
BEGIN 	


	
drop table if exists stg_customer_rel;	
create temporary table stg_customer_rel as 
select 	distinct
cast(p.CustomerRef as varchar) Customer_UniqueId,	
cast(p.SystemId as varchar) Policy_UniqueID,	
coalesce(pldp.PaperLessDeliveryInd, 'No') PaperLessDeliveryInd,	
coalesce(to_date(substring(pldp.LastEnrollmentDt,1,8),'YYYYMMDD'),'1900-01-01') LastEnrollmentDt,	
coalesce(to_date(substring(pldp.LastUnEnrollmentDt,1,8),'YYYYMMDD'),'1900-01-01') LastUnEnrollmentDt,	
coalesce(pldp.LastEnrollmentMethod,'Unknown') LastEnrollmentMethod	,	
coalesce(cast(cr.SystemId as varchar),'Unknown') PortalUser_UniqueId	
from aurora_prodCSE_dw.Policy p 	
join aurora_prodCSE_dw.BasicPolicy bp	
on p.SystemId=bp.SystemId	
and p.cmmContainer=bp.cmmContainer	
left outer join aurora_prodCSE_dw.PaperlessDeliveryPolicy pldp 	
on p.CustomerRef=pldp.SystemId	
and bp.PolicyNumber=pldp.PolicyNumber	
and pldp.cmmContainer='Customer'	
and pldp._fivetran_deleted=false
left outer join aurora_prodCSE_dw.LinkReference cr
on cr.SystemIdRef=p.CustomerRef
and cr.ModelName='Customer'	
and cr.cmmcontainer='CustomerLogin'
and cr._fivetran_deleted=false
where p.cmmcontainer='Policy'
and p._fivetran_deleted=false
and bp._fivetran_deleted=false;	


	

truncate table fsbi_dw_spinn.FACT_CUSTOMER_REL;
insert into fsbi_dw_spinn.FACT_CUSTOMER_REL
with data as (
select distinct
cast(r.customer_uniqueid as int) customer_id,
p.policy_id,
r.paperlessdeliveryind,
te.time_id lastenrollmentdt_id,
tue.time_id lastunenrollmentdt_id,
r.LastEnrollmentMethod,
pu.portaluser_id,
sql_loadDate LoadDate
from stg_customer_rel r
join fsbi_dw_spinn.dim_customer c
on r.customer_uniqueid=c.customer_uniqueid
join fsbi_dw_spinn.dim_portaluser pu
on r.portaluser_uniqueid=pu.portaluser_uniqueid
join fsbi_dw_spinn.dim_policy p
on p.pol_uniqueid=r.policy_uniqueid
join fsbi_dw_spinn.dim_time te
on r.lastenrollmentdt=te.tm_date
join fsbi_dw_spinn.dim_time tue
on r.lastunenrollmentdt=tue.tm_date
)
select
row_number() over(order by policy_id,customer_id) customer_rel_id,
data.*
from data
order by policy_id,customer_id;


END;


$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_fact_datareport(sql_bookdate date, sql_currentdate date, sql_loaddate timestamp, loadtype varchar)
	LANGUAGE plpgsql
AS $$
	
	
		
	
BEGIN 	
	
/*Scope*/	
	
drop table if exists tmp_scope;	
	
if LoadType='d' then	
	
create temporary table tmp_scope  as	
select 	
cb.SystemId,cb.cmmContainer	
from  aurora_prodcse_dw.xxchangedbeans cb	
where cb.cmmContainer='Application'	
and cast( cb._fivetran_synced AT TIME ZONE 'PST' as date) > sql_bookDate and cast( cb._fivetran_synced AT TIME ZONE 'PST' as date)  <= sql_currentDate	
and cb._fivetran_deleted=False	
union	
select drq.SystemId,drq.cmmContainer	
from  aurora_prodcse_dw.xxchangedbeans cb	
join aurora_prodcse_dw.DataReportRequest drq	
on drq.DataReportRef=cb.SystemId	
and drq.cmmContainer='Application'	
where cb.cmmContainer='DataReport'	
and cast( cb._fivetran_synced AT TIME ZONE 'PST' as date) > sql_bookDate and cast( cb._fivetran_synced AT TIME ZONE 'PST' as date)  <= sql_currentDate	
and cb._fivetran_deleted=False	
union	
select SystemId,'Application'	
from fsbi_stg_spinn.vstg_policyhistory h	
where  h.BookDt  > sql_bookDate and h.BookDt  <= sql_currentDate;	
	
else	
	
create temporary table tmp_scope	as
select cb.SystemId,cb.cmmContainer	
from  aurora_prodcse_dw.application cb	
where cb.cmmContainer='Application'	
and to_date(cb.UpdateTimestamp, 'mm/dd/yyyy')>dateadd(day, -1, sql_bookDate) and to_date(cb.UpdateTimestamp, 'mm/dd/yyyy') <= dateadd(day, 1, sql_currentDate)	
and cb._fivetran_deleted=False	
union	
select SystemId,'Application'	
from fsbi_stg_spinn.vstg_policyhistory h	
where  h.BookDt  > sql_bookDate and h.BookDt  <= sql_currentDate;	
	
	
end if;	
	
/*Staging*/	
	
drop table if exists stg_datareport;	
create temporary table stg_datareport  as	
select 	distinct
drq.SystemId application_uniqueid,	
cse_bi.ifempty(drpt.TypeCd,'Unknown') TypeCd ,	
cse_bi.ifempty(drq.TemplateIdRef,'Unknown') TemplateIdRef,	
cast(cse_bi.ifempty(substring(drq.AddDt,1,10) + ' '+ substring(drq.AddTm,1,8),'1900-01-01') as timestamp) DataReportRequestAddDt ,	
cse_bi.ifempty(drq.SourceIdRef,'Unknown') RiskIds,	
cse_bi.ifempty(b.Id,'Unknown') BuildingId,	
cse_bi.ifempty(v.Id,'Unknown') VehicleId,	
nvl(drpt.Systemid,0) DataReportId ,	
cse_bi.ifempty(drq.StatusCd ,'Unknown') DataReportRequestStatus,	
cse_bi.ifempty(drpt.StatusCd ,'Unknown') DataReportStatus ,	
replace(replace(replace(cse_bi.ifempty(drpt.ResultCd ,'Unknown'),'"',''),'\r\n',' '),'\n',' ') DataReportResult,	
cast(cse_bi.ifempty(substring(drpt.ReceivedDt,1,10)+' '+substring(drpt.ReceivedTm,1,8),'1900-01-01') as timestamp)  DataReportReceivedDt,	
cast(cse_bi.ifempty(substring(drpt.TransmittedDt,1,10) + ' '+ substring(drpt.TransmittedTm,1,8),'1900-01-01') as timestamp)  DataReportTransmittedDt,	
cast(cse_bi.ifempty(substring(drpt.AddDt,1,10)+' '+substring(drpt.AddTm,1,8),'1900-01-01') as timestamp)  DataReportAddDt	
from tmp_scope s	
join aurora_prodcse_dw.DataReportRequest    drq 	
on s.SystemId=drq.SystemId	
join aurora_prodcse_dw.BasicPolicy bp	
on drq.SystemId=bp.SystemId	
and drq.CMMContainer=bp.CMMContainer	
left outer join aurora_prodcse_dw.DataReport drpt 	
on drpt.SystemId=drq.DataReportRef	
and drpt.CMMContainer='DataReport'	
and drpt._fivetran_deleted=False	
left outer join aurora_prodcse_dw.Building b	
on drq.SystemId=b.SystemId	
and drq.cmmContainer=b.cmmContainer	
and drq.SourceIdRef=b.ParentId	
and bp.SubTypeCd!='PA'	
and b._fivetran_deleted=False	
left outer join aurora_prodcse_dw.Vehicle v	
on drq.SystemId=v.SystemId	
and drq.cmmContainer=v.cmmContainer	
and drq.SourceIdRef like '%'+v.ParentId+'%'	
and bp.SubTypeCd='PA'	
and v._fivetran_deleted=False	
where drq.CMMContainer='Application'	
and ((drq.AddDt>='2016-01-01') or (drpt.TransmittedDt>='2016-01-01'))	
and drq._fivetran_deleted=False	
and bp._fivetran_deleted=False;	
	
/*Dimension table*/	
	
insert into fsbi_dw_spinn.dim_datareport	
(	
datareport_id,	
typecd,	
templateidref,	
vendor,	
detaildatain,	
loaddate	
)	
with data as (	
select distinct	
stg.TemplateIDRef	
from stg_datareport	 stg
except	
select	
TemplateIDRef	
from fsbi_dw_spinn.dim_datareport	
)	
,  m as (select max(datareport_id) datareport_id from fsbi_dw_spinn.dim_datareport)	
select	
m.datareport_id+row_number() over(order by templateidref) datareport_id, 	
'Unknown' typecd,	
data.templateidref,	
'~' vendor,	
'~' detaildatain,	
sql_loadDate LoadDate	
from data	
join m	
on 1=1	;
	
	
	
with data as (	
select distinct TypeCd, TemplateIDRef	
from stg_datareport	 stg
where typecd<>'Unknown'	
)	
update fsbi_dw_spinn.dim_datareport	
set TypeCd=data.TypeCd	
from data	
where data.TemplateIDRef=fsbi_dw_spinn.dim_datareport.TemplateIDRef	
and fsbi_dw_spinn.dim_datareport.TypeCd='Unknown';	
	
/*FACT table*/	
	
/*First delete data for an application, report type and RiskIds	
which are in FACT already but there is some updated info in STG*/	
delete 	
from fsbi_dw_spinn.fact_datareport	
using stg_datareport stg 	
where fsbi_dw_spinn.fact_datareport.APPLICATION_ID=stg.APPLICATION_UNIQUEID;	
	
drop table if exists tmp_fact_datareport;	
create temporary table tmp_fact_datareport  as	
with 	
 m as (select max(factdatareport_id) factdatareport_id from fsbi_dw_spinn.fact_datareport)	
,data as (	
/*RiskIds in ONLY CLUE Personal Auto is concatanation of Driver PartyInfo Ids and Vehicle Risk Ids	
Vehicle Risk Ids are converted into Vehicle Ids in Aurora SP and create one row for each vehicle	
Driver PartyInfo Ids available in DW and the query below just create one row for each driver	
*/	
select distinct	
stg.application_uniqueid,	
stg.TypeCd,	
stg.TemplateIDRef,	
stg.DataReportRequestAddDt,	
d.SPINNDriver_Id RiskIds,	
stg.BuildingId,	
'Unknown' VehicleId,	
stg.DataReportId,	
stg.DataReportRequestStatus,	
stg.DataReportStatus,	
stg.DataReportResult,	
stg.DataReportReceivedDt,	
stg.DataReportTransmittedDt,	
stg.DataReportAddDt	
from stg_datareport stg 	
left outer join fsbi_dw_spinn.DIM_APP_DRIVER d	
on d.Application_id=stg.application_uniqueid	
and stg.RiskIds like '%'+d.SPINNDriver_Id+'%'	
where TypeCd='CLUE Personal Auto'	
union all	
select distinct	
stg.application_uniqueid,	
stg.TypeCd,	
stg.TemplateIDRef,	
stg.DataReportRequestAddDt,	
stg.RiskIds,	
stg.BuildingId,	
stg.VehicleId,	
stg.DataReportId,	
stg.DataReportRequestStatus,	
stg.DataReportStatus,	
stg.DataReportResult,	
stg.DataReportReceivedDt,	
stg.DataReportTransmittedDt,	
stg.DataReportAddDt	
from stg_datareport stg 	
)	
select distinct	
m.factdatareport_id, 	
stg.application_uniqueid APPLICATION_ID,	
coalesce(p.policy_id,0)  POLICY_ID,	
coalesce(prd.PRODUCT_ID,0) PRODUCT_ID,	
coalesce(prod.PRODUCER_ID,0) PRODUCER_ID,	
coalesce(dr.DATAREPORT_ID,0) DATAREPORT_ID,	
coalesce(b.BUILDING_APP_ID,0) BUILDING_APP_ID,	
coalesce(v.VEHICLE_APP_ID,0) VEHICLE_APP_ID,	
coalesce(d.Driver_app_id,0) DRIVER_APP_ID,	
stg.DataReportRequestStatus,	
stg.DataReportStatus,	
stg.DataReportResult,	
stg.DataReportRequestAddDt,	
stg.DataReportReceivedDt,	
stg.DataReportTransmittedDt,	
stg.DataReportAddDt,	
a.approved_policy_uniqueid POLICY_UNIQUEID,	
a.PRODUCT_UNIQUEID,	
a.PRODUCER_UNIQUEID,	
stg.RiskIds,	
stg.TemplateIdRef,	
stg.DataReportId,	
sql_loadDate LoadDate	
from data stg	
join m	
on 1=1	
join fsbi_dw_spinn.DIM_APPLICATION a	
on a.application_id=stg.application_uniqueid	
join fsbi_dw_spinn.DIM_POLICY p	
on p.pol_uniqueid=a.approved_policy_uniqueid	
left outer join fsbi_dw_spinn.DIM_PRODUCT prd	
on prd.product_uniqueid=a.PRODUCT_UNIQUEID	
left outer join fsbi_dw_spinn.DIM_PRODUCER prod	
on prod.PRODUCER_UNIQUEID=a.PRODUCER_UNIQUEID	
and prod.Valid_ToDate='2200-01-01'
left outer join fsbi_dw_spinn.DIM_DATAREPORT dr	
on dr.TemplateIDRef = stg.TemplateIDRef	
left outer join fsbi_dw_spinn.DIM_APP_DRIVER d	
on d.Application_id=stg.application_uniqueid	
and d.SPINNDriver_Id=stg.RiskIds	
left outer join fsbi_dw_spinn.DIM_APP_BUILDING b	
on b.Application_id=stg.application_uniqueid	
and b.SPInnBuilding_Id=stg.BuildingId	
left outer join fsbi_dw_spinn.DIM_APP_VEHICLE v	
on v.Application_id=stg.application_uniqueid	
and v.SPInnVehicle_Id=stg.VehicleId;	

insert into fsbi_dw_spinn.fact_datareport	
select 	
factdatareport_id + row_number() over(order by application_id) factdatareport_id, 	
APPLICATION_ID,	
POLICY_ID,	
PRODUCT_ID,	
PRODUCER_ID,	
DATAREPORT_ID,	
BUILDING_APP_ID,	
VEHICLE_APP_ID,	
DRIVER_APP_ID,	
DataReportRequestStatus,	
DataReportStatus,	
DataReportResult,	
DataReportRequestAddDt,	
DataReportReceivedDt,	
DataReportTransmittedDt,	
DataReportAddDt,	
POLICY_UNIQUEID,	
PRODUCT_UNIQUEID,	
PRODUCER_UNIQUEID,	
RiskIds,	
TemplateIdRef,	
DataReportId,	
LoadDate	
from tmp_fact_datareport;	
	
END;	
	



$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_fact_property_modeldata(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
	
					
BEGIN 				
				
 /*				
Author: Kate Drogaieva				
Purpose: This script populate FACT_HO_LL_MODELDATA				
Comment: Due to back dated transactions it was made as a full refresh.				
	Last Modification Date:			
Last Modification Date: 07/06/2020				
Adding Limits for THEFA coverage (On-premises and Away from premises				
12/16/2019 POLICY_CHANGES_ID added from DIM_POLICY_CHANGES				
10/25/2019 Total WP and Losses columns added				
10/03/2019 distinct in final select to eliminate duplication due to a SPINN glitch (more then one transaction with the same SystemId				
09/20/2019 population of CovA_FL - CovC_EC	added			
*/				
				
				
				
  /*1. Grouping and aggregating claims data				
 a temp table is used because grouping by modeldata_id is much faster*/				
 				
				
				
drop table if exists tmp_FACT_HO_LL_MODELDATA_IL;				
create temporary table tmp_FACT_HO_LL_MODELDATA_IL as				
select				
modeldata_id	,			
count(distinct Quality_ClaimOk_Flg) 	Quality_ClaimOk_Flg ,			
count(Quality_ClaimPolicyTermJoin_Flg)	Quality_ClaimPolicyTermJoin_Flg ,			
 --				
sum(isnull(CovA_inc_loss,0)+isnull(CovB_inc_loss,0)+isnull(CovC_inc_loss,0)+isnull(CovD_inc_loss,0)+isnull(CovE_inc_loss,0)+isnull(CovF_inc_loss,0)+isnull(LIAB_inc_loss,0)) Loss,				
count(distinct claimnumber) Claim_Count,				
 --				
sum(case when CatFlg='Yes' then CovA_inc_loss+CovB_inc_loss+CovC_inc_loss+CovD_inc_loss+CovE_inc_loss+CovF_inc_loss+LIAB_inc_loss else 0 end)  Cat_Loss,				
count(distinct case when CatFlg='Yes' then claimnumber else null end) Cat_Claim_Count,				
/*Inc Loss*/				
/*CovA*/				
sum(case when NC_Water='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_NC_Water	,		
sum(case when NC_WH='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_NC_WH	,		
sum(case when NC_TV='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_NC_TV	,		
sum(case when NC_FL='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_NC_FL	,		
sum(case when NC_AO='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovA_inc_loss else 0 end)  	CovA_IL_Cat_AO	,		
/*CovB*/				
sum(case when NC_Water='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_NC_Water	,		
sum(case when NC_WH='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_NC_WH	,		
sum(case when NC_TV='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_NC_TV	,		
sum(case when NC_FL='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_NC_FL	,		
sum(case when NC_AO='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovB_inc_loss else 0 end)  	CovB_IL_Cat_AO	,		
/*CovC*/				
sum(case when NC_Water='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_NC_Water	,		
sum(case when NC_WH='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_NC_WH	,		
sum(case when NC_TV='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_NC_TV	,		
sum(case when NC_FL='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_NC_FL	,		
sum(case when NC_AO='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovC_inc_loss else 0 end)  	CovC_IL_Cat_AO	,		
/*CovD*/				
sum(case when NC_Water='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_NC_Water	,		
sum(case when NC_WH='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_NC_WH	,		
sum(case when NC_TV='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_NC_TV	,		
sum(case when NC_FL='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_NC_FL	,		
sum(case when NC_AO='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovD_inc_loss else 0 end)  	CovD_IL_Cat_AO	,		
/*CovE*/				
sum(case when NC_Water='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_NC_Water	,		
sum(case when NC_WH='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_NC_WH	,		
sum(case when NC_TV='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_NC_TV	,		
sum(case when NC_FL='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_NC_FL	,		
sum(case when NC_AO='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovE_inc_loss else 0 end)  	CovE_IL_Cat_AO	,		
/*CovF*/				
sum(case when NC_Water='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_NC_Water	,		
sum(case when NC_WH='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_NC_WH	,		
sum(case when NC_TV='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_NC_TV	,		
sum(case when NC_FL='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_NC_FL	,		
sum(case when NC_AO='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovF_inc_loss else 0 end)  	CovF_IL_Cat_AO	,		
/*LIAB*/				
sum(case when NC_Water='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_NC_Water	,		
sum(case when NC_WH='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_NC_WH	,		
sum(case when NC_TV='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_NC_TV	,		
sum(case when NC_FL='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_NC_FL	,		
sum(case when NC_AO='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_NC_AO	,		
sum(case when CAT_FL='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_Cat_Fire	,		
sum(case when CAT_AO='Yes' then LIAB_inc_loss else 0 end)  	LIAB_IL_Cat_AO	,		
/*Inc Loss + DCCE*/				
/*CovA*/				
sum(case when NC_Water='Yes' then CovA_inc_loss + CovA_dcce else 0 end)  	CovA_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then CovA_inc_loss+CovA_dcce else 0 end)  	CovA_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then CovA_inc_loss+CovA_dcce else 0 end)  	CovA_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then CovA_inc_loss+CovA_dcce else 0 end)  	CovA_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then CovA_inc_loss+CovA_dcce else 0 end)  	CovA_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovA_inc_loss+CovA_dcce else 0 end)  	CovA_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovA_inc_loss+CovA_dcce else 0 end)  	CovA_IL_DCCE_Cat_AO	,		
/*CovB*/				
sum(case when NC_Water='Yes' then CovB_inc_loss + CovB_dcce else 0 end)  	CovB_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then CovB_inc_loss+CovB_dcce else 0 end)  	CovB_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then CovB_inc_loss+CovB_dcce else 0 end)  	CovB_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then CovB_inc_loss+CovB_dcce else 0 end)  	CovB_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then CovB_inc_loss+CovB_dcce else 0 end)  	CovB_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovB_inc_loss+CovB_dcce else 0 end)  	CovB_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovB_inc_loss+CovB_dcce else 0 end)  	CovB_IL_DCCE_Cat_AO	,		
/*CovC*/				
sum(case when NC_Water='Yes' then CovC_inc_loss + CovC_dcce else 0 end)  	CovC_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then CovC_inc_loss+CovC_dcce else 0 end)  	CovC_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then CovC_inc_loss+CovC_dcce else 0 end)  	CovC_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then CovC_inc_loss+CovC_dcce else 0 end)  	CovC_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then CovC_inc_loss+CovC_dcce else 0 end)  	CovC_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovC_inc_loss+CovC_dcce else 0 end)  	CovC_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovC_inc_loss+CovC_dcce else 0 end)  	CovC_IL_DCCE_Cat_AO	,		
/*CovD*/				
sum(case when NC_Water='Yes' then CovD_inc_loss + CovD_dcce else 0 end)  	CovD_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then CovD_inc_loss+CovD_dcce else 0 end)  	CovD_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then CovD_inc_loss+CovD_dcce else 0 end)  	CovD_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then CovD_inc_loss+CovD_dcce else 0 end)  	CovD_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then CovD_inc_loss+CovD_dcce else 0 end)  	CovD_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovD_inc_loss+CovD_dcce else 0 end)  	CovD_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovD_inc_loss+CovD_dcce else 0 end)  	CovD_IL_DCCE_Cat_AO	,		
/*CovE*/				
sum(case when NC_Water='Yes' then CovE_inc_loss + CovE_dcce else 0 end)  	CovE_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then CovE_inc_loss+CovE_dcce else 0 end)  	CovE_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then CovE_inc_loss+CovE_dcce else 0 end)  	CovE_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then CovE_inc_loss+CovE_dcce else 0 end)  	CovE_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then CovE_inc_loss+CovE_dcce else 0 end)  	CovE_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovE_inc_loss+CovE_dcce else 0 end)  	CovE_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovE_inc_loss+CovE_dcce else 0 end)  	CovE_IL_DCCE_Cat_AO	,		
/*CovF*/				
sum(case when NC_Water='Yes' then CovF_inc_loss + CovF_dcce else 0 end)  	CovF_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then CovF_inc_loss+CovF_dcce else 0 end)  	CovF_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then CovF_inc_loss+CovF_dcce else 0 end)  	CovF_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then CovF_inc_loss+CovF_dcce else 0 end)  	CovF_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then CovF_inc_loss+CovF_dcce else 0 end)  	CovF_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovF_inc_loss+CovF_dcce else 0 end)  	CovF_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovF_inc_loss+CovF_dcce else 0 end)  	CovF_IL_DCCE_Cat_AO	,		
/*LIAB*/				
sum(case when NC_Water='Yes' then LIAB_inc_loss + LIAB_dcce else 0 end)  	LIAB_IL_DCCE_NC_Water	,		
sum(case when NC_WH='Yes' then LIAB_inc_loss+LIAB_dcce else 0 end)  	LIAB_IL_DCCE_NC_WH	,		
sum(case when NC_TV='Yes' then LIAB_inc_loss+LIAB_dcce else 0 end)  	LIAB_IL_DCCE_NC_TV	,		
sum(case when NC_FL='Yes' then LIAB_inc_loss+LIAB_dcce else 0 end)  	LIAB_IL_DCCE_NC_FL	,		
sum(case when NC_AO='Yes' then LIAB_inc_loss+LIAB_dcce else 0 end)  	LIAB_IL_DCCE_NC_AO	,		
sum(case when CAT_FL='Yes' then LIAB_inc_loss+LIAB_dcce else 0 end)  	LIAB_IL_DCCE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then LIAB_inc_loss+LIAB_dcce else 0 end)  	LIAB_IL_DCCE_Cat_AO	,		
/*Inc Loss + ALAE*/				
/*CovA*/				
sum(case when NC_Water='Yes' then CovA_inc_loss + CovA_alae else 0 end)  	CovA_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then CovA_inc_loss+CovA_alae else 0 end)  	CovA_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then CovA_inc_loss+CovA_alae else 0 end)  	CovA_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then CovA_inc_loss+CovA_alae else 0 end)  	CovA_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then CovA_inc_loss+CovA_alae else 0 end)  	CovA_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovA_inc_loss+CovA_alae else 0 end)  	CovA_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovA_inc_loss+CovA_alae else 0 end)  	CovA_IL_ALAE_Cat_AO	,		
/*CovB*/				
sum(case when NC_Water='Yes' then CovB_inc_loss + CovB_alae else 0 end)  	CovB_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then CovB_inc_loss+CovB_alae else 0 end)  	CovB_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then CovB_inc_loss+CovB_alae else 0 end)  	CovB_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then CovB_inc_loss+CovB_alae else 0 end)  	CovB_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then CovB_inc_loss+CovB_alae else 0 end)  	CovB_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovB_inc_loss+CovB_alae else 0 end)  	CovB_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovB_inc_loss+CovB_alae else 0 end)  	CovB_IL_ALAE_Cat_AO	,		
/*CovC*/				
sum(case when NC_Water='Yes' then CovC_inc_loss + CovC_alae else 0 end)  	CovC_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then CovC_inc_loss+CovC_alae else 0 end)  	CovC_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then CovC_inc_loss+CovC_alae else 0 end)  	CovC_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then CovC_inc_loss+CovC_alae else 0 end)  	CovC_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then CovC_inc_loss+CovC_alae else 0 end)  	CovC_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovC_inc_loss+CovC_alae else 0 end)  	CovC_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovC_inc_loss+CovC_alae else 0 end)  	CovC_IL_ALAE_Cat_AO	,		
/*CovD*/				
sum(case when NC_Water='Yes' then CovD_inc_loss + CovD_alae else 0 end)  	CovD_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then CovD_inc_loss+CovD_alae else 0 end)  	CovD_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then CovD_inc_loss+CovD_alae else 0 end)  	CovD_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then CovD_inc_loss+CovD_alae else 0 end)  	CovD_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then CovD_inc_loss+CovD_alae else 0 end)  	CovD_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovD_inc_loss+CovD_alae else 0 end)  	CovD_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovD_inc_loss+CovD_alae else 0 end)  	CovD_IL_ALAE_Cat_AO	,		
/*CovE*/				
sum(case when NC_Water='Yes' then CovE_inc_loss + CovE_alae else 0 end)  	CovE_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then CovE_inc_loss+CovE_alae else 0 end)  	CovE_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then CovE_inc_loss+CovE_alae else 0 end)  	CovE_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then CovE_inc_loss+CovE_alae else 0 end)  	CovE_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then CovE_inc_loss+CovE_alae else 0 end)  	CovE_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovE_inc_loss+CovE_alae else 0 end)  	CovE_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovE_inc_loss+CovE_alae else 0 end)  	CovE_IL_ALAE_Cat_AO	,		
/*CovF*/				
sum(case when NC_Water='Yes' then CovF_inc_loss + CovF_alae else 0 end)  	CovF_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then CovF_inc_loss+CovF_alae else 0 end)  	CovF_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then CovF_inc_loss+CovF_alae else 0 end)  	CovF_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then CovF_inc_loss+CovF_alae else 0 end)  	CovF_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then CovF_inc_loss+CovF_alae else 0 end)  	CovF_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then CovF_inc_loss+CovF_alae else 0 end)  	CovF_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then CovF_inc_loss+CovF_alae else 0 end)  	CovF_IL_ALAE_Cat_AO	,		
/*LIAB*/				
sum(case when NC_Water='Yes' then LIAB_inc_loss + LIAB_alae else 0 end)  	LIAB_IL_ALAE_NC_Water	,		
sum(case when NC_WH='Yes' then LIAB_inc_loss+LIAB_alae else 0 end)  	LIAB_IL_ALAE_NC_WH	,		
sum(case when NC_TV='Yes' then LIAB_inc_loss+LIAB_alae else 0 end)  	LIAB_IL_ALAE_NC_TV	,		
sum(case when NC_FL='Yes' then LIAB_inc_loss+LIAB_alae else 0 end)  	LIAB_IL_ALAE_NC_FL	,		
sum(case when NC_AO='Yes' then LIAB_inc_loss+LIAB_alae else 0 end)  	LIAB_IL_ALAE_NC_AO	,		
sum(case when CAT_FL='Yes' then LIAB_inc_loss+LIAB_alae else 0 end)  	LIAB_IL_ALAE_Cat_Fire	,		
sum(case when CAT_AO='Yes' then LIAB_inc_loss+LIAB_alae else 0 end)  	LIAB_IL_ALAE_Cat_AO	,		
sum(CovA_FL) CovA_FL,				
sum(CovA_SF) CovA_SF,				
sum(CovA_EC) CovA_EC,				
sum(CovC_FL) CovC_FL,				
sum(CovC_SF) CovC_SF,				
sum(CovC_EC) CovC_EC,				
sum(isnull(all_lossinc,0)) AllCov_LossInc,				
sum(isnull(all_dcce,0)) AllCov_LossDCCE,				
sum(isnull(all_alae,0)) AllCov_LossALAE				
from fsbi_stg_spinn.STG_PROPERTY_MODELDATA stg				
join fsbi_stg_spinn.vstg_property_modeldata_claims c				
on stg.claimrisk_id=c.claimrisk_id				
group by 				
modeldata_id;				
				
				
				
				
/* Counts */				
				
drop table if exists tmp_FACT_HO_LL_MODELDATA_IC;				
create temporary table tmp_FACT_HO_LL_MODELDATA_IC as				
select				
modeldata_id	,			
/*Inc Loss*/				
/*CovA*/				
sum( case when NC_Water='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_NC_Water	,		
sum( case when NC_WH='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_NC_WH	,		
sum( case when NC_TV='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_NC_TV	,		
sum( case when NC_FL='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_NC_FL	,		
sum( case when NC_AO='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovA_inc_loss >0 then 1 else  0 end)  	CovA_IC_Cat_AO	,		
/*CovB*/				
sum( case when NC_Water='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_NC_Water	,		
sum( case when NC_WH='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_NC_WH	,		
sum( case when NC_TV='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_NC_TV	,		
sum( case when NC_FL='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_NC_FL	,		
sum( case when NC_AO='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovB_inc_loss >0 then 1 else  0 end)  	CovB_IC_Cat_AO	,		
/*CovC*/				
sum( case when NC_Water='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_NC_Water	,		
sum( case when NC_WH='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_NC_WH	,		
sum( case when NC_TV='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_NC_TV	,		
sum( case when NC_FL='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_NC_FL	,		
sum( case when NC_AO='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovC_inc_loss >0 then 1 else  0 end)  	CovC_IC_Cat_AO	,		
/*CovD*/				
sum( case when NC_Water='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_NC_Water	,		
sum( case when NC_WH='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_NC_WH	,		
sum( case when NC_TV='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_NC_TV	,		
sum( case when NC_FL='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_NC_FL	,		
sum( case when NC_AO='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovD_inc_loss >0 then 1 else  0 end)  	CovD_IC_Cat_AO	,		
sum( case when NC_Water='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_NC_Water	,		
sum( case when NC_WH='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_NC_WH	,		
sum( case when NC_TV='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_NC_TV	,		
sum( case when NC_FL='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_NC_FL	,		
sum( case when NC_AO='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovE_inc_loss >0 then 1 else  0 end)  	CovE_IC_Cat_AO	,		
/*CovF*/				
sum( case when NC_Water='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_NC_Water	,		
sum( case when NC_WH='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_NC_WH	,		
sum( case when NC_TV='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_NC_TV	,		
sum( case when NC_FL='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_NC_FL	,		
sum( case when NC_AO='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovF_inc_loss >0 then 1 else  0 end)  	CovF_IC_Cat_AO	,		
/*LIAB*/				
sum( case when NC_Water='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_NC_Water	,		
sum( case when NC_WH='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_NC_WH	,		
sum( case when NC_TV='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_NC_TV	,		
sum( case when NC_FL='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_NC_FL	,		
sum( case when NC_AO='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_NC_AO	,		
sum( case when CAT_FL='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_Cat_Fire	,		
sum( case when CAT_AO='Yes' and LIAB_inc_loss >0 then 1 else  0 end)  	LIAB_IC_Cat_AO	,		
/*Inc Loss + DCCE*/				
/*CovA*/				
sum( case when NC_Water='Yes' and CovA_inc_loss + CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and CovA_inc_loss+CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and CovA_inc_loss+CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and CovA_inc_loss+CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and CovA_inc_loss+CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovA_inc_loss+CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovA_inc_loss+CovA_dcce >0 then 1 else  0 end)  	CovA_IC_DCCE_Cat_AO	,		
/*CovB*/				
sum( case when NC_Water='Yes' and CovB_inc_loss + CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and CovB_inc_loss+CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and CovB_inc_loss+CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and CovB_inc_loss+CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and CovB_inc_loss+CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovB_inc_loss+CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovB_inc_loss+CovB_dcce >0 then 1 else  0 end)  	CovB_IC_DCCE_Cat_AO	,		
/*CovC*/				
sum( case when NC_Water='Yes' and CovC_inc_loss + CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and CovC_inc_loss+CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and CovC_inc_loss+CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and CovC_inc_loss+CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and CovC_inc_loss+CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovC_inc_loss+CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovC_inc_loss+CovC_dcce >0 then 1 else  0 end)  	CovC_IC_DCCE_Cat_AO	,		
/*CovD*/				
sum( case when NC_Water='Yes' and CovD_inc_loss + CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and CovD_inc_loss+CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and CovD_inc_loss+CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and CovD_inc_loss+CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and CovD_inc_loss+CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovD_inc_loss+CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovD_inc_loss+CovD_dcce >0 then 1 else  0 end)  	CovD_IC_DCCE_Cat_AO	,		
sum( case when NC_Water='Yes' and CovE_inc_loss + CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and CovE_inc_loss+CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and CovE_inc_loss+CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and CovE_inc_loss+CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and CovE_inc_loss+CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovE_inc_loss+CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovE_inc_loss+CovE_dcce >0 then 1 else  0 end)  	CovE_IC_DCCE_Cat_AO	,		
/*CovF*/				
sum( case when NC_Water='Yes' and CovF_inc_loss + CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and CovF_inc_loss+CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and CovF_inc_loss+CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and CovF_inc_loss+CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and CovF_inc_loss+CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovF_inc_loss+CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovF_inc_loss+CovF_dcce >0 then 1 else  0 end)  	CovF_IC_DCCE_Cat_AO	,		
/*LIAB*/				
sum( case when NC_Water='Yes' and LIAB_inc_loss + LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_NC_Water	,		
sum( case when NC_WH='Yes' and LIAB_inc_loss+LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_NC_WH	,		
sum( case when NC_TV='Yes' and LIAB_inc_loss+LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_NC_TV	,		
sum( case when NC_FL='Yes' and LIAB_inc_loss+LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_NC_FL	,		
sum( case when NC_AO='Yes' and LIAB_inc_loss+LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_NC_AO	,		
sum( case when CAT_FL='Yes' and LIAB_inc_loss+LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and LIAB_inc_loss+LIAB_dcce >0 then 1 else  0 end)  	LIAB_IC_DCCE_Cat_AO	,		
/*Inc Loss + ALAE*/				
/*CovA*/				
sum( case when NC_Water='Yes' and CovA_inc_loss + CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and CovA_inc_loss+CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and CovA_inc_loss+CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and CovA_inc_loss+CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and CovA_inc_loss+CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovA_inc_loss+CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovA_inc_loss+CovA_alae >0 then 1 else  0 end)  	CovA_IC_ALAE_Cat_AO	,		
/*CovB*/				
sum( case when NC_Water='Yes' and CovB_inc_loss + CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and CovB_inc_loss+CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and CovB_inc_loss+CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and CovB_inc_loss+CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and CovB_inc_loss+CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovB_inc_loss+CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovB_inc_loss+CovB_alae >0 then 1 else  0 end)  	CovB_IC_ALAE_Cat_AO	,		
/*CovC*/				
sum( case when NC_Water='Yes' and CovC_inc_loss + CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and CovC_inc_loss+CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and CovC_inc_loss+CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and CovC_inc_loss+CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and CovC_inc_loss+CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovC_inc_loss+CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovC_inc_loss+CovC_alae >0 then 1 else  0 end)  	CovC_IC_ALAE_Cat_AO	,		
/*CovD*/				
sum( case when NC_Water='Yes' and CovD_inc_loss + CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and CovD_inc_loss+CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and CovD_inc_loss+CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and CovD_inc_loss+CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and CovD_inc_loss+CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovD_inc_loss+CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovD_inc_loss+CovD_alae >0 then 1 else  0 end)  	CovD_IC_ALAE_Cat_AO	,		
/*CovE*/				
sum( case when NC_Water='Yes' and CovE_inc_loss + CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and CovE_inc_loss+CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and CovE_inc_loss+CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and CovE_inc_loss+CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and CovE_inc_loss+CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovE_inc_loss+CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovE_inc_loss+CovE_alae >0 then 1 else  0 end)  	CovE_IC_ALAE_Cat_AO	,		
/*CovF*/				
sum( case when NC_Water='Yes' and CovF_inc_loss + CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and CovF_inc_loss+CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and CovF_inc_loss+CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and CovF_inc_loss+CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and CovF_inc_loss+CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and CovF_inc_loss+CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and CovF_inc_loss+CovF_alae >0 then 1 else  0 end)  	CovF_IC_ALAE_Cat_AO	,		
/*LIAB*/				
sum( case when NC_Water='Yes' and LIAB_inc_loss + LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_NC_Water	,		
sum( case when NC_WH='Yes' and LIAB_inc_loss+LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_NC_WH	,		
sum( case when NC_TV='Yes' and LIAB_inc_loss+LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_NC_TV	,		
sum( case when NC_FL='Yes' and LIAB_inc_loss+LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_NC_FL	,		
sum( case when NC_AO='Yes' and LIAB_inc_loss+LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_NC_AO	,		
sum( case when CAT_FL='Yes' and LIAB_inc_loss+LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_Cat_Fire	,		
sum( case when CAT_AO='Yes' and LIAB_inc_loss+LIAB_alae >0 then 1 else  0 end)  	LIAB_IC_ALAE_Cat_AO			
from fsbi_stg_spinn.STG_PROPERTY_MODELDATA stg				
left outer join fsbi_stg_spinn.vstg_property_modeldata_claims c				
on stg.claimrisk_id=c.claimrisk_id				
group by 				
modeldata_id;				
				
				
				
/*2. Final load into FACT table: 				
staging + aggregated and grouped claim data + producer id				
*/				
				
				
				
drop table if exists tmp_final;				
create temporary table tmp_final as				
select distinct 				
	stg.modeldata_id			,
	SystemIdStart			,
	SystemIdEnd			,
	stg.policy_id			,
	stg.policy_uniqueid			,
	dc.policy_changes_id		,	
isnull(p.producer_id	,4) 	producer_id	,	
	Risk_id			,
	Risk_uniqueid			,
	RiskNumber			,
	RiskType			,
	Building_id			,
	Building_uniqueid			,
	StartDateTm			,
	EndDateTm			,
	startdate			,
	enddate			,
	CovA_deductible			,
	CovB_deductible			,
	CovC_deductible			,
	CovD_deductible			,
	CovE_deductible			,
	CovF_deductible			,
	CovA_Limit			,
	CovB_Limit			,
	CovC_Limit			,
	CovD_Limit			,
	CovE_Limit			,
	CovF_Limit			,
	OnPremises_Theft_Limit ,			
    AwayFromPremises_Theft_Limit,				
	CovA_FullTermAmt			,
	CovB_FullTermAmt			,
	CovC_FullTermAmt			,
	CovD_FullTermAmt			,
	CovE_FullTermAmt			,
	CovF_FullTermAmt			,
	Quality_PolAppInconsistency_Flg			,
	Quality_RiskIdDuplicates_Flg			,
isnull(	tmp_il.Quality_ClaimOk_Flg 	,0) 	Quality_ClaimOk_Flg 	,
isnull(	tmp_il.Quality_ClaimPolicyTermJoin_Flg 	,0) 	Quality_ClaimPolicyTermJoin_Flg 	,
	/*--*/			
isnull(	tmp_il.Loss	,0) 	Loss	,
isnull(	tmp_il.Claim_Count	,0) 	Claim_Count	,
	/*--*/			
isnull(	tmp_il.Cat_Loss	,0) 	Cat_Loss	,
isnull(	tmp_il.Cat_Claim_Count	,0) 	Cat_Claim_Count	,
	/*--*/			
isnull(	tmp_il.CovA_IL_NC_Water	,0) 	CovA_IL_NC_Water	, 
isnull(	tmp_il.CovA_IL_NC_WH	,0) 	CovA_IL_NC_WH	, 
isnull(	tmp_il.CovA_IL_NC_TV	,0) 	CovA_IL_NC_TV	, 
isnull(	tmp_il.CovA_IL_NC_FL	,0) 	CovA_IL_NC_FL	, 
isnull(	tmp_il.CovA_IL_NC_AO	,0) 	CovA_IL_NC_AO	, 
isnull(	tmp_il.CovA_IL_Cat_Fire	,0) 	CovA_IL_Cat_Fire	, 
isnull(	tmp_il.CovA_IL_Cat_AO	,0) 	CovA_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovB_IL_NC_Water	,0) 	CovB_IL_NC_Water	, 
isnull(	tmp_il.CovB_IL_NC_WH	,0) 	CovB_IL_NC_WH	, 
isnull(	tmp_il.CovB_IL_NC_TV	,0) 	CovB_IL_NC_TV	, 
isnull(	tmp_il.CovB_IL_NC_FL	,0) 	CovB_IL_NC_FL	, 
isnull(	tmp_il.CovB_IL_NC_AO	,0) 	CovB_IL_NC_AO	, 
isnull(	tmp_il.CovB_IL_Cat_Fire	,0) 	CovB_IL_Cat_Fire	, 
isnull(	tmp_il.CovB_IL_Cat_AO	,0) 	CovB_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovC_IL_NC_Water	,0) 	CovC_IL_NC_Water	, 
isnull(	tmp_il.CovC_IL_NC_WH	,0) 	CovC_IL_NC_WH	, 
isnull(	tmp_il.CovC_IL_NC_TV	,0) 	CovC_IL_NC_TV	, 
isnull(	tmp_il.CovC_IL_NC_FL	,0) 	CovC_IL_NC_FL	, 
isnull(	tmp_il.CovC_IL_NC_AO	,0) 	CovC_IL_NC_AO	, 
isnull(	tmp_il.CovC_IL_Cat_Fire	,0) 	CovC_IL_Cat_Fire	, 
isnull(	tmp_il.CovC_IL_Cat_AO	,0) 	CovC_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovD_IL_NC_Water	,0) 	CovD_IL_NC_Water	, 
isnull(	tmp_il.CovD_IL_NC_WH	,0) 	CovD_IL_NC_WH	, 
isnull(	tmp_il.CovD_IL_NC_TV	,0) 	CovD_IL_NC_TV	, 
isnull(	tmp_il.CovD_IL_NC_FL	,0) 	CovD_IL_NC_FL	, 
isnull(	tmp_il.CovD_IL_NC_AO	,0) 	CovD_IL_NC_AO	, 
isnull(	tmp_il.CovD_IL_Cat_Fire	,0) 	CovD_IL_Cat_Fire	, 
isnull(	tmp_il.CovD_IL_Cat_AO	,0) 	CovD_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovE_IL_NC_Water	,0) 	CovE_IL_NC_Water	, 
isnull(	tmp_il.CovE_IL_NC_WH	,0) 	CovE_IL_NC_WH	, 
isnull(	tmp_il.CovE_IL_NC_TV	,0) 	CovE_IL_NC_TV	, 
isnull(	tmp_il.CovE_IL_NC_FL	,0) 	CovE_IL_NC_FL	, 
isnull(	tmp_il.CovE_IL_NC_AO	,0) 	CovE_IL_NC_AO	, 
isnull(	tmp_il.CovE_IL_Cat_Fire	,0) 	CovE_IL_Cat_Fire	, 
isnull(	tmp_il.CovE_IL_Cat_AO	,0) 	CovE_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovF_IL_NC_Water	,0) 	CovF_IL_NC_Water	, 
isnull(	tmp_il.CovF_IL_NC_WH	,0) 	CovF_IL_NC_WH	, 
isnull(	tmp_il.CovF_IL_NC_TV	,0) 	CovF_IL_NC_TV	, 
isnull(	tmp_il.CovF_IL_NC_FL	,0) 	CovF_IL_NC_FL	, 
isnull(	tmp_il.CovF_IL_NC_AO	,0) 	CovF_IL_NC_AO	, 
isnull(	tmp_il.CovF_IL_Cat_Fire	,0) 	CovF_IL_Cat_Fire	, 
isnull(	tmp_il.CovF_IL_Cat_AO	,0) 	CovF_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.LIAB_IL_NC_Water	,0) 	LIAB_IL_NC_Water	, 
isnull(	tmp_il.LIAB_IL_NC_WH	,0) 	LIAB_IL_NC_WH	, 
isnull(	tmp_il.LIAB_IL_NC_TV	,0) 	LIAB_IL_NC_TV	, 
isnull(	tmp_il.LIAB_IL_NC_FL	,0) 	LIAB_IL_NC_FL	, 
isnull(	tmp_il.LIAB_IL_NC_AO	,0) 	LIAB_IL_NC_AO	, 
isnull(	tmp_il.LIAB_IL_Cat_Fire	,0) 	LIAB_IL_Cat_Fire	, 
isnull(	tmp_il.LIAB_IL_Cat_AO	,0) 	LIAB_IL_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovA_IL_DCCE_NC_Water	,0) 	CovA_IL_DCCE_NC_Water	, 
isnull(	tmp_il.CovA_IL_DCCE_NC_WH	,0) 	CovA_IL_DCCE_NC_WH	, 
isnull(	tmp_il.CovA_IL_DCCE_NC_TV	,0) 	CovA_IL_DCCE_NC_TV	, 
isnull(	tmp_il.CovA_IL_DCCE_NC_FL	,0) 	CovA_IL_DCCE_NC_FL	, 
isnull(	tmp_il.CovA_IL_DCCE_NC_AO	,0) 	CovA_IL_DCCE_NC_AO	, 
isnull(	tmp_il.CovA_IL_DCCE_Cat_Fire	,0) 	CovA_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.CovA_IL_DCCE_Cat_AO	,0) 	CovA_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovB_IL_DCCE_NC_Water	,0) 	CovB_IL_DCCE_NC_Water	, 
isnull(	tmp_il.CovB_IL_DCCE_NC_WH	,0) 	CovB_IL_DCCE_NC_WH	, 
isnull(	tmp_il.CovB_IL_DCCE_NC_TV	,0) 	CovB_IL_DCCE_NC_TV	, 
isnull(	tmp_il.CovB_IL_DCCE_NC_FL	,0) 	CovB_IL_DCCE_NC_FL	, 
isnull(	tmp_il.CovB_IL_DCCE_NC_AO	,0) 	CovB_IL_DCCE_NC_AO	, 
isnull(	tmp_il.CovB_IL_DCCE_Cat_Fire	,0) 	CovB_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.CovB_IL_DCCE_Cat_AO	,0) 	CovB_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovC_IL_DCCE_NC_Water	,0) 	CovC_IL_DCCE_NC_Water	, 
isnull(	tmp_il.CovC_IL_DCCE_NC_WH	,0) 	CovC_IL_DCCE_NC_WH	, 
isnull(	tmp_il.CovC_IL_DCCE_NC_TV	,0) 	CovC_IL_DCCE_NC_TV	, 
isnull(	tmp_il.CovC_IL_DCCE_NC_FL	,0) 	CovC_IL_DCCE_NC_FL	, 
isnull(	tmp_il.CovC_IL_DCCE_NC_AO	,0) 	CovC_IL_DCCE_NC_AO	, 
isnull(	tmp_il.CovC_IL_DCCE_Cat_Fire	,0) 	CovC_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.CovC_IL_DCCE_Cat_AO	,0) 	CovC_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovD_IL_DCCE_NC_Water	,0) 	CovD_IL_DCCE_NC_Water	, 
isnull(	tmp_il.CovD_IL_DCCE_NC_WH	,0) 	CovD_IL_DCCE_NC_WH	, 
isnull(	tmp_il.CovD_IL_DCCE_NC_TV	,0) 	CovD_IL_DCCE_NC_TV	, 
isnull(	tmp_il.CovD_IL_DCCE_NC_FL	,0) 	CovD_IL_DCCE_NC_FL	, 
isnull(	tmp_il.CovD_IL_DCCE_NC_AO	,0) 	CovD_IL_DCCE_NC_AO	, 
isnull(	tmp_il.CovD_IL_DCCE_Cat_Fire	,0) 	CovD_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.CovD_IL_DCCE_Cat_AO	,0) 	CovD_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovE_IL_DCCE_NC_Water	,0) 	CovE_IL_DCCE_NC_Water	, 
isnull(	tmp_il.CovE_IL_DCCE_NC_WH	,0) 	CovE_IL_DCCE_NC_WH	, 
isnull(	tmp_il.CovE_IL_DCCE_NC_TV	,0) 	CovE_IL_DCCE_NC_TV	, 
isnull(	tmp_il.CovE_IL_DCCE_NC_FL	,0) 	CovE_IL_DCCE_NC_FL	, 
isnull(	tmp_il.CovE_IL_DCCE_NC_AO	,0) 	CovE_IL_DCCE_NC_AO	, 
isnull(	tmp_il.CovE_IL_DCCE_Cat_Fire	,0) 	CovE_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.CovE_IL_DCCE_Cat_AO	,0) 	CovE_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovF_IL_DCCE_NC_Water	,0) 	CovF_IL_DCCE_NC_Water	, 
isnull(	tmp_il.CovF_IL_DCCE_NC_WH	,0) 	CovF_IL_DCCE_NC_WH	, 
isnull(	tmp_il.CovF_IL_DCCE_NC_TV	,0) 	CovF_IL_DCCE_NC_TV	, 
isnull(	tmp_il.CovF_IL_DCCE_NC_FL	,0) 	CovF_IL_DCCE_NC_FL	, 
isnull(	tmp_il.CovF_IL_DCCE_NC_AO	,0) 	CovF_IL_DCCE_NC_AO	, 
isnull(	tmp_il.CovF_IL_DCCE_Cat_Fire	,0) 	CovF_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.CovF_IL_DCCE_Cat_AO	,0) 	CovF_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.LIAB_IL_DCCE_NC_Water	,0) 	LIAB_IL_DCCE_NC_Water	, 
isnull(	tmp_il.LIAB_IL_DCCE_NC_WH	,0) 	LIAB_IL_DCCE_NC_WH	, 
isnull(	tmp_il.LIAB_IL_DCCE_NC_TV	,0) 	LIAB_IL_DCCE_NC_TV	, 
isnull(	tmp_il.LIAB_IL_DCCE_NC_FL	,0) 	LIAB_IL_DCCE_NC_FL	, 
isnull(	tmp_il.LIAB_IL_DCCE_NC_AO	,0) 	LIAB_IL_DCCE_NC_AO	, 
isnull(	tmp_il.LIAB_IL_DCCE_Cat_Fire	,0) 	LIAB_IL_DCCE_Cat_Fire	, 
isnull(	tmp_il.LIAB_IL_DCCE_Cat_AO	,0) 	LIAB_IL_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovA_IL_ALAE_NC_Water	,0) 	CovA_IL_ALAE_NC_Water	, 
isnull(	tmp_il.CovA_IL_ALAE_NC_WH	,0) 	CovA_IL_ALAE_NC_WH	, 
isnull(	tmp_il.CovA_IL_ALAE_NC_TV	,0) 	CovA_IL_ALAE_NC_TV	, 
isnull(	tmp_il.CovA_IL_ALAE_NC_FL	,0) 	CovA_IL_ALAE_NC_FL	, 
isnull(	tmp_il.CovA_IL_ALAE_NC_AO	,0) 	CovA_IL_ALAE_NC_AO	, 
isnull(	tmp_il.CovA_IL_ALAE_Cat_Fire	,0) 	CovA_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.CovA_IL_ALAE_Cat_AO	,0) 	CovA_IL_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovB_IL_ALAE_NC_Water	,0) 	CovB_IL_ALAE_NC_Water	, 
isnull(	tmp_il.CovB_IL_ALAE_NC_WH	,0) 	CovB_IL_ALAE_NC_WH	, 
isnull(	tmp_il.CovB_IL_ALAE_NC_TV	,0) 	CovB_IL_ALAE_NC_TV	, 
isnull(	tmp_il.CovB_IL_ALAE_NC_FL	,0) 	CovB_IL_ALAE_NC_FL	, 
isnull(	tmp_il.CovB_IL_ALAE_NC_AO	,0) 	CovB_IL_ALAE_NC_AO	, 
isnull(	tmp_il.CovB_IL_ALAE_Cat_Fire	,0) 	CovB_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.CovB_IL_ALAE_Cat_AO	,0) 	CovB_IL_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovC_IL_ALAE_NC_Water	,0) 	CovC_IL_ALAE_NC_Water	, 
isnull(	tmp_il.CovC_IL_ALAE_NC_WH	,0) 	CovC_IL_ALAE_NC_WH	, 
isnull(	tmp_il.CovC_IL_ALAE_NC_TV	,0) 	CovC_IL_ALAE_NC_TV	, 
isnull(	tmp_il.CovC_IL_ALAE_NC_FL	,0) 	CovC_IL_ALAE_NC_FL	, 
isnull(	tmp_il.CovC_IL_ALAE_NC_AO	,0) 	CovC_IL_ALAE_NC_AO	, 
isnull(	tmp_il.CovC_IL_ALAE_Cat_Fire	,0) 	CovC_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.CovC_IL_ALAE_Cat_AO	,0) 	CovC_IL_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovD_IL_ALAE_NC_Water	,0) 	CovD_IL_ALAE_NC_Water	, 
isnull(	tmp_il.CovD_IL_ALAE_NC_WH	,0) 	CovD_IL_ALAE_NC_WH	, 
isnull(	tmp_il.CovD_IL_ALAE_NC_TV	,0) 	CovD_IL_ALAE_NC_TV	, 
isnull(	tmp_il.CovD_IL_ALAE_NC_FL	,0) 	CovD_IL_ALAE_NC_FL	, 
isnull(	tmp_il.CovD_IL_ALAE_NC_AO	,0) 	CovD_IL_ALAE_NC_AO	, 
isnull(	tmp_il.CovD_IL_ALAE_Cat_Fire	,0) 	CovD_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.CovD_IL_ALAE_Cat_AO	,0) 	CovD_IL_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovE_IL_ALAE_NC_Water	,0) 	CovE_IL_ALAE_NC_Water	, 
isnull(	tmp_il.CovE_IL_ALAE_NC_WH	,0) 	CovE_IL_ALAE_NC_WH	, 
isnull(	tmp_il.CovE_IL_ALAE_NC_TV	,0) 	CovE_IL_ALAE_NC_TV	, 
isnull(	tmp_il.CovE_IL_ALAE_NC_FL	,0) 	CovE_IL_ALAE_NC_FL	, 
isnull(	tmp_il.CovE_IL_ALAE_NC_AO	,0) 	CovE_IL_ALAE_NC_AO	, 
isnull(	tmp_il.CovE_IL_ALAE_Cat_Fire	,0) 	CovE_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.CovE_IL_ALAE_Cat_AO	,0) 	CovE_IL_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.CovF_IL_ALAE_NC_Water	,0) 	CovF_IL_ALAE_NC_Water	, 
isnull(	tmp_il.CovF_IL_ALAE_NC_WH	,0) 	CovF_IL_ALAE_NC_WH	, 
isnull(	tmp_il.CovF_IL_ALAE_NC_TV	,0) 	CovF_IL_ALAE_NC_TV	, 
isnull(	tmp_il.CovF_IL_ALAE_NC_FL	,0) 	CovF_IL_ALAE_NC_FL	, 
isnull(	tmp_il.CovF_IL_ALAE_NC_AO	,0) 	CovF_IL_ALAE_NC_AO	, 
isnull(	tmp_il.CovF_IL_ALAE_Cat_Fire	,0) 	CovF_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.CovF_IL_ALAE_Cat_AO	,0) 	CovF_IL_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_il.LIAB_IL_ALAE_NC_Water	,0) 	LIAB_IL_ALAE_NC_Water	, 
isnull(	tmp_il.LIAB_IL_ALAE_NC_WH	,0) 	LIAB_IL_ALAE_NC_WH	, 
isnull(	tmp_il.LIAB_IL_ALAE_NC_TV	,0) 	LIAB_IL_ALAE_NC_TV	, 
isnull(	tmp_il.LIAB_IL_ALAE_NC_FL	,0) 	LIAB_IL_ALAE_NC_FL	, 
isnull(	tmp_il.LIAB_IL_ALAE_NC_AO	,0) 	LIAB_IL_ALAE_NC_AO	, 
isnull(	tmp_il.LIAB_IL_ALAE_Cat_Fire	,0) 	LIAB_IL_ALAE_Cat_Fire	, 
isnull(	tmp_il.LIAB_IL_ALAE_Cat_AO	,0) 	LIAB_IL_ALAE_Cat_AO	, 
isnull(	tmp_il.AllCov_LossInc	,0) 	AllCov_LossInc	, 
isnull(	tmp_il.AllCov_LossDCCE	,0) 	AllCov_LossDCCE	, 
isnull(	tmp_il.AllCov_LossALAE	,0) 	AllCov_LossALAE	, 
	/*==========*/			
isnull(	tmp_ic.CovA_IC_NC_Water	,0) 	CovA_IC_NC_Water	, 
isnull(	tmp_ic.CovA_IC_NC_WH	,0) 	CovA_IC_NC_WH	, 
isnull(	tmp_ic.CovA_IC_NC_TV	,0) 	CovA_IC_NC_TV	, 
isnull(	tmp_ic.CovA_IC_NC_FL	,0) 	CovA_IC_NC_FL	, 
isnull(	tmp_ic.CovA_IC_NC_AO	,0) 	CovA_IC_NC_AO	, 
isnull(	tmp_ic.CovA_IC_Cat_Fire	,0) 	CovA_IC_Cat_Fire	, 
isnull(	tmp_ic.CovA_IC_Cat_AO	,0) 	CovA_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovB_IC_NC_Water	,0) 	CovB_IC_NC_Water	, 
isnull(	tmp_ic.CovB_IC_NC_WH	,0) 	CovB_IC_NC_WH	, 
isnull(	tmp_ic.CovB_IC_NC_TV	,0) 	CovB_IC_NC_TV	, 
isnull(	tmp_ic.CovB_IC_NC_FL	,0) 	CovB_IC_NC_FL	, 
isnull(	tmp_ic.CovB_IC_NC_AO	,0) 	CovB_IC_NC_AO	, 
isnull(	tmp_ic.CovB_IC_Cat_Fire	,0) 	CovB_IC_Cat_Fire	, 
isnull(	tmp_ic.CovB_IC_Cat_AO	,0) 	CovB_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovC_IC_NC_Water	,0) 	CovC_IC_NC_Water	, 
isnull(	tmp_ic.CovC_IC_NC_WH	,0) 	CovC_IC_NC_WH	, 
isnull(	tmp_ic.CovC_IC_NC_TV	,0) 	CovC_IC_NC_TV	, 
isnull(	tmp_ic.CovC_IC_NC_FL	,0) 	CovC_IC_NC_FL	, 
isnull(	tmp_ic.CovC_IC_NC_AO	,0) 	CovC_IC_NC_AO	, 
isnull(	tmp_ic.CovC_IC_Cat_Fire	,0) 	CovC_IC_Cat_Fire	, 
isnull(	tmp_ic.CovC_IC_Cat_AO	,0) 	CovC_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovD_IC_NC_Water	,0) 	CovD_IC_NC_Water	, 
isnull(	tmp_ic.CovD_IC_NC_WH	,0) 	CovD_IC_NC_WH	, 
isnull(	tmp_ic.CovD_IC_NC_TV	,0) 	CovD_IC_NC_TV	, 
isnull(	tmp_ic.CovD_IC_NC_FL	,0) 	CovD_IC_NC_FL	, 
isnull(	tmp_ic.CovD_IC_NC_AO	,0) 	CovD_IC_NC_AO	, 
isnull(	tmp_ic.CovD_IC_Cat_Fire	,0) 	CovD_IC_Cat_Fire	, 
isnull(	tmp_ic.CovD_IC_Cat_AO	,0) 	CovD_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovE_IC_NC_Water	,0) 	CovE_IC_NC_Water	, 
isnull(	tmp_ic.CovE_IC_NC_WH	,0) 	CovE_IC_NC_WH	, 
isnull(	tmp_ic.CovE_IC_NC_TV	,0) 	CovE_IC_NC_TV	, 
isnull(	tmp_ic.CovE_IC_NC_FL	,0) 	CovE_IC_NC_FL	, 
isnull(	tmp_ic.CovE_IC_NC_AO	,0) 	CovE_IC_NC_AO	, 
isnull(	tmp_ic.CovE_IC_Cat_Fire	,0) 	CovE_IC_Cat_Fire	, 
isnull(	tmp_ic.CovE_IC_Cat_AO	,0) 	CovE_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovF_IC_NC_Water	,0) 	CovF_IC_NC_Water	, 
isnull(	tmp_ic.CovF_IC_NC_WH	,0) 	CovF_IC_NC_WH	, 
isnull(	tmp_ic.CovF_IC_NC_TV	,0) 	CovF_IC_NC_TV	, 
isnull(	tmp_ic.CovF_IC_NC_FL	,0) 	CovF_IC_NC_FL	, 
isnull(	tmp_ic.CovF_IC_NC_AO	,0) 	CovF_IC_NC_AO	, 
isnull(	tmp_ic.CovF_IC_Cat_Fire	,0) 	CovF_IC_Cat_Fire	, 
isnull(	tmp_ic.CovF_IC_Cat_AO	,0) 	CovF_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.LIAB_IC_NC_Water	,0) 	LIAB_IC_NC_Water	, 
isnull(	tmp_ic.LIAB_IC_NC_WH	,0) 	LIAB_IC_NC_WH	, 
isnull(	tmp_ic.LIAB_IC_NC_TV	,0) 	LIAB_IC_NC_TV	, 
isnull(	tmp_ic.LIAB_IC_NC_FL	,0) 	LIAB_IC_NC_FL	, 
isnull(	tmp_ic.LIAB_IC_NC_AO	,0) 	LIAB_IC_NC_AO	, 
isnull(	tmp_ic.LIAB_IC_Cat_Fire	,0) 	LIAB_IC_Cat_Fire	, 
isnull(	tmp_ic.LIAB_IC_Cat_AO	,0) 	LIAB_IC_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovA_IC_DCCE_NC_Water	,0) 	CovA_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.CovA_IC_DCCE_NC_WH	,0) 	CovA_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.CovA_IC_DCCE_NC_TV	,0) 	CovA_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.CovA_IC_DCCE_NC_FL	,0) 	CovA_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.CovA_IC_DCCE_NC_AO	,0) 	CovA_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.CovA_IC_DCCE_Cat_Fire	,0) 	CovA_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.CovA_IC_DCCE_Cat_AO	,0) 	CovA_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovB_IC_DCCE_NC_Water	,0) 	CovB_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.CovB_IC_DCCE_NC_WH	,0) 	CovB_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.CovB_IC_DCCE_NC_TV	,0) 	CovB_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.CovB_IC_DCCE_NC_FL	,0) 	CovB_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.CovB_IC_DCCE_NC_AO	,0) 	CovB_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.CovB_IC_DCCE_Cat_Fire	,0) 	CovB_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.CovB_IC_DCCE_Cat_AO	,0) 	CovB_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovC_IC_DCCE_NC_Water	,0) 	CovC_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.CovC_IC_DCCE_NC_WH	,0) 	CovC_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.CovC_IC_DCCE_NC_TV	,0) 	CovC_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.CovC_IC_DCCE_NC_FL	,0) 	CovC_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.CovC_IC_DCCE_NC_AO	,0) 	CovC_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.CovC_IC_DCCE_Cat_Fire	,0) 	CovC_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.CovC_IC_DCCE_Cat_AO	,0) 	CovC_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovD_IC_DCCE_NC_Water	,0) 	CovD_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.CovD_IC_DCCE_NC_WH	,0) 	CovD_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.CovD_IC_DCCE_NC_TV	,0) 	CovD_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.CovD_IC_DCCE_NC_FL	,0) 	CovD_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.CovD_IC_DCCE_NC_AO	,0) 	CovD_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.CovD_IC_DCCE_Cat_Fire	,0) 	CovD_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.CovD_IC_DCCE_Cat_AO	,0) 	CovD_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovE_IC_DCCE_NC_Water	,0) 	CovE_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.CovE_IC_DCCE_NC_WH	,0) 	CovE_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.CovE_IC_DCCE_NC_TV	,0) 	CovE_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.CovE_IC_DCCE_NC_FL	,0) 	CovE_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.CovE_IC_DCCE_NC_AO	,0) 	CovE_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.CovE_IC_DCCE_Cat_Fire	,0) 	CovE_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.CovE_IC_DCCE_Cat_AO	,0) 	CovE_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovF_IC_DCCE_NC_Water	,0) 	CovF_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.CovF_IC_DCCE_NC_WH	,0) 	CovF_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.CovF_IC_DCCE_NC_TV	,0) 	CovF_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.CovF_IC_DCCE_NC_FL	,0) 	CovF_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.CovF_IC_DCCE_NC_AO	,0) 	CovF_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.CovF_IC_DCCE_Cat_Fire	,0) 	CovF_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.CovF_IC_DCCE_Cat_AO	,0) 	CovF_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.LIAB_IC_DCCE_NC_Water	,0) 	LIAB_IC_DCCE_NC_Water	, 
isnull(	tmp_ic.LIAB_IC_DCCE_NC_WH	,0) 	LIAB_IC_DCCE_NC_WH	, 
isnull(	tmp_ic.LIAB_IC_DCCE_NC_TV	,0) 	LIAB_IC_DCCE_NC_TV	, 
isnull(	tmp_ic.LIAB_IC_DCCE_NC_FL	,0) 	LIAB_IC_DCCE_NC_FL	, 
isnull(	tmp_ic.LIAB_IC_DCCE_NC_AO	,0) 	LIAB_IC_DCCE_NC_AO	, 
isnull(	tmp_ic.LIAB_IC_DCCE_Cat_Fire	,0) 	LIAB_IC_DCCE_Cat_Fire	, 
isnull(	tmp_ic.LIAB_IC_DCCE_Cat_AO	,0) 	LIAB_IC_DCCE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovA_IC_ALAE_NC_Water	,0) 	CovA_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.CovA_IC_ALAE_NC_WH	,0) 	CovA_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.CovA_IC_ALAE_NC_TV	,0) 	CovA_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.CovA_IC_ALAE_NC_FL	,0) 	CovA_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.CovA_IC_ALAE_NC_AO	,0) 	CovA_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.CovA_IC_ALAE_Cat_Fire	,0) 	CovA_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.CovA_IC_ALAE_Cat_AO	,0) 	CovA_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovB_IC_ALAE_NC_Water	,0) 	CovB_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.CovB_IC_ALAE_NC_WH	,0) 	CovB_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.CovB_IC_ALAE_NC_TV	,0) 	CovB_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.CovB_IC_ALAE_NC_FL	,0) 	CovB_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.CovB_IC_ALAE_NC_AO	,0) 	CovB_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.CovB_IC_ALAE_Cat_Fire	,0) 	CovB_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.CovB_IC_ALAE_Cat_AO	,0) 	CovB_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovC_IC_ALAE_NC_Water	,0) 	CovC_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.CovC_IC_ALAE_NC_WH	,0) 	CovC_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.CovC_IC_ALAE_NC_TV	,0) 	CovC_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.CovC_IC_ALAE_NC_FL	,0) 	CovC_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.CovC_IC_ALAE_NC_AO	,0) 	CovC_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.CovC_IC_ALAE_Cat_Fire	,0) 	CovC_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.CovC_IC_ALAE_Cat_AO	,0) 	CovC_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovD_IC_ALAE_NC_Water	,0) 	CovD_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.CovD_IC_ALAE_NC_WH	,0) 	CovD_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.CovD_IC_ALAE_NC_TV	,0) 	CovD_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.CovD_IC_ALAE_NC_FL	,0) 	CovD_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.CovD_IC_ALAE_NC_AO	,0) 	CovD_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.CovD_IC_ALAE_Cat_Fire	,0) 	CovD_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.CovD_IC_ALAE_Cat_AO	,0) 	CovD_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovE_IC_ALAE_NC_Water	,0) 	CovE_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.CovE_IC_ALAE_NC_WH	,0) 	CovE_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.CovE_IC_ALAE_NC_TV	,0) 	CovE_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.CovE_IC_ALAE_NC_FL	,0) 	CovE_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.CovE_IC_ALAE_NC_AO	,0) 	CovE_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.CovE_IC_ALAE_Cat_Fire	,0) 	CovE_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.CovE_IC_ALAE_Cat_AO	,0) 	CovE_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.CovF_IC_ALAE_NC_Water	,0) 	CovF_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.CovF_IC_ALAE_NC_WH	,0) 	CovF_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.CovF_IC_ALAE_NC_TV	,0) 	CovF_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.CovF_IC_ALAE_NC_FL	,0) 	CovF_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.CovF_IC_ALAE_NC_AO	,0) 	CovF_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.CovF_IC_ALAE_Cat_Fire	,0) 	CovF_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.CovF_IC_ALAE_Cat_AO	,0) 	CovF_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	tmp_ic.LIAB_IC_ALAE_NC_Water	,0) 	LIAB_IC_ALAE_NC_Water	, 
isnull(	tmp_ic.LIAB_IC_ALAE_NC_WH	,0) 	LIAB_IC_ALAE_NC_WH	, 
isnull(	tmp_ic.LIAB_IC_ALAE_NC_TV	,0) 	LIAB_IC_ALAE_NC_TV	, 
isnull(	tmp_ic.LIAB_IC_ALAE_NC_FL	,0) 	LIAB_IC_ALAE_NC_FL	, 
isnull(	tmp_ic.LIAB_IC_ALAE_NC_AO	,0) 	LIAB_IC_ALAE_NC_AO	, 
isnull(	tmp_ic.LIAB_IC_ALAE_Cat_Fire	,0) 	LIAB_IC_ALAE_Cat_Fire	, 
isnull(	tmp_ic.LIAB_IC_ALAE_Cat_AO	,0) 	LIAB_IC_ALAE_Cat_AO	, 
	/*--*/			
isnull(	CovA_FL	,0) 	CovA_FL	, 
isnull(	 CovA_SF	,0) 	CovA_SF	, 
isnull(	CovA_EC	,0) 	CovA_EC	, 
isnull(	CovC_FL	,0) 	CovC_FL	, 
isnull(	CovC_SF	,0) 	CovC_SF	, 
isnull(	CovC_EC	,0) 	CovC_EC	, 
	/*--*/			
	GetDate() LoadDate			
from fsbi_stg_spinn.STG_PROPERTY_MODELDATA stg				
left outer join tmp_FACT_HO_LL_MODELDATA_IL tmp_il				
on stg.modeldata_id=tmp_il.modeldata_id				
left outer join tmp_FACT_HO_LL_MODELDATA_IC tmp_ic				
on stg.modeldata_id=tmp_ic.modeldata_id				
left outer join fsbi_dw_spinn.DIM_PRODUCER p				
on p.producer_uniqueid=isnull(stg.producer_uniqueid,'Unknown')
and stg.Startdatetm >= p.valid_fromdate and stg.Startdatetm<p.valid_todate
join fsbi_dw_spinn.DIM_POLICY_CHANGES dc				
on  stg.policy_uniqueid=dc.policy_uniqueid				
and stg.Startdatetm >= dc.valid_fromdate and stg.Startdatetm<dc.valid_todate;				
				
				
				
drop table if exists tmp_FACT_HO_LL_MODELDATA_IL;				
drop table if exists tmp_FACT_HO_LL_MODELDATA_IC;				
				
				
				
/*3. FullTermAmt (WP) per policy_uniqueid, systemid , risk_id and all coverages				
*/				
				
drop table if exists tmp_all_wp;				
create temporary table tmp_all_wp as				
select				
policy_uniqueid,				
systemid,				
risk_uniqueid,				
sum(FullTermAmt) WP				
from fsbi_stg_spinn.vstg_property_modeldata_coverage cov				
group by				
policy_uniqueid,				
systemid,				
risk_uniqueid		;		
				
				
				
truncate table fsbi_dw_spinn.FACT_PROPERTY_MODELDATA;				
insert into fsbi_dw_spinn.FACT_PROPERTY_MODELDATA				
select distinct 				
modeldata_id  ,				
SystemIdStart  ,				
SystemIdEnd  ,				
policy_id  ,				
f.policy_uniqueid  ,				
policy_changes_id ,				
producer_id  ,				
f.Risk_id  ,				
f.Risk_uniqueid  ,				
RiskNumber  ,				
RiskType ,				
Building_id  ,				
Building_uniqueid ,				
StartDateTm ,				
EndDateTm ,				
startdate,				
enddate,				
isnull(WP.WP,0) AllCov_WP,				
AllCov_LossInc,				
AllCov_LossDCCE,				
AllCov_LossALAE,				
isnull(CovA_FullTermAmt ,0) CovA_wp,				
isnull(CovB_FullTermAmt ,0) CovB_wp,				
isnull(CovC_FullTermAmt ,0) CovC_wp,				
isnull(CovD_FullTermAmt ,0) CovD_wp,				
isnull(CovE_FullTermAmt ,0) CovE_wp,				
isnull(CovF_FullTermAmt ,0) CovF_wp,				
CovA_deductible ,				
CovB_deductible ,				
CovC_deductible ,				
CovD_deductible ,				
CovE_deductible ,				
CovF_deductible ,				
CovA_Limit ,				
CovB_Limit ,				
CovC_Limit ,				
CovD_Limit ,				
CovE_Limit ,				
CovF_Limit ,				
OnPremises_Theft_Limit ,				
AwayFromPremises_Theft_Limit,				
Quality_PolAppInconsistency_Flg ,				
Quality_RiskIdDuplicates_Flg ,				
Quality_ClaimOk_Flg  ,				
Quality_ClaimPolicyTermJoin_Flg  ,				
Loss  ,				
Claim_Count  ,				
Cat_Loss  ,				
Cat_Claim_Count  ,				
CovA_IL_NC_Water  ,				
CovA_IL_NC_WH  ,				
CovA_IL_NC_TV  ,				
CovA_IL_NC_FL  ,				
CovA_IL_NC_AO  ,				
CovA_IL_Cat_Fire  ,				
CovA_IL_Cat_AO  ,				
CovB_IL_NC_Water  ,				
CovB_IL_NC_WH  ,				
CovB_IL_NC_TV  ,				
CovB_IL_NC_FL  ,				
CovB_IL_NC_AO  ,				
CovB_IL_Cat_Fire  ,				
CovB_IL_Cat_AO  ,				
CovC_IL_NC_Water  ,				
CovC_IL_NC_WH  ,				
CovC_IL_NC_TV  ,				
CovC_IL_NC_FL  ,				
CovC_IL_NC_AO  ,				
CovC_IL_Cat_Fire  ,				
CovC_IL_Cat_AO  ,				
CovD_IL_NC_Water  ,				
CovD_IL_NC_WH  ,				
CovD_IL_NC_TV  ,				
CovD_IL_NC_FL  ,				
CovD_IL_NC_AO  ,				
CovD_IL_Cat_Fire  ,				
CovD_IL_Cat_AO  ,				
CovE_IL_NC_Water  ,				
CovE_IL_NC_WH  ,				
CovE_IL_NC_TV  ,				
CovE_IL_NC_FL  ,				
CovE_IL_NC_AO  ,				
CovE_IL_Cat_Fire  ,				
CovE_IL_Cat_AO  ,				
CovF_IL_NC_Water  ,				
CovF_IL_NC_WH  ,				
CovF_IL_NC_TV  ,				
CovF_IL_NC_FL  ,				
CovF_IL_NC_AO  ,				
CovF_IL_Cat_Fire  ,				
CovF_IL_Cat_AO  ,				
LIAB_IL_NC_Water  ,				
LIAB_IL_NC_WH  ,				
LIAB_IL_NC_TV  ,				
LIAB_IL_NC_FL  ,				
LIAB_IL_NC_AO  ,				
LIAB_IL_Cat_Fire  ,				
LIAB_IL_Cat_AO  ,				
CovA_IL_DCCE_NC_Water  ,				
CovA_IL_DCCE_NC_WH  ,				
CovA_IL_DCCE_NC_TV  ,				
CovA_IL_DCCE_NC_FL  ,				
CovA_IL_DCCE_NC_AO  ,				
CovA_IL_DCCE_Cat_Fire  ,				
CovA_IL_DCCE_Cat_AO  ,				
CovB_IL_DCCE_NC_Water  ,				
CovB_IL_DCCE_NC_WH  ,				
CovB_IL_DCCE_NC_TV  ,				
CovB_IL_DCCE_NC_FL  ,				
CovB_IL_DCCE_NC_AO  ,				
CovB_IL_DCCE_Cat_Fire  ,				
CovB_IL_DCCE_Cat_AO  ,				
CovC_IL_DCCE_NC_Water  ,				
CovC_IL_DCCE_NC_WH  ,				
CovC_IL_DCCE_NC_TV  ,				
CovC_IL_DCCE_NC_FL  ,				
CovC_IL_DCCE_NC_AO  ,				
CovC_IL_DCCE_Cat_Fire  ,				
CovC_IL_DCCE_Cat_AO  ,				
CovD_IL_DCCE_NC_Water  ,				
CovD_IL_DCCE_NC_WH  ,				
CovD_IL_DCCE_NC_TV  ,				
CovD_IL_DCCE_NC_FL  ,				
CovD_IL_DCCE_NC_AO  ,				
CovD_IL_DCCE_Cat_Fire  ,				
CovD_IL_DCCE_Cat_AO  ,				
CovE_IL_DCCE_NC_Water  ,				
CovE_IL_DCCE_NC_WH  ,				
CovE_IL_DCCE_NC_TV  ,				
CovE_IL_DCCE_NC_FL  ,				
CovE_IL_DCCE_NC_AO  ,				
CovE_IL_DCCE_Cat_Fire  ,				
CovE_IL_DCCE_Cat_AO  ,				
CovF_IL_DCCE_NC_Water  ,				
CovF_IL_DCCE_NC_WH  ,				
CovF_IL_DCCE_NC_TV  ,				
CovF_IL_DCCE_NC_FL  ,				
CovF_IL_DCCE_NC_AO  ,				
CovF_IL_DCCE_Cat_Fire  ,				
CovF_IL_DCCE_Cat_AO  ,				
LIAB_IL_DCCE_NC_Water  ,				
LIAB_IL_DCCE_NC_WH  ,				
LIAB_IL_DCCE_NC_TV  ,				
LIAB_IL_DCCE_NC_FL  ,				
LIAB_IL_DCCE_NC_AO  ,				
LIAB_IL_DCCE_Cat_Fire  ,				
LIAB_IL_DCCE_Cat_AO  ,				
CovA_IL_ALAE_NC_Water  ,				
CovA_IL_ALAE_NC_WH  ,				
CovA_IL_ALAE_NC_TV  ,				
CovA_IL_ALAE_NC_FL  ,				
CovA_IL_ALAE_NC_AO  ,				
CovA_IL_ALAE_Cat_Fire  ,				
CovA_IL_ALAE_Cat_AO  ,				
CovB_IL_ALAE_NC_Water  ,				
CovB_IL_ALAE_NC_WH  ,				
CovB_IL_ALAE_NC_TV  ,				
CovB_IL_ALAE_NC_FL  ,				
CovB_IL_ALAE_NC_AO  ,				
CovB_IL_ALAE_Cat_Fire  ,				
CovB_IL_ALAE_Cat_AO  ,				
CovC_IL_ALAE_NC_Water  ,				
CovC_IL_ALAE_NC_WH  ,				
CovC_IL_ALAE_NC_TV  ,				
CovC_IL_ALAE_NC_FL  ,				
CovC_IL_ALAE_NC_AO  ,				
CovC_IL_ALAE_Cat_Fire  ,				
CovC_IL_ALAE_Cat_AO  ,				
CovD_IL_ALAE_NC_Water  ,				
CovD_IL_ALAE_NC_WH  ,				
CovD_IL_ALAE_NC_TV  ,				
CovD_IL_ALAE_NC_FL  ,				
CovD_IL_ALAE_NC_AO  ,				
CovD_IL_ALAE_Cat_Fire  ,				
CovD_IL_ALAE_Cat_AO  ,				
CovE_IL_ALAE_NC_Water  ,				
CovE_IL_ALAE_NC_WH  ,				
CovE_IL_ALAE_NC_TV  ,				
CovE_IL_ALAE_NC_FL  ,				
CovE_IL_ALAE_NC_AO  ,				
CovE_IL_ALAE_Cat_Fire  ,				
CovE_IL_ALAE_Cat_AO  ,				
CovF_IL_ALAE_NC_Water  ,				
CovF_IL_ALAE_NC_WH  ,				
CovF_IL_ALAE_NC_TV  ,				
CovF_IL_ALAE_NC_FL  ,				
CovF_IL_ALAE_NC_AO  ,				
CovF_IL_ALAE_Cat_Fire  ,				
CovF_IL_ALAE_Cat_AO  ,				
LIAB_IL_ALAE_NC_Water  ,				
LIAB_IL_ALAE_NC_WH  ,				
LIAB_IL_ALAE_NC_TV  ,				
LIAB_IL_ALAE_NC_FL  ,				
LIAB_IL_ALAE_NC_AO  ,				
LIAB_IL_ALAE_Cat_Fire  ,				
LIAB_IL_ALAE_Cat_AO  ,				
CovA_IC_NC_Water  ,				
CovA_IC_NC_WH  ,				
CovA_IC_NC_TV  ,				
CovA_IC_NC_FL  ,				
CovA_IC_NC_AO  ,				
CovA_IC_Cat_Fire  ,				
CovA_IC_Cat_AO  ,				
CovB_IC_NC_Water  ,				
CovB_IC_NC_WH  ,				
CovB_IC_NC_TV  ,				
CovB_IC_NC_FL  ,				
CovB_IC_NC_AO  ,				
CovB_IC_Cat_Fire  ,				
CovB_IC_Cat_AO  ,				
CovC_IC_NC_Water  ,				
CovC_IC_NC_WH  ,				
CovC_IC_NC_TV  ,				
CovC_IC_NC_FL  ,				
CovC_IC_NC_AO  ,				
CovC_IC_Cat_Fire  ,				
CovC_IC_Cat_AO  ,				
CovD_IC_NC_Water  ,				
CovD_IC_NC_WH  ,				
CovD_IC_NC_TV  ,				
CovD_IC_NC_FL  ,				
CovD_IC_NC_AO  ,				
CovD_IC_Cat_Fire  ,				
CovD_IC_Cat_AO  ,				
CovE_IC_NC_Water  ,				
CovE_IC_NC_WH  ,				
CovE_IC_NC_TV  ,				
CovE_IC_NC_FL  ,				
CovE_IC_NC_AO  ,				
CovE_IC_Cat_Fire  ,				
CovE_IC_Cat_AO  ,				
CovF_IC_NC_Water  ,				
CovF_IC_NC_WH  ,				
CovF_IC_NC_TV  ,				
CovF_IC_NC_FL  ,				
CovF_IC_NC_AO  ,				
CovF_IC_Cat_Fire  ,				
CovF_IC_Cat_AO  ,				
LIAB_IC_NC_Water  ,				
LIAB_IC_NC_WH  ,				
LIAB_IC_NC_TV  ,				
LIAB_IC_NC_FL  ,				
LIAB_IC_NC_AO  ,				
LIAB_IC_Cat_Fire  ,				
LIAB_IC_Cat_AO  ,				
CovA_IC_DCCE_NC_Water  ,				
CovA_IC_DCCE_NC_WH  ,				
CovA_IC_DCCE_NC_TV  ,				
CovA_IC_DCCE_NC_FL  ,				
CovA_IC_DCCE_NC_AO  ,				
CovA_IC_DCCE_Cat_Fire  ,				
CovA_IC_DCCE_Cat_AO  ,				
CovB_IC_DCCE_NC_Water  ,				
CovB_IC_DCCE_NC_WH  ,				
CovB_IC_DCCE_NC_TV  ,				
CovB_IC_DCCE_NC_FL  ,				
CovB_IC_DCCE_NC_AO  ,				
CovB_IC_DCCE_Cat_Fire  ,				
CovB_IC_DCCE_Cat_AO  ,				
CovC_IC_DCCE_NC_Water  ,				
CovC_IC_DCCE_NC_WH  ,				
CovC_IC_DCCE_NC_TV  ,				
CovC_IC_DCCE_NC_FL  ,				
CovC_IC_DCCE_NC_AO  ,				
CovC_IC_DCCE_Cat_Fire  ,				
CovC_IC_DCCE_Cat_AO  ,				
CovD_IC_DCCE_NC_Water  ,				
CovD_IC_DCCE_NC_WH  ,				
CovD_IC_DCCE_NC_TV  ,				
CovD_IC_DCCE_NC_FL  ,				
CovD_IC_DCCE_NC_AO  ,				
CovD_IC_DCCE_Cat_Fire  ,				
CovD_IC_DCCE_Cat_AO  ,				
CovF_IC_DCCE_NC_Water  ,				
CovF_IC_DCCE_NC_WH  ,				
CovF_IC_DCCE_NC_TV  ,				
CovF_IC_DCCE_NC_FL  ,				
CovF_IC_DCCE_NC_AO  ,				
CovF_IC_DCCE_Cat_Fire  ,				
CovF_IC_DCCE_Cat_AO  ,				
LIAB_IC_DCCE_NC_Water  ,				
LIAB_IC_DCCE_NC_WH  ,				
LIAB_IC_DCCE_NC_TV  ,				
LIAB_IC_DCCE_NC_FL  ,				
LIAB_IC_DCCE_NC_AO  ,				
LIAB_IC_DCCE_Cat_Fire  ,				
LIAB_IC_DCCE_Cat_AO  ,				
CovA_IC_ALAE_NC_Water  ,				
CovA_IC_ALAE_NC_WH  ,				
CovA_IC_ALAE_NC_TV  ,				
CovA_IC_ALAE_NC_FL  ,				
CovA_IC_ALAE_NC_AO  ,				
CovA_IC_ALAE_Cat_Fire  ,				
CovA_IC_ALAE_Cat_AO  ,				
CovB_IC_ALAE_NC_Water  ,				
CovB_IC_ALAE_NC_WH  ,				
CovB_IC_ALAE_NC_TV  ,				
CovB_IC_ALAE_NC_FL  ,				
CovB_IC_ALAE_NC_AO  ,				
CovB_IC_ALAE_Cat_Fire  ,				
CovB_IC_ALAE_Cat_AO  ,				
CovC_IC_ALAE_NC_Water  ,				
CovC_IC_ALAE_NC_WH  ,				
CovC_IC_ALAE_NC_TV  ,				
CovC_IC_ALAE_NC_FL  ,				
CovC_IC_ALAE_NC_AO  ,				
CovC_IC_ALAE_Cat_Fire  ,				
CovC_IC_ALAE_Cat_AO  ,				
CovD_IC_ALAE_NC_Water  ,				
CovD_IC_ALAE_NC_WH  ,				
CovD_IC_ALAE_NC_TV  ,				
CovD_IC_ALAE_NC_FL  ,				
CovD_IC_ALAE_NC_AO  ,				
CovD_IC_ALAE_Cat_Fire  ,				
CovD_IC_ALAE_Cat_AO  ,				
CovE_IC_ALAE_NC_Water  ,				
CovE_IC_ALAE_NC_WH  ,				
CovE_IC_ALAE_NC_TV  ,				
CovE_IC_ALAE_NC_FL  ,				
CovE_IC_ALAE_NC_AO  ,				
CovE_IC_ALAE_Cat_Fire  ,				
CovE_IC_ALAE_Cat_AO  ,				
CovF_IC_ALAE_NC_Water  ,				
CovF_IC_ALAE_NC_WH  ,				
CovF_IC_ALAE_NC_TV  ,				
CovF_IC_ALAE_NC_FL  ,				
CovF_IC_ALAE_NC_AO  ,				
CovF_IC_ALAE_Cat_Fire  ,				
CovF_IC_ALAE_Cat_AO  ,				
LIAB_IC_ALAE_NC_Water  ,				
LIAB_IC_ALAE_NC_WH  ,				
LIAB_IC_ALAE_NC_TV  ,				
LIAB_IC_ALAE_NC_FL  ,				
LIAB_IC_ALAE_NC_AO  ,				
LIAB_IC_ALAE_Cat_Fire  ,				
LIAB_IC_ALAE_Cat_AO  ,				
isnull(CovA_FL,0) CovA_FL,				
isnull(CovA_SF,0) CovA_SF,				
isnull(CovA_EC,0) CovA_EC,				
isnull(CovC_FL,0) CovC_FL,				
isnull(CovC_SF,0) CovC_SF,				
isnull(CovC_EC,0) CovC_EC,				
pLoadDate  LoadDate 				
from tmp_final  f				
left outer join tmp_all_wp wp				
on f.policy_uniqueid=wp.policy_uniqueid				
and f.SystemIdStart=wp.systemid				
and f.Risk_uniqueid=wp.risk_uniqueid;				
				
drop table if exists tmp_final;				
drop table if exists tmp_all_wp;				
				
END;				



$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_portfolio_auto(pmonth_id int4, ploaddate date)
	LANGUAGE plpgsql
AS $$
			
/*		
Version 2 of the stored procedure to populate v2 portfolio_auto		
IF pmonth_id = 190001 monthes available in fsbi_stg_spinn.fact_policy are used		
othervise pmonth_id is reprocessed		
--		
--		
The algorithm to select months from FACT_POLICYCOVERAGE		
is based on process_bob_building SP as on 2022-08-16. (yes, building, not auto)		
FACT_POLICYTANSACTION data: monthes based on policy term 1st transaction transaction date		
and following month(s if any) before policy becomes inforce and there is a month in FACT_POLICYCOVERAGE		
--		
--		
Only one vehicle per policy based on the minimum veh number (usually 1)		
but amounts are per policy term, not vehicle		
*/		
DECLARE 		
months RECORD;		
query text;		
BEGIN		
		
IF pmonth_id<200002 THEN		
 raise info 'Month_Id was not provided. Monthes available in fsbi_stg_spinn.fact_policy will be used';		
 query := 'select distinct month_id from fsbi_stg_spinn.fact_policy order by month_id';		
ELSE		
 raise info 'Month_Id to process - %', pmonth_Id;		
 query := 'select ' || pmonth_Id || ' month_id';		
END IF;		
		
raise info '%',query;		
		
FOR months IN EXECUTE query LOOP		
 raise info 'Processing %',months.month_id;		
		
  		
/* 1. Data in portofolio should be only from vehicle per policy. */		
/* 1.1  Selecting lowest vehicle  number at the moment of the transaction.		
  It's 1 in most of the cases.		
*/		
drop table if exists first_veh_trn;		
create temporary table first_veh_trn as 		
select cast(substring(fp.transactiondate_id,1,6) as int) month_id, fp.policy_id, min(vehnumber) vehnumber, count(distinct vehicle_uniqueid) risk_cnt,	count(distinct case when LicenseNumber<>'~' then LicenseNumber else null end) DriverCount	
FROM fsbi_dw_spinn.fact_policytransaction fp 		
     join fsbi_dw_spinn.dim_vehicle v on fp.trn_vehicle_id=v.vehicle_id 		
     join fsbi_dw_spinn.dim_driver d on fp.trn_driver_id=d.driver_id 		
     WHERE   FP.TRANSACTIONSEQUENCE = 1 		
     and fp.trn_vehicle_id>0		
     and cast(substring(fp.transactiondate_id,1,6) as int)>=cast(to_char(date_add('year', -4, getdate()), 'yyyymm') as int)		
group by cast(substring(fp.transactiondate_id,1,6) as int), fp.policy_id;		
		
		
		
		
		
/* 1.2  Selecting lowest (inforce) vehicle number each month per policy.		
*/		
 drop table if exists first_veh_month;		
 create temporary table first_veh_month as (		
/*If policy is inforce then then it's possible to have inforce and deleted vehicle*/		
with data as (		
select fpc.month_id, fpc.policy_id, vehnumber, v.vehicle_uniqueid, d.LicenseNumber, d.gooddriverind, ps.polst_statuscd		
from fsbi_dw_spinn.dim_vehicle v		
join fsbi_dw_spinn.fact_policycoverage fpc 		
on fpc.month_vehicle_id=v.vehicle_id		
join fsbi_dw_spinn.vdim_policystatus ps 		
on fpc.policystatus_id = ps.policystatus_id		
join fsbi_dw_spinn.dim_driver d 		
on fpc.month_driver_id=d.driver_id 		
where fpc.month_id = months.month_id		
and (fpc.month_vehicle_id<>0	)	
and ps.polst_statuscd = 'INF'		
and fpc.risk_deletedindicator='N'		
group by fpc.month_id, fpc.policy_id	, ps.polst_statuscd	, vehnumber, v.vehicle_uniqueid, d.LicenseNumber, d.gooddriverind
having sum(term_prem_amt_itd)>0		
)		
select  
month_id, 
policy_id,
polst_statuscd, 
min(vehnumber) vehnumber, 
count(distinct vehicle_uniqueid) risk_cnt,	
count(distinct case when LicenseNumber<>'~' then LicenseNumber else null end) DriverCount,
count(distinct case when LicenseNumber<>'~' and gooddriverind in ('Yes','Super') then LicenseNumber else null end ) GoodDriverCount
from data		
group by month_id, policy_id,polst_statuscd		
union all		
/*when policy is cancelled or non-renewal just taking any first vehicle*/		
select 
fpc.month_id,
fpc.policy_id,
ps.polst_statuscd, 
min(vehnumber) vehnumber, 
case when ps.polst_statuscd = 'CN' then count(DISTINCT v.vehicle_uniqueid) else 0 end risk_cnt	,	
case when ps.polst_statuscd = 'CN' then count(DISTINCT case when d.LicenseNumber<>'~' then d.LicenseNumber else null end) else 0 end DriverCount,
case when ps.polst_statuscd = 'CN' then count(DISTINCT case when d.LicenseNumber<>'~' and d.gooddriverind in ('Yes','Super') then d.LicenseNumber  else null end) else 0 end GoodDriverCount
from fsbi_dw_spinn.dim_vehicle v		
join fsbi_dw_spinn.fact_policycoverage fpc 		
on fpc.month_vehicle_id=v.vehicle_id		
join fsbi_dw_spinn.vdim_policystatus ps 		
on fpc.policystatus_id = ps.policystatus_id		
join fsbi_dw_spinn.dim_driver d 		
on fpc.month_driver_id=d.driver_id		
where fpc.month_id = months.month_id		
and fpc.month_vehicle_id<>0		
and ps.polst_statuscd in ('NR','CN','FE')		
and fpc.risk_deletedindicator='N'		
group by fpc.month_id, fpc.policy_id	, ps.polst_statuscd	
)	;	
		
		
		
/*2 Months of policy backdated transactions*/		
drop table if exists bkdt_trn;		
create temporary table bkdt_trn as 		
select		
distinct		
fp.policy_id,		
cast(substring(fp.accountingdate_id,1,6) as int) month_id		
from fsbi_dw_spinn.fact_policytransaction fp		
join fsbi_dw_spinn.dim_product dp on fp.product_id =dp.product_id 		 
where  dp.prdt_lob in ('PersonalAuto')		
and cast(substring(fp.accountingdate_id,1,6) as int)>cast(substring(fp.effectivedate_id,1,6) as int)		
and  cast(substring(fp.accountingdate_id,1,6) as int)>= to_char(date_add('year', -4, getdate()), 'yyyymm');		
		
		
		
		
/*3. Term Amount(WP) from first transaction only,  		
     first transaction accounting and transaction dates		
and Term Amount(WP) in all transactions*/		
drop table if exists trn_term_amounts;		
create temporary table  trn_term_amounts as (with data as (		
select		
fp.policy_id,		
max(case when fp.transactionsequence = 1 then fp.transactiondate_id else null end) first_transactiondate_id,		
to_date(max(case when fp.transactionsequence = 1 then fp.transactiondate_id else null end),'yyyymmdd') first_transaction_date,		
to_date(max(case when fp.transactionsequence = 1 then fp.accountingdate_id else null end),'yyyymmdd')  first_accounting_date,		
max(fp.accountingdate_id)	max_accountingdate_id,	
fp.policyexpirationdate_id,		
sum(case when fp.transactionsequence = 1 then fp.term_amount else 0 end) original_wp,		
sum(case when fp.transactiondate_id<cast(to_char(dateadd('month', 1, to_date(months.month_id, 'yyyymmdd')),'yyyymmdd') as int) then fp.term_amount else 0 end) all_wp		
FROM fsbi_dw_spinn.fact_policytransaction fp  		
     join fsbi_dw_spinn.dim_coverage c on fp.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce ON dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_product dp on fp.product_id =dp.product_id 		 
     WHERE  dce.codetype!='Fee'		
     and dp.prdt_lob in ('PersonalAuto')		
     GROUP BY fp.policy_id,fp.policyexpirationdate_id		
)		
select		
m.month_id,		
data.policy_id,		
data.first_transaction_date transaction_date,		
data.first_accounting_date accounting_date,		
data.original_wp,		
data.all_wp		
from data 		
left outer join bkdt_trn bt		
on data.policy_id=bt.policy_id		
join fsbi_dw_spinn.dim_month m		
/*extend to each month of policy life or backdated transaction month*/		
on m.month_id>=cast(substring(data.first_transactiondate_id,1,6) as int)		
and (m.month_id<=cast(substring(data.policyexpirationdate_id,1,6) as int)		
or		
(m.month_id=bt.month_id)		
)		
where m.month_id>=cast(to_char(date_add('year', -4, getdate()), 'yyyymm') as int)		
);		
		
		
		
		
/*4. Inforce premium and status per policy monthly for all vehicles*/		
drop table if exists inf_prem_status;		
create temporary table  inf_prem_status as (		
select fpc.month_id, 		
       fpc.policy_id, 		
      sum(fpc.term_prem_amt_itd) - sum(fpc.fees_amt_itd) Inforce_Premium, 		
       ps.polst_statuscd policy_status		,
       ps.policystatus_id		
from fsbi_dw_spinn.fact_policy fpc 		
join fsbi_dw_spinn.vdim_policystatus ps 		
on fpc.policystatus_id = ps.policystatus_id		
join fsbi_dw_spinn.dim_product dp 		
on fpc.product_id =dp.product_id 		
where 		
fpc.month_id = months.month_id		
and dp.prdt_lob in ('PersonalAuto')		
group by fpc.month_id, fpc.policy_id, 	ps.polst_statuscd,ps.policystatus_id	
);		
		
		
		
/*5. Cancellation date in a specific month. A policy can be reinstated in the same or next month		
Canceldt in dim_policyextension is static, latest cancelation date		
*/		
drop table if exists tmp_monthly_canceldt;		
create temporary table  tmp_monthly_canceldt as		
with c as (		
select		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6) month_id,		
max(transactionnumber) transactionnumber		
from fsbi_dw_spinn.fact_policytransaction f		
join fsbi_dw_spinn.dim_product dp 		
on f.product_id =dp.product_id 		
where f.transactioncd='Cancellation'		
and dp.prdt_lob in ('PersonalAuto')		
and  cast(substring(f.accountingdate_id,1,6) as int)>= to_char(date_add('year', -4, getdate()), 'yyyymm')		
group by		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6)		
)		
, r as (		
select		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6) month_id,		
max(transactionnumber) transactionnumber		
from fsbi_dw_spinn.fact_policytransaction f		
join fsbi_dw_spinn.dim_product dp 		
on f.product_id =dp.product_id 		
where f.transactioncd='Reinstatement'		
and dp.prdt_lob in ('PersonalAuto')		
and  cast(substring(f.accountingdate_id,1,6) as int)>= to_char(date_add('year', -4, getdate()), 'yyyymm')		
group by		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6)		
)		
select distinct		
c.policy_id,		
c.month_id,		
f.effectivedate_id canceldt		
from c		
left outer join r		
on c.policy_id=r.policy_id		
and c.month_id=r.month_id		
and c.transactionnumber<r.transactionnumber		
join fsbi_dw_spinn.fact_policytransaction f		
on c.policy_id=f.policy_id		
and c.transactionnumber=f.transactionnumber		
where r.policy_id is null;		
		
/*6. Limits from only INFORCE premiums in a specific month		
In the final query we select INF and Cancelled data		
*/		
		
drop table if exists tmp_BILimit;		
create temporary table tmp_BILimit as		
SELECT		
month_id,		
fpc.policy_id,		
case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end cov_limit		
FROM fsbi_dw_spinn.fact_policycoverage fpc		
     join fsbi_dw_spinn.dim_coverage c on fpc.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce on dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fpc.limit_id		
     join fsbi_dw_spinn.dim_policy p on fpc.policy_id=p.policy_id 		
     join fsbi_dw_spinn.vdim_policystatus ps on fpc.policystatus_id = ps.policystatus_id		
WHERE fpc.month_id = months.month_id		
and ps.polst_statuscd = 'INF'		
and dce.covx_code='BI'		
group by 		
month_id,		
fpc.policy_id,		
cov_limit		
having sum(term_prem_amt_itd)>0;		
		
drop table if exists tmp_PDLimit;		
create temporary table tmp_PDLimit as		
SELECT		
month_id,		
fpc.policy_id,		
case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end cov_limit		
FROM fsbi_dw_spinn.fact_policycoverage fpc		
     join fsbi_dw_spinn.dim_coverage c on fpc.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce on dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fpc.limit_id		
     join fsbi_dw_spinn.dim_policy p on fpc.policy_id=p.policy_id 		
     join fsbi_dw_spinn.vdim_policystatus ps on fpc.policystatus_id = ps.policystatus_id		
WHERE fpc.month_id = months.month_id		
and ps.polst_statuscd = 'INF'		
and dce.covx_code='PD'		
group by 		
month_id,		
fpc.policy_id,		
cov_limit		
having sum(term_prem_amt_itd)>0;		
		
		
drop table if exists tmp_UMBILimit;		
create temporary table tmp_UMBILimit as		
SELECT		
month_id,		
fpc.policy_id,		
case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end cov_limit		
FROM fsbi_dw_spinn.fact_policycoverage fpc		
     join fsbi_dw_spinn.dim_coverage c on fpc.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce on dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fpc.limit_id		
     join fsbi_dw_spinn.dim_policy p on fpc.policy_id=p.policy_id 		
     join fsbi_dw_spinn.vdim_policystatus ps on fpc.policystatus_id = ps.policystatus_id		
WHERE fpc.month_id = months.month_id		
and ps.polst_statuscd = 'INF'		
and dce.covx_code IN ('UMBI', 'UM')		
group by 		
month_id,		
fpc.policy_id,		
cov_limit		
having sum(term_prem_amt_itd)>0;		
		
drop table if exists tmp_MedLimit;		
create temporary table tmp_MedLimit as		
SELECT		
month_id,		
fpc.policy_id,		
case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end cov_limit		
FROM fsbi_dw_spinn.fact_policycoverage fpc		
     join fsbi_dw_spinn.dim_coverage c on fpc.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce on dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fpc.limit_id		
     join fsbi_dw_spinn.dim_policy p on fpc.policy_id=p.policy_id 		
     join fsbi_dw_spinn.vdim_policystatus ps on fpc.policystatus_id = ps.policystatus_id		
WHERE fpc.month_id = months.month_id		
and ps.polst_statuscd = 'INF'		
and dce.covx_code='MEDPAY'		
group by 		
month_id,		
fpc.policy_id,		
cov_limit		
having sum(term_prem_amt_itd)>0;		
		
/*7. Count drivers and count of good drivers - not very accurat because 
 * not assigned drivers are joined by valid from and valid to dates (transaction effective date) and 1st of month_id (transaction accounting date)
 * */		
drop table if exists tmp_CountAllDrivers;		
create temporary table tmp_CountAllDrivers as	
select
f.month_id,
f.policy_id,
count( distinct d.driver_uniqueid) DriverCount,
count( distinct case when d.gooddriverind in ('Yes','Super') then d.driver_uniqueid else null end ) GoodDriverCount
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_month m
on f.month_id=m.month_id
/*All drivers*/
join fsbi_dw_spinn.dim_driver d
on f.policy_id=d.policy_id
and m.mon_startdate>=d.valid_fromdate and m.mon_startdate<d.valid_todate
where f.driver_id<>0
and d.status='Active'
and upper(d.LicenseNumber) not like '%EXCLUDED%' 
and d.DriverTypeCd not in ('NonOperator', 'Excluded', 'UnderAged', 'Nonoperator')
and f.month_id = months.month_id
group by 
f.month_id,
f.policy_id
order by f.month_id;

/*8. Final*/
		
delete from  reporting.portfolio_auto		
where month_id=months.month_id;		
		
		
drop table if exists tmp_portfolio_auto;		
create temporary table tmp_portfolio_auto as  		
select 		
     m.month_id,		
     fp.policy_id,		
     isnull(max(case when first_veh.vehnumber is not null and first_veh.vehnumber=db.vehnumber then db.vehicle_id end),0) vehicle_id,		
     isnull(first_veh.risk_cnt,1) risk_cnt,		
     fp.producer_id,		
     tta.original_wp,		
     tta.all_wp,		
     tta.transaction_date,		
     tta.accounting_date,		
     0.000 Inforce_Premium, 		
     CASE WHEN tta.all_wp > 0 THEN 35 /*FE policystatus_id*/ ELSE 29 /*CN CF policystatus_id*/ END policystatus_id,		
     'Fact_PolicyTransaction-First Transaction' as source,		
      /*case when tta.all_wp > 0 and cast(to_char(p.pol_effectivedate,'yyyymm') as int)=cast(to_char(GetDate(),'yyyymm') as int) then isnull(min(case when ((first_veh.vehnumber is not null and first_veh.vehnumber=db.vehnumber) or first_veh.vehnumber is null) and dce.covx_code='BI' then case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end  else '~' end),'~') else '0/0' end as BILimit,		
      case when tta.all_wp > 0 and cast(to_char(p.pol_effectivedate,'yyyymm') as int)=cast(to_char(GetDate(),'yyyymm') as int) then isnull(min(case when ((first_veh.vehnumber is not null and first_veh.vehnumber=db.vehnumber) or first_veh.vehnumber is null) and dce.covx_code='PD' then case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end  else '~' end),'~') else '0.00' end as PDLimit,		
      case when tta.all_wp > 0 and cast(to_char(p.pol_effectivedate,'yyyymm') as int)=cast(to_char(GetDate(),'yyyymm') as int) then isnull(min(case when ((first_veh.vehnumber is not null and first_veh.vehnumber=db.vehnumber) or first_veh.vehnumber is null) and dce.covx_code IN ('UMBI', 'UM') then case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end  else '~' end),'~') end as UMBILimit,		
      case when tta.all_wp > 0 and cast(to_char(p.pol_effectivedate,'yyyymm') as int)=cast(to_char(GetDate(),'yyyymm') as int) then isnull(min(case when ((first_veh.vehnumber is not null and first_veh.vehnumber=db.vehnumber) or first_veh.vehnumber is null) and dce.covx_code='MEDPAY' then case when dl.COV_LIMIT1 not in ('~','0') then dl.COV_LIMIT1 else '' end+case when dl.COV_LIMIT1 not in ('~','0') and dl.COV_LIMIT2 not in ('~','0') then '/' else '' end+case when dl.COV_LIMIT2 not in ('~','0') then dl.COV_LIMIT2 else '' end  else '~' end),'~') else '0.00' end as MedLimit,		
      */		
      '0/0' as BILimit,		
      '0.00' as PDLimit,		
      null as UMBILimit,		
      '0.00' as MedLimit,		
      0 VehicleCount,		
      0 AssignedDriverCount,
      0 GoodAssignedDriverCount,
      0 DriverCount,
      0 GoodDriverCount 
     FROM fsbi_dw_spinn.fact_policytransaction fp  		
     join fsbi_dw_spinn.dim_coverage c on fp.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce on dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fp.limit_id		
     join fsbi_dw_spinn.dim_product dp on fp.product_id =dp.product_id 		
     join fsbi_dw_spinn.dim_policy p on fp.policy_id =p.policy_id 		
     join fsbi_dw_spinn.dim_month m		
     on m.month_id>=cast(substring(fp.transactiondate_id,1,6) as int)		
     and m.month_id<cast(substring(fp.accountingdate_id,1,6) as int)		
     join trn_term_amounts tta		
     on tta.policy_id=fp.policy_id		
     and tta.month_id=m.month_id		
     join fsbi_dw_spinn.dim_vehicle db on fp.trn_vehicle_id=db.vehicle_id		
     left outer join first_veh_trn  first_veh on first_veh.policy_id=fp.policy_id		
     and first_veh.month_id=cast(substring(fp.transactiondate_id,1,6) as int)		
     WHERE   FP.TRANSACTIONSEQUENCE = 1 		
     and dp.prdt_lob in ('PersonalAuto')		
     and cast(substring(fp.transactiondate_id,1,6) as int)>=cast(to_char(date_add('year', -4, getdate()), 'yyyymm') as int)		
     and cast(substring(fp.transactiondate_id,1,6) as int)<=cast(to_char(getdate(), 'yyyymm') as int)		
     and dce.codetype!='Fee'		
     GROUP BY m.month_id,		
              fp.policy_id,		
              isnull(first_veh.risk_cnt,1),		
              fp.transactiondate_id,		
              fp.producer_id,		
              tta.original_wp,		
              tta.all_wp,		
              tta.transaction_date,		
              tta.accounting_date;		
		
insert into reporting.portfolio_auto 
(
month_id,
policy_id,
vehicle_id,
risk_cnt,
producer_id,
original_wp,
all_wp,
transaction_date,
accounting_date,
inforce_premium,
policystatus_id,
source,
bilimit,
pdlimit,
umbilimit,
medlimit,
VehicleCount,
DriverCount,
loaddate,
canceldt,
AssignedDriverCount,
GoodDriverCount,
GoodAssignedDriverCount
)
select 
pp.month_id,
pp.policy_id,
pp.vehicle_id,
pp.risk_cnt,
pp.producer_id,
pp.original_wp,
pp.all_wp,
pp.transaction_date,
pp.accounting_date,
pp.Inforce_Premium, 
pp.policystatus_id,
pp.source,
pp.BILimit,
pp.PDLimit,
pp.UMBILimit,
pp.MedLimit,
pp.VehicleCount,
pp.DriverCount, 
ploaddate loaddate, 
isnull(to_date(c.canceldt, 'yyyymmdd'),'1900-01-01') canceldt ,
pp.AssignedDriverCount,
pp.GoodDriverCount,
pp.GoodAssignedDriverCount
from tmp_portfolio_auto pp		
left outer join tmp_monthly_canceldt c		
on pp.policy_id=c.policy_id		
and pp.month_id=c.month_id		
where pp.month_id=months.month_id;		
		
		
drop table if exists tmp_portfolio_auto;		
create temporary table tmp_portfolio_auto as		
SELECT 		
      fpc.month_id,		
      fpc.policy_id,		
      isnull(max(case when first_veh.vehnumber is not null and first_veh.vehnumber=db.vehnumber then db.vehicle_id end),0) vehicle_id,		
      isnull(first_veh.risk_cnt,1) risk_cnt,		
      fpc.producer_id,		
      tta.original_wp,		
      tta.all_wp,		
      tta.transaction_date,		
      tta.accounting_date,		
      ips.Inforce_Premium, 		
      ips.policystatus_id,		
      'Fact_PolicyCoverage' as source,		
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id )then '0/0' else isnull(max(tbi.cov_limit),'~') end as BILimit,		
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then '0.00' else isnull(max(tpd.cov_limit),'~') end as PDLimit,		
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then null else isnull(max(tumbi.cov_limit),'~') end  as UMBILimit,		
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then  '0.00' else isnull(max(tmed.cov_limit),'~') end as MedLimit,		
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then 0 else isnull(first_veh.risk_cnt,0) end VehicleCount,		
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then 0 else  isnull(first_veh.DriverCount,0) end AssignedDriverCount,
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then 0 else  isnull(first_veh.GoodDriverCount,0) end GoodAssignedDriverCount,      
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then 0 else  isnull(tcad.DriverCount,0) end DriverCount,
      case when ips.policy_status = 'NR' or (ips.policy_status = 'CN' and cast(to_char(p.pol_expirationdate,'yyyymm') as int)<=fpc.month_id ) then 0 else  isnull(tcad.GoodDriverCount,0) end GoodDriverCount 
     FROM fsbi_dw_spinn.fact_policycoverage fpc		     
     join fsbi_dw_spinn.dim_policy p on fpc.policy_id=p.policy_id 		
     join fsbi_dw_spinn.dim_policyextension pe on fpc.policy_id=pe.policy_id		
     join fsbi_dw_spinn.dim_product dp on fpc.product_id =dp.product_id 		    
     join trn_term_amounts tta		
     on tta.policy_id=fpc.policy_id		
     and tta.month_id=fpc.month_id		
     join inf_prem_status ips		
     on ips.policy_id=fpc.policy_id		
     and ips.month_id=fpc.month_id		
     /*data only from a vehicle with lowest number */		
     join fsbi_dw_spinn.dim_vehicle db on fpc.month_vehicle_id=db.vehicle_id
     /*and count all veh and assigned drivers*/
     left outer join first_veh_month first_veh on first_veh.policy_id=fpc.policy_id		
     and first_veh.month_id=fpc.month_id	
     /*and count all  drivers in a policy*/
     left outer join tmp_CountAllDrivers tcad on tcad.policy_id=fpc.policy_id		
     and tcad.month_id=fpc.month_id     
     /*Limits*/		
     left outer join tmp_BILimit tbi		
     on tbi.policy_id=fpc.policy_id		
     and tbi.month_id=fpc.month_id		
     left outer join tmp_PDLimit tpd		
     on tpd.policy_id=fpc.policy_id		
     and tpd.month_id=fpc.month_id		
     left outer join tmp_UMBILimit tumbi		
     on tumbi.policy_id=fpc.policy_id		
     and tumbi.month_id=fpc.month_id     		
     left outer join tmp_MedLimit tmed		
     on tmed.policy_id=fpc.policy_id		
     and tmed.month_id=fpc.month_id          		
     where  dp.prdt_lob in ('PersonalAuto')		
     and fpc.coverage_deletedindicator = 'N'		
     and fpc.month_id = months.month_id		
     AND (		
  ips.policy_status = 'INF' OR		
  fpc.POLICYCANCELLEDEFFECTIVEIND = 1		
  OR (ips.policy_status = 'NR' AND fpc.POLICYEXPIREDEFFECTIVEIND = 1)		
  OR (ips.policy_status = 'CN' AND (fpc.POLICYCANCELLEDEFFECTIVEIND = 1 OR fpc.POLICYCANCELLEDISSUEDIND = 1)		
  )		
  OR (ABS(fpc.EARNED_PREM_AMT) > 0 AND ips.policy_status <> 'CN')		
  OR (fpc.POLICYNEWISSUEDIND = 1 AND fpc.POLICYCANCELLEDISSUEDIND = 1 AND ips.policy_status = 'CN') --Backdated born and cancelled		
  )		
  AND ips.policy_status <> 'EXP'		
  group by 		
     fpc.policy_id,		
     isnull(first_veh.risk_cnt,1),		
     fpc.month_id,		
     fpc.producer_id,		
     tta.original_wp,		
     tta.all_wp,		
     tta.transaction_date,		
     tta.accounting_date,		
     ips.Inforce_Premium, 		
     ips.policystatus_id,		
     ips.policy_status,		
     cast(to_char(p.pol_expirationdate,'yyyymm') as int),		
     isnull(first_veh.risk_cnt,0),		
     isnull(first_veh.DriverCount,0),
     isnull(first_veh.GoodDriverCount,0),
     isnull(tcad.DriverCount,0),
     isnull(tcad.GoodDriverCount,0);	 	
		
		
		
insert into reporting.portfolio_auto      
(
month_id,
policy_id,
vehicle_id,
risk_cnt,
producer_id,
original_wp,
all_wp,
transaction_date,
accounting_date,
inforce_premium,
policystatus_id,
source,
bilimit,
pdlimit,
umbilimit,
medlimit,
VehicleCount,
DriverCount,
loaddate,
canceldt,
AssignedDriverCount,
GoodDriverCount,
GoodAssignedDriverCount
)
select 
pp.month_id,
pp.policy_id,
pp.vehicle_id,
pp.risk_cnt,
pp.producer_id,
pp.original_wp,
pp.all_wp,
pp.transaction_date,
pp.accounting_date,
pp.Inforce_Premium, 
pp.policystatus_id,
pp.source,
pp.BILimit,
pp.PDLimit,
pp.UMBILimit,
pp.MedLimit,
pp.VehicleCount,
pp.DriverCount, 
ploaddate  loaddate, 
isnull(to_date(c.canceldt, 'yyyymmdd') ,'1900-01-01') canceldt,
pp.AssignedDriverCount,
pp.GoodDriverCount,
pp.GoodAssignedDriverCount
from tmp_portfolio_auto pp		
left outer join tmp_monthly_canceldt c		
on pp.policy_id=c.policy_id		
and pp.month_id=c.month_id		
where pp.month_id=months.month_id;		
		
		
END LOOP;		
		
END;		

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_portfolio_property(pmonth_id int4, ploaddate date)
	LANGUAGE plpgsql
AS $$
			
/*		
Version 2 of the stored procedure to populate v2 portfolio_property		
IF pmonth_id = 190001 monthes available in fsbi_stg_spinn.fact_policy are used		
othervise pmonth_id is reprocessed		
--		
Data based on FACT_POLICYTRANSACTION deleted completly		
and only 4 recent years added (all monthes based on 1st transaction transaction date		
and month between inforce month in FACT_POLICYCOVERAGE if any)		
Data based on FACT_POLICYCOVERAGE: only month_id is deleted and inserted		
--		
The algorithm to select months from FACT_POLICYCOVERAGE		
is based on process_bob_building SP as on 2022-08-16.		
FACT_POLICYTANSACTION data: monthes based on policy term 1st transaction transaction date		
and following month(s if any) before policy becomes inforce and there is a month in FACT_POLICYCOVERAGE		
--		
The coverage based columns selection is based on sp_pm_property_coverages as on 2022-08-16		
and presumably continuos requrements to PortfolioManagment (PM) dashboard.		
They are needed to pivot row from FACT_POLICYCOVERAGE and FACT_POLICYTRANSACTION		
The rest of the columns are IDs in the opposite to hard coded values from		
the original portfolio_property and bob_building		
--		
Only one building per policy based on the minimum bldg number (usually 1)		
but amounts are per policy term, not building		
*/		
DECLARE 		
months RECORD;		
query text;		
BEGIN		
		
IF pmonth_id<200002 THEN		
 raise info 'Month_Id was not provided. Monthes available in fsbi_stg_spinn.fact_policy will be used';		
 query := 'select distinct month_id from fsbi_stg_spinn.fact_policy order by month_id';		
ELSE		
 raise info 'Month_Id to process - %', pmonth_Id;		
 query := 'select ' || pmonth_Id || ' month_id';		
END IF;		
		
raise info '%',query;		
		
FOR months IN EXECUTE query LOOP		
 raise info 'Processing %',months.month_id;		
		
  		
/* 1. Data in portofolio should be only from building per policy. */		
/* 1.1  Selecting lowest building number at the moment of the transaction.		
  It's 1 in most of the cases.		
*/		
drop table if exists first_bldg_trn;		
create temporary table first_bldg_trn as 		
select cast(substring(fp.transactiondate_id,1,6) as int) month_id, fp.policy_id, min(bldgnumber) bldgnumber,count(DISTINCT b.building_uniqueid) risk_cnt		
FROM fsbi_dw_spinn.fact_policytransaction fp 		
     join fsbi_dw_spinn.dim_building b on fp.trn_building_id=b.building_id 		
     WHERE   FP.TRANSACTIONSEQUENCE = 1 		
     and fp.trn_building_id>0		
     and cast(substring(fp.transactiondate_id,1,6) as int)>=cast(to_char(date_add('year', -4, getdate()), 'yyyymm') as int)		
group by cast(substring(fp.transactiondate_id,1,6) as int), fp.policy_id;		
		
		
		
/* 1.2  Selecting lowest (inforce) building number each month per policy.		
  It's 1 in most of the cases.		
*/		
 drop table if exists first_bldg_month;		
 create temporary table first_bldg_month as (		
/*If policy is inforce then then it's possible to have inforce and deleted building*/		
select fpc.month_id, fpc.policy_id, min(bldgnumber) bldgnumber,count(DISTINCT b.building_uniqueid) risk_cnt	,ps.polst_statuscd	
from fsbi_dw_spinn.dim_building b		
join fsbi_dw_spinn.fact_policycoverage fpc 		
on fpc.month_building_id=b.building_id		
join fsbi_dw_spinn.vdim_policystatus ps 		
on fpc.policystatus_id = ps.policystatus_id		
where fpc.month_id = months.month_id		
and (fpc.month_building_id<>0	)	
and ps.polst_statuscd = 'INF'		
group by fpc.month_id, fpc.policy_id	, ps.polst_statuscd	
having sum(term_prem_amt_itd)>0		
union all		
/*when policy is cancelled or non-renewal just taking any first building*/		
select fpc.month_id, fpc.policy_id, min(bldgnumber) bldgnumber,count(DISTINCT b.building_uniqueid) risk_cnt	,ps.polst_statuscd	
from fsbi_dw_spinn.dim_building b		
join fsbi_dw_spinn.fact_policycoverage fpc 		
on fpc.month_building_id=b.building_id		
join fsbi_dw_spinn.vdim_policystatus ps 		
on fpc.policystatus_id = ps.policystatus_id		
where fpc.month_id = months.month_id		
and fpc.month_building_id<>0		
and ps.polst_statuscd in ('NR','CN','FE')		
group by fpc.month_id, fpc.policy_id	, ps.polst_statuscd	
)	;	
		
/*2 Months of policy backdated transactions*/		
drop table if exists bkdt_trn;		
create temporary table bkdt_trn as 		
select		
distinct		
fp.policy_id,		
cast(substring(fp.accountingdate_id,1,6) as int) month_id		
from fsbi_dw_spinn.fact_policytransaction fp		
join fsbi_dw_spinn.dim_product dp on fp.product_id =dp.product_id 		 
where  upper(dp.prdt_lob) in ('HOMEOWNERS','DWELLING')		
and cast(substring(fp.accountingdate_id,1,6) as int)>cast(substring(fp.effectivedate_id,1,6) as int)		
and  cast(substring(fp.accountingdate_id,1,6) as int)>= to_char(date_add('year', -4, getdate()), 'yyyymm');		
		
		
/*3. Term Amount(WP) from first transaction only,  		
     first transaction accounting and transaction dates		
and Term Amount(WP) in all transactions*/		
drop table if exists trn_term_amounts;		
create temporary table  trn_term_amounts as (with data as (		
select		
fp.policy_id,		
max(case when fp.transactionsequence = 1 then fp.transactiondate_id else null end) first_transactiondate_id,		
to_date(max(case when fp.transactionsequence = 1 then fp.transactiondate_id else null end),'yyyymmdd') first_transaction_date,		
to_date(max(case when fp.transactionsequence = 1 then fp.accountingdate_id else null end),'yyyymmdd')  first_accounting_date,		
max(fp.accountingdate_id)	max_accountingdate_id,	
fp.policyexpirationdate_id,		
sum(case when fp.transactionsequence = 1 then fp.term_amount else 0 end) original_wp,		
sum(case when fp.transactiondate_id<cast(to_char(dateadd('month', 1, to_date(months.month_id, 'yyyymmdd')),'yyyymmdd') as int) then fp.term_amount else 0 end) all_wp		
FROM fsbi_dw_spinn.fact_policytransaction fp  		
     join fsbi_dw_spinn.dim_coverage c on fp.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce ON dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_product dp on fp.product_id =dp.product_id 		 
     WHERE  dce.codetype!='Fee'		
     and upper(dp.prdt_lob) in ('HOMEOWNERS','DWELLING')		
     GROUP BY fp.policy_id,fp.policyexpirationdate_id		
)		
select		
m.month_id,		
data.policy_id,		
data.first_transaction_date transaction_date,		
data.first_accounting_date accounting_date,		
data.original_wp,		
data.all_wp		
from data 		
left outer join bkdt_trn bt		
on data.policy_id=bt.policy_id		
join fsbi_dw_spinn.dim_month m		
/*extend to each month of policy life or backdated transaction month*/		
on m.month_id>=cast(substring(data.first_transactiondate_id,1,6) as int)		
and (m.month_id<=cast(substring(data.policyexpirationdate_id,1,6) as int)		
or		
(m.month_id=bt.month_id)		
)		
where m.month_id>=cast(to_char(date_add('year', -4, getdate()), 'yyyymm') as int)		
);		
		
/*4. Inforce premium and status per policy monthly for all building*/		
drop table if exists inf_prem_status;		
create temporary table  inf_prem_status as (		
select fpc.month_id, 		
       fpc.policy_id, 		
      sum(fpc.term_prem_amt_itd) - sum(fpc.fees_amt_itd) Inforce_Premium, 		
       ps.polst_statuscd policy_status		,
       ps.policystatus_id		
from fsbi_dw_spinn.fact_policy fpc 		
join fsbi_dw_spinn.vdim_policystatus ps 		
on fpc.policystatus_id = ps.policystatus_id		
where 		
fpc.month_id = months.month_id		
group by fpc.month_id, fpc.policy_id, 	ps.polst_statuscd,ps.policystatus_id	
);		
		
/*5. Cancellation date in a specific mont. A policy can be reinstated in the same or next month		
Canceldt in dim_policyextension is static, latest cancelation date		
*/		
drop table if exists tmp_monthly_canceldt;		
create temporary table  tmp_monthly_canceldt as		
with c as (		
select		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6) month_id,		
max(transactionnumber) transactionnumber		
from fsbi_dw_spinn.fact_policytransaction f		
where f.transactioncd='Cancellation'		
group by		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6)		
)		
, r as (		
select		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6) month_id,		
max(transactionnumber) transactionnumber		
from fsbi_dw_spinn.fact_policytransaction f		
where f.transactioncd='Reinstatement'		
group by		
f.policy_id,		
substring(cast(f.accountingdate_id as varchar),1,6)		
)		
select distinct		
c.policy_id,		
c.month_id,		
f.effectivedate_id canceldt		
from c		
left outer join r		
on c.policy_id=r.policy_id		
and c.month_id=r.month_id		
and c.transactionnumber<r.transactionnumber		
join fsbi_dw_spinn.fact_policytransaction f		
on c.policy_id=f.policy_id		
and c.transactionnumber=f.transactionnumber		
where r.policy_id is null;		
		
		
		
delete from  reporting.portfolio_property		
where month_id=months.month_id;		
		
drop table if exists tmp_portfolio_property;		
create temporary table tmp_portfolio_property as  		
select 		
     m.month_id,		
     fp.policy_id,		
     isnull(max(case when first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber then db.building_id end),0) building_id,		
     isnull(first_bldg.risk_cnt,1) risk_cnt,		
     fp.producer_id,		
     tta.original_wp,		
     tta.all_wp,		
     tta.transaction_date,		
     tta.accounting_date,		
     0.000 Inforce_Premium, 		
     CASE WHEN tta.all_wp > 0 THEN 35 /*FE policystatus_id*/ ELSE 29 /*CN CF policystatus_id*/ END policystatus_id,		
     'Fact_PolicyTransaction-First Transaction' as source,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SEWER' then dl.COV_LIMIT1_VALUE else 0 end) as BackupofSewersandDrains,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='BEDBUG' then dl.COV_LIMIT1_VALUE else 0 end) as BedBugCoverage,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='BOLAW' then dl.COV_LIMIT1_VALUE else 0 end) as BuildingOrdinanceorLaw,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='H051ST0' then dl.COV_LIMIT1_VALUE else 0 end) as BuildingAdditionsandAlterationsIncreasedLimit,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='COC' then dl.COV_LIMIT1_VALUE else 0 end) as CourseofConstruction,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='HO5' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as ContentsOpenPerils,  		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovA' then dl.COV_LIMIT1_VALUE else 0 end) as CovA,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovB' then dl.COV_LIMIT1_VALUE else 0 end) as CovB,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovC' then dl.COV_LIMIT1_VALUE else 0 end) as CovC,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovD' then dl.COV_LIMIT1_VALUE else 0 end) as CovD,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovE' then dl.COV_LIMIT1_VALUE else 0 end) as CovE,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code ='MEDPAY' then dl.COV_LIMIT1_VALUE else 0 end) as CovF,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='EQPBK' then (case when dl.cov_limit1 = '~' then 'Yes' else ISNULL(dl.COV_LIMIT1, dl.COV_LIMIT2) end) else '0' end) as EquipmentBreakdown,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='EmployeeDiscount' and FP.Amount < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as EmployeeDiscount, 		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='ML545' then db.expandedreplacementcostind end) as ExpandedReplacementCost,  		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='FVREP' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end) else '0' end) as ExtendedReplacementCostDwelling,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='FXRC' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as FunctionalReplacementCost,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='FRAUD' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end) else '0' end) as IdentityRecoveryCoverage,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='MultiPolicy' and FP.Amount < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as MultiPolicyDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='OLT' then dl.COV_LIMIT1_VALUE else 0 end) as LandlordEvictionExpenseReimbursement,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='LAC' then dl.COV_LIMIT1_VALUE else 0 end) as LossAssessment,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='OccupationDiscount' and FP.Amount < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as OccupationDiscount, 		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='INCB' then dl.COV_LIMIT1_VALUE else 0 end) as OtherStructuresIncreasedLimit,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='INCC' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end)  else '0' end) as PersonalPropertyIncreasedLimit,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PIHOM' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end) else '0' end) as PersonalInjuryLiability,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PPREP' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as PersonalPropertyReplacementCostOption,   		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PRTDVC' and FP.Amount < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as ProtectiveDevices,  		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PropertyManager' then db.propertymanager  end) as PropertyManagerDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='RentersInsurance' and FP.Amount < 0 then db.rentersinsurance end) as RentersInsuranceVerificationDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='UTLDB' then dl.COV_LIMIT1_VALUE else 0 end) as ServiceLine,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SeniorDiscount' and FP.Amount < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end )  end) as SeniorDiscount, 		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SRORP' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end)  else '0' end) as StructuresRentedtoOthersResidencePremises,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SPP' then (case when dl.cov_limit1 = '~' or dl.cov_limit1 = 0 then 'Yes' else 'No' end )  end) as ScheduledPersonalProperty,		 
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='THEFA' then dl.COV_LIMIT1_VALUE else 0 end) as Theft, 		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='WCINC' and dce.covx_description= 'Workers Compensation' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as WorkersCompensation,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='WCINC' and dce.covx_description= 'Workers Compensation - Occasional Employee' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as WorkersCompensationOccasionalEmployee		
     ,substring(replace(listagg(distinct case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SPP' then cl.class_code else '~' end,','),'~,',''),1,250)  spp_class_code		
     ,substring(replace(listagg(distinct case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='INCB' then cl.class_code else '~' end,','),'~,',''),1,250) incb_class_code		
     FROM fsbi_dw_spinn.fact_policytransaction fp  		
     join fsbi_dw_spinn.dim_product dp on fp.product_id =dp.product_id 		
     join fsbi_dw_spinn.dim_coverage c on fp.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce ON dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fp.limit_id		
     join fsbi_dw_spinn.dim_classification cl on fp.class_id=cl.class_id		
     join fsbi_dw_spinn.dim_month m		
     on m.month_id>=cast(substring(fp.transactiondate_id,1,6) as int)		
     and m.month_id<cast(substring(fp.accountingdate_id,1,6) as int)		
     join trn_term_amounts tta		
     on tta.policy_id=fp.policy_id		
     and tta.month_id=m.month_id		
     join fsbi_dw_spinn.dim_building db on fp.trn_building_id=db.building_id		
     left outer join first_bldg_trn  first_bldg on first_bldg.policy_id=fp.policy_id		
     and first_bldg.month_id=cast(substring(fp.transactiondate_id,1,6) as int)		
     WHERE   FP.TRANSACTIONSEQUENCE = 1 		
     and upper(dp.prdt_lob) in ('HOMEOWNERS','DWELLING')		
     and cast(substring(fp.transactiondate_id,1,6) as int)>=cast(to_char(date_add('year', -4, getdate()), 'yyyymm') as int)		
     and cast(substring(fp.transactiondate_id,1,6) as int)<=cast(to_char(getdate(), 'yyyymm') as int)		
     and dce.codetype!='Fee'		
     GROUP BY m.month_id,		
              fp.policy_id,		
              isnull(first_bldg.risk_cnt,1),		
              fp.transactiondate_id,		
              fp.producer_id,		
              tta.original_wp,		
              tta.all_wp,		
              tta.transaction_date,		
              tta.accounting_date;		
		
insert into reporting.portfolio_property             		
select pp.*, ploaddate loaddate, isnull(to_date(c.canceldt, 'yyyymmdd'),'1900-01-01') canceldt  		
from tmp_portfolio_property pp		
left outer join tmp_monthly_canceldt c		
on pp.policy_id=c.policy_id		
and pp.month_id=c.month_id		
where pp.month_id=months.month_id;		
		
		
drop table if exists tmp_portfolio_property;		
create temporary table tmp_portfolio_property as		
SELECT 		
      fpc.month_id,		
      fpc.policy_id,		
      isnull(max(case when first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber then db.building_id end),0) building_id,		
      isnull(first_bldg.risk_cnt,1) risk_cnt,		
      fpc.producer_id,		
      tta.original_wp,		
      tta.all_wp,		
      tta.transaction_date,		
      tta.accounting_date,		
      ips.Inforce_Premium, 		
      ips.policystatus_id,		
     'Fact_PolicyCoverage' as source,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SEWER' then dl.COV_LIMIT1_VALUE else 0 end) as BackupofSewersandDrains,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='BEDBUG' then dl.COV_LIMIT1_VALUE else 0 end) as BedBugCoverage,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='BOLAW' then dl.COV_LIMIT1_VALUE else 0 end) as BuildingOrdinanceorLaw,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='H051ST0' then dl.COV_LIMIT1_VALUE else 0 end) as BuildingAdditionsandAlterationsIncreasedLimit,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='COC' then dl.COV_LIMIT1_VALUE else 0 end) as CourseofConstruction,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='HO5' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as ContentsOpenPerils,  		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovA' then dl.COV_LIMIT1_VALUE else 0 end) as CovA,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovB' then dl.COV_LIMIT1_VALUE else 0 end) as CovB,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovC' then dl.COV_LIMIT1_VALUE else 0 end) as CovC,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovD' then dl.COV_LIMIT1_VALUE else 0 end) as CovD,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='CovE' then dl.COV_LIMIT1_VALUE else 0 end) as CovE,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code ='MEDPAY' then dl.COV_LIMIT1_VALUE else 0 end) as CovF,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='EQPBK' then (case when dl.cov_limit1 = '~' then 'Yes' else ISNULL(dl.COV_LIMIT1, dl.COV_LIMIT2) end) else '0' end) as EquipmentBreakdown,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='EmployeeDiscount' and FPC.WRTN_PREM_AMT_ITD < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as EmployeeDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='ML545' then db.expandedreplacementcostind end) as ExpandedReplacementCost,  		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='FVREP' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end) else '0' end) as ExtendedReplacementCostDwelling,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='FXRC' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as FunctionalReplacementCost,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='FRAUD' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end) else '0' end) as IdentityRecoveryCoverage,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='MultiPolicy' and FPC.WRTN_PREM_AMT_ITD < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as MultiPolicyDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='OLT' then dl.COV_LIMIT1_VALUE else 0 end) as LandlordEvictionExpenseReimbursement,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='LAC' then dl.COV_LIMIT1_VALUE else 0 end) as LossAssessment,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='OccupationDiscount' and FPC.WRTN_PREM_AMT_ITD < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as OccupationDiscount, 		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='INCB' then dl.COV_LIMIT1_VALUE else 0 end) as OtherStructuresIncreasedLimit,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='INCC' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end)  else '0' end) as PersonalPropertyIncreasedLimit,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PIHOM' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end) else '0' end) as PersonalInjuryLiability,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PPREP' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as PersonalPropertyReplacementCostOption,   		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PRTDVC' and FPC.WRTN_PREM_AMT_ITD < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as ProtectiveDevices,  		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='PropertyManager' then db.propertymanager  end) as PropertyManagerDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='RentersInsurance' and FPC.WRTN_PREM_AMT_ITD < 0 then db.rentersinsurance end) as RentersInsuranceVerificationDiscount,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='UTLDB' then dl.COV_LIMIT1_VALUE else 0 end) as ServiceLine,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SeniorDiscount' and FPC.WRTN_PREM_AMT_ITD < 0 then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end )  end) as SeniorDiscount, 		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SRORP' then (case when dl.cov_limit1 = '~' then 'Yes' else CAST(dl.COV_LIMIT1_VALUE as varchar(15)) end)  else '0' end) as StructuresRentedtoOthersResidencePremises,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SPP' then (case when dl.cov_limit1 = '~' or dl.cov_limit1 = 0 then 'Yes' else 'No' end )  end) as ScheduledPersonalProperty,		 
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='THEFA' then dl.COV_LIMIT1_VALUE else 0 end) as Theft ,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='WCINC' and dce.covx_description= 'Workers Compensation' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as WorkersCompensation,		
     max(case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='WCINC' and dce.covx_description= 'Workers Compensation - Occasional Employee' then (case when dl.cov_limit1 = '~' then 'Yes' else 'No' end ) end) as WorkersCompensationOccasionalEmployee		
     ,substring(replace(listagg(distinct case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='SPP' then cl.class_code else '~' end,','),'~,',''),1,250)  spp_class_code		
     ,substring(replace(listagg(distinct case when ((first_bldg.bldgnumber is not null and first_bldg.bldgnumber=db.bldgnumber) or first_bldg.bldgnumber is null) and dce.covx_code='INCB' then cl.class_code else '~' end,','),'~,',''),250)  incb_class_code		
     FROM fsbi_dw_spinn.fact_policycoverage fpc		
     join fsbi_dw_spinn.dim_policy p on fpc.policy_id=p.policy_id 		
     join fsbi_dw_spinn.dim_policyextension pe on fpc.policy_id=pe.policy_id		
     join fsbi_dw_spinn.dim_product dp on fpc.product_id =dp.product_id 		
     join fsbi_dw_spinn.dim_coverage c on fpc.coverage_id=c.coverage_id		
     left outer join public.dim_coverageextension dce on dce.coverage_id  = c.coverage_id		
     join fsbi_dw_spinn.dim_limit dl on dl.limit_id = fpc.limit_id		
     join fsbi_dw_spinn.dim_classification cl on fpc.class_id=cl.class_id     		
     join trn_term_amounts tta		
     on tta.policy_id=fpc.policy_id		
     and tta.month_id=fpc.month_id		
     join inf_prem_status ips		
     on ips.policy_id=fpc.policy_id		
     and ips.month_id=fpc.month_id		
     /*data only from a building with lowest number*/		
     join fsbi_dw_spinn.dim_building db on fpc.month_building_id=db.building_id		
     left outer join first_bldg_month first_bldg on first_bldg.policy_id=fpc.policy_id		
     and first_bldg.month_id=fpc.month_id		
     where  UPPER(dp.prdt_lob) in ('HOMEOWNERS','DWELLING')		
     and fpc.coverage_deletedindicator = 'N'		
     and fpc.month_id = months.month_id		
     and dce.codetype!='Fee'		
     AND (		
  ips.policy_status = 'INF' OR		
  fpc.POLICYCANCELLEDEFFECTIVEIND = 1		
  OR (ips.policy_status = 'NR' AND fpc.POLICYEXPIREDEFFECTIVEIND = 1)		
  OR (ips.policy_status = 'CN' AND (fpc.POLICYCANCELLEDEFFECTIVEIND = 1 OR fpc.POLICYCANCELLEDISSUEDIND = 1)		
  )		
  OR (ABS(fpc.EARNED_PREM_AMT) > 0 AND ips.policy_status <> 'CN')		
  OR (fpc.POLICYNEWISSUEDIND = 1 AND fpc.POLICYCANCELLEDISSUEDIND = 1 AND ips.policy_status = 'CN') --Backdated born and cancelled		
  )		
  AND ips.policy_status <> 'EXP'		
     group by 		
     fpc.policy_id,		
     isnull(first_bldg.risk_cnt,1),		
     fpc.month_id,		
     fpc.producer_id,		
     tta.original_wp,		
     tta.all_wp,		
     tta.transaction_date,		
     tta.accounting_date,		
     ips.Inforce_Premium, 		
     ips.policystatus_id;	 	
		
		
insert into reporting.portfolio_property              		
select pp.*, ploaddate loaddate, isnull(to_date(c.canceldt, 'yyyymmdd') ,'1900-01-01') canceldt  		
from tmp_portfolio_property pp		
left outer join tmp_monthly_canceldt c		
on pp.policy_id=c.policy_id		
and pp.month_id=c.month_id		
where pp.month_id=months.month_id;		
		
		
END LOOP;		
		
END;		

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_claim_summaries(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
DECLARE 
months RECORD;
BEGIN

create temporary table tmp_dp as
select distinct 
claim_number,
case 
when claim_number in (
'00449940',
'00449867',
'00449943',
'00449915'
) then 'CommercialFire' 
else   coalesce(p.prdt_lob, f.product )
end product
from public.vmfact_claimtransaction_blended f
left outer join fsbi_dw_spinn.dim_product p
on f.product=p.prdt_name;

create temporary table tmp_da as
select distinct 
claim_number,
max(acct_date) acct_date
from public.vmfact_claimtransaction_blended f
where (source_system='SPINN' or (source_system='WINS' and loss_cause is not null))
group by claim_number;

create temporary table tmp_dc as
select distinct 
f.claim_number,
max(catastrophe_id) catastrophe_id,
max(loss_cause) loss_cause,
max(policy_state) policy_state,
max(company) company,
max(carrier) carrier,
max(policyref) policyref
from public.vmfact_claimtransaction_blended f
join tmp_da
on f.claim_number=tmp_da.claim_number
and f.acct_date=tmp_da.acct_date
where (source_system='SPINN' or (source_system='WINS' and loss_cause is not null))
group by f.claim_number;

create temporary table tmp_fm as 
select distinct
covx.covx_asl as aslob,
covx.act_rag  as rag,
left(covx.coveragetype,1) as feature_type,
covx.covx_code as feature,
isnull(covx.act_map,'~') as feature_map
from public.dim_coverageextension covx
union all
select distinct 
aslob,
rag,
left(feature_type,1) as feature_type,
feature,
'~' feature_map
from public.vmfact_claimtransaction_blended
where feature='~'
union 
select distinct
aslob,
rag,
feature_type,
feature,
feature_map
from fsbi_dw_wins.ppd_feature_map_wins;


FOR months IN 
 select distinct 
 month_id , 
 cast(to_char(add_months(cast(cast(month_id as varchar) + '01' as date),-1),'YYYYMM') as int) prev_month_id
 from fsbi_stg_spinn.fact_claim
 order by month_id
LOOP

delete from reporting.ppd_claim_summaries
where month_id=months.month_id;

insert into reporting.ppd_claim_summaries
select 
f.month_id,
f.claim_number,
f.claimant,
dc.policy_state,
dc.carrier,
dc.company,
case 
 when cast(po.pol_policynumbersuffix as int)<2 then 'New'
 else 'Renewal'
end policyneworrenewal,
case when dc.catastrophe_id is null then 'No' else 'Yes' end Cat_Flg,
case 
 when fm.rag in ('HO','SP') and fm.feature_type='L' then 'Liability'
 when dc.loss_cause in ('Fire','FIRE','Smoke') then 'Fire'
 when dc.loss_cause in ('Water','Water Backup','Water Damage','WATER DAMAGE','Water Discharge') then 'Water'
 when dc.loss_cause in ('Flood','Freezing','Hail','Landslide','Lightning','Weight of Ice Snow Sleet','Wind and Hail','Windstorm','Windstorm and Hail') then 'Weather'
 when dc.loss_cause is null and fm.feature_type='L' then 'Liability'
 when dc.loss_cause is null and fm.feature_type='P'  then 'Other'
 else 'Other'
end as PerilGroup,
dc.loss_cause,
dp.product,
case when fm.aslob in ('051','052') then 'CM' else  fm.rag end rag,
fm.feature_type,
fm.feature_map,
sum(f.loss_paid + f.loss_reserve + f.aoo_paid + f.dcc_paid + f.aoo_reserve + f.dcc_reserve - f.salvage_received  - f.subro_received) total_incurred_loss,
sum(f.loss_paid + f.loss_reserve) loss_incurred,
sum(f.aoo_paid + f.dcc_paid + f.aoo_reserve + f.dcc_reserve) alae_incurred,
sum(f.aoo_paid + f.dcc_paid) alae_paid,
sum(f.salvage_received + f.salvage_reserve + f.subro_received + f.subro_reserve)   salsub_incurred,
sum(f.salvage_received + f.subro_received) salsub_received,
sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve)  total_reserve
,pLoadDate LoadDate
from public.vmfact_claim_blended  f 
left outer join tmp_dc dc
on dc.claim_number=f.claim_number
left outer join tmp_dp dp
on dp.claim_number=f.claim_number
left outer join tmp_fm fm
on fm.aslob = f.aslob and
fm.rag = f.rag and
fm.feature_type = f.feature_type and 
fm.feature = f.feature 
left outer join fsbi_dw_spinn.dim_policy po
on dc.PolicyRef=po.pol_uniqueid
where loss_date >= '2012-01-01'
and month_id=months.month_id
group by
f.month_id,
f.claim_number,
f.claimant,
dc.policy_state,
dc.carrier,
dc.company,
case 
 when cast(po.pol_policynumbersuffix as int)<2 then 'New'
 else 'Renewal'
end,
case when dc.catastrophe_id is null then 'No' else 'Yes' end,
case 
 when fm.rag in ('HO','SP') and fm.feature_type='L' then 'Liability'
 when dc.loss_cause in ('Fire','FIRE','Smoke') then 'Fire'
 when dc.loss_cause in ('Water','Water Backup','Water Damage','WATER DAMAGE','Water Discharge') then 'Water'
 when dc.loss_cause in ('Flood','Freezing','Hail','Landslide','Lightning','Weight of Ice Snow Sleet','Wind and Hail','Windstorm','Windstorm and Hail') then 'Weather'
 when dc.loss_cause is null and fm.feature_type='L' then 'Liability'
 when dc.loss_cause is null and fm.feature_type='P'  then 'Other'
 else 'Other'
end,
dc.loss_cause,
dp.product,
case when fm.aslob in ('051','052') then 'CM' else  fm.rag end,
fm.feature_type,
fm.feature_map;

/*update catastrophe and perilgroup in all previous month to the latest available*/


update reporting.ppd_claim_summaries
set cat_flg=case when data.catastrophe_id is null then 'No' else 'Yes' end 
,perilgroup=case 
 when s.rag in ('HO','SP') and s.feature_type='L' then 'Liability'
 when data.loss_cause in ('Fire','FIRE','Smoke') then 'Fire'
 when data.loss_cause in ('Water','Water Backup','Water Damage','WATER DAMAGE','Water Discharge') then 'Water'
 when data.loss_cause in ('Flood','Freezing','Hail','Landslide','Lightning','Weight of Ice Snow Sleet','Wind and Hail','Windstorm','Windstorm and Hail') then 'Weather'
 when data.loss_cause is null and s.feature_type='L' then 'Liability'
 when data.loss_cause is null and s.feature_type='P'  then 'Other'
 else 'Other'
end
,policy_state = data.policy_state
,company = data.company
,carrier = data.carrier 
from reporting.ppd_claim_summaries s
join tmp_dc data
on s.claim_number=data.claim_number;



END LOOP;
END;

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_claims(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
						
BEGIN					
/*incremental load is too complex. full takes 1 min*/					
truncate table reporting.ppd_claims;					
insert into reporting.ppd_claims					
with 					
data_feature as (					
select					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
claimant,					
rag,					
feature_type,					
feature_map,					
total_incurred_loss feat_total_incurred_loss,					
sum(total_incurred_loss) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_total_incurred_loss,					
total_reserve feat_total_reserve,					
sum(total_reserve)       over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_total_reserve,					
case when feat_cumulative_total_incurred_loss >= 0.5 then 1 else 0 end as feat_reported_count,					
case when feat_cumulative_total_incurred_loss >= 0.5 and feat_cumulative_total_reserve < 0.5 then 1 else 0 end as feat_closed_count,					
greatest(feat_reported_count - feat_closed_count,0) as feat_open_count,					
case when feat_cumulative_total_incurred_loss > 100000 then 1 else 0 end as feat_reported_count_100k,					
loss_incurred feat_loss_incurred,					
sum(loss_incurred) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_loss_incurred,					
alae_incurred feat_alae_incurred,					
sum(alae_incurred) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_alae_incurred,					
salsub_received feat_salsub_received,					
sum(salsub_received) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_salsub_received					
from reporting.ppd_claim_summaries					
)					
,data_claim1 as (					
select					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
rag,					
feature_type,					
sum(total_incurred_loss)total_incurred_loss,					
sum(total_reserve) total_reserve,					
sum(loss_incurred) loss_incurred,					
sum(alae_incurred) alae_incurred,					
sum(alae_paid) alae_paid,					
sum(salsub_incurred) salsub_incurred,					
sum(salsub_received) salsub_received					
from reporting.ppd_claim_summaries					
group by 					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
rag,					
feature_type					
)					
,data_claim as (					
select					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
rag,					
feature_type,					
total_incurred_loss clm_total_incurred_loss,					
sum(total_incurred_loss) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_total_incurred_loss,					
loss_incurred clm_loss_incurred,					
sum(loss_incurred) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_loss_incurred,					
alae_incurred clm_alae_incurred,					
sum(alae_incurred) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_alae_incurred,					
salsub_received clm_salsub_received,					
sum(salsub_received) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_salsub_received					
from data_claim1					
)					
select 					
dc.month_id,					
dc.policy_state,					
dc.carrier,					
dc.company,					
dc.policyneworrenewal,					
dc.product,					
dc.cat_flg,					
dc.perilgroup,					
dc.claim_number,					
df.claimant,					
df.rag,					
df.feature_type,					
df.feature_map,					
/*===============Claim level==============*/					
/*-----------------------------*/					
dc.clm_total_incurred_loss,					
dc.clm_cumulative_total_incurred_loss,					
/*-----------------------------*/					
dc.clm_loss_incurred,					
dc.clm_cumulative_loss_incurred,					
/*-----------------------------*/					
dc.clm_alae_incurred,					
dc.clm_cumulative_alae_incurred,					
/*-----------------------------*/					
dc.clm_salsub_received,					
dc.clm_cumulative_salsub_received,					
/*-----------------------------*/					
/*===============Feature Map level==============*/					
/*-----------------------------*/					
df.feat_total_incurred_loss ,					
df.feat_cumulative_total_incurred_loss ,					
/*-------------needed to test counts only------*/					
df.feat_total_reserve,					
df.feat_cumulative_total_reserve,					
/*-----------------------------*/					
df.feat_reported_count ,					
df.feat_closed_count ,					
df.feat_open_count ,					
df.feat_reported_count_100k ,					
/*-----------------------------*/					
df.feat_loss_incurred ,					
df.feat_cumulative_loss_incurred,					
/*-----------------------------*/					
df.feat_alae_incurred ,					
df.feat_cumulative_alae_incurred,					
/*-----------------------------*/					
df.feat_salsub_received,					
df.feat_cumulative_salsub_received ,					
/*---------Capped----------*/					
/*---------100k----------*/					
least(clm_cumulative_total_incurred_loss, 100000) clm_capped_cumulative_total_incurred_100k,					
case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else cast(feat_cumulative_total_incurred_loss as float)/cast(clm_cumulative_total_incurred_loss as float) end ratio,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  ratio*clm_capped_cumulative_total_incurred_100k					
 else					
  feat_cumulative_total_incurred_loss					
end feat_capped_cumulative_total_incurred_100k,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else feat_capped_cumulative_total_incurred_100k*(cast(clm_cumulative_loss_incurred as float)/cast(clm_cumulative_total_incurred_loss as float)) end					
 else					
  feat_cumulative_loss_incurred					
end feat_capped_cumulative_loss_incurred_100k,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else feat_capped_cumulative_total_incurred_100k*(cast(clm_cumulative_alae_incurred as float)/cast(clm_cumulative_total_incurred_loss as float)) end					
 else					
  feat_cumulative_alae_incurred					
end feat_capped_cumulative_alae_incurred_100k,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else feat_capped_cumulative_total_incurred_100k*(cast(clm_cumulative_salsub_received as float)/cast(clm_cumulative_total_incurred_loss as float)) end					
 else					
  feat_cumulative_salsub_received					
end feat_capped_cumulative_salsub_received_100k					
/*-----------------------------*/					
,pLoadDate LoadDate					
/*-----------------------------*/					
from data_claim dc					
join data_feature df					
on dc.claim_number=df.claim_number					
and dc.rag = df.rag					
and dc.feature_type=df.feature_type					
and dc.month_id=df.month_id					
and dc.policy_state=df.policy_state					
and dc.carrier=df.carrier					
and dc.company=df.company					
and dc.policyneworrenewal=df.policyneworrenewal					
order by dc.claim_number, dc.month_id;					
					
					
					
END;					

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_losses(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
BEGIN
/*incremental load is too complex. full takes less then 1 min*/
truncate table reporting.ppd_losses;
insert into reporting.ppd_losses
with 
/*---First Level of Aggregation at the level of feature---*/
data as (select 
Product,
month_id,
-- policy_state,
case when policy_state='WA' then 'CA' else policy_state end policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
rag,
feature_type,
feature_map,
sum(feat_total_incurred_loss) total_incurred,
sum(feat_reported_count) reported_count,
sum(feat_open_count) open_count,
sum(feat_reported_count_100k) reported_count_100k,
sum(feat_capped_cumulative_loss_incurred_100k) + sum(feat_capped_cumulative_alae_incurred_100k) - sum(feat_capped_cumulative_salsub_received_100k)  total_incurred_100k
from 
reporting.ppd_claims
where claim_number<>'00533729' /*excluding legacy claims*/
group by Product,
month_id,
case when policy_state='WA' then 'CA' else policy_state end,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
rag,
feature_type,
feature_map
)
/*---Second Level - analytical function ---*/
,data2 as (
select
Product,
month_id,
policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
rag,
feature_type,
feature_map,
isnull(total_incurred,0) total_incurred,
isnull(total_incurred_100k,0) - isnull(lag(total_incurred_100k) over(partition by policy_state, carrier, policyneworrenewal, company, Product,rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) total_incurred_100k,
isnull(reported_count,0) - isnull(lag(reported_count)           over(partition by policy_state, carrier, policyneworrenewal, company, Product,rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) reported_count,
isnull(open_count,0) open_count,
isnull(reported_count_100k,0) - isnull(lag(reported_count_100k) over(partition by policy_state, carrier, policyneworrenewal, company, Product,rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) reported_count_100k,
isnull(reported_count,0) reported_count_month,
isnull(reported_count_100k,0) reported_count_100k_month,
isnull(total_incurred_100k,0) total_incurred_100k_month
from data
)
, mapping as 
 (select 
  distinct 
  product, 
  subproduct, 
  feature_map, 
  feature_type, 
  rag 
  from reporting.vppd_loss_product_mapping
  ) 
/*--------FINAL for each LOB and some features for Auto------------*/
,product_data as 
(
select
m.Product,
m.SubProduct,
month_id,
policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
sum(total_incurred) total_incurred,
sum(total_incurred_100k_month) total_incurred_100k_month,
sum(total_incurred_100k) total_incurred_capped_100k,
sum(reported_count_month) reported_count_month,
sum(reported_count) reported_count,
sum(open_count) open_count,
sum(reported_count_100k) reported_count_100k,
sum(reported_count_100k_month) reported_count_100k_month
from data2
join mapping m
on data2.feature_map=m.feature_map
and data2.feature_type=m.feature_type
and data2.rag=m.rag
group by
m.Product,
m.SubProduct,
month_id,
policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup
)
select *
,pLoadDate LoadDate
from product_data;

END;

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_policies_summaries(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
		
	
DECLARE 	
months RECORD;	
BEGIN	
FOR months IN 	
 select distinct 	
 month_id 	
 from fsbi_stg_spinn.fact_policy	
 order by month_id	
LOOP	
delete from reporting.ppd_policies_summaries	
where month_id=months.month_id;	
	
insert into reporting.ppd_policies_summaries	
with 	
/*-----EXPOSURES------*/	
/*----1.Not Auto PD---*/	
data_other as (	
select	
p.prdt_lob as product,	
f.month_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
sum(case
 when c.cov_code in ('F.30005B','F.31580A') then round(ee_rm/12,3) /*Umbrella*/
 when pe.AltSubTypeCd='PB' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*Boatowners - boats - CovA and Trailers covC*/
 when pe.AltSubTypeCd='EQ' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*In Earthquake policies if there are both CovA and CovC, then CovC do not have exposures*/
 when pe.AltSubTypeCd = 'DF3' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode<>'WF-DWELL') then round(ee_rm/12,3) 
 when pe.AltSubTypeCd = 'HO3-Homeguard' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode='EXWF-DWELL') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('DF6','DF1', 'FL1-Basic', 'FL1-Vacant', 'FL2-Broad', 'FL3-Special', 'Form3', 'HO3') and (c.cov_subline in ('410','402') and ce.covx_code='CovA') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('HO4', 'HO6') and ce.covx_code='CovC' then round(ee_rm/12,3)
 when ce.covx_code = 'BI' then round(ee_rm/12,3)
else 0
end) EE	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension ce	
on c.coverage_id=ce.coverage_id	
join fsbi_dw_spinn.dim_product p	
on p.product_id=f.product_id	
join fsbi_dw_spinn.dim_policyextension pe	
on f.policy_id=pe.policy_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where f.month_id>=201201	
and ce.covx_code not in ( 'COLL', 'COMP')	
and f.month_id=months.month_id	
group by 	
p.prdt_lob,	
f.month_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal	
having  sum(case
 when c.cov_code in ('F.30005B','F.31580A') then round(ee_rm/12,3) /*Umbrella*/
 when pe.AltSubTypeCd='PB' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*Boatowners - boats - CovA and Trailers covC*/
 when pe.AltSubTypeCd='EQ' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*In Earthquake policies if there are both CovA and CovC, then CovC do not have exposures*/
 when pe.AltSubTypeCd = 'DF3' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode<>'WF-DWELL') then round(ee_rm/12,3) 
 when pe.AltSubTypeCd = 'HO3-Homeguard' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode='EXWF-DWELL') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('DF6','DF1', 'FL1-Basic', 'FL1-Vacant', 'FL2-Broad', 'FL3-Special', 'Form3', 'HO3') and (c.cov_subline in ('410','402') and ce.covx_code='CovA') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('HO4', 'HO6') and ce.covx_code='CovC' then round(ee_rm/12,3)
 when ce.covx_code = 'BI' then round(ee_rm/12,3)
else 0
end)<>0	
)	
/*--------Auto PD which is COMP or COLL------*/	
,data_coll as (	
select	
f.month_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
f.policy_id,	
v.vehidentificationnumber vin,	
v.vehnumber RiskCd,	
sum(round(ee_rm/12,3)) EE	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension cx	
on c.coverage_id=cx.coverage_id	
join fsbi_dw_spinn.dim_vehicle v	
on f.vehicle_id=v.vehicle_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where cx.covx_code = 'COLL'	
and f.month_id=months.month_id	
group by 	
f.month_id,	
f.policy_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal,	
v.vehidentificationnumber,	
v.vehnumber	
having  sum(round(ee_rm/12,3))<>0	
)	
,data_comp as (	
select	
f.month_id,	
f.policy_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
v.vehidentificationnumber vin,	
v.vehnumber RiskCd,	
sum(round(ee_rm/12,3)) EE	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension cx	
on c.coverage_id=cx.coverage_id	
join fsbi_dw_spinn.dim_vehicle v	
on f.vehicle_id=v.vehicle_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where  cx.covx_code = 'COMP'	
and f.month_id=months.month_id	
group by 	
f.month_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal,	
f.policy_id,	
v.vehidentificationnumber,	
v.vehnumber	
having  sum(round(ee_rm/12,3))<>0	
)	
,data_pd as (select	
coalesce(data_comp.month_id, data_coll.month_id) month_id,	
coalesce(data_comp.policy_state, data_coll.policy_state) policy_state,	
coalesce(data_comp.carrier, data_coll.carrier) carrier,	
coalesce(data_comp.company, data_coll.company) company,	
coalesce(data_comp.policyneworrenewal, data_coll.policyneworrenewal) policyneworrenewal,	
sum(case when data_comp.EE is null then isnull(data_coll.EE,0) else isnull(data_comp.EE,0) end) EE	
from data_comp	
full outer join data_coll	
on data_comp.month_id=data_coll.month_id	
and data_comp.policy_id=data_coll.policy_id	
and data_comp.vin=data_coll.vin	
and data_comp.riskcd=data_coll.riskcd	
group by 	
coalesce(data_comp.month_id, data_coll.month_id),	
coalesce(data_comp.policy_state, data_coll.policy_state),	
coalesce(data_comp.carrier, data_coll.carrier),	
coalesce(data_comp.company, data_coll.company),	
coalesce(data_comp.policyneworrenewal, data_coll.policyneworrenewal)	
) 	
/*-------- Earned Premium and PIF-------------*/	
,data as (	
select	
p.prdt_lob as product,	
f.month_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
pe.policyformcode,	
left(cx.coveragetype,1) as coverage_type,	
cx.act_rag  as rag,	
cx.covx_code as coverage,	
isnull(cx.act_map,'~') as coverage_map,	
sum(earned_prem_amt)   EP,	
case when s.polst_statuscd = 'INF' and sum(f.term_prem_amt_itd)>0 then po.pol_policynumber else null end PIF	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension cx	
on c.coverage_id=cx.coverage_id	
join fsbi_dw_spinn.dim_product p	
on f.product_id = p.product_id	
join fsbi_dw_spinn.vdim_policystatus s	
on f.policystatus_id = s.policystatus_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.dim_policyextension pe	
on f.policy_id=pe.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where  cx.covx_code not like '%Fee%'	
and f.month_id=months.month_id	
group by p.prdt_lob,	
pe.policyformcode,	
left(cx.coveragetype,1),	
cx.act_rag,	
cx.covx_code,	
cx.act_map,	
f.month_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal,	
s.polst_statuscd,	
po.pol_policynumber	
having  (sum(earned_prem_amt)<>0 or sum(case when cx.covx_code='BI' then round(ee_rm/12,3) else 0 end)<>0)	
)	
, mapping as 	
 (select 	
  distinct 	
  prdt_lob,	
  isnull(product,'~') product, 	
  subproduct, 	
  coverage_map, 	
  coverage_type, 	
  rag 	
  from reporting.vppd_premium_product_mapping	
  where isnull(product,'~')<>'All Products'	
  ) 	
/*------------------FINAL-------------------*/	
,product_data as 	
(	
select	
isnull(m.product,'~') product,	
isnull(m.subproduct,'~') subproduct,	
data.month_id,	
data.policy_state,	
data.carrier,	
data.company,	
data.policyneworrenewal,	
sum(EP)   EP,	
max(case when isnull(m.product,'~')='~' then 0 when data.rag<>'APD' then data_other.EE else data_pd.EE end) EE,	
count(distinct PIF) PIF	
from data	
left outer join data_other	
on isnull(data.product,'~')=isnull(data_other.product,'~')	
and data.month_id=data_other.month_id	
and data.policyneworrenewal=data_other.policyneworrenewal	
and data.policy_state=data_other.policy_state	
and data.company=data_other.company	
and data.carrier=data_other.carrier	
left outer join data_pd	
on data.month_id=data_pd.month_id	
and data.policyneworrenewal=data_pd.policyneworrenewal	
and data.policy_state=data_pd.policy_state	
and data.company=data_pd.company	
and data.carrier=data_pd.carrier	
join mapping m	
on data.coverage_map=m.coverage_map	
and data.coverage_type=m.coverage_type	
and data.rag=m.rag	
and data.product=m.prdt_lob	
group by	
m.product,	
m.subproduct,	
data.month_id,	
data.policy_state,	
data.carrier,	
data.company,	
data.policyneworrenewal	
)	
select *	
,pLoadDate LoadDate	
from (	
select *	
from product_data	
union all	
select	
'All Products' product,	
'All' subproduct,	
month_id,	
policy_state,	
carrier,	
company,	
policyneworrenewal,	
sum(EP)   EP,	
sum(EE) EE,	
sum(PIF) PIF	
from product_data	
where subproduct='All'	
group by	
month_id,	
policy_state,	
carrier,	
company,	
policyneworrenewal	
) d;	
	
	
	
	
	
END LOOP;	
END;	
	

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_policies_summaries(ploaddate date)
	LANGUAGE plpgsql
AS $$
	
DECLARE 
months RECORD;
BEGIN
FOR months IN 
 select distinct 
 month_id 
 from fsbi_stg_spinn.fact_policy
 order by month_id
LOOP
delete from reporting.ppd_policies_summaries
where month_id=months.month_id;

insert into reporting.ppd_policies_summaries
with 
/*-----EXPOSURES------*/
/*----1.Not Auto PD---*/
data_other as (
select
p.prdt_lob as product,
f.month_id,
po.pol_masterstate policy_state,
co.comp_name1 carrier,
co.comp_number  company,
f.policyneworrenewal,
sum(round(ee_rm/12,3)) EE
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_coverage c
on f.coverage_id=c.coverage_id
join public.dim_coverageextension cx
on c.coverage_id=cx.coverage_id
join fsbi_dw_spinn.dim_product p
on p.product_id=f.product_id
join fsbi_dw_spinn.dim_policyextension pe
on f.policy_id=pe.policy_id
join fsbi_dw_spinn.dim_policy po
on po.policy_id=f.policy_id
join fsbi_dw_spinn.vdim_company co
on f.company_id=co.company_id
where f.month_id>=201201 and
(cx.covx_code in ('CUMBR','BLDG') or 
 (c.cov_subline in ('410','402') and cx.covx_code='CovA') or 
 (pe.policyformcode in ('HO4','HO6') and cx.covx_code='CovC') or
  cx.covx_code = 'BI'
)
and f.month_id=months.month_id
group by 
p.prdt_lob,
f.month_id,
po.pol_masterstate,
co.comp_name1,
co.comp_number,
f.policyneworrenewal
having  sum(round(ee_rm/12,3))<>0
)
/*--------Auto PD which is COMP or COLL------*/
,data_coll as (
select
f.month_id,
po.pol_masterstate policy_state,
co.comp_name1 carrier,
co.comp_number  company,
f.policyneworrenewal,
f.policy_id,
v.vehidentificationnumber vin,
v.vehnumber RiskCd,
sum(round(ee_rm/12,3)) EE
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_coverage c
on f.coverage_id=c.coverage_id
join public.dim_coverageextension cx
on c.coverage_id=cx.coverage_id
join fsbi_dw_spinn.dim_vehicle v
on f.vehicle_id=v.vehicle_id
join fsbi_dw_spinn.dim_policy po
on po.policy_id=f.policy_id
join fsbi_dw_spinn.vdim_company co
on f.company_id=co.company_id
where cx.covx_code = 'COLL'
and f.month_id=months.month_id
group by 
f.month_id,
f.policy_id,
po.pol_masterstate,
co.comp_name1,
co.comp_number,
f.policyneworrenewal,
v.vehidentificationnumber,
v.vehnumber
having  sum(round(ee_rm/12,3))<>0
)
,data_comp as (
select
f.month_id,
f.policy_id,
po.pol_masterstate policy_state,
co.comp_name1 carrier,
co.comp_number  company,
f.policyneworrenewal,
v.vehidentificationnumber vin,
v.vehnumber RiskCd,
sum(round(ee_rm/12,3)) EE
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_coverage c
on f.coverage_id=c.coverage_id
join public.dim_coverageextension cx
on c.coverage_id=cx.coverage_id
join fsbi_dw_spinn.dim_vehicle v
on f.vehicle_id=v.vehicle_id
join fsbi_dw_spinn.dim_policy po
on po.policy_id=f.policy_id
join fsbi_dw_spinn.vdim_company co
on f.company_id=co.company_id
where  cx.covx_code = 'COMP'
and f.month_id=months.month_id
group by 
f.month_id,
po.pol_masterstate,
co.comp_name1,
co.comp_number,
f.policyneworrenewal,
f.policy_id,
v.vehidentificationnumber,
v.vehnumber
having  sum(round(ee_rm/12,3))<>0
)
,data_pd as (select
coalesce(data_comp.month_id, data_coll.month_id) month_id,
coalesce(data_comp.policy_state, data_coll.policy_state) policy_state,
coalesce(data_comp.carrier, data_coll.carrier) carrier,
coalesce(data_comp.company, data_coll.company) company,
coalesce(data_comp.policyneworrenewal, data_coll.policyneworrenewal) policyneworrenewal,
sum(case when data_comp.EE is null then isnull(data_coll.EE,0) else isnull(data_comp.EE,0) end) EE
from data_comp
full outer join data_coll
on data_comp.month_id=data_coll.month_id
and data_comp.policy_id=data_coll.policy_id
and data_comp.vin=data_coll.vin
and data_comp.riskcd=data_coll.riskcd
group by 
coalesce(data_comp.month_id, data_coll.month_id),
coalesce(data_comp.policy_state, data_coll.policy_state),
coalesce(data_comp.carrier, data_coll.carrier),
coalesce(data_comp.company, data_coll.company),
coalesce(data_comp.policyneworrenewal, data_coll.policyneworrenewal)
) 
/*-------- Earned Premium and PIF-------------*/
,data as (
select
p.prdt_lob as product,
f.month_id,
po.pol_masterstate policy_state,
co.comp_name1 carrier,
co.comp_number  company,
f.policyneworrenewal,
pe.policyformcode,
left(cx.coveragetype,1) as coverage_type,
cx.act_rag  as rag,
cx.covx_code as coverage,
isnull(cx.act_map,'~') as coverage_map,
sum(earned_prem_amt)   EP,
case when s.polst_statuscd = 'INF' and sum(f.term_prem_amt_itd)>0 then po.pol_policynumber else null end PIF
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_coverage c
on f.coverage_id=c.coverage_id
join public.dim_coverageextension cx
on c.coverage_id=cx.coverage_id
join fsbi_dw_spinn.dim_product p
on f.product_id = p.product_id
join fsbi_dw_spinn.vdim_policystatus s
on f.policystatus_id = s.policystatus_id
join fsbi_dw_spinn.dim_policy po
on po.policy_id=f.policy_id
join fsbi_dw_spinn.dim_policyextension pe
on f.policy_id=pe.policy_id
join fsbi_dw_spinn.vdim_company co
on f.company_id=co.company_id
where  cx.covx_code not like '%Fee%'
and f.month_id=months.month_id
group by p.prdt_lob,
pe.policyformcode,
left(cx.coveragetype,1),
cx.act_rag,
cx.covx_code,
cx.act_map,
f.month_id,
po.pol_masterstate,
co.comp_name1,
co.comp_number,
f.policyneworrenewal,
s.polst_statuscd,
po.pol_policynumber
having  (sum(earned_prem_amt)<>0 or sum(case when cx.covx_code='BI' then round(ee_rm/12,3) else 0 end)<>0)
)
, mapping as 
 (select 
  distinct 
  prdt_lob,
  isnull(product,'~') product, 
  subproduct, 
  coverage_map, 
  coverage_type, 
  rag 
  from reporting.vppd_premium_product_mapping
  where isnull(product,'~')<>'All Products'
  ) 
/*------------------FINAL-------------------*/
,product_data as 
(
select
isnull(m.product,'~') product,
isnull(m.subproduct,'~') subproduct,
data.month_id,
data.policy_state,
data.carrier,
data.company,
data.policyneworrenewal,
sum(EP)   EP,
max(case when isnull(m.product,'~')='~' then 0 when data.rag<>'APD' then data_other.EE else data_pd.EE end) EE,
count(distinct PIF) PIF
from data
left outer join data_other
on isnull(data.product,'~')=isnull(data_other.product,'~')
and data.month_id=data_other.month_id
and data.policyneworrenewal=data_other.policyneworrenewal
and data.policy_state=data_other.policy_state
and data.company=data_other.company
and data.carrier=data_other.carrier
left outer join data_pd
on data.month_id=data_pd.month_id
and data.policyneworrenewal=data_pd.policyneworrenewal
and data.policy_state=data_pd.policy_state
and data.company=data_pd.company
and data.carrier=data_pd.carrier
join mapping m
on data.coverage_map=m.coverage_map
and data.coverage_type=m.coverage_type
and data.rag=m.rag
and data.product=m.prdt_lob
group by
m.product,
m.subproduct,
data.month_id,
data.policy_state,
data.carrier,
data.company,
data.policyneworrenewal
)
select *
,GetDate() LoadDate
from (
select *
from product_data
union all
select
'All Products' product,
'All' subproduct,
month_id,
policy_state,
carrier,
company,
policyneworrenewal,
sum(EP)   EP,
sum(EE) EE,
sum(PIF) PIF
from product_data
where subproduct='All'
group by
month_id,
policy_state,
carrier,
company,
policyneworrenewal
) d;





END LOOP;
END;

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_stg_auto_modeldata(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
				
			
BEGIN 			
			
			
			
			
/*			
Author: Kate Drogaieva			
Purpose: This script populate STG_AUTO_MODELDATA (staging table for FACT_AUTO_MODELDATA)			
Comment: Due to back dated transactions it was made as a full refresh.			
03/02/2023 - Back to redshift			
12/13/2019 - Using stg_policy_changes_v2 instead of stg_policy_changes			
11/13/2019 - LossDate was added in  v_auto_ClaimsForModel_Base. Slight adjustment of the select for claims			
10/25/2019 - Adjusting to the new structure v_stg_auto_modeldata_coverage new structure 			
03/24/2020 - Commented PrivatePassengerAuto condition to load all risk types			
*/			
			
			
/*			
1. LibilityOnly Risks - policies without Collision and Comprehencive coverages			
at each mid-term change			
*/			
			
			
			
drop table if exists LiabilityOnlyRisks;			
create temporary table  LiabilityOnlyRisks as			
select			
*			
from (			
select			
distinct 			
 f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata in ('COLL',  'COMP',  'BI', 'UM', 'PD', 'Med')			
except			
 --auto policies with Comp and Collision			
select			
distinct f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata in ('COLL', 'COMP')			
) d ;			
			
/*			
2. CompOnly Risks - policies with only Collision and Comprehencive coverages			
at each mid-term change			
*/			
			
			
drop table if exists CompOnlyRisks;			
create temporary table  CompOnlyRisks as			
select			
*			
from (			
select			
distinct f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata in ('COLL',  'COMP') 			
except			
select			
distinct f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata not in ('COLL', 'COMP')			
) d ;			
			
/*			
3. Driver Counts at each mid-term change			
*/			
			
			
drop table if exists CntDrv;			
create temporary table  CntDrv as			
select 			
cast(stg.PolicyRef	as varchar) Policy_Uniqueid,		
stg.SystemId,			
stg.ChangeDate,			
count(distinct case when stg.status='Active' then  stg.driver_uniqueid else null end) CntDrv,			
count(distinct case when stg.status='Active' and upper(stg.LicenseNumber) NOT like '%EXCLUDED%' and stg.DriverTypeCd in ('NonOperator', 'Excluded', 'UnderAged') then  stg.driver_uniqueid else null end) CntNonDrv,			
count(distinct case when stg.status='Active' and upper(stg.LicenseNumber) like '%EXCLUDED%'  then stg.driver_uniqueid else null end) CntExcludedDrv,			
min(case when stg.status='Active' then case when  DateDiff(year, stg.birthdt,p.pol_EffectiveDate)<=0 or stg.birthdt<='1900-01-01' then null else DateDiff(year, stg.birthdt,p.pol_EffectiveDate)  end else null end)   minDriverAge			
from fsbi_stg_spinn.vstg_auto_modeldata_drivers stg			
join fsbi_dw_spinn.dim_policy p			
on p.pol_uniqueid=cast(stg.PolicyRef	as varchar)		
group by 			
stg.PolicyRef,			
stg.SystemId,			
stg.ChangeDate	;		
			
			
			
/*			
4. Combined Limits, Deductible and FullTermAmount for each coverage of interst  at each mid-term change			
*/			
			
			
			
drop table if exists d;			
create temporary table  d as			
select  			
d.SystemId, 			
d.policy_uniqueid, 			
d.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(d.act_modeldata))+'='+ltrim(rtrim(d.Deductible1)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(d.act_modeldata))))  Combined_Deductible			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage d			
where 	d.Deductible1 is not null		
group by d.SystemId, d.policy_uniqueid, d.risk_uniqueid;			
			
			
			
drop table if exists l1;			
create temporary table  l1 as			
select   			
l.SystemId, 			
l.policy_uniqueid, 			
l.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(l.act_modeldata))+'='+ltrim(rtrim(l.Limit1)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(l.act_modeldata))))  Combined_Limit1			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage l			
where 	l.Limit1 is not null		
group by l.SystemId, l.policy_uniqueid, l.risk_uniqueid; 			
			
			
			
drop table if exists l2;			
create temporary table  l2 as			
select   			
l.SystemId, 			
l.policy_uniqueid, 			
l.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(l.act_modeldata))+'='+ltrim(rtrim(l.Limit2)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(l.act_modeldata))))  Combined_Limit2			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage l			
where 	l.Limit2 is not null		
group by l.SystemId, l.policy_uniqueid, l.risk_uniqueid; 			
			
			
			
			
drop table if exists f;			
create temporary table  f as			
select   			
c.SystemId, 			
c.policy_uniqueid, 			
c.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(c.act_modeldata))+'='+ltrim(rtrim(c.FullTermAmt)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(c.act_modeldata))))  Combined_FullTermAmt			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage c			
group by c.SystemId, c.policy_uniqueid, c.risk_uniqueid; 			
			
			
			
			
			
/*			
5. (1)Active (not obsolete, joined to discarded items with record_version=-1) Risks 			
related to  New Business, Renewal or  Endorsement transactions (2).			
(3) If there are more then one change in the same day, we use the last change at this day			
(1)It's possible when a transaction with newest BookDt has an older effective date 			
then effective transactions already in the system.			
*/			
			
			
			
drop table if exists coveredrisk;			
create temporary table  coveredrisk as			
with cleaned_risks as (			
select 			
policy_uniqueid,			
cast(cvrsk_startdate as date) cvrsk_startdate,			
max(cvrsk_startdate) last_cvrsk_startdate_per_day			
from (			
select 			
cr.policy_uniqueid,			
cvrsk_startdate,			
spinn_systemid			
from fsbi_dw_spinn.dim_coveredrisk cr			
join fsbi_stg_spinn.vstg_modeldata_policyhistory f			
on f.SystemId=cr.spinn_systemid			
and f.PolicyRef=cr.policy_uniqueid			
where cvrsk_item_type='VEHICLE'			
-- and cvrsk_typedescription='PrivatePassengerAuto'			
 --and dim_vehicle.record_version>-1 need more details how exclude not active transactions			
and f.TransactionCd in ('New Business','Renewal','Endorsement')			
) data			
group by 			
policy_uniqueid,			
cast(cvrsk_startdate as date)			
)			
select 			
cr.*			
from fsbi_dw_spinn.dim_coveredrisk cr			
join cleaned_risks 			
on cr.policy_uniqueid=cleaned_risks.policy_uniqueid			
and cr.cvrsk_startdate=cleaned_risks.last_cvrsk_startdate_per_day			
;			
			
			
			
			
			
			
/*6. There is no "Final" record in dim_coveredrisk			
with systemid=policy_uniqueid			
We need it to close the last entry in mid-term changes*/			
			
			
drop table if exists extend_dim_coveredrisk;			
create temporary table  extend_dim_coveredrisk as			
select *			
from			
(			
select 			
 coveredrisk_id			
,cvrsk_uniqueid			
,policy_uniqueid			
,policy_id			
,deleted_indicator			
,cvrsk_typedescription			
,cvrsk_item_id			
,cvrsk_item_uniqueid			
,cvrsk_item_type			
,cvrsk_item_id2			
,cvrsk_item_uniqueid2			
,cvrsk_item_type2			
,cvrsk_startdate			
,cvrsk_number			
,cvrsk_number2			
,cvrsk_item_naturalkey			
,cvrsk_item_naturalkey2			
,cvrsk_inceptiondate			
,cvrsk_inceptiondate2			
,policy_last_known_cvrsk_item_id			
,policy_last_known_cvrsk_item_id2			
,policy_term_last_known_cvrsk_item_id			
,policy_term_last_known_cvrsk_item_id2			
,spinn_systemid original_spinn_systemid			
,spinn_systemid			
,PolAppInconsistency_Flg			
,RiskIdDuplicates_Flg			
,RiskNumberDuplicates_Flg			
,RiskNaturalKeyDuplicates_Flg			
,RiskNaturalKey2Duplicates_Flg			
,ExcludedDrv_Flg			
,source_system			
,LoadDate			
from coveredrisk			
where policy_uniqueid<>'Unknown'			
union all			
select 			
 coveredrisk_id			
,dc.cvrsk_uniqueid			
,dc.policy_uniqueid			
,policy_id			
,deleted_indicator			
,cvrsk_typedescription			
,cvrsk_item_id			
,cvrsk_item_uniqueid			
,cvrsk_item_type			
,cvrsk_item_id2			
,cvrsk_item_uniqueid2			
,cvrsk_item_type2			
,cvrsk_startdate			
,cvrsk_number			
,cvrsk_number2			
,cvrsk_item_naturalkey			
,cvrsk_item_naturalkey2			
,cvrsk_inceptiondate			
,cvrsk_inceptiondate2			
,policy_last_known_cvrsk_item_id			
,policy_last_known_cvrsk_item_id2			
,policy_term_last_known_cvrsk_item_id			
,policy_term_last_known_cvrsk_item_id2			
,spinn_systemid original_spinn_systemid			
,cast(dc.policy_uniqueid as int) spinn_systemid			
,PolAppInconsistency_Flg			
,RiskIdDuplicates_Flg			
,RiskNumberDuplicates_Flg			
,RiskNaturalKeyDuplicates_Flg			
,RiskNaturalKey2Duplicates_Flg			
,ExcludedDrv_Flg			
,source_system			
,LoadDate			
from coveredrisk dc			
join (			
select policy_uniqueid,  max(dc.spinn_systemid) id			
from coveredrisk dc			
where dc.policy_uniqueid<>'Unknown'			
group by policy_uniqueid			
) last_system			
on dc.spinn_systemId=last_system.id			
and dc.policy_uniqueid=last_system.policy_uniqueid			
where dc.policy_uniqueid<>'Unknown'			
) d;			
			
drop table if exists coveredrisk;			
			
/*select *			
from #extend_dim_coveredrisk			
where policy_uniqueid='903653'			
and cvrsk_uniqueid='Risk-1492337505-1254933222'			
order by cvrsk_startdate			
*/			
			
/*			
7. Main staging data select #tmp_PolicyRiskHistory			
based on stg_policyhistory plus all related info			
*/			
			
			
drop table if exists tmp_PolicyRiskHistory;			
create temporary table  tmp_PolicyRiskHistory as			
select distinct 			
  stg.SystemId			
, dc.original_spinn_systemid			
, dc.policy_id  			
, dc.policy_uniqueid			
, pg.Producer_Uniqueid			
, dc.coveredrisk_id	risk_id		
, dc.cvrsk_typedescription			
, dc.cvrsk_uniqueid risk_uniqueid			
, dc.cvrsk_item_id vehicle_id			
, v.SPInnVehicle_Id vehicle_uniqueid			
, dc.cvrsk_item_naturalkey  vin			
, dc.cvrsk_number RiskCd			
, dc.cvrsk_item_id2	driver_id		
, d.spinndriver_parentid driver_uniqueid			
, dc.cvrsk_item_naturalkey2   Driver			
, dc.cvrsk_number2 DriverNumber			
, case when dc.deleted_indicator=1 then 'Deleted' else 'Active' end  status			
, case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt			
  else dc.cvrsk_startdate 			
  end changedate			
, dd.Combined_Deductible			
, l1.Combined_Limit1			
, l2.Combined_Limit2			
, f.Combined_FullTermAmt			
--			
, CntDrv.CntDrv			
, CntDrv.CntNonDrv			
, CntDrv.CntExcludedDrv			
, CntDrv.minDriverAge			
, case when lor.policy_uniqueid is not null then 'Yes' else 'No' end LiabilityOnlyFlg			
, case when cor.policy_uniqueid is not null then 'Yes' else 'No' end CompOnlyFlg			
, stg.TransactionCd			
,row_number() over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid order by   case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt			
  else dc.cvrsk_startdate 			
  end) rn_trn			
,count(*) over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid ) cn_trn			
,cvrsk_inceptiondate VehicleInceptionDate			
,cvrsk_inceptiondate2 DriverInceptionDate			
,case when PolAppInconsistency_Flg='Y' then 'Yes' else 'No' end Quality_PolAppInconsistency_Flg			
,case when RiskIdDuplicates_Flg='Y' then 'Yes' else 'No' end Quality_RiskIdDuplicates_Flg			
,case when ExcludedDrv_Flg='Y' then 'Yes' else 'No' end Quality_ExcludedDrv_Flg			
			
from fsbi_stg_spinn.vstg_modeldata_policyhistory stg			
 --			
join extend_dim_coveredrisk dc			
on  stg.PolicyRef=dc.policy_uniqueid			
and stg.SystemId=dc.spinn_systemid			
and dc.cvrsk_item_type='VEHICLE'			
-- and dc.cvrsk_typedescription='PrivatePassengerAuto'			
 --			
join fsbi_dw_spinn.dim_vehicle v			
on v.vehicle_id=dc.cvrsk_item_id			
 --			
join fsbi_dw_spinn.dim_driver d			
on d.driver_id=dc.cvrsk_item_id2			
 --			
left outer join CntDrv CntDrv			
on stg.SystemId=CntDrv.SystemId			
and stg.PolicyRef=CntDrv.Policy_Uniqueid			
			
 --			
left outer join d dd			
on dd.SystemId=stg.SystemId			
and dd.policy_uniqueid=stg.PolicyRef			
and dd.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join l1	l1		
on l1.SystemId=stg.SystemId			
and l1.policy_uniqueid=stg.PolicyRef			
and l1.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join l2	l2		
on l2.SystemId=stg.SystemId			
and l2.policy_uniqueid=stg.PolicyRef			
and l2.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join f	f		
on f.SystemId=stg.SystemId			
and f.policy_uniqueid=stg.PolicyRef			
and f.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join  LiabilityOnlyRisks lor			
on lor.SystemId=stg.SystemId			
and lor.policy_uniqueid=stg.PolicyRef			
and lor.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join  CompOnlyRisks cor			
on cor.SystemId=stg.SystemId			
and cor.policy_uniqueid=stg.PolicyRef			
and cor.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join fsbi_stg_spinn.vstg_auto_modeldata_producers pg			
on pg.SystemId=stg.Systemid			
and pg.Policy_Uniqueid=stg.PolicyRef			
 --			
where  stg.TransactionCd in ('New Business','Renewal','Endorsement', 'Final')			
and stg.ReplacedByTransactionNumber is null			
and stg.UnAppliedByTransactionNumber is null;			
			
			
drop table if exists extend_dim_coveredrisk;			
drop table if exists CntDrv;			
drop table if exists d;			
drop table if exists l1;			
drop table if exists l2;			
drop table if exists f;			
drop table if exists lor;			
drop table if exists cor;			
			
			
/*			
8. #data1 - #data3 - List of Vehicles  (VINs and Vehicle IDs separately because of replace VINs instead of adding a new Vehicle Id) 			
and Drivers			
Can be one query if it could be possible to calculate with			
an analytical function			
*/			
			
/*-----------------------------------------------------------------------------*/			
			
			
drop table if exists data1;			
create temporary table  data1 as			
select  			
t1.Policy_UniqueId, 			
t1.SystemId,			
checksum(LISTAGG( distinct ltrim(rtrim(t1.vehicle_uniqueid)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(t1.vehicle_uniqueid))))  listvehids			
from tmp_PolicyRiskHistory t1			
group by Policy_UniqueId, SystemId	;		
			
			
drop table if exists data2;			
create temporary table  data2 as			
select  			
t1.Policy_UniqueId, 			
t1.SystemId,			
checksum(LISTAGG( distinct ltrim(rtrim(t1.vin)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(t1.vin))))  listvins			
from tmp_PolicyRiskHistory t1			
group by Policy_UniqueId, SystemId	;		
			
			
drop table if exists data3;			
create temporary table  data3 as			
select  			
t1.Policy_UniqueId, 			
t1.SystemId,			
checksum(LISTAGG( distinct ltrim(rtrim(t1.driver)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(t1.driver))))  listdrivers			
from tmp_PolicyRiskHistory t1			
group by Policy_UniqueId, SystemId	;		
			
			
			
			
			
/*			
9. Total number of vehicles by Policy term			
*/			
			
			
drop table if exists VINById;			
create temporary table  VINById as			
select 			
Policy_Uniqueid,			
vehicle_uniqueid,			
count(distinct vin) cnt			
from tmp_PolicyRiskHistory			
group by Policy_Uniqueid,			
vehicle_uniqueid;			
			
			
			
/*			
10. List of vehicles and Drivers together			
*/			
drop table if exists Veh;			
create temporary table  Veh as			
select			
 data.Policy_Uniqueid, 			
 data.SystemId,			
 data.changedate,			
 data.CntDrv,			
 listvehids,			
 listvins,			
 listdrivers,			
 count(distinct case when Status='Active' then vin else null end) Cnt			
 from tmp_PolicyRiskHistory data			
 join data1 			
 on data.policy_uniqueid=data1.policy_uniqueid			
 and data.SystemId=data1.SystemId			
 join data2 			
 on data.policy_uniqueid=data2.policy_uniqueid			
 and data.SystemId=data2.SystemId			
 join data3 			
 on data.policy_uniqueid=data3.policy_uniqueid			
 and data.SystemId=data3.SystemId			
 group by data.Policy_Uniqueid, 			
 data.SystemId,			
 data.changedate,			
 data.CntDrv,			
 listvehids,			
 listvins,			
 listdrivers;			
			
drop table if exists data1;			
drop table if exists data2;			
drop table if exists data3;			
			
/*11.Calculated Limits, Deductibles, FullTrm amount Changed Flags 			
1 if something important changed  comparing to the next record			
and we need to add one more row in the model dataset			
*/			
			
			
drop table if exists VinFlgs;			
create temporary table  VinFlgs as			
 select 			
  data.Policy_Uniqueid			
, SystemId  			
, vin			
, changedate			
, case when upper(Driver)<>lag(upper(Driver)) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeAssignedDrvFlg			
, case when upper(Status)<>lag(upper(Status)) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeVehStatusFlg			
, case when upper(vin)<>lag(upper(vin)) over (partition by data.Policy_Uniqueid, Vehicle_Uniqueid  order by data.changedate) then 1 else 0 end ChangeVehVINFlg			
, case when Combined_Limit1<>lag(Combined_Limit1) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_Limit1Flg			
, case when Combined_Limit2<>lag(Combined_Limit2) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_Limit2Flg			
, case when Combined_Deductible<>lag(Combined_Deductible) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_DeductibleFlg			
--			
, case when Combined_FullTermAmt<>lag(Combined_FullTermAmt) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_FullTermAmtFlg			
--			
from tmp_PolicyRiskHistory data;			
			
			
			
			
/*			
12. Changes in number drivers or vehicles when we need to generate a new row			
*/			
			
			
			
drop table if exists PolicyRefFlgs;			
create temporary table  PolicyRefFlgs as			
select			
  Policy_Uniqueid			
, Systemid			
, ChangeDate			
, case when Veh.Cnt<>lag(Veh.Cnt) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeVehFlg			
, case when CntDrv<>lag(CntDrv) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end AddDrvFlg			
, case when listvehids<>lag(listvehids) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeVehId2			
, case when upper(listvins)<>lag(upper(listvins)) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeVehFlg2			
, case when upper(listdrivers)<>lag(upper(listdrivers)) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeDrvFlg2			
from Veh;			
			
			
			
/*			
13. Combining all flags into 1 field			
*/			
			
			
drop table if exists OneFlg;			
create temporary table  OneFlg as			
select 			
VinFlgs.Policy_Uniqueid,			
VinFlgs.SystemId,			
VinFlgs.ChangeDate,			
case when sum(ChangeAssignedDrvFlg)+			
sum(ChangeVehStatusFlg) +			
sum(ChangeVehVINFlg) +			
sum(ChangeVehFlg)+			
sum(AddDrvFlg)+			
sum(ChangeVehFlg2)+			
sum(ChangeDrvFlg2)+			
sum(ChangeVehId2)+			
sum(ChangeCombined_Limit1Flg)+			
sum(ChangeCombined_Limit2Flg)+			
sum(ChangeCombined_DeductibleFlg)+			
sum(ChangeCombined_FullTermAmtFlg)>=1 then 1 else 0 end Flg			
from VinFlgs			
join PolicyRefFlgs			
on VinFlgs.Policy_Uniqueid=PolicyRefFlgs.Policy_Uniqueid			
and VinFlgs.SystemId=PolicyRefFlgs.SystemId			
group by VinFlgs.Policy_Uniqueid, VinFlgs.SystemId, VinFlgs.ChangeDate;			
			
drop table if exists VinFlgs;			
drop table if exists PolicyRefFlgs;			
			
/*			
14. Joining Counts and Flags together			
Adjusting Flag to 1 (Change, first or last change) or 0			
*/			
			
			
drop table if exists final_data2;			
create temporary table  final_data2 as			
select 			
  data.* 			
, Veh.Cnt CntVeh			
, case when OneFlg.Flg>0 or data.rn_trn=1 or data.rn_trn=data.cn_trn then 1 else 0 end Flg			
from tmp_PolicyRiskHistory data			
join Veh Veh			
on data.Policy_Uniqueid=Veh.Policy_Uniqueid			
and data.SystemId =Veh.SystemId 			
join  OneFlg			
on data.Policy_Uniqueid=OneFlg.Policy_Uniqueid			
and data.SystemId =OneFlg.SystemId	;		
			
			
			
drop table if exists Veh;			
drop table if exists OneFlg;			
drop table if exists tmp_PolicyRiskHistory;			
/*			
15. Final mid-term changes			
*/ 			
			
			
drop table if exists stg_auto_modeldata_1;			
create temporary table  stg_auto_modeldata_1 as			
with data3 as (			
select 			
  data2.*			
, changedate StartDateTm			
, case 			
   when VINById.Cnt>1 then			
     coalesce(lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid,    vin order by changedate),lead(changedate) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  vin order by changedate) )			
   else	 		
     coalesce(lead(changedate) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate),lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid, vin order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  vin order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate))			
   end EndDateTm			
, case 			
   when VINById.Cnt>1 then			
     coalesce(lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid,    vin order by changedate),lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  vin order by changedate) )			
   else	 		
     coalesce(lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate),lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid, vin order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  vin order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate))			
   end SystemIdEnd			
from final_data2 data2			
join VINById VINById	 		
on data2.Policy_Uniqueid=VINById.Policy_Uniqueid			
and data2.vehicle_uniqueid=VINById.vehicle_uniqueid			
where Flg=1			
)			
select 			
row_number() over(order by SystemId) modeldata_id	,		
data3.*			
from data3			
where status='Active'			
and EndDateTm is not null			
and abs(datediff(day,dateadd(sec, 100, StartDatetm),dateadd(sec, 100, EndDateTm)))>0			
order by Policy_Uniqueid,StartDatetm;			
			
drop table if exists VINById;			
drop table if exists final_data2;			
			
/*-----------------           16           ------------------------------------------*/			
/*----------------SPLITTING MID-TERM CHANGES FOR Calendar/Accident Year data---------*/			
/*----------------NUMBER OF CHANGES IS INCREASED HERE--------------------------------*/			
/*----------------FIRST ROW INDICATORS MUST BE CALCULATED HERE NOW-------------------*/			
/*----------------IMPORTANT !!! MODELDATA_ID is changed HERE-------------------------*/			
			
			
			
drop table if exists stg_auto_modeldata_2;			
create temporary table  stg_auto_modeldata_2 as			
with 			
dim_year as 			
/*dim_year from dim_month*/			
(select cast(mon_year as int) y, mon_startdate startdate, dateadd(month, 11, mon_enddate) enddate 			
 from fsbi_dw_spinn.dim_month			
 where mon_monthinyear=1)			
,data as 			
/*Start Year and End Year of midterm changes*/			
(select			
d.*			
,cast(to_char(startdatetm, 'yyyy') as int) startyear			
,cast(to_char(enddatetm, 'yyyy') as int) endyear			
from stg_auto_modeldata_1 d)			
,data_adjusted as			
/*Splitted StartDate and EndDate based on year*/ 			
(select  distinct 			
 row_number() over(order by SystemId) modeldata_id_adjusted	       		
,case 			
  when  data.startyear<>data.endyear then 			
   case 			
    when data.startyear=dim_year.y then cast(data.startdatetm as date) 			
    when data.endyear=dim_year.y then dim_year.startdate			
   end  			
  else cast(data.startdatetm as date)			
 end startdate			
,case 			
  when  data.startyear<>data.endyear then			
   case 			
    when data.startyear=dim_year.y then  dateadd(day,1,dim_year.enddate)			
    when data.endyear=dim_year.y then cast(data.enddatetm as date) 			
   end 			
  else cast(data.enddatetm as date)  			
 end enddate,			
data.*			
from data 			
join dim_year 			
on (data.startyear=dim_year.y or data.endyear=dim_year.y)			
)			
select			
data.*			
from data_adjusted data;			
			
drop table if exists stg_auto_modeldata_1;			
			
			
/*17. Joining claims			
It's possible to have more then 1 claim per mid term			
Modeldata_id becomes not unique at this step			
Only Claims for modeldata are used			
17-1. Main join with dim_claimrisk			
*/			
			
			
			
drop table if exists stg_auto_modeldata_3;			
create temporary table  stg_auto_modeldata_3 as			
with claims1 as (			
select 			
clr.CLAIMRISK_ID,			
clr.clrsk_lossdate lossdate,			
clr.audit_id,			
cr.policy_uniqueid,			
cr.cvrsk_uniqueid risk_uniqueid,			
cr.spinn_systemid claim_SystemId			
from fsbi_dw_spinn.dim_claimrisk clr			
join fsbi_dw_spinn.dim_coveredrisk cr			
on clr.COVEREDRISK_ID=cr.coveredrisk_id			
and clr.policy_uniqueid=cr.policy_uniqueid			
join fsbi_stg_spinn.vstg_auto_modeldata_claims cb			
on clr.CLAIMRISK_ID=cb.CLAIMRISK_ID			
where clr.clrsk_item_type='VEHICLE'			
)			
,claims2 as (			
select 			
c.claimrisk_id,			
lossdate,			
audit_id,			
stg.policy_uniqueid,			
stg.risk_uniqueid,			
stg.SystemId			
from  stg_auto_modeldata_2 stg			
join claims1 c			
on c.claim_SystemId>=stg.SystemId and c.claim_SystemId<stg.SystemIdEnd 			
and to_char(c.lossdate,'yyyy')=to_char(stg.StartDate,'yyyy')  /*LossDate in the mid term change splitted by year*/			
and c.lossdate>=stg.StartDateTm and c.lossdate<=stg.EndDateTm /*LossDate in the mid term change important if a mid-term change not splitted by year*/			
and c.policy_uniqueid=stg.policy_uniqueid			
and c.risk_uniqueid=stg.risk_uniqueid			
union			
select 			
c.claimrisk_id,			
lossdate,			
audit_id,			
stg.policy_uniqueid,			
stg.risk_uniqueid,			
stg.SystemId			
from  stg_auto_modeldata_2 stg			
join claims1 c			
on c.claim_SystemId=stg.SystemIdEnd			
and to_char(c.lossdate,'yyyy')=to_char(stg.StartDate,'yyyy')  /*LossDate in the mid term change splitted by year*/			
and c.lossdate>=stg.StartDateTm and c.lossdate<=stg.EndDateTm /*LossDate in the mid term change important if a mid-term change not splitted by year*/			
and c.policy_uniqueid=stg.policy_uniqueid			
and c.risk_uniqueid=stg.risk_uniqueid			
)			
,claims3 as (			
select claimrisk_id,			
lossdate,			
audit_id,			
policy_uniqueid,			
risk_uniqueid,			
min(SystemId) SystemId			
from claims2			
group by claimrisk_id,			
lossdate,			
audit_id,			
policy_uniqueid,			
risk_uniqueid			
)			
select			
c.claimrisk_id,			
c.audit_id,			
stg.*,			
row_number() over(partition by stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid,stg.vin) FirstRecinPolicyTermInd			
from stg_auto_modeldata_2 stg			
left outer join claims3 c			
on stg.SystemId=c.SystemId			
and stg.policy_uniqueid=c.policy_uniqueid			
and stg.risk_uniqueid=c.risk_uniqueid			
and to_char(c.lossdate,'yyyy')=to_char(stg.StartDate,'yyyy');			
			
			
			
/*17-2. LossDate is beyond any mid term change			
can not be joined.			
In most cases they are claims with wrong Loss Date*/			
			
			
			
			
drop table if exists nf;			
create temporary table  nf as			
select c.* 			
from fsbi_dw_spinn.dim_claimrisk c			
join  fsbi_stg_spinn.vstg_auto_modeldata_claims cb			
on c.CLAIMRISK_ID=cb.CLAIMRISK_ID			
left outer join stg_auto_modeldata_3 stg			
on c.claimrisk_id=stg.claimrisk_id			
where clrsk_item_type='VEHICLE'			
and stg.modeldata_id_adjusted is null			
and coveredrisk_id<>0;			
			
			
			
/*17-3. Join not joined claims  to first change by policy term only*/			
			
			
drop table if exists stg_FirstRecinPolicyTerm;			
create temporary table  stg_FirstRecinPolicyTerm as			
with data as (			
select 			
nf.CLAIMRISK_ID,			
29 audit_id,			
stg.*,			
/*we may have more then one claim per first policy_uniqueid*/			
row_number() over(partition by nf.CLAIMRISK_ID,stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid,stg.vin) FirstRecinPolicyTermInd			
from nf			
join fsbi_dw_spinn.dim_coveredrisk cr			
on nf.coveredrisk_id=cr.coveredrisk_id			
join stg_auto_modeldata_2 stg 			
on nf.policy_uniqueid=stg.policy_uniqueid			
and cr.cvrsk_uniqueid=stg.risk_uniqueid			
)			
select			
data.*			
from data			
where FirstRecinPolicyTermInd=1;			
			
drop table if exists nf;			
drop table if exists stg_auto_modeldata_2;			
			
/*17-4. Delete first before insert the same*/			
delete from stg_auto_modeldata_3			
where modeldata_id_adjusted in (select modeldata_id_adjusted from stg_FirstRecinPolicyTerm)			
and claimrisk_id is null;			
			
			
/*17-5. Insert first records with missing claims*/			
insert into stg_auto_modeldata_3			
select			
*			
from stg_FirstRecinPolicyTerm;			
			
drop table if exists stg_FirstRecinPolicyTerm	;		
			
			
/*Test*/			
			
/*only NULL claimrisk_id*/			
/*select claimrisk_id,			
count(distinct modeldata_id)			
from stg_auto_modeldata_3			
group by claimrisk_id			
having count(distinct modeldata_id)>1;*/			
			
/*Nothing*/			
/*select modeldata_id_adjusted,			
count(*),			
count(distinct claimrisk_id)			
from stg_auto_modeldata_3			
group by modeldata_id_adjusted			
having count(*)>1			
and count(distinct claimrisk_id)=1;*/			
			
			
/*36/14 Flat cancelled*/			
/*			
select c.* 			
from fsbi_dw_spinn.dim_claimrisk c			
join  fsbi_stg_spinn.vstg_auto_modeldata_claims cb			
on c.CLAIMRISK_ID=cb.CLAIMRISK_ID			
left outer join stg_auto_modeldata_3 stg			
on c.claimrisk_id=stg.claimrisk_id			
where clrsk_item_type='VEHICLE'			
and stg.modeldata_id_adjusted is null			
and coveredrisk_id<>0;			
*/			
			
/*18. Final insert into main staging table*/			
			
truncate table fsbi_stg_spinn.stg_auto_modeldata;			
insert into fsbi_stg_spinn.stg_auto_modeldata			
(			
modeldata_id,			
claimrisk_id,			
SystemIdStart,			
SystemIdEnd,			
risk_id,			
risktype,			
policy_id,			
policy_uniqueid,			
Producer_Uniqueid,			
risk_uniqueid,			
vehicle_id,			
vehicle_uniqueid,			
vin,			
risknumber,			
driver_id,			
driver_uniqueid,			
driverlicense,			
drivernumber,			
startdatetm,			
enddatetm,			
startdate,			
enddate,			
CntVeh,			
CntDrv,			
CntNonDrv,			
CntExcludedDrv,			
mindriverage,			
VehicleInceptionDate,			
DriverInceptionDate,			
Liabilityonly_Flg,			
Componly_Flg,			
ExcludedDrv_Flg,			
Quality_PolAppInconsistency_Flg,			
Quality_RiskIdDuplicates_Flg,			
Quality_ExcludedDrv_Flg,			
Quality_ReplacedVIN_Flg,			
Quality_ReplacedDriver_Flg,			
Quality_ClaimOk_Flg ,			
Quality_ClaimUnknownVIN_Flg ,			
Quality_ClaimUnknownVINNotListedDriver_Flg ,			
Quality_ClaimPolicyTermJoin_Flg ,			
LoadDate			
)			
with ReplacedVIN as (select policy_uniqueid, vehicle_uniqueid,			
count(distinct vin)		cnt	
from stg_auto_modeldata_3			
group by policy_uniqueid, vehicle_uniqueid			
having count(distinct vin)>1)			
,ReplacedDriver as (select policy_uniqueid, driver_uniqueid,			
count(distinct Driver)		cnt	
from stg_auto_modeldata_3			
group by policy_uniqueid, driver_uniqueid			
having count(distinct driver)>1)			
select			
modeldata_id_adjusted modeldata_id,			
claimrisk_id,			
cast(SystemId as int) SystemIdStart,			
SystemIdEnd	,		
risk_id,			
cvrsk_typedescription	,		
policy_id	,		
stg.policy_uniqueid	,		
Producer_Uniqueid ,			
risk_uniqueid	,		
vehicle_id	,		
stg.vehicle_uniqueid	,		
vin	,		
RiskCd	,		
driver_id	,		
stg.driver_uniqueid	,		
Driver	,		
DriverNumber	,		
startdatetm	,		
enddatetm	,		
startdate,			
enddate,			
CntVeh	,		
CntDrv	,		
CntNonDrv	,		
CntExcludedDrv	,		
minDriverAge	,		
VehicleInceptionDate,			
DriverInceptionDate,			
LiabilityOnlyFlg	,		
CompOnlyFlg		,	
case when CntExcludedDrv>0  then 'Yes' else 'No' end ExcludedDrv_Flg,			
Quality_PolAppInconsistency_Flg,			
Quality_RiskIdDuplicates_Flg,			
Quality_ExcludedDrv_Flg,			
case when ReplacedVIN.policy_uniqueid is not null then 'Yes' else 'No' end Quality_ReplacedVIN_Flg,			
case when ReplacedDriver.policy_uniqueid is not null then 'Yes' else 'No' end Quality_ReplacedDriver_Flg,			
case when audit_id in (25,26,27) then claimrisk_id end Quality_ClaimOk_Flg,			
case when audit_id=30 then claimrisk_id end Quality_ClaimUnknownVIN_Flg,			
case when audit_id in (31,32) then claimrisk_id end  Quality_ClaimUnknownVINNotListedDriver_Flg	,		
case when audit_id in (29,33) then claimrisk_id end 	Quality_ClaimPolicyTermJoin_Flg,		
ploaddate LoadDate			
from stg_auto_modeldata_3 stg			
left outer join ReplacedVIN			
on stg.policy_uniqueid=ReplacedVIN.policy_uniqueid			
and stg.vehicle_uniqueid=ReplacedVIN.vehicle_uniqueid			
left outer join ReplacedDriver			
on stg.policy_uniqueid=ReplacedDriver.policy_uniqueid			
and stg.driver_uniqueid=ReplacedDriver.driver_uniqueid;			
			
drop table if exists stg_auto_modeldata_3;			
/*19. There is an issue in TransactionHistory where some Unapplied Endorsements are not marked as Uanapplied			
Just delete these data			
*/			
			
drop table if exists to_delete;			
create temporary table  to_delete as			
select modeldata_id			 
from fsbi_stg_spinn.stg_auto_modeldata m			
join fsbi_stg_spinn.vstg_modeldata_policyhistory ph			
on m.policy_uniqueid=ph.PolicyRef			
and m.SystemIdStart=ph.SystemId			
where 			
ph.TransactionCd='Final'			
order by Startdatetm;			
			
delete from fsbi_stg_spinn.stg_auto_modeldata 			
where modeldata_id in (select modeldata_id from to_delete);			
			
drop table if exists to_delete;			
			
END;			
			

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_stg_property_modeldata(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
			
		
BEGIN 		
		
/*		
Author: Kate Drogaieva		
Purpose: This script populate STG_HO_LL_MODELDATA (staging table for FACT_HO_LL_MODELDATA)		
Comment: Due to back dated transactions it was made as a full refresh.		
		
Last Modification Date: 02/14/2023		
Back to Redshift!		
Modification Date: 07/06/2020		
Adjusting mid-term change based on multipolicyind and autohomeind (the same indicator for different products)		
Adding Limits for THEFA coverage (On-premises and Away from premises		
Modification Date: 10/25/2019		
Adjusting to the new structure v_stg_ho_ll_modeldata_coverage new structure		
*/		
		
		
		
		
		
		
/*		
1. Limits, Deductible and FullTermAmount for each coverage of interest  at each mid-term change		
*/		
drop table if exists d_CovA;		
create temporary table d_CovA as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovA 		
where d_CovA.act_modeldata ='CovA';		
		
		
drop table if exists d_CovB;		
create temporary table d_CovB as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovB 		
where act_modeldata = 'CovB';		
		
drop table if exists d_CovC;		
create temporary table d_CovC as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovC 		
where act_modeldata = 'CovC';		
		
		
drop table if exists d_CovD;		
create temporary table d_CovD as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovD 		
where act_modeldata='CovD';		
		
drop table if exists d_CovE;		
create temporary table d_CovE as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovE 		
where act_modeldata = 'CovE';		
		
drop table if exists d_CovF;		
create temporary table d_CovF as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovF 		
where act_modeldata  = 'CovF';		
		
		
drop table if exists l_CovA;		
create temporary table l_CovA as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovA 		
where act_modeldata = 'CovA'; 		
		
drop table if exists l_CovB;		
create temporary table l_CovB as		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovB 		
where act_modeldata = 'CovB'; 		
		
		
drop table if exists l_CovC;		
create temporary table l_CovC as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovC 		
where act_modeldata = 'CovC'; 		
		
		
drop table if exists l_CovD;		
create temporary table l_CovD as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovD 		
where act_modeldata =  'CovD'; 		
		
drop table if exists l_CovE;		
create temporary table l_CovE as		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovE 		
where act_modeldata = 'CovE'; 		
		
		
drop table if exists l_CovF;		
create temporary table l_CovF as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovF 		
where act_modeldata = 'CovF'; 		
		
		
		
/*		
2. (1)Active  Risks 		
related to  New Business, Renewal or  Endorsement transactions (2).		
(3) If there are more then one change in the same day, we use the last change at this day		
(1)It's possible when a transaction with newest BookDt has an older effective date 		
then effective transactions already in the system.		
*/		
		
		
		
drop table if exists coveredrisk;		
create temporary table coveredrisk as 		
with cleaned_risks as (		
select 		
policy_uniqueid,		
cast(cvrsk_startdate as date) cvrsk_startdate,		
max(cvrsk_startdate) last_cvrsk_startdate_per_day		
from (		
select 		
cr.policy_uniqueid,		
cvrsk_startdate,		
spinn_systemid		
from fsbi_dw_spinn.dim_coveredrisk cr		
join fsbi_stg_spinn.vstg_modeldata_policyhistory f		
on f.SystemId=cr.spinn_systemid		
and f.PolicyRef=cr.policy_uniqueid		
where cvrsk_item_type='BUILDING'		
and cvrsk_item_uniqueid2='Unknown' --not BusinessOwners		
and f.TransactionCd in ('New Business','Renewal','Endorsement')		
) data		
group by 		
policy_uniqueid,		
cast(cvrsk_startdate as date)		
)		
select 		
cr.*		
from fsbi_dw_spinn.dim_coveredrisk cr		
join cleaned_risks 		
on cr.policy_uniqueid=cleaned_risks.policy_uniqueid		
and cr.cvrsk_startdate=cleaned_risks.last_cvrsk_startdate_per_day		
;		
		
		
		
		
		
		
/*3. There is no "Final" record in dim_coveredrisk		
with systemid=policy_uniqueid		
We need it to close the last entry in mid-term changes*/		
		
		
drop table if exists extend_dim_coveredrisk;		
create temporary table extend_dim_coveredrisk as 		
select *		
from		
(		
select 		
 coveredrisk_id		
,cvrsk_uniqueid		
,policy_uniqueid		
,policy_id		
,deleted_indicator		
,cvrsk_typedescription		
,cvrsk_item_id		
,cvrsk_item_uniqueid		
,cvrsk_item_type		
,cvrsk_item_id2		
,cvrsk_item_uniqueid2		
,cvrsk_item_type2		
,cvrsk_startdate		
,cvrsk_number		
,cvrsk_number2		
,cvrsk_item_naturalkey		
,cvrsk_item_naturalkey2		
,cvrsk_inceptiondate		
,cvrsk_inceptiondate2		
,policy_last_known_cvrsk_item_id		
,policy_last_known_cvrsk_item_id2		
,policy_term_last_known_cvrsk_item_id		
,policy_term_last_known_cvrsk_item_id2		
,spinn_systemid original_spinn_systemid		
,spinn_systemid		
,PolAppInconsistency_Flg		
,RiskIdDuplicates_Flg		
,RiskNumberDuplicates_Flg		
,RiskNaturalKeyDuplicates_Flg		
,RiskNaturalKey2Duplicates_Flg		
,ExcludedDrv_Flg		
,source_system		
,LoadDate		
from coveredrisk		
where policy_uniqueid<>'Unknown'		
union all		
select 		
 coveredrisk_id		
,dc.cvrsk_uniqueid		
,dc.policy_uniqueid		
,policy_id		
,deleted_indicator		
,cvrsk_typedescription		
,cvrsk_item_id		
,cvrsk_item_uniqueid		
,cvrsk_item_type		
,cvrsk_item_id2		
,cvrsk_item_uniqueid2		
,cvrsk_item_type2		
,cvrsk_startdate		
,cvrsk_number		
,cvrsk_number2		
,cvrsk_item_naturalkey		
,cvrsk_item_naturalkey2		
,cvrsk_inceptiondate		
,cvrsk_inceptiondate2		
,policy_last_known_cvrsk_item_id		
,policy_last_known_cvrsk_item_id2		
,policy_term_last_known_cvrsk_item_id		
,policy_term_last_known_cvrsk_item_id2		
,spinn_systemid original_spinn_systemid		
,cast(dc.policy_uniqueid as int) spinn_systemid		
,PolAppInconsistency_Flg		
,RiskIdDuplicates_Flg		
,RiskNumberDuplicates_Flg		
,RiskNaturalKeyDuplicates_Flg		
,RiskNaturalKey2Duplicates_Flg		
,ExcludedDrv_Flg		
,source_system		
,LoadDate		
from coveredrisk dc		
join (		
select policy_uniqueid, cvrsk_uniqueid, max(dc.spinn_systemid) id		
from coveredrisk dc		
where dc.policy_uniqueid<>'Unknown'		
group by policy_uniqueid, cvrsk_uniqueid		
) last_system		
on dc.spinn_systemId=last_system.id		
and dc.policy_uniqueid=last_system.policy_uniqueid		
and dc.cvrsk_uniqueid=last_system.cvrsk_uniqueid		
where dc.policy_uniqueid<>'Unknown'		
) d;		
		
		
drop table if exists coveredrisk;		
		
/*		
4. Main staging data select #tmp_PolicyRiskHistory		
based on stg_policyhistory plus all related info		
*/		
		
		
		
drop table if exists tmp_PolicyRiskHistory;		
create temporary table tmp_PolicyRiskHistory as 		
select distinct 		
  stg.SystemId		
, dc.original_spinn_systemid		
, dc.policy_id  		
, dc.policy_uniqueid		
, pg.Producer_Uniqueid		
, dc.coveredrisk_id	risk_id	
, dc.cvrsk_typedescription	RiskType	
, dc.cvrsk_uniqueid risk_uniqueid		
, dc.cvrsk_item_id building_id		
, b.SPInnBuilding_Id building_uniqueid		
, dc.cvrsk_number RiskCd		
, case when dc.deleted_indicator=1 then 'Deleted' else 'Active' end  status		
, case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt		
  else dc.cvrsk_startdate 		
  end changedate		
  --		
, b.UsageType		
, upper(replace(b.homegardcreditind	,'~','No')) homegardcreditind	
, upper(replace(b.sprinklersystem,'~','No')) sprinklersystem		
, upper(replace(b.landlordind,'~','No')) landlordind		
, upper(replace(b.cseagent,'~','No')) cseagent		
, upper(replace(b.rentersinsurance,'~','No')) RentersInsurance		
, upper(replace(b.FireAlarmType,'~','No')) FireAlarmType		
, upper(replace(b.BurglaryAlarmType,'~','No')) BurglaryAlarmType		
, upper(replace(b.WaterDetectionDevice,'~','No')) WaterDetectionDevice		
, upper(replace(b.NeighborhoodCrimeWatchInd,'~','No')) NeighborhoodCrimeWatchInd		
, upper(replace(b.PropertyManager,'~','No')) PropertyManager		
, upper(replace(b.earthquakeumbrellaind,'~','No')) earthquakeumbrellaind		
, upper(replace(b.MultiPolicyInd,'~','No')) MultiPolicyInd		
, upper(replace(b.AutoHomeInd,'~','No')) AutoHomeInd		
, upper(replace(b.MultiPolicyIndUmbrella,'~','No')) MultiPolicyIndUmbrella		
  --		
, upper(replace(CovADDRR_SecondaryResidence,'~','No')) CovADDRR_SecondaryResidence		
, CovADDRRPrem_SecondaryResidence		
  --		
, isnull(d_CovA.Deductible,'~') CovA_deductible		
, isnull(d_CovB.Deductible,'~') CovB_deductible		
, isnull(d_CovC.Deductible,'~') CovC_deductible		
, isnull(d_CovD.Deductible,'~') CovD_deductible		
, isnull(d_CovE.Deductible,'~') CovE_deductible		
, isnull(d_CovF.Deductible,'~') CovF_deductible		
  --		
, isnull(l_CovA.Limit1,'~')   CovA_Limit		
, isnull(l_CovB.Limit1,'~')   CovB_Limit		
, isnull(l_CovC.Limit1,'~')   CovC_Limit		
, isnull(l_CovD.Limit1,'~')   CovD_Limit		
, isnull(l_CovE.Limit1,'~')   CovE_Limit		
, isnull(l_CovF.Limit1,'~')   CovF_Limit		
 --		
, isnull(l_CovA.FullTermAmt,0)   CovA_FullTermAmt		
, isnull(l_CovB.FullTermAmt,0)   CovB_FullTermAmt		
, isnull(l_CovC.FullTermAmt,0)   CovC_FullTermAmt		
, isnull(l_CovD.FullTermAmt,0)   CovD_FullTermAmt		
, isnull(l_CovE.FullTermAmt,0)   CovE_FullTermAmt		
, isnull(l_CovF.FullTermAmt,0)   CovF_FullTermAmt		
, stg.TransactionCd		
,row_number() over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid order by   case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt		
  else dc.cvrsk_startdate 		
  end) rn_trn		
,count(*) over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid ) cn_trn		
,case when PolAppInconsistency_Flg='Y' then 'Yes' else 'No' end Quality_PolAppInconsistency_Flg		
,case when RiskIdDuplicates_Flg='Y' then 'Yes' else 'No' end Quality_RiskIdDuplicates_Flg		
		
from fsbi_stg_spinn.vstg_modeldata_policyhistory stg		
 --		
join extend_dim_coveredrisk dc		
on  stg.PolicyRef=dc.policy_uniqueid		
and stg.SystemId=dc.spinn_systemid		
 --		
join fsbi_dw_spinn.dim_building b		
on b.building_id=dc.cvrsk_item_id		
 --		
left outer join d_CovA	d_CovA	
on d_CovA.SystemId=stg.SystemId		
and d_CovA.policy_uniqueid=stg.PolicyRef		
and d_CovA.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovB	d_CovB	
on d_CovB.SystemId=stg.SystemId		
and d_CovB.policy_uniqueid=stg.PolicyRef		
and d_CovB.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovC	d_CovC	
on d_CovC.SystemId=stg.SystemId		
and d_CovC.policy_uniqueid=stg.PolicyRef		
and d_CovC.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovD	d_CovD	
on d_CovD.SystemId=stg.SystemId		
and d_CovD.policy_uniqueid=stg.PolicyRef		
and d_CovD.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovE	d_CovE	
on d_CovE.SystemId=stg.SystemId		
and d_CovE.policy_uniqueid=stg.PolicyRef		
and d_CovE.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovF	d_CovF	
on d_CovF.SystemId=stg.SystemId		
and d_CovF.policy_uniqueid=stg.PolicyRef		
and d_CovF.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
 --		
left outer join l_CovA	l_CovA	
on l_CovA.SystemId=stg.SystemId		
and l_CovA.policy_uniqueid=stg.PolicyRef		
and l_CovA.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovB	l_CovB	
on l_CovB.SystemId=stg.SystemId		
and l_CovB.policy_uniqueid=stg.PolicyRef		
and l_CovB.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovC	l_CovC	
on l_CovC.SystemId=stg.SystemId		
and l_CovC.policy_uniqueid=stg.PolicyRef		
and l_CovC.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovD	l_CovD	
on l_CovD.SystemId=stg.SystemId		
and l_CovD.policy_uniqueid=stg.PolicyRef		
and l_CovD.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovE	l_CovE	
on l_CovE.SystemId=stg.SystemId		
and l_CovE.policy_uniqueid=stg.PolicyRef		
and l_CovE.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovF	l_CovF	
on l_CovF.SystemId=stg.SystemId		
and l_CovF.policy_uniqueid=stg.PolicyRef		
and l_CovF.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join fsbi_dw_spinn.DIM_POLICY_CHANGES pg		
on  stg.PolicyRef=pg.policy_uniqueid		
and stg.TransactionEffectiveDt >= pg.valid_fromdate and stg.TransactionEffectiveDt<pg.valid_todate		
 --		
where  stg.TransactionCd in ('New Business','Renewal','Endorsement', 'Final')		
and stg.ReplacedByTransactionNumber is null		
and stg.UnAppliedByTransactionNumber is null;		
		
		
		
drop table if exists d_CovA;		
drop table if exists d_CovB;		
drop table if exists d_CovC;		
drop table if exists d_CovD;		
drop table if exists d_CovE;		
drop table if exists d_CovF;		
		
		
		
drop table if exists l_CovA;		
drop table if exists l_CovB;		
drop table if exists l_CovC;		
drop table if exists l_CovD;		
drop table if exists l_CovE;		
drop table if exists l_CovF;		
		
drop table if exists extend_dim_coveredrisk;		
/*		
5. Changes in Risks		
*/		
		
/*-----------------------------------------------------------------------------*/		
		
drop table if exists data1;		
create temporary table data1 as 		
with d1 as (		
select  		
t0.Policy_UniqueId, 		
t0.SystemId,		
count(distinct t0.risk_uniqueid) CntRisks		
from tmp_PolicyRiskHistory t0		
group by Policy_UniqueId, SystemId		
)		
,d2 as (select  		
t0.Policy_UniqueId, 		
t0.SystemId,		
checksum(LISTAGG( distinct risk_uniqueid , ','  ) WITHIN GROUP (order by risk_uniqueid))  listrisks		
from tmp_PolicyRiskHistory t0		
group by Policy_UniqueId, SystemId	)	
select		
d1.Policy_UniqueId, 		
d1.SystemId,		
CntRisks,		
listrisks		
from d1 join d2		
on d1.Policy_UniqueId=d2.Policy_UniqueId		
and d1.SystemId=d2.SystemId		
order by d1.Policy_UniqueId, d1.SystemId;		
		
		
		
		
		
/*6. Calculated Limits, Deductibles, FullTrm amount Changed Flags 		
1 if something important changed  comparing to the next record		
and we need to add one more row in the model dataset		
*/		
		
		
		
drop table if exists OneFlg;		
create temporary table OneFlg as 		
 select 		
  data.Policy_Uniqueid		
, data.SystemId  		
, risk_uniqueid		
, changedate		
, case when Status<>lag(Status) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CntRisks<>lag(CntRisks) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when ListRisks<>lag(ListRisks) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when homegardcreditind<>lag(homegardcreditind) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when cseagent<>lag(cseagent) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when landlordind<>lag(landlordind) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when UsageType<>lag(UsageType) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when RentersInsurance<>lag(RentersInsurance) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when sprinklersystem<>lag(sprinklersystem) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when FireAlarmType<>lag(FireAlarmType) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when BurglaryAlarmType<>lag(BurglaryAlarmType) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when WaterDetectionDevice<>lag(WaterDetectionDevice) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when NeighborhoodCrimeWatchInd<>lag(NeighborhoodCrimeWatchInd) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when PropertyManager<>lag(PropertyManager) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when earthquakeumbrellaind<>lag(earthquakeumbrellaind) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when MultiPolicyInd<>lag(MultiPolicyInd) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when AutoHomeInd<>lag(AutoHomeInd) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when MultiPolicyIndUmbrella<>lag(MultiPolicyIndUmbrella) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when CovADDRR_SecondaryResidence<>lag(CovADDRR_SecondaryResidence) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when CovADDRRPrem_SecondaryResidence<>lag(CovADDRRPrem_SecondaryResidence) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when CovA_Limit<>lag(CovA_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovB_Limit<>lag(CovB_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovC_Limit<>lag(CovC_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovD_Limit<>lag(CovD_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovE_Limit<>lag(CovE_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovF_Limit<>lag(CovF_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
--		
+ case when CovA_deductible<>lag(CovA_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovB_deductible<>lag(CovB_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovC_deductible<>lag(CovC_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovD_deductible<>lag(CovD_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovE_deductible<>lag(CovE_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovF_deductible<>lag(CovF_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
--		
+ case when CovA_FullTermAmt<>lag(CovA_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovB_FullTermAmt<>lag(CovB_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovC_FullTermAmt<>lag(CovC_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovD_FullTermAmt<>lag(CovD_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovE_FullTermAmt<>lag(CovE_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovF_FullTermAmt<>lag(CovF_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end Flg		
--		
from tmp_PolicyRiskHistory data		
join data1		
on data.policy_uniqueid=data1.policy_uniqueid		
and data.SystemId=data1.SystemId;		
		
		
drop table if exists data1;		
		
		
/*		
7. Joining Counts and Flags together		
Adjusting Flag to 1 (Change, first or last change) or 0		
*/		
		
		
		
drop table if exists final_data2;		
create temporary table final_data2 as 		
select 		
  data.* 		
, case when OneFlg.Flg>0 or data.rn_trn=1 or data.rn_trn=data.cn_trn then 1 else 0 end Flg		
from tmp_PolicyRiskHistory data		
join OneFlg		
on data.Policy_Uniqueid=OneFlg.Policy_Uniqueid		
and data.SystemId =OneFlg.SystemId	;	
		
drop table if exists OneFlg;		
		
/*		
8. Final mid-term changes		
*/ 		
		
		
		
drop table if exists stg_ho_ll_modeldata_1;		
create temporary table stg_ho_ll_modeldata_1 as 		
with data3 as (		
select 		
  data2.*		
, changedate StartDateTm		
, lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.risk_uniqueid order by changedate) EndDateTm		
, lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid, data2.risk_uniqueid order by changedate) SystemIdEnd		
from final_data2 data2		
where Flg=1		
)		
select 		
row_number() over(order by SystemId) modeldata_id	,	
data3.*		
from data3		
where status='Active'		
and EndDateTm is not null		
and abs(datediff(day,dateadd(sec, 100, StartDatetm),dateadd(sec, 100, EndDateTm)))>0		
order by Policy_Uniqueid,StartDatetm;		
		
drop table if exists final_data2;		
		
		
		
		
/*-----------------           9            ------------------------------------------*/		
/*----------------SPLITTING MID-TERM CHANGES FOR Calendar/Accident Year data---------*/		
/*----------------NUMBER OF CHANGES IS INCREASED HERE--------------------------------*/		
/*----------------FIRST ROW INDICATORS MUST BE CALCULATED HERE NOW-------------------*/		
/*----------------IMPORTANT !!! MODELDATA_ID is changed HERE-------------------------*/		
		
		
		
drop table if exists stg_ho_ll_modeldata_2;		
create temporary table stg_ho_ll_modeldata_2 as 		
with 		
dim_year as 		
/*dim_year from dim_month*/		
(select cast(mon_year as int) y, mon_startdate startdate, dateadd(month, 11, mon_enddate) enddate 		
 from fsbi_dw_spinn.dim_month		
 where mon_monthinyear=1)		
,data as 		
/*Start Year and End Year of midterm changes*/		
(select		
d.*		
,cast(datepart(year, startdatetm) as int) startyear		
,cast(datepart(year, enddatetm) as int) endyear		
from stg_ho_ll_modeldata_1 d)		
,data_adjusted as		
/*Splitted StartDate and EndDate based on year*/ 		
(select  distinct 		
 row_number() over(order by SystemId) modeldata_id_adjusted	       	
,case 		
  when  data.startyear<>data.endyear then 		
   case 		
    when data.startyear=dim_year.y then cast(data.startdatetm as date) 		
    when data.endyear=dim_year.y then dim_year.startdate		
   end  		
  else cast(data.startdatetm as date)		
 end startdate		
,case 		
  when  data.startyear<>data.endyear then		
   case 		
    when data.startyear=dim_year.y then  dateadd(day,1,dim_year.enddate)		   
    when data.endyear=dim_year.y then cast(data.enddatetm as date) 		
   end 		
  else cast(data.enddatetm as date)  		
 end enddate,		
data.*		
from data 		
join dim_year 		
on (data.startyear=dim_year.y or data.endyear=dim_year.y)		
)		
select		
data.*		
from data_adjusted data;		
		
drop table if exists stg_ho_ll_modeldata_1;		
		
/*10. Joining claims		
It's possible to have more then 1 claim per mid term		
Modeldata_id becomes not unique at this step		
Only Claims for modeldata are used		
10-1. Main join with dim_claimrisk		
*/		
		
		
		
		
drop table if exists stg_ho_ll_modeldata_3;		
create temporary table stg_ho_ll_modeldata_3 as 		
with claims1 as (		
select 		
clr.CLAIMRISK_ID,		
clr.clrsk_lossdate lossdate,		
clr.audit_id,		
cr.policy_uniqueid,		
cr.cvrsk_uniqueid risk_uniqueid,		
cr.spinn_systemid claim_SystemId		
from fsbi_dw_spinn.dim_claimrisk clr		
join fsbi_dw_spinn.dim_coveredrisk cr		
on clr.COVEREDRISK_ID=cr.coveredrisk_id		
and clr.policy_uniqueid=cr.policy_uniqueid		
join  fsbi_stg_spinn.vstg_property_modeldata_claims cb		
on clr.CLAIMRISK_ID=cb.CLAIMRISK_ID		
where clr.clrsk_item_type='BUILDING'		
)		
,claims2 as (		
select 		
c.claimrisk_id,		
lossdate,		
audit_id,		
stg.policy_uniqueid,		
stg.risk_uniqueid,		
stg.SystemId		
from  stg_ho_ll_modeldata_2 stg		
join claims1 c		
on c.claim_SystemId>=stg.SystemId and c.claim_SystemId<stg.SystemIdEnd 		/*Claim in a middle of a mid-term change*/
and datepart(year, c.lossdate)=datepart(year, stg.StartDate)  /*LossDate in the mid term change splitted by year*/		
and c.lossdate>=cast(stg.StartDateTm as date) and c.lossdate<=cast(stg.EndDateTm as date) /*LossDate in the mid term change important if a mid-term change not splitted by year*/		
and c.policy_uniqueid=stg.policy_uniqueid		
and c.risk_uniqueid=stg.risk_uniqueid		
union		
select 		
c.claimrisk_id,		
lossdate,		
audit_id,		
stg.policy_uniqueid,		
stg.risk_uniqueid,		
stg.SystemId		
from  stg_ho_ll_modeldata_2 stg		
join claims1 c		
on c.claim_SystemId=stg.SystemIdEnd		/*Claim at the edge of a mid-term change*/
and datepart(year, c.lossdate)=datepart(year, stg.StartDate)  /*LossDate in the mid term change splitted by year*/		
and c.lossdate>=cast(stg.StartDateTm as date) and c.lossdate<=cast(stg.EndDateTm as date)/*LossDate in the mid term change important if a mid-term change not splitted by year*/		
and c.policy_uniqueid=stg.policy_uniqueid		
and c.risk_uniqueid=stg.risk_uniqueid		
)		
,claims3 as (		
select claimrisk_id,		
lossdate,		
audit_id,		
policy_uniqueid,		
risk_uniqueid,		
min(SystemId) SystemId		
from claims2		
group by claimrisk_id,		
lossdate,		
audit_id,		
policy_uniqueid,		
risk_uniqueid		
)		
select		
c.claimrisk_id,		
0 audit_id,		
stg.*,		
row_number() over(partition by stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid) FirstRecinPolicyTermInd		
from stg_ho_ll_modeldata_2 stg		
left outer join claims3 c		
on stg.SystemId=c.SystemId		
and stg.policy_uniqueid=c.policy_uniqueid		
and stg.risk_uniqueid=c.risk_uniqueid		
and datepart(year, c.lossdate)=datepart(year, stg.StartDate);		
		
		
		
/*10-2. LossDate is beyond any mid term change		
can not be joined.		
In most cases they are claims with wrong Loss Date*/		
		
		
drop table if exists cb;		
create temporary table cb as 		
select *		
from fsbi_stg_spinn.vstg_property_modeldata_claims;		
		
		
		
drop table if exists nf;		
create temporary table nf as		
select c.* 		
from fsbi_dw_spinn.dim_claimrisk c		
join  cb		
on c.CLAIMRISK_ID=cb.CLAIMRISK_ID		
left outer join stg_ho_ll_modeldata_3 stg		
on c.claimrisk_id=stg.claimrisk_id		
where clrsk_item_type='BUILDING'		
and stg.modeldata_id_adjusted is null		
and coveredrisk_id<>0;		
		
drop table if exists cb;		
		
/*10-3. Join not joined claims  to first change by policy term only*/		
		
		
drop table if exists stg_FirstRecinPolicyTerm;		
create temporary table stg_FirstRecinPolicyTerm as		
with data as (		
select 		
nf.CLAIMRISK_ID,		
29 audit_id,		
stg.*,		
/*we may have more then one claim per first policy_uniqueid*/		
row_number() over(partition by nf.CLAIMRISK_ID,stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid) FirstRecinPolicyTermInd		
from nf		
join fsbi_dw_spinn.dim_coveredrisk cr		
on nf.coveredrisk_id=cr.coveredrisk_id		
join stg_ho_ll_modeldata_2 stg 		
on nf.policy_uniqueid=stg.policy_uniqueid		
and cr.cvrsk_uniqueid=stg.risk_uniqueid		
)		
select		
data.*		
from data		
where FirstRecinPolicyTermInd=1;		
		
drop table if exists nf;		
drop table if exists stg_ho_ll_modeldata_2;		
		
		
/*10-4. Delete first before insert the same*/		
delete from stg_ho_ll_modeldata_3		
where modeldata_id_adjusted in (select modeldata_id_adjusted from stg_FirstRecinPolicyTerm)		
and claimrisk_id is null;		
		
		
/*10-5. Insert first records with missing claims*/		
insert into stg_ho_ll_modeldata_3		
select		
*		
from stg_FirstRecinPolicyTerm;		
		
/*Test		
		
 -- These claims are not in the dataset because the correspondent policies were cancelled		
 -- 00503780 (CAH0760010, 297101)		
 -- 00512190 (CAH0334800, 482484)		
 -- 00444905 (CAH0766850, 207491)		
		
select cr.clrsk_lossdate,  cb.* 		
from cb cb		
join fsbi_dw_spinn.dim_claimrisk cr		
on cb.claimrisk_id=cr.claimrisk_id		
left outer join stg_ho_ll_modeldata_3 stg		
on cb.claimrisk_id=stg.CLAIMRISK_ID		
where stg.modeldata_id_adjusted is null		
		
		
		
 --only NULL claimrisk_id*		
select claimrisk_id,		
count(distinct modeldata_id)		
from stg_ho_ll_modeldata_3		
group by claimrisk_id		
having count(distinct modeldata_id)>1;		
		
 --Nothing		
select modeldata_id_adjusted,		
count(*),		
count(distinct claimrisk_id)		
from stg_ho_ll_modeldata_3		
group by modeldata_id_adjusted		
having count(*)>1		
and count(distinct claimrisk_id)=1;		
		
		
*/		
		
/*11. Main insert into the staging table*/		
truncate table fsbi_stg_spinn.stg_property_modeldata;		
insert into fsbi_stg_spinn.stg_property_modeldata		
select 		
    modeldata_id_adjusted modeldata_id,		
	claimrisk_id,	
	cast(stg.SystemId as int) SystemIdStart,	
	SystemIdEnd,	
	policy_id,	
	stg.policy_uniqueid,	
	Producer_Uniqueid,	
	Risk_id,	
	stg.Risk_uniqueid,	
	RiskCd RiskNumber,	
	RiskType,	
	Building_id,	
	Building_uniqueid,	
	StartDateTm,	
	EndDateTm,	
	StartDate,	
	EndDate,	
	CovA_deductible,	
	CovB_deductible,	
	CovC_deductible,	
	CovD_deductible,	
	CovE_deductible,	
	CovF_deductible,	
	CovA_Limit,	
	CovB_Limit,	
	CovC_Limit,	
	CovD_Limit,	
	CovE_Limit,	
	CovF_Limit,	
	CovA_FullTermAmt,	
	CovB_FullTermAmt,	
	CovC_FullTermAmt,	
	CovD_FullTermAmt,	
	CovE_FullTermAmt,	
	CovF_FullTermAmt,	
	isnull(cov.Limit1,'~') OnPremises_Theft_Limit,	
	isnull(cov.Limit2,'~') AwayFromPremises_Theft_Limit,	
	Quality_PolAppInconsistency_Flg,	
	Quality_RiskIdDuplicates_Flg,	
    case when audit_id in (25) then claimrisk_id end Quality_ClaimOk_Flg,		
    case when audit_id in (29,33) then claimrisk_id end 	Quality_ClaimPolicyTermJoin_Flg,	
	pLoadDate LoadDate	
from 	stg_ho_ll_modeldata_3	stg
left outer join fsbi_stg_spinn.vstg_property_modeldata_coverage cov		
on cov.SystemId=stg.SystemId		
and cov.Policy_Uniqueid=stg.policy_uniqueid		
and cov.Risk_Uniqueid=stg.risk_uniqueid		
and cov.act_modeldata='THEFA'		
order by cast(stg.policy_uniqueid as int) desc, StartDateTm, riskcd;		
		
		
		
/*12. There is an issue in TransactionHistory where some Unapplied Endorsements are not marked as Uanapplied		
Just delete these data		
Policy Uniqueid 2 is a particular case where mid-term SystemId=2 is teh same as PolicyRef=2*/		
		
		
drop table if exists to_delete;		
create temporary table to_delete as		
select modeldata_id		
from fsbi_stg_spinn.stg_property_modeldata m		
join fsbi_stg_spinn.vstg_modeldata_policyhistory ph		
on m.policy_uniqueid=ph.PolicyRef		
and m.SystemIdStart=ph.SystemId		
where 		
ph.TransactionCd='Final'		
and m.policy_uniqueid<>'2'		
order by Startdatetm;		
		
delete from fsbi_stg_spinn.stg_property_modeldata 		
where modeldata_id in (select modeldata_id from to_delete);		
		
drop table if exists to_delete;		
		
END;		
		

$$
;