create external schema fsbi_stg_uuico							
from data catalog 								
database 'fsbi_stg_uuico' 								
iam_role 'arn:aws:iam::XYZ:role/CSE-Redshift-Spectrum-Role'								
create external database if not exists;		

drop  table if exists fsbi_stg_uuico.STG_CLAIM;         					
create external table fsbi_stg_uuico.STG_CLAIM(         					
  FILE_VERSION varchar(10)  ,       					
  SOURCE_SYSTEM varchar(100)  ,       					
  EXTRACT_DATE date  ,       					
  CLM_SEQUENCE integer  ,       					
  CLAIM_UNIQUEID varchar(100)  ,        					
  POLICY_UNIQUEID varchar(100) ,        					
  PRIMARYRISK_UNIQUEID varchar(100) ,       					
  SECONDARYRISK_UNIQUEID varchar(100) ,       					
  RISKRELATIONSHIP_UNIQUEID varchar(100) ,        					
  COVERAGE_UNIQUEID varchar(100) ,        					
  CLAIMANT_UNIQUEID varchar(100) ,        					
  ADJUSTER_UNIQUEID varchar(100) ,        					
  CONTACT_UNIQUEID varchar(100) ,       					
  CLM_CLAIMNUMBER varchar(50)  ,        					
  CLM_FEATURENUMBER varchar(50) ,       					
  CLM_FEATUREDELETEFLAG varchar(1) ,        					
  CLM_GROUPNUMBER varchar(50) ,       					
  CLM_TYPELOSS varchar(100) ,       					
  CLM_DESCRIPTION varchar(2000) ,       					
  CLM_CATCODE varchar(50) ,       					
  CLM_CATDESCRIPTION varchar(256) ,       					
  CLM_CAUSELOSSCODE varchar(50) ,       					
  CLM_CAUSELOSSDESCRIPTION varchar(256) ,       					
  CLM_DATEOFLOSS date ,        					
  CLM_LOSSREPORTEDDATE date ,        					
  CLM_CLOSEDDATE date ,        					
  CLM_CLAIMSTATUSCD varchar(50) ,       					
  CLM_SUBSTATUSCD varchar(50) ,       					
  CLM_ADDRESS1 varchar(150) ,       					
  CLM_ADDRESS2 varchar(150) ,       					
  CLM_ADDRESS3 varchar(150) ,       					
  CLM_COUNTY varchar(50) ,        					
  CLM_CITY varchar(50) ,        					
  CLM_STATE varchar(50) ,       					
  CLM_POSTALCODE varchar(20) ,        					
  CLM_COUNTRY varchar(50) ,       					
  CLM_LATITUDE numeric(18, 12) ,        					
  CLM_LONGITUDE numeric(18, 12) ,       					
  CLM_CHANGEDATE date  ,       					
  ATFAULT varchar(100)        					
)         					
partitioned by (month_id VARCHAR(8))          					
row format delimited          					
fields terminated by '|'          					
stored as textfile          					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/'          					
TABLE PROPERTIES ('skip.header.line.count'='1');          					
 					
 					
Alter table fsbi_stg_uuico.stg_claim add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claim/month_id=202212/';					
					
					
drop  table if exists fsbi_stg_uuico.STG_CLAIMTRANSACTION;          					
create external table fsbi_stg_uuico.STG_CLAIMTRANSACTION(          					
  FILE_VERSION varchar(10)  ,       					
  SOURCE_SYSTEM varchar(100)  ,       					
  EXTRACT_DATE date  ,       					
  CLAIMTRANSACTION_UNIQUEID varchar(150) ,        					
  CLAIM_UNIQUEID varchar(100)  ,        					
  PAYEE_UNIQUEID varchar(100) ,       					
  CT_SEQUENCE integer  ,        					
  CT_TRANSACTIONFLAG varchar(1) ,       					
  CT_TRANSACTIONSTATUS varchar(50) ,        					
  CT_TRANSACTIONDATE date ,        					
  CT_ACCOUNTINGDATE date  ,        					
  CT_CHANGEDATE date ,       					
  CT_TYPECODE varchar(50)  ,        					
  CT_SUBTYPECODE varchar(50) ,        					
  CT_AMOUNT numeric(13, 2)  ,       					
  CT_ORIGCURRENCYCODE varchar(5) ,        					
  CT_ORIGCURRENCYAMOUNT numeric(13, 3) ,        					
  ReserveCd varchar(255) ,        					
  ReserveTypeCd varchar(255) ,        					
  BookDt date        					
)         					
partitioned by (month_id VARCHAR(10))         					
row format delimited          					
fields terminated by '|'          					
stored as textfile          					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/'           					
TABLE PROPERTIES ('skip.header.line.count'='1');          					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_claimtransaction add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_claimtransaction/month_id=202212/';					
					
					
drop  table if exists fsbi_stg_uuico.STG_COVERAGE;          					
create external table fsbi_stg_uuico.STG_COVERAGE(          					
  FILE_VERSION varchar(10)  ,       					
  SOURCE_SYSTEM varchar(100)  ,       					
  EXTRACT_DATE date  ,       					
  COV_SEQUENCE int  ,       					
  COVERAGE_UNIQUEID varchar(100)  ,       					
  COV_TRANSACTIONTYPE varchar(5)  ,       					
  COV_CHANGEDATE date  ,        					
  COV_TYPE varchar(100) ,       					
  COV_CODE varchar(50)  ,       					
  COV_NAME varchar(256) ,       					
  COV_DESCRIPTION varchar(256) ,        					
  COV_SUBCODE varchar(50) ,       					
  COV_SUBCODENAME varchar(256) ,        					
  COV_SUBCODEDESCRIPTION varchar(256) ,       					
  COV_EFFECTIVEDATE date  ,        					
  COV_EXPIRATIONDATE date  ,       					
  COV_ASL varchar(5) ,        					
  COV_SUBLINE varchar(5) ,        					
  COV_CLASSCODE varchar(50) ,       					
  COV_CLASSCODENAME varchar(50) ,       					
  COV_CLASSCODEDESCRIPTION varchar(256) ,       					
  COV_CLASSSUBCODE varchar(50) ,        					
  COV_CLASSSUBCODENAME varchar(50) ,        					
  COV_CLASSSUBCODEDESCRIPTION varchar(256) ,        					
  COV_DEDUCTIBLE1 numeric(13, 2) ,        					
  COV_DEDUCTIBLE1TYPE varchar(50) ,       					
  COV_DEDUCTIBLE2 numeric(13, 2) ,        					
  COV_DEDUCTIBLE2TYPE varchar(50) ,       					
  COV_DEDUCTIBLE3 numeric(13, 2) ,        					
  COV_DEDUCTIBLE3TYPE varchar(50) ,       					
  COV_LIMIT1 numeric(13, 2) ,       					
  COV_LIMIT1TYPE varchar(50) ,        					
  COV_LIMIT2 numeric(13, 2) ,       					
  COV_LIMIT2TYPE varchar(50) ,        					
  COV_LIMIT3 numeric(13, 2) ,       					
  COV_LIMIT3TYPE varchar(50) ,        					
  COV_LIMIT4 numeric(13, 2) ,       					
  COV_LIMIT4TYPE varchar(50) ,        					
  COV_LIMIT5 numeric(13, 2) ,       					
  COV_LIMIT5TYPE varchar(50),        					
  COV_TRANSACTIONTIME VARCHAR(20),					
  COV_VEHICLEID VARCHAR(5),					
  COV_POLICYUNIQUEID VARCHAR(50),					
  COV_TRANSACTIONDATE date					
)         					
partitioned by (month_id VARCHAR(10))         					
row format delimited          					
fields terminated by '|'          					
stored as textfile          					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/'           					
TABLE PROPERTIES ('skip.header.line.count'='1');          					
  					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_coverage add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_coverage/month_id=202212/';					
					
					
