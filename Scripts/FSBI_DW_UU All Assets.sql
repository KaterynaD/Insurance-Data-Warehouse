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

CREATE OR REPLACE PROCEDURE cse_bi.sp_extend_blended_claims_uu()
	LANGUAGE plpgsql
AS $$
	
	
	
BEGIN

	-- get "last" ids for claimtransaction_id, claimsummary_id at the claim (claim number) and feature (claim number/claimant/feature) levels 
	drop table if exists #latest_ids;
	create table #latest_ids as
	with xns as
	(
		select distinct
			clm.clm_claimnumber claim_number
		,	clmnt.claimant_number claimant
		,	covx.covx_code feature
		,	last_value(f.claimtransaction_id) over (partition by claim_number order by f.accountingdate_id,f.claimtransaction_id
				rows between unbounded preceding and unbounded following) claimtransaction_id_claim
		,	last_value(f.claimtransaction_id) over (partition by claim_number,claimant,feature order by f.accountingdate_id,f.claimtransaction_id
				rows between unbounded preceding and unbounded following) claimtransaction_id_feature
		from fsbi_dw_uu.fact_claimtransaction f
		left join fsbi_dw_uu.dim_claim clm using (claim_id)
		left join fsbi_dw_uu.dim_claimant clmnt using (claimant_id)
		left join fsbi_dw_uu.dim_coverageextension covx using (coverage_id)	
	)
	, mthly_summ as
	(
		select distinct
			clm.clm_claimnumber claim_number
		,	clmnt.claimant_number claimant
		,	covx.covx_code feature
		,	last_value(f.claimsummary_id) over (partition by claim_number order by f.month_id,f.claimsummary_id
				rows between unbounded preceding and unbounded following) claimsummary_id_claim
		,	last_value(f.claimsummary_id) over (partition by claim_number,claimant,feature order by f.month_id,f.claimsummary_id
				rows between unbounded preceding and unbounded following) claimsummary_id_feature
		from fsbi_dw_uu.fact_claim f
		left join fsbi_dw_uu.dim_claim clm using (claim_id)
		left join fsbi_dw_uu.dim_claimant clmnt using (claimant_id)
		left join fsbi_dw_uu.dim_coverageextension covx using (coverage_id)	
		where month_id <= (select left(max(accountingdate_id)::varchar,6)::int from fsbi_dw_uu.fact_claimtransaction)
	)
	select
		claim_number
	,	claimant
	,	feature
	,	claimtransaction_id_claim
	,	claimsummary_id_claim
	,	claimtransaction_id_feature
	,	claimsummary_id_feature
	from xns
	full outer join mthly_summ using (claim_number,claimant,feature)
	order by 1,2,3
	;
	
	-- latest feature-level attributes	
	drop table if exists #feature_attribs;
	create table #feature_attribs as
	with feats as
	(
		select distinct
			claim_number
		,	claimant
		,	feature
		,	xn.claim_id
		,	xn.claimant_id
		,	xn.coverage_id
		,	xn.policy_id
		,	xn.product_id
		from #latest_ids i
		join fsbi_dw_uu.fact_claimtransaction xn on xn.claimtransaction_id = claimtransaction_id_feature
		join fsbi_dw_uu.fact_claim summ on summ.claimsummary_id = claimsummary_id_feature
	)
	, attribs as
	(
		select
			claim_number
		,	claimant
		,	feature
		,	covx.covx_description feature_desc
		,	left(covx.coveragetype,1) feature_type
		,	covx.covx_asl aslob
		,	covx.act_rag rag
		,	covx.fin_schedp schedp_part
		from feats
		join fsbi_dw_uu.dim_coverageextension covx using (coverage_id)
	)
	select
		*
	from attribs
	order by 1,2,3
	;

	-- latest claim-level attributes	
	drop table if exists #claim_attribs;
	create table #claim_attribs as
	with clms as
	(
		select distinct
			claim_number
		,	xn.claim_id
		,	xn.policy_id
		,	xn.product_id
		from #latest_ids i
		join fsbi_dw_uu.fact_claimtransaction xn on xn.claimtransaction_id = claimtransaction_id_claim
--		join fsbi_dw_uu.fact_claim summ on summ.claimsummary_id = claimsummary_id_claim		
	)
	, attribs as
	(
		select
			claim_number
		,	claim_id
		,	clm.dateofloss loss_date
		,	date_part(year,loss_date)::integer loss_year
		,	clm.datereported reported_date
		,	decode(clm.clm_causelosscode,'~','',clm.clm_causelosscode) loss_cause
		,	fccr.catastrophe_id catastrophe_id
		,	pol.pol_policynumber policy_number
		,	pol.pol_effectivedate poleff_date
		,	pol.pol_expirationdate polexp_date
		,	policy_id
		,	pol.pol_masterstate prdt_state
		,	fprdtc.prdt_lob_code prdt_lob_code
		,	decode(fprdt.prdt_lob_code,'Dwelling','Landlord',fprdt.prdt_lob_code) product_code
		,	decode(fprdt.prdt_lob_code,'Dwelling','Landlord',fprdt.prdt_lob_code) product
		,	fprdtc.prdt_lob_name prdt_lob_name
		,	fprdt.prdt_code prdt_code
		,	fprdt.prdt_name prdt_name
		,	fprdt.prdt_lob_type
		,	floc.fin_location_id fin_location_id
		,	fprdt.fin_product_id fin_product_id
		,	elr.elr
		from clms
		left join fsbi_dw_uu.dim_claim clm using (claim_id,policy_id)
		left join fsbi_dw_uu.dim_policy pol using (policy_id)
		left join fsbi_dw_uu.dim_product prdt using (product_id)
		left join fsbi_dw_uu.fact_claimcatastrophe_rel fccr using (claim_id)
		left join fsbi_dw_spinn.dim_fin_location floc on pol.pol_masterstate = floc.state and floc.valid_todate = '2999-12-31'
		left join fsbi_dw_spinn.dim_fin_product_code fprdtc on
			fprdtc.prdt_code =
				decode(prdt.prdt_name
		--			,	'Homeowners','HO' + right(pol.pol_form,1)
		--			,	'Dwelling','DF' + right(pol.pol_form,1)
				,	'Homeowners','HO3'
				,	'Dwelling','DF3'
				,	'PersonalAuto','PA'
				)
		and fprdtc.prdt_selectorpreferred = 'Preferred'
		left join fsbi_dw_spinn.dim_fin_product fprdt using (fin_product_id)
		left join reporting.product_mappings_finance elr on
			elr.fin_source_id = '122'
		and elr.fin_company_id = '22'
		and elr.fin_location_id = floc.fin_location_id
		and elr.fin_product_id = fprdt.fin_product_id
	)
	select
		*
	from attribs
	order by 1
	;

	truncate table fsbi_dw_uu.vmfact_claimtransaction_blended;

	insert into fsbi_dw_uu.vmfact_claimtransaction_blended
	(claimtransaction_id,source_system,businesssource,trans_date,acct_date,claim_number,claimant,feature,feature_desc,feature_type,aslob,catastrophe_id,iseco,rag,elr,schedp_part,ctrans_code,ctrans_name,ctrans_subcode,ctrans_subname,loss_paid,loss_reserve,aoo_paid,aoo_reserve,dcc_paid,dcc_reserve,salvage_received,salvage_reserve,subro_received,subro_reserve,product_code,product,subproduct,carrier,carrier_group,company,prdt_lob_code,prdt_lob_name,prdt_lob_type,prdt_state,carr_code,carr_abbr,prdt_selectorpreferred,prdt_code,prdt_name,policy_state,policy_number,policyref,poleff_date,polexp_date,producer_code,loss_date,loss_year,reported_date,loss_cause,changetype,claimtransactiontype_id_original,coverage_id_original,dateofloss_id_original,amount_original,fin_source_id,fin_company_id,fin_location_id,fin_product_id,policy_id)
	select
		f.claimtransaction_id
	,	f.source_system
	,	'UU' businesssource
	,	f.transactiondate_id::varchar::date trans_date
	,	f.accountingdate_id::varchar::date acct_date
	,	clattr.claim_number
	,	ftattr.claimant
	,	ftattr.feature
	,	ftattr.feature_desc
	,	ftattr.feature_type
	,	ftattr.aslob
	,	clattr.catastrophe_id
	,	false iseco
	,	ftattr.rag
	,	clattr.elr
	,	ftattr.schedp_part
	,	dctt.ctrans_code
	,	dctt.ctrans_name
	,	dctt.ctrans_subcode
	,	dctt.ctrans_subname
	,	cast(case when '+' in (dctt.ctrans_losspaid) then f.amount else 0 end as decimal(18,2)) as loss_paid
	,	cast(case when '+' in (dctt.ctrans_lossreserve) then f.amount else 0 end as decimal(18,2)) as loss_reserve
	,	cast(case when '+' in (dctt.ctrans_alaepaid) then f.amount else 0 end as decimal(18,2)) as aoo_paid
	,	cast(case when '+' in (dctt.ctrans_alaereserve) then f.amount else 0 end as decimal(18,2)) as aoo_reserve
	,	cast(case when '+' in (dctt.ctrans_ulaepaid) then f.amount else 0 end as decimal(18,2)) as dcc_paid
	,	cast(case when '+' in (dctt.ctrans_ulaereserve) then f.amount else 0 end as decimal(18,2)) as dcc_reserve
	,	-cast(case when '+' in (dctt.ctrans_salvagereceived) then f.amount else 0 end as decimal(18,2)) as salvage_received
	,	-cast(case when '+' in (dctt.ctrans_salvagereserve) then f.amount else 0 end as decimal(18,2)) as salvage_reserve
	,	-cast(case when '+' in (dctt.ctrans_subropaid,dctt.ctrans_subroreceived) then f.amount else 0 end as decimal(18,2)) as subro_received
	,	-cast(case when '+' in (dctt.ctrans_subroreserve) then f.amount else 0 end as decimal(18,2)) as subro_reserve
	,	clattr.product_code
	,	clattr.product
	,	clattr.prdt_code subproduct
	,	'CSESG' carrier
	,	'Preferred' carrier_group
	,	'0017' company
	,	clattr.prdt_lob_code
	,	clattr.prdt_lob_name
	,	clattr.prdt_lob_type
	,	clattr.prdt_state
	,	'CSESG' carr_code
	,	'SFG' carr_abbr
	,	'Preferred' prdt_selectorpreferred
	,	clattr.prdt_code
	,	clattr.prdt_name
	,	clattr.prdt_state policy_state
	,	clattr.policy_number
	,	null policyref
	,	clattr.poleff_date
	,	clattr.polexp_date
	,	'' producer_code
	,	clattr.loss_date
	,	clattr.loss_year
	,	clattr.reported_date
	,	clattr.loss_cause
	,	'' changetype
	,	f.claimtransactiontype_id claimtransactiontype_id_original
	,	f.coverage_id coverage_id_original
	,	to_char(clattr.loss_date,'YYYYMMDD')::integer dateofloss_id_original
	,	f.amount amount_original
	,	'122' fin_source_id
	,	'22' fin_company_id
	,	clattr.fin_location_id
	,	clattr.fin_product_id
	,	clattr.policy_id
	from fsbi_dw_uu.fact_claimtransaction f
	left join fsbi_dw_uu.dim_claim clm using (claim_id)
	left join fsbi_dw_uu.dim_claimant clmnt using (claimant_id)
	left join fsbi_dw_uu.dim_coverageextension covx using (coverage_id)	
	left join #claim_attribs clattr on clattr.claim_number = f.claimnumber
	left join #feature_attribs ftattr on
		ftattr.claim_number = f.claimnumber
	and ftattr.claimant = clmnt.claimant_number
	and ftattr.feature = covx.covx_code
	left join fsbi_dw_uu.dim_claimtransactiontype dctt on f.claimtransactiontype_id = dctt.claimtransactiontype_id
	;
	
	drop table if exists #latest_ids;
	drop table if exists #claim_attribs;
	drop table if exists #feature_attribs;

END;


$$
;

-- Drop table

-- DROP TABLE fsbi_dw_uu.checks;

