CREATE OR REPLACE PROCEDURE cse_bi.sp_eris_claims_uuico(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
					
BEGIN				
				
				
/*-------Feature conversion is used in several parts of the process independently ------------------------------*/    				
create temporary table covx as    				
select distinct   				
covx.covx_asl as aslob,   				
covx.act_rag  as rag,   				
left(covx.coveragetype,1) as feature_type,    				
covx.covx_code as feature,    				
isnull(covx.act_eris,'OTH') as feature_map    				
from fsbi_dw_uuico.dim_coverageextension covx;   				
    				
/*--1.Latest known claims attributes----------------------*/   				
/*--it might be already handled in  vmfact_claimtransaction_blended. just in case -------------------------------*/   		 		
/*--1.1 Latest transaction --------------------------------------------------------------------------------------*/   				
create temporary table  tmp_da as   				
select    				
f.claim_number,   				
f.claimant,   				
f.feature,    				
max(acct_date) acct_date    				
from fsbi_dw_uuico.vmfact_claimtransaction_blended f   		   		
group by f.claim_number,    				
f.claimant,   				
f.feature;    				
    				
    				
/*--1.2. Claims data from the latest kown transaction-------------------------------------------------------------*/   				
create temporary table tmp_dc as    				
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
'AU' LOB , 				
max(policy_id) policy_id,   				
max(poleff_date) poleff_date,   				
max(polexp_date) polexp_date,   				
max(v.producer_status) producer_status    				
from fsbi_dw_uuico.vmfact_claimtransaction_blended f   				
join fsbi_dw_uuico.vdim_producer v    				
on f.producer_code=v.producer_number    				
join tmp_da				
on f.claim_number=tmp_da.claim_number   				
and f.acct_date=tmp_da.acct_date    				
group by f.claim_number,    				
f.claimant,   				
f.feature ;   				
				

   				
    				
/*--2. Reported Count is based on transactional level----------------*/   				
create temporary table tmp_reported_count as    				
select    				
f.claim_number,   				
f.claimant,   				
covx.feature_map Feature,   				
min(cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar)) quarter_id,   				
min(acct_date) reported_count_date    				
from fsbi_dw_uuico.vmfact_claimtransaction_blended f   				
join tmp_dc   				
on tmp_dc.claim_number=f.claim_number   				
left outer join covx    				
on f.feature=covx.feature   				
and f.feature_type=covx.feature_type    				
and f.aslob=covx.aslob    				
and f.rag=covx.rag    				    
where f.acct_date>=dateadd(year,-10, GetDate())   				
and (   				
f.loss_paid>=0.5 or f.loss_reserve>=0.5 or f.aoo_paid>=0.5 or f.aoo_reserve>=0.5 or f.dcc_paid>=0.5 or f.dcc_reserve>=0.5 or f.salvage_received>=0.5 or f.subro_received>=0.5   				
)   				
group by    				
f.claim_number,   				
f.claimant,   				
covx.feature_map ;   				
				
				
/*--3. Closed Count is based on transactional level----------------*/   				
    				
create temporary table tmp_closed_count as    				
with data as (    				
select    				
f.claim_number,   				
f.claimant,   				
covx.feature_map Feature,     				
f.acct_date acct_date,    				
cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar) quarter_id,    				
sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve) trn_reserve   				
from fsbi_dw_uuico.vmfact_claimtransaction_blended f   				
join tmp_dc   				
on tmp_dc.claim_number=f.claim_number   				
left outer join covx    				
on f.feature=covx.feature   				
and f.feature_type=covx.feature_type    				
and f.aslob=covx.aslob    				
and f.rag=covx.rag    		  		 
where f.acct_date>=dateadd(year,-10, GetDate())   				
group by    				
f.claim_number,   				
f.claimant,   				
covx.feature_map,   				
 f.acct_date,   				
 cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar)   				
 having   				
 sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve)<0.5    				
)   				
select    				
claim_number,   				
claimant,   				
feature,    				
max(quarter_id) quarter_id,   				
max(acct_date) closed_count_date    				
from data   				
group by    				
claim_number,   				
claimant,   				
feature;    				
    				
				
    				
    				
				
    				
/*---4. Final part - Main select with attributes on monthly level ----------------*/				
/*----------For whatever reason the direct insert into fsbi_dw_uuico.vmERIS_Claims fails with a weird error---*/				
create temporary table tmp_vmERIS_Claims as				
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
p.pol_uniqueid policy_uniqueid,   				
lpad(isnull(clr.clrsk_number,1),3,'0') RiskCd,    				
tmp_dc.poleff_date,   				
tmp_dc.polexp_date,   				
case when MONTHS_BETWEEN (p.pol_expirationdate, p.pol_effectivedate)<11 then '6 Months' else '1 Year' end RenewalTermCd, 				
case    		   		
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
when f.aslob='192' then 'AL'    				
when f.aslob='211' then 'APD'   		   		
end LOB2,   				
case    		  		
when f.aslob='192' then 'AL'    				
when f.aslob='211' then 'APD'   		  		
end LOB3,   				
'AU' Product,    				
'PA' PolicyFormCode,  				
case 				
when di.Employment_Group_Discount='Basic Program' then 'BP'				
when di.Employment_Group_Discount='CA Medical Association' then 'MA'				
when di.Employment_Group_Discount='CA CPA' then 'CP'				
when di.Employment_Group_Discount='Government Employee' then 'GE'				
when di.Employment_Group_Discount='Public Safety Professional' then 'PS'				
when di.Employment_Group_Discount='Scientist or Engineer' then 'SE'				
when di.Employment_Group_Discount='Educator' then 'ED'				
else tmp_dc.LOB				
end ProgramInd,  				  
case    		 		
when f.aslob='192' then 'LIAB'    				
when f.aslob='211' then 'PROP'    		    		
end FeatureType,    				
covx.feature_map Feature,     				
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
else 'Open' end Claim_Status  				
from fsbi_dw_uuico.vmfact_claim_blended  f     				
join fsbi_dw_uuico.dim_month m    				
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
left outer join fsbi_dw_uuico.dim_policy p    				
on tmp_dc.policy_id=p.policy_id 					
left outer join fsbi_dw_uuico.dim_claimrisk clr   				
on tmp_dc.claim_number=clr.claimnumber    		 		
left outer join (select distinct clm_claimnumber, dateofloss from fsbi_dw_uuico.dim_claim) cl   				
on tmp_dc.claim_number=cl.clm_claimnumber   		  		
left outer join fsbi_dw_uuico.dim_discount di				
on p.policy_id=di.policy_id				
where m.mon_year>=DATE_PART(year,Getdate())-10    				
group by    				
datediff(qtr, isnull(cl.dateofloss,f.loss_date), m.mon_enddate)+1 ,   				
m.mon_year,   				
m.mon_quarter,    				
cast(m.mon_year as varchar)+'0'+cast(m.mon_quarter as varchar) ,    				
isnull(cl.dateofloss,f.loss_date) ,    				
f.reported_date,    				
tmp_dc.Carrier,   				
tmp_dc.Company,   				
tmp_dc.Policy_number,   				
p.pol_uniqueid ,   				
lpad(isnull(clr.clrsk_number,1),3,'0') ,    				
tmp_dc.poleff_date,   				
tmp_dc.polexp_date,   				
case when MONTHS_BETWEEN (p.pol_expirationdate, p.pol_effectivedate)<11 then '6 Months' else '1 Year' end,   				
case    		   		
 when cast(isnull(p.pol_policynumbersuffix,'0') as int)<2 then 'New'    				
 else 'Renewal'   				
end,   				
tmp_dc.policy_state,    				
tmp_dc.producer_status,   				
f.claim_number,   				
f.claimant,   				
case when tmp_dc.catastrophe_id is null then 'No' else 'Yes' end ,   				
case 				
when di.Employment_Group_Discount='Basic Program' then 'BP'				
when di.Employment_Group_Discount='CA Medical Association' then 'MA'				
when di.Employment_Group_Discount='CA CPA' then 'CP'				
when di.Employment_Group_Discount='Government Employee' then 'GE'				
when di.Employment_Group_Discount='Public Safety Professional' then 'PS'				
when di.Employment_Group_Discount='Scientist or Engineer' then 'SE'				
when di.Employment_Group_Discount='Educator' then 'ED'				
else tmp_dc.LOB				
end ,   				
case    		  		
when f.aslob='192' then 'AL'    				
when f.aslob='211' then 'APD'   		   		
end ,   				
case    		  		
when f.aslob='192' then 'AL'    				
when f.aslob='211' then 'APD'   		  		
end ,   		   		
tmp_dc.LOB ,   				
case    		 		
when f.aslob='192' then 'LIAB'    				
when f.aslob='211' then 'PROP'    		    		
end ,    				
covx.feature_map				
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
d.feature = first_reported_count.feature    				
/*-------------------------------*/   				
left outer join tmp_closed_count last_closed_count    				
on    				
d.claim_number = last_closed_count.claim_number and   				
d.claimant = last_closed_count.claimant and   				
d.feature = last_closed_count.feature   				
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
case when last_closed_count_flg='Y'  then ITD_Salvage_and_subrogation else 0 end Paid_On_Closed_Salvage_Subrogation   				
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
/*2022-03-31 If a claim has closed_count or closed_nopay = 1 and reported_count = 0 then set closed_count or closed_nopay to 0 as well.*/				
sum(Reported_Count) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType ORDER BY reported_year, reported_qtr rows unbounded preceding) isReported,				
case when isReported=1 then Closed_Count else 0 end Closed_Count,   				
case when isReported=1 then Closed_NoPay  else 0 end  Closed_NoPay,				
Paid_On_Closed_Loss,    				
Paid_On_Closed_Expense,   				
Paid_On_Closed_DCC_Expense  , 				
Paid_On_Closed_Salvage_Subrogation  , 				
case    				
 when min(case when ITD_Loss_and_ALAE_for_Paid_count>0 then concat(reported_year, reported_qtr) end) over(partition by claim_number, claimant, feature, LOB2, LOB3, FeatureType)=concat(reported_year, reported_qtr) then 1   				
 else 0     				
end Paid_Count    				
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
'ICO' source_system,				
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
Paid_Count,   				
pLoadDate LoadDate,    				
ITD_PAID  				
from data3 d    				
order by DevQ,claim_number,claimant,feature;				
				
truncate table fsbi_dw_uuico.vmERIS_Claims;				
insert into fsbi_dw_uuico.vmERIS_Claims				
select * from tmp_vmERIS_Claims;				
				
				
				
END;				

$$
;

CREATE OR REPLACE PROCEDURE cse_bi.sp_eris_policies_uuico(ploaddate timestamp)
	LANGUAGE plpgsql
AS $$
	
BEGIN

create temporary table dim_policy_extended as 
select 
p.policy_id,
p.pol_policynumber,
p.pol_uniqueid,
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_masterstate,
'AU' LOB,
isnull(r.coverage,'All') coverage,
isnull(EXP(SUM(LN(cast((1+r.renewal_change/100) as float)))),1) renewal_change,
isnull(EXP(SUM(LN(cast((1+r.nb_change/100) as float)))),1) nb_change
from fsbi_dw_uuico.dim_policy p
left outer join external_data_ico_pricing.eris_ratechange r
on  r.startdt>pol_effectivedate
/*The rest is still the same in all rows ICO no need to use in the condition as for now
and r.carriercd=co.comp_name1
and r.formcd=pe.PolicyFormCode
and r.statecd=p.pol_masterstate
*/
group by
p.policy_id,
p.pol_policynumber,
p.pol_uniqueid,
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_masterstate,
isnull(r.coverage,'All');