drop  table if exists fsbi_stg_uuico.STG_DISCOUNT;           					
create external table fsbi_stg_uuico.STG_DISCOUNT(       					
  file_version varchar(10) ,     					
  source_system varchar(100) ,     					
  extract_date date ,     					
  Policy_UniqueID varchar(100) ,     					
  Employment_Group_Discount varchar(50) ,     					
  Multi_Car_Discount varchar(1) ,    					
  Multi_Policy_Discount varchar(1) ,     					
  effective_date date  					
) 					
partitioned by (month_id VARCHAR(10))            					
row format delimited           					
fields terminated by '|'           					
stored as textfile           					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/'            					
TABLE PROPERTIES ('skip.header.line.count'='1');           					
   					
   					
  					
Alter table fsbi_stg_uuico.stg_discount add 					
partition(month_id='202201')     					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202201/' 					
partition(month_id='202202') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202202/' 					
partition(month_id='202203') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202203/' 					
partition(month_id='202204') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202204/' 					
partition(month_id='202205') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202205/' 					
partition(month_id='202206') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202206/' 					
partition(month_id='202207') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202207/' 					
partition(month_id='202208') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202208/' 					
partition(month_id='202209') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202209/' 					
partition(month_id='202210') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202210/' 					
partition(month_id='202211') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202211/' 					
partition(month_id='202212') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=202212/' 					
partition(month_id='fix202205') 					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_discount/month_id=fix202205/'; 					
					
					
					
