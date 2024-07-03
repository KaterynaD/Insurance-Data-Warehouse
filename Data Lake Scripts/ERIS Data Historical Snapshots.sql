create external schema external_data_pricing 						
from data catalog 						
database 'external_data_pricing' 						
iam_role 'arn:aws:iam::171874763805:role/CSE-Redshift-Spectrum-Role'						
create external database if not exists;						
						
grant usage on schema external_data_pricing to group bi;						
grant usage on schema external_data_pricing to group ba;


drop table if exists external_data_pricing.eris_ratechange;											
create external table external_data_pricing.eris_ratechange(											
ratechange_id integer,											
ratechange_name VARCHAR(10),											
statecd VARCHAR(2),											
linecd VARCHAR(15),											
carriercd VARCHAR(10),											
AltSubTypeCd VARCHAR(20),											
coverage VARCHAR(5),											
startdt DATE,											
nb_change NUMERIC(5, 2),											
renewal_change NUMERIC(5, 2),											
comments VARCHAR(255)											
)											
row format delimited											
fields terminated by ','											
stored as textfile											
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/ERIS_RATECHANGE/' 											
table properties ('skip.header.line.count'='1','invalid_char_handling'='DROP_ROW','data_cleansing_enabled'='true');											
						


drop table if exists external_data_pricing.veris_premium_ia;								
create external table external_data_pricing.veris_premium_ia(								
	report_year INTEGER,							
	report_quarter INTEGER,							
	renewaltermcd VARCHAR(255),							
	policyneworrenewal VARCHAR(10),							
	policystate VARCHAR(50),							
	companynumber VARCHAR(50),							
	company VARCHAR(100),							
	lob VARCHAR(3),							
	asl VARCHAR(5),							
	lob2 VARCHAR(3),							
	lob3 VARCHAR(3),							
	product VARCHAR(2),							
	policyformcode VARCHAR(255),							
	programind VARCHAR(6),							
	producer_status VARCHAR(10),							
	coveragetype VARCHAR(4),							
	coverage VARCHAR(5),							
	feeind VARCHAR(1) ,							
	wp NUMERIC(38, 2),							
	ep NUMERIC(38, 2),							
	clep DOUBLE PRECISION,							
	ee NUMERIC(38, 3)		,					
	AltSubTypeCd VARCHAR(20)							
)								
partitioned by (quarter_id VARCHAR(7), snapshot_id VARCHAR(8))								
stored as PARQUET								
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/'								
TABLE PROPERTIES ( 'write.parallel'='off' );								

drop table if exists external_data_pricing.veris_losses_ia;				
create external table external_data_pricing.veris_losses_ia(				
	devq BIGINT,			
	loss_qtr DOUBLE PRECISION,			
	loss_year DOUBLE PRECISION,			
	reported_qtr INTEGER,			
	reported_year INTEGER,			
	cat_indicator VARCHAR(3),			
	carrier VARCHAR(100),			
	company VARCHAR(50),			
	lob VARCHAR(3),			
	lob2 VARCHAR(3),			
	lob3 VARCHAR(3),			
	product VARCHAR(2),			
	policystate VARCHAR(2),			
	programind VARCHAR(6),			
	featuretype VARCHAR(4),			
	feature VARCHAR(5),			
	renewaltermcd VARCHAR(255),			
	policyneworrenewal VARCHAR(7),			
	claim_status VARCHAR(6),			
	producer_status VARCHAR(10),			
	source_system VARCHAR(5),			
	qtd_paid_dcc_expense NUMERIC(38, 2),			
	qtd_paid_expense NUMERIC(38, 2),			
	qtd_incurred_expense NUMERIC(38, 2),			
	qtd_incurred_dcc_expense NUMERIC(38, 2),			
	qtd_paid_salvage_and_subrogation NUMERIC(38, 2),			
	qtd_paid_loss NUMERIC(38, 2),			
	qtd_incurred_loss NUMERIC(38, 2),			
	qtd_paid NUMERIC(38, 2),			
	qtd_incurred NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation NUMERIC(38, 2),			
	qtd_total_incurred_los NUMERIC(38, 2),			
	paid_on_closed_salvage_subrogation NUMERIC(38, 2),			
	qtd_paid_25k NUMERIC(38, 2),			
	qtd_paid_50k NUMERIC(38, 2),			
	qtd_paid_100k NUMERIC(38, 2),			
	qtd_paid_250k NUMERIC(38, 2),			
	qtd_paid_500k NUMERIC(38, 2),			
	qtd_paid_1m NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation_25k NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation_50k NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation_100k NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation_250k NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation_500k NUMERIC(38, 2),			
	qtd_incurred_net_salvage_subrogation_1m NUMERIC(38, 2),			
	reported_count BIGINT,			
	closed_count BIGINT,			
	closed_nopay BIGINT,			
	paid_on_closed_loss NUMERIC(38, 2),			
	paid_on_closed_expense NUMERIC(38, 2),			
	paid_on_closed_dcc_expense NUMERIC(38, 2),			
	paid_count BIGINT,			
	PolicyFormCode VARCHAR(20),			
	AltSubTypeCd VARCHAR(20)			
)				
partitioned by (quarter_id VARCHAR(7), snapshot_id VARCHAR(8))				
stored as PARQUET				
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/'				
TABLE PROPERTIES ( 'write.parallel'='off' );				