truncate table fsbi_dw_uuico.vmERIS_Policies;
insert into fsbi_dw_uuico.vmERIS_Policies 
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
case when MONTHS_BETWEEN (p.pol_expirationdate, p.pol_effectivedate)<11 then '6 Months' else '1 Year' end RenewalTermCd,
f.policyneworrenewal,
p.pol_masterstate PolicyState,
co.comp_number CompanyNumber,
co.comp_name1 Company,
'AU' LOB,
c.cov_asl ASL,
case
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
end LOB2,
case
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
end LOB3,
'AU' Product,
'PA' PolicyFormCode,
case 
when di.Employment_Group_Discount='Basic Program' then 'BP'
when di.Employment_Group_Discount='CA Medical Association' then 'MA'
when di.Employment_Group_Discount='CA CPA' then 'CP'
when di.Employment_Group_Discount='Government Employee' then 'GE'
when di.Employment_Group_Discount='Public Safety Professional' then 'PS'
when di.Employment_Group_Discount='Scientist or Engineer' then 'SE'
when di.Employment_Group_Discount='Educator' then 'ED'
else 'AU'
end ProgramInd,
pr.producer_status,
case
when c.cov_asl='192' then 'LIAB'
when c.cov_asl='211' then 'PROP'
end CoverageType,
case when ce.codetype='Fee' then 'Fee' else isnull(ce.Act_ERIS,'OTH') end Coverage,
case when ce.codetype='Fee' then 'Y' else 'N' end FeeInd,
'UU ICO' Source,
sum(wrtn_prem_amt) WP,
sum(earned_prem_amt) EP,
sum(case
 when f.policyneworrenewal='New' then p.nb_change*earned_prem_amt
 else p.renewal_change*earned_prem_amt
end) CLEP,
sum(
case
 when  (ce.covx_code in ('BI', 'COMP', 'COLL','MEDPAY', 'PD','RREIM', 'ROAD', 'UM','UMBI', 'UMPD' ) or isnull(ce.Act_ERIS,'OTH')='OTH') then round(ee_rm/12,3)
else 0
end
)  EE,
pLoadDate LoadDate
from fsbi_dw_uuico.fact_policycoverage f
join fsbi_dw_uuico.vdim_company co
on f.company_id=co.company_id
join fsbi_dw_uuico.dim_coverage c
on f.coverage_id=c.coverage_id
left outer join fsbi_dw_uuico.dim_coverageextension ce
on c.coverage_id=ce.coverage_id
join dim_policy_extended p
on f.policy_id=p.policy_id
join fsbi_dw_uuico.vdim_producer pr
on f.producer_id=pr.producer_id
join fsbi_dw_uuico.dim_month m
on f.month_id=m.month_id
join fsbi_dw_uuico.dim_coveredrisk cr
on f.primaryrisk_id=cr.coveredrisk_id
left outer join fsbi_dw_uuico.dim_discount di
on f.policy_id=di.policy_id
/*Only "meaningfull" coverages from rating. The results of this join will help to filter out duplicates */
left outer join dim_policy_extended r
on f.policy_id=r.policy_id
and isnull(ce.Act_ERIS,'OTH')=r.coverage
where  
/*keep coverages only once*/
not (p.coverage='All' and isnull(ce.Act_ERIS,'OTH')=isnull(r.coverage,'N/A'))
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
case when MONTHS_BETWEEN (p.pol_expirationdate, p.pol_effectivedate)<11 then '6 Months' else '1 Year' end,
f.policyneworrenewal,
p.pol_masterstate,
co.comp_number,
co.comp_name1,
c.cov_asl,
case
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
end ,
case
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
end ,
pr.producer_status,
case
when c.cov_asl='192' then 'LIAB'
when c.cov_asl='211' then 'PROP'
end ,
case when ce.codetype='Fee' then 'Fee' else isnull(ce.Act_ERIS,'OTH') end ,
case when ce.codetype='Fee' then 'Y' else 'N' end,
case 
when di.Employment_Group_Discount='Basic Program' then 'BP'
when di.Employment_Group_Discount='CA Medical Association' then 'MA'
when di.Employment_Group_Discount='CA CPA' then 'CP'
when di.Employment_Group_Discount='Government Employee' then 'GE'
when di.Employment_Group_Discount='Public Safety Professional' then 'PS'
when di.Employment_Group_Discount='Scientist or Engineer' then 'SE'
when di.Employment_Group_Discount='Educator' then 'ED'
else 'AU'
end 
having sum(wrtn_prem_amt + fees_amt)<>0 or sum(earned_prem_amt)<>0 or sum(ee_rm)<>0
order by report_year, report_quarter;

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

CREATE OR REPLACE PROCEDURE cse_bi.sp_extend_blended_claims_uuico()
	LANGUAGE plpgsql