drop  table if exists fsbi_stg_uuico.STG_DRIVER;          					
create external table fsbi_stg_uuico.STG_DRIVER(    					
  file_version varchar(10) ,  					
  source_system varchar(100) ,  					
  extract_date date ,  					
  Driver_uniqueid varchar(100) ,  					
  DriverType varchar(100) , 					
  DriverPoints int ,  					
  DriverGender varchar(100) , 					
  DriverMaritalStatus varchar(100) ,  					
  DriverLicensedDate date , 					
  DriverDOB date ,  					
  DriverAddDate date ,  					
  DriverRemoveDate date , 					
  InsuranceScore int ,  					
  DriverChangeDate date , 					
  DriverGoodDriver varchar(1) , 					
  Driver_3_YearClean varchar(1) , 					
  Driver_5_YearAccidentFree varchar(1) ,  					
  DriverGoodStudent varchar(1) ,  					
  DriverDefensiveDriver varchar(1) ,  					
  DriverPermitDriver varchar(1) , 					
  DriverStatus varchar(15) ,  					
  DriverLicenseNumber varchar(255) ,  					
  DriverFirstName varchar(255) ,  					
  DriverLastName varchar(255) , 					
  PolicyUniqueID varchar(100) 					
)					
partitioned by (month_id VARCHAR(10))           					
row format delimited          					
fields terminated by '|'          					
stored as textfile          					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/'           					
TABLE PROPERTIES ('skip.header.line.count'='1');          					
  					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_driver add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_driver/month_id=202212/';					
					
					
					