drop table if exists external_data_pricing.vmeris_policies_ia;					
create external table external_data_pricing.vmeris_policies_ia(					
	report_year INTEGER,				
	report_quarter INTEGER,				
	policynumber VARCHAR(50),				
	policy_id INTEGER,				
	policy_uniqueid VARCHAR(100),				
	riskcd VARCHAR(12),				
	policyversion VARCHAR(10),				
	effectivedate DATE,				
	expirationdate DATE,				
	renewaltermcd VARCHAR(255),				
	policyneworrenewal VARCHAR(10),				
	policystate VARCHAR(50),				
	companynumber VARCHAR(50),				
	company VARCHAR(100),				
	lob VARCHAR(3),				
	asl VARCHAR(5),				
	lob2 VARCHAR(3),				
	lob3 VARCHAR(3),				
	product VARCHAR(2),				
	policyformcode VARCHAR(255),				
	programind VARCHAR(6),				
	producer_status VARCHAR(10),				
	coveragetype VARCHAR(4),				
	coverage VARCHAR(5),				
	feeind VARCHAR(1),				
	source VARCHAR(5),				
	wp NUMERIC(38, 2),				
	ep NUMERIC(38, 2),				
	clep DOUBLE PRECISION,				
	ee NUMERIC(38, 3),				
	loaddate DATE,				
	AltSubTypeCd VARCHAR(20)				
)					
partitioned by (quarter_id VARCHAR(7), snapshot_id VARCHAR(8))					
stored as PARQUET					
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/VMERIS_POLICIES/'					
TABLE PROPERTIES ( 'write.parallel'='on' );					
					

drop table if exists external_data_pricing.vmeris_claims_ia;	
create external table external_data_pricing.vmeris_claims_ia(	
	devq BIGINT,
	reported_year INTEGER,
	reported_qtr INTEGER,
	loss_date DATE,
	reported_date DATE,
	carrier VARCHAR(100),
	company VARCHAR(50),
	policy_number VARCHAR(50),
	policy_uniqueid VARCHAR(100),
	riskcd VARCHAR(12),
	poleff_date DATE,
	polexp_date DATE,
	renewaltermcd VARCHAR(255),
	policyneworrenewal VARCHAR(7),
	policystate VARCHAR(2),
	producer_status VARCHAR(10),
	claim_number VARCHAR(50),
	claimant VARCHAR(50),
	cat_indicator VARCHAR(3),
	lob VARCHAR(3),
	lob2 VARCHAR(3),
	lob3 VARCHAR(3),
	product VARCHAR(2),
	policyformcode VARCHAR(20),
	programind VARCHAR(6),
	featuretype VARCHAR(4),
	feature VARCHAR(5),
	claim_status VARCHAR(6),
	source_system VARCHAR(5),
	itd_paid_expense NUMERIC(38, 2),
	itd_paid_dcc_expense NUMERIC(38, 2),
	itd_paid_loss NUMERIC(38, 2),
	itd_incurred NUMERIC(38, 2),
	itd_incurred_net_salvage_subrogation NUMERIC(38, 2),
	itd_total_incurred_loss NUMERIC(38, 2),
	itd_reserve NUMERIC(38, 2),
	itd_loss_and_alae_for_paid_count NUMERIC(38, 2),
	itd_salvage_and_subrogation NUMERIC(38, 2),
	qtd_paid_dcc_expense NUMERIC(38, 2),
	qtd_paid_expense NUMERIC(38, 2),
	qtd_incurred_expense NUMERIC(38, 2),
	qtd_incurred_dcc_expense NUMERIC(38, 2),
	qtd_paid_salvage_and_subrogation NUMERIC(38, 2),
	qtd_paid_loss NUMERIC(38, 2),
	qtd_incurred_loss NUMERIC(38, 2),
	qtd_paid NUMERIC(38, 2),
	qtd_incurred NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation NUMERIC(38, 2),
	qtd_total_incurred_loss NUMERIC(38, 2),
	qtd_paid_25k NUMERIC(38, 2),
	qtd_paid_50k NUMERIC(38, 2),
	qtd_paid_100k NUMERIC(38, 2),
	qtd_paid_250k NUMERIC(38, 2),
	qtd_paid_500k NUMERIC(38, 2),
	qtd_paid_1m NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation_25k NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation_50k NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation_100k NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation_250k NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation_500k NUMERIC(38, 2),
	qtd_incurred_net_salvage_subrogation_1m NUMERIC(38, 2),
	x_itd_incurred_net_salvage_subrogation_250k NUMERIC(38, 2),
	x_itd_incurred_net_salvage_subrogation_500k NUMERIC(38, 2),
	reported_count INTEGER,
	closed_count INTEGER,
	closed_nopay INTEGER,
	paid_on_closed_loss NUMERIC(38, 2),
	paid_on_closed_expense NUMERIC(38, 2),
	paid_on_closed_dcc_expense NUMERIC(38, 2),
	paid_on_closed_salvage_subrogation NUMERIC(38, 2),
	paid_count INTEGER,
	loaddate TIMESTAMP,
	itd_paid NUMERIC(38, 2),
	AltSubTypeCd VARCHAR(20)
)	
partitioned by (quarter_id VARCHAR(7), snapshot_id VARCHAR(8))	
stored as PARQUET	
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/VMERIS_CLAIMS/'	
TABLE PROPERTIES ( 'write.parallel'='on' );	
