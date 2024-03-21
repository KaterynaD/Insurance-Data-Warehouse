-- reporting.budgetforecast_20180308 definition

-- Drop table

-- DROP TABLE reporting.budgetforecast_20180308;

--DROP TABLE reporting.budgetforecast_20180308;
CREATE TABLE IF NOT EXISTS reporting.budgetforecast_20180308
(
	pln_month INTEGER   ENCODE az64
	,pln_monthabbr VARCHAR(7)   ENCODE lzo
	,pln_year INTEGER   ENCODE az64
	,pln_state VARCHAR(2)   ENCODE lzo
	,pln_company VARCHAR(10)   ENCODE lzo
	,pln_lob VARCHAR(50)   ENCODE lzo
	,pln_term VARCHAR(10)   ENCODE lzo
	,pln_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(20,2)   ENCODE az64
	,pln_year_issue NUMERIC(20,2)   ENCODE az64
	,loaddate DATE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.budgetforecast_20180308 owner to kdrogaieva;
COMMENT ON TABLE reporting.budgetforecast_20180308 IS 'Forecast data used in Result Committee dashboard in 2018. Not in use anymore.';


-- reporting.budgetforecast_20180605 definition

-- Drop table

-- DROP TABLE reporting.budgetforecast_20180605;

--DROP TABLE reporting.budgetforecast_20180605;
CREATE TABLE IF NOT EXISTS reporting.budgetforecast_20180605
(
	pln_month INTEGER   ENCODE az64
	,pln_monthabbr VARCHAR(7)   ENCODE lzo
	,pln_year INTEGER   ENCODE az64
	,pln_state VARCHAR(2)   ENCODE lzo
	,pln_company VARCHAR(10)   ENCODE lzo
	,pln_lob VARCHAR(50)   ENCODE lzo
	,pln_term VARCHAR(10)   ENCODE lzo
	,pln_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(20,2)   ENCODE az64
	,pln_year_issue NUMERIC(20,2)   ENCODE az64
	,loaddate DATE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.budgetforecast_20180605 owner to kdrogaieva;
COMMENT ON TABLE reporting.budgetforecast_20180605 IS 'Forecast data used in Result Committee dashboard in 2018. Not in use anymore.';


-- reporting.budgetforecast_20190214 definition

-- Drop table

-- DROP TABLE reporting.budgetforecast_20190214;

--DROP TABLE reporting.budgetforecast_20190214;
CREATE TABLE IF NOT EXISTS reporting.budgetforecast_20190214
(
	pln_month INTEGER   ENCODE az64
	,pln_monthabbr VARCHAR(7)   ENCODE lzo
	,pln_year INTEGER   ENCODE az64
	,pln_state VARCHAR(2)   ENCODE lzo
	,pln_company VARCHAR(20)   ENCODE lzo
	,pln_lob VARCHAR(50)   ENCODE lzo
	,pln_term VARCHAR(10)   ENCODE lzo
	,pln_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(20,2)   ENCODE az64
	,pln_year_issue NUMERIC(20,2)   ENCODE az64
	,loaddate DATE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.budgetforecast_20190214 owner to kdrogaieva;
COMMENT ON TABLE reporting.budgetforecast_20190214 IS 'UU Forecast data used in Result Committee dashboard in 2018-2019. Not in use anymore.';


-- reporting.budgetforecast_2020022024 definition

-- Drop table

-- DROP TABLE reporting.budgetforecast_2020022024;

--DROP TABLE reporting.budgetforecast_2020022024;
CREATE TABLE IF NOT EXISTS reporting.budgetforecast_2020022024
(
	pln_month INTEGER   ENCODE az64
	,pln_monthabbr VARCHAR(7)   ENCODE lzo
	,pln_year INTEGER   ENCODE az64
	,pln_state VARCHAR(2)   ENCODE lzo
	,pln_company VARCHAR(10)   ENCODE lzo
	,pln_lob VARCHAR(50)   ENCODE lzo
	,pln_term VARCHAR(10)   ENCODE lzo
	,pln_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(20,2)   ENCODE az64
	,pln_year_issue NUMERIC(20,2)   ENCODE az64
	,loaddate DATE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.budgetforecast_2020022024 owner to kdrogaieva;
COMMENT ON TABLE reporting.budgetforecast_2020022024 IS 'Forecast data used in Result Committee dashboard in 2020. Not in use anymore.';


-- reporting.budgetforecast_20210222 definition

-- Drop table

-- DROP TABLE reporting.budgetforecast_20210222;

--DROP TABLE reporting.budgetforecast_20210222;
CREATE TABLE IF NOT EXISTS reporting.budgetforecast_20210222
(
	pln_month INTEGER   ENCODE az64
	,pln_monthabbr VARCHAR(7)   ENCODE lzo
	,pln_year INTEGER   ENCODE az64
	,pln_state VARCHAR(2)   ENCODE lzo
	,pln_company VARCHAR(20)   ENCODE lzo
	,pln_lob VARCHAR(50)   ENCODE lzo
	,pln_term VARCHAR(10)   ENCODE lzo
	,pln_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(20,2)   ENCODE az64
	,pln_year_issue NUMERIC(20,2)   ENCODE az64
	,loaddate DATE   ENCODE az64
	,business_source VARCHAR(2)   ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.budgetforecast_20210222 owner to kdrogaieva;
COMMENT ON TABLE reporting.budgetforecast_20210222 IS 'Forecast data used in Result Committee dashboard in 2021 and 2022 years. Not in use anymore.';


-- reporting.budgetforecast_20230208 definition

-- Drop table

-- DROP TABLE reporting.budgetforecast_20230208;

--DROP TABLE reporting.budgetforecast_20230208;
CREATE TABLE IF NOT EXISTS reporting.budgetforecast_20230208
(
	pln_month INTEGER   ENCODE az64
	,pln_monthabbr VARCHAR(3)   ENCODE lzo
	,pln_year INTEGER   ENCODE az64
	,pln_state VARCHAR(3)   ENCODE lzo
	,pln_company VARCHAR(15)   ENCODE lzo
	,pln_lob VARCHAR(20)   ENCODE lzo
	,pln_term VARCHAR(10)   ENCODE lzo
	,pln_wp NUMERIC(21,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(21,2)   ENCODE az64
	,pln_new_pif NUMERIC(20,2)   ENCODE az64
	,pln_renewed_pif NUMERIC(20,2)   ENCODE az64
	,business_source VARCHAR(5)   ENCODE lzo
	,pln_year_issue INTEGER   ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.budgetforecast_20230208 owner to fsbi_admin;
COMMENT ON TABLE reporting.budgetforecast_20230208 IS 'Forecast data used in Result Committee dashboard based on data in 2022 F7x5 Forecast_2023 Budget - Finance Version.xlsx file from https://cseinsurance.sharepoint.com/:x:/r/_layouts/15/Doc.aspx?sourcedoc=%7BD3370665-BB4A-41FA-B1A3-C51885B0877D%7D&file=2022%20F7x5%20Forecast_2023%20Budget%20-%20Finance%20Version.xlsx&wdOrigin=OFFICECOM-WEB.MAIN.SEARCH&ct=1675890705215&action=default&mobileredirect=true';


-- reporting.portfolio_auto definition

-- Drop table

-- DROP TABLE reporting.portfolio_auto;

--DROP TABLE reporting.portfolio_auto;
CREATE TABLE IF NOT EXISTS reporting.portfolio_auto
(
	month_id INTEGER   ENCODE RAW
	,policy_id INTEGER   ENCODE az64
	,vehicle_id INTEGER   ENCODE az64
	,risk_cnt INTEGER   ENCODE az64
	,producer_id INTEGER   ENCODE az64
	,original_wp NUMERIC(38,2)   ENCODE az64
	,all_wp NUMERIC(38,2)   ENCODE az64
	,transaction_date DATE   ENCODE az64
	,accounting_date DATE   ENCODE az64
	,inforce_premium NUMERIC(38,2)   ENCODE az64
	,policystatus_id INTEGER   ENCODE az64
	,source VARCHAR(40)   ENCODE bytedict
	,bilimit VARCHAR(255)   ENCODE bytedict
	,pdlimit VARCHAR(255)   ENCODE bytedict
	,umbilimit VARCHAR(255)   ENCODE bytedict
	,medlimit VARCHAR(255)   ENCODE bytedict
	,vehiclecount INTEGER   ENCODE az64
	,drivercount INTEGER   ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,canceldt DATE   ENCODE az64
	,assigneddrivercount INTEGER  DEFAULT 0 ENCODE az64
	,gooddrivercount INTEGER  DEFAULT 0 ENCODE az64
	,goodassigneddrivercount INTEGER  DEFAULT 0 ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE reporting.portfolio_auto owner to kdrogaieva;
COMMENT ON TABLE reporting.portfolio_auto IS 'Portfolio Monitoring Auto base table. Populated in cse_bi.sp_portfolio_auto. Business Owner - Wendy Huang <whuang@cseinsurance.com>';

-- Column comments

COMMENT ON COLUMN reporting.portfolio_auto.drivercount IS 'Count of all Active  (driver status), not excluded (driver typecd) drivers  in a policy term. Not assigned drivers are joined based on a month_id(Transaction Accounting Date) 1st(startdate) day and dim_driver valid_fromdate and valid_todate (Transaction Effective date) which may be not 100% accurate but close.';
COMMENT ON COLUMN reporting.portfolio_auto.assigneddrivercount IS 'Count of Inforce assigned drivers.0 if policy term is not yet Inforce in a specific month.';
COMMENT ON COLUMN reporting.portfolio_auto.gooddrivercount IS 'Count of Yes or Super GoodDriverInd Active  (driver status), not excluded (driver typecd) drivers  in a policy term. Not assigned drivers are joined based on a month_id(Transaction Accounting Date) 1st(startdate) day and dim_driver valid_fromdate and valid_todate (Transaction Effective date) which may be not 100% accurate but close.';
COMMENT ON COLUMN reporting.portfolio_auto.goodassigneddrivercount IS 'Count of of Yes or Super GoodDriverInd in Inforce assigned drivers. 0 if policy term is not yet Inforce in a specific month.';


-- reporting.portfolio_property definition

-- Drop table

-- DROP TABLE reporting.portfolio_property;

--DROP TABLE reporting.portfolio_property;
CREATE TABLE IF NOT EXISTS reporting.portfolio_property
(
	month_id INTEGER   ENCODE RAW
	,policy_id INTEGER   ENCODE az64
	,building_id INTEGER   ENCODE az64
	,risk_cnt INTEGER   ENCODE az64
	,producer_id INTEGER   ENCODE az64
	,original_wp NUMERIC(38,2)   ENCODE az64
	,all_wp NUMERIC(38,2)   ENCODE az64
	,transaction_date DATE   ENCODE az64
	,accounting_date DATE   ENCODE az64
	,inforce_premium NUMERIC(38,3)   ENCODE az64
	,policystatus_id INTEGER   ENCODE az64
	,source VARCHAR(40)   ENCODE bytedict
	,backupofsewersanddrains NUMERIC(13,2)   ENCODE az64
	,bedbugcoverage NUMERIC(13,2)   ENCODE az64
	,buildingordinanceorlaw NUMERIC(13,2)   ENCODE az64
	,buildingadditionsandalterationsincreasedlimit NUMERIC(13,2)   ENCODE az64
	,courseofconstruction NUMERIC(13,2)   ENCODE az64
	,contentsopenperils VARCHAR(3)   ENCODE lzo
	,cova NUMERIC(13,2)   ENCODE az64
	,covb NUMERIC(13,2)   ENCODE az64
	,covc NUMERIC(13,2)   ENCODE az64
	,covd NUMERIC(13,2)   ENCODE az64
	,cove NUMERIC(13,2)   ENCODE az64
	,covf NUMERIC(13,2)   ENCODE az64
	,equipmentbreakdown VARCHAR(255)   ENCODE bytedict
	,employeediscount VARCHAR(3)   ENCODE lzo
	,expandedreplacementcost VARCHAR(255)   ENCODE lzo
	,extendedreplacementcostdwelling VARCHAR(15)   ENCODE bytedict
	,functionalreplacementcost VARCHAR(3)   ENCODE lzo
	,identityrecoverycoverage VARCHAR(15)   ENCODE bytedict
	,multipolicydiscount VARCHAR(3)   ENCODE lzo
	,landlordevictionexpensereimbursement NUMERIC(13,2)   ENCODE az64
	,lossassessment NUMERIC(13,2)   ENCODE az64
	,occupationdiscount VARCHAR(3)   ENCODE lzo
	,otherstructuresincreasedlimit NUMERIC(13,2)   ENCODE az64
	,personalpropertyincreasedlimit VARCHAR(15)   ENCODE lzo
	,personalinjuryliability VARCHAR(15)   ENCODE bytedict
	,personalpropertyreplacementcostoption VARCHAR(3)   ENCODE lzo
	,protectivedevices VARCHAR(3)   ENCODE lzo
	,propertymanagerdiscount VARCHAR(3)   ENCODE lzo
	,rentersinsuranceverificationdiscount VARCHAR(3)   ENCODE lzo
	,serviceline NUMERIC(13,2)   ENCODE az64
	,seniordiscount VARCHAR(3)   ENCODE lzo
	,structuresrentedtoothersresidencepremises VARCHAR(15)   ENCODE lzo
	,scheduledpersonalproperty VARCHAR(3)   ENCODE bytedict
	,theft NUMERIC(13,2)   ENCODE az64
	,workerscompensation VARCHAR(3)   ENCODE lzo
	,workerscompensationoccasionalemployee VARCHAR(3)   ENCODE bytedict
	,spp_class_code VARCHAR(256)   ENCODE lzo
	,incb_class_code VARCHAR(256)   ENCODE bytedict
	,loaddate DATE   ENCODE az64
	,canceldt DATE   ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE reporting.portfolio_property owner to kdrogaieva;
COMMENT ON TABLE reporting.portfolio_property IS 'Portfolio Monitoring Property(building) base table. Populated in cse_bi.sp_portfolio_property. Business Owner - Wendy Huang <whuang@cseinsurance.com>';


-- reporting.ppd_claim_summaries definition

-- Drop table

-- DROP TABLE reporting.ppd_claim_summaries;

--DROP TABLE reporting.ppd_claim_summaries;
CREATE TABLE IF NOT EXISTS reporting.ppd_claim_summaries
(
	month_id INTEGER   ENCODE az64
	,claim_number VARCHAR(50)   ENCODE lzo
	,claimant VARCHAR(50)   ENCODE lzo
	,policy_state VARCHAR(75)   ENCODE lzo
	,carrier VARCHAR(100)   ENCODE lzo
	,company VARCHAR(50)   ENCODE lzo
	,policyneworrenewal VARCHAR(7)   ENCODE lzo
	,cat_flg VARCHAR(3)   ENCODE lzo
	,perilgroup VARCHAR(9)   ENCODE lzo
	,loss_cause VARCHAR(255)   ENCODE bytedict
	,product VARCHAR(100)   ENCODE lzo
	,rag VARCHAR(5)   ENCODE lzo
	,feature_type VARCHAR(100)   ENCODE lzo
	,feature_map VARCHAR(20)   ENCODE bytedict
	,total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,loss_incurred NUMERIC(38,2)   ENCODE az64
	,alae_incurred NUMERIC(38,2)   ENCODE az64
	,alae_paid NUMERIC(38,2)   ENCODE az64
	,salsub_incurred NUMERIC(38,2)   ENCODE az64
	,salsub_received NUMERIC(38,2)   ENCODE az64
	,total_reserve NUMERIC(38,2)   ENCODE az64
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 DISTKEY (month_id)
;
ALTER TABLE reporting.ppd_claim_summaries owner to kdrogaieva;
COMMENT ON TABLE reporting.ppd_claim_summaries IS 'Product performance Dashboard Claims base Monthly summaries. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';


-- reporting.ppd_claims definition

-- Drop table

-- DROP TABLE reporting.ppd_claims;

--DROP TABLE reporting.ppd_claims;
CREATE TABLE IF NOT EXISTS reporting.ppd_claims
(
	month_id INTEGER   ENCODE RAW
	,policy_state VARCHAR(75)   ENCODE bytedict
	,carrier VARCHAR(100)   ENCODE bytedict
	,company VARCHAR(50)   ENCODE bytedict
	,policyneworrenewal VARCHAR(7)   ENCODE bytedict
	,product VARCHAR(100)   ENCODE bytedict
	,cat_flg VARCHAR(3)   ENCODE lzo
	,perilgroup VARCHAR(9)   ENCODE bytedict
	,claim_number VARCHAR(50)   ENCODE lzo
	,claimant VARCHAR(50)   ENCODE bytedict
	,rag VARCHAR(5)   ENCODE bytedict
	,feature_type VARCHAR(100)   ENCODE bytedict
	,feature_map VARCHAR(20)   ENCODE bytedict
	,clm_total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,clm_cumulative_total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,clm_loss_incurred NUMERIC(38,2)   ENCODE az64
	,clm_cumulative_loss_incurred NUMERIC(38,2)   ENCODE az64
	,clm_alae_incurred NUMERIC(38,2)   ENCODE az64
	,clm_cumulative_alae_incurred NUMERIC(38,2)   ENCODE az64
	,clm_salsub_received NUMERIC(38,2)   ENCODE az64
	,clm_cumulative_salsub_received NUMERIC(38,2)   ENCODE az64
	,feat_total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,feat_cumulative_total_incurred_loss NUMERIC(38,2)   ENCODE az64
	,feat_total_reserve NUMERIC(38,2)   ENCODE az64
	,feat_cumulative_total_reserve NUMERIC(38,2)   ENCODE az64
	,feat_reported_count INTEGER   ENCODE az64
	,feat_closed_count INTEGER   ENCODE az64
	,feat_open_count INTEGER   ENCODE az64
	,feat_reported_count_100k INTEGER   ENCODE az64
	,feat_loss_incurred NUMERIC(38,2)   ENCODE az64
	,feat_cumulative_loss_incurred NUMERIC(38,2)   ENCODE az64
	,feat_alae_incurred NUMERIC(38,2)   ENCODE az64
	,feat_cumulative_alae_incurred NUMERIC(38,2)   ENCODE az64
	,feat_salsub_received NUMERIC(38,2)   ENCODE az64
	,feat_cumulative_salsub_received NUMERIC(38,2)   ENCODE az64
	,clm_capped_cumulative_total_incurred_100k NUMERIC(38,2)   ENCODE az64
	,ratio DOUBLE PRECISION   ENCODE RAW
	,feat_capped_cumulative_total_incurred_100k DOUBLE PRECISION   ENCODE RAW
	,feat_capped_cumulative_loss_incurred_100k DOUBLE PRECISION   ENCODE RAW
	,feat_capped_cumulative_alae_incurred_100k DOUBLE PRECISION   ENCODE RAW
	,feat_capped_cumulative_salsub_received_100k DOUBLE PRECISION   ENCODE RAW
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 DISTKEY (month_id)
 SORTKEY (
	month_id
	, claim_number
	, claimant
	, feature_type
	, feature_map
	)
;
ALTER TABLE reporting.ppd_claims owner to kdrogaieva;
COMMENT ON TABLE reporting.ppd_claims IS 'Product performance Dashboard Claims calculations. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';


-- reporting.ppd_losses definition

-- Drop table

-- DROP TABLE reporting.ppd_losses;

--DROP TABLE reporting.ppd_losses;
CREATE TABLE IF NOT EXISTS reporting.ppd_losses
(
	product VARCHAR(12)   ENCODE lzo
	,subproduct VARCHAR(7)   ENCODE lzo
	,month_id INTEGER   ENCODE az64
	,policy_state VARCHAR(75)   ENCODE lzo
	,carrier VARCHAR(100)   ENCODE lzo
	,company VARCHAR(50)   ENCODE lzo
	,policyneworrenewal VARCHAR(7)   ENCODE lzo
	,cat_flg VARCHAR(3)   ENCODE lzo
	,perilgroup VARCHAR(9)   ENCODE lzo
	,total_incurred NUMERIC(38,2)   ENCODE az64
	,total_incurred_100k_month NUMERIC(38,2)   ENCODE az64
	,total_incurred_capped_100k DOUBLE PRECISION   ENCODE RAW
	,reported_count_month BIGINT   ENCODE az64
	,reported_count BIGINT   ENCODE az64
	,open_count BIGINT   ENCODE az64
	,reported_count_100k BIGINT   ENCODE az64
	,reported_count_100k_month BIGINT   ENCODE az64
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 DISTKEY (month_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE reporting.ppd_losses owner to kdrogaieva;
COMMENT ON TABLE reporting.ppd_losses IS 'Product performance Dashboard monthly losses data. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';


-- reporting.ppd_policies_summaries definition

-- Drop table

-- DROP TABLE reporting.ppd_policies_summaries;

--DROP TABLE reporting.ppd_policies_summaries;
CREATE TABLE IF NOT EXISTS reporting.ppd_policies_summaries
(
	product VARCHAR(12)   ENCODE lzo
	,subproduct VARCHAR(7)   ENCODE lzo
	,month_id INTEGER   ENCODE az64
	,policy_state VARCHAR(50)   ENCODE lzo
	,carrier VARCHAR(100)   ENCODE lzo
	,company VARCHAR(50)   ENCODE lzo
	,policyneworrenewal VARCHAR(10)   ENCODE lzo
	,ep NUMERIC(38,2)   ENCODE az64
	,ee NUMERIC(38,3)   ENCODE az64
	,pif BIGINT   ENCODE az64
	,loaddate DATE NOT NULL  ENCODE runlength
)
DISTSTYLE AUTO
 SORTKEY (
	month_id
	)
;
ALTER TABLE reporting.ppd_policies_summaries owner to kdrogaieva;
COMMENT ON TABLE reporting.ppd_policies_summaries IS 'Product performance Dashboard monthly earned premiums, exposures and PIF. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';


-- reporting.vm_execprodmonitor_main definition

-- Drop table

-- DROP TABLE reporting.vm_execprodmonitor_main;

--DROP TABLE reporting.vm_execprodmonitor_main;
CREATE TABLE IF NOT EXISTS reporting.vm_execprodmonitor_main
(
	sourcesystem VARCHAR(5)   ENCODE lzo
	,mon_startdate DATE   ENCODE az64
	,mon_monthinyear INTEGER   ENCODE az64
	,mon_monthabbr VARCHAR(4)   ENCODE lzo
	,mon_year INTEGER   ENCODE az64
	,reportperiod VARCHAR(23)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,company VARCHAR(151)   ENCODE lzo
	,term VARCHAR(255)   ENCODE lzo
	,lob VARCHAR(20)   ENCODE lzo
	,mtd_writprem NUMERIC(37,0)   ENCODE az64
	,ytd_writprem_origin NUMERIC(37,0)   ENCODE az64
	,new_mtd_writprem NUMERIC(37,0)   ENCODE az64
	,new_ytd_writprem NUMERIC(37,0)   ENCODE az64
	,for_avg_mtd_writprem NUMERIC(37,0)   ENCODE az64
	,for_avg_ytd_writprem NUMERIC(37,0)   ENCODE az64
	,for_avg_new_mtd_writprem NUMERIC(37,0)   ENCODE az64
	,for_avg_new_ytd_writprem NUMERIC(37,0)   ENCODE az64
	,total_polcnt BIGINT   ENCODE az64
	,new_polcnt BIGINT   ENCODE az64
	,pif BIGINT   ENCODE az64
	,pif_ye_prev BIGINT   ENCODE az64
	,ytd_writprem NUMERIC(37,0)   ENCODE az64
	,ytd_total_polcnt BIGINT   ENCODE az64
	,ytd_new_polcnt BIGINT   ENCODE az64
	,offset_for_retention BIGINT   ENCODE az64
	,pln_wp NUMERIC(21,2)   ENCODE az64
	,pln_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_pif NUMERIC(21,2)   ENCODE az64
	,pln_ytd_wp NUMERIC(21,2)   ENCODE az64
	,pln_ytd_new_wp NUMERIC(20,2)   ENCODE az64
	,pln_ytd_renewed_wp NUMERIC(20,2)   ENCODE az64
	,pln_ytd_new_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_ytd_renewed_polcnt NUMERIC(20,2)   ENCODE az64
	,pln_year_issue INTEGER   ENCODE az64
	,pln_type VARCHAR(15)   ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE reporting.vm_execprodmonitor_main owner to kdrogaieva;
COMMENT ON TABLE reporting.vm_execprodmonitor_main IS 'Materialized view of reporting.vexecprodmonitor_main (true materialized view is impossible to create due to complex structure based on other views) - Results Commitee Dashboards. Business Owner: Wendy Huang';


-- reporting.vmeris_claims definition

-- Drop table

-- DROP TABLE reporting.vmeris_claims;

--DROP TABLE reporting.vmeris_claims;
CREATE TABLE IF NOT EXISTS reporting.vmeris_claims
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
	,claim_number VARCHAR(50)   ENCODE zstd
	,claimant VARCHAR(50)   ENCODE bytedict
	,cat_indicator VARCHAR(3)   ENCODE lzo
	,lob VARCHAR(3)   ENCODE lzo
	,lob2 VARCHAR(3)   ENCODE lzo
	,lob3 VARCHAR(3)   ENCODE lzo
	,product VARCHAR(2)   ENCODE lzo
	,policyformcode VARCHAR(20)   ENCODE lzo
	,programind VARCHAR(6)   ENCODE lzo
	,featuretype VARCHAR(4)   ENCODE lzo
	,feature VARCHAR(5)   ENCODE bytedict
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
	,altsubtypecd VARCHAR(20)   ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (claim_number)
 SORTKEY (
	devq
	, claim_number
	, claimant
	, feature
	)
;
ALTER TABLE reporting.vmeris_claims owner to kdrogaieva;
COMMENT ON TABLE reporting.vmeris_claims IS 'ERIS Losses detail level. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';

-- Column comments

COMMENT ON COLUMN reporting.vmeris_claims.devq IS 'DevQ is based on claims loss dates quarters. DevQ is NOT a quarter number. It''s number of months in quarter. (3*number of development quarters). evQ is always less then or equal 120. It''s forcefully set to 120 for higher numbers.';
COMMENT ON COLUMN reporting.vmeris_claims.reported_year IS 'Year based on claim transaction date';
COMMENT ON COLUMN reporting.vmeris_claims.reported_qtr IS 'Quarter based on claim transaction date';
COMMENT ON COLUMN reporting.vmeris_claims.policyneworrenewal IS 'All WINs claims are related to "New" policyneworrenewal due to a complex way getting proper data';
COMMENT ON COLUMN reporting.vmeris_claims.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.featuretype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.feature IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_claims.claim_status IS 'Closed when Reserve=0 or Open';
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid_expense IS 'ITD (Inception To date): aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid_dcc_expense IS 'ITD (Inception To date): dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid_loss IS 'ITD (Inception To date):loss_paid';
COMMENT ON COLUMN reporting.vmeris_claims.itd_incurred IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.itd_incurred_net_salvage_subrogation IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN reporting.vmeris_claims.itd_total_incurred_loss IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN reporting.vmeris_claims.itd_reserve IS 'ITD (Inception To date):loss_reserve + aoo_reserve + dcc_reserve';
COMMENT ON COLUMN reporting.vmeris_claims.itd_loss_and_alae_for_paid_count IS 'ITD (Inception To date): loss_paid + aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.itd_salvage_and_subrogation IS 'ITD (Inception To date: salvage_received + subro_received';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_dcc_expense IS 'QTD (Reported_Year, Reported_Qtr To date): dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_expense IS 'QTD (Reported_Year, Reported_Qtr To date): aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_expense IS 'QTD (Reported_Year, Reported_Qtr To date): aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_dcc_expense IS 'QTD (Reported_Year, Reported_Qtr To date): dcc_paid + dcc_reserve';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_salvage_and_subrogation IS 'QTD (Reported_Year, Reported_Qtr To date): salvage_received + subro_received';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_loss IS 'QTD (Reported_Year, Reported_Qtr To date): loss_paid';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_loss IS 'QTD (Reported_Year, Reported_Qtr To date): loss_paid + loss_reserve';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_total_incurred_loss IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_25k IS 'QTD (Reported_Year, Reported_Qtr To date): least(25k, itd_paid) - prev quarter least(25k, itd_paid) ';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_50k IS 'QTD (Reported_Year, Reported_Qtr To date):least(50k, itd_paid) - prev quarter least(50k, itd_paid) ';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_100k IS 'QTD (Reported_Year, Reported_Qtr To date): least(100k, itd_paid) - prev quarter least(100k, itd_paid) ';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_250k IS 'QTD (Reported_Year, Reported_Qtr To date): least(250k, itd_paid) - prev quarter least(250k, itd_paid) ';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_500k IS 'QTD (Reported_Year, Reported_Qtr To date): least(500k, itd_paid) - prev quarter least(500k, itd_paid) ';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_1m IS 'QTD (Reported_Year, Reported_Qtr To date): least(1m, itd_paid) - prev quarter least(1m,itd_paid) ';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_25k IS 'QTD (Reported_Year, Reported_Qtr To date): least(25k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(25k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_50k IS 'QTD (Reported_Year, Reported_Qtr To date): least(50k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(50k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_100k IS 'QTD (Reported_Year, Reported_Qtr To date): least(100k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(100k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_250k IS 'QTD (Reported_Year, Reported_Qtr To date): least(250k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(250k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_500k IS 'QTD (Reported_Year, Reported_Qtr To date): least(500k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(500k,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_1m IS 'QTD (Reported_Year, Reported_Qtr To date): least(1m,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(1m,ITD_Incurred_net_Salvage_Subrogation)';
COMMENT ON COLUMN reporting.vmeris_claims.x_itd_incurred_net_salvage_subrogation_250k IS 'case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 250000) else 0 end';
COMMENT ON COLUMN reporting.vmeris_claims.x_itd_incurred_net_salvage_subrogation_500k IS 'case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 500000) else 0 end';
COMMENT ON COLUMN reporting.vmeris_claims.reported_count IS '1 or 0 Reported Count is based on transactional level.  The script is looking for the first transaction date(*) and quarter when this condition is TRUE in a transaction (no aggragation in metric values): loss_paid>=0.5 or loss_reserve>=0.5 or f.aoo_paid>=0.5 or aoo_reserve>=0.5 or dcc_paid>=0.5 or dcc_reserve>=0.5 or salvage_received>=0.5 or subro_received>=0.5';
COMMENT ON COLUMN reporting.vmeris_claims.closed_count IS '1 or 0 Closed Count is based on transactional level. The script is looking for the latest transaction date and quarter (from transactional date) when this condition is TRUE:sum(loss_reserve + aoo_reserve + dcc_reserve)<0.5 (The data are aggregated at the claim-claimant-ERIS feature level (see Configuration) and transaction date)';
COMMENT ON COLUMN reporting.vmeris_claims.closed_nopay IS 'The same as closed count but in the same quorter this condition should be TRUE ITD_Paid_Loss + ITD_Paid_Expense<=0 to have 1 in the metric';
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_loss IS 'ITD_Paid_Loss If closed_count 1 else 0';
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_expense IS 'ITD_Paid_Expense If closed_count 1 else 0';
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_dcc_expense IS 'ITD_Paid_DCC_Expense If closed_count 1 else 0';
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_salvage_subrogation IS 'ITD_Salvage_and_subrogation If closed_count 1 else 0';
COMMENT ON COLUMN reporting.vmeris_claims.paid_count IS '1 in DevQ when ITD_Loss_and_ALAE_for_Paid_count>0';
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid IS 'ITD (Inception To date): itd_paid_loss+ itd_paid_expense- itd_salvage_and_subrogation';
COMMENT ON COLUMN reporting.vmeris_claims.altsubtypecd IS 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';


-- reporting.vmeris_policies definition

-- Drop table

-- DROP TABLE reporting.vmeris_policies;

--DROP TABLE reporting.vmeris_policies;
CREATE TABLE IF NOT EXISTS reporting.vmeris_policies
(
	report_year INTEGER   ENCODE az64
	,report_quarter INTEGER   ENCODE az64
	,policynumber VARCHAR(50)   ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,riskcd VARCHAR(12)   ENCODE bytedict
	,policyversion VARCHAR(10)   ENCODE bytedict
	,effectivedate DATE   ENCODE az64
	,expirationdate DATE   ENCODE az64
	,renewaltermcd VARCHAR(255)   ENCODE bytedict
	,policyneworrenewal VARCHAR(10)   ENCODE lzo
	,policystate VARCHAR(50)   ENCODE bytedict
	,companynumber VARCHAR(50)   ENCODE bytedict
	,company VARCHAR(100)   ENCODE bytedict
	,lob VARCHAR(3)   ENCODE bytedict
	,asl VARCHAR(5)   ENCODE bytedict
	,lob2 VARCHAR(3)   ENCODE bytedict
	,lob3 VARCHAR(3)   ENCODE bytedict
	,product VARCHAR(2)   ENCODE lzo
	,policyformcode VARCHAR(255)   ENCODE bytedict
	,programind VARCHAR(6)   ENCODE bytedict
	,producer_status VARCHAR(10)   ENCODE bytedict
	,coveragetype VARCHAR(4)   ENCODE bytedict
	,coverage VARCHAR(5)   ENCODE bytedict
	,feeind VARCHAR(1)   ENCODE lzo
	,source VARCHAR(5)   ENCODE lzo
	,wp NUMERIC(38,2)   ENCODE az64
	,ep NUMERIC(38,2)   ENCODE az64
	,clep DOUBLE PRECISION   ENCODE RAW
	,ee NUMERIC(38,3)   ENCODE az64
	,loaddate DATE NOT NULL  ENCODE runlength
	,altsubtypecd VARCHAR(20)   ENCODE bytedict
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	report_year
	, report_quarter
	)
;
ALTER TABLE reporting.vmeris_policies owner to kdrogaieva;
COMMENT ON TABLE reporting.vmeris_policies IS 'ERIS Premiums detail level. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';

-- Column comments

COMMENT ON COLUMN reporting.vmeris_policies.report_year IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN reporting.vmeris_policies.report_quarter IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN reporting.vmeris_policies.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.coveragetype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.coverage IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.vmeris_policies.wp IS 'Written Premium';
COMMENT ON COLUMN reporting.vmeris_policies.ep IS 'Earned Premium';
COMMENT ON COLUMN reporting.vmeris_policies.clep IS 'Current Level Earned Premium: Earned premium adjusted using all rate changes starting after policy term effecyive date, based on company,  state, policyformcode,  new or renewal policy. ';
COMMENT ON COLUMN reporting.vmeris_policies.altsubtypecd IS 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';


-- reporting.external_partitions source

CREATE OR REPLACE VIEW reporting.external_partitions
AS SELECT svv_external_partitions.schemaname, svv_external_partitions.tablename, svv_external_partitions."values", svv_external_partitions."location", svv_external_partitions.input_format, svv_external_partitions.output_format, svv_external_partitions.serialization_lib, svv_external_partitions.serde_parameters, svv_external_partitions.compressed, svv_external_partitions."parameters"
   FROM svv_external_partitions;


-- reporting.newbusinessproductiondocumentdeliverymethodpolicylevel source

CREATE OR REPLACE VIEW reporting.newbusinessproductiondocumentdeliverymethodpolicylevel
AS SELECT DISTINCT r.policy_id, p.policyref, p.policynumber, p.state, p.lob, p.product, p.territory, p.agencygroup, p.company, r.paperlessdeliveryind AS policylevelpaperlessenrollment, r.lastenrollmentmethod AS paperlessenrollmentmethod, nb.dt AS newbusdt
   FROM fsbi_dw_spinn.fact_customer_rel r
   JOIN ( SELECT DISTINCT p.policy_id, p.pol_uniqueid AS policyref, p.pol_policynumber AS policynumber, p.pol_masterstate AS state, pr.prdt_lob AS lob, pr.prdt_name AS product, COALESCE(prod.territory, 'Unknown'::character varying) AS territory, COALESCE(prod.agency_group, 'Unknown'::character varying) AS agencygroup, comp.comp_name1 AS company
           FROM fsbi_dw_spinn.fact_policytransaction f
      JOIN fsbi_dw_spinn.dim_policy p ON f.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.dim_product pr ON f.product_id = pr.product_id
   JOIN fsbi_dw_spinn.vdim_producer prod ON f.producer_id = prod.producer_id
   JOIN fsbi_dw_spinn.vdim_company comp ON f.company_id = comp.company_id) p ON r.policy_id = p.policy_id
   JOIN ( SELECT t.poleff_date AS dt, f.policy_id
      FROM fsbi_dw_spinn.fact_policytransaction f
   JOIN fsbi_dw_spinn.dim_policy p ON f.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.vdim_policyeffectivedate t ON f.policyeffectivedate_id = t.policyeffectivedate_id
   JOIN fsbi_dw_spinn.vdim_accountingdate ad ON f.accountingdate_id = ad.accountingdate_id AND t.poleff_reportperiod::text = ad.acct_reportperiod::text
  WHERE f.policyneworrenewal::text = 'New'::text) nb ON r.policy_id = nb.policy_id
  WHERE nb.dt > '2018-08-01'::date;

COMMENT ON VIEW reporting.newbusinessproductiondocumentdeliverymethodpolicylevel IS 'Customer Dashboards. Business Owner: Cahit Ogut <cogut@cseinsurance.com>';


-- reporting.newpaperlessenrollment source

CREATE OR REPLACE VIEW reporting.newpaperlessenrollment
AS SELECT DISTINCT p.policy_id, p.policyref, p.policynumber, p.state, p.lob, p.product, p.territory, p.agencygroup, p.company, r.paperlessdeliveryind AS paperlessdeliveryenrolled, 
        CASE
            WHEN r.lastenrollmentdt_id < 20180813 THEN 'Portal'::character varying
            ELSE r.lastenrollmentmethod
        END AS paperlessenrollmentmethod, to_date(r.lastenrollmentdt_id::character varying::text, 'yyyymmdd'::text) AS lastenrollmentdt
   FROM fsbi_dw_spinn.fact_customer_rel r
   JOIN ( SELECT DISTINCT p.policy_id, p.pol_uniqueid AS policyref, p.pol_policynumber AS policynumber, p.pol_masterstate AS state, pr.prdt_lob AS lob, pr.prdt_name AS product, COALESCE(prod.territory, 'Unknown'::character varying) AS territory, COALESCE(prod.agency_group, 'Unknown'::character varying) AS agencygroup, comp.comp_name1 AS company
           FROM fsbi_dw_spinn.fact_policytransaction f
      JOIN fsbi_dw_spinn.dim_policy p ON f.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.dim_product pr ON f.product_id = pr.product_id
   JOIN fsbi_dw_spinn.vdim_producer prod ON f.producer_id = prod.producer_id
   JOIN fsbi_dw_spinn.vdim_company comp ON f.company_id = comp.company_id) p ON r.policy_id = p.policy_id
  WHERE r.lastenrollmentdt_id > 0 AND r.paperlessdeliveryind::text = 'Yes'::text;

COMMENT ON VIEW reporting.newpaperlessenrollment IS 'Customer Dashboards. Business Owner: Cahit Ogut <cogut@cseinsurance.com>';


-- reporting.newportalregistrations source

CREATE OR REPLACE VIEW reporting.newportalregistrations
AS SELECT DISTINCT c.customer_uniqueid AS customernumber, c.name AS customername, pu.registrationdt AS registrationdate, pu.portaluser_uniqueid AS portalsystemid, c.email AS customeremailaddr
   FROM fsbi_dw_spinn.fact_customer_rel r
   JOIN fsbi_dw_spinn.dim_customer c ON r.customer_id = c.customer_id
   JOIN fsbi_dw_spinn.dim_portaluser pu ON r.portaluser_id = pu.portaluser_id AND pu.status::text = 'Active'::character varying::text;

COMMENT ON VIEW reporting.newportalregistrations IS 'Customer Dashboards. Business Owner: Cahit Ogut <cogut@cseinsurance.com>';


-- reporting.policylevelpaperlessenrolment source

CREATE OR REPLACE VIEW reporting.policylevelpaperlessenrolment
AS SELECT DISTINCT p.policy_id, p.policyref, p.policynumber, to_date(p.month_id::character varying::text + '01'::text, 'yyyymmdd'::text) AS monthfirstdate, p.state, p.company, p.lob, p.product, p.territory, p.agencygroup, c.customer_uniqueid AS customernumber, c.name AS customername, c.email, r.paperlessdeliveryind, r.lastenrollmentmethod AS paperlessdeliverymethod, 
        CASE
            WHEN ((pg_catalog.listagg(DISTINCT 
            CASE
                WHEN pu.status::text = 'Deleted'::text THEN 'N/A'::text
                WHEN to_char(pu.registrationdt::timestamp without time zone, 'yyyymm'::text)::integer <= p.month_id AND to_char(pu.registrationdt::timestamp without time zone, 'yyyymm'::text)::integer <> 190001 AND pu.status::text = 'Active'::text THEN 'Yes'::text
                ELSE 'No'::text
            END, ','::text) WITHIN GROUP(
      ORDER BY p.policynumber)
      OVER( 
      PARTITION BY p.month_id, p.policynumber))::text) ~~ '%Yes%'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS portaluser
   FROM ( SELECT p.policy_id, p.pol_uniqueid AS policyref, p.pol_policynumber AS policynumber, f.month_id, 
                CASE
                    WHEN s.polst_statuscd::text = 'INF'::text AND sum(f.term_prem_amt_itd) > 0::numeric THEN 'Yes'::text
                    ELSE 'No'::text
                END AS inforcedflg, p.pol_masterstate AS state, pr.prdt_lob AS lob, pr.prdt_name AS product, COALESCE(prod.territory, 'Unknown'::character varying) AS territory, COALESCE(prod.agency_group, 'Unknown'::character varying) AS agencygroup, comp.comp_name1 AS company
           FROM fsbi_dw_spinn.fact_policy f
      JOIN fsbi_dw_spinn.vdim_policystatus s ON f.policystatus_id = s.policystatus_id
   JOIN fsbi_dw_spinn.dim_policy p ON f.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.dim_product pr ON f.product_id = pr.product_id
   JOIN fsbi_dw_spinn.vdim_producer prod ON f.producer_id = prod.producer_id
   JOIN fsbi_dw_spinn.vdim_company comp ON f.company_id = comp.company_id
  WHERE f.month_id = to_char('now'::text::date::timestamp without time zone, 'yyyymm'::text)::integer
  GROUP BY p.policy_id, p.pol_uniqueid, p.pol_policynumber, f.month_id, s.polst_statuscd, p.pol_masterstate, pr.prdt_lob, pr.prdt_name, COALESCE(prod.territory, 'Unknown'::character varying), COALESCE(prod.agency_group, 'Unknown'::character varying), comp.comp_name1) p
   JOIN fsbi_dw_spinn.fact_customer_rel r ON r.policy_id = p.policy_id AND p.inforcedflg = 'Yes'::text
   JOIN fsbi_dw_spinn.dim_customer c ON c.customer_id = r.customer_id
   JOIN fsbi_dw_spinn.dim_portaluser pu ON pu.portaluser_id = r.portaluser_id;

COMMENT ON VIEW reporting.policylevelpaperlessenrolment IS 'Customer Dashboards. Business Owner: Cahit Ogut <cogut@cseinsurance.com>';


-- reporting.product_mappings source

CREATE OR REPLACE VIEW reporting.product_mappings
AS -- reporting.product_mappings source

create or replace view reporting.product_mappings as
select
	fsrc.fin_source_id,carr.fin_company_id,floc.fin_location_id,fprdt.fin_product_id,carr.carrier_id,businesssource,businesssource as fsrc_code,dac,carr_code,carr_abbr,prdt_state,prdt_state as state,prdt_lob_code,fprdtc.prdt_code,prdt_selectorpreferred,prdt_isselect,fprdt.fprdt_name,elr
from reporting.elr_lookup
left join fsbi_dw_spinn.dim_fin_product_code fprdtc using (prdt_lob_code,prdt_isselect)
left join fsbi_dw_spinn.dim_fin_product fprdt using (fin_product_id,prdt_lob_code)
left join fsbi_dw_spinn.dim_fin_location floc on prdt_state = floc.state and floc.valid_todate = '2999-12-31'
left join fsbi_dw_spinn.dim_carrier carr using (carr_code)
left join fsbi_dw_spinn.dim_fin_source fsrc on 
	case
		when dac = 'D' then businesssource = fsrc.fsrc_code
		when dac = 'A' then 
		case
			when elr = 'UU.SFG.AU.AZ.All' then fsrc.fsrc_code = 'UU-UIC-AZ'
			when elr = 'UU.SFG.AU.UT.All' then fsrc.fsrc_code in ('UU-EZAUTO','UU-UIC-UT')
		end
	end
where
	fprdt.valid_todate = '2999-12-31'
and	split_part(elr_lookup.elr,'.',3) = prdt_elr_group
and not (businesssource = 'IA' and (dac = 'A' or fprdtc.prdt_code like '%-UU-%' or fprdtc.prdt_code = 'CAP'))
and not (businesssource = 'UU' and prdt_state not in ('AZ','UT'))
with no schema binding
;


-- reporting.vcashstlmnt_checks_accountstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checks_accountstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_Checks_AccountStats as 
select acs.*,
bai_code Bank_Code,
bai_description Bank_Code_Description,
case when bai.datefield is not null then 'Cleared' end Bank_Settlement_Status,
bai.datefield Bank_Settlement_DT,
bai.account Clearing_Account
from aurora_prodcse.AccountStats acs
left outer join thirdparty.bai_detail bai
on acs.CheckNumber = bai.cust_ref
where acs.BookDt>'2016-01-01'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_checks_accountstats IS 'Cash Settlment. prodcse.AccountStats (Aurora) and thirdparty.bai_detail joined via AccountStats.CheckNumber = bai_detail.cust_ref Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_checks_claimanttransaction source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checks_claimanttransaction
AS create view reporting.vcashstlmnt_Checks_ClaimantTransaction as 	
select  
ctt.*,	
bai_code Bank_Code,	
bai_description Bank_Code_Description,	
case when bai.datefield is not null then 'Cleared' end Bank_Settlement_Status,	
bai.datefield Bank_Settlement_DT,	
bai.account Clearing_Account
from 
aurora_prodcse_dw.claimanttransaction ctt
left outer join thirdparty.bai_detail bai	
on ltrim(ctt.RecoveryCheckNumber,0)=bai.cust_ref 	
where ctt.BookDt>'2016-01-01'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_checks_claimanttransaction IS 'Cash Settlment. prodcse.ClaimantTransaction (Aurora) and thirdparty.bai_detail joined via cast(ClaimantTransaction.RecoveryCheckNumber AS int)=bai_detail.cust_ref Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_checks_claimanttransaction_v2 source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checks_claimanttransaction_v2
AS SELECT ctt._fivetran_id, ctt.recoverycheckdt, ctt.paymentstatusdt, ctt.paidamt, ctt.systemid, ctt.statuscd, ctt.expectedrecoveryamt, ctt.id, ctt.memo, ctt.sequencenumber, ctt.claimanttransactionref, ctt.printertemplateidref, ctt.paymentstatus, ctt.paytoclaimantind, ctt.paytointerestind, ctt.voidallowedind, ctt.transactionuser, ctt.automatedpaymentind, ctt.paymenttypecd, ctt.reserveamt, ctt.transactioncd, ctt.paytoname, ctt.transactiontm, ctt.subrogationidref, ctt.providerref, ctt.recoverychecknumber, ctt.paytooverrideind, ctt."comment", ctt.classificationcd, ctt.parentid, ctt.claimtransactionhistoryref, ctt.transactionnumber, ctt.bookdt, ctt.paymentaccountcd, ctt.recoverycheckamt, ctt.paymentmethodcd, ctt.paymentreference, ctt.paytoproviderind, ctt.interestcd, ctt.memocd, ctt.transactiondt, ctt.recoverypaidby, ctt.cmmcontainer, ctt.recoveryamt, ctt.interestidref, ctt._fivetran_index, ctt._fivetran_deleted, ctt._fivetran_synced, cs.bank_code, cs.bank_code_description, cs.bank_settlement_status, cs.bank_settlement_dt, cs.clearing_account
   FROM ( SELECT cs.systemid, cs.claimnumber, cs.featurestatuschgind, cs.lossdt, cs.featuretypecd, cs.propertydamagedidref, cs.losscausecd, cs.catastrophenumber, cs.sublinecd, cs.reportdt, cs.branchcd, cs.borproviderref, cs.examinerproviderref, cs.propertydamagednumber, cs.classcd, cs.id, cs.serviceperiodstartdt, cs.historicexpectedrecoveryamt, cs.claimanttransactionnumber, cs.historicpostedrecoveryamt, cs.claimantcd, cs.companycd, cs.historicpaidamt, cs.denytypecd, cs.riskcd, cs.bookdt, cs.startdt, cs.expectedrecoverychangeamt, cs.checkamt, cs.claimstatuscd, cs.reasoncd, cs.featurecd, cs.sublosscausecd, cs.policynumber, cs.statdata, cs.claimantstatuschgind, cs.statuscd, cs.productname, cs.deductible, cs.expirationdt, cs.reservestatuschgind, cs.providerrole, cs.weatherrelatedind, cs.statsequence, cs.paidamt, cs.reservechangeamt, cs.carriercd, cs.featurestatuscd, cs.conversionfilename, cs.examinerprovidercd, cs.rateareaname, cs.conversiontemplateidref, cs.coverageitemcd, cs.insurancetypecd, cs.deductibledescription, cs.checknumber, cs.customerref, cs.policyversion, cs.paymentaccountcd, cs.adjusterprovidercd, cs.claimantstatuscd, cs.conversionjobref, cs.summarykey, cs.policyref, cs.denyreasoncd, cs.limitdescription, cs.policyproductname, cs.claimref, cs.aggregatelimitdescription, cs.policyproductversionidref, cs.policylimit, cs.reservestatuscd, cs.productversionidref, cs.systemcheckreference, cs.filereasoncd, cs.paytoname, cs.producerproviderref, cs.effectivedt, cs.producerprovidercd, cs.policyformcd, cs.statsequencereplace, cs.reservetypecd, cs.policyyear, cs.transactionnumber, cs.recordonly, cs.carriergroupcd, cs.coveragecd, cs.policydeductible, cs.adjusterproviderref, cs.reversalstopind, cs.claimanttransactioncd, cs.policygroupcd, cs.historicreserveamt, cs.enddt, cs.lossyear, cs.linecd, cs.statecd, cs.featuresubcd, cs.combinedkey, cs.postedrecoveryamt, cs.claimanttransactionidref, cs.serviceperiodenddt, cs.policytypecd, cs.catastropheref, cs."limit", cs.aggregatelimit, cs.watermitigationind, cs.checkdt, cs.claimantlinkidref, cs.reservecd, cs.conversiongroup, cs.adddt, cs.transactioncd, cs.annualstatementlinecd, cs.claimstatuschgind, cs.providerref, cs.boreffectivedt, cs.itemnumber, cs._fivetran_deleted, cs._fivetran_synced, bai.bai_code AS bank_code, bai.bai_description AS bank_code_description, 
                CASE
                    WHEN bai.datefield IS NOT NULL THEN 'Cleared'::text
                    ELSE NULL::text
                END AS bank_settlement_status, bai.datefield AS bank_settlement_dt, bai."account" AS clearing_account
           FROM aurora_prodcse.claimstats cs
      LEFT JOIN thirdparty.bai_detail bai ON ltrim(cs.checknumber::text, 0::text) = bai.cust_ref::text
     WHERE cs.bookdt > '2016-01-01 00:00:00'::timestamp without time zone AND 
           CASE
               WHEN isnumeric(cs.checknumber) THEN 
               CASE
                   WHEN cs.checknumber::double precision <= 2147483647::double precision THEN cs.checknumber::integer
                   ELSE NULL::integer
               END
               ELSE NULL::integer
           END) cs
   JOIN aurora_prodcse_dw.claimant ct ON ct.systemid = cs.claimref AND ct.claimantnumber = cs.claimantcd::integer
   LEFT JOIN aurora_prodcse_dw.claimanttransaction ctt ON ct.systemid = ctt.systemid AND ct.id::text = ctt.parentid::text AND ctt.cmmcontainer::text = 'Claim'::text AND ltrim(cs.checknumber::text, 0::text) = ltrim(ctt.recoverychecknumber::text, 0::text)
  WHERE ctt.bookdt > '2016-01-01 00:00:00'::timestamp without time zone;

COMMENT ON VIEW reporting.vcashstlmnt_checks_claimanttransaction_v2 IS 'Cash Settlment. prodcse.ClaimantTransaction (Aurora) and reporting.vcashstlmnt_Checks_ClaimStats joined via Claimant and ltrim(cs.CheckNumber,0)=ltrim(ctt.RecoveryCheckNumber,0) Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_checks_claimstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checks_claimstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_Checks_ClaimStats as 
select cs.*,
bai_code Bank_Code,
bai_description Bank_Code_Description,
case when bai.datefield is not null then 'Cleared' end Bank_Settlement_Status,
bai.datefield Bank_Settlement_DT,
bai.account Clearing_Account
from aurora_prodcse.ClaimStats cs
left outer join thirdparty.bai_detail bai
on ltrim(cs.CheckNumber,0)=bai.cust_ref 
where cs.BookDt>'2016-01-01'
and case when public.isnumeric(cs.CheckNumber) then case when cast(cs.CheckNumber AS float)<=2147483647 then cast(cs.CheckNumber AS int) end end
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_checks_claimstats IS 'Cash Settlment. prodcse.ClaimStats (Aurora) and thirdparty.bai_detail joined via cast(ClaimStats.CheckNumber AS int)=bai_detail.cust_ref Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_checks_payablestats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checks_payablestats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_Checks_PayableStats as 
select ps.*,
bai_code Bank_Code,
bai_description Bank_Code_Description,
case when bai.datefield is not null then 'Cleared' end Bank_Settlement_Status,
bai.datefield Bank_Settlement_DT,
bai.account Clearing_Account
from aurora_prodcse.PayableStats ps
left outer join thirdparty.bai_detail bai
on ltrim(ps.ItemNumber,0)=bai.cust_ref
where ps.BookDt>'2016-01-01'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_checks_payablestats IS 'Cash Settlment. prodcse.PayableStats (Aurora) and thirdparty.bai_detail joined via cast(PayableStats.ItemNumber AS int)=bai_detail.cust_ref Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_checks_suspensestats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checks_suspensestats
AS SELECT ss.systemid, ss.startdt, ss.activitytypecd, ss.statsequencereplace, ss.checkdt, ss.pendingamt, ss.transactionnumber, ss.receiptamt, ss.recreatesuspenseind, ss.policynumber, ss.depositorylocationcd, ss.bookdt, ss.sourcecd, ss.id, ss.systemchecknumber, ss.combinedkey, ss.enddt, ss.checknumber, ss.transactiontypecd, ss.batchid, ss.adddt, ss.statuscd, ss.accountnumber, ss.statsequence, ss.checkamt, ss._fivetran_deleted, ss._fivetran_synced, bai.bai_code AS bank_code, bai.bai_description AS bank_code_description, 
        CASE
            WHEN bai.datefield IS NOT NULL THEN 'Cleared'::text
            ELSE NULL::text
        END AS bank_settlement_status, bai.datefield AS bank_settlement_dt, bai."account" AS clearing_account
   FROM aurora_prodcse.suspensestats ss
   LEFT JOIN thirdparty.bai_detail bai ON ltrim(ss.checknumber::text, 0::text) = bai.cust_ref::text
  WHERE ss.bookdt > '2016-01-01 00:00:00'::timestamp without time zone;

COMMENT ON VIEW reporting.vcashstlmnt_checks_suspensestats IS 'Cash Settlment. prodcse.SuspenseStats (Aurora) and thirdparty.bai_detail joined via cast(SuspenseStats.CheckNumber AS int)=bai_detail.cust_ref Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_checksrefunds_accountstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_checksrefunds_accountstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_ChecksRefunds_AccountStats as 
select acs.*,
bai_code Bank_Code,
bai_description Bank_Code_Description,
case when bai.datefield is not null then 'Cleared' end Bank_Settlement_Status,
bai.datefield Bank_Settlement_DT,
bai.account Clearing_Account
from aurora_prodcse.AccountStats acs
left outer join thirdparty.bai_detail bai
on acs.CheckNumber = bai.cust_ref
where acs.ActivityTypeCd = 'Refund' 
and acs.BookDt>'2016-01-01'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_checksrefunds_accountstats IS 'Cash Settlment. prodcse.AccountStats (Aurora) and thirdparty.bai_detail joined via AccountStats.CheckNumber = bai_detail.cust_ref and ActivityTypeCd = ''Refund''  Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_ebox_accountstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_ebox_accountstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_Ebox_AccountStats as 
select 
acs.*,
case when acs.categorycd='Premium'
and acs.transactiontypecd='Receipt'
and acs.checkdt=acs.bookdt then 'Cleared' end Bank_Settlement_Status
from aurora_prodcse.AccountStats acs
where acs.ARReceiptTypeCd='BillPay'
and acs.checkdt>='2016-03-22'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_ebox_accountstats IS 'Cash Settlment. prodcse.vAccountStats(Aurora) ARReceiptTypeCd=''BillPay'' A record is Cleared (match data from WF BAI data) if categorycd=''Premium'' and transactiontypecd=''Receipt'' and checkdt=bookdt. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_ebox_suspensestats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_ebox_suspensestats
AS /* partner:Coginiti Pro -v 22.8.172 */
create view reporting.vcashstlmnt_Ebox_SuspenseStats as 
select SystemId,id,StatSequence,StatSequenceReplace,PolicyNumber,CombinedKey,AddDt,BookDt,StartDt,EndDt,StatusCd,AccountNumber,TransactionTypeCd,SourceCd,TransactionNumber,CheckNumber,CheckAmt,case when checkdt like '%/%' then to_date(checkdt,'mm/dd/yyyy') else  to_date(checkdt,'yyyymmdd') end CheckDt, BatchId, ActivityTypeCd, ReceiptAmt, PendingAmt,DepositoryLocationCd,SystemCheckNumber,recreatesuspenseind
from aurora_prodcse.suspensestats 
where activitytypecd='Wells Fargo Receivable Manager'
and CheckNumber like '022%'
and case when checkdt like '%/%' then to_date(checkdt,'mm/dd/yyyy') else  to_date(checkdt,'yyyymmdd') end=bookdt
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_ebox_suspensestats IS 'Cash Settlment. prodcse.vAccountStats(Aurora) and thirdparty.bai_detail joined in via activitytypecd=''Wells Fargo Receivable Manager'' and CheckNumber like ''022%'' and checkdt=bookdt. See more details in the project design document. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_lockbox_accountstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_lockbox_accountstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_Lockbox_AccountStats as 
with WF_Lockbox as (
select 
 --bai.account,
bai.datefield,
sum(bai.amount) Amt
from thirdparty.bai_detail bai
where bai.bai_code='115'
and cust_ref='78571'
group by 
 --bai.account,
bai.datefield)
select a.*,
case when wf.datefield is not null then  'Cleared' end Bank_Settlement_Status,
wf.datefield Bank_Settlement_DT,
 --wf.account Clearing_Account,
wf.Amt  Bank_TotalAmt
from aurora_prodcse.accountstats a
left outer join WF_Lockbox wf
on a.CheckDt=wf.datefield
and a.activitytypecd = 'Receipt' 
and a.sourcecd <> 'Manual' 
and a.PaidAmt > 0 
and a.ARReceiptTypeCd = 'Check' 
and a.CategoryCd = 'Premium'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_lockbox_accountstats IS 'Cash Settlment. prodcse.vAccountStats(Aurora) and thirdparty.bai_detail joined in a very complex way. In addition: Bai_Detail.bai_code=''115'' and  Bai_Detail.cust_ref=''78571'' See more details in the project design document. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_lockbox_agg source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_lockbox_agg
AS /* partner:Coginiti Pro -v 22.8.172 */
create view reporting.vcashstlmnt_Lockbox_agg as 
with SuspenseStatsAdj as (
select 
SystemId,id,StatSequence,StatSequenceReplace,PolicyNumber,CombinedKey,AddDt,BookDt,StartDt,EndDt,StatusCd,AccountNumber,TransactionTypeCd,SourceCd,TransactionNumber,CheckNumber,CheckAmt,case when checkdt like '%/%' then to_date(checkdt,'mm/dd/yyyy') else  to_date(checkdt,'yyyymmdd') end CheckDt, BatchId, ActivityTypeCd, ReceiptAmt, PendingAmt,DepositoryLocationCd,SystemCheckNumber,recreatesuspenseind,
split_part(CombinedKey,'|',3) IKey
from aurora_prodcse.SuspenseStats s
where not (CheckNumber like '022%' and case when checkdt like '%/%' then to_date(checkdt,'mm/dd/yyyy') else  to_date(checkdt,'yyyymmdd') end=bookdt)
)
,Suspense as (
select
d1.CheckDt
,sum(case when d2.IKey is not null then d1.ReceiptAmt else 0 end) Refund
,sum(case when d3.IKey is  null then d1.ReceiptAmt else 0 end) Resolved
from SuspenseStatsAdj d1
left outer join SuspenseStatsAdj d2
on d1.IKey=d2.IKey
and d2.TransactionTypeCd='SuspenseRefund'
left outer join SuspenseStatsAdj d3
on d1.IKey=d3.IKey
and d1.SystemId<>d3.SystemId
where d1.TransactionTypeCd='CreateSuspense'
and d1.ActivityTypeCd = 'Wells Fargo Receivable Manager'
group by d1.CheckDt
)
,SuspensePending as (
select
d1.BookDt
,sum(d1.PendingAmt) Pending
from SuspenseStatsAdj d1
where d1.TransactionTypeCd='SuspenseRefundReversed'
and d1.ActivityTypeCd = 'Wells Fargo Receivable Manager'
group by d1.BookDt
)
,SPINN_Lockbox as (
select a.CheckDt
,sum(a.checkamt) Checks
from aurora_prodcse.accountstats a
where a.activitytypecd = 'Receipt' 
and a.sourcecd <> 'Manual' 
and a.PaidAmt > 0 
and a.ARReceiptTypeCd = 'Check' 
and a.CategoryCd = 'Premium'
group by a.CheckDt
)
,WF_Lockbox as (
select 
bai.datefield,
sum(bai.amount) Amt
from thirdparty.bai_detail bai
where bai.bai_code='115'
and cust_ref='78571'
group by bai.datefield)
select 
wf.datefield,
isnull(wf.Amt,0) WF_Lockbox,
sl.Checks SPINN_Lockbox_Checks ,
case when isnull(wf.Amt,0)=sl.Checks then 0 else isnull(s.Refund,0)+isnull(s.Resolved,0)+isnull(sp.Pending,0) end SPINN_Suspense_Refunds_Resolved_Pending,
WF_Lockbox - SPINN_Lockbox_Checks - SPINN_Suspense_Refunds_Resolved_Pending Diff,
isnull(s.Refund,0) SPINN_Suspense_Refunds,
isnull(s.Resolved,0) SPINN_Suspense_Resolved,
isnull(sp.Pending,0) SPINN_Suspense_Pending
from WF_Lockbox wf 
left outer join SPINN_Lockbox sl
on wf.datefield=sl.CheckDt
left outer join Suspense s
on wf.datefield=s.CheckDt
left outer join SuspensePending sp
on wf.datefield=sp.BookDt
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_lockbox_agg IS 'Cash Settlment. Lockbox aggregated view with summaries from ThirdParty.bai_detail, prodcse.SuspenseStats and prodcse.AccountStats (Aurora) See more details in the project design document. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_lockbox_suspensestats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_lockbox_suspensestats
AS /* partner:Coginiti Pro -v 22.8.172 */
create view reporting.vcashstlmnt_Lockbox_SuspenseStats as 
with SuspenseStatsAdj as (
select 
SystemId,id,StatSequence,StatSequenceReplace,PolicyNumber,CombinedKey,AddDt,BookDt,StartDt,EndDt,StatusCd,AccountNumber,TransactionTypeCd,SourceCd,TransactionNumber,CheckNumber,CheckAmt,case when checkdt like '%/%' then to_date(checkdt,'mm/dd/yyyy') else  to_date(checkdt,'yyyymmdd') end CheckDt, BatchId, ActivityTypeCd, ReceiptAmt, PendingAmt,DepositoryLocationCd,SystemCheckNumber,recreatesuspenseind,
split_part(CombinedKey,'|',3) IKey
from aurora_prodcse.SuspenseStats s
where not (CheckNumber like '022%' and case when checkdt like '%/%' then to_date(checkdt,'mm/dd/yyyy') else  to_date(checkdt,'yyyymmdd') end=bookdt)
)
,WF_Lockbox as (
select 
 --bai.account,
bai.datefield,
sum(bai.amount) Amt
from thirdparty.bai_detail bai
where bai.bai_code='115'
and cust_ref='78571'
group by 
 --bai.account,
bai.datefield)
select distinct 
 d1.*,
case when d1.TransactionTypeCd='CreateSuspense' and d1.ActivityTypeCd = 'Wells Fargo Receivable Manager' and d2.IKey is not null then d1.ReceiptAmt else 0 end Refund,
case when d3.IKey is  null then d1.ReceiptAmt else 0 end Resolved,
case when d1.TransactionTypeCd='SuspenseRefundReversed' and d1.ActivityTypeCd = 'Wells Fargo Receivable Manager' then d1.PendingAmt else 0 end Pending,
case when wf.datefield is not null then  'Cleared' end Bank_Settlement_Status,
wf.datefield Bank_Settlement_DT,
 --wf.account Clearing_Account,
wf.Amt  Bank_TotalAmt
from SuspenseStatsAdj d1
left outer join SuspenseStatsAdj d2
on d1.IKey=d2.IKey
and d2.TransactionTypeCd='SuspenseRefund'
left outer join SuspenseStatsAdj d3
on d1.IKey=d3.IKey
and d1.SystemId<>d3.SystemId
left outer join WF_Lockbox wf
on ((d1.CheckDt=wf.datefield and d1.TransactionTypeCd='CreateSuspense')
or  (d1.BookDt=wf.datefield and d1.TransactionTypeCd='SuspenseRefundReversed'))
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_lockbox_suspensestats IS 'Cash Settlment. prodcse.SuspenseStats (Aurora) and thirdparty.bai_detail joined in a very complex way. In addition: Bai_Detail.bai_code=''115'' and  Bai_Detail.cust_ref=''78571'' See more details in the project design document. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_oneinc_accountstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_oneinc_accountstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_OneInc_AccountStats as 
with bai as (
select
ltrim(split_part(bai.text_description,' ',9),'#') externalbatchnumber,
case 
when split_part(bai.text_description,' ',10)='CSESFG' then 'CSESG'
when split_part(bai.text_description,' ',10)='CSEIG' then 'CSEICO'
end  carriercd,
bai.account,
bai_code,
bai_description,
max(bai.datefield) max_datefield,
min(bai.datefield) min_datefield
from thirdparty.bai_detail bai
where bai.bai_code='169' 
group by 
ltrim(split_part(bai.text_description,' ',9),'#'),
case 
when split_part(bai.text_description,' ',10)='CSESFG' then 'CSESG'
when split_part(bai.text_description,' ',10)='CSEIG' then 'CSEICO'
end,
bai.account,
bai_code,
bai_description
)
select acs.*,
bai_code Bank_Code,
bai_description Bank_Code_Description,
case when bai_code is not null then 'Cleared' end Bank_Settlement_Status,
case when acs.arreceipttypecd='ACH' then max_datefield when acs.arreceipttypecd='Credit Card' then min_datefield end Bank_Settlement_DT,
bai.account Clearing_Account
from aurora_prodcse.AccountStats acs
left outer join bai
on bai.externalbatchnumber=acs.externalbatchnumber
and bai.carriercd=acs.carriercd
where acs.arreceipttypecd in ('Credit Card', 'ACH')
and acs.BookDt>'2016-01-01'
order by systemid
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_oneinc_accountstats IS 'Cash Settlment. prodcse.AccountStats (Aurora) and thirdparty.bai_detail joined via AccountStats.ExternalBatchNumber and CarrierCd in Bai_Detail.Text_Description. in addition: AccountStats.arreceipttypecd in (''ACH'',''Credit Card'') and Bai_Detail.bai_code=''169''. Only latest BAI datefield is used for ACH and the first one for Credit Card. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.vcashstlmnt_oneincreturns_accountstats source

CREATE OR REPLACE VIEW reporting.vcashstlmnt_oneincreturns_accountstats
AS /* partner:Coginiti Pro -v 22.7.294 */
create view reporting.vcashstlmnt_OneIncReturns_AccountStats as 
select acs.*,
bai.bai_code Bank_Code,
bai.bai_description Bank_Code_Description,
case when bai_code is not null then 'Cleared' end Bank_Settlement_Status,
bai.datefield Bank_Settlement_DT,
bai.account Clearing_Account
from aurora_prodcse.AccountStats acs
left outer join thirdparty.bai_detail bai 
on ltrim(split_part(bai.text_description,' ',8),'#')=acs.externaltransactionid
and bai.text_description like '%CSE Insurance Gr DEPOSITPMT%' 
and bai.bai_code = '469'
where acs.externaltransactionmsg in ('Chargeback debit','EFT Returned')
and acs.BookDt>'2016-01-01'
with no schema binding;

COMMENT ON VIEW reporting.vcashstlmnt_oneincreturns_accountstats IS 'Cash Settlment. prodcse.AccountStats (Aurora) and thirdparty.bai_detail joined via AccountStats.ExternalTransactionId in Bai_Detail.Text_Description. in addition: AccountStats.externaltransactionmsg in (''Chargeback debit'',''EFT Returned'') and Bai_Detail.and bai.text_description like ''%CSE Insurance Gr DEPOSITPMT%'' and bai.bai_code = 469. Business Owner: Finance - Jeremy Perini - JPerini@cseinsurance.com';


-- reporting.veris_losses source

CREATE OR REPLACE VIEW reporting.veris_losses
AS SELECT vmeris_claims.devq, pgdate_part('qtr'::text, vmeris_claims.loss_date::timestamp without time zone) AS loss_qtr, pgdate_part('year'::text, vmeris_claims.loss_date::timestamp without time zone) AS loss_year, vmeris_claims.reported_qtr, vmeris_claims.reported_year, vmeris_claims.cat_indicator, vmeris_claims.carrier, vmeris_claims.company, vmeris_claims.lob, vmeris_claims.lob2, vmeris_claims.lob3, vmeris_claims.product, vmeris_claims.policystate, vmeris_claims.programind, vmeris_claims.featuretype, vmeris_claims.feature, vmeris_claims.renewaltermcd, vmeris_claims.policyneworrenewal, vmeris_claims.claim_status, vmeris_claims.producer_status, vmeris_claims.source_system, sum(vmeris_claims.qtd_paid_dcc_expense) AS qtd_paid_dcc_expense, sum(vmeris_claims.qtd_paid_expense) AS qtd_paid_expense, sum(vmeris_claims.qtd_incurred_expense) AS qtd_incurred_expense, sum(vmeris_claims.qtd_incurred_dcc_expense) AS qtd_incurred_dcc_expense, sum(vmeris_claims.qtd_paid_salvage_and_subrogation) AS qtd_paid_salvage_and_subrogation, sum(vmeris_claims.qtd_paid_loss) AS qtd_paid_loss, sum(vmeris_claims.qtd_incurred_loss) AS qtd_incurred_loss, sum(vmeris_claims.qtd_paid) AS qtd_paid, sum(vmeris_claims.qtd_incurred) AS qtd_incurred, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation) AS qtd_incurred_net_salvage_subrogation, sum(vmeris_claims.qtd_total_incurred_loss) AS qtd_total_incurred_los, sum(vmeris_claims.paid_on_closed_salvage_subrogation) AS paid_on_closed_salvage_subrogation, sum(vmeris_claims.qtd_paid_25k) AS qtd_paid_25k, sum(vmeris_claims.qtd_paid_50k) AS qtd_paid_50k, sum(vmeris_claims.qtd_paid_100k) AS qtd_paid_100k, sum(vmeris_claims.qtd_paid_250k) AS qtd_paid_250k, sum(vmeris_claims.qtd_paid_500k) AS qtd_paid_500k, sum(vmeris_claims.qtd_paid_1m) AS qtd_paid_1m, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_25k) AS qtd_incurred_net_salvage_subrogation_25k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_50k) AS qtd_incurred_net_salvage_subrogation_50k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_100k) AS qtd_incurred_net_salvage_subrogation_100k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_250k) AS qtd_incurred_net_salvage_subrogation_250k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_500k) AS qtd_incurred_net_salvage_subrogation_500k, sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_1m) AS qtd_incurred_net_salvage_subrogation_1m, sum(vmeris_claims.reported_count) AS reported_count, sum(vmeris_claims.closed_count) AS closed_count, sum(vmeris_claims.closed_nopay) AS closed_nopay, sum(vmeris_claims.paid_on_closed_loss) AS paid_on_closed_loss, sum(vmeris_claims.paid_on_closed_expense) AS paid_on_closed_expense, sum(vmeris_claims.paid_on_closed_dcc_expense) AS paid_on_closed_dcc_expense, sum(vmeris_claims.paid_count) AS paid_count, vmeris_claims.policyformcode, vmeris_claims.altsubtypecd
   FROM reporting.vmeris_claims
  GROUP BY vmeris_claims.devq, pgdate_part('qtr'::text, vmeris_claims.loss_date::timestamp without time zone), pgdate_part('year'::text, vmeris_claims.loss_date::timestamp without time zone), vmeris_claims.reported_qtr, vmeris_claims.reported_year, vmeris_claims.cat_indicator, vmeris_claims.carrier, vmeris_claims.company, vmeris_claims.lob, vmeris_claims.lob2, vmeris_claims.lob3, vmeris_claims.product, vmeris_claims.policystate, vmeris_claims.programind, vmeris_claims.featuretype, vmeris_claims.feature, vmeris_claims.renewaltermcd, vmeris_claims.policyneworrenewal, vmeris_claims.claim_status, vmeris_claims.producer_status, vmeris_claims.source_system, vmeris_claims.policyformcode, vmeris_claims.altsubtypecd
 HAVING sum(vmeris_claims.qtd_paid) <> 0::numeric OR sum(vmeris_claims.qtd_incurred) <> 0::numeric OR sum(vmeris_claims.qtd_paid_25k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_50k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_100k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_250k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_500k) <> 0::numeric OR sum(vmeris_claims.qtd_paid_1m) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_25k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_50k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_100k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_250k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_500k) <> 0::numeric OR sum(vmeris_claims.qtd_incurred_net_salvage_subrogation_1m) <> 0::numeric OR sum(vmeris_claims.reported_count) <> 0 OR sum(vmeris_claims.closed_count) <> 0 OR sum(vmeris_claims.closed_nopay) <> 0 OR sum(vmeris_claims.paid_on_closed_loss) <> 0::numeric OR sum(vmeris_claims.paid_on_closed_expense) <> 0::numeric OR sum(vmeris_claims.paid_on_closed_dcc_expense) <> 0::numeric OR sum(vmeris_claims.paid_on_closed_salvage_subrogation) <> 0::numeric;

COMMENT ON VIEW reporting.veris_losses IS 'Aggregated ERIS Losses, having at least 1 non 0 metric. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';
COMMENT ON COLUMN reporting.veris_losses.devq IS 'DevQ is based on claims loss dates quarters. DevQ is NOT a quarter number. It''s number of months in quarter. (3*number of development quarters). evQ is always less then or equal 120. It''s forcefully set to 120 for higher numbers.';
COMMENT ON COLUMN reporting.veris_losses.loss_qtr IS 'Quarter based on claim loss date';
COMMENT ON COLUMN reporting.veris_losses.loss_year IS 'Year based on claim loss date';
COMMENT ON COLUMN reporting.veris_losses.reported_qtr IS 'Quarter based on claim transaction date';
COMMENT ON COLUMN reporting.veris_losses.reported_year IS 'Year based on claim transaction date';
COMMENT ON COLUMN reporting.veris_losses.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.featuretype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.feature IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_losses.policyneworrenewal IS 'All WINs claims are related to "New" policyneworrenewal due to a complex way getting proper data';
COMMENT ON COLUMN reporting.veris_losses.claim_status IS 'Closed when Reserve=0 or Open';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_dcc_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): dcc_paid';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_dcc_expense IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): dcc_paid + dcc_reserve';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_salvage_and_subrogation IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): salvage_received + subro_received';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_loss IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): loss_paid';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_loss IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): loss_paid + loss_reserve';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
COMMENT ON COLUMN reporting.veris_losses.paid_on_closed_salvage_subrogation IS 'sum of 	ITD_Salvage_and_subrogation If closed_count 1 else 0';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_25k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(25k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_50k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(50k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_100k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(100k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_250k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(250k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_500k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(500k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_paid_1m IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(1m, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation_25k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(25k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation_50k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(50k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation_100k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(100k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation_250k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(250k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation_500k IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(500k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.qtd_incurred_net_salvage_subrogation_1m IS 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(1m,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
COMMENT ON COLUMN reporting.veris_losses.reported_count IS 'sum of 	1 or 0 Reported Count is based on transactional level.  The script is looking for the first transaction date(*) and quarter when this condition is TRUE in a transaction (no aggragation in metric values): loss_paid>=0.5 or loss_reserve>=0.5 or f.aoo_paid>=0.5 or aoo_reserve>=0.5 or dcc_paid>=0.5 or dcc_reserve>=0.5 or salvage_received>=0.5 or subro_received>=0.5';
COMMENT ON COLUMN reporting.veris_losses.closed_count IS 'sum of 	1 or 0 Closed Count is based on transactional level. The script is looking for the latest transaction date and quarter (from transactional date) when this condition is TRUE:sum(loss_reserve + aoo_reserve + dcc_reserve)<0.5 (The data are aggregated at the claim-claimant-ERIS feature level (see Configuration) and transaction date)';
COMMENT ON COLUMN reporting.veris_losses.closed_nopay IS 'sum of 	The same as closed count but in the same quorter this condition should be TRUE ITD_Paid_Loss + ITD_Paid_Expense<=0 to have 1 in the metric';
COMMENT ON COLUMN reporting.veris_losses.paid_on_closed_loss IS 'sum of 	ITD_Paid_Loss If closed_count 1 else 0';
COMMENT ON COLUMN reporting.veris_losses.paid_on_closed_expense IS 'sum of 	ITD_Paid_Expense If closed_count 1 else 0';
COMMENT ON COLUMN reporting.veris_losses.paid_on_closed_dcc_expense IS 'sum of 	ITD_Paid_DCC_Expense If closed_count 1 else 0';
COMMENT ON COLUMN reporting.veris_losses.paid_count IS 'sum of 	1 in DevQ when ITD_Loss_and_ALAE_for_Paid_count>0';
COMMENT ON COLUMN reporting.veris_losses.altsubtypecd IS 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';


-- reporting.veris_losses_quarterly_snapshots source

create or replace view reporting.veris_losses_quarterly_snapshots as 
select 
data.*
from external_data_pricing.veris_losses_ia data
join reporting.veris_quarterly_latest_snapshots f
on data.quarter_id=f.quarter_id
and data.snapshot_id=f.snapshot_id
and f.tablename='veris_losses_ia'
with no schema binding;

COMMENT ON VIEW reporting.veris_losses_quarterly_snapshots IS 'The view can be used instead of the original table to get data only from the latest snapshot per quarter. Only quarter ID is needed to get the data.';


-- reporting.veris_premium source

CREATE OR REPLACE VIEW reporting.veris_premium
AS SELECT vmeris_policies.report_year, vmeris_policies.report_quarter, vmeris_policies.renewaltermcd, vmeris_policies.policyneworrenewal, vmeris_policies.policystate, vmeris_policies.companynumber, vmeris_policies.company, vmeris_policies.lob, vmeris_policies.asl, vmeris_policies.lob2, vmeris_policies.lob3, vmeris_policies.product, vmeris_policies.policyformcode, vmeris_policies.programind, vmeris_policies.producer_status, vmeris_policies.coveragetype, vmeris_policies.coverage, vmeris_policies.feeind, sum(vmeris_policies.wp) AS wp, sum(vmeris_policies.ep) AS ep, sum(vmeris_policies.clep) AS clep, sum(vmeris_policies.ee) AS ee, vmeris_policies.altsubtypecd
   FROM reporting.vmeris_policies
  GROUP BY vmeris_policies.report_year, vmeris_policies.report_quarter, vmeris_policies.renewaltermcd, vmeris_policies.policyneworrenewal, vmeris_policies.policystate, vmeris_policies.companynumber, vmeris_policies.company, vmeris_policies.lob, vmeris_policies.asl, vmeris_policies.lob2, vmeris_policies.lob3, vmeris_policies.product, vmeris_policies.policyformcode, vmeris_policies.programind, vmeris_policies.producer_status, vmeris_policies.coveragetype, vmeris_policies.coverage, vmeris_policies.feeind, vmeris_policies.altsubtypecd;

COMMENT ON VIEW reporting.veris_premium IS 'ERIS Premiums aggregated level. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';
COMMENT ON COLUMN reporting.veris_premium.report_year IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN reporting.veris_premium.report_quarter IS 'Based on policy transaction accounting date';
COMMENT ON COLUMN reporting.veris_premium.lob IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.lob2 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.lob3 IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.product IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.programind IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.coveragetype IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.coverage IS 'See Configuration in ERIS Tables Design document';
COMMENT ON COLUMN reporting.veris_premium.wp IS 'Sum of Written Premium';
COMMENT ON COLUMN reporting.veris_premium.ep IS 'Sum of Earned Premium';
COMMENT ON COLUMN reporting.veris_premium.clep IS 'Sum of Current Level Earned Premium: Earned premium adjusted using all rate changes starting after policy term effecyive date, based on company,  state, policyformcode,  new or renewal policy. ';
COMMENT ON COLUMN reporting.veris_premium.altsubtypecd IS 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';


-- reporting.veris_premium_quarterly_snapshots source

create or replace view reporting.veris_premium_quarterly_snapshots as 
select 
data.*
from external_data_pricing.veris_premium_ia data
join reporting.veris_quarterly_latest_snapshots f
on data.quarter_id=f.quarter_id
and data.snapshot_id=f.snapshot_id
and f.tablename='veris_premium_ia'
with no schema binding;

COMMENT ON VIEW reporting.veris_premium_quarterly_snapshots IS 'The view can be used instead of the original table to get data only from the latest snapshot per quarter. Only quarter ID is needed to get the data.';


-- reporting.veris_quarterly_latest_snapshots source

CREATE OR REPLACE VIEW reporting.veris_quarterly_latest_snapshots
AS SELECT external_partitions.tablename, "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 1), '['::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text) AS quarter_id, "max"("replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 2), ']'::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text)) AS snapshot_id
   FROM reporting.external_partitions
  WHERE external_partitions.schemaname = 'external_data_pricing'::character varying::text AND external_partitions.tablename ~~ '%eris%ia'::character varying::text
  GROUP BY external_partitions.tablename, "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 1), '['::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text)
  ORDER BY external_partitions.tablename, "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 1), '['::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text);


-- reporting.veris_quarterly_snapshots source

CREATE OR REPLACE VIEW reporting.veris_quarterly_snapshots
AS SELECT external_partitions.tablename, "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 1), '['::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text) AS quarter_id, "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 2), ']'::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text) AS snapshot_id, 'select * from external_data_pricing.'::character varying::text + external_partitions.tablename + ' where quarter_id=\''::character varying::text + "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 1), '['::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text) + '\' and snapshot_id=\''::character varying::text + "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 2), ']'::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text) + '\' limit 100'::character varying::text AS sql
   FROM reporting.external_partitions
  WHERE external_partitions.schemaname = 'external_data_pricing'::character varying::text AND external_partitions.tablename ~~ '%eris%ia'::character varying::text
  ORDER BY external_partitions.tablename, "replace"("replace"(split_part(external_partitions."values", ','::character varying::text, 1), '['::character varying::text, ''::character varying::text), '"'::character varying::text, ''::character varying::text);


-- reporting.vexecprodmonitor_main source

CREATE OR REPLACE VIEW reporting.vexecprodmonitor_main
AS SELECT 'SPINN' AS sourcesystem, COALESCE(spinn_data.mon_startdate, p.pln_startdate) AS mon_startdate, COALESCE(spinn_data.mon_monthinyear, p.pln_month) AS mon_monthinyear, COALESCE(spinn_data.mon_monthabbr, p.pln_monthabbr) AS mon_monthabbr, COALESCE(spinn_data.mon_year, p.pln_year) AS mon_year, COALESCE(spinn_data.reportperiod, p.pln_reportperiod::character varying) AS reportperiod, COALESCE(spinn_data.state, p.pln_state) AS state, COALESCE(spinn_data.company, p.pln_company::text)::character varying AS company, COALESCE(spinn_data.term, p.pln_term) AS term, COALESCE(spinn_data.lob, p.pln_lob::text)::character varying AS lob, spinn_data.mtd_writprem, spinn_data.ytd_writprem AS ytd_writprem_origin, spinn_data.new_mtd_writprem, spinn_data.new_ytd_writprem, spinn_data.for_avg_mtd_writprem, spinn_data.for_avg_ytd_writprem, spinn_data.for_avg_new_mtd_writprem, spinn_data.for_avg_new_ytd_writprem, spinn_data.total_polcnt, spinn_data.new_polcnt, spinn_data.pif, COALESCE(spinn_data.pif_ye_prev, 0::bigint) AS pif_ye_prev, sum(spinn_data.mtd_writprem)
  OVER( 
  PARTITION BY spinn_data.mon_year, spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ORDER BY spinn_data.mon_year, spinn_data.mon_monthinyear, spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_writprem, sum(spinn_data.total_polcnt)
  OVER( 
  PARTITION BY spinn_data.mon_year, spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ORDER BY spinn_data.mon_year, spinn_data.mon_monthinyear, spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_total_polcnt, sum(spinn_data.new_polcnt)
  OVER( 
  PARTITION BY spinn_data.mon_year, spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ORDER BY spinn_data.mon_year, spinn_data.mon_monthinyear, spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_new_polcnt, COALESCE(pg_catalog.lead(spinn_data.total_polcnt, 
        CASE
            WHEN spinn_data.term::text = '1 Year'::text THEN 12
            ELSE 6
        END)
  OVER( 
  PARTITION BY spinn_data.state, spinn_data.company, spinn_data.term, spinn_data.lob, p.pln_type
  ORDER BY spinn_data.mon_year DESC, spinn_data.mon_monthinyear DESC, spinn_data.state DESC, spinn_data.company DESC, spinn_data.term DESC, spinn_data.lob DESC, p.pln_type DESC), 0::bigint) AS offset_for_retention, COALESCE(p.pln_wp, 0::numeric) AS pln_wp, COALESCE(p.pln_new_wp, 0::numeric) AS pln_new_wp, COALESCE(p.pln_renewed_wp, 0::numeric) AS pln_renewed_wp, COALESCE(p.pln_new_polcnt, 0::numeric) AS pln_new_polcnt, COALESCE(p.pln_renewed_polcnt, 0::numeric) AS pln_renewed_polcnt, COALESCE(p.pln_pif, 0::numeric) AS pln_pif, COALESCE(p.pln_ytd_wp, 0::numeric) AS pln_ytd_wp, COALESCE(p.pln_ytd_new_wp, 0::numeric) AS pln_ytd_new_wp, COALESCE(p.pln_ytd_renewed_wp, 0::numeric) AS pln_ytd_renewed_wp, COALESCE(p.pln_ytd_new_polcnt, 0::numeric) AS pln_ytd_new_polcnt, COALESCE(p.pln_ytd_renewed_polcnt, 0::numeric) AS pln_ytd_renewed_polcnt, COALESCE(p.pln_year_issue, 0) AS pln_year_issue, COALESCE(p.pln_type, 'Budget/Forecast'::text)::character varying AS pln_type
   FROM ( SELECT s1.sourcesystem, s1.mon_startdate, s1.mon_monthinyear, s1.mon_monthabbr, s1.mon_year, s1.reportperiod, s1.state, s1.company, s1.term, s1.lob, s1.mtd_writprem, s1.ytd_writprem, s1.new_mtd_writprem, s1.new_ytd_writprem, s1.for_avg_mtd_writprem, s1.for_avg_ytd_writprem, s1.for_avg_new_mtd_writprem, s1.for_avg_new_ytd_writprem, s1.total_polcnt, s1.new_polcnt, s1.pif, s2.pif AS pif_ye_prev
           FROM ( SELECT 'SPINN'::character varying AS sourcesystem, dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod AS reportperiod, b.pol_masterstate AS state, 
                        CASE
                            WHEN b.pol_masterstate::text = 'AZ'::text THEN 'AZ-ICO'::text
                            WHEN b.pol_masterstate::text = 'NV'::text THEN 'NV-ICO'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND pe.altsubtypecd::text = 'HO3-Homeguard'::text THEN 'CA-Homeguard'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0001'::text OR vdc.comp_number::text = '0002'::text) THEN 'CA-ICO'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0016'::text OR vdc.comp_number::text = '0017'::text) THEN 'CA-SG'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND vdc.comp_number::text = '0019'::text THEN 'CA-Select'::text
                            WHEN b.pol_masterstate::text = 'UT'::text THEN 'UT-Select'::text
                            ELSE b.pol_masterstate::text + '-'::text + vdc.comp_name1::text
                        END AS company, pe.renewaltermcd AS term, 
                        CASE
                            WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
                            WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
                            WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
                            WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
                            ELSE 'Other'::text
                        END AS lob, round(sum(a.wrtn_prem_amt), 0) AS mtd_writprem, round(sum(a.wrtn_prem_amt_ytd), 0) AS ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS new_ytd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_mtd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_ytd_writprem, count(DISTINCT 
                        CASE
                            WHEN dm.mon_reportperiod::text = ped.poleff_reportperiod::text AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND c.cov_code::text !~~ '%Fee%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS total_polcnt, count(DISTINCT 
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND dm.mon_reportperiod::text = a.firstreportperiod::text AND pmtdf.policy_wrtn_prem_amt > 0::numeric AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND c.cov_code::text !~~ '%Fee%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS new_polcnt, count(DISTINCT 
                        CASE
                            WHEN p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND c.cov_code::text !~~ '%Fee%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS pif
                   FROM ( SELECT d.policy_id, dm.month_id, d.coverage_id, d.product_id, d.policyextension_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, 
                                CASE
                                    WHEN d.lastreportperiod = dm.month_id THEN d.wrtn_prem_amt
                                    ELSE 0::numeric
                                END AS wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.policyextension_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_spinn.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_spinn.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                      RIGHT JOIN fsbi_dw_spinn.dim_month dm ON dm.month_id >= d.lastreportperiod AND dm.mon_year = "substring"(d.lastreportperiod::text, 1, 4)::integer
                     WHERE d.lastreportperiod = d.month_id
                UNION ALL 
                         SELECT d.policy_id, d.month_id, d.coverage_id, d.product_id, d.policyextension_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, d.wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.policyextension_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_spinn.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_spinn.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                          WHERE d.lastreportperiod > d.month_id) a
              JOIN fsbi_dw_spinn.dim_policy b ON a.policy_id = b.policy_id
         JOIN fsbi_dw_spinn.dim_coverage c ON a.coverage_id = c.coverage_id
    JOIN fsbi_dw_spinn.dim_product d ON a.product_id = d.product_id
   JOIN fsbi_dw_spinn.vdim_company vdc ON a.company_id = vdc.company_id
   JOIN fsbi_dw_spinn.dim_month dm ON a.month_id = dm.month_id
   JOIN fsbi_dw_spinn.vdim_policystatus p ON a.policystatus_id = p.policystatus_id
   JOIN fsbi_dw_spinn.dim_policyextension pe ON a.policyextension_id = pe.policyextension_id
   JOIN fsbi_dw_spinn.vdim_policyeffectivedate ped ON a.policyeffectivedate_id = ped.policyeffectivedate_id
   LEFT JOIN ( SELECT a.policy_id, a.month_id, sum(a.wrtn_prem_amt) AS policy_wrtn_prem_amt, sum(a.term_prem_amt_itd) AS policy_term_prem_amt_itd
   FROM fsbi_dw_spinn.fact_policy a
  GROUP BY a.policy_id, a.month_id) pmtdf ON pmtdf.policy_id = b.policy_id AND pmtdf.month_id = a.month_id
  GROUP BY dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod, b.pol_masterstate, 
CASE
    WHEN b.pol_masterstate::text = 'AZ'::text THEN 'AZ-ICO'::text
    WHEN b.pol_masterstate::text = 'NV'::text THEN 'NV-ICO'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND pe.altsubtypecd::text = 'HO3-Homeguard'::text THEN 'CA-Homeguard'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0001'::text OR vdc.comp_number::text = '0002'::text) THEN 'CA-ICO'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0016'::text OR vdc.comp_number::text = '0017'::text) THEN 'CA-SG'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND vdc.comp_number::text = '0019'::text THEN 'CA-Select'::text
    WHEN b.pol_masterstate::text = 'UT'::text THEN 'UT-Select'::text
    ELSE b.pol_masterstate::text + '-'::text + vdc.comp_name1::text
END, pe.renewaltermcd, 
CASE
    WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
    WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
    WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
    WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
    ELSE 'Other'::text
END) s1
      LEFT JOIN ( SELECT 'SPINN' AS sourcesystem, dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod AS reportperiod, b.pol_masterstate AS state, 
                        CASE
                            WHEN b.pol_masterstate::text = 'AZ'::text THEN 'AZ-ICO'::text
                            WHEN b.pol_masterstate::text = 'NV'::text THEN 'NV-ICO'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND pe.altsubtypecd::text = 'HO3-Homeguard'::text THEN 'CA-Homeguard'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0001'::text OR vdc.comp_number::text = '0002'::text) THEN 'CA-ICO'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0016'::text OR vdc.comp_number::text = '0017'::text) THEN 'CA-SG'::text
                            WHEN b.pol_masterstate::text = 'CA'::text AND vdc.comp_number::text = '0019'::text THEN 'CA-Select'::text
                            WHEN b.pol_masterstate::text = 'UT'::text THEN 'UT-Select'::text
                            ELSE b.pol_masterstate::text + '-'::text + vdc.comp_name1::text
                        END AS company, pe.renewaltermcd AS term, 
                        CASE
                            WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
                            WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
                            WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
                            WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
                            ELSE 'Other'::text
                        END AS lob, round(sum(a.wrtn_prem_amt), 0) AS mtd_writprem, round(sum(a.wrtn_prem_amt_ytd), 0) AS ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS new_ytd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_mtd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_ytd_writprem, count(DISTINCT 
                        CASE
                            WHEN dm.mon_reportperiod::text = ped.poleff_reportperiod::text AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND c.cov_code::text !~~ '%Fee%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS total_polcnt, count(DISTINCT 
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND dm.mon_reportperiod::text = a.firstreportperiod::text AND pmtdf.policy_wrtn_prem_amt > 0::numeric AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND c.cov_code::text !~~ '%Fee%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS new_polcnt, count(DISTINCT 
                        CASE
                            WHEN p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND c.cov_code::text !~~ '%Fee%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS pif
                   FROM ( SELECT d.policy_id, dm.month_id, d.coverage_id, d.product_id, d.policyextension_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, 
                                CASE
                                    WHEN d.lastreportperiod = dm.month_id THEN d.wrtn_prem_amt
                                    ELSE 0::numeric
                                END AS wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.policyextension_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_spinn.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_spinn.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                      RIGHT JOIN fsbi_dw_spinn.dim_month dm ON dm.month_id >= d.lastreportperiod AND dm.mon_year = "substring"(d.lastreportperiod::text, 1, 4)::integer
                     WHERE d.lastreportperiod = d.month_id
                UNION ALL 
                         SELECT d.policy_id, d.month_id, d.coverage_id, d.product_id, d.policyextension_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, d.wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.policyextension_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_spinn.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_spinn.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                          WHERE d.lastreportperiod > d.month_id) a
              JOIN fsbi_dw_spinn.dim_policy b ON a.policy_id = b.policy_id
         JOIN fsbi_dw_spinn.dim_coverage c ON a.coverage_id = c.coverage_id
    JOIN fsbi_dw_spinn.dim_product d ON a.product_id = d.product_id
   JOIN fsbi_dw_spinn.vdim_company vdc ON a.company_id = vdc.company_id
   JOIN fsbi_dw_spinn.dim_month dm ON a.month_id = dm.month_id
   JOIN fsbi_dw_spinn.vdim_policystatus p ON a.policystatus_id = p.policystatus_id
   JOIN fsbi_dw_spinn.dim_policyextension pe ON a.policyextension_id = pe.policyextension_id
   JOIN fsbi_dw_spinn.vdim_policyeffectivedate ped ON a.policyeffectivedate_id = ped.policyeffectivedate_id
   LEFT JOIN ( SELECT a.policy_id, a.month_id, sum(a.wrtn_prem_amt) AS policy_wrtn_prem_amt, sum(a.term_prem_amt_itd) AS policy_term_prem_amt_itd
   FROM fsbi_dw_spinn.fact_policy a
  GROUP BY a.policy_id, a.month_id) pmtdf ON pmtdf.policy_id = b.policy_id AND pmtdf.month_id = a.month_id
  GROUP BY dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod, b.pol_masterstate, 
CASE
    WHEN b.pol_masterstate::text = 'AZ'::text THEN 'AZ-ICO'::text
    WHEN b.pol_masterstate::text = 'NV'::text THEN 'NV-ICO'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND pe.altsubtypecd::text = 'HO3-Homeguard'::text THEN 'CA-Homeguard'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0001'::text OR vdc.comp_number::text = '0002'::text) THEN 'CA-ICO'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND (vdc.comp_number::text = '0016'::text OR vdc.comp_number::text = '0017'::text) THEN 'CA-SG'::text
    WHEN b.pol_masterstate::text = 'CA'::text AND vdc.comp_number::text = '0019'::text THEN 'CA-Select'::text
    WHEN b.pol_masterstate::text = 'UT'::text THEN 'UT-Select'::text
    ELSE b.pol_masterstate::text + '-'::text + vdc.comp_name1::text
END, pe.renewaltermcd, 
CASE
    WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
    WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
    WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
    WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
    ELSE 'Other'::text
END) s2 ON s2.mon_year = (s1.mon_year - 1) AND s2.state::text = s1.state::text AND s2.company = s1.company AND s2.lob = s1.lob AND s2.term::text = s1.term::text AND s2.mon_monthinyear = 12) spinn_data
   LEFT JOIN ( SELECT to_date(
                CASE
                    WHEN budgetforecast_20230208.pln_month < 10 THEN '0'::text
                    ELSE ''::text
                END + budgetforecast_20230208.pln_month::character varying::text + '-01-'::text + budgetforecast_20230208.pln_year::character varying::text, 'mm-dd-yyyy'::text) AS pln_startdate, budgetforecast_20230208.pln_year::character varying::text + 
                CASE
                    WHEN budgetforecast_20230208.pln_month < 10 THEN '0'::text
                    ELSE ''::text
                END + budgetforecast_20230208.pln_month::character varying::text AS pln_reportperiod, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_monthabbr, budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, budgetforecast_20230208.pln_wp, budgetforecast_20230208.pln_new_wp, budgetforecast_20230208.pln_renewed_wp, budgetforecast_20230208.pln_new_polcnt, budgetforecast_20230208.pln_renewed_polcnt, budgetforecast_20230208.pln_pif, budgetforecast_20230208.pln_year_issue, sum(budgetforecast_20230208.pln_wp)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_wp, sum(budgetforecast_20230208.pln_new_wp)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_new_wp, sum(budgetforecast_20230208.pln_renewed_wp)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_renewed_wp, sum(budgetforecast_20230208.pln_new_polcnt)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_new_polcnt, sum(budgetforecast_20230208.pln_renewed_polcnt)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_renewed_polcnt, 'Budget'::text AS pln_type
           FROM reporting.budgetforecast_20230208
          WHERE budgetforecast_20230208.business_source::text = 'IA'::text) p ON spinn_data.mon_monthinyear = p.pln_month AND spinn_data.mon_year = p.pln_year AND spinn_data.state::text = p.pln_state::text AND spinn_data.company = p.pln_company::text AND spinn_data.lob = p.pln_lob::text AND spinn_data.term::text = p.pln_term::text
UNION ALL 
 SELECT 'UU' AS sourcesystem, COALESCE(uu_data.mon_startdate, p.pln_startdate) AS mon_startdate, COALESCE(uu_data.mon_monthinyear, p.pln_month) AS mon_monthinyear, COALESCE(uu_data.mon_monthabbr, p.pln_monthabbr) AS mon_monthabbr, COALESCE(uu_data.mon_year, p.pln_year) AS mon_year, COALESCE(uu_data.reportperiod, p.pln_reportperiod::character varying) AS reportperiod, COALESCE(uu_data.state, p.pln_state) AS state, COALESCE(uu_data.company, p.pln_company) AS company, COALESCE(uu_data.term, p.pln_term::text)::character varying AS term, COALESCE(uu_data.lob, p.pln_lob::text)::character varying AS lob, uu_data.mtd_writprem, uu_data.ytd_writprem AS ytd_writprem_origin, uu_data.new_mtd_writprem, uu_data.new_ytd_writprem, uu_data.for_avg_mtd_writprem, uu_data.for_avg_ytd_writprem, uu_data.for_avg_new_mtd_writprem, uu_data.for_avg_new_ytd_writprem, uu_data.total_polcnt, uu_data.new_polcnt, uu_data.pif, COALESCE(uu_data.pif_ye_prev, 0::bigint) AS pif_ye_prev, sum(uu_data.mtd_writprem)
  OVER( 
  PARTITION BY uu_data.mon_year, uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ORDER BY uu_data.mon_year, uu_data.mon_monthinyear, uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_writprem, sum(uu_data.total_polcnt)
  OVER( 
  PARTITION BY uu_data.mon_year, uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ORDER BY uu_data.mon_year, uu_data.mon_monthinyear, uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_total_polcnt, sum(uu_data.new_polcnt)
  OVER( 
  PARTITION BY uu_data.mon_year, uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ORDER BY uu_data.mon_year, uu_data.mon_monthinyear, uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_new_polcnt, COALESCE(pg_catalog.lead(uu_data.total_polcnt, 
        CASE
            WHEN uu_data.term = '1 Year'::text THEN 12
            ELSE 6
        END)
  OVER( 
  PARTITION BY uu_data.state, uu_data.company, uu_data.term, uu_data.lob, p.pln_type
  ORDER BY uu_data.mon_year DESC, uu_data.mon_monthinyear DESC, uu_data.state DESC, uu_data.term DESC, uu_data.lob DESC, p.pln_type DESC), 0::bigint) AS offset_for_retention, COALESCE(p.pln_wp, 0::numeric) AS pln_wp, COALESCE(p.pln_new_wp, 0::numeric) AS pln_new_wp, COALESCE(p.pln_renewed_wp, 0::numeric) AS pln_renewed_wp, COALESCE(p.pln_new_polcnt, 0::numeric) AS pln_new_polcnt, COALESCE(p.pln_renewed_polcnt, 0::numeric) AS pln_renewed_polcnt, COALESCE(p.pln_pif, 0::numeric) AS pln_pif, COALESCE(p.pln_ytd_wp, 0::numeric) AS pln_ytd_wp, COALESCE(p.pln_ytd_new_wp, 0::numeric) AS pln_ytd_new_wp, COALESCE(p.pln_ytd_renewed_wp, 0::numeric) AS pln_ytd_renewed_wp, COALESCE(p.pln_ytd_new_polcnt, 0::numeric) AS pln_ytd_new_polcnt, COALESCE(p.pln_ytd_renewed_polcnt, 0::numeric) AS pln_ytd_renewed_polcnt, COALESCE(p.pln_year_issue, 0) AS pln_year_issue, COALESCE(p.pln_type, 'Budget/Forecast'::text)::character varying AS pln_type
   FROM ( SELECT s1.sourcesystem, s1.mon_startdate, s1.mon_monthinyear, s1.mon_monthabbr, s1.mon_year, s1.reportperiod, s1.state, s1.company, s1.term, s1.lob, s1.mtd_writprem, s1.ytd_writprem, s1.new_mtd_writprem, s1.new_ytd_writprem, s1.for_avg_mtd_writprem, s1.for_avg_ytd_writprem, s1.for_avg_new_mtd_writprem, s1.for_avg_new_ytd_writprem, s1.total_polcnt, s1.new_polcnt, s1.pif, s2.pif AS pif_ye_prev
           FROM ( SELECT 'UU'::character varying AS sourcesystem, dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod AS reportperiod, b.pol_masterstate AS state, 'UT-SG'::character varying AS company, 
                        CASE
                            WHEN date_diff('month'::text, ped.poleff_date::timestamp without time zone, pex.polexp_date::timestamp without time zone) <= 6 THEN '6 Months'::text
                            ELSE '1 Year'::text
                        END AS term, 
                        CASE
                            WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
                            WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
                            WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
                            WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
                            ELSE 'Other'::text
                        END AS lob, round(sum(a.wrtn_prem_amt), 0) AS mtd_writprem, round(sum(a.wrtn_prem_amt_ytd), 0) AS ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS new_ytd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_mtd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_ytd_writprem, count(DISTINCT 
                        CASE
                            WHEN dm.mon_reportperiod::text = ped.poleff_reportperiod::text AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND upper(c.cov_code::text) !~~ '%FEE%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS total_polcnt, count(DISTINCT 
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND dm.mon_reportperiod::text = a.firstreportperiod::text AND pmtdf.policy_wrtn_prem_amt > 0::numeric AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND upper(c.cov_code::text) !~~ '%FEE%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS new_polcnt, count(DISTINCT 
                        CASE
                            WHEN p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND upper(c.cov_code::text) !~~ '%FEE%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS pif
                   FROM ( SELECT d.policy_id, dm.month_id, d.coverage_id, d.product_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, 
                                CASE
                                    WHEN d.lastreportperiod = dm.month_id THEN d.wrtn_prem_amt
                                    ELSE 0::numeric
                                END AS wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, a.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_uu.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_uu.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                      RIGHT JOIN fsbi_dw_uu.dim_month dm ON dm.month_id >= d.lastreportperiod AND dm.mon_year = "substring"(d.lastreportperiod::text, 1, 4)::integer
                     WHERE d.lastreportperiod = d.month_id
                UNION ALL 
                         SELECT d.policy_id, d.month_id, d.coverage_id, d.product_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, d.wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, a.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_uu.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_uu.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                          WHERE d.lastreportperiod > d.month_id) a
              JOIN fsbi_dw_uu.dim_policy b ON a.policy_id = b.policy_id
         JOIN fsbi_dw_uu.dim_coverage c ON a.coverage_id = c.coverage_id
    JOIN fsbi_dw_uu.dim_product d ON a.product_id = d.product_id
   JOIN fsbi_dw_uu.vdim_company vdc ON a.company_id = vdc.company_id
   JOIN fsbi_dw_uu.dim_month dm ON a.month_id = dm.month_id
   JOIN fsbi_dw_uu.vdim_policystatus p ON a.policystatus_id = p.policystatus_id
   JOIN fsbi_dw_uu.vdim_policyeffectivedate ped ON a.policyeffectivedate_id = ped.policyeffectivedate_id
   JOIN fsbi_dw_uu.vdim_policyexpirationdate pex ON a.policyexpirationdate_id = pex.policyexpirationdate_id
   LEFT JOIN ( SELECT a.policy_id, a.month_id, sum(a.wrtn_prem_amt) AS policy_wrtn_prem_amt, sum(a.term_prem_amt_itd) AS policy_term_prem_amt_itd
   FROM fsbi_dw_uu.fact_policy a
  GROUP BY a.policy_id, a.month_id) pmtdf ON pmtdf.policy_id = b.policy_id AND pmtdf.month_id = a.month_id
  WHERE d.prdt_lob::text <> 'Umbrella'::text
  GROUP BY dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod, b.pol_masterstate, 
CASE
    WHEN date_diff('month'::text, ped.poleff_date::timestamp without time zone, pex.polexp_date::timestamp without time zone) <= 6 THEN '6 Months'::text
    ELSE '1 Year'::text
END, 
CASE
    WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
    WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
    WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
    WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
    ELSE 'Other'::text
END) s1
      LEFT JOIN ( SELECT 'UU' AS sourcesystem, dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod AS reportperiod, b.pol_masterstate AS state, 'UT-SG'::character varying AS company, 
                        CASE
                            WHEN date_diff('month'::text, ped.poleff_date::timestamp without time zone, pex.polexp_date::timestamp without time zone) <= 6 THEN '6 Months'::text
                            ELSE '1 Year'::text
                        END AS term, 
                        CASE
                            WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
                            WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
                            WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
                            WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
                            ELSE 'Other'::text
                        END AS lob, round(sum(a.wrtn_prem_amt), 0) AS mtd_writprem, round(sum(a.wrtn_prem_amt_ytd), 0) AS ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS new_ytd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_mtd_writprem, round(sum(
                        CASE
                            WHEN p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_ytd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_mtd_writprem, round(sum(
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND p.polst_statuscd::text <> 'CF'::text AND p.polst_statuscd::text <> 'CM'::text AND p.polst_statuscd::text <> 'CN'::text THEN a.wrtn_prem_amt_ytd
                            ELSE 0::numeric
                        END), 0) AS for_avg_new_ytd_writprem, count(DISTINCT 
                        CASE
                            WHEN dm.mon_reportperiod::text = ped.poleff_reportperiod::text AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND upper(c.cov_code::text) !~~ '%FEE%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS total_polcnt, count(DISTINCT 
                        CASE
                            WHEN a.policyneworrenewal::text = 'New'::text AND dm.mon_reportperiod::text = a.firstreportperiod::text AND pmtdf.policy_wrtn_prem_amt > 0::numeric AND p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND upper(c.cov_code::text) !~~ '%FEE%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS new_polcnt, count(DISTINCT 
                        CASE
                            WHEN p.polst_statuscd::text = 'INF'::text AND pmtdf.policy_term_prem_amt_itd > 0::numeric AND upper(c.cov_code::text) !~~ '%FEE%'::text THEN b.pol_policynumber
                            ELSE NULL::character varying
                        END) AS pif
                   FROM ( SELECT d.policy_id, dm.month_id, d.coverage_id, d.product_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, 
                                CASE
                                    WHEN d.lastreportperiod = dm.month_id THEN d.wrtn_prem_amt
                                    ELSE 0::numeric
                                END AS wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, a.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_uu.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_uu.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                      RIGHT JOIN fsbi_dw_uu.dim_month dm ON dm.month_id >= d.lastreportperiod AND dm.mon_year = "substring"(d.lastreportperiod::text, 1, 4)::integer
                     WHERE d.lastreportperiod = d.month_id
                UNION ALL 
                         SELECT d.policy_id, d.month_id, d.coverage_id, d.product_id, d.company_id, d.policyneworrenewal, d.policystatus_id, d.policyeffectivedate_id, d.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, d.wrtn_prem_amt, d.wrtn_prem_amt_ytd
                           FROM ( SELECT a.policy_id, a.month_id, a.coverage_id, a.product_id, a.company_id, a.policyneworrenewal, a.policystatus_id, a.policyeffectivedate_id, a.policyexpirationdate_id, d.firstreportperiod, d.lastreportperiod, a.wrtn_prem_amt, a.wrtn_prem_amt_ytd
                                   FROM fsbi_dw_uu.fact_policycoverage a
                              JOIN ( SELECT f.policy_id, min(f.month_id) AS firstreportperiod, "max"(f.month_id) AS lastreportperiod
                                           FROM fsbi_dw_uu.fact_policy f
                                          GROUP BY f.policy_id) d ON a.policy_id = d.policy_id) d
                          WHERE d.lastreportperiod > d.month_id) a
              JOIN fsbi_dw_uu.dim_policy b ON a.policy_id = b.policy_id
         JOIN fsbi_dw_uu.dim_coverage c ON a.coverage_id = c.coverage_id
    JOIN fsbi_dw_uu.dim_product d ON a.product_id = d.product_id
   JOIN fsbi_dw_uu.vdim_company vdc ON a.company_id = vdc.company_id
   JOIN fsbi_dw_uu.dim_month dm ON a.month_id = dm.month_id
   JOIN fsbi_dw_uu.vdim_policystatus p ON a.policystatus_id = p.policystatus_id
   JOIN fsbi_dw_uu.vdim_policyeffectivedate ped ON a.policyeffectivedate_id = ped.policyeffectivedate_id
   JOIN fsbi_dw_uu.vdim_policyexpirationdate pex ON a.policyexpirationdate_id = pex.policyexpirationdate_id
   LEFT JOIN ( SELECT a.policy_id, a.month_id, sum(a.wrtn_prem_amt) AS policy_wrtn_prem_amt, sum(a.term_prem_amt_itd) AS policy_term_prem_amt_itd
   FROM fsbi_dw_uu.fact_policy a
  GROUP BY a.policy_id, a.month_id) pmtdf ON pmtdf.policy_id = b.policy_id AND pmtdf.month_id = a.month_id
  WHERE d.prdt_lob::text <> 'Umbrella'::text
  GROUP BY dm.mon_startdate, dm.mon_monthinyear, dm.mon_monthabbr, dm.mon_year, dm.mon_reportperiod, b.pol_masterstate, 
CASE
    WHEN date_diff('month'::text, ped.poleff_date::timestamp without time zone, pex.polexp_date::timestamp without time zone) <= 6 THEN '6 Months'::text
    ELSE '1 Year'::text
END, 
CASE
    WHEN d.prdt_lob::text = 'Dwelling'::text THEN 'LandLord'::text
    WHEN d.prdt_lob::text = 'PersonalAuto'::text THEN 'Auto'::text
    WHEN d.prdt_lob::text = 'Homeowners'::text THEN 'Homeowners'::text
    WHEN d.prdt_lob::text = 'BusinessOwner'::text OR d.prdt_lob::text = 'CommercialFire'::text OR d.prdt_lob::text = 'CommercialUmbrella'::text THEN 'Commercial'::text
    ELSE 'Other'::text
END) s2 ON s2.mon_year = (s1.mon_year - 1) AND s2.state::text = s1.state::text AND s2.company::text = s1.company::text AND s2.lob = s1.lob AND s2.term = s1.term AND s2.mon_monthinyear = 12) uu_data
   LEFT JOIN ( SELECT to_date(
                CASE
                    WHEN budgetforecast_20230208.pln_month < 10 THEN '0'::text
                    ELSE ''::text
                END + budgetforecast_20230208.pln_month::character varying::text + '-01-'::text + budgetforecast_20230208.pln_year::character varying::text, 'mm-dd-yyyy'::text) AS pln_startdate, budgetforecast_20230208.pln_year::character varying::text + 
                CASE
                    WHEN budgetforecast_20230208.pln_month < 10 THEN '0'::text
                    ELSE ''::text
                END + budgetforecast_20230208.pln_month::character varying::text AS pln_reportperiod, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_monthabbr, budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, budgetforecast_20230208.pln_wp, budgetforecast_20230208.pln_new_wp, budgetforecast_20230208.pln_renewed_wp, budgetforecast_20230208.pln_new_polcnt, budgetforecast_20230208.pln_renewed_polcnt, budgetforecast_20230208.pln_pif, budgetforecast_20230208.pln_year_issue, sum(budgetforecast_20230208.pln_wp)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_wp, sum(budgetforecast_20230208.pln_new_wp)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_new_wp, sum(budgetforecast_20230208.pln_renewed_wp)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_renewed_wp, sum(budgetforecast_20230208.pln_new_polcnt)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_new_polcnt, sum(budgetforecast_20230208.pln_renewed_polcnt)
          OVER( 
          PARTITION BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ORDER BY budgetforecast_20230208.pln_year, budgetforecast_20230208.pln_month, budgetforecast_20230208.pln_state, budgetforecast_20230208.pln_company, budgetforecast_20230208.pln_lob, budgetforecast_20230208.pln_term, 22
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pln_ytd_renewed_polcnt, 'Budget'::text AS pln_type
           FROM reporting.budgetforecast_20230208
          WHERE budgetforecast_20230208.business_source::text = 'UU'::text) p ON uu_data.mon_monthinyear = p.pln_month AND uu_data.mon_year = p.pln_year AND uu_data.state::text = p.pln_state::text AND uu_data.company::text = p.pln_company::text AND uu_data.lob = p.pln_lob::text AND uu_data.term = p.pln_term::text;

COMMENT ON VIEW reporting.vexecprodmonitor_main IS 'Results Commitee Dashboards. Business Owner: Wendy Huang';


-- reporting.vmeris_claims_quarterly_snapshots source

create or replace view reporting.vmeris_claims_quarterly_snapshots as 
select 
data.*
from external_data_pricing.vmeris_claims_ia data
join reporting.veris_quarterly_latest_snapshots f
on data.quarter_id=f.quarter_id
and data.snapshot_id=f.snapshot_id
and f.tablename='vmeris_claims_ia'
with no schema binding;

COMMENT ON VIEW reporting.vmeris_claims_quarterly_snapshots IS 'The view can be used instead of the original table to get data only from the latest snapshot per quarter. Only quarter ID is needed to get the data.';


-- reporting.vmeris_policies_quarterly_snapshots source

create or replace view reporting.vmeris_policies_quarterly_snapshots as 
select 
data.*
from external_data_pricing.vmeris_policies_ia data
join reporting.veris_quarterly_latest_snapshots f
on data.quarter_id=f.quarter_id
and data.snapshot_id=f.snapshot_id
and f.tablename='vmeris_policies_ia'
with no schema binding;

COMMENT ON VIEW reporting.vmeris_policies_quarterly_snapshots IS 'The view can be used instead of the original table to get data only from the latest snapshot per quarter. Only quarter ID is needed to get the data.';


-- reporting.vppd_claims_details source

CREATE OR REPLACE VIEW reporting.vppd_claims_details
AS SELECT DISTINCT "data".month_id, "data".policy_state, "data".carrier, "data".company, "data".policyneworrenewal, 
        CASE
            WHEN config_product.subproduct::text = 'All'::text THEN 
            CASE
                WHEN config_product.product::text = 'Commercial'::text THEN 'Commercial'::character varying
                WHEN config_product.product::text = 'PersonalAuto'::text THEN 'Auto'::character varying
                WHEN config_product.product::text = 'Homeowners'::text THEN 'Home'::character varying
                WHEN config_product.product::text = 'Dwelling'::text THEN 'DF'::character varying
                ELSE config_product.product
            END::text
            ELSE 
            CASE
                WHEN config_product.subproduct::text = 'AL'::text THEN 'Auto Liability'::text
                WHEN config_product.subproduct::text = 'ALOTHER'::text THEN 'Auto Liability Ex BI'::text
                WHEN config_product.subproduct::text = 'ALBI'::text THEN 'Auto BI'::text
                WHEN config_product.subproduct::text = 'APD'::text THEN 'Auto PD'::text
                WHEN config_product.subproduct::text = 'DL'::text THEN 'DF Liability'::text
                WHEN config_product.subproduct::text = 'HL'::text THEN 'Home Liability'::text
                ELSE NULL::text
            END
        END AS ppd_product, config_product.product, config_product.subproduct, 
        CASE
            WHEN "data".cat_flg::text = 'Yes'::text THEN 'Cat'::text
            ELSE 'Non Cat'::text
        END AS cat_flg, COALESCE("data".perilgroup, 'Empty'::character varying) AS perilgroup, "data".claim_number, "policy".policynumber, "data".rag, "data".feature_type, "data".feature_map, "data".claimant, claim_loss.losscausecd, claim_loss.sublosscausecd, claim_loss.dateofloss, claim_loss.datereported, claim_loss.description, "data".incurred, "data".cumulative_total_reserve, "data".feat_reported_count_current_month, "data".feat_reported_count_prev_month, 
        CASE
            WHEN "data".feat_reported_count_current_month = 1 AND "data".feat_reported_count_prev_month = 1 THEN 'Reported in prior months'::text
            WHEN "data".feat_reported_count_current_month = 0 AND "data".feat_reported_count_prev_month = 0 THEN 'Reported in prior months'::text
            WHEN "data".feat_reported_count_current_month = 1 AND "data".feat_reported_count_prev_month = 0 THEN 'Reported in current month'::text
            WHEN "data".feat_reported_count_current_month = 0 AND "data".feat_reported_count_prev_month = 1 THEN 'Closed No-Pay in current month'::text
            ELSE NULL::text
        END AS isreported, 
        CASE
            WHEN "data".isopen > 0 THEN 'Yes'::text
            ELSE 'No'::text
        END AS isopen, 
        CASE
            WHEN "data".islargeloss > 0 THEN 'Yes'::text
            ELSE 'No'::text
        END AS islargeloss, "data".largeloss_incurred, 
        CASE
            WHEN a.claim_number IS NULL THEN 'No'::text
            ELSE 'Yes'::text
        END AS addedtolargelosses, 
        CASE
            WHEN r.claim_number IS NULL THEN 'No'::text
            ELSE 'Yes'::text
        END AS removedfromlargelosses, "data".loss_incurred, "data".alae_incurred, "data".loss_alae_incurred, "data".cumulative_loss_incurred, "data".cumulative_alae_incurred, "data".cumulative_loss_alae_incurred, "data".total_reserve
   FROM ( SELECT DISTINCT ppd_claims.month_id, ppd_claims.policy_state, ppd_claims.carrier, ppd_claims.company, ppd_claims.policyneworrenewal, ppd_claims.cat_flg, ppd_claims.perilgroup, ppd_claims.rag, ppd_claims.feature_type, ppd_claims.feature_map, ppd_claims.claim_number, ppd_claims.claimant, ppd_claims.feat_total_incurred_loss AS incurred, ppd_claims.feat_cumulative_total_reserve AS cumulative_total_reserve, COALESCE(ppd_claims.feat_reported_count, 0) AS feat_reported_count_current_month, COALESCE(lead(ppd_claims.feat_reported_count)
          OVER( 
          PARTITION BY ppd_claims.policy_state, ppd_claims.carrier, ppd_claims.policyneworrenewal, ppd_claims.company, ppd_claims.product, ppd_claims.claim_number, ppd_claims.claimant, ppd_claims.rag, ppd_claims.cat_flg, ppd_claims.perilgroup, ppd_claims.feature_type, ppd_claims.feature_map
          ORDER BY ppd_claims.month_id DESC), 0) AS feat_reported_count_prev_month, COALESCE(ppd_claims.feat_reported_count, 0) - COALESCE(lead(ppd_claims.feat_reported_count)
          OVER( 
          PARTITION BY ppd_claims.policy_state, ppd_claims.carrier, ppd_claims.policyneworrenewal, ppd_claims.company, ppd_claims.product, ppd_claims.claim_number, ppd_claims.claimant, ppd_claims.rag, ppd_claims.cat_flg, ppd_claims.perilgroup, ppd_claims.feature_type, ppd_claims.feature_map
          ORDER BY ppd_claims.month_id DESC), 0) AS isreported, ppd_claims.feat_open_count AS isopen, ppd_claims.feat_reported_count_100k AS islargeloss, ppd_claims.feat_capped_cumulative_loss_incurred_100k + ppd_claims.feat_capped_cumulative_alae_incurred_100k - ppd_claims.feat_capped_cumulative_salsub_received_100k AS largeloss_incurred, ppd_claims.feat_loss_incurred AS loss_incurred, ppd_claims.feat_alae_incurred AS alae_incurred, ppd_claims.feat_loss_incurred + ppd_claims.feat_alae_incurred AS loss_alae_incurred, ppd_claims.feat_cumulative_loss_incurred AS cumulative_loss_incurred, ppd_claims.feat_cumulative_alae_incurred AS cumulative_alae_incurred, ppd_claims.feat_cumulative_loss_incurred + ppd_claims.feat_cumulative_alae_incurred AS cumulative_loss_alae_incurred, ppd_claims.feat_total_reserve AS total_reserve
           FROM reporting.ppd_claims) "data"
   JOIN ( SELECT DISTINCT vppd_loss_product_mapping.product, vppd_loss_product_mapping.subproduct, vppd_loss_product_mapping.rag, vppd_loss_product_mapping.feature_type, vppd_loss_product_mapping.feature_map
           FROM reporting.vppd_loss_product_mapping
          WHERE upper(vppd_loss_product_mapping.feature::text) !~~ '%FEE%'::text) config_product ON "data".rag::text = config_product.rag::text AND "data".feature_type::text = config_product.feature_type::text AND "data".feature_map::text = config_product.feature_map::text
   LEFT JOIN ( SELECT DISTINCT c.clm_claimnumber AS claim_number, "max"(cle.losscausecd::text) AS losscausecd, "max"("replace"(cle.sublosscausecd::text, 'No'::text, ''::text)) AS sublosscausecd, "max"(c.dateofloss) AS dateofloss, "max"(c.datereported) AS datereported, "max"(cle.description::text) AS description
      FROM fsbi_dw_spinn.dim_claim c
   JOIN fsbi_dw_spinn.dim_claimextension cle ON c.clm_uniqueid::text = cle.claim_uniqueid::text
  GROUP BY c.clm_claimnumber) claim_loss ON "data".claim_number::text = claim_loss.claim_number::text
   LEFT JOIN ( SELECT DISTINCT vmfact_claimtransaction_blended.claim_number AS claimnumber, vmfact_claimtransaction_blended.policy_number AS policynumber
   FROM vmfact_claimtransaction_blended) "policy" ON "policy".claimnumber::text = "data".claim_number::text
   LEFT JOIN ( SELECT DISTINCT ppd_claims.month_id, ppd_claims.claimant, ppd_claims.feature_map, ppd_claims.claim_number
   FROM reporting.ppd_claims
  WHERE ppd_claims.feat_reported_count_100k > 0
EXCEPT 
 SELECT DISTINCT to_char(add_months(m.mon_startdate::timestamp without time zone, 1::bigint), 'YYYYMM'::text)::integer AS month_id, f.claimant, f.feature_map, f.claim_number
   FROM reporting.ppd_claims f
   JOIN fsbi_dw_spinn.dim_month m ON f.month_id = m.month_id
  WHERE f.feat_reported_count_100k > 0) a ON a.month_id = "data".month_id AND a.claimant::text = "data".claimant::text AND a.feature_map::text = "data".feature_map::text AND a.claim_number::text = "data".claim_number::text
   LEFT JOIN ( SELECT DISTINCT to_char(add_months(m.mon_startdate::timestamp without time zone, 1::bigint), 'YYYYMM'::text)::integer AS month_id, f.claimant, f.feature_map, f.claim_number
   FROM reporting.ppd_claims f
   JOIN fsbi_dw_spinn.dim_month m ON f.month_id = m.month_id
  WHERE f.feat_reported_count_100k > 0
EXCEPT 
 SELECT DISTINCT ppd_claims.month_id, ppd_claims.claimant, ppd_claims.feature_map, ppd_claims.claim_number
   FROM reporting.ppd_claims
  WHERE ppd_claims.feat_reported_count_100k > 0) r ON r.month_id = "data".month_id AND r.claimant::text = "data".claimant::text AND r.feature_map::text = "data".feature_map::text AND r.claim_number::text = "data".claim_number::text;

COMMENT ON VIEW reporting.vppd_claims_details IS 'Product performance Dashboard claims details view. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';


-- reporting.vppd_loss_product_mapping source

CREATE OR REPLACE VIEW reporting.vppd_loss_product_mapping
AS (((((( SELECT DISTINCT 'PersonalAuto'::character varying AS product, 'APD'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.feature_type::text = 'P'::character varying::text AND config_data.rag::text = 'APD'::character varying::text
UNION ALL 
 SELECT DISTINCT 'PersonalAuto'::character varying AS product, 'ALOTHER'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.feature_type::text = 'L'::character varying::text AND config_data.feature_map::text <> 'BI'::character varying::text AND config_data.rag::text = 'AL'::character varying::text)
UNION ALL 
 SELECT DISTINCT 'PersonalAuto'::character varying AS product, 'AL'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.feature_type::text = 'L'::character varying::text AND config_data.rag::text = 'AL'::character varying::text)
UNION ALL 
 SELECT DISTINCT 'PersonalAuto'::character varying AS product, 'ALBI'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.feature_map::text = 'BI'::character varying::text)
UNION ALL 
 SELECT DISTINCT 'Homeowners'::character varying AS product, 'HL'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.feature_type::text = 'L'::character varying::text AND config_data.rag::text = 'HO'::character varying::text)
UNION ALL 
 SELECT DISTINCT 'Dwelling'::character varying AS product, 'DL'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.feature_type::text = 'L'::character varying::text AND config_data.rag::text = 'SP'::character varying::text)
UNION ALL 
 SELECT DISTINCT 'All Products'::character varying AS product, 'All'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.rag IS NOT NULL)
UNION ALL 
 SELECT DISTINCT 
        CASE
            WHEN config_data.rag::text = 'AL'::character varying::text OR config_data.rag::text = 'APD'::character varying::text THEN 'PersonalAuto'::character varying
            WHEN config_data.rag::text = 'HO'::character varying::text THEN 'Homeowners'::character varying
            WHEN config_data.rag::text = 'SP'::character varying::text THEN 'Dwelling'::character varying
            WHEN config_data.rag::text = 'CM'::character varying::text THEN 'Commercial'::character varying
            ELSE NULL::character varying
        END AS product, 'All'::character varying AS subproduct, config_data.feature_type, config_data.feature_map, config_data.standard_feature, config_data.feature, config_data.rag
   FROM (( SELECT DISTINCT covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1)::character varying AS feature_type, covx.covx_code AS standard_feature, c.cov_code AS feature, COALESCE(covx.act_map, '~'::character varying) AS feature_map
           FROM dim_coverageextension covx
      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
UNION 
         SELECT DISTINCT vmfact_claimtransaction_blended.aslob, vmfact_claimtransaction_blended.rag, "left"(vmfact_claimtransaction_blended.feature_type::text, 1)::character varying AS feature_type, vmfact_claimtransaction_blended.feature AS standard_feature, vmfact_claimtransaction_blended.feature, '~'::character varying AS feature_map
           FROM vmfact_claimtransaction_blended
          WHERE vmfact_claimtransaction_blended.feature::text = '~'::character varying::text)
UNION 
         SELECT DISTINCT ppd_feature_map_wins.aslob, ppd_feature_map_wins.rag, ppd_feature_map_wins.feature_type, ppd_feature_map_wins.feature AS standard_feature, ppd_feature_map_wins.feature, ppd_feature_map_wins.feature_map
           FROM fsbi_dw_wins.ppd_feature_map_wins) config_data
  WHERE config_data.rag IS NOT NULL;


-- reporting.vppd_losses source

CREATE OR REPLACE VIEW reporting.vppd_losses
AS SELECT to_date(ppd_losses.month_id::character varying::text + '01'::text, 'yyyymmdd'::text) AS reportperiod, ppd_losses.product, ppd_losses.subproduct, ppd_losses.month_id, ppd_losses.policy_state, rtrim(ppd_losses.carrier::text) AS carrier, ppd_losses.company, ppd_losses.policyneworrenewal, 
        CASE
            WHEN ppd_losses.cat_flg::text = 'Yes'::text THEN 'Cat'::text
            ELSE 'Non Cat'::text
        END AS cat_flg, ppd_losses.perilgroup, ppd_losses.total_incurred, ppd_losses.total_incurred_capped_100k, ppd_losses.reported_count, ppd_losses.open_count, ppd_losses.reported_count_100k, ppd_losses.reported_count_100k_month, ppd_losses.total_incurred_100k_month, ppd_losses.reported_count_month
   FROM reporting.ppd_losses;


-- reporting.vppd_policies_summaries source

CREATE OR REPLACE VIEW reporting.vppd_policies_summaries
AS SELECT to_date(ppd_policies_summaries.month_id::character varying::text + '01'::text, 'yyyymmdd'::text) AS reportperiod, ppd_policies_summaries.product, ppd_policies_summaries.subproduct, ppd_policies_summaries.month_id, ppd_policies_summaries.policy_state, ppd_policies_summaries.carrier, ppd_policies_summaries.company, ppd_policies_summaries.policyneworrenewal, ppd_policies_summaries.ep, ppd_policies_summaries.ee, ppd_policies_summaries.pif
   FROM reporting.ppd_policies_summaries;


-- reporting.vppd_premium_product_mapping source

CREATE OR REPLACE VIEW reporting.vppd_premium_product_mapping
AS SELECT DISTINCT derived_table1.prdt_lob, derived_table1.product, derived_table1.subproduct, derived_table1.coverage_type, derived_table1.coverage_map, derived_table1.standard_coverage, derived_table1.coverage, derived_table1.rag
   FROM ( SELECT product_data.prdt_lob, product_data.product, product_data.subproduct, product_data.coverage_type, product_data.coverage_map, product_data.standard_coverage, product_data.coverage, product_data.rag
           FROM (((((( SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'AL'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_type = 'L'::character varying::text AND config_data.rag::text = 'AL'::character varying::text
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'ALBI'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_map::text = 'BI'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'ALOTHER'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_type = 'L'::character varying::text AND config_data.coverage_map::text <> 'BI'::character varying::text AND config_data.rag::text = 'AL'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'APD'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_type = 'P'::character varying::text AND config_data.rag::text = 'APD'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'Dwelling'::character varying AS product, 'DL'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.rag::text = 'SP'::character varying::text AND config_data.prdt_lob::text = 'Dwelling'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'Homeowners'::character varying AS product, 'HL'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE (config_data.rag::text = 'HO'::character varying::text OR config_data.rag::text = 'SP'::character varying::text) AND config_data.prdt_lob::text = 'Homeowners'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 
                        CASE
                            WHEN config_data.rag::text = 'AL'::character varying::text OR config_data.rag::text = 'APD'::character varying::text THEN 'PersonalAuto'::character varying
                            WHEN (config_data.rag::text = 'HO'::character varying::text OR config_data.rag::text = 'SP'::character varying::text) AND config_data.prdt_lob::text = 'Homeowners'::character varying::text THEN 'Homeowners'::character varying
                            WHEN config_data.rag::text = 'SP'::character varying::text AND config_data.prdt_lob::text = 'Dwelling'::character varying::text THEN 'Dwelling'::character varying
                            WHEN config_data.rag::text = 'CM'::character varying::text THEN 'Commercial'::character varying
                            ELSE NULL::character varying
                        END AS product, 'All'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data) product_data
UNION ALL 
         SELECT DISTINCT product_data.prdt_lob, 'All Products'::character varying AS product, 'All'::character varying AS subproduct, product_data.coverage_type, product_data.coverage_map, product_data.standard_coverage, product_data.coverage, product_data.rag
           FROM (((((( SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'AL'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_type = 'L'::character varying::text AND config_data.rag::text = 'AL'::character varying::text
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'ALBI'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_map::text = 'BI'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'ALOTHER'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_type = 'L'::character varying::text AND config_data.coverage_map::text <> 'BI'::character varying::text AND config_data.rag::text = 'AL'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'PersonalAuto'::character varying AS product, 'APD'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.coverage_type = 'P'::character varying::text AND config_data.rag::text = 'APD'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'Dwelling'::character varying AS product, 'DL'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE config_data.rag::text = 'SP'::character varying::text AND config_data.prdt_lob::text = 'Dwelling'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 'Homeowners'::character varying AS product, 'HL'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data
                  WHERE (config_data.rag::text = 'HO'::character varying::text OR config_data.rag::text = 'SP'::character varying::text) AND config_data.prdt_lob::text = 'Homeowners'::character varying::text)
        UNION ALL 
                 SELECT DISTINCT config_data.prdt_lob, 
                        CASE
                            WHEN config_data.rag::text = 'AL'::character varying::text OR config_data.rag::text = 'APD'::character varying::text THEN 'PersonalAuto'::character varying
                            WHEN (config_data.rag::text = 'HO'::character varying::text OR config_data.rag::text = 'SP'::character varying::text) AND config_data.prdt_lob::text = 'Homeowners'::character varying::text THEN 'Homeowners'::character varying
                            WHEN config_data.rag::text = 'SP'::character varying::text AND config_data.prdt_lob::text = 'Dwelling'::character varying::text THEN 'Dwelling'::character varying
                            WHEN config_data.rag::text = 'CM'::character varying::text THEN 'Commercial'::character varying
                            ELSE NULL::character varying
                        END AS product, 'All'::character varying AS subproduct, config_data.coverage_type::character varying AS coverage_type, config_data.coverage_map, config_data.standard_coverage, config_data.coverage, config_data.rag
                   FROM ( SELECT DISTINCT p.prdt_lob, covx.covx_asl AS aslob, covx.act_rag AS rag, "left"(covx.coveragetype::text, 1) AS coverage_type, covx.covx_code AS standard_coverage, c.cov_code AS coverage, COALESCE(covx.act_map, '~'::character varying) AS coverage_map
                           FROM dim_coverageextension covx
                      JOIN fsbi_dw_spinn.dim_coverage c ON covx.coverage_id = c.coverage_id
                 JOIN fsbi_dw_spinn.fact_policytransaction f ON f.coverage_id = c.coverage_id
            JOIN fsbi_dw_spinn.dim_product p ON f.product_id = p.product_id
           WHERE upper(c.cov_code::text) !~~ '%FEE%'::character varying::text) config_data) product_data
          WHERE product_data.subproduct::text = 'All'::character varying::text) derived_table1;


-- reporting.vwt_quote_auto source

CREATE OR REPLACE VIEW reporting.vwt_quote_auto
AS SELECT qa.quote_auto_key, qa.linecd, qa.subtypecd, qa.systemid, qa.cmmcontainer, qa.carriergroupcd, qa.carriercd, qa.companycd, qa.subtypecd_bp, qa.controllingstatecd, qa.quotenumber, qa.originalapplicationref, qa.id, qa.policynumber, qa.policyversion, qa.effectivedt, qa.expirationdt, qa.ratedind, qa.renewaltermcd, qa.writtenpremiumamt, qa.programind, qa.batchquotesourcecd, qa.affinitygroupcd, qa.applicationnumber, qa.bridged, qa.subtypecd_qi, qa.uniqueid, qa.adddt, qa.addtm, qa.adduser, qa.agent, qa.addr, qa.city, qa.zipcode, qa.mailingstatecd, qa.primaryinsured, qa.primaryphonenumber, qa.primaryphonename, qa.customernumber, qa.birthdt, qa.uniquecustomerkey, qa.uniquecustomerkey_app, qa.updatetimestamp_app, qa.updatedt, qa.updatetm, qa.updateuser, qa.customerref, qa.policyref, qa.changeinforef, qa.typecd, qa.status, qa.description, qa.vehidentificationnumber, qa.vehnumber, qa.comprehensiveded, qa.collisionded, qa.bilimit, qa.pdlimit, qa.umbilimit, qa.medpaylimit, qa.mpd1, qa.mpd2, qa.multicar, qa.fulltermamt, qa.finalpremiumamt, qa.insertdate, qa.insertby, qa.updatedate, qa.updateby, qa.firsttran, qa.agency_group, qa.dba, qa.territory, qa.departmentcd, sp.firstpayment
   FROM fsbi_dw_spinn.quote_auto qa
   LEFT JOIN ( SELECT p.pol_policynumber AS policynumber, p.pol_effectivedate AS effectivedt, lpad(p.pol_policynumbersuffix::text, 3, 0::text) AS policyversion, 
                CASE
                    WHEN pe.firstpayment = '1900-01-01'::date THEN NULL::date
                    ELSE pe.firstpayment
                END AS firstpayment, 
                CASE
                    WHEN pe.lastpayment = '1900-01-01'::date THEN NULL::date
                    ELSE pe.lastpayment
                END AS lastpayment, pe.balanceamt, pe.paidamt
           FROM fsbi_dw_spinn.dim_policy p
      JOIN fsbi_dw_spinn.dim_policyextension pe ON p.policy_id = pe.policy_id) sp ON sp.policynumber::text = qa.policynumber AND sp.effectivedt = qa.effectivedt;

COMMENT ON VIEW reporting.vwt_quote_auto IS 'This is the data source for the "Auto Portfolio Monitoring dashboards.';


-- reporting.vwt_quote_building source

CREATE OR REPLACE VIEW reporting.vwt_quote_building
AS SELECT qb.linecd, qb.subtypecd, qb.systemid, qb.cmmcontainer, qb.carriergroupcd, qb.carriercd, qb.companycd, qb.subtypecd_bp, qb.controllingstatecd, qb.quotenumber, qb.originalapplicationref, qb.id, qb.policynumber, qb.policyversion, qb.effectivedt, qb.expirationdt, qb.ratedind, qb.renewaltermcd, qb.writtenpremiumamt, qb.programind, qb.batchquotesourcecd, qb.affinitygroupcd, qb.applicationnumber, qb.bridged, qb.subtypecd_qi, qb.uniqueid, qb.adddt, qb.addtm, qb.adduser, qb.updatedt, qb.updatetm, qb.updateuser, qb.agent, qb.addr, qb.city, qb.zipcode, qb.mailingstatecd, qb.primaryinsured, qb.primaryphonenumber, qb.primaryphonename, qb.customernumber, qb.birthdt, qb.uniquecustomerkey, qb.uniquecustomerkey_app, qb.updatetimestamp_app, qb.customerref, qb.policyref, qb.changeinforef, qb.typecd, qb.status, qb.description, qb.covalimit, qb.sqft, qb.yearbuilt, qb.roofcd, qb.deductible, qb.protectionclass, qb.waterded, qb.stories, qb.mpd1, qb.mpd2, qb.multicar, qb.insertdate, qb.insertby, qb.updatedate, qb.updateby, qb.firsttran, qb.safeguardplusind, qb.ratingtier, qb.waterriskscore, qb.building_zipcode, qb.agency_group, qb.dba, qb.territory, qb.departmentcd, qb.producer_uniqueid, sp.firstpayment, 
        CASE
            WHEN qb.linecd::text = 'Home'::text AND qb.safeguardplusind = 'Yes'::text THEN 'Plus'::text
            WHEN qb.linecd::text = 'Dwelling'::text THEN qb.ratingtier
            ELSE 'Basic'::text
        END AS packagelevel
   FROM fsbi_dw_spinn.quote_building qb
   LEFT JOIN ( SELECT p.pol_policynumber AS policynumber, p.pol_effectivedate AS effectivedt, lpad(p.pol_policynumbersuffix::text, 3, 0::text) AS policyversion, 
                CASE
                    WHEN pe.firstpayment = '1900-01-01'::date THEN NULL::date
                    ELSE pe.firstpayment
                END AS firstpayment, 
                CASE
                    WHEN pe.lastpayment = '1900-01-01'::date THEN NULL::date
                    ELSE pe.lastpayment
                END AS lastpayment, pe.balanceamt, pe.paidamt
           FROM fsbi_dw_spinn.dim_policy p
      JOIN fsbi_dw_spinn.dim_policyextension pe ON p.policy_id = pe.policy_id) sp ON sp.policynumber::text = qb.policynumber AND sp.effectivedt = qb.effectivedt;

COMMENT ON VIEW reporting.vwt_quote_building IS 'It`s a source view for some product managment dashboards';


-- reporting.vwt_quote_property source

CREATE OR REPLACE VIEW reporting.vwt_quote_property
AS SELECT DISTINCT a.application_id AS applicationref, 
        CASE
            WHEN "left"(a.applicationnumber::text, 2) = 'AP'::text THEN a.applicationnumber
            ELSE NULL::character varying
        END AS applicationnumber, a.approved_policynumber AS policynumber, a.statecd AS controllingstatecd, "replace"(ltrim(rtrim(split_part(a.company_uniqueid::text, '-'::text, 1))), '~'::text, 'UNK'::text) AS carriercd, "replace"(ltrim(rtrim(split_part(a.company_uniqueid::text, '-'::text, 2))), '~'::text, 'UNK'::text) AS companycd, "replace"(ia.state::text, '~'::text, ''::text) AS mailingstatecd, pr.prdt_lob AS lob, 
        CASE
            WHEN a.quotenumber::text = '~'::text THEN NULL::character varying
            ELSE a.quotenumber
        END AS quotenumber, 
        CASE
            WHEN pr.altsubtypecd::text ~~* '%HOMEGUARD%'::text THEN pr.altsubtypecd
            ELSE a.subtypecd
        END AS subtypecd, a.policyformcode AS formtype, a.batchquotesourcecd AS rater, COALESCE(ag.agency_group, 'Unknown'::character varying) AS agencygroup, ag.territory, a.transactioncd, 
        CASE
            WHEN a.bc_quoteinfo_typecd::text = 'Application'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS bridged, a.affinitygroupcd, a.carriergroupcd, a.effectivedt AS effectivedate, a.bc_application_updatetimestamp AS updatedt, to_date(to_char(a.bc_quoteinfo_updatedt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) AS updatedt_qb, a.programind, 
        CASE
            WHEN a.approved_policybookdt = '1900-01-01'::date THEN NULL::date
            ELSE a.approved_policybookdt
        END AS firsttran_qb, ui.departmentcd, 
        CASE
            WHEN a.payplancd::text ~~* '%insured%direct%full%'::text THEN 'Full'::character varying
            WHEN a.payplancd::text ~~* '%third%party%'::text THEN 'Mortgagee Full Pay'::character varying
            WHEN a.payplancd::text ~ '[0-9]'::text AND regexp_count(a.payplancd::text, '\\d+'::text) = 1 OR a.payplancd::text ~~* '%form%'::text AND regexp_count(a.payplancd::text, '\\d+'::text) = 2 THEN 
            CASE
                WHEN a.payplancd::text ~~* '%auto%'::text THEN btrim(regexp_substr(a.payplancd::text, '\\d+'::text)) + ' '::text + 'Auto Pay'::text
                ELSE btrim(regexp_substr(a.payplancd::text, '\\d+'::text)) + ' '::text + 'Pay Plan'::text
            END::character varying
            WHEN a.payplancd::text ~ '[0-9]'::text AND regexp_count(a.payplancd::text, '\\d+'::text) >= 2 AND a.payplancd::text !~~* '%form%'::text THEN 
            CASE
                WHEN a.payplancd::text ~~* '%auto%'::text THEN btrim(regexp_substr(a.payplancd::text, '\\d+'::text, 1, 2)) + ' '::text + 'Auto Pay'::text
                ELSE btrim(regexp_substr(a.payplancd::text, '\\d+'::text, 1, 2)) + ' '::text + 'Pay Plan'::text
            END::character varying
            WHEN a.payplancd::text = '~'::text THEN 'N/A'::character varying
            ELSE a.payplancd
        END AS paymenttype, "replace"(
        CASE
            WHEN ia.telephone::text = '~'::text THEN ia.mobile
            ELSE ia.telephone
        END::text, '~'::text, ''::text) + '|'::text + "substring"(ia.postalcode::text, 1, 5) + '|'::text + to_char(
        CASE
            WHEN c.dob = '1900-01-01'::date THEN '1899-11-30'::date
            ELSE c.dob
        END::timestamp without time zone, 'yyyy-mm-dd'::text) AS uniquecustomerkey, 
        CASE
            WHEN a.bc_quoteinfo_typecd::text = 'Application'::text THEN 
            CASE
                WHEN ia.telephone::text = '~'::text THEN ia.mobile
                ELSE ia.telephone
            END::text + '|'::text + ia.postalcode::text + '|'::text + to_char(c.dob::timestamp without time zone, 'yyyy-mm-dd'::text)
            ELSE NULL::text
        END AS uniquecustomerkey_app, "replace"(ia.postalcode::text, '~'::text, ''::text) AS zipcode, "replace"(b.postalcode::text, '~'::text, ''::text) AS buildingzipcode, a.bc_basicpolicy_writtenpremiumamt AS writtenpremiumamt, COALESCE(b.allperilded, '~'::character varying) AS allperildeductible, COALESCE(upper(b.burglaryalarmtype::text), '~'::text) AS burglaryalarmtype, COALESCE(b.sqft, 0) AS sqft, COALESCE(b.roofcd, '~'::character varying) AS roofcd, 
        CASE
            WHEN upper(pr.prdt_lob::text) = 'DWELLING'::text THEN b.ratingtier
            WHEN upper(pr.prdt_lob::text) = 'HOMEOWNERS'::text AND b.safeguardplusind::text = 'Yes'::text THEN 'Plus'::character varying
            ELSE 'Basic'::character varying
        END AS packagelevel, COALESCE(b.waterded, '~'::character varying) AS waterdeductible, COALESCE(b.censusblock, '~'::character varying) AS censusblock, COALESCE(b.constructioncd, '~'::character varying) AS constructiontype, COALESCE(upper(b.county::text), '~'::text) AS county, COALESCE(b.firealarmtype, '~'::character varying) AS firealarmtype, COALESCE(b.reportedfirehazardscore, '~'::character varying) AS fireline, COALESCE(b.homegardcreditind, '~'::character varying) AS homegardcredit, COALESCE(b.neighborhoodcrimewatchind, '~'::character varying) AS neighborhoodcrimewatch, COALESCE(b.numberoffamilies, 0) AS numberoffamilies, COALESCE(b.numlosses, 0) AS numberoflosses, COALESCE(b.owneroccupiedunits, 0) AS owneroccupiedunits, COALESCE(b.poolind, '~'::character varying) AS poolindicator, COALESCE(b.protectionclass, '~'::character varying) AS protectionclass, COALESCE(b.replacementcostdwellingind, '~'::character varying) AS replacementcost, COALESCE(b.stories, 0) AS stories, COALESCE(b.tenantoccupiedunits, 0) AS tenantoccupiedunits, COALESCE(b.covaddrr_secondaryresidence, '~'::character varying) AS secondaryresidence, COALESCE(b.usagetype, '~'::character varying) AS usagetype, COALESCE(b.wuiclass, '~'::character varying) AS wuiclass, COALESCE(b.waterriskscore, 0) AS waterriskscore, COALESCE(b.yearbuilt, 0) AS yearbuilt, COALESCE(coverages.backupofsewersanddrains, 0::numeric) AS backupofsewersanddrains, COALESCE(coverages.bedbugcoverage, 0::numeric) AS bedbugcoverage, COALESCE(coverages.buildingordinanceorlaw, 0::numeric) AS buildingordinanceorlaw, COALESCE(coverages.buildingadditionsandalterationsincreasedlimit, 0::numeric) AS buildingadditionsandalterationsincreasedlimit, COALESCE(coverages.contentsopenperils, 'No'::text) AS contentsopenperils, COALESCE(coverages.courseofconstruction, 0::numeric) AS courseofconstruction, COALESCE(coverages.cova, b.covalimit::numeric, 0::numeric) AS cova, COALESCE(coverages.covb, b.covblimit::numeric, 0::numeric) AS covb, COALESCE(coverages.covc, b.covclimit::numeric, 0::numeric) AS covc, COALESCE(coverages.covd, b.covdlimit::numeric, 0::numeric) AS covd, COALESCE(coverages.cove, b.covelimit::numeric, 0::numeric) AS cove, COALESCE(coverages.covf, b.covflimit::numeric, 0::numeric) AS covf, COALESCE(coverages.equipmentbreakdown, 0::numeric) AS equipmentbreakdown, COALESCE(a.cseemployeediscountind, 'No'::character varying) AS employeediscount, COALESCE(b.expandedreplacementcostind, 'No'::character varying) AS expandedreplacementcost, COALESCE(b.replacementcostdwellingind, 'No'::character varying) AS extendedreplacementcostdwelling, COALESCE(b.functionalreplacementcost, 'No'::character varying) AS functionalreplacementcost, COALESCE(coverages.identityrecoverycoverage, 'No'::text) AS identityrecoverycoverage, COALESCE(coverages.landlordevictionexpensereimbursement, 0::numeric) AS landlordevictionexpensereimbursement, COALESCE(coverages.lossassessment, 0::numeric) AS lossassessment, COALESCE(a.multipolicydiscount, 'No'::character varying) AS multipolicydiscount, COALESCE(coverages.otherstructuresincreasedlimit, 0::numeric) AS otherstructuresincreasedlimit, COALESCE(coverages.occupationdiscount, 'No'::text) AS occupationdiscount, COALESCE(coverages.personalpropertyincreasedlimit, 'No'::text) AS personalpropertyincreasedlimit, COALESCE(coverages.personalinjuryliability, 'No'::text) AS personalinjuryliability, COALESCE(coverages.personalpropertyreplacementcostoption, 'No'::text) AS personalpropertyreplacementcostoption, COALESCE(coverages.protectivedevices, 'No'::text) AS protectivedevices, COALESCE("replace"(b.propertymanager::text, '~'::text, 'No'::text), 'No'::text) AS propertymanagerdiscount, COALESCE("replace"(b.rentersinsurance::text, '~'::text, 'No'::text), 'No'::text) AS rentersinsuranceverificationdiscount, COALESCE(coverages.scheduledpersonalproperty, 'No'::text) AS scheduledpersonalproperty, COALESCE(coverages.serviceline, 0::numeric) AS serviceline, COALESCE(coverages.structuresrentedtoothersresidencepremises, '0'::text) AS structuresrentedtoothersresidencepremises, COALESCE(coverages.seniordiscount, 'No'::text) AS seniordiscount, COALESCE(coverages.theft, 0::numeric) AS theft, COALESCE(coverages.workerscompensation, 'No'::text) AS workerscompensation, COALESCE(coverages.workerscompensationoccasionalemployee, 'No'::text) AS workerscompensationoccasionalemployee
   FROM fsbi_dw_spinn.dim_application a
   JOIN fsbi_dw_spinn.dim_app_insured ia ON a.application_id = ia.application_id
   JOIN fsbi_dw_spinn.dim_customer c ON a.customer_uniqueid::text = c.customer_uniqueid::text
   JOIN fsbi_dw_spinn.vdim_producer_lookup ag ON a.producer_uniqueid::text = ag.prdr_uniqueid::text
   JOIN fsbi_dw_spinn.dim_userinfo ui ON lower(a.bc_quoyeinfo_adduser_uniqueid::text) = lower(ui.userinfo_uniqueid::text)
   JOIN fsbi_dw_spinn.dim_product pr ON a.product_uniqueid::text = pr.product_uniqueid::text
   LEFT JOIN fsbi_dw_spinn.dim_app_building b ON a.application_id = b.application_id
   LEFT JOIN ( SELECT f.application_id, "max"(
        CASE
            WHEN vcm.covx_code::text = 'SEWER'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS backupofsewersanddrains, "max"(
        CASE
            WHEN vcm.covx_code::text = 'BEDBUG'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS bedbugcoverage, "max"(
        CASE
            WHEN vcm.covx_code::text = 'BOLAW'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS buildingordinanceorlaw, "max"(
        CASE
            WHEN vcm.covx_code::text = 'H051ST0'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS buildingadditionsandalterationsincreasedlimit, "max"(
        CASE
            WHEN vcm.covx_code::text = 'COC'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS courseofconstruction, "max"(
        CASE
            WHEN vcm.covx_code::text = 'HO5'::text THEN 'Yes'::text
            ELSE 'No'::text
        END) AS contentsopenperils, "max"(
        CASE
            WHEN vcm.covx_code::text = 'CovA'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS cova, "max"(
        CASE
            WHEN vcm.covx_code::text = 'CovB'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS covb, "max"(
        CASE
            WHEN vcm.covx_code::text = 'CovC'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS covc, "max"(
        CASE
            WHEN vcm.covx_code::text = 'CovD'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS covd, "max"(
        CASE
            WHEN vcm.covx_code::text = 'CovE'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS cove, "max"(
        CASE
            WHEN vcm.covx_code::text = 'MEDPAY'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS covf, "max"(
        CASE
            WHEN vcm.covx_code::text = 'EQPBK'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS equipmentbreakdown, "max"(
        CASE
            WHEN vcm.covx_code::text = 'FRAUD'::text THEN "replace"(dl.cov_limit1::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS identityrecoverycoverage, "max"(
        CASE
            WHEN vcm.covx_code::text = 'OLT'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS landlordevictionexpensereimbursement, "max"(
        CASE
            WHEN vcm.covx_code::text = 'LAC'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS lossassessment, "max"(
        CASE
            WHEN vcm.covx_code::text = 'OccupationDiscount'::text AND f.fulltermamt < 0::numeric(28,6) THEN 'Yes'::text
            ELSE 'No'::text
        END) AS occupationdiscount, "max"(
        CASE
            WHEN vcm.covx_code::text = 'INCB'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS otherstructuresincreasedlimit, "max"(
        CASE
            WHEN vcm.covx_code::text = 'INCC'::text THEN "replace"(dl.cov_limit2::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS personalpropertyincreasedlimit, "max"(
        CASE
            WHEN vcm.covx_code::text = 'PIHOM'::text THEN "replace"(dl.cov_limit1::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS personalinjuryliability, "max"(
        CASE
            WHEN vcm.covx_code::text = 'PPREP'::text THEN 'Yes'::text
            ELSE 'No'::text
        END) AS personalpropertyreplacementcostoption, "max"(
        CASE
            WHEN vcm.covx_code::text = 'PRTDVC'::text THEN 'Yes'::text
            ELSE 'No'::text
        END) AS protectivedevices, "max"(
        CASE
            WHEN vcm.covx_code::text = 'UTLDB'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS serviceline, "max"(
        CASE
            WHEN vcm.covx_code::text = 'SeniorDiscount'::text AND f.fulltermamt < 0::numeric(28,6) THEN 'Yes'::text
            ELSE 'No'::text
        END) AS seniordiscount, "max"(
        CASE
            WHEN vcm.covx_code::text = 'SRORP'::text THEN "replace"(dl.cov_limit1::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS structuresrentedtoothersresidencepremises, "max"(
        CASE
            WHEN vcm.covx_code::text = 'SPP'::text THEN "replace"(dl.cov_limit1::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS scheduledpersonalproperty, "max"(
        CASE
            WHEN vcm.covx_code::text = 'THEFA'::text THEN dl.cov_limit1_value
            ELSE 0::numeric
        END) AS theft, "max"(
        CASE
            WHEN vcm.covx_code::text = 'WCINC'::text AND vcm.covx_description::text = 'Workers Compensation'::text THEN "replace"(dl.cov_limit1::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS workerscompensation, "max"(
        CASE
            WHEN vcm.covx_code::text = 'WCINC'::text AND vcm.covx_description::text = 'Workers Compensation - Occasional Employee'::text THEN "replace"(dl.cov_limit1::text, '~'::text, 'Yes'::text)
            ELSE 'No'::text
        END) AS workerscompensationoccasionalemployee
   FROM fsbi_dw_spinn.fact_application f
   JOIN fsbi_dw_spinn.dim_limit dl ON dl.limit_id = f.limit_id
   JOIN fsbi_dw_spinn.dim_product pr ON f.product_id = pr.product_id
   JOIN fsbi_dw_spinn.dim_application a ON f.application_id = a.application_id
   JOIN vcoverage_mapping vcm ON vcm.cov_code::text = f.coveragecd::text
  WHERE (pr.prdt_lob::text = 'Dwelling'::text OR pr.prdt_lob::text = 'Homeowners'::text) AND a.effectivedt > '2020-01-01'::date
  GROUP BY f.application_id) coverages ON a.application_id = coverages.application_id
  WHERE a.transactioncd::text = 'New Business'::text AND (a.subtypecd::text = 'DF3'::text OR a.subtypecd::text = 'DF6'::text OR a.subtypecd::text = 'FL1-Basic'::text OR a.subtypecd::text = 'FL1-Vacant'::text OR a.subtypecd::text = 'FL2-Broad'::text OR a.subtypecd::text = 'FL3-Special'::text OR a.subtypecd::text = 'Form3'::text OR a.subtypecd::text = 'HO3'::text OR a.subtypecd::text = 'HO4'::text OR a.subtypecd::text = 'HO6'::text);

COMMENT ON VIEW reporting.vwt_quote_property IS 'PM dasboard source. if there is a coverage present and no limit then Yes meaning there is a coverage but Limit unknown 0 WP is not taken into account, just coverage presence. Because in some product 0 WP is a valid value for specific coverahes as well as no limits or deductibles Discounts must have WP less then 0. max is used to have all coverages in one row vs multiple rows in fact_application.';


-- reporting.vwt_quotecounts_agencyperformance source

CREATE OR REPLACE VIEW reporting.vwt_quotecounts_agencyperformance
AS SELECT 
        CASE
            WHEN qa.policynumber <> ''::text THEN qa.policynumber
            ELSE NULL::text
        END::character varying AS policy_number, qa.uniquecustomerkey::character varying AS uniquecustomerkey, dm.month_id, qa.adddt, qa.carriercd::character varying AS carriercd, qa.agent::character varying AS agent, qa.controllingstatecd, 'PersonalAuto' AS lob, 
        CASE
            WHEN "left"(qa.description, 7) = 'Rewrite'::text THEN 'Rewrite'::text
            WHEN "left"(qa.description, 7) = 'New App'::text THEN 'New Application'::text
            WHEN "left"(qa.description, 7) = 'New Quo'::text THEN 'New Quote'::text
            ELSE 'Unknown'::text
        END::character varying AS quote_description
   FROM fsbi_dw_spinn.quote_auto qa
   JOIN fsbi_dw_spinn.dim_month dm ON qa.adddt >= dm.mon_startdate AND qa.adddt <= dm.mon_enddate AND dm.month_id >= (("date_part"('year'::text, getdate()) - 3)::character varying::text + '01'::text)::integer
UNION ALL 
 SELECT 
        CASE
            WHEN qb.policynumber <> ''::text THEN qb.policynumber
            ELSE NULL::text
        END::character varying AS policy_number, qb.uniquecustomerkey::character varying AS uniquecustomerkey, dm.month_id, qb.adddt, qb.carriercd::character varying AS carriercd, qb.agent::character varying AS agent, qb.controllingstatecd, 
        CASE
            WHEN qb.linecd::text = 'Home'::text THEN 'Homeowners'::character varying
            WHEN qb.linecd::text = 'Dwelling'::text THEN 'Dwelling'::character varying
            ELSE qb.linecd
        END AS lob, 
        CASE
            WHEN "left"(qb.description, 7) = 'Rewrite'::text THEN 'Rewrite'::text
            WHEN "left"(qb.description, 7) = 'New App'::text THEN 'New Application'::text
            WHEN "left"(qb.description, 7) = 'New Quo'::text THEN 'New Quote'::text
            ELSE 'Unknown'::text
        END::character varying AS quote_description
   FROM fsbi_dw_spinn.quote_building qb
   JOIN fsbi_dw_spinn.dim_month dm ON qb.adddt >= dm.mon_startdate AND qb.adddt <= dm.mon_enddate AND dm.month_id >= (("date_part"('year'::text, getdate()) - 3)::character varying::text + '01'::text)::integer;

COMMENT ON VIEW reporting.vwt_quotecounts_agencyperformance IS 'The view is used in Sales and Marketing/Agency Performance Dashboard to get number of quotes based on uniquecustomerkey';