drop  table if exists fsbi_stg_uuico.STG_LEGALENTITY;         					
create external table fsbi_stg_uuico.STG_LEGALENTITY(       					
  FILE_VERSION varchar(10)  ,     					
  SOURCE_SYSTEM varchar(100)  ,     					
  EXTRACT_DATE date  ,     					
  LENTY_SEQUENCE int  ,     					
  LEGALENTITY_UNIQUEID varchar(100) ,     					
  LEGALENTITY_PARENTUNIQUEID varchar(100) ,     					
  LENTY_ROLE varchar(50)  ,     					
  LENTY_TYPE varchar(50) ,      					
  LENTY_TYPEDESCRIPTION varchar(256) ,      					
  LENTY_AFFILIATENUMBER varchar(50) ,     					
  LENTY_AFFILIATENAME varchar(100) ,      					
  LENTY_NUMBER varchar(50) ,      					
  LENTY_NAME1 varchar(200)  ,     					
  LENTY_NAME2 varchar(200) ,      					
  LENTY_DOB date ,     					
  LENTY_OCCUPATION varchar(256) ,     					
  LENTY_GENDER varchar(10) ,      					
  LENTY_MARITALSTATUS varchar(256) ,      					
  LENTY_ADDRESS1 varchar(150) ,     					
  LENTY_ADDRESS2 varchar(150) ,     					
  LENTY_ADDRESS3 varchar(150) ,     					
  LENTY_COUNTY varchar(50) ,      					
  LENTY_CITY varchar(50) ,      					
  LENTY_STATE varchar(50) ,     					
  LENTY_POSTALCODE varchar(20) ,      					
  LENTY_COUNTRY varchar(50) ,     					
  LENTY_LATITUDE numeric(18, 12) ,      					
  LENTY_LONGITUDE numeric(18, 12) ,     					
  LENTY_TELEPHONE varchar(20) ,     					
  LENTY_FAX varchar(20) ,     					
  LENTY_MOBILE varchar(20) ,      					
  LENTY_EMAIL varchar(100) ,      					
  LENTY_WEBSITE varchar(100) ,      					
  LENTY_BUSINESSTYPE varchar(50) ,      					
  LENTY_SICNAICS varchar(6) ,     					
  LENTY_SICNAICSDESC varchar(256) ,     					
  LENTY_FEINSSN varchar(15) ,     					
  LENTY_DEPARTMENT varchar(100) ,     					
  LENTY_JOBTITLE varchar(100) ,     					
  LENTY_CHANGEDATE date  ,           					
  lenty_credit_score int ,      					
  lenty_credit_tier int       					
)     					
partitioned by (month_id VARCHAR(10))           					
row format delimited          					
fields terminated by '|'          					
stored as textfile          					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/'          					
TABLE PROPERTIES ('skip.header.line.count'='1');          					
  					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_legalentity add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_legalentity/month_id=202212/';					
					
					
					
drop  table if exists fsbi_stg_uuico.STG_POLICY;          					
create external table fsbi_stg_uuico.STG_POLICY(          					
  FILE_VERSION varchar(10)  ,       					
  SOURCE_SYSTEM varchar(100)  ,       					
  EXTRACT_DATE date  ,       					
  POL_SEQUENCE integer  ,       					
  POLICY_UNIQUEID varchar(100)  ,       					
  QUOTE_UNIQUEID varchar(100) ,       					
  PRODUCT_UNIQUEID varchar(100) ,       					
  COMPANY_UNIQUEID varchar(100) ,       					
  PRODUCER_UNIQUEID varchar(100) ,        					
  SUBPRODUCER_UNIQUEID varchar(100) ,       					
  UNDERWRITER_UNIQUEID varchar(100) ,       					
  FIRSTINSURED_UNIQUEID varchar(100) ,        					
  SECONDINSURED_UNIQUEID varchar(100) ,       					
  THIRDINSURED_UNIQUEID varchar(100) ,        					
  FOURTHINSURED_UNIQUEID varchar(100) ,       					
  FIFTHINSURED_UNIQUEID varchar(100) ,        					
  POL_POLICYNUMBERPREFIX varchar(10) ,        					
  POL_POLICYNUMBER varchar(50)  ,       					
  POL_POLICYNUMBERSUFFIX varchar(10) ,        					
  POL_ORIGINALEFFECTIVEDATE date ,       					
  POL_QUOTEDDATE date ,        					
  POL_ISSUEDDATE date ,        					
  POL_BINDERISSUEDDATE date ,        					
  POL_EFFECTIVEDATE date ,       					
  POL_EXPIRATIONDATE date ,        					
  POL_ASL varchar(5) ,        					
  POL_MASTERSTATE varchar(50) ,       					
  POL_MASTERCOUNTRY varchar(50) ,       					
  POL_MASTERTERRITORYCODE varchar(5) ,        					
  POL_MASTERTERRITORYNAME varchar(100) ,        					
  POL_CONVERSIONINDICATORCODE varchar(5) ,        					
  POL_AUTOMATEDAPPROVAL int ,       					
  POL_GENERATIONSOURCE varchar(100) ,       					
  POL_ACCOUNTNUMBER varchar(50) ,       					
  POL_ACCOUNTDESCRIPTION varchar(256) ,       					
  POL_CHANGEDATE date  ,       					
  POL_VERSION varchar(10) ,       					
  POL_CANCELDATE date ,       					
  POL_FORM varchar(5) ,       					
  POL_STATUS varchar(20) ,        					
  POL_ICOPOLICYNUMBER varchar(50) ,       					
  POL_ICOPRODUCERCODES varchar(500)         					
)         					
partitioned by (month_id VARCHAR(10))         					
row format delimited          					
fields terminated by '|'          					
stored as textfile          					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/'           					
TABLE PROPERTIES ('skip.header.line.count'='1');          					
 					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_policy add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policy/month_id=202212/';					
					
					
					