--DROP TABLE fsbi_dw_uu.checks;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.checks
(
	agency VARCHAR(100)   ENCODE lzo
	,carrier VARCHAR(100)   ENCODE lzo
	,claim_number VARCHAR(100)   ENCODE lzo
	,claim_dol TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,cov_code VARCHAR(100)   ENCODE lzo
	,check_date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,void_stop_date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,check_number VARCHAR(100)   ENCODE lzo
	,amount NUMERIC(13,3)   ENCODE az64
	,filename VARCHAR(250) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uu.checks owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.checks IS 'Checks info from monthly UU files.';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_address;

--DROP TABLE fsbi_dw_uu.dim_address;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_address
(
	address_id INTEGER NOT NULL  ENCODE RAW
	,addr_address1 VARCHAR(150)   ENCODE lzo
	,addr_address2 VARCHAR(150)   ENCODE lzo
	,addr_address3 VARCHAR(150)   ENCODE lzo
	,addr_county VARCHAR(50)   ENCODE lzo
	,addr_city VARCHAR(50)   ENCODE lzo
	,addr_state VARCHAR(50)   ENCODE lzo
	,addr_postalcode VARCHAR(20)   ENCODE lzo
	,addr_country VARCHAR(50)   ENCODE lzo
	,addr_latitude NUMERIC(18,12)   ENCODE az64
	,addr_longitude NUMERIC(18,12)   ENCODE az64
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (address_id)
)
DISTSTYLE AUTO
 DISTKEY (address_id)
 SORTKEY (
	address_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_address owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_address IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table of all full addresses from FSBI_STG_UU.stg_risk';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_adjuster;

--DROP TABLE fsbi_dw_uu.dim_adjuster;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_adjuster
(
	adjuster_id INTEGER NOT NULL  ENCODE RAW
	,name VARCHAR(100)   ENCODE lzo
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,adjuster_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE az64
	,PRIMARY KEY (adjuster_id)
)
DISTSTYLE AUTO
 SORTKEY (
	adjuster_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_adjuster owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_adjuster IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Adjuster info  from FSBI_STG_UU.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_claim;

--DROP TABLE fsbi_dw_uu.dim_claim;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_claim
(
	claim_id INTEGER NOT NULL  ENCODE RAW
	,policy_id INTEGER NOT NULL  ENCODE az64
	,clm_claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,clm_featurenumber VARCHAR(50) NOT NULL  ENCODE lzo
	,dateofloss DATE NOT NULL  ENCODE az64
	,datereported DATE NOT NULL  ENCODE az64
	,clm_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,clm_catcode VARCHAR(50) NOT NULL  ENCODE lzo
	,clm_catdescription VARCHAR(256)   ENCODE lzo
	,clm_causelosscode VARCHAR(50) NOT NULL  ENCODE lzo
	,clm_causelossdescription VARCHAR(256) NOT NULL  ENCODE lzo
	,atfault VARCHAR(1) NOT NULL  ENCODE lzo
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,PRIMARY KEY (claim_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	claim_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_claim owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_claim IS 'DW Table type: Dimension Type 1 Table description: Claimnumber, date of loss, reported date, policy term etc from FSBI_STG_UU.stg_claim';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_claimant;

--DROP TABLE fsbi_dw_uu.dim_claimant;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_claimant
(
	claimant_id INTEGER NOT NULL  ENCODE RAW
	,claimant_number VARCHAR(50)   ENCODE lzo
	,name VARCHAR(100)   ENCODE lzo
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,claimant_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE az64
	,PRIMARY KEY (claimant_id)
)
DISTSTYLE AUTO
 DISTKEY (claimant_id)
 SORTKEY (
	claimant_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_claimant owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_claimant IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Claimant info  from FSBI_STG_UU.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_claimrisk;

--DROP TABLE fsbi_dw_uu.dim_claimrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_claimrisk
(
	claimrisk_id INTEGER NOT NULL  ENCODE RAW
	,claimnumber VARCHAR(100) NOT NULL  ENCODE lzo
	,clrsk_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE az64
	,clrsk_item_id INTEGER NOT NULL  ENCODE az64
	,clrsk_item_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,clrsk_item_type VARCHAR(10) NOT NULL  ENCODE lzo
	,clrsk_item_id2 BIGINT NOT NULL  ENCODE az64
	,clrsk_item_uniqueid2 VARCHAR(255) NOT NULL  ENCODE lzo
	,clrsk_item_type2 VARCHAR(10) NOT NULL  ENCODE lzo
	,clrsk_number INTEGER NOT NULL  ENCODE az64
	,clrsk_number2 INTEGER NOT NULL  ENCODE az64
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE az64
	,PRIMARY KEY (claimrisk_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	claimrisk_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_claimrisk owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_claimrisk IS 'DW Table type: Dimension Type 0 Table description: Claim risks. Use FACT_CLAIMTRANSACTION.PRIMARYRISK_ID to join. It''s a table for a special purposes. Use direct links to risk items from FACT tables via VEHICLE_ID, DRIVER_ID';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_claimtransactiontype;

--DROP TABLE fsbi_dw_uu.dim_claimtransactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_claimtransactiontype
(
	claimtransactiontype_id INTEGER NOT NULL  ENCODE az64
	,ctrans_code VARCHAR(50)   ENCODE lzo
	,ctrans_name VARCHAR(100)   ENCODE lzo
	,ctrans_description VARCHAR(256)   ENCODE lzo
	,ctrans_subcode VARCHAR(50)   ENCODE lzo
	,ctrans_subname VARCHAR(100)   ENCODE lzo
	,ctrans_subdescription VARCHAR(256)   ENCODE lzo
	,ctrans_losspaid VARCHAR(1)   ENCODE lzo
	,ctrans_lossreserve VARCHAR(1)   ENCODE lzo
	,ctrans_initlossreserve VARCHAR(1)   ENCODE lzo
	,ctrans_alaepaid VARCHAR(1)   ENCODE lzo
	,ctrans_alaereserve VARCHAR(1)   ENCODE lzo
	,ctrans_ulaepaid VARCHAR(1)   ENCODE lzo
	,ctrans_ulaereserve VARCHAR(1)   ENCODE lzo
	,ctrans_subroreceived VARCHAR(1)   ENCODE lzo
	,ctrans_subropaid VARCHAR(1)   ENCODE lzo
	,ctrans_subroreserve VARCHAR(1)   ENCODE lzo
	,ctrans_salvagereceived VARCHAR(1)   ENCODE lzo
	,ctrans_salvagereserve VARCHAR(1)   ENCODE lzo
	,ctrans_deductrecoveryrecvd VARCHAR(1)   ENCODE lzo
	,ctrans_deductrecoveryrsrv VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary1 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary2 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary3 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary4 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary5 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary6 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary7 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary8 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary9 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary10 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary11 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary12 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary13 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary14 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary15 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary16 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary17 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary18 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary19 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary20 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary21 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary22 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary23 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary24 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary25 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary26 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary27 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary28 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary29 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary30 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary31 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary32 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary33 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary34 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary35 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary36 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary37 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary38 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary39 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary40 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary41 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary42 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary43 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary44 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary45 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary46 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary47 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary48 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary49 VARCHAR(1)   ENCODE lzo
	,ctrans_userdefinedsummary50 VARCHAR(1)   ENCODE lzo
	,loaddate DATE   ENCODE az64
	,PRIMARY KEY (claimtransactiontype_id)
)
DISTSTYLE AUTO
 SORTKEY (
	claimtransactiontype_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_claimtransactiontype owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_claimtransactiontype IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: DW special table from 4SightBI original setup';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_coverage;

--DROP TABLE fsbi_dw_uu.dim_coverage;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_coverage
(
	coverage_id INTEGER NOT NULL  ENCODE RAW
	,cov_type VARCHAR(100)   ENCODE lzo
	,cov_code VARCHAR(50)   ENCODE lzo
	,cov_name VARCHAR(100)   ENCODE lzo
	,cov_description VARCHAR(256)   ENCODE lzo
	,cov_subcode VARCHAR(50)   ENCODE lzo
	,cov_subcodename VARCHAR(100)   ENCODE lzo
	,cov_subcodedescription VARCHAR(256)   ENCODE lzo
	,cov_asl VARCHAR(5)   ENCODE lzo
	,cov_subline VARCHAR(5)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (coverage_id)
)
DISTSTYLE AUTO
 SORTKEY (
	coverage_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_coverage owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_coverage IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available Coverage codes, ASL, SubLine from FSBI_STG_UU.stg_coverage with adjustments made in ETL';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_coverageextension;

--DROP TABLE fsbi_dw_uu.dim_coverageextension;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_coverageextension
(
	coverageextension_id INTEGER   ENCODE RAW
	,coverage_id INTEGER   ENCODE RAW
	,covx_code VARCHAR(75)   ENCODE RAW
	,covx_name VARCHAR(75)   ENCODE lzo
	,covx_description VARCHAR(125)   ENCODE lzo
	,covx_subcode VARCHAR(32)   ENCODE lzo
	,covx_subcodename VARCHAR(1)   ENCODE lzo
	,covx_subcodedescription VARCHAR(1)   ENCODE lzo
	,covx_asl VARCHAR(3)   ENCODE lzo
	,covx_subline VARCHAR(5)   ENCODE lzo
	,codetype VARCHAR(25)   ENCODE lzo
	,coveragetype VARCHAR(25)   ENCODE lzo
	,act_rag VARCHAR(3)   ENCODE lzo
	,fin_schedp VARCHAR(2)   ENCODE lzo
	,act_modeldata_auto VARCHAR(10)   ENCODE lzo
	,act_modeldata_ho_ll VARCHAR(50)   ENCODE lzo
	,act_modeldata_ho_ll_claims VARCHAR(50)   ENCODE lzo
	,claim_features VARCHAR(50)   ENCODE lzo
	,act_map VARCHAR(20)   ENCODE lzo
	,clm_cov_group VARCHAR(24)   ENCODE lzo
	,act_eris VARCHAR(5)   ENCODE lzo
	,clm_subropotential VARCHAR(1)   ENCODE lzo
	,clm_toolkit VARCHAR(8)   ENCODE lzo
	,uu_month_sum VARCHAR(25)   ENCODE lzo
	,feetype VARCHAR(20)   ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uu.dim_coverageextension owner to emiller;
COMMENT ON TABLE fsbi_dw_uu.dim_coverageextension IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. Standartized Coverage codes, ASL, SubLineand any other coverage mapping used in different projects';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_coveredrisk;

--DROP TABLE fsbi_dw_uu.dim_coveredrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_coveredrisk
(
	coveredrisk_id INTEGER NOT NULL  ENCODE az64
	,cvrsk_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE RAW
	,deleted_indicator INTEGER   ENCODE az64
	,cvrsk_typedescription VARCHAR(256)   ENCODE lzo
	,cvrsk_item_id INTEGER   ENCODE az64
	,cvrsk_item_uniqueid VARCHAR(500)   ENCODE lzo
	,cvrsk_item_type VARCHAR(100)   ENCODE bytedict
	,cvrsk_item_id2 INTEGER   ENCODE az64
	,cvrsk_item_uniqueid2 VARCHAR(500)   ENCODE lzo
	,cvrsk_item_type2 VARCHAR(100)   ENCODE lzo
	,policy_last_known_cvrsk_item_id INTEGER   ENCODE az64
	,policy_last_known_cvrsk_item_id2 INTEGER   ENCODE az64
	,policy_term_last_known_cvrsk_item_id INTEGER   ENCODE az64
	,policy_term_last_known_cvrsk_item_id2 INTEGER   ENCODE az64
	,cvrsk_number INTEGER   ENCODE az64
	,cvrsk_number2 INTEGER   ENCODE az64
	,cvrsk_startdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,cvrsk_startseq INTEGER   ENCODE az64
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (coveredrisk_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	coveredrisk_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_coveredrisk owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_coveredrisk IS 'DW Table type:';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_deductible;

--DROP TABLE fsbi_dw_uu.dim_deductible;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_deductible
(
	deductible_id INTEGER NOT NULL  ENCODE RAW
	,cov_deductible1 NUMERIC(13,2)   ENCODE az64
	,cov_deductible1type VARCHAR(50)   ENCODE lzo
	,cov_deductible2 NUMERIC(13,2)   ENCODE az64
	,cov_deductible2type VARCHAR(50)   ENCODE lzo
	,cov_deductible3 NUMERIC(13,2)   ENCODE az64
	,cov_deductible3type VARCHAR(50)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (deductible_id)
)
DISTSTYLE AUTO
 SORTKEY (
	deductible_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_deductible owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_deductible IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available deductibles from FSBI_STG_UU.stg_coverage ';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_discount;

--DROP TABLE fsbi_dw_uu.dim_discount;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_discount
(
	policy_id INTEGER NOT NULL  ENCODE RAW
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,multicardiscountind VARCHAR(1)   ENCODE lzo
	,paidinfulldiscountind VARCHAR(1)   ENCODE lzo
	,surepaydiscountind VARCHAR(1)   ENCODE lzo
	,preferredproviderdiscountind VARCHAR(1)   ENCODE lzo
	,civilserviceemployeediscountind VARCHAR(1)   ENCODE lzo
	,multipolicydiscountind VARCHAR(1)   ENCODE lzo
	,multipolicydiscountreason VARCHAR(100)   ENCODE lzo
	,increasedpriorlimitsdiscountind VARCHAR(1)   ENCODE lzo
	,totalabstainerdiscountind VARCHAR(1)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,loyaltydiscountind VARCHAR(20)   ENCODE bytedict
	,PRIMARY KEY (policy_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_discount owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_discount IS 'DW Table type: Dimension Type 1 Table description: discounts per policy term from FSBI_STG_UU.stg_discount. It''s a dim_policy extension in some sense. Use Policy_Id to join to fact tables';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_driver;

--DROP TABLE fsbi_dw_uu.dim_driver;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_driver
(
	driver_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,record_version INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,driver_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,drivertype VARCHAR(100) NOT NULL  ENCODE lzo
	,driverpoints INTEGER NOT NULL  ENCODE az64
	,drivergender VARCHAR(100) NOT NULL  ENCODE bytedict
	,drivermaritalstatus VARCHAR(100) NOT NULL  ENCODE bytedict
	,driverlicenseddate DATE NOT NULL  ENCODE az64
	,driverdob DATE NOT NULL  ENCODE az64
	,driveradddate DATE NOT NULL  ENCODE az64
	,driverremovedate DATE NOT NULL  ENCODE az64
	,insurancescore INTEGER NOT NULL  ENCODE az64
	,drivernewteendiscount VARCHAR(1) NOT NULL  ENCODE lzo
	,driveronyourowndiscount VARCHAR(1) NOT NULL  ENCODE lzo
	,drivergoodstudentdiscount VARCHAR(1) NOT NULL  ENCODE lzo
	,driverpermitdiscount VARCHAR(1) NOT NULL  ENCODE lzo
	,driverviolationfreediscount VARCHAR(1) NOT NULL  ENCODE lzo
	,sourcesystem VARCHAR(10) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_record_version INTEGER NOT NULL  ENCODE az64
	,audit_id INTEGER NOT NULL  ENCODE az64
	,PRIMARY KEY (driver_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	driver_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_driver owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_driver IS 'DW Table type: Slowly Changing Dimension Type 2 Table description: Driver info  from FSBI_STG_UU.stg_driver';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_examiner;

--DROP TABLE fsbi_dw_uu.dim_examiner;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_examiner
(
	examiner_id INTEGER NOT NULL  ENCODE RAW
	,name VARCHAR(100)   ENCODE lzo
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,examiner_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE az64
	,PRIMARY KEY (examiner_id)
)
DISTSTYLE AUTO
 SORTKEY (
	examiner_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_examiner owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_examiner IS 'DW Table type:  Dimension Type 1 (Dictionary)	Table description: Examiner info including email';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_geography;

--DROP TABLE fsbi_dw_uu.dim_geography;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_geography
(
	geography_id INTEGER NOT NULL  ENCODE RAW
	,geo_county VARCHAR(50)   ENCODE lzo
	,geo_city VARCHAR(50)   ENCODE lzo
	,geo_state VARCHAR(50)   ENCODE lzo
	,geo_postalcode VARCHAR(20)   ENCODE lzo
	,geo_country VARCHAR(50)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (geography_id)
)
DISTSTYLE AUTO
 SORTKEY (
	geography_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_geography owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_geography IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table of all state/county/city/postal code addresses from FSBI_STG_UU.stg_risk. Better use dim_address instead.';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_insured;

--DROP TABLE fsbi_dw_uu.dim_insured;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_insured
(
	insured_id INTEGER NOT NULL  ENCODE RAW
	,policy_id INTEGER NOT NULL  ENCODE az64
	,insured_role VARCHAR(50)   ENCODE lzo
	,fullname VARCHAR(200)   ENCODE lzo
	,commercialname VARCHAR(200)   ENCODE lzo
	,dob DATE   ENCODE az64
	,occupation VARCHAR(256)   ENCODE lzo
	,gender VARCHAR(10)   ENCODE bytedict
	,maritalstatus VARCHAR(256)   ENCODE bytedict
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,county VARCHAR(50)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,fax VARCHAR(20)   ENCODE lzo
	,mobile VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,jobtitle VARCHAR(100)   ENCODE lzo
	,insured_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,lenty_credit_score INTEGER   ENCODE az64
	,lenty_credit_tier INTEGER   ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (insured_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	insured_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_insured owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_insured IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Insured info  from FSBI_STG_UU.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_legalentity_other;

--DROP TABLE fsbi_dw_uu.dim_legalentity_other;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_legalentity_other
(
	legalentity_id INTEGER NOT NULL  ENCODE RAW
	,lenty_role VARCHAR(50)   ENCODE lzo
	,lenty_number VARCHAR(50)   ENCODE lzo
	,lenty_name1 VARCHAR(100)   ENCODE lzo
	,lenty_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (legalentity_id)
)
DISTSTYLE AUTO
 DISTKEY (legalentity_id)
 SORTKEY (
	lenty_role
	)
;
ALTER TABLE fsbi_dw_uu.dim_legalentity_other owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_legalentity_other IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: all other legalentity  info  from FSBI_STG_UU.stg_legalentity as company etc';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_limit;

--DROP TABLE fsbi_dw_uu.dim_limit;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_limit
(
	limit_id INTEGER NOT NULL  ENCODE RAW
	,cov_limit1 NUMERIC(13,2)   ENCODE az64
	,cov_limit1type VARCHAR(50)   ENCODE lzo
	,cov_limit2 NUMERIC(13,2)   ENCODE az64
	,cov_limit2type VARCHAR(50)   ENCODE lzo
	,cov_limit3 NUMERIC(13,2)   ENCODE az64
	,cov_limit3type VARCHAR(50)   ENCODE lzo
	,cov_limit4 NUMERIC(13,2)   ENCODE az64
	,cov_limit4type VARCHAR(50)   ENCODE lzo
	,cov_limit5 NUMERIC(13,2)   ENCODE az64
	,cov_limit5type VARCHAR(50)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (limit_id)
)
DISTSTYLE AUTO
 SORTKEY (
	limit_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_limit owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_limit IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available limits from FSBI_STG_UU.stg_coverage ';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_month;

--DROP TABLE fsbi_dw_uu.dim_month;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_month
(
	month_id INTEGER   ENCODE az64
	,mon_monthname VARCHAR(25)   ENCODE lzo
	,mon_monthabbr VARCHAR(4)   ENCODE lzo
	,mon_reportperiod VARCHAR(6)   ENCODE lzo
	,mon_monthinquarter INTEGER   ENCODE az64
	,mon_monthinyear INTEGER   ENCODE az64
	,mon_year INTEGER   ENCODE az64
	,mon_quarter INTEGER   ENCODE az64
	,mon_startdate DATE   ENCODE az64
	,mon_enddate DATE   ENCODE az64
	,mon_sequence INTEGER   ENCODE az64
	,mon_isodate VARCHAR(8)   ENCODE lzo
	,loaddate DATE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uu.dim_month owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_month IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: For backward compatibility only, not needed in new projects, all foreign keys (date fields) are integers in format YYYYMM. The same as in other schemas';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_policy;

--DROP TABLE fsbi_dw_uu.dim_policy;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_policy
(
	policy_id INTEGER NOT NULL  ENCODE RAW
	,pol_policynumber VARCHAR(50)   ENCODE lzo
	,pol_policynumbersuffix VARCHAR(10)   ENCODE bytedict
	,pol_originaleffectivedate DATE   ENCODE az64
	,pol_quoteddate DATE   ENCODE az64
	,pol_issueddate DATE   ENCODE az64
	,pol_masterstate VARCHAR(50)   ENCODE lzo
	,pol_mastercountry VARCHAR(50)   ENCODE lzo
	,pol_uniqueid VARCHAR(100)   ENCODE lzo
	,pol_effectivedate DATE   ENCODE az64
	,pol_expirationdate DATE   ENCODE az64
	,pol_canceldate DATE   ENCODE az64
	,pol_form VARCHAR(5)   ENCODE bytedict
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (policy_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_policy owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_policy IS 'DW Table type: Dimension Type 1 Table description: PolicyNumber, Version (pol_policynumbersuffix), State from FSBI_STG_UU.stg_policy';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_policytransactiontype;

--DROP TABLE fsbi_dw_uu.dim_policytransactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_policytransactiontype
(
	policytransactiontype_id INTEGER NOT NULL  ENCODE RAW
	,ptrans_4sightbicode VARCHAR(50)   ENCODE lzo
	,ptrans_code VARCHAR(50) NOT NULL  ENCODE lzo
	,ptrans_name VARCHAR(100) NOT NULL  ENCODE lzo
	,ptrans_description VARCHAR(256) NOT NULL  ENCODE lzo
	,ptrans_subcode VARCHAR(50) NOT NULL  ENCODE lzo
	,ptrans_subname VARCHAR(100) NOT NULL  ENCODE lzo
	,ptrans_subdescription VARCHAR(256) NOT NULL  ENCODE lzo
	,ptrans_writtenprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_commission VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_grosswrittenprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_originalwrittenprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_earnedprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_grossearnedprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_earnedcommission VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_manualwrittenprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_endorsementprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_auditprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_cancellationprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_reinstatementprem VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_taxes VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_fees VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary1 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary2 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary3 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary4 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary5 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary6 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary7 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary8 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary9 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary10 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary11 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary12 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary13 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary14 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary15 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary16 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary17 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary18 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary19 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary20 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary21 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary22 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary23 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary24 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary25 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary26 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary27 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary28 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary29 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary30 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary31 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary32 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary33 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary34 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary35 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary36 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary37 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary38 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary39 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary40 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary41 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary42 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary43 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary44 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary45 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary46 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary47 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary48 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary49 VARCHAR(1) NOT NULL  ENCODE lzo
	,ptrans_userdefinedsummary50 VARCHAR(1) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
 SORTKEY (
	policytransactiontype_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_policytransactiontype owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_policytransactiontype IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: DW special table from 4SightBI original setup';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_producer;

--DROP TABLE fsbi_dw_uu.dim_producer;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_producer
(
	producer_id INTEGER NOT NULL  ENCODE RAW
	,producer_role VARCHAR(50)   ENCODE lzo
	,producer_number VARCHAR(50)   ENCODE lzo
	,name VARCHAR(100)   ENCODE lzo
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,producer_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (producer_id)
)
DISTSTYLE AUTO
 SORTKEY (
	producer_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_producer owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_producer IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Producer(Agency) info  from FSBI_STG_UU.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_product;

--DROP TABLE fsbi_dw_uu.dim_product;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_product
(
	product_id INTEGER NOT NULL  ENCODE RAW
	,product_uniqueid VARCHAR(100)   ENCODE lzo
	,prdt_group VARCHAR(100)   ENCODE lzo
	,prdt_name VARCHAR(100)   ENCODE lzo
	,prdt_lob VARCHAR(50)   ENCODE lzo
	,prdt_description VARCHAR(2000)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (product_id)
)
DISTSTYLE AUTO
 SORTKEY (
	product_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_product owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_product IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: list of products awailable in UU DW';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_property;

--DROP TABLE fsbi_dw_uu.dim_property;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_property
(
	property_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,record_version INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,property_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,constructionclass VARCHAR(20) NOT NULL  ENCODE bytedict
	,numberofstories INTEGER NOT NULL  ENCODE az64
	,numberoffamilies INTEGER NOT NULL  ENCODE az64
	,owneroccupiedunits INTEGER NOT NULL  ENCODE az64
	,tenantoccupiedunits INTEGER NOT NULL  ENCODE az64
	,protectionclass INTEGER NOT NULL  ENCODE az64
	,rooftype VARCHAR(20) NOT NULL  ENCODE bytedict
	,squarefeet INTEGER NOT NULL  ENCODE az64
	,woodshakeroof VARCHAR(5) NOT NULL  ENCODE lzo
	,yearbuilt INTEGER NOT NULL  ENCODE az64
	,distofirehydrant INTEGER NOT NULL  ENCODE az64
	,distofirestation INTEGER NOT NULL  ENCODE az64
	,fireextinguisherind INTEGER NOT NULL  ENCODE az64
	,sprinklersystem INTEGER NOT NULL  ENCODE az64
	,units INTEGER NOT NULL  ENCODE az64
	,firescore INTEGER NOT NULL  ENCODE az64
	,usagetype INTEGER NOT NULL  ENCODE az64
	,crimewatch INTEGER NOT NULL  ENCODE az64
	,sourcesystem VARCHAR(10) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_record_version INTEGER NOT NULL  ENCODE az64
	,audit_id INTEGER NOT NULL  ENCODE az64
	,PRIMARY KEY (property_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	property_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_property owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_property IS 'DW Table type: Slowly Changing Dimension Type 2 Table description: Building info  from FSBI_STG_UU.stg_property';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_status;

--DROP TABLE fsbi_dw_uu.dim_status;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_status
(
	status_id INTEGER NOT NULL  ENCODE RAW
	,stat_4sightbistatuscd VARCHAR(50) NOT NULL  ENCODE lzo
	,stat_statuscd VARCHAR(50) NOT NULL  ENCODE lzo
	,stat_status VARCHAR(100) NOT NULL  ENCODE lzo
	,stat_substatuscd VARCHAR(50) NOT NULL  ENCODE lzo
	,stat_substatus VARCHAR(100) NOT NULL  ENCODE lzo
	,stat_category VARCHAR(50) NOT NULL  ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE az64
	,PRIMARY KEY (status_id)
)
DISTSTYLE AUTO
 SORTKEY (
	status_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_status owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_status IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: DW special table with policies and claims statuses';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_territory;

--DROP TABLE fsbi_dw_uu.dim_territory;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_territory
(
	territory_id INTEGER NOT NULL  ENCODE RAW
	,terr_code VARCHAR(5)   ENCODE lzo
	,terr_name VARCHAR(100)   ENCODE lzo
	,terr_category VARCHAR(50)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (territory_id)
)
DISTSTYLE AUTO
 SORTKEY (
	territory_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_territory owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_territory IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available territories and codes. Rare used.';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_time;

--DROP TABLE fsbi_dw_uu.dim_time;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_time
(
	time_id INTEGER   ENCODE az64
	,month_id INTEGER   ENCODE az64
	,tm_date DATE   ENCODE az64
	,tm_dayname VARCHAR(25)   ENCODE lzo
	,tm_dayabbr VARCHAR(4)   ENCODE lzo
	,tm_reportperiod VARCHAR(6)   ENCODE lzo
	,tm_isodate VARCHAR(8)   ENCODE lzo
	,tm_dayinweek INTEGER   ENCODE az64
	,tm_dayinmonth INTEGER   ENCODE az64
	,tm_dayinquarter INTEGER   ENCODE az64
	,tm_dayinyear INTEGER   ENCODE az64
	,tm_weekinmonth INTEGER   ENCODE az64
	,tm_weekinquarter INTEGER   ENCODE az64
	,tm_weekinyear INTEGER   ENCODE az64
	,tm_monthname VARCHAR(25)   ENCODE lzo
	,tm_monthabbr VARCHAR(4)   ENCODE lzo
	,tm_monthinquarter INTEGER   ENCODE az64
	,tm_monthinyear INTEGER   ENCODE az64
	,tm_quarter INTEGER   ENCODE az64
	,tm_year INTEGER   ENCODE az64
	,loaddate DATE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uu.dim_time owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_time IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: For backward compatibility only, not needed in new projects, all foreign keys are integers in format YYYYMMDD. The same as in other schemas';

-- Drop table

-- DROP TABLE fsbi_dw_uu.dim_vehicle;

--DROP TABLE fsbi_dw_uu.dim_vehicle;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.dim_vehicle
(
	vehicle_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,record_version INTEGER   ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,vehicle_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,vin VARCHAR(100) NOT NULL  ENCODE lzo
	,vehiclemake VARCHAR(100) NOT NULL  ENCODE bytedict
	,vehiclemodel VARCHAR(100) NOT NULL  ENCODE lzo
	,vehicleyear INTEGER NOT NULL  ENCODE az64
	,vehiclemileage INTEGER NOT NULL  ENCODE az64
	,vehiclevalueamount INTEGER NOT NULL  ENCODE az64
	,vehicleadddate DATE NOT NULL  ENCODE az64
	,vehicleremovedate DATE NOT NULL  ENCODE az64
	,vehicleisosymbols VARCHAR(100) NOT NULL  ENCODE lzo
	,vehicleuse VARCHAR(100) NOT NULL  ENCODE lzo
	,garagingzip VARCHAR(100) NOT NULL  ENCODE lzo
	,sourcesystem VARCHAR(10) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_record_version INTEGER NOT NULL  ENCODE az64
	,audit_id INTEGER NOT NULL DEFAULT 0 ENCODE az64
	,PRIMARY KEY (vehicle_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	vehicle_id
	)
;
ALTER TABLE fsbi_dw_uu.dim_vehicle owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.dim_vehicle IS 'DW Table type: Slowly Changing Dimension Type 2 Table description: Vehicle info  from FSBI_STG_UU.stg_vehicle';

-- Drop table

-- DROP TABLE fsbi_dw_uu.fact_claim;

--DROP TABLE fsbi_dw_uu.fact_claim;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.fact_claim
(
	claimsummary_id INTEGER NOT NULL  ENCODE az64
	,month_id INTEGER NOT NULL  ENCODE RAW
	,coverage_id INTEGER NOT NULL  ENCODE az64
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,adjuster_id INTEGER NOT NULL  ENCODE az64
	,claimant_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE az64
	,company_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,producer_id INTEGER NOT NULL  ENCODE az64
	,policymasterterritory_id INTEGER NOT NULL  ENCODE az64
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE az64
	,claim_id INTEGER NOT NULL  ENCODE az64
	,claimstatus_id INTEGER NOT NULL  ENCODE az64
	,claimlossgeography_id INTEGER NOT NULL  ENCODE az64
	,claimlossaddress_id INTEGER NOT NULL  ENCODE az64
	,datereported_id INTEGER NOT NULL  ENCODE az64
	,dateofloss_id INTEGER NOT NULL  ENCODE az64
	,openeddate_id INTEGER NOT NULL  ENCODE az64
	,closeddate_id INTEGER NOT NULL  ENCODE az64
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,limit_id INTEGER NOT NULL  ENCODE az64
	,deductible_id INTEGER NOT NULL  ENCODE az64
	,primaryrisk_id INTEGER NOT NULL  ENCODE az64
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE az64
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE az64
	,property_id INTEGER NOT NULL  ENCODE az64
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,loss_pd_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,loss_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,init_loss_rsrv_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,alc_exp_pd_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,alc_exp_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,ualc_exp_pd_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,ualc_exp_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_recv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_paid_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,salvage_recv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,salvage_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,dedrecov_recv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,dedrecov_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,loss_pd_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,loss_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,alc_exp_pd_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,alc_exp_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,ualc_exp_pd_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,ualc_exp_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_recv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_paid_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,salvage_recv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,salvage_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,dedrecov_recv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,dedrecov_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,loss_pd_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,loss_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,alc_exp_pd_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,alc_exp_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,ualc_exp_pd_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,ualc_exp_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_recv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,subro_paid_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,salvage_recv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,salvage_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,dedrecov_recv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,dedrecov_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,feat_days_open INTEGER NOT NULL  ENCODE az64
	,feat_days_open_itd INTEGER NOT NULL  ENCODE az64
	,feat_opened_in_month INTEGER NOT NULL  ENCODE az64
	,feat_closed_in_month INTEGER NOT NULL  ENCODE az64
	,feat_closed_without_pay INTEGER NOT NULL  ENCODE az64
	,feat_closed_with_pay INTEGER NOT NULL  ENCODE az64
	,clm_days_open INTEGER NOT NULL  ENCODE az64
	,clm_days_open_itd INTEGER NOT NULL  ENCODE az64
	,clm_opened_in_month INTEGER NOT NULL  ENCODE az64
	,clm_closed_in_month INTEGER NOT NULL  ENCODE az64
	,clm_closed_without_pay INTEGER NOT NULL  ENCODE az64
	,clm_closed_with_pay INTEGER NOT NULL  ENCODE az64
	,masterclaim INTEGER NOT NULL  ENCODE az64
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE az64
	,claim_uniqueid VARCHAR(100)   ENCODE lzo
	,examiner_id INTEGER  DEFAULT 6 ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_uu.fact_claim owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.fact_claim IS 'DW Table type: Fact Monthly Summary table Table description: Monthly claim summaries. Months are based on accounting dates. You need to aggregate amounts from this table. It''s calculated based on Fact_Claimtransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uu.fact_claim.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.adjuster_id IS 'Foreign Key (link)  to dim_adjuster.adjuster_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.claim_id IS 'Foreign Key (link)  to dim_claim.claim_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.claimstatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.claimlossgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.claimlossaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.datereported_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.dateofloss_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.openeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.closeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.property_id IS 'Foreign Key (link) to dim_property.property_id';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.claimnumber IS 'The number associated with this claim.  This is inserted into the fact table to do distinct counts.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.policy_uniqueid IS 'The policy unique ID that uniquely identifies each policy.  This value has been degenerated from the policy dimension table to provide unique counts and improved query performance.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.coverage_uniqueid IS 'The coverage unique ID that uniquely identifies each coverage.  This value has been degenerated from the coverage dimension table to provide improved performance when loading the warehouse.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.loss_pd_amt IS 'Loss(Indemnity) paid amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.loss_rsrv_chng_amt IS 'Change in the loss reserve(Outstanding case reserve) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.alc_exp_pd_amt IS 'Amount of allocated expenses(ALAE) paid (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.alc_exp_rsrv_chng_amt IS 'Change in allocated expense reserve(Outstanding ALAE reserve) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.ualc_exp_pd_amt IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.ualc_exp_rsrv_chng_amt IS 'Change in Defense & Cost Containment Expenses (DCCE) reserve amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.subro_recv_chng_amt IS 'Change in received(recovered) subrogation amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.subro_rsrv_chng_amt IS 'Change in reserve subrogation amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.salvage_recv_chng_amt IS 'Change in salvage received(recovered) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.salvage_rsrv_chng_amt IS 'Change in salvage reserve amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.loss_pd_amt_ytd IS 'Loss(Indemnity) paid amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.loss_rsrv_chng_amt_ytd IS 'Change in the loss reserve(Outstanding case reserve) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.alc_exp_pd_amt_ytd IS 'Amount of allocated expenses(ALAE) paid (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.alc_exp_rsrv_chng_amt_ytd IS 'Change in allocated expense reserve(Outstanding ALAE reserve) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.ualc_exp_pd_amt_ytd IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.ualc_exp_rsrv_chng_amt_ytd IS 'Change in Defense & Cost Containment Expenses (DCCE) reserve amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.subro_recv_chng_amt_ytd IS 'Change in received(recovered) subrogation amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.subro_rsrv_chng_amt_ytd IS 'Change in reserve subrogation amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.salvage_recv_chng_amt_ytd IS 'Change in salvage received(recovered) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.salvage_rsrv_chng_amt_ytd IS 'Change in salvage reserve amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.loss_pd_amt_itd IS 'Loss(Indemnity) paid amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.loss_rsrv_chng_amt_itd IS 'Loss reserve(Outstanding case reserve) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.alc_exp_pd_amt_itd IS 'Amount of allocated expenses(ALAE) paid (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.alc_exp_rsrv_chng_amt_itd IS 'Allocated expense reserve(Outstanding ALAE reserve) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.ualc_exp_pd_amt_itd IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.ualc_exp_rsrv_chng_amt_itd IS 'Defense & Cost Containment Expenses (DCCE) reserve amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.subro_recv_chng_amt_itd IS 'Change in received(recovered) subrogation amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.subro_rsrv_chng_amt_itd IS 'Amount of reserve subrogation  (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.salvage_recv_chng_amt_itd IS 'Change in salvage received(recovered) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.salvage_rsrv_chng_amt_itd IS 'Change in salvage reserve amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.feat_days_open IS 'Returns the number of days a claim feature has been open (month-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.feat_days_open_itd IS 'Returns the number of days a claim feature has been open (inception-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.feat_opened_in_month IS 'Indicates if the claim feature was opened in the month.  1 = Opened In the Month, 0 = Not Opened in the Month.  The field can be summed to get the number of claim  features opened in a given month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.feat_closed_in_month IS 'Indicates if the claim feature was closed in the month.  1 = Closed In the Month, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed in a given month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.feat_closed_without_pay IS 'Indicates if the claim feature was closed in the month and had no losses paid on it.  1 = Closed In the Month without Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed in a given month without pay.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.feat_closed_with_pay IS 'Indicates if the claim feature was closed with losses paid in the month.  1 = Closed In the Month with Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed with pay in a given month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.clm_days_open IS 'Returns the number of days a claim has been open (month-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.clm_days_open_itd IS 'Returns the number of days a claim has been open (inception-to-date)';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.clm_opened_in_month IS 'Indicates if the claim was opened in the month.  1 = Opened In the Month, 0 = Not Opened in the Month.  The field can be summed to get the number of claims opened in a given month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.clm_closed_in_month IS 'Indicates if the claim was closed in the month.  1 = Closed In the Month, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed in a given month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.clm_closed_without_pay IS 'Indicates if the claim was closed in the month and had no losses paid on it.  1 = Closed In the Month without Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed in a given month without pay.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.clm_closed_with_pay IS 'Indicates if the claim was closed with losses paid in the month.  1 = Closed In the Month with Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed with pay in a given month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.masterclaim IS 'Indicates that this is the master record for the claim - the record that contains the overall claim status counts';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.claim_uniqueid IS 'The claim unique ID that uniquely identifies each claim.  This value has been degenerated from the claim dimension table to provide unique counts and improved query performance.';
COMMENT ON COLUMN fsbi_dw_uu.fact_claim.examiner_id IS 'Foreign Key (link) to dim_examiner.examiner_id';

-- Drop table

-- DROP TABLE fsbi_dw_uu.fact_claimcatastrophe_rel;

--DROP TABLE fsbi_dw_uu.fact_claimcatastrophe_rel;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.fact_claimcatastrophe_rel
(
	claim_id BIGINT NOT NULL  ENCODE RAW
	,catastrophe_id INTEGER NOT NULL  ENCODE RAW
	,clmcat_manuallyadded BOOLEAN NOT NULL  ENCODE RAW
	,clmcat_addeddate DATE   ENCODE lzo
	,clmcat_updatedby VARCHAR(50)   ENCODE lzo
	,clmcat_changeddate DATE   ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uu.fact_claimcatastrophe_rel owner to emiller;

-- Drop table

-- DROP TABLE fsbi_dw_uu.fact_claimtransaction;

--DROP TABLE fsbi_dw_uu.fact_claimtransaction;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.fact_claimtransaction
(
	claimtransaction_id INTEGER NOT NULL  ENCODE az64
	,transactiondate_id INTEGER NOT NULL  ENCODE az64
	,accountingdate_id INTEGER NOT NULL  ENCODE RAW
	,claimtransactiontype_id INTEGER NOT NULL  ENCODE az64
	,adjuster_id INTEGER NOT NULL  ENCODE az64
	,claimant_id INTEGER NOT NULL  ENCODE az64
	,producer_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE az64
	,company_id INTEGER NOT NULL  ENCODE az64
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,claim_id INTEGER NOT NULL  ENCODE az64
	,claimstatus_id INTEGER NOT NULL  ENCODE az64
	,claimlossgeography_id INTEGER NOT NULL  ENCODE az64
	,claimlossaddress_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,coverage_id INTEGER NOT NULL  ENCODE az64
	,limit_id INTEGER NOT NULL  ENCODE az64
	,deductible_id INTEGER NOT NULL  ENCODE az64
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,openeddate_id INTEGER NOT NULL  ENCODE az64
	,closeddate_id INTEGER NOT NULL  ENCODE az64
	,datereported_id INTEGER NOT NULL  ENCODE az64
	,dateofloss_id INTEGER NOT NULL  ENCODE az64
	,policymasterterritory_id INTEGER NOT NULL  ENCODE az64
	,primaryrisk_id INTEGER NOT NULL  ENCODE az64
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE az64
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE az64
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE az64
	,property_id INTEGER NOT NULL  ENCODE az64
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,claimtransaction_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,transactionsequence BIGINT NOT NULL  ENCODE az64
	,transactionflag VARCHAR(1) NOT NULL  ENCODE lzo
	,transactionstatus VARCHAR(50) NOT NULL  ENCODE lzo
	,transactionrollup VARCHAR(1) NOT NULL  ENCODE lzo
	,transactiondeleted VARCHAR(1) NOT NULL  ENCODE lzo
	,currentrecord VARCHAR(1) NOT NULL  ENCODE lzo
	,amount NUMERIC(13,2) NOT NULL  ENCODE az64
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE az64
	,examiner_id INTEGER  DEFAULT 6 ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	accountingdate_id
	)
;
ALTER TABLE fsbi_dw_uu.fact_claimtransaction owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.fact_claimtransaction IS 'DW Table type: Fact table Table description: Claim transactions from FSBI_STG_UU.stg_claimtransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.transactiondate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.accountingdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.claimtransactiontype_id IS 'Foreign Key (link)  to dim_claimtransactiontype.claimtransactiontype_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.adjuster_id IS 'Foreign Key (link)  to dim_adjuster.adjuster_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.claim_id IS 'Foreign Key (link)  to dim_claim.claim_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.claimstatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.claimlossgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.claimlossaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.openeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.closeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.datereported_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.dateofloss_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.property_id IS 'Foreign Key (link) to dim_property.property_id';
COMMENT ON COLUMN fsbi_dw_uu.fact_claimtransaction.examiner_id IS 'Foreign Key (link) to dim_examiner.examiner_id';

-- Drop table

-- DROP TABLE fsbi_dw_uu.fact_policy;

--DROP TABLE fsbi_dw_uu.fact_policy;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.fact_policy
(
	factpolicy_id INTEGER NOT NULL  ENCODE az64
	,month_id INTEGER NOT NULL  ENCODE RAW
	,producer_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE az64
	,company_id INTEGER NOT NULL  ENCODE az64
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,policystatus_id INTEGER NOT NULL  ENCODE az64
	,policymasterterritory_id INTEGER NOT NULL  ENCODE az64
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,earned_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,earned_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,earned_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,unearned_prem NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_uu.fact_policy owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.fact_policy IS 'DW Table type: Fact Monthly Summary table Table description: Monthly summaries at policy term level. Months are based on accounting dates . It''s calculated based on Fact_PolicyCoverage';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uu.fact_policy.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.policystatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.wrtn_prem_amt IS 'Month-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.wrtn_prem_amt_ytd IS 'Year-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.wrtn_prem_amt_itd IS 'Inception-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.term_prem_amt IS 'Full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.term_prem_amt_ytd IS 'Year-to-date full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.term_prem_amt_itd IS 'Inception-to-date Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.earned_prem_amt IS 'Month-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.earned_prem_amt_ytd IS 'Year-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.earned_prem_amt_itd IS 'Inception-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.fees_amt IS 'Month-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.fees_amt_ytd IS 'Year-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.fees_amt_itd IS 'Inception-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.cncl_prem_amt IS 'Month-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.cncl_prem_amt_ytd IS 'Year-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policy.cncl_prem_amt_itd IS 'Inception-to-date cancellation premium amount. ';

-- Drop table

-- DROP TABLE fsbi_dw_uu.fact_policycoverage;

--DROP TABLE fsbi_dw_uu.fact_policycoverage;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.fact_policycoverage
(
	factpolicycoverage_id INTEGER NOT NULL  ENCODE az64
	,month_id INTEGER NOT NULL  ENCODE RAW
	,producer_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE az64
	,company_id INTEGER NOT NULL  ENCODE az64
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,policystatus_id INTEGER NOT NULL  ENCODE az64
	,coverage_id INTEGER NOT NULL  ENCODE az64
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,policymasterterritory_id INTEGER NOT NULL  ENCODE az64
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE az64
	,limit_id INTEGER NOT NULL  ENCODE az64
	,deductible_id INTEGER NOT NULL  ENCODE az64
	,primaryrisk_id INTEGER NOT NULL  ENCODE az64
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE az64
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE az64
	,property_id INTEGER NOT NULL  ENCODE az64
	,month_property_id INTEGER NOT NULL  ENCODE az64
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,month_vehicle_id INTEGER NOT NULL  ENCODE az64
	,month_driver_id INTEGER NOT NULL  ENCODE az64
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,earned_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,earned_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,earned_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,unearned_prem NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,we INTEGER   ENCODE az64
	,ee INTEGER   ENCODE az64
	,we_ytd INTEGER   ENCODE az64
	,ee_ytd INTEGER   ENCODE az64
	,we_itd INTEGER   ENCODE az64
	,ee_itd INTEGER   ENCODE az64
	,we_rm NUMERIC(38,4)   ENCODE az64
	,ee_rm NUMERIC(38,4)   ENCODE az64
	,we_rm_ytd NUMERIC(38,4)   ENCODE az64
	,ee_rm_ytd NUMERIC(38,4)   ENCODE az64
	,we_rm_itd NUMERIC(38,4)   ENCODE az64
	,ee_rm_itd NUMERIC(38,4)   ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_uu.fact_policycoverage owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.fact_policycoverage IS 'DW Table type: Fact Monthly Summary table Table description: Monthly summaries at coverage level plus monthly policy state of coverages and risks (limits, deductibles) Months are based on accounting dates. You need to aggregate amounts from this table.  It''s calculated based on Fact_Policytransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.policystatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.property_id IS 'Foreign Key (link) to dim_property.property_id Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active.';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.month_property_id IS 'Foreign Key (link) to dim_property.property_id Use this column to get attributes effective at the end of the specific month.';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.month_vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the end of the specific month. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.month_driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the end of the specific month. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.wrtn_prem_amt IS 'Month-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.wrtn_prem_amt_ytd IS 'Year-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.wrtn_prem_amt_itd IS 'Inception-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.term_prem_amt IS 'Full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.term_prem_amt_ytd IS 'Year-to-date Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.term_prem_amt_itd IS 'Inception-to-date full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.earned_prem_amt IS 'Month-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.earned_prem_amt_ytd IS 'Year-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.earned_prem_amt_itd IS 'Inception-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.fees_amt IS 'Month-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.fees_amt_ytd IS 'Year-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.fees_amt_itd IS 'Inception-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.cncl_prem_amt IS 'Month-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.cncl_prem_amt_ytd IS 'Year-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.cncl_prem_amt_itd IS 'Inception-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.we IS 'Written Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.ee IS 'Earned Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.we_ytd IS 'Year To Date Written Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.ee_ytd IS 'Year To Date Earned Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.we_itd IS 'Inception To Date Written Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_uu.fact_policycoverage.ee_itd IS 'Inception To Date Earned Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';

-- Drop table

-- DROP TABLE fsbi_dw_uu.fact_policytransaction;

--DROP TABLE fsbi_dw_uu.fact_policytransaction;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.fact_policytransaction
(
	policytransaction_id INTEGER NOT NULL  ENCODE az64
	,transactiondate_id INTEGER NOT NULL  ENCODE az64
	,accountingdate_id INTEGER NOT NULL  ENCODE RAW
	,effectivedate_id INTEGER NOT NULL  ENCODE az64
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE az64
	,company_id INTEGER NOT NULL  ENCODE az64
	,policymasterterritory_id INTEGER NOT NULL  ENCODE az64
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE az64
	,policytransactiontype_id INTEGER NOT NULL  ENCODE az64
	,producer_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,coverage_id INTEGER NOT NULL  ENCODE az64
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,limit_id INTEGER NOT NULL  ENCODE az64
	,deductible_id INTEGER NOT NULL  ENCODE az64
	,earnfromdate_id INTEGER NOT NULL  ENCODE az64
	,primaryrisk_id INTEGER NOT NULL  ENCODE az64
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE az64
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE az64
	,earntodate_id INTEGER NOT NULL  ENCODE az64
	,property_id INTEGER NOT NULL  ENCODE az64
	,trn_property_id INTEGER NOT NULL  ENCODE az64
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,trn_vehicle_id INTEGER NOT NULL  ENCODE az64
	,trn_driver_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,policytransaction_uniqueid VARCHAR(200) NOT NULL  ENCODE lzo
	,transactionsequence INTEGER NOT NULL  ENCODE az64
	,amount NUMERIC(13,2)   ENCODE az64
	,term_amount NUMERIC(13,2)   ENCODE az64
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	accountingdate_id
	)
;
ALTER TABLE fsbi_dw_uu.fact_policytransaction owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.fact_policytransaction IS 'DW Table type: Fact table Table description: Policy transactions from FSBI_STG_UU.stg_policytransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.transactiondate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.accountingdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.effectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.policytransactiontype_id IS 'Foreign Key (link)  to dim_policytransactiontype.policytransactiontype_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.property_id IS 'Foreign Key (link) to dim_property.property_id Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active.';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.trn_property_id IS 'Foreign Key (link) to dim_property.property_id Use this column to get attributes effective at the moment of the specific transaction.';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.trn_vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	 Use this column to get attributes effective at the moment of the specific transaction';
COMMENT ON COLUMN fsbi_dw_uu.fact_policytransaction.trn_driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	 Use this column to get attributes effective at the moment of the specific transaction';

-- Drop table

-- DROP TABLE fsbi_dw_uu.stg_exposures;

--DROP TABLE fsbi_dw_uu.stg_exposures;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.stg_exposures
(
	factpolicycoverage_id BIGINT   ENCODE az64
	,month_id INTEGER   ENCODE lzo
	,policy_id INTEGER   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,coverage_id INTEGER   ENCODE lzo
	,coverage_uniqueid VARCHAR(100)   ENCODE lzo
	,we INTEGER   ENCODE lzo
	,ee INTEGER   ENCODE lzo
	,we_ytd INTEGER   ENCODE lzo
	,ee_ytd INTEGER   ENCODE lzo
	,we_itd INTEGER   ENCODE lzo
	,ee_itd INTEGER   ENCODE lzo
	,we_rm NUMERIC(38,4)   ENCODE lzo
	,ee_rm NUMERIC(38,4)   ENCODE lzo
	,we_rm_ytd NUMERIC(38,4)   ENCODE lzo
	,ee_rm_ytd NUMERIC(38,4)   ENCODE lzo
	,we_rm_itd NUMERIC(38,4)   ENCODE lzo
	,ee_rm_itd NUMERIC(38,4)   ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_uu.stg_exposures owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.stg_exposures IS 'Staging table to keep intermitten exposure results';

-- Drop table

-- DROP TABLE fsbi_dw_uu.vmfact_claim_blended;

--DROP TABLE fsbi_dw_uu.vmfact_claim_blended;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.vmfact_claim_blended
(
	month_id INTEGER   ENCODE az64
	,claim_number VARCHAR(50)   ENCODE lzo
	,catastrophe_id INTEGER   ENCODE az64
	,claimant VARCHAR(50)   ENCODE bytedict
	,feature VARCHAR(75)   ENCODE bytedict
	,feature_desc VARCHAR(125)   ENCODE bytedict
	,feature_type VARCHAR(100)   ENCODE bytedict
	,aslob VARCHAR(5)   ENCODE bytedict
	,rag VARCHAR(3)   ENCODE bytedict
	,schedp_part CHAR(2)   ENCODE lzo
	,loss_paid NUMERIC(38,2)   ENCODE az64
	,loss_reserve NUMERIC(38,2)   ENCODE az64
	,aoo_paid NUMERIC(38,2)   ENCODE az64
	,aoo_reserve NUMERIC(38,2)   ENCODE az64
	,dcc_paid NUMERIC(38,2)   ENCODE az64
	,dcc_reserve NUMERIC(38,2)   ENCODE az64
	,salvage_received NUMERIC(38,2)   ENCODE az64
	,salvage_reserve NUMERIC(38,2)   ENCODE az64
	,subro_received NUMERIC(38,2)   ENCODE az64
	,subro_reserve NUMERIC(38,2)   ENCODE az64
	,product_code VARCHAR(100)   ENCODE bytedict
	,product VARCHAR(100)   ENCODE bytedict
	,subproduct VARCHAR(100)   ENCODE bytedict
	,carrier VARCHAR(100)   ENCODE lzo
	,carrier_group VARCHAR(9)   ENCODE lzo
	,company VARCHAR(50)   ENCODE lzo
	,policy_state VARCHAR(75)   ENCODE lzo
	,policy_number VARCHAR(75)   ENCODE lzo
	,policy_id INTEGER   ENCODE az64
	,poleff_date DATE   ENCODE az64
	,polexp_date DATE   ENCODE az64
	,producer_code VARCHAR(50)   ENCODE lzo
	,loss_date DATE   ENCODE az64
	,loss_year INTEGER   ENCODE az64
	,reported_date DATE   ENCODE az64
	,loss_cause VARCHAR(255)   ENCODE bytedict
	,source_system VARCHAR(100)   ENCODE lzo
	,iseco BOOLEAN  DEFAULT false ENCODE RAW
	,elr VARCHAR(32)   ENCODE bytedict
	,coverage_id_original INTEGER   ENCODE az64
	,dateofloss_id_original INTEGER   ENCODE az64
	,fin_source_id VARCHAR(3)   ENCODE lzo
	,fin_company_id VARCHAR(2)   ENCODE lzo
	,fin_location_id VARCHAR(4)   ENCODE lzo
	,fin_product_id VARCHAR(3)   ENCODE bytedict
	,businesssource VARCHAR(16)   ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 DISTKEY (month_id)
;
ALTER TABLE fsbi_dw_uu.vmfact_claim_blended owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uu.vmfact_claim_blended IS 'Monthly summaries of fsbi_dw_uu.vmfact_claimtransaction_blended based on month of acct_date';

-- Drop table

-- DROP TABLE fsbi_dw_uu.vmfact_claimtransaction_blended;

--DROP TABLE fsbi_dw_uu.vmfact_claimtransaction_blended;
CREATE TABLE IF NOT EXISTS fsbi_dw_uu.vmfact_claimtransaction_blended
(
	claimtransaction_id INTEGER   ENCODE RAW
	,source_system VARCHAR(5)   ENCODE RAW
	,businesssource VARCHAR(16)   ENCODE bytedict
	,trans_date DATE   ENCODE RAW
	,acct_date DATE   ENCODE RAW
	,claim_number VARCHAR(16)   ENCODE RAW
	,claimant VARCHAR(3)   ENCODE bytedict
	,feature VARCHAR(32)   ENCODE bytedict
	,feature_desc VARCHAR(64)   ENCODE bytedict
	,feature_type VARCHAR(1)   ENCODE lzo
	,aslob VARCHAR(3)   ENCODE bytedict
	,catastrophe_id INTEGER   ENCODE az64
	,iseco BOOLEAN   ENCODE RAW
	,rag VARCHAR(3)   ENCODE bytedict
	,elr VARCHAR(32)   ENCODE bytedict
	,schedp_part CHAR(2)   ENCODE bytedict
	,ctrans_code VARCHAR(32)   ENCODE lzo
	,ctrans_name VARCHAR(32)   ENCODE lzo
	,ctrans_subcode VARCHAR(8)   ENCODE lzo
	,ctrans_subname VARCHAR(64)   ENCODE lzo
	,loss_paid NUMERIC(18,2)   ENCODE az64
	,loss_reserve NUMERIC(18,2)   ENCODE az64
	,aoo_paid NUMERIC(18,2)   ENCODE az64
	,aoo_reserve NUMERIC(18,2)   ENCODE az64
	,dcc_paid NUMERIC(18,2)   ENCODE az64
	,dcc_reserve NUMERIC(18,2)   ENCODE az64
	,salvage_received NUMERIC(18,2)   ENCODE az64
	,salvage_reserve NUMERIC(18,2)   ENCODE az64
	,subro_received NUMERIC(18,2)   ENCODE az64
	,subro_reserve NUMERIC(18,2)   ENCODE az64
	,product_code VARCHAR(32)   ENCODE bytedict
	,product VARCHAR(32)   ENCODE bytedict
	,subproduct VARCHAR(32)   ENCODE bytedict
	,carrier VARCHAR(6)   ENCODE bytedict
	,carrier_group VARCHAR(9)   ENCODE bytedict
	,company VARCHAR(4)   ENCODE bytedict
	,prdt_lob_code VARCHAR(32)   ENCODE bytedict
	,prdt_lob_name VARCHAR(32)   ENCODE bytedict
	,prdt_lob_type VARCHAR(16)   ENCODE bytedict
	,prdt_state CHAR(2)   ENCODE bytedict
	,carr_code VARCHAR(6)   ENCODE bytedict
	,carr_abbr CHAR(3)   ENCODE bytedict
	,prdt_selectorpreferred VARCHAR(9)   ENCODE lzo
	,prdt_code VARCHAR(32)   ENCODE bytedict
	,prdt_name VARCHAR(32)   ENCODE bytedict
	,policy_state VARCHAR(2)   ENCODE lzo
	,policy_number VARCHAR(16)   ENCODE lzo
	,policyref INTEGER   ENCODE az64
	,poleff_date DATE   ENCODE az64
	,polexp_date DATE   ENCODE az64
	,producer_code VARCHAR(16)   ENCODE lzo
	,loss_date DATE   ENCODE az64
	,loss_year INTEGER   ENCODE az64
	,reported_date DATE   ENCODE az64
	,loss_cause VARCHAR(32)   ENCODE bytedict
	,changetype VARCHAR(5)   ENCODE lzo
	,claimtransactiontype_id_original INTEGER   ENCODE az64
	,coverage_id_original INTEGER   ENCODE az64
	,dateofloss_id_original INTEGER   ENCODE az64
	,amount_original NUMERIC(13,2)   ENCODE az64
	,fin_source_id VARCHAR(3)   ENCODE lzo
	,fin_company_id VARCHAR(2)   ENCODE lzo
	,fin_location_id VARCHAR(4)   ENCODE lzo
	,fin_product_id VARCHAR(3)   ENCODE bytedict
	,policy_id INTEGER   ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (claimtransaction_id)
;
ALTER TABLE fsbi_dw_uu.vmfact_claimtransaction_blended owner to emiller;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_accountingdate
AS SELECT dim_time.time_id AS accountingdate_id, dim_time.tm_date AS acct_date, dim_time.tm_dayname AS acct_dayname, dim_time.tm_dayabbr AS acct_dayabbr, dim_time.tm_dayinweek AS acct_dayinweek, dim_time.tm_dayinmonth AS acct_dayinmonth, dim_time.tm_dayinquarter AS acct_dayinquarter, dim_time.tm_dayinyear AS acct_dayinyear, dim_time.tm_weekinmonth AS acct_weekinmonth, dim_time.tm_weekinquarter AS acct_weekinquarter, dim_time.tm_weekinyear AS acct_weekinyear, dim_time.tm_monthname AS acct_monthname, dim_time.tm_monthabbr AS acct_monthabbr, dim_time.tm_monthinquarter AS acct_monthinquarter, dim_time.tm_monthinyear AS acct_monthinyear, dim_time.tm_quarter AS acct_quarter, dim_time.tm_year AS acct_year, dim_time.tm_reportperiod AS acct_reportperiod, dim_time.tm_isodate AS acct_isodate, dim_time.month_id AS acct_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_agingstartdate
AS SELECT dim_time.time_id AS agingstartdate_id, dim_time.tm_date AS asdt_date, dim_time.tm_dayname AS asdt_dayname, dim_time.tm_dayabbr AS asdt_dayabbr, dim_time.tm_dayinweek AS asdt_dayinweek, dim_time.tm_dayinmonth AS asdt_dayinmonth, dim_time.tm_dayinquarter AS asdt_dayinquarter, dim_time.tm_dayinyear AS asdt_dayinyear, dim_time.tm_weekinmonth AS asdt_weekinmonth, dim_time.tm_weekinquarter AS asdt_weekinquarter, dim_time.tm_weekinyear AS asdt_weekinyear, dim_time.tm_monthname AS asdt_monthname, dim_time.tm_monthabbr AS asdt_monthabbr, dim_time.tm_monthinquarter AS asdt_monthinquarter, dim_time.tm_monthinyear AS asdt_monthinyear, dim_time.tm_quarter AS asdt_quarter, dim_time.tm_year AS asdt_year, dim_time.tm_reportperiod AS asdt_reportperiod, dim_time.tm_isodate AS asdt_isodate, dim_time.month_id AS asdt_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_bookeffectivedate
AS SELECT dim_time.time_id AS bookeffectivedate_id, dim_time.tm_date AS bkeff_date, dim_time.tm_dayname AS bkeff_dayname, dim_time.tm_dayabbr AS bkeff_dayabbr, dim_time.tm_dayinweek AS bkeff_dayinweek, dim_time.tm_dayinmonth AS bkeff_dayinmonth, dim_time.tm_dayinquarter AS bkeff_dayinquarter, dim_time.tm_dayinyear AS bkeff_dayinyear, dim_time.tm_weekinmonth AS bkeff_weekinmonth, dim_time.tm_weekinquarter AS bkeff_weekinquarter, dim_time.tm_weekinyear AS bkeff_weekinyear, dim_time.tm_monthname AS bkeff_monthname, dim_time.tm_monthabbr AS bkeff_monthabbr, dim_time.tm_monthinquarter AS bkeff_monthinquarter, dim_time.tm_monthinyear AS bkeff_monthinyear, dim_time.tm_quarter AS bkeff_quarter, dim_time.tm_year AS bkeff_year, dim_time.tm_reportperiod AS bkeff_reportperiod, dim_time.tm_isodate AS bkeff_isodate, dim_time.month_id AS bkeff_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding

;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_bookexpirationdate
AS SELECT dim_time.time_id AS bookexpirationdate_id, dim_time.tm_date AS bkexp_date, dim_time.tm_dayname AS bkexp_dayname, dim_time.tm_dayabbr AS bkexp_dayabbr, dim_time.tm_dayinweek AS bkexp_dayinweek, dim_time.tm_dayinmonth AS bkexp_dayinmonth, dim_time.tm_dayinquarter AS bkexp_dayinquarter, dim_time.tm_dayinyear AS bkexp_dayinyear, dim_time.tm_weekinmonth AS bkexp_weekinmonth, dim_time.tm_weekinquarter AS bkexp_weekinquarter, dim_time.tm_weekinyear AS bkexp_weekinyear, dim_time.tm_monthname AS bkexp_monthname, dim_time.tm_monthabbr AS bkexp_monthabbr, dim_time.tm_monthinquarter AS bkexp_monthinquarter, dim_time.tm_monthinyear AS bkexp_monthinyear, dim_time.tm_quarter AS bkexp_quarter, dim_time.tm_year AS bkexp_year, dim_time.tm_reportperiod AS bkexp_reportperiod, dim_time.tm_isodate AS bkexp_isodate, dim_time.month_id AS bkexp_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE VIEW fsbi_dw_uu.vdim_claimant
AS select
	dim_legalentity.claimant_id
--XX	, dim_legalentity.claimant_role as clmnt_role
--XX	, dim_legalentity.claimant_type as clmnt_type
	, dim_legalentity.claimant_number as clmnt_number
	, dim_legalentity.name as clmnt_name1
	, dim_legalentity.name as clmnt_fullname
--XX	, dim_legalentity.dob as clmnt_dob
--XX	, dim_legalentity.occupation as clmnt_occupation
--XX	, dim_legalentity.gender as clmnt_gender
--XX	, dim_legalentity.maritalstatus as clmnt_maritalstatus
	, dim_legalentity.address1 as clmnt_address1
	, dim_legalentity.address2 as clmnt_address2
	, dim_legalentity.city as clmnt_city
	, dim_legalentity.state as clmnt_state
	, dim_legalentity.postalcode as clmnt_postalcode
	, dim_legalentity.country as clmnt_country
	, dim_legalentity.telephone as clmnt_telephone
--XX	, dim_legalentity.fax as clmnt_fax
	, dim_legalentity.email as clmnt_email
--XX	, dim_legalentity.jobtitle as clmnt_jobtitle
	, dim_legalentity.claimant_uniqueid as clmnt_uniqueid
	, dim_legalentity.source_system
	, dim_legalentity.loaddate
from
	fsbi_dw_uu.dim_claimant dim_legalentity
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_claimstatus
AS SELECT dim_status.status_id AS claimstatus_id, dim_status.stat_4sightbistatuscd AS clmst_4sightbistatuscd, dim_status.stat_statuscd AS clmst_statuscd, dim_status.stat_status AS clmst_status, dim_status.stat_substatuscd AS clmst_substatuscd, dim_status.stat_substatus AS clmst_substatus
   FROM fsbi_dw_uu.dim_status
  WHERE dim_status.stat_category::text = 'claim'::character varying::text;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_closedate
AS SELECT dim_time.time_id AS closeddate_id, dim_time.tm_date AS clsdt_date, dim_time.tm_dayname AS clsdt_dayname, dim_time.tm_dayabbr AS clsdt_dayabbr, dim_time.tm_dayinweek AS clsdt_dayinweek, dim_time.tm_dayinmonth AS clsdt_dayinmonth, dim_time.tm_dayinquarter AS clsdt_dayinquarter, dim_time.tm_dayinyear AS clsdt_dayinyear, dim_time.tm_weekinmonth AS clsdt_weekinmonth, dim_time.tm_weekinquarter AS clsdt_weekinquarter, dim_time.tm_weekinyear AS clsdt_weekinyear, dim_time.tm_monthname AS clsdt_monthname, dim_time.tm_monthabbr AS clsdt_monthabbr, dim_time.tm_monthinquarter AS clsdt_monthinquarter, dim_time.tm_monthinyear AS clsdt_monthinyear, dim_time.tm_quarter AS clsdt_quarter, dim_time.tm_year AS clsdt_year, dim_time.tm_reportperiod AS clsdt_reportperiod, dim_time.tm_isodate AS clsdt_isodate, dim_time.month_id AS clsdt_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_company
AS SELECT dim_legalentity.legalentity_id AS company_id, dim_legalentity.lenty_role AS comp_role, dim_legalentity.lenty_number AS comp_number, dim_legalentity.lenty_name1 AS comp_name1, dim_legalentity.lenty_uniqueid AS comp_uniqueid, dim_legalentity.source_system, dim_legalentity.loaddate
   FROM fsbi_dw_uu.dim_legalentity_other dim_legalentity
  WHERE dim_legalentity.lenty_role::text = 'COMPANY'::character varying::text;

COMMENT ON VIEW fsbi_dw_uu.vdim_company IS 'DW Table type: Dimension Table description: There is only company because the physical table dim_legalentity_other contains few entities with very small number of records';

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_coverage
AS SELECT dim_coverage.coverage_id, 
        CASE
            WHEN dim_coverage.cov_code::text !~~* '%fee'::text AND (dim_coverage.cov_code::text = 'MEDICAL'::text OR dim_coverage.cov_code::text = 'PERSONAL_LIA'::text OR dim_coverage.cov_code::text = 'UMBRELLA'::text OR dim_coverage.cov_asl::text = 192::text) THEN 'Casualty'::text
            WHEN dim_coverage.cov_code::text ~~* '%fee'::text THEN 'Other'::text
            WHEN dim_coverage.cov_code::text = '~'::text THEN '~'::text
            WHEN dim_coverage.cov_code::text = 'UNK'::text THEN 'UNK'::text
            ELSE 'Property'::text
        END AS cov_type, dim_coverage.cov_code, dim_coverage.cov_name, dim_coverage.cov_description, dim_coverage.cov_subcode, dim_coverage.cov_subcodename, dim_coverage.cov_subcodedescription, dim_coverage.cov_asl, dim_coverage.cov_subline, dim_coverage.loaddate
   FROM fsbi_dw_uu.dim_coverage;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_coverageeffectivedate
AS SELECT dim_time.time_id AS coverageeffectivedate_id, dim_time.tm_date AS coveff_date, dim_time.tm_dayname AS coveff_dayname, dim_time.tm_dayabbr AS coveff_dayabbr, dim_time.tm_dayinweek AS coveff_dayinweek, dim_time.tm_dayinmonth AS coveff_dayinmonth, dim_time.tm_dayinquarter AS coveff_dayinquarter, dim_time.tm_dayinyear AS coveff_dayinyear, dim_time.tm_weekinmonth AS coveff_weekinmonth, dim_time.tm_weekinquarter AS coveff_weekinquarter, dim_time.tm_weekinyear AS coveff_weekinyear, dim_time.tm_monthname AS coveff_monthname, dim_time.tm_monthabbr AS coveff_monthabbr, dim_time.tm_monthinquarter AS coveff_monthinquarter, dim_time.tm_monthinyear AS coveff_monthinyear, dim_time.tm_quarter AS coveff_quarter, dim_time.tm_year AS coveff_year, dim_time.tm_reportperiod AS coveff_reportperiod, dim_time.tm_isodate AS coveff_isodate, dim_time.month_id AS coveff_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_coverageexpirationdate
AS SELECT dim_time.time_id AS coverageexpirationdate_id, dim_time.tm_date AS covexp_date, dim_time.tm_dayname AS covexp_dayname, dim_time.tm_dayabbr AS covexp_dayabbr, dim_time.tm_dayinweek AS covexp_dayinweek, dim_time.tm_dayinmonth AS covexp_dayinmonth, dim_time.tm_dayinquarter AS covexp_dayinquarter, dim_time.tm_dayinyear AS covexp_dayinyear, dim_time.tm_weekinmonth AS covexp_weekinmonth, dim_time.tm_weekinquarter AS covexp_weekinquarter, dim_time.tm_weekinyear AS covexp_weekinyear, dim_time.tm_monthname AS covexp_monthname, dim_time.tm_monthabbr AS covexp_monthabbr, dim_time.tm_monthinquarter AS covexp_monthinquarter, dim_time.tm_monthinyear AS covexp_monthinyear, dim_time.tm_quarter AS covexp_quarter, dim_time.tm_year AS covexp_year, dim_time.tm_reportperiod AS covexp_reportperiod, dim_time.tm_isodate AS covexp_isodate, dim_time.month_id AS covexp_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_dateofloss
AS SELECT dim_time.time_id AS dateofloss_id, dim_time.tm_date AS dol_date, dim_time.tm_dayname AS dol_dayname, dim_time.tm_dayabbr AS dol_dayabbr, dim_time.tm_dayinweek AS dol_dayinweek, dim_time.tm_dayinmonth AS dol_dayinmonth, dim_time.tm_dayinquarter AS dol_dayinquarter, dim_time.tm_dayinyear AS dol_dayinyear, dim_time.tm_weekinmonth AS dol_weekinmonth, dim_time.tm_weekinquarter AS dol_weekinquarter, dim_time.tm_weekinyear AS dol_weekinyear, dim_time.tm_monthname AS dol_monthname, dim_time.tm_monthabbr AS dol_monthabbr, dim_time.tm_monthinquarter AS dol_monthinquarter, dim_time.tm_monthinyear AS dol_monthinyear, dim_time.tm_quarter AS dol_quarter, dim_time.tm_year AS dol_year, dim_time.tm_reportperiod AS dol_reportperiod, dim_time.tm_isodate AS dol_isodate, dim_time.month_id AS dol_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_effectivedate
AS SELECT dim_time.time_id AS effectivedate_id, dim_time.tm_date AS eff_date, dim_time.tm_dayname AS eff_dayname, dim_time.tm_dayabbr AS eff_dayabbr, dim_time.tm_dayinweek AS eff_dayinweek, dim_time.tm_dayinmonth AS eff_dayinmonth, dim_time.tm_dayinquarter AS eff_dayinquarter, dim_time.tm_dayinyear AS eff_dayinyear, dim_time.tm_weekinmonth AS eff_weekinmonth, dim_time.tm_weekinquarter AS eff_weekinquarter, dim_time.tm_weekinyear AS eff_weekinyear, dim_time.tm_monthname AS eff_monthname, dim_time.tm_monthabbr AS eff_monthabbr, dim_time.tm_monthinquarter AS eff_monthinquarter, dim_time.tm_monthinyear AS eff_monthinyear, dim_time.tm_quarter AS eff_quarter, dim_time.tm_year AS eff_year, dim_time.tm_reportperiod AS eff_reportperiod, dim_time.tm_isodate AS eff_isodate, dim_time.month_id AS eff_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_expirationdate
AS SELECT dim_time.time_id AS expirationdate_id, dim_time.tm_date AS exp_date, dim_time.tm_dayname AS exp_dayname, dim_time.tm_dayabbr AS exp_dayabbr, dim_time.tm_dayinweek AS exp_dayinweek, dim_time.tm_dayinmonth AS exp_dayinmonth, dim_time.tm_dayinquarter AS exp_dayinquarter, dim_time.tm_dayinyear AS exp_dayinyear, dim_time.tm_weekinmonth AS exp_weekinmonth, dim_time.tm_weekinquarter AS exp_weekinquarter, dim_time.tm_weekinyear AS exp_weekinyear, dim_time.tm_monthname AS exp_monthname, dim_time.tm_monthabbr AS exp_monthabbr, dim_time.tm_monthinquarter AS exp_monthinquarter, dim_time.tm_monthinyear AS exp_monthinyear, dim_time.tm_quarter AS exp_quarter, dim_time.tm_year AS exp_year, dim_time.tm_reportperiod AS exp_reportperiod, dim_time.tm_isodate AS exp_isodate, dim_time.month_id AS exp_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_openeddate
AS SELECT dim_time.time_id AS openeddate_id, dim_time.tm_date AS opndt_date, dim_time.tm_dayname AS opndt_dayname, dim_time.tm_dayabbr AS opndt_dayabbr, dim_time.tm_dayinweek AS opndt_dayinweek, dim_time.tm_dayinmonth AS opndt_dayinmonth, dim_time.tm_dayinquarter AS opndt_dayinquarter, dim_time.tm_dayinyear AS opndt_dayinyear, dim_time.tm_weekinmonth AS opndt_weekinmonth, dim_time.tm_weekinquarter AS opndt_weekinquarter, dim_time.tm_weekinyear AS opndt_weekinyear, dim_time.tm_monthname AS opndt_monthname, dim_time.tm_monthabbr AS opndt_monthabbr, dim_time.tm_monthinquarter AS opndt_monthinquarter, dim_time.tm_monthinyear AS opndt_monthinyear, dim_time.tm_quarter AS opndt_quarter, dim_time.tm_year AS opndt_year, dim_time.tm_reportperiod AS opndt_reportperiod, dim_time.tm_isodate AS opndt_isodate, dim_time.month_id AS opndt_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_policyeffectivedate
AS SELECT dim_time.time_id AS policyeffectivedate_id, dim_time.tm_date AS poleff_date, dim_time.tm_dayname AS poleff_dayname, dim_time.tm_dayabbr AS poleff_dayabbr, dim_time.tm_dayinweek AS poleff_dayinweek, dim_time.tm_dayinmonth AS poleff_dayinmonth, dim_time.tm_dayinquarter AS poleff_dayinquarter, dim_time.tm_dayinyear AS poleff_dayinyear, dim_time.tm_weekinmonth AS poleff_weekinmonth, dim_time.tm_weekinquarter AS poleff_weekinquarter, dim_time.tm_weekinyear AS poleff_weekinyear, dim_time.tm_monthname AS poleff_monthname, dim_time.tm_monthabbr AS poleff_monthabbr, dim_time.tm_monthinquarter AS poleff_monthinquarter, dim_time.tm_monthinyear AS poleff_monthinyear, dim_time.tm_quarter AS poleff_quarter, dim_time.tm_year AS poleff_year, dim_time.tm_reportperiod AS poleff_reportperiod, dim_time.tm_isodate AS poleff_isodate, dim_time.month_id AS poleff_month_id
   FROM fsbi_dw_uu.dim_time;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_policyexpirationdate
AS SELECT dim_time.time_id AS policyexpirationdate_id, dim_time.tm_date AS polexp_date, dim_time.tm_dayname AS polexp_dayname, dim_time.tm_dayabbr AS polexp_dayabbr, dim_time.tm_dayinweek AS polexp_dayinweek, dim_time.tm_dayinmonth AS polexp_dayinmonth, dim_time.tm_dayinquarter AS polexp_dayinquarter, dim_time.tm_dayinyear AS polexp_dayinyear, dim_time.tm_weekinmonth AS polexp_weekinmonth, dim_time.tm_weekinquarter AS polexp_weekinquarter, dim_time.tm_weekinyear AS polexp_weekinyear, dim_time.tm_monthname AS polexp_monthname, dim_time.tm_monthabbr AS polexp_monthabbr, dim_time.tm_monthinquarter AS polexp_monthinquarter, dim_time.tm_monthinyear AS polexp_monthinyear, dim_time.tm_quarter AS polexp_quarter, dim_time.tm_year AS polexp_year, dim_time.tm_reportperiod AS polexp_reportperiod, dim_time.tm_isodate AS polexp_isodate, dim_time.month_id AS polexp_month_id
   FROM fsbi_dw_uu.dim_time;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_policystatus
AS SELECT dim_status.status_id AS policystatus_id, dim_status.stat_4sightbistatuscd AS polst_4sightbistatuscd, dim_status.stat_statuscd AS polst_statuscd, dim_status.stat_status AS polst_status, dim_status.stat_substatuscd AS polst_substatuscd, dim_status.stat_substatus AS polst_substatus
   FROM fsbi_dw_uu.dim_status
  WHERE dim_status.stat_category::text = 'policy'::character varying::text;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_producer
AS CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_producer
AS select
	up.producer_id
	, coalesce(sp.prdr_role, up.producer_role) as producer_role
	, coalesce(sp.prdr_number, up.producer_number) as producer_number
	, coalesce(sp.prdr_name1, up.name) as name
	, coalesce(sp.prdr_address1, up.address1) as address1
	, coalesce(sp.prdr_address2, up.address2) as address2
	, coalesce(sp.prdr_city, up.city) as city
	, coalesce(sp.prdr_state, up.state) as state
	, coalesce(sp.prdr_zipcode, up.postalcode) as postalcode
	, coalesce(sp.prdr_country, up.country) as country
	, coalesce(sp.prdr_telephone, '~'::character varying) as telephone
	, coalesce(sp.prdr_email, '~'::character varying) as email
	, coalesce(sp.agency_group, '~'::character varying) as agency_group
	, coalesce(sp.national_name, '~'::character varying) as national_name
	, coalesce(sp.national_code, '~'::character varying) as national_code
	, coalesce(sp.territory, '~'::character varying) as territory
	, coalesce(sp.territory_manager, '~'::character varying) as territory_manager
	, coalesce(sp.dba, '~'::character varying) as dba
	, coalesce(sp.producer_status, '~'::character varying) as producer_status
	, coalesce(sp.commission_master, '~'::character varying) as commission_master
	, coalesce(sp.reporting_master, '~'::character varying) as reporting_master
	, coalesce(sp.pn_appointment_date, '1900-01-01'::date) as pn_appointment_date
	, coalesce(sp.prdr_uniqueid, 'Unknown'::character varying) as spinn_producer_uniqueid
	, up.producer_uniqueid as ico_producer_uniqueid
	, coalesce(sp.source_system, up.source_system) as source_system
	, coalesce(sp.loaddate::timestamp without time zone, up.loaddate) as loaddate
from
	fsbi_dw_uu.dim_producer up
left join fsbi_dw_spinn.vdim_producer sp on
	up.producer_number::text = sp.prdr_number::text
   with no schema binding
   
;

COMMENT ON VIEW fsbi_dw_uu.vdim_producer IS 'The view combines producer info from both SPINN/AMS and UU.';

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_reporteddate
AS SELECT dim_time.time_id AS datereported_id, dim_time.tm_date AS rptdt_date, dim_time.tm_dayname AS rptdt_dayname, dim_time.tm_dayabbr AS rptdt_dayabbr, dim_time.tm_dayinweek AS rptdt_dayinweek, dim_time.tm_dayinmonth AS rptdt_dayinmonth, dim_time.tm_dayinquarter AS rptdt_dayinquarter, dim_time.tm_dayinyear AS rptdt_dayinyear, dim_time.tm_weekinmonth AS rptdt_weekinmonth, dim_time.tm_weekinquarter AS rptdt_weekinquarter, dim_time.tm_weekinyear AS rptdt_weekinyear, dim_time.tm_monthname AS rptdt_monthname, dim_time.tm_monthabbr AS rptdt_monthabbr, dim_time.tm_monthinquarter AS rptdt_monthinquarter, dim_time.tm_monthinyear AS rptdt_monthinyear, dim_time.tm_quarter AS rptdt_quarter, dim_time.tm_year AS rptdt_year, dim_time.tm_reportperiod AS rptdt_reportperiod, dim_time.tm_isodate AS rptdt_isodate, dim_time.month_id AS rptdt_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_transactiondate
AS CREATE OR REPLACE VIEW fsbi_dw_uu.vdim_transactiondate
AS SELECT dim_time.time_id AS transactiondate_id, dim_time.tm_date AS trans_date, dim_time.tm_dayname AS trans_dayname, dim_time.tm_dayabbr AS trans_dayabbr, dim_time.tm_dayinweek AS trans_dayinweek, dim_time.tm_dayinmonth AS trans_dayinmonth, dim_time.tm_dayinquarter AS trans_dayinquarter, dim_time.tm_dayinyear AS trans_dayinyear, dim_time.tm_weekinmonth AS trans_weekinmonth, dim_time.tm_weekinquarter AS trans_weekinquarter, dim_time.tm_weekinyear AS trans_weekinyear, dim_time.tm_monthname AS trans_monthname, dim_time.tm_monthabbr AS trans_monthabbr, dim_time.tm_monthinquarter AS trans_monthinquarter, dim_time.tm_monthinyear AS trans_monthinyear, dim_time.tm_quarter AS trans_quarter, dim_time.tm_year AS trans_year, dim_time.tm_reportperiod AS trans_reportperiod, dim_time.tm_isodate AS trans_isodate, dim_time.month_id AS trans_month_id
   FROM fsbi_dw_uu.dim_time
with no schema binding
;