AS $$
	
	
	
	

	
BEGIN

	truncate table fsbi_dw_uuico.vmfact_claimtransaction_blended;

	insert into fsbi_dw_uuico.vmfact_claimtransaction_blended
	(claimtransaction_id,source_system,businesssource,trans_date,acct_date,claim_number,claimant,feature,feature_desc,feature_type,aslob,catastrophe_id,iseco,rag,elr,schedp_part,ctrans_code,ctrans_name,ctrans_subcode,ctrans_subname,loss_paid,loss_reserve,aoo_paid,aoo_reserve,dcc_paid,dcc_reserve,salvage_received,salvage_reserve,subro_received,subro_reserve,product_code,product,subproduct,carrier,carrier_group,company,prdt_lob_code,prdt_lob_name,prdt_lob_type,prdt_state,carr_code,carr_abbr,prdt_selectorpreferred,prdt_code,prdt_name,policy_state,policy_number,policyref,poleff_date,polexp_date,producer_code,loss_date,loss_year,reported_date,loss_cause,changetype,claimtransactiontype_id_original,coverage_id_original,dateofloss_id_original,amount_original,fin_source_id,fin_company_id,fin_location_id,fin_product_id,policy_id)
	select
		f.claimtransaction_id
	,	f.source_system
	,	'PV' businesssource
	,	vdtd.trans_date
	,	vdad.acct_date
	,	dclm.clm_claimnumber claim_number
	,	decode(vdclmnt.clmnt_number,'~','~',null,'~',lpad(vdclmnt.clmnt_number,3,'0')) claimant
	,	covx.covx_code feature
	,	covx.covx_description feature_desc
	,	left(covx.coveragetype,1) feature_type
	,	covx.covx_asl aslob
	,	null catastrophe_id
	,	false iseco
	,	covx.act_rag rag
	,	'PV.ICO.AU.CA.All' elr
	,	covx.fin_schedp schedp_part
	,	ctrans_code
	,	ctrans_name
	,	ctrans_subcode
	,	ctrans_subname
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
	,	'PersonalAuto' product_code
	,	'PersonalAuto' product
	,	'PA' subproduct
	,	'CSEICO' carrier
	,	'Preferred' carrier_group
	,	'0001' company
	,	'PersonalAuto' prdt_lob_code
	,	'Personal Auto' prdt_lob_name
	,	'Personal' prdt_lob_type
	,	'CA' prdt_state
	,	'CSEICO' carr_code
	,	'ICO' carr_abbr
	,	'Preferred' prdt_selectorpreferred
	,	'PA' prdt_code
	,	'Personal Auto' prdt_name
	,	'CA' policy_state
	,	dpol.pol_policynumber policy_number -- do I need to UPPER()?
	,	null policyref -- this isn't an integer in UUICO
	,	vdped.poleff_date
	,	vdpxd.polexp_date
	,	vprdr.producer_number as producer_code
	,	vdol.dol_date as loss_date
	,	date_part(year,loss_date)::integer loss_year
	,	vdrd.rptdt_date as reported_date
	,	null loss_cause
	,	'' changetype
	,	f.claimtransactiontype_id claimtransactiontype_id_original
	,	f.coverage_id coverage_id_original
	,	f.dateofloss_id dateofloss_id_original
	,	f.amount amount_original
	,	'124' fin_source_id
	,	'21' fin_company_id
	,	'0502' fin_location_id
	,	'113' fin_product_id
	,	f.policy_id
	from fsbi_dw_uuico.fact_claimtransaction f
	left join fsbi_dw_uuico.dim_claimtransactiontype dctt on f.claimtransactiontype_id = dctt.claimtransactiontype_id
	left join fsbi_dw_uuico.dim_policy dpol on f.policy_id = dpol.policy_id
	left join fsbi_dw_uuico.dim_claim dclm on f.claim_id = dclm.claim_id
	left join fsbi_dw_uuico.vdim_claimant vdclmnt on f.claimant_id = vdclmnt.claimant_id
	left join fsbi_dw_uuico.vdim_producer vprdr on f.producer_id = vprdr.producer_id
	left join fsbi_dw_uuico.dim_coverageextension covx on f.coverage_id = covx.coverage_id
	left join reporting.rag_lookup rag on covx.covx_asl = rag.annualstatementlinecd and left(covx.coveragetype,1) = rag.covgtype
	left join fsbi_dw_uuico.vdim_transactiondate vdtd using (transactiondate_id)
	left join fsbi_dw_uuico.vdim_accountingdate vdad using (accountingdate_id)
	left join fsbi_dw_uuico.vdim_policyeffectivedate vdped on f.policyeffectivedate_id = vdped.policyeffectivedate_id
	left join fsbi_dw_uuico.vdim_policyexpirationdate vdpxd on f.policyexpirationdate_id = vdpxd.policyexpirationdate_id
	left join fsbi_dw_uuico.vdim_coverageeffectivedate vdced on f.coverageeffectivedate_id = vdced.coverageeffectivedate_id
	left join fsbi_dw_uuico.vdim_coverageexpirationdate vdcxd on f.coverageexpirationdate_id = vdcxd.coverageexpirationdate_id
	left join fsbi_dw_uuico.vdim_dateofloss vdol on f.dateofloss_id = vdol.dateofloss_id
	left join fsbi_dw_uuico.vdim_openeddate vdod on f.openeddate_id = vdod.openeddate_id
	left join fsbi_dw_uuico.vdim_closedate vdcd on f.closeddate_id = vdcd.closeddate_id
	left join fsbi_dw_uuico.vdim_reporteddate vdrd on dclm.datereported = vdrd.rptdt_date
	;

	drop table if exists #tmp_ccfa_lasttrans;
	create table #tmp_ccfa_lasttrans
	sortkey(claim_number,claimant,feature,aslob)
	as
	select distinct
		claim_number
	,	claimant
	,	feature
	,	aslob
	,	last_value(claimtransaction_id) over (partition by claim_number order by trans_date,source_system desc,claimtransaction_id
			rows between unbounded preceding and unbounded following) as claimtransaction_id_claim
	,	last_value(source_system) over (partition by claim_number order by trans_date,source_system desc,claimtransaction_id
			rows between unbounded preceding and unbounded following) as source_system_claim
	,	last_value(claimtransaction_id) over (partition by claim_number,claimant,feature,aslob order by trans_date,source_system desc,claimtransaction_id
			rows between unbounded preceding and unbounded following) as claimtransaction_id_feature
	,	last_value(source_system) over (partition by claim_number,claimant,feature,aslob order by trans_date,source_system desc,claimtransaction_id
			rows between unbounded preceding and unbounded following) as source_system_feature
	from fsbi_dw_uuico.vmfact_claimtransaction_blended
	;
	-- select * from #tmp_ccf_maxtrans
	
	-- update claim-based values to last known values
	update fsbi_dw_uuico.vmfact_claimtransaction_blended
	set
		catastrophe_id = lv.catastrophe_id
	,	iseco = lv.iseco
	,	product_code = lv.product_code
	,	product = lv.product
	,	subproduct = lv.subproduct
	,	carrier = lv.carrier
	,	carrier_group = lv.carrier_group
	,	company = lv.company
	,	prdt_lob_code = lv.prdt_lob_code
	,	prdt_lob_name = lv.prdt_lob_name
	,	prdt_lob_type = lv.prdt_lob_type
	,	prdt_state = lv.prdt_state
	,	carr_code = lv.carr_code
	,	carr_abbr = lv.carr_abbr
	,	prdt_selectorpreferred = lv.prdt_selectorpreferred
	,	prdt_code = lv.prdt_code
	,	prdt_name = lv.prdt_name
	,	policy_state = lv.policy_state
	,	policy_number = lv.policy_number
	,	policyref = lv.policyref
	,	poleff_date = lv.poleff_date
	,	polexp_date = lv.polexp_date
	,	producer_code = lv.producer_code
	,	loss_date = lv.loss_date
	,	loss_year = lv.loss_year
	,	reported_date = lv.reported_date
	,	loss_cause = lv.loss_cause
	,	fin_source_id = lv.fin_source_id
	,	fin_company_id = lv.fin_company_id
	,	fin_location_id = lv.fin_location_id
	,	fin_product_id = lv.fin_product_id
	,	policy_id = lv.policy_id
	from
	(
		select
			lastvals.*
		from (select distinct claimtransaction_id_claim claimtransaction_id, source_system_claim source_system from #tmp_ccfa_lasttrans) l
		join fsbi_dw_uuico.vmfact_claimtransaction_blended lastvals using (source_system,claimtransaction_id)
	) lv
	join fsbi_dw_uuico.vmfact_claimtransaction_blended upd on lv.claim_number = upd.claim_number
	;
	
	-- update feature-based values to last known values
	update fsbi_dw_uuico.vmfact_claimtransaction_blended
	set
		feature_desc = lv.feature_desc
	,	feature_type = lv.feature_type
	,	rag = lv.rag
	,	elr = lv.elr
	,	schedp_part = lv.schedp_part
	from
	(
		select
			lastvals.*
		from (select claimtransaction_id_feature claimtransaction_id, source_system_feature source_system from #tmp_ccfa_lasttrans) l
		join fsbi_dw_uuico.vmfact_claimtransaction_blended lastvals using (source_system,claimtransaction_id)
	) lv
	join fsbi_dw_uuico.vmfact_claimtransaction_blended upd on
		lv.claim_number = upd.claim_number
	and lv.claimant = upd.claimant
	and lv.feature = upd.feature
	and lv.aslob = upd.aslob
	;

	drop table if exists #tmp_ccfa_lasttrans;

END;






$$
;

-- Drop table

-- DROP TABLE fsbi_dw_uuico.checks;

--DROP TABLE fsbi_dw_uuico.checks;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.checks
(
	agency VARCHAR(100)   ENCODE lzo
	,carrier VARCHAR(100)   ENCODE lzo
	,claim_number VARCHAR(100)   ENCODE lzo
	,claim_dol TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,cov_code VARCHAR(100)   ENCODE lzo
	,check_type VARCHAR(100)   ENCODE lzo
	,check_date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,void_stop_date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,check_number VARCHAR(100)   ENCODE lzo
	,amount NUMERIC(13,3)   ENCODE az64
	,filename VARCHAR(250) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uuico.checks owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.checks IS 'Checks info from monthly UU files.';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_address;

--DROP TABLE fsbi_dw_uuico.dim_address;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_address
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
 SORTKEY (
	address_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_address owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_address IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table of all full addresses from FSBI_STG_UUICO.stg_risk';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_adjuster;

--DROP TABLE fsbi_dw_uuico.dim_adjuster;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_adjuster
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
ALTER TABLE fsbi_dw_uuico.dim_adjuster owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_adjuster IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Adjuster info  from FSBI_STG_UUICO.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_claim;

--DROP TABLE fsbi_dw_uuico.dim_claim;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_claim
(
	claim_id INTEGER NOT NULL  ENCODE RAW
	,policy_id INTEGER NOT NULL  ENCODE az64
	,clm_claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,clm_featurenumber VARCHAR(50) NOT NULL  ENCODE lzo
	,dateofloss DATE NOT NULL  ENCODE az64
	,datereported DATE NOT NULL  ENCODE az64
	,clm_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,atfault VARCHAR(1) NOT NULL  ENCODE lzo
	,source_system VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE az64
	,clm_causelosscode VARCHAR(50)  DEFAULT '~'::character varying ENCODE lzo
	,clm_causelossdescription VARCHAR(256)  DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (claim_id)
)
DISTSTYLE AUTO
 SORTKEY (
	claim_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_claim owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_claim IS 'DW Table type: Dimension Type 1 Table description: Claimnumber, date of loss, reported date, policy term etc from FSBI_STG_UUICO.stg_claim';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_claimant;

--DROP TABLE fsbi_dw_uuico.dim_claimant;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_claimant
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
 SORTKEY (
	claimant_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_claimant owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_claimant IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Claimant info  from FSBI_STG_UUICO.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_claimrisk;

--DROP TABLE fsbi_dw_uuico.dim_claimrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_claimrisk
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
 SORTKEY (
	claimrisk_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_claimrisk owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_claimrisk IS 'DW Table type: Dimension Type 0 Table description: Claim risks. Use FACT_CLAIMTRANSACTION.PRIMARYRISK_ID to join. It''s a table for a special purposes. Use direct links to risk items from FACT tables via VEHICLE_ID, DRIVER_ID';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_claimtransactiontype;

--DROP TABLE fsbi_dw_uuico.dim_claimtransactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_claimtransactiontype
(
	claimtransactiontype_id INTEGER   ENCODE az64
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
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uuico.dim_claimtransactiontype owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_claimtransactiontype IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: DW special table from 4SightBI original setup';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_coverage;

--DROP TABLE fsbi_dw_uuico.dim_coverage;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_coverage
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
ALTER TABLE fsbi_dw_uuico.dim_coverage owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_coverage IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available Coverage codes, ASL, SubLine from FSBI_STG_UUICO.stg_coverage with adjustments made in ETL';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_coverageextension;

--DROP TABLE fsbi_dw_uuico.dim_coverageextension;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_coverageextension
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
	,clm_toolkit VARCHAR(8)  DEFAULT ''::character varying ENCODE lzo
	,uu_month_sum VARCHAR(20)   ENCODE lzo
	,feetype VARCHAR(20)   ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_uuico.dim_coverageextension owner to emiller;
COMMENT ON TABLE fsbi_dw_uuico.dim_coverageextension IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. Standartized Coverage codes, ASL, SubLineand any other coverage mapping used in different projects';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_coveredrisk;

--DROP TABLE fsbi_dw_uuico.dim_coveredrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_coveredrisk
(
	coveredrisk_id INTEGER NOT NULL  ENCODE az64
	,cvrsk_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE RAW
	,deleted_indicator INTEGER   ENCODE az64
	,cvrsk_typedescription VARCHAR(256)   ENCODE lzo
	,cvrsk_item_id INTEGER   ENCODE az64
	,cvrsk_item_uniqueid VARCHAR(500)   ENCODE lzo
	,cvrsk_item_type VARCHAR(100)   ENCODE lzo
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
ALTER TABLE fsbi_dw_uuico.dim_coveredrisk owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_coveredrisk IS 'DW Table type:';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_deductible;

--DROP TABLE fsbi_dw_uuico.dim_deductible;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_deductible
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
ALTER TABLE fsbi_dw_uuico.dim_deductible owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_deductible IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available deductibles from FSBI_STG_UUICO.stg_coverage ';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_discount;

--DROP TABLE fsbi_dw_uuico.dim_discount;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_discount
(
	policy_id INTEGER NOT NULL  ENCODE RAW
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,employment_group_discount VARCHAR(50)   ENCODE lzo
	,multi_car_discount VARCHAR(1)   ENCODE lzo
	,multi_policy_discount VARCHAR(1)   ENCODE lzo
	,effective_date DATE   ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (policy_id)
)
DISTSTYLE AUTO
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_discount owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_discount IS 'DW Table type: Dimension Type 1 Table description: discounts per policy term from FSBI_STG_UUICO.stg_discount. It''s a dim_policy extension in some sense. Use Policy_Id to join to fact tables';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_driver;

--DROP TABLE fsbi_dw_uuico.dim_driver;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_driver
(
	driver_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,record_version INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,driver_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,drivertype VARCHAR(100) NOT NULL  ENCODE lzo
	,driverfirstname VARCHAR(255) NOT NULL  ENCODE lzo
	,driverlastname VARCHAR(255) NOT NULL  ENCODE lzo
	,drivergender VARCHAR(100) NOT NULL  ENCODE lzo
	,drivermaritalstatus VARCHAR(100) NOT NULL  ENCODE lzo
	,driverlicensenumber VARCHAR(255) NOT NULL  ENCODE lzo
	,driverlicenseddate DATE NOT NULL  ENCODE az64
	,driverdob DATE NOT NULL  ENCODE az64
	,driveradddate DATE NOT NULL  ENCODE az64
	,driverremovedate DATE NOT NULL  ENCODE az64
	,driverpoints INTEGER NOT NULL  ENCODE az64
	,insurancescore INTEGER NOT NULL  ENCODE az64
	,drivergooddriver VARCHAR(1) NOT NULL  ENCODE lzo
	,driver_3_yearclean VARCHAR(1) NOT NULL  ENCODE lzo
	,driver_5_yearaccidentfree VARCHAR(1) NOT NULL  ENCODE lzo
	,drivergoodstudent VARCHAR(1) NOT NULL  ENCODE lzo
	,driverdefensivedriver VARCHAR(1) NOT NULL  ENCODE lzo
	,driverpermitdriver VARCHAR(1) NOT NULL  ENCODE lzo
	,driverstatus VARCHAR(15) NOT NULL  ENCODE lzo
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
ALTER TABLE fsbi_dw_uuico.dim_driver owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_driver IS 'DW Table type: Slowly Changing Dimension Type 2 Table description: Driver info  from FSBI_STG_UUICO.stg_driver';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.dim_driver.driverdefensivedriver IS 'A Defensive Driver discount (Mature Driver discount) shall be applied to the insured motor vehicle as set forth in the Rate Manual for Principal drivers age 55 and over who have: 1. Received a driver improvement course certificate from a DMV certified school; and 
2. Had no at fault accidents or traffic convictions since completing the course. 
A copy of the certificate must be submitted with the application. The discount applies for up to 3 
years from the completion date of the driver improvement course. 
The discount will be canceled if any of the following apply to the insured: 
A. Involved in an at-fault accident; 
B. Convicted of a moving violation or a traffic related offense involving alcohol or narcotics
';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_examiner;

--DROP TABLE fsbi_dw_uuico.dim_examiner;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_examiner
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
ALTER TABLE fsbi_dw_uuico.dim_examiner owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_examiner IS 'DW Table type:  Dimension Type 1 (Dictionary)	Table description: Examiner info including email';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_geography;

--DROP TABLE fsbi_dw_uuico.dim_geography;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_geography
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
ALTER TABLE fsbi_dw_uuico.dim_geography owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_geography IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table of all state/county/city/postal code addresses from FSBI_STG_UUICO.stg_risk. Better use dim_address instead.';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_insured;

--DROP TABLE fsbi_dw_uuico.dim_insured;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_insured
(
	insured_id INTEGER NOT NULL  ENCODE RAW
	,policy_id INTEGER NOT NULL  ENCODE az64
	,insured_role VARCHAR(50)   ENCODE lzo
	,fullname VARCHAR(200)   ENCODE lzo
	,commercialname VARCHAR(200)   ENCODE lzo
	,dob DATE   ENCODE az64
	,occupation VARCHAR(256)   ENCODE lzo
	,gender VARCHAR(10)   ENCODE lzo
	,maritalstatus VARCHAR(256)   ENCODE lzo
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
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (insured_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	insured_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_insured owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_insured IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Insured info  from FSBI_STG_UUICO.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_legalentity_other;

--DROP TABLE fsbi_dw_uuico.dim_legalentity_other;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_legalentity_other
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
 SORTKEY (
	legalentity_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_legalentity_other owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_legalentity_other IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: all other legalentity  info  from FSBI_STG_UUICO.stg_legalentity as company etc';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_limit;

--DROP TABLE fsbi_dw_uuico.dim_limit;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_limit
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
ALTER TABLE fsbi_dw_uuico.dim_limit owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_limit IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available limits from FSBI_STG_UUICO.stg_coverage ';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_month;

--DROP TABLE fsbi_dw_uuico.dim_month;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_month
(
	month_id INTEGER NOT NULL  ENCODE RAW
	,mon_monthname VARCHAR(25)   ENCODE lzo
	,mon_monthabbr VARCHAR(4)   ENCODE lzo
	,mon_monthinquarter INTEGER   ENCODE az64
	,mon_monthinyear INTEGER   ENCODE az64
	,mon_year INTEGER   ENCODE az64
	,mon_quarter INTEGER   ENCODE az64
	,mon_startdate DATE   ENCODE az64
	,mon_enddate DATE   ENCODE az64
	,loaddate DATE   ENCODE az64
	,mon_reportperiod VARCHAR(6)   ENCODE lzo
	,mon_isodate VARCHAR(8)   ENCODE lzo
	,PRIMARY KEY (month_id)
)
DISTSTYLE AUTO
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_month owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_month IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: For backward compatibility only, not needed in new projects, all foreign keys (date fields) are integers in format YYYYMM. The same as in other schemas';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_policy;

--DROP TABLE fsbi_dw_uuico.dim_policy;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_policy
(
	policy_id INTEGER NOT NULL  ENCODE RAW
	,pol_policynumber VARCHAR(50)   ENCODE lzo
	,pol_spinnpolicynumber VARCHAR(50)   ENCODE lzo
	,pol_policynumbersuffix VARCHAR(10)   ENCODE lzo
	,pol_originaleffectivedate DATE   ENCODE az64
	,pol_quoteddate DATE   ENCODE az64
	,pol_issueddate DATE   ENCODE az64
	,pol_masterstate VARCHAR(50)   ENCODE lzo
	,pol_mastercountry VARCHAR(50)   ENCODE lzo
	,pol_uniqueid VARCHAR(100)   ENCODE lzo
	,pol_effectivedate DATE   ENCODE az64
	,pol_expirationdate DATE   ENCODE az64
	,pol_canceldate DATE   ENCODE az64
	,pol_status VARCHAR(20)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,PRIMARY KEY (policy_id)
)
DISTSTYLE AUTO
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_policy owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_policy IS 'DW Table type: Dimension Type 1 Table description: PolicyNumber, Version (pol_policynumbersuffix), State from FSBI_STG_UUICO.stg_policy';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.dim_policy.pol_canceldate IS 'The content is updated in ETL based on a cancelation transaction effective date after FACT_POLICYTRANSACTION load. The data in stg_policy is not reliable and not taken into account.';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_policytransactiontype;

--DROP TABLE fsbi_dw_uuico.dim_policytransactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_policytransactiontype
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
	,PRIMARY KEY (policytransactiontype_id)
)
DISTSTYLE AUTO
 SORTKEY (
	policytransactiontype_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_policytransactiontype owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_policytransactiontype IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: DW special table from 4SightBI original setup';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_producer;

--DROP TABLE fsbi_dw_uuico.dim_producer;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_producer
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
ALTER TABLE fsbi_dw_uuico.dim_producer owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_producer IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Producer(Agency) info  from FSBI_STG_UUICO.stg_legalentity';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_product;

--DROP TABLE fsbi_dw_uuico.dim_product;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_product
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
ALTER TABLE fsbi_dw_uuico.dim_product owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_product IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: list of products awailable in ICO DW';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_status;

--DROP TABLE fsbi_dw_uuico.dim_status;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_status
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
ALTER TABLE fsbi_dw_uuico.dim_status owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_status IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: DW special table with policies and claims statuses';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_territory;

--DROP TABLE fsbi_dw_uuico.dim_territory;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_territory
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
ALTER TABLE fsbi_dw_uuico.dim_territory owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_territory IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: Dictionary table. All available territories and codes. Rare used.';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_time;

--DROP TABLE fsbi_dw_uuico.dim_time;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_time
(
	time_id INTEGER NOT NULL  ENCODE RAW
	,tm_date DATE   ENCODE az64
	,tm_dayname VARCHAR(25)   ENCODE lzo
	,tm_dayabbr VARCHAR(4)   ENCODE lzo
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
	,tm_reportperiod VARCHAR(6)   ENCODE lzo
	,tm_isodate VARCHAR(8)   ENCODE lzo
	,month_id INTEGER   ENCODE az64
	,PRIMARY KEY (time_id)
)
DISTSTYLE AUTO
 SORTKEY (
	time_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_time owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_time IS 'DW Table type: Dimension Type 1 (Dictionary) Table description: For backward compatibility only, not needed in new projects, all foreign keys are integers in format YYYYMMDD. The same as in other schemas';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.dim_vehicle;

--DROP TABLE fsbi_dw_uuico.dim_vehicle;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.dim_vehicle
(
	vehicle_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,record_version INTEGER   ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,vehicle_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,vin VARCHAR(100) NOT NULL  ENCODE lzo
	,vehiclemake VARCHAR(100) NOT NULL  ENCODE lzo
	,vehiclemodel VARCHAR(100) NOT NULL  ENCODE lzo
	,vehicleyear INTEGER NOT NULL  ENCODE az64
	,vehiclemileage INTEGER NOT NULL  ENCODE az64
	,vehiclevalueamount INTEGER NOT NULL  ENCODE az64
	,vehicleadddate DATE NOT NULL  ENCODE az64
	,vehicleremovedate DATE NOT NULL  ENCODE az64
	,vehicleisosymbols VARCHAR(100) NOT NULL  ENCODE lzo
	,vehicleuse VARCHAR(100) NOT NULL  ENCODE lzo
	,garagingzip VARCHAR(100) NOT NULL  ENCODE lzo
	,status VARCHAR(20) NOT NULL  ENCODE lzo
	,sourcesystem VARCHAR(10) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,original_record_version INTEGER NOT NULL  ENCODE az64
	,audit_id INTEGER NOT NULL  ENCODE az64
	,verifiedmiles INTEGER  DEFAULT 0 ENCODE az64
	,PRIMARY KEY (vehicle_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	vehicle_id
	)
;
ALTER TABLE fsbi_dw_uuico.dim_vehicle owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.dim_vehicle IS 'DW Table type: Slowly Changing Dimension Type 2 Table description: Vehicle info  from FSBI_STG_UUICO.stg_vehicle';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.dim_vehicle.vehicleisosymbols IS 'ProgressiveSymbol';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.fact_claim;

--DROP TABLE fsbi_dw_uuico.fact_claim;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.fact_claim
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
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE lzo
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
	,examiner_id INTEGER  DEFAULT 0 ENCODE az64
)
DISTSTYLE AUTO
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_uuico.fact_claim owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.fact_claim IS 'DW Table type: Fact Monthly Summary table Table description: Monthly claim summaries. Months are based on accounting dates. You need to aggregate amounts from this table. It''s calculated based on Fact_Claimtransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.adjuster_id IS 'Foreign Key (link)  to dim_adjuster.adjuster_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.claim_id IS 'Foreign Key (link)  to dim_claim.claim_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.claimstatus_id IS 'Foreign Key (link)  to dim_status.status_id It`s calculated based on if Loss Reserve is positive then Open else Closed. No other expenses are taken into account. If there are any previous month in Closed status then Status is Reopen.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.claimlossgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.claimlossaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.datereported_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.dateofloss_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.openeddate_id IS 'Foreign Key (link)  to dim_time.time_id It`s calculated based on reserve transaction effective date.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.closeddate_id IS 'Foreign Key (link)  to dim_time.time_id It`s calculated based on reserve transaction effective date. Default (19000101) for Open or Reopen claims';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.claimnumber IS 'The number associated with this claim.  This is inserted into the fact table to do distinct counts.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.policy_uniqueid IS 'The policy unique ID that uniquely identifies each policy.  This value has been degenerated from the policy dimension table to provide unique counts and improved query performance.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.coverage_uniqueid IS 'The coverage unique ID that uniquely identifies each coverage.  This value has been degenerated from the coverage dimension table to provide improved performance when loading the warehouse.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.loss_pd_amt IS 'Loss(Indemnity) paid amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.loss_rsrv_chng_amt IS 'Change in the loss reserve(Outstanding case reserve) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.alc_exp_pd_amt IS 'Amount of allocated expenses(ALAE) paid (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.alc_exp_rsrv_chng_amt IS 'Change in allocated expense reserve(Outstanding ALAE reserve) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.ualc_exp_pd_amt IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.ualc_exp_rsrv_chng_amt IS 'Change in Defense & Cost Containment Expenses (DCCE) reserve amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.subro_recv_chng_amt IS 'Change in received(recovered) subrogation amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.subro_rsrv_chng_amt IS 'Change in reserve subrogation amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.salvage_recv_chng_amt IS 'Change in salvage received(recovered) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.salvage_rsrv_chng_amt IS 'Change in salvage reserve amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.loss_pd_amt_ytd IS 'Loss(Indemnity) paid amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.loss_rsrv_chng_amt_ytd IS 'Change in the loss reserve(Outstanding case reserve) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.alc_exp_pd_amt_ytd IS 'Amount of allocated expenses(ALAE) paid (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.alc_exp_rsrv_chng_amt_ytd IS 'Change in allocated expense reserve(Outstanding ALAE reserve) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.ualc_exp_pd_amt_ytd IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.ualc_exp_rsrv_chng_amt_ytd IS 'Change in Defense & Cost Containment Expenses (DCCE) reserve amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.subro_recv_chng_amt_ytd IS 'Change in received(recovered) subrogation amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.subro_rsrv_chng_amt_ytd IS 'Change in reserve subrogation amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.salvage_recv_chng_amt_ytd IS 'Change in salvage received(recovered) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.salvage_rsrv_chng_amt_ytd IS 'Change in salvage reserve amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.loss_pd_amt_itd IS 'Loss(Indemnity) paid amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.loss_rsrv_chng_amt_itd IS 'Loss reserve(Outstanding case reserve) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.alc_exp_pd_amt_itd IS 'Amount of allocated expenses(ALAE) paid (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.alc_exp_rsrv_chng_amt_itd IS 'Allocated expense reserve(Outstanding ALAE reserve) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.ualc_exp_pd_amt_itd IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.ualc_exp_rsrv_chng_amt_itd IS 'Defense & Cost Containment Expenses (DCCE) reserve amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.subro_recv_chng_amt_itd IS 'Change in received(recovered) subrogation amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.subro_rsrv_chng_amt_itd IS 'Amount of reserve subrogation  (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.salvage_recv_chng_amt_itd IS 'Change in salvage received(recovered) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.salvage_rsrv_chng_amt_itd IS 'Change in salvage reserve amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.feat_days_open IS 'Returns the number of days a claim feature has been open (month-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.feat_days_open_itd IS 'Returns the number of days a claim feature has been open (inception-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.feat_opened_in_month IS 'Indicates if the claim feature was opened in the month.  1 = Opened In the Month, 0 = Not Opened in the Month.  The field can be summed to get the number of claim  features opened in a given month.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.feat_closed_in_month IS 'Indicates if the claim feature was closed in the month.  1 = Closed In the Month, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed in a given month.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.feat_closed_without_pay IS 'Indicates if the claim feature was closed in the month and had no losses paid on it.  1 = Closed In the Month without Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed in a given month without pay.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.feat_closed_with_pay IS 'Indicates if the claim feature was closed with losses paid in the month.  1 = Closed In the Month with Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed with pay in a given month.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.clm_days_open IS 'Returns the number of days a claim has been open (month-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.clm_days_open_itd IS 'Returns the number of days a claim has been open (inception-to-date)';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.clm_opened_in_month IS 'Indicates if the claim was opened in the month.  1 = Opened In the Month, 0 = Not Opened in the Month.  The field can be summed to get the number of claims opened in a given month.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.clm_closed_in_month IS 'Indicates if the claim was closed in the month.  1 = Closed In the Month, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed in a given month.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.clm_closed_without_pay IS 'Indicates if the claim was closed in the month and had no losses paid on it.  1 = Closed In the Month without Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed in a given month without pay.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.clm_closed_with_pay IS 'Indicates if the claim was closed with losses paid in the month.  1 = Closed In the Month with Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed with pay in a given month.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.masterclaim IS 'Indicates that this is the master record for the claim - the record that contains the overall claim status counts';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.claim_uniqueid IS 'The claim unique ID that uniquely identifies each claim.  This value has been degenerated from the claim dimension table to provide unique counts and improved query performance.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claim.examiner_id IS 'Foreign Key (link) to dim_examiner.examiner_id';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.fact_claimtransaction;

--DROP TABLE fsbi_dw_uuico.fact_claimtransaction;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.fact_claimtransaction
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
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE lzo
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
	,examiner_id INTEGER  DEFAULT 0 ENCODE az64
)
DISTSTYLE AUTO
 SORTKEY (
	accountingdate_id
	)
;
ALTER TABLE fsbi_dw_uuico.fact_claimtransaction owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.fact_claimtransaction IS 'DW Table type: Fact table Table description: Claim transactions from FSBI_STG_UUICO.stg_claimtransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.transactiondate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.accountingdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.claimtransactiontype_id IS 'Foreign Key (link)  to dim_claimtransactiontype.claimtransactiontype_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.adjuster_id IS 'Foreign Key (link)  to dim_adjuster.adjuster_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.claim_id IS 'Foreign Key (link)  to dim_claim.claim_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.claimstatus_id IS 'Foreign Key (link)  to dim_status.status_id. There is a simplified calculation to match a similar column in FACT_CLAIM: All transactions in a month where sum of Loss Reserve is positive are Open else Closed. No other expenses are taken into account. If there are any previous month in Closed status then Status is Reopen.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.claimlossgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.claimlossaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.openeddate_id IS 'Foreign Key (link)  to dim_time.time_id There is a simplified calculation to match a similar column in FACT_CLAIM: All transactions in a month have the same date as in FACT_CLAIM.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.closeddate_id IS 'Foreign Key (link)  to dim_time.time_id There is a simplified calculation to match a similar column in FACT_CLAIM. All transactions in a month have the same date as in FACT_CLAIM.';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.datereported_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.dateofloss_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_claimtransaction.examiner_id IS 'Foreign Key (link) to dim_examiner.examiner_id';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.fact_policy;

--DROP TABLE fsbi_dw_uuico.fact_policy;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.fact_policy
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
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE lzo
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
ALTER TABLE fsbi_dw_uuico.fact_policy owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.fact_policy IS 'DW Table type: Fact Monthly Summary table Table description: Monthly summaries at policy term level. Months are based on accounting dates . It''s calculated based on Fact_PolicyCoverage';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.fact_policycoverage;

--DROP TABLE fsbi_dw_uuico.fact_policycoverage;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.fact_policycoverage
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
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,month_vehicle_id INTEGER NOT NULL  ENCODE az64
	,month_driver_id INTEGER NOT NULL  ENCODE az64
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE lzo
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
ALTER TABLE fsbi_dw_uuico.fact_policycoverage owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.fact_policycoverage IS 'DW Table type: Fact Monthly Summary table Table description: Monthly summaries at coverage level plus monthly policy state of coverages and risks (limits, deductibles) Months are based on accounting dates. You need to aggregate amounts from this table. . It''s calculated based on Fact_Policytransaction';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.fact_policytransaction;

--DROP TABLE fsbi_dw_uuico.fact_policytransaction;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.fact_policytransaction
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
	,vehicle_id INTEGER NOT NULL  ENCODE az64
	,driver_id INTEGER NOT NULL  ENCODE az64
	,trn_vehicle_id INTEGER NOT NULL  ENCODE az64
	,trn_driver_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE lzo
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
	policytransactiontype_id
	)
;
ALTER TABLE fsbi_dw_uuico.fact_policytransaction owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.fact_policytransaction IS 'DW Table type: Fact table Table description: Policy transactions from FSBI_STG_UUICO.stg_policytransaction';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.transactiondate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.accountingdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.effectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.policytransactiontype_id IS 'Foreign Key (link)  to dim_policytransactiontype.policytransactiontype_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.trn_vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	 Use this column to get attributes effective at the moment of the specific transaction';
COMMENT ON COLUMN fsbi_dw_uuico.fact_policytransaction.trn_driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	 Use this column to get attributes effective at the moment of the specific transaction';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.stg_exposures;

--DROP TABLE fsbi_dw_uuico.stg_exposures;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.stg_exposures
(
	factpolicycoverage_id BIGINT   ENCODE lzo
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
ALTER TABLE fsbi_dw_uuico.stg_exposures owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.stg_exposures IS 'Staging table to keep intermitten exposure results';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.table_to_delete;

--DROP TABLE fsbi_dw_uuico.table_to_delete;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.table_to_delete
(
	table_name VARCHAR(128)   ENCODE lzo
)
DISTSTYLE EVEN
;
ALTER TABLE fsbi_dw_uuico.table_to_delete owner to kdrogaieva;

-- Drop table

-- DROP TABLE fsbi_dw_uuico.vmeris_claims;

--DROP TABLE fsbi_dw_uuico.vmeris_claims;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.vmeris_claims
(
	devq BIGINT   ENCODE RAW
	,reported_year INTEGER   ENCODE az64
	,reported_qtr INTEGER   ENCODE az64
	,loss_date DATE   ENCODE az64
	,reported_date DATE   ENCODE az64
	,carrier VARCHAR(100)   ENCODE lzo
	,company VARCHAR(50)   ENCODE lzo
	,policy_number VARCHAR(50)   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,riskcd VARCHAR(12)   ENCODE lzo
	,poleff_date DATE   ENCODE az64
	,polexp_date DATE   ENCODE az64
	,renewaltermcd VARCHAR(255)   ENCODE lzo
	,policyneworrenewal VARCHAR(7)   ENCODE lzo
	,policystate VARCHAR(2)   ENCODE lzo
	,producer_status VARCHAR(10)   ENCODE lzo
	,claim_number VARCHAR(50)   ENCODE RAW
	,claimant VARCHAR(50)   ENCODE RAW
	,cat_indicator VARCHAR(3)   ENCODE lzo
	,lob VARCHAR(3)   ENCODE lzo
	,lob2 VARCHAR(3)   ENCODE lzo
	,lob3 VARCHAR(3)   ENCODE lzo
	,product VARCHAR(2)   ENCODE lzo
	,policyformcode VARCHAR(20)   ENCODE lzo
	,programind VARCHAR(6)   ENCODE lzo
	,featuretype VARCHAR(4)   ENCODE lzo
	,feature VARCHAR(5)   ENCODE RAW
	,claim_status VARCHAR(6)   ENCODE lzo
	,source_system VARCHAR(5)   ENCODE lzo
	,itd_paid_expense NUMERIC(38,2)   ENCODE az64
	,itd_paid_dcc_expense NUMERIC(38,2)   ENCODE az64
	,itd_paid_loss NUMERIC(38,2)   ENCODE az64
	,itd_incurred NUMERIC(38,2)   ENCODE az64
	,itd_incurred_net_salvage_subrogation NUMERIC(38,2)   ENCODE az64
	,itd_total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,itd_reserve NUMERIC(38,2)   ENCODE az64
	,itd_loss_and_alae_for_paid_count NUMERIC(38,2)   ENCODE az64
	,itd_salvage_and_subrogation NUMERIC(38,2)   ENCODE az64
	,qtd_paid_dcc_expense NUMERIC(38,2)   ENCODE az64
	,qtd_paid_expense NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_expense NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_dcc_expense NUMERIC(38,2)   ENCODE az64
	,qtd_paid_salvage_and_subrogation NUMERIC(38,2)   ENCODE az64
	,qtd_paid_loss NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_loss NUMERIC(38,2)   ENCODE az64
	,qtd_paid NUMERIC(38,2)   ENCODE az64
	,qtd_incurred NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation NUMERIC(38,2)   ENCODE az64
	,qtd_total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,qtd_paid_25k NUMERIC(38,2)   ENCODE az64
	,qtd_paid_50k NUMERIC(38,2)   ENCODE az64
	,qtd_paid_100k NUMERIC(38,2)   ENCODE az64
	,qtd_paid_250k NUMERIC(38,2)   ENCODE az64
	,qtd_paid_500k NUMERIC(38,2)   ENCODE az64
	,qtd_paid_1m NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation_25k NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation_50k NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation_100k NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation_250k NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation_500k NUMERIC(38,2)   ENCODE az64
	,qtd_incurred_net_salvage_subrogation_1m NUMERIC(38,2)   ENCODE az64
	,x_itd_incurred_net_salvage_subrogation_250k NUMERIC(38,2)   ENCODE az64
	,x_itd_incurred_net_salvage_subrogation_500k NUMERIC(38,2)   ENCODE az64
	,reported_count INTEGER   ENCODE az64
	,closed_count INTEGER   ENCODE az64
	,closed_nopay INTEGER   ENCODE az64
	,paid_on_closed_loss NUMERIC(38,2)   ENCODE az64
	,paid_on_closed_expense NUMERIC(38,2)   ENCODE az64
	,paid_on_closed_dcc_expense NUMERIC(38,2)   ENCODE az64
	,paid_on_closed_salvage_subrogation NUMERIC(38,2)   ENCODE az64
	,paid_count INTEGER   ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,itd_paid NUMERIC(38,2)   ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (claim_number)
;
ALTER TABLE fsbi_dw_uuico.vmeris_claims owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.vmeris_claims IS 'UU ICO ERIS Losses detail level.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.devq IS 'DevQ is based on claims loss dates quarters. DevQ is NOT a quarter number. It''s number of months in quarter. (3*number of development quarters). evQ is always less then or equal 120. It''s forcefully set to 120 for higher numbers.';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.reported_year IS 'Year based on claim transaction date';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.reported_qtr IS 'Quarter based on claim transaction date';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.featuretype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.feature IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.claim_status IS 'Closed when Reserve=0 or Open';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_paid_expense IS 'ITD (Inception To date): aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_paid_dcc_expense IS 'ITD (Inception To date): dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_paid_loss IS 'ITD (Inception To date):loss_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_incurred IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_incurred_net_salvage_subrogation IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_total_incurred_loss IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_reserve IS 'ITD (Inception To date):loss_reserve + aoo_reserve + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_loss_and_alae_for_paid_count IS 'ITD (Inception To date): loss_paid + aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_salvage_and_subrogation IS 'ITD (Inception To date: salvage_received + subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_dcc_expense IS 'QTD (Reported_Year, Reported_Qtr To date): dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_expense IS 'QTD (Reported_Year, Reported_Qtr To date): aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_expense IS 'QTD (Reported_Year, Reported_Qtr To date): aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_dcc_expense IS 'QTD (Reported_Year, Reported_Qtr To date): dcc_paid + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_salvage_and_subrogation IS 'QTD (Reported_Year, Reported_Qtr To date): salvage_received + subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_loss IS 'QTD (Reported_Year, Reported_Qtr To date): loss_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_loss IS 'QTD (Reported_Year, Reported_Qtr To date): loss_paid + loss_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_total_incurred_loss IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_25k IS 'QTD (Reported_Year, Reported_Qtr To date): least(25k, itd_paid) - prev quarter least(25k, itd_paid) ';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_50k IS 'QTD (Reported_Year, Reported_Qtr To date):least(50k, itd_paid) - prev quarter least(50k, itd_paid) ';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_100k IS 'QTD (Reported_Year, Reported_Qtr To date): least(100k, itd_paid) - prev quarter least(100k, itd_paid) ';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_250k IS 'QTD (Reported_Year, Reported_Qtr To date): least(250k, itd_paid) - prev quarter least(250k, itd_paid) ';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_500k IS 'QTD (Reported_Year, Reported_Qtr To date): least(500k, itd_paid) - prev quarter least(500k, itd_paid) ';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_paid_1m IS 'QTD (Reported_Year, Reported_Qtr To date): least(1m, itd_paid) - prev quarter least(1m,itd_paid) ';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation_25k IS 'QTD (Reported_Year, Reported_Qtr To date): least(25k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(25k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation_50k IS 'QTD (Reported_Year, Reported_Qtr To date): least(50k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(50k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation_100k IS 'QTD (Reported_Year, Reported_Qtr To date): least(100k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(100k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation_250k IS 'QTD (Reported_Year, Reported_Qtr To date): least(250k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(250k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation_500k IS 'QTD (Reported_Year, Reported_Qtr To date): least(500k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(500k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.qtd_incurred_net_salvage_subrogation_1m IS 'QTD (Reported_Year, Reported_Qtr To date): least(1m,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(1m,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.x_itd_incurred_net_salvage_subrogation_250k IS 'case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 250000) else 0 end';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.x_itd_incurred_net_salvage_subrogation_500k IS 'case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 500000) else 0 end';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.reported_count IS '1 or 0 Reported Count is based on transactional level.  The script is looking for the first transaction date(*) and quarter when this condition is TRUE in a transaction (no aggragation in metric values): loss_paid>=0.5 or loss_reserve>=0.5 or f.aoo_paid>=0.5 or aoo_reserve>=0.5 or dcc_paid>=0.5 or dcc_reserve>=0.5 or salvage_received>=0.5 or subro_received>=0.5';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.closed_count IS '1 or 0 Closed Count is based on transactional level. The script is looking for the latest transaction date and quarter (from transactional date) when this condition is TRUE:sum(loss_reserve + aoo_reserve + dcc_reserve)<0.5 (The data are aggregated at the claim-claimant-ERIS feature level (see Configuration) and transaction date)';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.closed_nopay IS 'The same as closed count but in the same quorter this condition should be TRUE ITD_Paid_Loss + ITD_Paid_Expense<=0 to have 1 in the metric';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.paid_on_closed_loss IS 'ITD_Paid_Loss If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.paid_on_closed_expense IS 'ITD_Paid_Expense If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.paid_on_closed_dcc_expense IS 'ITD_Paid_DCC_Expense If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.paid_on_closed_salvage_subrogation IS 'ITD_Salvage_and_subrogation If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.paid_count IS '1 in DevQ when ITD_Loss_and_ALAE_for_Paid_count>0';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_claims.itd_paid IS 'ITD (Inception To date): itd_paid_loss+ itd_paid_expense- itd_salvage_and_subrogation';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.vmeris_policies;

--DROP TABLE fsbi_dw_uuico.vmeris_policies;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.vmeris_policies
(
	report_year INTEGER   ENCODE az64
	,report_quarter INTEGER   ENCODE az64
	,policynumber VARCHAR(50)   ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,riskcd VARCHAR(12)   ENCODE lzo
	,policyversion VARCHAR(10)   ENCODE lzo
	,effectivedate DATE   ENCODE az64
	,expirationdate DATE   ENCODE az64
	,renewaltermcd VARCHAR(255)   ENCODE lzo
	,policyneworrenewal VARCHAR(10)   ENCODE lzo
	,policystate VARCHAR(50)   ENCODE lzo
	,companynumber VARCHAR(50)   ENCODE lzo
	,company VARCHAR(100)   ENCODE lzo
	,lob VARCHAR(3)   ENCODE lzo
	,asl VARCHAR(5)   ENCODE lzo
	,lob2 VARCHAR(3)   ENCODE lzo
	,lob3 VARCHAR(3)   ENCODE lzo
	,product VARCHAR(2)   ENCODE lzo
	,policyformcode VARCHAR(255)   ENCODE lzo
	,programind VARCHAR(6)   ENCODE lzo
	,producer_status VARCHAR(10)   ENCODE lzo
	,coveragetype VARCHAR(4)   ENCODE lzo
	,coverage VARCHAR(5)   ENCODE lzo
	,feeind VARCHAR(1)   ENCODE lzo
	,source VARCHAR(10)   ENCODE lzo
	,wp NUMERIC(38,2)   ENCODE az64
	,ep NUMERIC(38,2)   ENCODE az64
	,clep DOUBLE PRECISION   ENCODE RAW
	,ee NUMERIC(38,3)   ENCODE az64
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	report_year
	, report_quarter
	)
;
ALTER TABLE fsbi_dw_uuico.vmeris_policies owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.vmeris_policies IS 'ERIS Premiums detail level. Business Owner: Yiqin Huang';

-- Column comments

COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.report_year IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.report_quarter IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.coveragetype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.coverage IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.wp IS 'Written Premium';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.ep IS 'Earned Premium';
COMMENT ON COLUMN fsbi_dw_uuico.vmeris_policies.clep IS 'Current Level Earned Premium: Earned premium adjusted using all rate changes starting after policy term effecyive date, based on company,  state, policyformcode,  new or renewal policy. ';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.vmfact_claim_blended;

--DROP TABLE fsbi_dw_uuico.vmfact_claim_blended;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.vmfact_claim_blended
(
	month_id INTEGER   ENCODE az64
	,claim_number VARCHAR(50)   ENCODE lzo
	,catastrophe_id INTEGER   ENCODE az64
	,claimant VARCHAR(50)   ENCODE lzo
	,feature VARCHAR(75)   ENCODE lzo
	,feature_desc VARCHAR(125)   ENCODE lzo
	,feature_type VARCHAR(100)   ENCODE lzo
	,aslob VARCHAR(5)   ENCODE lzo
	,rag VARCHAR(3)   ENCODE lzo
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
	,product_code VARCHAR(100)   ENCODE lzo
	,product VARCHAR(100)   ENCODE lzo
	,subproduct VARCHAR(100)   ENCODE lzo
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
	,loss_cause VARCHAR(255)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,iseco BOOLEAN  DEFAULT false ENCODE RAW
	,elr VARCHAR(32)   ENCODE lzo
	,coverage_id_original INTEGER   ENCODE az64
	,dateofloss_id_original INTEGER   ENCODE az64
	,fin_source_id VARCHAR(3)   ENCODE lzo
	,fin_company_id VARCHAR(2)   ENCODE lzo
	,fin_location_id VARCHAR(4)   ENCODE lzo
	,fin_product_id VARCHAR(3)   ENCODE lzo
	,businesssource VARCHAR(16)   ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 DISTKEY (month_id)
;
ALTER TABLE fsbi_dw_uuico.vmfact_claim_blended owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_uuico.vmfact_claim_blended IS 'Monthly summaries of fsbi_dw_uuico.vmfact_claimtransaction_blended based on month of acct_date';

-- Drop table

-- DROP TABLE fsbi_dw_uuico.vmfact_claimtransaction_blended;

--DROP TABLE fsbi_dw_uuico.vmfact_claimtransaction_blended;
CREATE TABLE IF NOT EXISTS fsbi_dw_uuico.vmfact_claimtransaction_blended
(
	claimtransaction_id INTEGER   ENCODE RAW
	,source_system VARCHAR(5)   ENCODE RAW
	,businesssource VARCHAR(16)   ENCODE bytedict
	,trans_date DATE   ENCODE RAW
	,acct_date DATE   ENCODE RAW
	,claim_number VARCHAR(16)   ENCODE RAW
	,claimant VARCHAR(3)   ENCODE lzo
	,feature VARCHAR(32)   ENCODE lzo
	,feature_desc VARCHAR(64)   ENCODE lzo
	,feature_type VARCHAR(1)   ENCODE lzo
	,aslob VARCHAR(3)   ENCODE bytedict
	,catastrophe_id INTEGER   ENCODE az64
	,iseco BOOLEAN   ENCODE RAW
	,rag VARCHAR(3)   ENCODE bytedict
	,elr VARCHAR(32)   ENCODE lzo
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
	,product_code VARCHAR(32)   ENCODE lzo
	,product VARCHAR(32)   ENCODE lzo
	,subproduct VARCHAR(32)   ENCODE lzo
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
	,loss_cause VARCHAR(32)   ENCODE lzo
	,changetype VARCHAR(5)   ENCODE lzo
	,claimtransactiontype_id_original INTEGER   ENCODE az64
	,coverage_id_original INTEGER   ENCODE az64
	,dateofloss_id_original INTEGER   ENCODE az64
	,amount_original NUMERIC(13,2)   ENCODE az64
	,fin_source_id VARCHAR(3)   ENCODE lzo
	,fin_company_id VARCHAR(2)   ENCODE lzo
	,fin_location_id VARCHAR(4)   ENCODE lzo
	,fin_product_id VARCHAR(3)   ENCODE lzo
	,policy_id INTEGER  DEFAULT 0 ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (claimtransaction_id)
;
ALTER TABLE fsbi_dw_uuico.vmfact_claimtransaction_blended owner to emiller;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_accountingdate
AS SELECT dim_time.time_id AS accountingdate_id, dim_time.tm_date AS acct_date, dim_time.tm_dayname AS acct_dayname, dim_time.tm_dayabbr AS acct_dayabbr, dim_time.tm_dayinweek AS acct_dayinweek, dim_time.tm_dayinmonth AS acct_dayinmonth, dim_time.tm_dayinquarter AS acct_dayinquarter, dim_time.tm_dayinyear AS acct_dayinyear, dim_time.tm_weekinmonth AS acct_weekinmonth, dim_time.tm_weekinquarter AS acct_weekinquarter, dim_time.tm_weekinyear AS acct_weekinyear, dim_time.tm_monthname AS acct_monthname, dim_time.tm_monthabbr AS acct_monthabbr, dim_time.tm_monthinquarter AS acct_monthinquarter, dim_time.tm_monthinyear AS acct_monthinyear, dim_time.tm_quarter AS acct_quarter, dim_time.tm_year AS acct_year, dim_time.tm_reportperiod AS acct_reportperiod, dim_time.tm_isodate AS acct_isodate, dim_time.month_id AS acct_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_agingstartdate
AS SELECT dim_time.time_id AS agingstartdate_id, dim_time.tm_date AS asdt_date, dim_time.tm_dayname AS asdt_dayname, dim_time.tm_dayabbr AS asdt_dayabbr, dim_time.tm_dayinweek AS asdt_dayinweek, dim_time.tm_dayinmonth AS asdt_dayinmonth, dim_time.tm_dayinquarter AS asdt_dayinquarter, dim_time.tm_dayinyear AS asdt_dayinyear, dim_time.tm_weekinmonth AS asdt_weekinmonth, dim_time.tm_weekinquarter AS asdt_weekinquarter, dim_time.tm_weekinyear AS asdt_weekinyear, dim_time.tm_monthname AS asdt_monthname, dim_time.tm_monthabbr AS asdt_monthabbr, dim_time.tm_monthinquarter AS asdt_monthinquarter, dim_time.tm_monthinyear AS asdt_monthinyear, dim_time.tm_quarter AS asdt_quarter, dim_time.tm_year AS asdt_year, dim_time.tm_reportperiod AS asdt_reportperiod, dim_time.tm_isodate AS asdt_isodate, dim_time.month_id AS asdt_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_bookeffectivedate
AS SELECT dim_time.time_id AS bookeffectivedate_id, dim_time.tm_date AS bkeff_date, dim_time.tm_dayname AS bkeff_dayname, dim_time.tm_dayabbr AS bkeff_dayabbr, dim_time.tm_dayinweek AS bkeff_dayinweek, dim_time.tm_dayinmonth AS bkeff_dayinmonth, dim_time.tm_dayinquarter AS bkeff_dayinquarter, dim_time.tm_dayinyear AS bkeff_dayinyear, dim_time.tm_weekinmonth AS bkeff_weekinmonth, dim_time.tm_weekinquarter AS bkeff_weekinquarter, dim_time.tm_weekinyear AS bkeff_weekinyear, dim_time.tm_monthname AS bkeff_monthname, dim_time.tm_monthabbr AS bkeff_monthabbr, dim_time.tm_monthinquarter AS bkeff_monthinquarter, dim_time.tm_monthinyear AS bkeff_monthinyear, dim_time.tm_quarter AS bkeff_quarter, dim_time.tm_year AS bkeff_year, dim_time.tm_reportperiod AS bkeff_reportperiod, dim_time.tm_isodate AS bkeff_isodate, dim_time.month_id AS bkeff_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_bookexpirationdate
AS SELECT dim_time.time_id AS bookexpirationdate_id, dim_time.tm_date AS bkexp_date, dim_time.tm_dayname AS bkexp_dayname, dim_time.tm_dayabbr AS bkexp_dayabbr, dim_time.tm_dayinweek AS bkexp_dayinweek, dim_time.tm_dayinmonth AS bkexp_dayinmonth, dim_time.tm_dayinquarter AS bkexp_dayinquarter, dim_time.tm_dayinyear AS bkexp_dayinyear, dim_time.tm_weekinmonth AS bkexp_weekinmonth, dim_time.tm_weekinquarter AS bkexp_weekinquarter, dim_time.tm_weekinyear AS bkexp_weekinyear, dim_time.tm_monthname AS bkexp_monthname, dim_time.tm_monthabbr AS bkexp_monthabbr, dim_time.tm_monthinquarter AS bkexp_monthinquarter, dim_time.tm_monthinyear AS bkexp_monthinyear, dim_time.tm_quarter AS bkexp_quarter, dim_time.tm_year AS bkexp_year, dim_time.tm_reportperiod AS bkexp_reportperiod, dim_time.tm_isodate AS bkexp_isodate, dim_time.month_id AS bkexp_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_claimant
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
	fsbi_dw_uuico.dim_claimant dim_legalentity
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_closedate
AS SELECT dim_time.time_id AS closeddate_id, dim_time.tm_date AS clsdt_date, dim_time.tm_dayname AS clsdt_dayname, dim_time.tm_dayabbr AS clsdt_dayabbr, dim_time.tm_dayinweek AS clsdt_dayinweek, dim_time.tm_dayinmonth AS clsdt_dayinmonth, dim_time.tm_dayinquarter AS clsdt_dayinquarter, dim_time.tm_dayinyear AS clsdt_dayinyear, dim_time.tm_weekinmonth AS clsdt_weekinmonth, dim_time.tm_weekinquarter AS clsdt_weekinquarter, dim_time.tm_weekinyear AS clsdt_weekinyear, dim_time.tm_monthname AS clsdt_monthname, dim_time.tm_monthabbr AS clsdt_monthabbr, dim_time.tm_monthinquarter AS clsdt_monthinquarter, dim_time.tm_monthinyear AS clsdt_monthinyear, dim_time.tm_quarter AS clsdt_quarter, dim_time.tm_year AS clsdt_year, dim_time.tm_reportperiod AS clsdt_reportperiod, dim_time.tm_isodate AS clsdt_isodate, dim_time.month_id AS clsdt_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_company
AS SELECT dim_legalentity.legalentity_id AS company_id, dim_legalentity.lenty_role AS comp_role, dim_legalentity.lenty_number AS comp_number, dim_legalentity.lenty_name1 AS comp_name1, dim_legalentity.lenty_uniqueid AS comp_uniqueid, dim_legalentity.source_system, dim_legalentity.loaddate
   FROM fsbi_dw_uuico.dim_legalentity_other dim_legalentity
  WHERE dim_legalentity.lenty_role::text = 'COMPANY'::character varying::text;

COMMENT ON VIEW fsbi_dw_uuico.vdim_company IS 'DW Table type: Dimension Table description: There is only company because the physical table dim_legalentity_other contains few entities with very small number of records';

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_coverageeffectivedate
AS SELECT dim_time.time_id AS coverageeffectivedate_id, dim_time.tm_date AS coveff_date, dim_time.tm_dayname AS coveff_dayname, dim_time.tm_dayabbr AS coveff_dayabbr, dim_time.tm_dayinweek AS coveff_dayinweek, dim_time.tm_dayinmonth AS coveff_dayinmonth, dim_time.tm_dayinquarter AS coveff_dayinquarter, dim_time.tm_dayinyear AS coveff_dayinyear, dim_time.tm_weekinmonth AS coveff_weekinmonth, dim_time.tm_weekinquarter AS coveff_weekinquarter, dim_time.tm_weekinyear AS coveff_weekinyear, dim_time.tm_monthname AS coveff_monthname, dim_time.tm_monthabbr AS coveff_monthabbr, dim_time.tm_monthinquarter AS coveff_monthinquarter, dim_time.tm_monthinyear AS coveff_monthinyear, dim_time.tm_quarter AS coveff_quarter, dim_time.tm_year AS coveff_year, dim_time.tm_reportperiod AS coveff_reportperiod, dim_time.tm_isodate AS coveff_isodate, dim_time.month_id AS coveff_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_coverageexpirationdate
AS SELECT dim_time.time_id AS coverageexpirationdate_id, dim_time.tm_date AS covexp_date, dim_time.tm_dayname AS covexp_dayname, dim_time.tm_dayabbr AS covexp_dayabbr, dim_time.tm_dayinweek AS covexp_dayinweek, dim_time.tm_dayinmonth AS covexp_dayinmonth, dim_time.tm_dayinquarter AS covexp_dayinquarter, dim_time.tm_dayinyear AS covexp_dayinyear, dim_time.tm_weekinmonth AS covexp_weekinmonth, dim_time.tm_weekinquarter AS covexp_weekinquarter, dim_time.tm_weekinyear AS covexp_weekinyear, dim_time.tm_monthname AS covexp_monthname, dim_time.tm_monthabbr AS covexp_monthabbr, dim_time.tm_monthinquarter AS covexp_monthinquarter, dim_time.tm_monthinyear AS covexp_monthinyear, dim_time.tm_quarter AS covexp_quarter, dim_time.tm_year AS covexp_year, dim_time.tm_reportperiod AS covexp_reportperiod, dim_time.tm_isodate AS covexp_isodate, dim_time.month_id AS covexp_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_dateofloss
AS SELECT dim_time.time_id AS dateofloss_id, dim_time.tm_date AS dol_date, dim_time.tm_dayname AS dol_dayname, dim_time.tm_dayabbr AS dol_dayabbr, dim_time.tm_dayinweek AS dol_dayinweek, dim_time.tm_dayinmonth AS dol_dayinmonth, dim_time.tm_dayinquarter AS dol_dayinquarter, dim_time.tm_dayinyear AS dol_dayinyear, dim_time.tm_weekinmonth AS dol_weekinmonth, dim_time.tm_weekinquarter AS dol_weekinquarter, dim_time.tm_weekinyear AS dol_weekinyear, dim_time.tm_monthname AS dol_monthname, dim_time.tm_monthabbr AS dol_monthabbr, dim_time.tm_monthinquarter AS dol_monthinquarter, dim_time.tm_monthinyear AS dol_monthinyear, dim_time.tm_quarter AS dol_quarter, dim_time.tm_year AS dol_year, dim_time.tm_reportperiod AS dol_reportperiod, dim_time.tm_isodate AS dol_isodate, dim_time.month_id AS dol_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_duedate
AS SELECT dim_time.time_id AS duedate_id, dim_time.tm_date AS duedt_date, dim_time.tm_dayname AS duedt_dayname, dim_time.tm_dayabbr AS duedt_dayabbr, dim_time.tm_dayinweek AS duedt_dayinweek, dim_time.tm_dayinmonth AS duedt_dayinmonth, dim_time.tm_dayinquarter AS duedt_dayinquarter, dim_time.tm_dayinyear AS duedt_dayinyear, dim_time.tm_weekinmonth AS duedt_weekinmonth, dim_time.tm_weekinquarter AS duedt_weekinquarter, dim_time.tm_weekinyear AS duedt_weekinyear, dim_time.tm_monthname AS duedt_monthname, dim_time.tm_monthabbr AS duedt_monthabbr, dim_time.tm_monthinquarter AS duedt_monthinquarter, dim_time.tm_monthinyear AS duedt_monthinyear, dim_time.tm_quarter AS duedt_quarter, dim_time.tm_year AS duedt_year, dim_time.tm_reportperiod AS duedt_reportperiod, dim_time.tm_isodate AS duedt_isodate, dim_time.month_id AS duedt_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_effectivedate
AS SELECT dim_time.time_id AS effectivedate_id, dim_time.tm_date AS eff_date, dim_time.tm_dayname AS eff_dayname, dim_time.tm_dayabbr AS eff_dayabbr, dim_time.tm_dayinweek AS eff_dayinweek, dim_time.tm_dayinmonth AS eff_dayinmonth, dim_time.tm_dayinquarter AS eff_dayinquarter, dim_time.tm_dayinyear AS eff_dayinyear, dim_time.tm_weekinmonth AS eff_weekinmonth, dim_time.tm_weekinquarter AS eff_weekinquarter, dim_time.tm_weekinyear AS eff_weekinyear, dim_time.tm_monthname AS eff_monthname, dim_time.tm_monthabbr AS eff_monthabbr, dim_time.tm_monthinquarter AS eff_monthinquarter, dim_time.tm_monthinyear AS eff_monthinyear, dim_time.tm_quarter AS eff_quarter, dim_time.tm_year AS eff_year, dim_time.tm_reportperiod AS eff_reportperiod, dim_time.tm_isodate AS eff_isodate, dim_time.month_id AS eff_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_expirationdate
AS SELECT dim_time.time_id AS expirationdate_id, dim_time.tm_date AS exp_date, dim_time.tm_dayname AS exp_dayname, dim_time.tm_dayabbr AS exp_dayabbr, dim_time.tm_dayinweek AS exp_dayinweek, dim_time.tm_dayinmonth AS exp_dayinmonth, dim_time.tm_dayinquarter AS exp_dayinquarter, dim_time.tm_dayinyear AS exp_dayinyear, dim_time.tm_weekinmonth AS exp_weekinmonth, dim_time.tm_weekinquarter AS exp_weekinquarter, dim_time.tm_weekinyear AS exp_weekinyear, dim_time.tm_monthname AS exp_monthname, dim_time.tm_monthabbr AS exp_monthabbr, dim_time.tm_monthinquarter AS exp_monthinquarter, dim_time.tm_monthinyear AS exp_monthinyear, dim_time.tm_quarter AS exp_quarter, dim_time.tm_year AS exp_year, dim_time.tm_reportperiod AS exp_reportperiod, dim_time.tm_isodate AS exp_isodate, dim_time.month_id AS exp_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_openeddate
AS SELECT dim_time.time_id AS openeddate_id, dim_time.tm_date AS opndt_date, dim_time.tm_dayname AS opndt_dayname, dim_time.tm_dayabbr AS opndt_dayabbr, dim_time.tm_dayinweek AS opndt_dayinweek, dim_time.tm_dayinmonth AS opndt_dayinmonth, dim_time.tm_dayinquarter AS opndt_dayinquarter, dim_time.tm_dayinyear AS opndt_dayinyear, dim_time.tm_weekinmonth AS opndt_weekinmonth, dim_time.tm_weekinquarter AS opndt_weekinquarter, dim_time.tm_weekinyear AS opndt_weekinyear, dim_time.tm_monthname AS opndt_monthname, dim_time.tm_monthabbr AS opndt_monthabbr, dim_time.tm_monthinquarter AS opndt_monthinquarter, dim_time.tm_monthinyear AS opndt_monthinyear, dim_time.tm_quarter AS opndt_quarter, dim_time.tm_year AS opndt_year, dim_time.tm_reportperiod AS opndt_reportperiod, dim_time.tm_isodate AS opndt_isodate, dim_time.month_id AS opndt_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_policyeffectivedate
AS SELECT dim_time.time_id AS policyeffectivedate_id, dim_time.tm_date AS poleff_date, dim_time.tm_dayname AS poleff_dayname, dim_time.tm_dayabbr AS poleff_dayabbr, dim_time.tm_dayinweek AS poleff_dayinweek, dim_time.tm_dayinmonth AS poleff_dayinmonth, dim_time.tm_dayinquarter AS poleff_dayinquarter, dim_time.tm_dayinyear AS poleff_dayinyear, dim_time.tm_weekinmonth AS poleff_weekinmonth, dim_time.tm_weekinquarter AS poleff_weekinquarter, dim_time.tm_weekinyear AS poleff_weekinyear, dim_time.tm_monthname AS poleff_monthname, dim_time.tm_monthabbr AS poleff_monthabbr, dim_time.tm_monthinquarter AS poleff_monthinquarter, dim_time.tm_monthinyear AS poleff_monthinyear, dim_time.tm_quarter AS poleff_quarter, dim_time.tm_year AS poleff_year, dim_time.tm_reportperiod AS poleff_reportperiod, dim_time.tm_isodate AS poleff_isodate, dim_time.month_id AS poleff_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_policyexpirationdate
AS SELECT dim_time.time_id AS policyexpirationdate_id, dim_time.tm_date AS polexp_date, dim_time.tm_dayname AS polexp_dayname, dim_time.tm_dayabbr AS polexp_dayabbr, dim_time.tm_dayinweek AS polexp_dayinweek, dim_time.tm_dayinmonth AS polexp_dayinmonth, dim_time.tm_dayinquarter AS polexp_dayinquarter, dim_time.tm_dayinyear AS polexp_dayinyear, dim_time.tm_weekinmonth AS polexp_weekinmonth, dim_time.tm_weekinquarter AS polexp_weekinquarter, dim_time.tm_weekinyear AS polexp_weekinyear, dim_time.tm_monthname AS polexp_monthname, dim_time.tm_monthabbr AS polexp_monthabbr, dim_time.tm_monthinquarter AS polexp_monthinquarter, dim_time.tm_monthinyear AS polexp_monthinyear, dim_time.tm_quarter AS polexp_quarter, dim_time.tm_year AS polexp_year, dim_time.tm_reportperiod AS polexp_reportperiod, dim_time.tm_isodate AS polexp_isodate, dim_time.month_id AS polexp_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_policystatus
AS SELECT dim_status.status_id AS policystatus_id, dim_status.stat_4sightbistatuscd AS polst_4sightbistatuscd, dim_status.stat_statuscd AS polst_statuscd, dim_status.stat_status AS polst_status, dim_status.stat_substatuscd AS polst_substatuscd, dim_status.stat_substatus AS polst_substatus
   FROM fsbi_dw_uuico.dim_status
  WHERE dim_status.stat_category::text = 'policy'::character varying::text;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_producer
AS -- fsbi_dw_uuico.vdim_producer source


CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_producer
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
	fsbi_dw_uuico.dim_producer up
left join fsbi_dw_spinn.vdim_producer_lookup sp on
	up.producer_number::text = sp.prdr_number::text
   with no schema binding
   
;

COMMENT ON VIEW fsbi_dw_uuico.vdim_producer IS 'The view combines producer info from both SPINN/AMS/AgentSync and ICO. VDIM_PRODUCER in fsbi_dw_spinn is SCD2 but only the latest known producer info is used in fsbi_dw_uuico.vdim_producer';

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_reporteddate
AS SELECT dim_time.time_id AS datereported_id, dim_time.tm_date AS rptdt_date, dim_time.tm_dayname AS rptdt_dayname, dim_time.tm_dayabbr AS rptdt_dayabbr, dim_time.tm_dayinweek AS rptdt_dayinweek, dim_time.tm_dayinmonth AS rptdt_dayinmonth, dim_time.tm_dayinquarter AS rptdt_dayinquarter, dim_time.tm_dayinyear AS rptdt_dayinyear, dim_time.tm_weekinmonth AS rptdt_weekinmonth, dim_time.tm_weekinquarter AS rptdt_weekinquarter, dim_time.tm_weekinyear AS rptdt_weekinyear, dim_time.tm_monthname AS rptdt_monthname, dim_time.tm_monthabbr AS rptdt_monthabbr, dim_time.tm_monthinquarter AS rptdt_monthinquarter, dim_time.tm_monthinyear AS rptdt_monthinyear, dim_time.tm_quarter AS rptdt_quarter, dim_time.tm_year AS rptdt_year, dim_time.tm_reportperiod AS rptdt_reportperiod, dim_time.tm_isodate AS rptdt_isodate, dim_time.month_id AS rptdt_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.vdim_transactiondate
AS SELECT dim_time.time_id AS transactiondate_id, dim_time.tm_date AS trans_date, dim_time.tm_dayname AS trans_dayname, dim_time.tm_dayabbr AS trans_dayabbr, dim_time.tm_dayinweek AS trans_dayinweek, dim_time.tm_dayinmonth AS trans_dayinmonth, dim_time.tm_dayinquarter AS trans_dayinquarter, dim_time.tm_dayinyear AS trans_dayinyear, dim_time.tm_weekinmonth AS trans_weekinmonth, dim_time.tm_weekinquarter AS trans_weekinquarter, dim_time.tm_weekinyear AS trans_weekinyear, dim_time.tm_monthname AS trans_monthname, dim_time.tm_monthabbr AS trans_monthabbr, dim_time.tm_monthinquarter AS trans_monthinquarter, dim_time.tm_monthinyear AS trans_monthinyear, dim_time.tm_quarter AS trans_quarter, dim_time.tm_year AS trans_year, dim_time.tm_reportperiod AS trans_reportperiod, dim_time.tm_isodate AS trans_isodate, dim_time.month_id AS trans_month_id
   FROM fsbi_dw_uuico.dim_time
with no schema binding
;

CREATE OR REPLACE VIEW fsbi_dw_uuico.veris_losses
AS SELECT vmeris_claims.devq, pgdate_part('qtr'::text, vmeris_claims.loss_date::timestamp without time zone) AS loss_qtr, pgdate_part('year'::text, vmeris_claims.loss_date::timestamp without time zone) AS loss_year, vmeris_claims.reported_qtr, vmeris_claims.reported_year, vmeris_claims.cat_indicator, vmeris_claims.carrier, vmeris_claims.company, vmeris_claims.lob, vmeris_claims.lob2, vmeris_claims.lob3, vmeris_claims.product, vmeris_claims.policystate, vmeris_claims.programind, vmeris_claims.featuretype, vmeris_claims.feature, vmeris_claims.renewaltermcd, vmeris_claims.policyneworrenewal, vmeris_claims.claim_status, vmeris_claims.producer_status, vmeris_claims.source_system, sum(vmeris_claims.qtd_paid_dcc_expense) AS qtd_paid_dcc_expense, sum(vmeris_claims.qtd_paid_expense) AS qtd_paid_expense, sum(vmeris_claims.qtd_incurred_expense) AS qtd_incurred_expense, sum(vmeris_claims.qtd_incurred_dcc_expense) AS qtd_incurred_dcc_expense, sum(vmeris_claims.qtd_paid_salvage_and_subrogation) AS qtd_paid_salvage_and_subrogation, sum(vmeris_claims.qtd_paid_loss) AS qtd_paid_loss, sum(vmeris_claims.qtd_incurred_loss) AS qtd_incurred_loss, sum(vmeris_claims.qtd_paid) AS qtd_paid, sum(vmeris_claims.qtd_incurred) AS qtd_incurred, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation) AS qtd_incurred_net_salvage_subrogation, sum(vmeris_claims.qtd_total_incurred_loss) AS qtd_total_incurred_los, sum(vmeris_claims.paid_on_closed_salvage_subrogation) AS paid_on_closed_salvage_subrogation, sum(vmeris_claims.qtd_paid_25k) AS qtd_paid_25k, sum(vmeris_claims.qtd_paid_50k) AS qtd_paid_50k, sum(vmeris_claims.qtd_paid_100k) AS qtd_paid_100k, sum(vmeris_claims.qtd_paid_250k) AS qtd_paid_250k, sum(vmeris_claims.qtd_paid_500k) AS qtd_paid_500k, sum(vmeris_claims.qtd_paid_1m) AS qtd_paid_1m, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_25k) AS qtd_incurred_net_salvage_subrogation_25k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_50k) AS qtd_incurred_net_salvage_subrogation_50k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_100k) AS qtd_incurred_net_salvage_subrogation_100k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_250k) AS qtd_incurred_net_salvage_subrogation_250k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_500k) AS qtd_incurred_net_salvage_subrogation_500k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_1m) AS qtd_incurred_net_salvage_subrogation_1m, sum(vmeris_claims.reported_count) AS reported_count, sum(vmeris_claims.closed_count) AS closed_count, sum(vmeris_claims.closed_nopay) AS closed_nopay, sum(vmeris_claims.paid_on_closed_loss) AS paid_on_closed_loss, sum(vmeris_claims.paid_on_closed_expense) AS paid_on_closed_expense, sum(vmeris_claims.paid_on_closed_dcc_expense) AS paid_on_closed_dcc_expense, sum(vmeris_claims.paid_count) AS paid_count
   FROM fsbi_dw_uuico.vmeris_claims
  GROUP BY vmeris_claims.devq, pgdate_part('qtr'::text, vmeris_claims.loss_date::timestamp without time zone), pgdate_part('year'::text, vmeris_claims.loss_date::timestamp without time zone), vmeris_claims.reported_qtr, vmeris_claims.reported_year, vmeris_claims.cat_indicator, vmeris_claims.carrier, vmeris_claims.company, vmeris_claims.lob, vmeris_claims.lob2, vmeris_claims.lob3, vmeris_claims.product, vmeris_claims.policystate, vmeris_claims.programind, vmeris_claims.featuretype, vmeris_claims.feature, vmeris_claims.renewaltermcd, vmeris_claims.policyneworrenewal, vmeris_claims.claim_status, vmeris_claims.producer_status, vmeris_claims.source_system
 HAVING sum(vmeris_claims.qtd_paid) <> 0::numeric OR sum(vmeris_claims.qtd_incurred) <> 0::numeric OR sum(vmeris_claims.qtd_paid_25k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_50k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_100k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_250k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_500k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_1m) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_25k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_50k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_100k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_250k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_500k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_1m) <> 0::numeric OR sum(vmeris_claims.reported_count) <> 0 OR sum(vmeris_claims.closed_count) <> 0 OR sum(vmeris_claims.closed_nopay) <> 0 OR sum(vmeris_claims.paid_on_closed_loss) <> 0::numeric OR sum(vmeris_claims.paid_on_closed_expense) <> 0::numeric OR sum(vmeris_claims.paid_on_closed_dcc_expense) <> 0::numeric OR sum(vmeris_claims.paid_on_closed_salvage_subrogation) <> 0::numeric;

COMMENT ON VIEW fsbi_dw_uuico.veris_losses IS 'Aggregated ERIS Losses, having at least 1 non 0 metric.';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.devq IS 'DevQ is based on claims loss dates quarters. DevQ is NOT a quarter number. It''s number of months in quarter. (3*number of development quarters). DevQ is always less then or equal 120. It''s forcefully set to 120 for higher numbers.';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.loss_qtr IS 'Quarter based on claim loss date';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.loss_year IS 'Year based on claim loss date';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.reported_qtr IS 'Quarter based on claim transaction date';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.reported_year IS 'Year based on claim transaction date';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.featuretype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.feature IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.claim_status IS 'Closed when Reserve=0 or Open';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_dcc_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_dcc_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): dcc_paid + dcc_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_salvage_and_subrogation IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): salvage_received + subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_loss IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): loss_paid';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_loss IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): loss_paid + loss_reserve';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.paid_on_closed_salvage_subrogation IS 'sum of 	ITD_Salvage_and_subrogation If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_25k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(25k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_50k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(50k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_100k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(100k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_250k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(250k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_500k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(500k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_paid_1m IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(1m, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation_25k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(25k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation_50k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(50k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation_100k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(100k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation_250k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(250k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation_500k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(500k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.qtd_incurred_net_salvage_subrogation_1m IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(1m,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.reported_count IS 'sum of 	1 or 0 Reported Count is based on transactional level.  The script is looking for the first transaction date(*) and quarter when this condition is TRUE in a transaction (no aggragation in metric values): loss_paid>=0.5 or loss_reserve>=0.5 or f.aoo_paid>=0.5 or aoo_reserve>=0.5 or dcc_paid>=0.5 or dcc_reserve>=0.5 or salvage_received>=0.5 or subro_received>=0.5';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.closed_count IS 'sum of 	1 or 0 Closed Count is based on transactional level. The script is looking for the latest transaction date and quarter (from transactional date) when this condition is TRUE:sum(loss_reserve + aoo_reserve + dcc_reserve)<0.5 (The data are aggregated at the claim-claimant-ERIS feature level (see Configuration) and transaction date)';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.closed_nopay IS 'sum of 	The same as closed count but in the same quorter this condition should be TRUE ITD_Paid_Loss + ITD_Paid_Expense<=0 to have 1 in the metric';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.paid_on_closed_loss IS 'sum of 	ITD_Paid_Loss If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.paid_on_closed_expense IS 'sum of 	ITD_Paid_Expense If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.paid_on_closed_dcc_expense IS 'sum of 	ITD_Paid_DCC_Expense If closed_count 1 else 0';
COMMENT ON COLUMN fsbi_dw_uuico.veris_losses.paid_count IS 'sum of 	1 in DevQ when ITD_Loss_and_ALAE_for_Paid_count>0';

CREATE OR REPLACE VIEW fsbi_dw_uuico.veris_premium
AS SELECT vmeris_policies.report_year, vmeris_policies.report_quarter, vmeris_policies.renewaltermcd, vmeris_policies.policyneworrenewal, vmeris_policies.policystate, vmeris_policies.companynumber, vmeris_policies.company, vmeris_policies.lob, vmeris_policies.asl, vmeris_policies.lob2, vmeris_policies.lob3, vmeris_policies.product, vmeris_policies.policyformcode, vmeris_policies.programind, vmeris_policies.producer_status, vmeris_policies.coveragetype, vmeris_policies.coverage, vmeris_policies.feeind, sum(vmeris_policies.wp) AS wp, sum(vmeris_policies.ep) AS ep, sum(vmeris_policies.clep) AS clep, sum(vmeris_policies.ee) AS ee
   FROM fsbi_dw_uuico.vmeris_policies
  GROUP BY vmeris_policies.report_year, vmeris_policies.report_quarter, vmeris_policies.renewaltermcd, vmeris_policies.policyneworrenewal, vmeris_policies.policystate, vmeris_policies.companynumber, vmeris_policies.company, vmeris_policies.lob, vmeris_policies.asl, vmeris_policies.lob2, vmeris_policies.lob3, vmeris_policies.product, vmeris_policies.policyformcode, vmeris_policies.programind, vmeris_policies.producer_status, vmeris_policies.coveragetype, vmeris_policies.coverage, vmeris_policies.feeind;

COMMENT ON VIEW fsbi_dw_uuico.veris_premium IS 'ERIS Premiums aggregated level.';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.report_year IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.report_quarter IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.coveragetype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.coverage IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.wp IS 'Sum of Written Premium';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.ep IS 'Sum of Earned Premium';
COMMENT ON COLUMN fsbi_dw_uuico.veris_premium.clep IS 'Sum of Current Level Earned Premium: Earned premium adjusted using all rate changes starting after policy term effecyive date, based on company,  state, policyformcode,  new or renewal policy. ';

CREATE OR REPLACE VIEW fsbi_dw_uuico.vico_ca_auto_policies
AS SELECT "data".source_system, "data".policy_id, "data".spinn_policynumber, "data".uu_policynumber, "data".effectivedate, "data".expirationdate, "data".policynumbersuffix AS source_system_version, pg_catalog.row_number()
  OVER( 
  PARTITION BY "data".spinn_policynumber
  ORDER BY "data".spinn_policynumber, "data".effectivedate) AS version, "data".policy_uniqueid, "data".policy_status, "data".policyneworrenewal
   FROM ( SELECT p.source_system, p.policy_id, p.pol_policynumber AS spinn_policynumber, '' AS uu_policynumber, p.pol_effectivedate AS effectivedate, p.pol_expirationdate AS expirationdate, p.pol_policynumbersuffix AS policynumbersuffix, p.pol_uniqueid AS policy_uniqueid, pe.policy_spinn_status AS policy_status, 
                CASE
                    WHEN p.pol_policynumbersuffix::integer = 0 THEN 'Shell'::text
                    WHEN p.pol_policynumbersuffix::integer = 1 THEN 'New'::text
                    ELSE 'Renewal'::text
                END::character varying AS policyneworrenewal
           FROM fsbi_dw_spinn.dim_policy p
      JOIN fsbi_dw_spinn.dim_policyextension pe ON p.policy_id = pe.policy_id
   JOIN fsbi_dw_spinn.vdim_company c ON p.company_id = c.company_id
  WHERE p.pol_policynumber::text ~~ 'CAA%'::text AND c.comp_name1::text = 'CSEICO'::text
UNION ALL 
         SELECT p.source_system, p.policy_id, p.pol_spinnpolicynumber AS spinn_policynumber, p.pol_policynumber AS uu_policynumber, p.pol_effectivedate, p.pol_expirationdate, p.pol_policynumbersuffix, p.pol_uniqueid, p.pol_status AS policy_status, 
                CASE
                    WHEN p.pol_policynumbersuffix::integer = 0 THEN 'Shell'::text
                    WHEN p.pol_policynumbersuffix::integer = 1 THEN 'New'::text
                    ELSE 'Renewal'::text
                END::character varying AS policyneworrenewal
           FROM fsbi_dw_uuico.dim_policy p
          WHERE p.policy_id <> 0) "data"
  ORDER BY "data".spinn_policynumber, "data".effectivedate;

COMMENT ON VIEW fsbi_dw_uuico.vico_ca_auto_policies IS 'The view combines basic policy data from CSE SPINN and UU ICO and adds end-to-end versions';