drop  table if exists fsbi_stg_uuico.stg_policytransaction;           					
create external table fsbi_stg_uuico.stg_policytransaction(           					
  FILE_VERSION varchar(10)  ,         					
  SOURCE_SYSTEM varchar(100)  ,         					
  EXTRACT_DATE date  ,         					
  POLICYTRANSACTION_UNIQUEID varchar(100)  ,          					
  POLICY_UNIQUEID varchar(100)  ,         					
  PRIMARYRISK_UNIQUEID varchar(100)  ,          					
  SECONDARYRISK_UNIQUEID varchar(100)  ,          					
  RISKRELATIONSHIP_UNIQUEID varchar(100)  ,         					
  COVERAGE_UNIQUEID varchar(100)  ,         					
  PT_TRANSACTIONDATE date ,          					
  PT_SEQUENCE integer  ,          					
  PT_ACCOUNTINGDATE date  ,          					
  PT_EFFECTIVEDATE date  ,         					
  PT_EARNINGSTYPE varchar(1) ,          					
  PT_EARNFROMDATE date ,         					
  PT_EARNTODATE date ,         					
  PT_TYPECODE varchar(49)  ,          					
  PT_TYPESUBCODE varchar(49) ,          					
  PT_PERCENTEARNEDINCEPTION numeric(6, 3) ,         					
  PT_AMOUNT numeric(13, 2)  ,         					
  PT_COMMISSIONAMOUNT numeric(13, 2) ,          					
  PT_TERMAMOUNT numeric(13, 2) ,          					
  PT_COVERAGECODE varchar(50) ,         					
  PT_ORIGCURRENCYAMOUNT numeric(13, 3),					
  PT_INSURANCELINE VARCHAR(50),					
  PT_TRANSACTIONTIME VARCHAR(20),					
  PT_VEHICLEID VARCHAR(5)					
)           					
partitioned by (month_id VARCHAR(10))           					
row format delimited            					
fields terminated by '|'            					
stored as textfile            					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/'            					
TABLE PROPERTIES ('skip.header.line.count'='1');            					
        					
 					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_policytransaction add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_policytransaction/month_id=202212/';					
					
					
					
drop  table if exists fsbi_stg_uuico.STG_PRODUCT;           					
create external table fsbi_stg_uuico.STG_PRODUCT(     					
  FILE_VERSION varchar(50)  ,   					
  SOURCE_SYSTEM varchar(100)  ,   					
  EXTRACT_DATE date  ,   					
  PRODUCT_UNIQUEID varchar(100)  ,    					
  PRDT_GROUP varchar(100) ,   					
  PRDT_NAME varchar(100)  ,   					
  PRDT_LOB varchar(50) ,    					
  PRDT_DESCRIPTION varchar(2000) 					
) 					
partitioned by (month_id VARCHAR(10))           					
row format delimited            					
fields terminated by '|'            					
stored as textfile            					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/'            					
TABLE PROPERTIES ('skip.header.line.count'='1');            					
        					
 					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_product add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_product/month_id=202212/';					
					
					
drop  table if exists fsbi_stg_uuico.STG_RISK;            					
create external table fsbi_stg_uuico.STG_RISK(        					
  FILE_VERSION varchar(10)  ,     					
  SOURCE_SYSTEM varchar(100)  ,     					
  EXTRACT_DATE date  ,     					
  RSK_SEQUENCE int ,      					
  RISK_UNIQUEID varchar(100)  ,     					
  FOTHRINT_UNIQUEID varchar(100) ,      					
  SOTHRINT_UNIQUEID varchar(100) ,      					
  RSK_TRANSACTIONTYPE varchar(5)  ,     					
  RSK_TRANSACTIONDATE date  ,      					
  RSK_NUMBER varchar(50) ,      					
  RSK_SUBNUMBER varchar(50) ,     					
  RSK_TYPE varchar(100) ,     					
  RSK_TYPEDESCRIPTION varchar(256) ,      					
  RSK_TERRITORYCODE varchar(5) ,      					
  RSK_TERRITORYNAME varchar(100) ,      					
  RSK_ADDRESS1 varchar(150) ,     					
  RSK_ADDRESS2 varchar(150) ,     					
  RSK_ADDRESS3 varchar(150) ,     					
  RSK_COUNTY varchar(50) ,      					
  RSK_CITY varchar(50) ,      					
  RSK_STATE varchar(50) ,     					
  RSK_POSTALCODE varchar(20) ,      					
  RSK_COUNTRY varchar(50) ,     					
  RSK_LATITUDE numeric(18, 12) ,      					
  RSK_LONGITUDE numeric(18, 12) 					
) 					
partitioned by (month_id VARCHAR(10))           					
row format delimited            					
fields terminated by '|'            					
stored as textfile            					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/'             					
TABLE PROPERTIES ('skip.header.line.count'='1');            					
        					
 					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_risk add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_risk/month_id=202212/';					
					
					
drop  table if exists fsbi_stg_uuico.STG_VEHICLE;           					
create external table fsbi_stg_uuico.STG_VEHICLE(     					
  file_version varchar(10) ,    					
  source_system varchar(100) ,    					
  extract_date date ,    					
  Vehicle_UniqueID varchar(100) ,   					
  VIN varchar(100) ,    					
  VehicleMake varchar(100) ,    					
  VehicleModel varchar(100) ,   					
  VehicleYear int ,   					
  VehicleMileage integer ,    					
  VehicleValueAmount integer ,    					
  VehicleAddDate date ,   					
  VehicleRemoveDate date ,    					
  VehicleISOSymbols varchar(100) ,    					
  VehicleUse varchar(100) ,   					
  GaragingZip varchar(100) ,    					
  VehicleChangeDate date ,    					
  Status varchar(15)  ,					
VerifiedMiles int 					
)					
partitioned by (month_id VARCHAR(10))           					
row format delimited            					
fields terminated by '|'            					
stored as textfile            					
location  's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/'            					
TABLE PROPERTIES ('skip.header.line.count'='1');            					
        					
 					
  					
 					
 					
Alter table fsbi_stg_uuico.stg_vehicle add					
partition(month_id='202201')    					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202201/'					
partition(month_id='202202')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202202/'					
partition(month_id='202203')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202203/'					
partition(month_id='202204')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202204/'					
partition(month_id='202205')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202205/'					
partition(month_id='202206')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202206/'					
partition(month_id='202207')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202207/'					
partition(month_id='202208')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202208/'					
partition(month_id='202209')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202209/'					
partition(month_id='202210')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202210/'					
partition(month_id='202211')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202211/'					
partition(month_id='202212')					
location 's3://cse-bi/RedshiftSpectrum/fsbi_stg_uuico/stg_vehicle/month_id=202212/';					
