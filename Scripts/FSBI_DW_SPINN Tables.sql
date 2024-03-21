-- fsbi_dw_spinn.dim_address definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_address;

--DROP TABLE fsbi_dw_spinn.dim_address;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_address
(
	address_id INTEGER NOT NULL  ENCODE RAW
	,addr_address1 VARCHAR(150)   ENCODE lzo
	,addr_address2 VARCHAR(150)   ENCODE lzo
	,addr_address3 VARCHAR(150)   ENCODE runlength
	,addr_county VARCHAR(50)   ENCODE lzo
	,addr_city VARCHAR(50)   ENCODE lzo
	,addr_state VARCHAR(50)   ENCODE bytedict
	,addr_postalcode VARCHAR(20)   ENCODE lzo
	,addr_country VARCHAR(50)   ENCODE lzo
	,addr_latitude NUMERIC(18,12)   ENCODE lzo
	,addr_longitude NUMERIC(18,12)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE runlength
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (address_id)
)
DISTSTYLE AUTO
 DISTKEY (address_id)
 SORTKEY (
	addr_latitude
	)
;
ALTER TABLE fsbi_dw_spinn.dim_address owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_address IS ' 	Source: 	Addr	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary table. All available risk addresses in the system. The same data as address data  in  DIM_VEHICLE or DIM_BUILDING. Garage or Insured Lookup address for vehicles, Risk address for Homeowners and LandLords, Location address for commercial. The same approach as in PolicyStats.';


-- fsbi_dw_spinn.dim_adjuster definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_adjuster;

--DROP TABLE fsbi_dw_spinn.dim_adjuster;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_adjuster
(
	adjuster_id INTEGER NOT NULL  ENCODE RAW
	,adjuster_type VARCHAR(50)   ENCODE lzo
	,adjuster_number VARCHAR(50)   ENCODE lzo
	,name VARCHAR(100)   ENCODE lzo
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE lzo
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,fax VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,adjuster_uniqueid VARCHAR(100)   ENCODE lzo
	,usermanagementgroupcd VARCHAR(25)   ENCODE lzo
	,supervisor VARCHAR(255)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (adjuster_id)
)
DISTSTYLE AUTO
 SORTKEY (
	adjuster_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_adjuster owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_adjuster IS ' 	Source: 	AllContacts, Provider, UserInfo	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Adjuster info including email';


-- fsbi_dw_spinn.dim_app_building definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_app_building;

--DROP TABLE fsbi_dw_spinn.dim_app_building;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_app_building
(
	building_app_id INTEGER NOT NULL  ENCODE RAW
	,application_id INTEGER NOT NULL  ENCODE az64
	,building_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,spinnbuilding_id VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE lzo
	,building_naturalkey VARCHAR(500) NOT NULL  ENCODE lzo
	,stateprovcd VARCHAR(255) NOT NULL  ENCODE lzo
	,county VARCHAR(255) NOT NULL  ENCODE lzo
	,postalcode VARCHAR(255) NOT NULL  ENCODE lzo
	,city VARCHAR(255) NOT NULL  ENCODE lzo
	,addr1 VARCHAR(255) NOT NULL  ENCODE lzo
	,addr2 VARCHAR(255) NOT NULL  ENCODE lzo
	,bldgnumber INTEGER NOT NULL  ENCODE az64
	,constructioncd VARCHAR(255) NOT NULL  ENCODE lzo
	,roofcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,yearbuilt INTEGER NOT NULL  ENCODE az64
	,sqft INTEGER NOT NULL  ENCODE az64
	,stories INTEGER NOT NULL  ENCODE az64
	,units INTEGER NOT NULL  ENCODE az64
	,occupancycd VARCHAR(255) NOT NULL  ENCODE lzo
	,protectionclass VARCHAR(255) NOT NULL  ENCODE bytedict
	,territorycd VARCHAR(255) NOT NULL  ENCODE lzo
	,windhailexclusion VARCHAR(255) NOT NULL  ENCODE lzo
	,covalimit INTEGER NOT NULL  ENCODE az64
	,covblimit INTEGER NOT NULL  ENCODE az64
	,covclimit INTEGER NOT NULL  ENCODE az64
	,covdlimit INTEGER NOT NULL  ENCODE az64
	,covelimit INTEGER NOT NULL  ENCODE az64
	,covflimit INTEGER NOT NULL  ENCODE az64
	,allperilded VARCHAR(255) NOT NULL  ENCODE bytedict
	,burglaryalarmtype VARCHAR(255) NOT NULL  ENCODE lzo
	,firealarmtype VARCHAR(255) NOT NULL  ENCODE lzo
	,covblimitincluded INTEGER NOT NULL  ENCODE az64
	,covblimitincrease INTEGER NOT NULL  ENCODE az64
	,covclimitincluded INTEGER NOT NULL  ENCODE az64
	,covclimitincrease INTEGER NOT NULL  ENCODE az64
	,covdlimitincluded INTEGER NOT NULL  ENCODE az64
	,covdlimitincrease INTEGER NOT NULL  ENCODE az64
	,ordinanceorlawpct INTEGER NOT NULL  ENCODE az64
	,neighborhoodcrimewatchind VARCHAR(255) NOT NULL  ENCODE lzo
	,employeecreditind VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyind VARCHAR(255) NOT NULL  ENCODE lzo
	,homewarrantycreditind VARCHAR(255) NOT NULL  ENCODE lzo
	,yearoccupied INTEGER NOT NULL  ENCODE az64
	,yearpurchased INTEGER NOT NULL  ENCODE az64
	,typeofstructure VARCHAR(255) NOT NULL  ENCODE lzo
	,feettofirehydrant INTEGER NOT NULL  ENCODE az64
	,numberoffamilies INTEGER NOT NULL  ENCODE az64
	,milesfromfirestation INTEGER NOT NULL  ENCODE az64
	,rooms INTEGER NOT NULL  ENCODE az64
	,roofpitch VARCHAR(255) NOT NULL  ENCODE lzo
	,firedistrict VARCHAR(255) NOT NULL  ENCODE lzo
	,sprinklersystem VARCHAR(255) NOT NULL  ENCODE lzo
	,fireextinguisherind VARCHAR(255) NOT NULL  ENCODE lzo
	,kitchenfireextinguisherind VARCHAR(255) NOT NULL  ENCODE lzo
	,deadboltind VARCHAR(255) NOT NULL  ENCODE lzo
	,gatedcommunityind VARCHAR(255) NOT NULL  ENCODE lzo
	,centralheatingind VARCHAR(255) NOT NULL  ENCODE lzo
	,foundation VARCHAR(255) NOT NULL  ENCODE lzo
	,wiringrenovation VARCHAR(255) NOT NULL  ENCODE lzo
	,wiringrenovationcompleteyear VARCHAR(255) NOT NULL  ENCODE lzo
	,plumbingrenovation VARCHAR(255) NOT NULL  ENCODE lzo
	,heatingrenovation VARCHAR(255) NOT NULL  ENCODE lzo
	,plumbingrenovationcompleteyear VARCHAR(255) NOT NULL  ENCODE lzo
	,exteriorpaintrenovation VARCHAR(255) NOT NULL  ENCODE lzo
	,heatingrenovationcompleteyear VARCHAR(255) NOT NULL  ENCODE lzo
	,circuitbreakersind VARCHAR(255) NOT NULL  ENCODE lzo
	,copperwiringind VARCHAR(255) NOT NULL  ENCODE lzo
	,exteriorpaintrenovationcompleteyear VARCHAR(255) NOT NULL  ENCODE lzo
	,copperpipesind VARCHAR(255) NOT NULL  ENCODE lzo
	,earthquakeretrofitind VARCHAR(255) NOT NULL  ENCODE lzo
	,primaryfuelsource VARCHAR(255) NOT NULL  ENCODE lzo
	,secondaryfuelsource VARCHAR(255) NOT NULL  ENCODE lzo
	,usagetype VARCHAR(255) NOT NULL  ENCODE lzo
	,homegardcreditind VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,localfirealarmind VARCHAR(255) NOT NULL  ENCODE lzo
	,numlosses INTEGER NOT NULL  ENCODE az64
	,covalimitincrease INTEGER NOT NULL  ENCODE az64
	,covalimitincluded INTEGER NOT NULL  ENCODE az64
	,monthsrentedout INTEGER NOT NULL  ENCODE az64
	,roofreplacement VARCHAR(255) NOT NULL  ENCODE lzo
	,safeguardplusind VARCHAR(255) NOT NULL  ENCODE bytedict
	,covelimitincluded INTEGER NOT NULL  ENCODE az64
	,roofreplacementcompleteyear VARCHAR(255) NOT NULL  ENCODE lzo
	,covelimitincrease INTEGER NOT NULL  ENCODE az64
	,owneroccupiedunits INTEGER NOT NULL  ENCODE az64
	,tenantoccupiedunits INTEGER NOT NULL  ENCODE az64
	,replacementcostdwellingind VARCHAR(255) NOT NULL  ENCODE lzo
	,feettopropertyline VARCHAR(255) NOT NULL  ENCODE lzo
	,galvanizedpipeind VARCHAR(255) NOT NULL  ENCODE lzo
	,workerscompinservant INTEGER NOT NULL  ENCODE az64
	,workerscompoutservant INTEGER NOT NULL  ENCODE az64
	,liabilityterritorycd VARCHAR(255) NOT NULL  ENCODE lzo
	,premisesliabilitymedpayind VARCHAR(255) NOT NULL  ENCODE lzo
	,relatedprivatestructureexclusion VARCHAR(255) NOT NULL  ENCODE lzo
	,vandalismexclusion VARCHAR(255) NOT NULL  ENCODE lzo
	,vandalismind VARCHAR(255) NOT NULL  ENCODE lzo
	,roofexclusion VARCHAR(255) NOT NULL  ENCODE lzo
	,expandedreplacementcostind VARCHAR(255) NOT NULL  ENCODE lzo
	,replacementvalueind VARCHAR(255) NOT NULL  ENCODE lzo
	,otherpolicynumber1 VARCHAR(255) NOT NULL  ENCODE lzo
	,otherpolicynumber2 VARCHAR(255) NOT NULL  ENCODE lzo
	,otherpolicynumber3 VARCHAR(255) NOT NULL  ENCODE lzo
	,primarypolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,otherpolicynumbers VARCHAR(255) NOT NULL  ENCODE lzo
	,reportedfirehazardscore VARCHAR(255) NOT NULL  ENCODE bytedict
	,firehazardscore VARCHAR(255) NOT NULL  ENCODE lzo
	,reportedsteepslopeind VARCHAR(255) NOT NULL  ENCODE lzo
	,steepslopeind VARCHAR(255) NOT NULL  ENCODE lzo
	,reportedhomereplacementcost INTEGER NOT NULL  ENCODE az64
	,reportedprotectionclass VARCHAR(255) NOT NULL  ENCODE lzo
	,earthquakezone VARCHAR(255) NOT NULL  ENCODE lzo
	,mmiscore VARCHAR(255) NOT NULL  ENCODE lzo
	,homeinspectiondiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,ratingtier VARCHAR(255) NOT NULL  ENCODE bytedict
	,soiltypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,reportedfirelineassessment VARCHAR(255) NOT NULL  ENCODE lzo
	,aaisfireprotectionclass VARCHAR(255) NOT NULL  ENCODE lzo
	,inspectionscore VARCHAR(255) NOT NULL  ENCODE lzo
	,equipmentbreakdown VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyindumbrella VARCHAR(255) NOT NULL  ENCODE lzo
	,poolind VARCHAR(255) NOT NULL  ENCODE lzo
	,studsuprenovation VARCHAR(255) NOT NULL  ENCODE lzo
	,studsuprenovationcompleteyear VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicynumberumbrella VARCHAR(255) NOT NULL  ENCODE lzo
	,rctmsbamt VARCHAR(255) NOT NULL  ENCODE lzo
	,rctmsbhomestyle VARCHAR(255) NOT NULL  ENCODE lzo
	,winsoverridenonsmokerdiscount VARCHAR(255) NOT NULL  ENCODE lzo
	,winsoverrideseniordiscount VARCHAR(255) NOT NULL  ENCODE lzo
	,itv INTEGER NOT NULL  ENCODE az64
	,itvdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,msbreporttype VARCHAR(255) NOT NULL  ENCODE lzo
	,vandalismdesiredind VARCHAR(255) NOT NULL  ENCODE lzo
	,cseagent VARCHAR(3) NOT NULL  ENCODE lzo
	,propertymanager VARCHAR(3) NOT NULL  ENCODE lzo
	,rentersinsurance VARCHAR(3) NOT NULL  ENCODE lzo
	,waterdetectiondevice VARCHAR(3) NOT NULL  ENCODE lzo
	,autohomeind VARCHAR(3) NOT NULL  ENCODE lzo
	,earthquakeumbrellaind VARCHAR(3) NOT NULL  ENCODE lzo
	,landlordind VARCHAR(3) NOT NULL  ENCODE lzo
	,lossassessment VARCHAR(16) NOT NULL  ENCODE lzo
	,gasshutoffind VARCHAR(4) NOT NULL  ENCODE lzo
	,waterded VARCHAR(16) NOT NULL  ENCODE bytedict
	,serviceline VARCHAR(4) NOT NULL  ENCODE lzo
	,functionalreplacementcost VARCHAR(4) NOT NULL  ENCODE lzo
	,covaddrr_secondaryresidence VARCHAR(3) NOT NULL  ENCODE lzo
	,covaddrrprem_secondaryresidence NUMERIC(13,2) NOT NULL  ENCODE az64
	,hodeluxe VARCHAR(3) NOT NULL  ENCODE lzo
	,latitude NUMERIC(18,12) NOT NULL  ENCODE az64
	,longitude NUMERIC(18,12) NOT NULL  ENCODE az64
	,wuiclass VARCHAR(30) NOT NULL  ENCODE bytedict
	,censusblock VARCHAR(30) NOT NULL  ENCODE lzo
	,waterriskscore INTEGER NOT NULL  ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,landlordlosspreventionservices VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,enhancedwatercoverage VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,landlordproperty VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,liabilityextendedtoothers VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,lossofuseextendedtime VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,onpremisestheft INTEGER  DEFAULT 0 ENCODE az64
	,bedbugmitigation VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,habitabilityexclusion VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,wildfirehazardpotential VARCHAR(20)  DEFAULT '~'::character varying ENCODE lzo
	,backupofsewersanddrains INTEGER  DEFAULT 0 ENCODE az64
	,vegetationsetbackft INTEGER  DEFAULT 0 ENCODE az64
	,yarddebriscoveragearea INTEGER  DEFAULT 0 ENCODE az64
	,yarddebriscoveragepercentage VARCHAR(5)  DEFAULT '~'::character varying ENCODE lzo
	,capetrampoline VARCHAR(16)  DEFAULT '~'::character varying ENCODE lzo
	,capepool VARCHAR(16)  DEFAULT '~'::character varying ENCODE lzo
	,roofconditionrating VARCHAR(16)  DEFAULT '~'::character varying ENCODE lzo
	,trampolineind VARCHAR(16)  DEFAULT '~'::character varying ENCODE lzo
	,plumbingmaterial VARCHAR(16)  DEFAULT '~'::character varying ENCODE lzo
	,centralizedheating VARCHAR(16)  DEFAULT '~'::character varying ENCODE lzo
	,firedistrictsubscriptioncode VARCHAR(8)  DEFAULT '~'::character varying ENCODE lzo
	,roofcondition VARCHAR(20)  DEFAULT '~'::character varying ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_app_building owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_app_building IS 'Source: Building, Addr DW Table type: Dimension Type 1 Table description: Quotes and Applications Property and related policy attributes(rating variables and coverage limits or deductibles)';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.status IS 'Current status of the Building record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.bldgnumber IS 'Unique number identifying the building within a line.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.constructioncd IS 'from first or largest percentage(CA SFG) % in MSB RCT data report';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.roofcd IS 'Code describing the type of roof.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.yearbuilt IS 'Year the building construction was completed.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.sqft IS 'Total square footage of the building.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.stories IS 'Number of building stories.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.units IS 'Number of building units.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.occupancycd IS 'Code describing the building occupancy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covalimit IS 'Coverage A Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covblimit IS 'Coverage B Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covclimit IS 'Coverages:   PP,CovC  -  C - Personal Property Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covdlimit IS 'Coverages:   LOU,CovD  -  D - Loss of Use, D - Fair Rental Value Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covelimit IS 'Coverages: ALEXP,PL,CovE  -  E - Personal Liability, E - Additional Living Expense Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covflimit IS 'Coverages: MEDPAY,MEDPM,CovF  -  F - Medical Payments to Others Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covblimitincrease IS 'The column is NOT populated consistently and correctly. It''s 0 when CovB(OS) is a standard 10% of CovA and populated if a non standard limit. The name of the column is close to INCB coverage description but it is not supposed to be populated for INCB. On the other hand, there are sometimes mid-term policy changes with numbers which match INCB coverage limit.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.ordinanceorlawpct IS 'Coverages: F.30630,BOLAW,F.30655  -  Building Ordinance or Law Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.feettofirehydrant IS 'Distance to Fire Station,  mapped from PPC data report';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.roofpitch IS 'from MSB RCT data report Roof Style/Slope: Flat to Flat or all other in MSB RCT to Slant in SPINN';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.foundation IS 'Mapped from MSB RCT. Slab in SPINN: Slab at Grade; Basement, Daylight; Basement, Walkout; Basement, Below Grade; Crawl Space Unexcavated; rawl Space, Excavated. Piers or Posts  in SPINN: Piers; Hillside; Hillside Slope';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.usagetype IS 'Only for value COC: COC, Course of Construction        Products:    CA-SG-DF3,CA-SG-DF6';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.homegardcreditind IS 'Coverages: HomeGard      Determines whether to rate with credit Products:    CA-ICO-HO3 ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.numlosses IS 'Number of losses within the past 3 years. Used for QuickQuote.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covalimitincrease IS 'CovALimitIncrease';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.covalimitincluded IS 'CovALimitIncluded';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.safeguardplusind IS 'Indicates Safeguard Plus Endorsement is selected.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.replacementcostdwellingind IS 'Coverages: FVREP  D515ST1    Extended Replacement Cost Dwelling Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3. 150, 175 or other numbers representg the percentage of the replacement cost';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.feettopropertyline IS 'Feet to property line';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.galvanizedpipeind IS 'Type of plumbing pipes';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.workerscompinservant IS 'Coverages: WCPIN,  H090CA0-Inservant  -  Workers Compensation - Inservant Products:    CA-ICO-HO3      CA-ICO-DF3,CA-SG-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.workerscompoutservant IS 'Coverages: WCPOT,  H090CA0-Outservant  -  Workers Compensation - Outservant Products:    CA-ICO-HO3      CA-ICO-DF3,CA-SG-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.premisesliabilitymedpayind IS 'Indicator for Premises Liability Med Pay (OL&amp;T)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.reportedfirehazardscore IS 'Score designation for Fire Hazard Assessment retrieved from Data Report.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.firehazardscore IS 'Score for Fire Hazard Assessment.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.reportedsteepslopeind IS 'Indicates whether the slope is over 35 degrees and retrieved from Data Report in ISO Fireline slope sub-score.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.steepslopeind IS 'It`s a flag to indicate if Slope over 35 Degrees in ISO Fireline slope sub-score. If ReportedSteepSlopeInd is "S3,S4,S5" the value will be set to “Yes”.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.reportedhomereplacementcost IS 'Replacement Cost Value returned by AIR.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.reportedprotectionclass IS 'Protection class number retrieved from Data Report.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.mmiscore IS 'The MMI Score.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.homeinspectiondiscountind IS 'Indicates whether a building qualifies for Home Inspection Discount.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.ratingtier IS 'Plus: LL1 - Landlord Plus Coverage Package; Premier: LL2 - Landlord Premier Coverage Package        Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.soiltypecd IS 'New Field to display Soil type for EarthQuake in Dwelling tab.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.reportedfirelineassessment IS 'Fire Hazard Assessment retrieved from Data Report.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.aaisfireprotectionclass IS 'AAIS Fire Protection Class.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.inspectionscore IS 'a measure of this property&apos;s likelihood of having an actionable inspection discovery';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.equipmentbreakdown IS 'Coverages: EQPBK      Equipment Breakdown Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.multipolicyindumbrella IS 'Umbrella Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.poolind IS 'The info is provided by agent. Not used in rules. There is an additional info in QuestionReply (not in Redshift DW) regarding standing step ladder, slide, spa and hot tube';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.studsuprenovation IS 'A renovation from-the-studs-up may qualify a building with an older original construction year for options available to newer construction.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.studsuprenovationcompleteyear IS 'A renovation from-the-studs-up may qualify a building with an older original construction year for options available to newer construction.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.multipolicynumberumbrella IS 'Umbrella Policy Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.rctmsbamt IS 'MSB RCT Amount';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.rctmsbhomestyle IS 'MSB RCT Home Style';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.winsoverridenonsmokerdiscount IS 'Indicator for applying non smoker discount for converted policies from WINS';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.winsoverrideseniordiscount IS 'Indicator for applying senior discount for converted policies from WINS';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.itv IS 'Field for storing the Pending Renewal CovALimit value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.itvdate IS 'Field for storing the date the MSB was ordered for ITV';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.msbreporttype IS 'Indicates whether MSB report received is HighValue or Mainstreet';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.vandalismdesiredind IS 'SEL FL-1 VAC/COC is issued without Vandalism coverage, though it may be added if the risk qualifies after an exterior/interior inspection. This indicator allows the insured to express the desire that Vandalism coverage be added if the risk qualifies, or to decline Vandalism up-front, in which case there is no need to order an interior inspection. See PCSInspectionReport.getInspectionCategory().';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.cseagent IS 'CSE Agent discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.propertymanager IS 'Property Manager discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.rentersinsurance IS 'Renters Insurance discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.waterdetectiondevice IS 'Water Detection Device discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.autohomeind IS 'Auto or Home Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.earthquakeumbrellaind IS 'Earthquake or Umbrella Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.landlordind IS 'Multiple Landlord Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.lossassessment IS 'Homeowners: Building.LossAssessment - Coverages:   LAC,H035ST0  -  Loss Assessment Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3 Dwelling - value of Limit1  (LAC coverage) from Limit table';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.gasshutoffind IS 'Gas Shut Off Valve Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.serviceline IS 'Coverages: UTLDB      Service Line Products:AZ-DF3,  CA-SG-DF3,  NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.functionalreplacementcost IS 'Coverages: FXRC      Functional Replacement Cost Products:    CA-SG-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.wuiclass IS 'Wildland Urban Interface Area value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.waterriskscore IS 'Water Risk Score value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.landlordlosspreventionservices IS 'CA SFG NX2 DF3; Landlord Loss Prevention Services checkbox; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.enhancedwatercoverage IS 'CA SFG NX2 DF3; Enhanced Water Coverage checkbox; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.landlordproperty IS 'CA SFG NX2 DF3; Landlord Property checkbox; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.liabilityextendedtoothers IS 'CA SFG NX2 DF3; Liability Extended to Others dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.lossofuseextendedtime IS 'CA SFG NX2 DF3; Loss of Use â€“ Extended Time dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.onpremisestheft IS 'CA SFG NX2 DF3; On Premises Theft dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.bedbugmitigation IS 'CA SFG NX2 DF3; Bed Bug Mitigation dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.habitabilityexclusion IS 'CA SFG NX2 DF3; Habitability Exclusion dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.wildfirehazardpotential IS 'CA SFG NX2 HO3 and CA SFG NX2 DF3; Wildfire Hazard Potential from Cape Analytics Data Report;  US21208 and US21592';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.backupofsewersanddrains IS ' 	CA SFG Homeguard , added Apr 2022;	SEWER coverage limit (Backup of Sewers and Drain)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.vegetationsetbackft IS ' 	Cape Analytics, added Apr 2022;	"Distance between the primary
structure perimeter and nearest
large vegetation.
Distance, measured in units of
feet. Returns null when attribute
is not available for a parcel.
“Large vegetation” is defined as
trees and large bushes. Smaller
shrubs, lawns, and undergrowth
are excluded."';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.yarddebriscoveragearea IS ' 	Cape Analytics, added Apr 2022;	"Square footage value and ratio
of yard covered by debris (e.g.
junk cars, appliances,
construction materials,
disorganized piles).
Yard Debris returns are limited
to parcels with area less than
500,000 sqft. In cases in which
parcel area is greater than that
limit, the response will be NULL."';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.yarddebriscoveragepercentage IS ' 	Cape Analytics, added Apr 2022;	"Square footage value and ratio
of yard covered by debris (e.g.
junk cars, appliances,
construction materials,
disorganized piles).
Yard Debris returns are limited
to parcels with area less than
500,000 sqft. In cases in which
parcel area is greater than that
limit, the response will be NULL."';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.capetrampoline IS ' 	Cape Analytics, added Apr 2022; There is also one CSE Rule that use this field in the condition. (US20225);	Detects presence of a trampoline on a parcel. with_trampoline - one or more trampolines were detected on the parcel; no_trampoline - no trampolines were detected on the parcel; unknown - cape is unable to determine whether or not';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.capepool IS ' 	Cape Analytics, added Apr 2022;	Detects presence of an in ground or above- ground pool on a property. with_pool - home has a pool; no_pool - home does not have a pool; ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.roofconditionrating IS ' 	Cape Analytics, added Apr 2022;	"Severity rating of the exterior roof condition. 
2 - Excellent - No visible signs of roof defects; 
1 - Good - Minimal signs of defects that are not visibly pronounced. Minor discoloration and/or cosmetic flaws; 
0 - Fair - Visible defects that are not as strongly pronounced or as clearly obvious as a poor roof (-1). Faint or localized streaking/discoloration; 
-1 - Poor - Obvious, pronounced signs of defects that affect the function and safety of the roof. Large patches of streaking/discoloration, or warped shingles
-2 - Severe - Obvious, pronounced signs of defects that significantly affect the function and safety of the roof. Tarp on the roof, missing shingles, organic matter, patches from repair, visible damage, or signs of ponding unknown - Property visibly obstructed, often by trees or shadow. Cape is unable to provide a rating with sufficient confidence"';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.trampolineind IS ' 	CA SFG Homeguard , added Apr 2022;	The info is provided by agent. Not used in rules. There is an additional info in QuestionReply (not in Redshift DW) regarding a trampoline safety net enclosure.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.plumbingmaterial IS ' 	CA SFG Homeguard , added Apr 2022;	is used in CA SFG HO3 instead of galvanizedpipeind and  copperpipesind';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.centralizedheating IS ' 	CA SFG Homeguard , added Apr 2022;	Centralized or thermostatically controlled heating system:';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_building.firedistrictsubscriptioncode IS ' 	CA SFG Homeguard , added Apr 2022;	mapped from PPC: S indicates the Risk address is within a subscription fire protection area. T indicates, it doesn’t have a subscription.';


-- fsbi_dw_spinn.dim_app_driver definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_app_driver;

--DROP TABLE fsbi_dw_spinn.dim_app_driver;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_app_driver
(
	driver_app_id INTEGER NOT NULL  ENCODE RAW
	,application_id INTEGER NOT NULL  ENCODE az64
	,spinndriver_id VARCHAR(255) NOT NULL  ENCODE lzo
	,driver_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE lzo
	,driverinfocd VARCHAR(255) NOT NULL  ENCODE lzo
	,drivernumber BIGINT NOT NULL  ENCODE az64
	,drivertypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,driverstatuscd VARCHAR(255) NOT NULL  ENCODE bytedict
	,licensenumber VARCHAR(255) NOT NULL  ENCODE lzo
	,licensedt VARCHAR(23) NOT NULL  ENCODE lzo
	,licensedstateprovcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,relationshiptoinsuredcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,scholasticdiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,mvrrequestind VARCHAR(255) NOT NULL  ENCODE bytedict
	,mvrstatusdt DATE NOT NULL  ENCODE az64
	,mvrstatus VARCHAR(255) NOT NULL  ENCODE bytedict
	,maturedriverind VARCHAR(255) NOT NULL  ENCODE bytedict
	,drivertrainingind VARCHAR(255) NOT NULL  ENCODE lzo
	,gooddriverind VARCHAR(255) NOT NULL  ENCODE bytedict
	,accidentpreventioncoursecompletiondt DATE NOT NULL  ENCODE az64
	,drivertrainingcompletiondt DATE NOT NULL  ENCODE az64
	,accidentpreventioncourseind VARCHAR(255) NOT NULL  ENCODE lzo
	,scholasticcertificationdt DATE NOT NULL  ENCODE az64
	,activemilitaryind VARCHAR(255) NOT NULL  ENCODE lzo
	,permanentlicenseind VARCHAR(255) NOT NULL  ENCODE bytedict
	,newtostateind VARCHAR(255) NOT NULL  ENCODE lzo
	,persontypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,gendercd VARCHAR(10) NOT NULL  ENCODE bytedict
	,birthdt DATE NOT NULL  ENCODE az64
	,maritalstatuscd VARCHAR(255) NOT NULL  ENCODE bytedict
	,occupationclasscd VARCHAR(255) NOT NULL  ENCODE lzo
	,newteenexpirationdt DATE NOT NULL  ENCODE az64
	,attachedvehicleref VARCHAR(255) NOT NULL  ENCODE lzo
	,viol_pointschargedterm INTEGER NOT NULL  ENCODE az64
	,acci_pointschargedterm INTEGER NOT NULL  ENCODE az64
	,other_pointschargedterm INTEGER NOT NULL  ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,sr22feeind VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,maturecertificationdt TIMESTAMP WITHOUT TIME ZONE  DEFAULT '1900-01-01 00:00:00'::timestamp without time zone ENCODE az64
	,gooddriverpoints_chargedterm INTEGER  DEFAULT 0 ENCODE az64
	,agefirstlicensed INTEGER  DEFAULT 0 ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_app_driver owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_app_driver IS 'Source: DriverInfo, DriverPoints, PartyInfo, PersonInfo DW Table type: Dimension Type 1 Table description: Quotes  and Application Drivers attributes';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.status IS 'Current status of the Driver record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.drivernumber IS 'Sequential number indicating in what order the driver was added to the policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.licensedstateprovcd IS 'State the driver is licensed in.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.sr22feeind IS 'CA SFG Auto, added Apr 2021;	SR 22 Filing Fee applies';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.maturecertificationdt IS 'CA SFG Auto, added Apr 2021;	Mature Certificationc  date See also MatureDriverInd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.gooddriverpoints_chargedterm IS 'CA SFG Auto, added Apr 2021;	points for the good driver';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_driver.agefirstlicensed IS 'used in Portal Quick Quote';


-- fsbi_dw_spinn.dim_app_insured definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_app_insured;

--DROP TABLE fsbi_dw_spinn.dim_app_insured;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_app_insured
(
	application_id INTEGER NOT NULL  ENCODE RAW
	,application_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,name VARCHAR(200) NOT NULL  ENCODE lzo
	,commercial_name VARCHAR(200) NOT NULL  ENCODE lzo
	,dob DATE NOT NULL  ENCODE az64
	,gender VARCHAR(10) NOT NULL  ENCODE lzo
	,maritalstatus VARCHAR(255) NOT NULL  ENCODE bytedict
	,address1 VARCHAR(255) NOT NULL  ENCODE lzo
	,address2 VARCHAR(255) NOT NULL  ENCODE lzo
	,county VARCHAR(255) NOT NULL  ENCODE lzo
	,city VARCHAR(255) NOT NULL  ENCODE lzo
	,state VARCHAR(255) NOT NULL  ENCODE bytedict
	,postalcode VARCHAR(20) NOT NULL  ENCODE lzo
	,telephone VARCHAR(255) NOT NULL  ENCODE lzo
	,mobile VARCHAR(255) NOT NULL  ENCODE lzo
	,email VARCHAR(255) NOT NULL  ENCODE lzo
	,insurancescore VARCHAR(255) NOT NULL  ENCODE lzo
	,overriddeninsurancescore VARCHAR(255) NOT NULL  ENCODE bytedict
	,applieddt DATE NOT NULL  ENCODE az64
	,insurancescorevalue VARCHAR(5) NOT NULL  ENCODE lzo
	,ratepageeffectivedt DATE NOT NULL  ENCODE az64
	,insscoretiervalueband VARCHAR(20) NOT NULL  ENCODE lzo
	,financialstabilitytier VARCHAR(20) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_app_insured owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_app_insured IS 'Source:Insured, ParttyInfo, NameInfo, PersonInfo, Addr, AllContacts, InsuranceScore DW Table type: Dimension Type 1 Table description: Quotes and Applications Insured info including mailing address and scores';


-- fsbi_dw_spinn.dim_app_vehicle definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_app_vehicle;

--DROP TABLE fsbi_dw_spinn.dim_app_vehicle;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_app_vehicle
(
	vehicle_app_id INTEGER NOT NULL  ENCODE RAW
	,application_id INTEGER NOT NULL  ENCODE az64
	,spinnvehicle_id VARCHAR(255) NOT NULL  ENCODE lzo
	,vehicle_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,stateprovcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,county VARCHAR(255) NOT NULL  ENCODE lzo
	,postalcode VARCHAR(255) NOT NULL  ENCODE lzo
	,city VARCHAR(255) NOT NULL  ENCODE lzo
	,addr1 VARCHAR(1023) NOT NULL  ENCODE lzo
	,addr2 VARCHAR(255) NOT NULL  ENCODE lzo
	,latitude NUMERIC(18,12) NOT NULL  ENCODE az64
	,longitude NUMERIC(18,12) NOT NULL  ENCODE az64
	,garagaddrflg VARCHAR(3) NOT NULL  ENCODE lzo
	,garagpostalcode VARCHAR(255) NOT NULL  ENCODE lzo
	,garagpostalcodeflg VARCHAR(3) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE bytedict
	,manufacturer VARCHAR(255) NOT NULL  ENCODE lzo
	,"model" VARCHAR(255) NOT NULL  ENCODE lzo
	,modelyr VARCHAR(10) NOT NULL  ENCODE bytedict
	,vehidentificationnumber VARCHAR(255) NOT NULL  ENCODE lzo
	,validvinind VARCHAR(255) NOT NULL  ENCODE lzo
	,vehlicensenumber VARCHAR(255) NOT NULL  ENCODE lzo
	,registrationstateprovcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,vehbodytypecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,performancecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,restraintcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,antibrakingsystemcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,antitheftcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,enginesize VARCHAR(255) NOT NULL  ENCODE bytedict
	,enginecylinders VARCHAR(255) NOT NULL  ENCODE bytedict
	,enginehorsepower VARCHAR(255) NOT NULL  ENCODE lzo
	,enginetype VARCHAR(255) NOT NULL  ENCODE bytedict
	,vehusecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,garageterritory INTEGER NOT NULL  ENCODE az64
	,collisionded VARCHAR(255) NOT NULL  ENCODE bytedict
	,comprehensiveded VARCHAR(255) NOT NULL  ENCODE bytedict
	,statedamt NUMERIC(28,6) NOT NULL  ENCODE az64
	,classcd VARCHAR(255) NOT NULL  ENCODE lzo
	,ratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,costnewamt NUMERIC(28,6) NOT NULL  ENCODE az64
	,estimatedannualdistance INTEGER NOT NULL  ENCODE az64
	,estimatedworkdistance INTEGER NOT NULL  ENCODE az64
	,leasedvehind VARCHAR(255) NOT NULL  ENCODE bytedict
	,purchasedt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,statedamtind VARCHAR(255) NOT NULL  ENCODE lzo
	,neworusedind VARCHAR(255) NOT NULL  ENCODE bytedict
	,carpoolind VARCHAR(255) NOT NULL  ENCODE bytedict
	,odometerreading VARCHAR(10) NOT NULL  ENCODE lzo
	,weekspermonthdriven VARCHAR(255) NOT NULL  ENCODE bytedict
	,daylightrunninglightsind VARCHAR(255) NOT NULL  ENCODE bytedict
	,passiveseatbeltind VARCHAR(255) NOT NULL  ENCODE bytedict
	,daysperweekdriven VARCHAR(255) NOT NULL  ENCODE bytedict
	,umpdlimit VARCHAR(255) NOT NULL  ENCODE bytedict
	,towingandlaborind VARCHAR(255) NOT NULL  ENCODE bytedict
	,rentalreimbursementind VARCHAR(255) NOT NULL  ENCODE bytedict
	,liabilitywaiveind VARCHAR(255) NOT NULL  ENCODE lzo
	,ratefeesind VARCHAR(255) NOT NULL  ENCODE bytedict
	,optionalequipmentvalue INTEGER NOT NULL  ENCODE az64
	,customizingequipmentind VARCHAR(255) NOT NULL  ENCODE bytedict
	,customizingequipmentdesc VARCHAR(255) NOT NULL  ENCODE lzo
	,invalidvinacknowledgementind VARCHAR(255) NOT NULL  ENCODE bytedict
	,ignoreumpdwcdind VARCHAR(255) NOT NULL  ENCODE lzo
	,recalculateratingsymbolind VARCHAR(255) NOT NULL  ENCODE lzo
	,programtypecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,cmpratingvalue VARCHAR(255) NOT NULL  ENCODE lzo
	,colratingvalue VARCHAR(255) NOT NULL  ENCODE lzo
	,liabilityratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,medpayratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,racmpratingvalue VARCHAR(255) NOT NULL  ENCODE lzo
	,racolratingvalue VARCHAR(255) NOT NULL  ENCODE lzo
	,rabiratingsymbol VARCHAR(255) NOT NULL  ENCODE lzo
	,rapdratingsymbol VARCHAR(255) NOT NULL  ENCODE lzo
	,ramedpayratingsymbol VARCHAR(255) NOT NULL  ENCODE lzo
	,estimatedannualdistanceoverride VARCHAR(5) NOT NULL  ENCODE lzo
	,originalestimatedannualmiles VARCHAR(12) NOT NULL  ENCODE lzo
	,reportedmileagenonsave VARCHAR(12) NOT NULL  ENCODE lzo
	,mileage VARCHAR(12) NOT NULL  ENCODE bytedict
	,estimatednoncommutemiles VARCHAR(12) NOT NULL  ENCODE lzo
	,titlehistoryissue VARCHAR(3) NOT NULL  ENCODE bytedict
	,bundle VARCHAR(15) NOT NULL  ENCODE bytedict
	,loanleasegap VARCHAR(3) NOT NULL  ENCODE bytedict
	,equivalentreplacementcost VARCHAR(3) NOT NULL  ENCODE bytedict
	,originalequipmentmanufacturer VARCHAR(3) NOT NULL  ENCODE bytedict
	,optionalrideshare VARCHAR(3) NOT NULL  ENCODE bytedict
	,medicalpartsaccessibility VARCHAR(4) NOT NULL  ENCODE bytedict
	,vehnumber INTEGER NOT NULL  ENCODE az64
	,odometerreadingprior VARCHAR(10) NOT NULL  ENCODE lzo
	,reportedmileagenonsavedtprior DATE NOT NULL  ENCODE az64
	,fullglasscovind VARCHAR(3) NOT NULL  ENCODE bytedict
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,replacementof INTEGER  DEFAULT 0 ENCODE az64
	,reportedmileagenonsavedt DATE  DEFAULT '1900-01-01'::date ENCODE az64
	,manufacturersymbol VARCHAR(4)  DEFAULT '~'::character varying ENCODE bytedict
	,modelsymbol VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,bodystylesymbol VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,symbolcode VARCHAR(12)  DEFAULT '~'::character varying ENCODE lzo
	,verifiedmileageoverride VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_app_vehicle owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_app_vehicle IS 'Source: Vehicle, Addr DW Table type: Dimension Type 1 Table description:Quotes and Application Vehicle and related policy attributes(rating variables and coverage limits or deductibles)';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.stateprovcd IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) State';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.county IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) County';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.postalcode IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) PostalCode';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.city IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) City';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.addr1 IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Addr1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.addr2 IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Addr2';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.latitude IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Latitude';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.longitude IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Longitude';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.garagaddrflg IS 'Flag indicating if VehicleGarageAddr (Yes) or InsuredLookupAddr (No) is used in address columns based on availability ALL VehicleGarageAddr 4 columns - State, PostalCode, City and Addr1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.garagpostalcode IS 'VehicleGarageAddr Postal Code even if State, City and Addr1 are not available. InsuredLookupAddr Postal Code if there is no VehicleGarageAddr Postal Code.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.garagpostalcodeflg IS 'Flag indicating if VehicleGarageAddr or InsuredLookupAddr Postal Code is used in GaragPostalCode.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.status IS 'Current status of the Vehicle record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.manufacturer IS 'Vehicle manufacturer.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle."model" IS 'Vehicle model.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.modelyr IS 'Vehicle model year.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.vehidentificationnumber IS 'Vehicle identification number.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.validvinind IS 'Indicates if the vehicle contains a valid vin';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.vehlicensenumber IS 'Vehicle license plate number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.registrationstateprovcd IS 'State the vehicle is registered in.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.vehbodytypecd IS 'Code describing the vehicle body type.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.performancecd IS 'Vehicle performance (i.e. Standard, Intermediate, Sport, High)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.restraintcd IS 'Restaint system (i.e. Seat Belts, Air Bags)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.antibrakingsystemcd IS 'Anti-braking system (i.e. 2 Wheel, 4 Wheel)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.antitheftcd IS 'Anti-Theft (i.e. Alarm)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.enginesize IS 'Engine Size in Liters';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.enginecylinders IS 'Number for Engine Cylinders';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.enginehorsepower IS 'Engine Horse Power';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.enginetype IS 'Engine Type';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.vehusecd IS 'Code describing the vehicle use.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.garageterritory IS 'Territory the vehicle is garaged in';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.collisionded IS 'Covereges: COLL, Collision  -  Collision Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.comprehensiveded IS 'Covereges: COMP, Comprehensive  -  Comprehensive Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.statedamt IS 'Stated amount that the vehicle is worth';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.classcd IS 'The class code of the vehicle.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.ratingvalue IS 'The vehicle&apos;s rating value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.costnewamt IS 'Cost if this vehicle was purchased new.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.estimatedannualdistance IS 'Estimated annual distance driven.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.estimatedworkdistance IS 'Estimated distance to work one way';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.leasedvehind IS 'Indicates if this is a leased vehicle.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.purchasedt IS 'Date vehicle was purchased.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.statedamtind IS 'Covereges: MPREM  -  Stated Amount Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.neworusedind IS 'Indicates if the vehicle is new or used';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.carpoolind IS 'Indicates if a car pool is used';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.odometerreading IS 'Odometer reading of the vehicle';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.weekspermonthdriven IS 'Weeks per month the vehicle is driven';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.daylightrunninglightsind IS 'Indicates if daylight running lights are equipment.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.passiveseatbeltind IS 'Indicates if passive seat belts are present';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.daysperweekdriven IS 'Number of Days per Week driven';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.umpdlimit IS 'UMPD Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.towingandlaborind IS 'Covereges: ROAD  -  Roadside Assistance Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.rentalreimbursementind IS 'Covereges: RREIM, RentalReimbursement  -  Rental Reimbursement Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.invalidvinacknowledgementind IS 'Indicator to determine if a user acknowledges that they entered an invalid VIN.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.ignoreumpdwcdind IS 'Used to ignore the UMPD/WCD coverage validation for WINS policy types';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.recalculateratingsymbolind IS 'Used for conversion to determine when to recalculate/retrieve rating symbol.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.programtypecd IS 'Field that indicates that the vehicle is included in the SAVE Program. Value will be used to: determine which SAVE Mileage factors and Annual Mileage factors to use; determine what fields should display on the vehicle detail screen.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.cmpratingvalue IS 'Comprehensive Rating Value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.colratingvalue IS 'Collision Rating Value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.liabilityratingvalue IS 'ISO Liability Rating Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.medpayratingvalue IS 'ISO Med Pay Rating Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.racmpratingvalue IS 'Risk Analyser Comprehensive Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.racolratingvalue IS 'Risk Analyzer Collision Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.rabiratingsymbol IS 'Risk Analyzer Bodily Injury Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.rapdratingsymbol IS 'Risk Analyzer Property Damage Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.ramedpayratingsymbol IS 'Risk Analyzer Medical Payment Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.estimatedannualdistanceoverride IS 'Field that determines how the EstimatedAnnualDistance value will be set if ProgramTypeCd = Save&quot;.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.originalestimatedannualmiles IS 'Field that indicates the originally estimated Annual Miles to be driven for that policy term. Value will assist in determining EstimatedAnnualDistance. Note: This field is separate from the EstimatedAnnualDistance because this value must be retained even if the EstimatedAnnualDistance changes.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.reportedmileagenonsave IS 'Mileage Reported as response to the Annual Mileage questionnaires correspondence.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.mileage IS 'Mileage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.estimatednoncommutemiles IS 'Estimated number of miles driven for pleasure or other purposes';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.titlehistoryissue IS 'Title Salvage History issue reported by Carfax';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.bundle IS 'Bundle';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.loanleasegap IS 'Covereges: LOAN  -  Loan Lease Gap Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.equivalentreplacementcost IS 'Covereges: RRGAP  -  Equivalent Replacement Cost Products: AZ-ICO,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.originalequipmentmanufacturer IS 'Covereges: OEM  -  Original Equipment Manufacturer Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.optionalrideshare IS 'Covereges: RIDESH  -  Rideshare Products: AZ-ICO,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.medicalpartsaccessibility IS 'Covereges: CUSTE  -  Medical Parts and Accessibility Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.vehnumber IS 'Unique number identifying the vehicle within the line.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.odometerreadingprior IS 'Prior odometer reading of the vehicle';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.reportedmileagenonsavedtprior IS 'Prior date of the mileage reported as response to the Annual Mileage questionnaires correspondence';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.fullglasscovind IS 'Covereges: GLASA  -  Full Glass Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.replacementof IS 'Replaced Vehicle Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.reportedmileagenonsavedt IS 'CA SFG Auto, added Apr 2021;	Odometer Date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.manufacturersymbol IS 'CA SFG Auto, added Apr 2021;	code of the Manufacturer ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.modelsymbol IS 'CA SFG Auto, added Apr 2021;	code of the Model';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.bodystylesymbol IS 'CA SFG Auto, added Apr 2021;	code of the Body Style';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.symbolcode IS 'CA SFG Auto, added Apr 2021;	combined code of the ManufacturerSymbol,ModelSymbol and BodyStyleSymbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_app_vehicle.verifiedmileageoverride IS ' 	CA SFG Auto; Verified Mileage Override dropdown; Saved in Application/Line/Risk/Vehicle or Policy/Line/Risk/Vehicle ;  US21847		 ';


-- fsbi_dw_spinn.dim_application definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_application;

--DROP TABLE fsbi_dw_spinn.dim_application;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_application
(
	application_id INTEGER NOT NULL  ENCODE RAW
	,application_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,applicationnumber VARCHAR(255) NOT NULL  ENCODE lzo
	,applicationtype VARCHAR(255) NOT NULL  ENCODE bytedict
	,transactioncd VARCHAR(255) NOT NULL  ENCODE bytedict
	,statecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,effectivedt DATE NOT NULL  ENCODE az64
	,expirationdt DATE NOT NULL  ENCODE az64
	,affinitygroupcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,batchquotesourcecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,bilimit VARCHAR(255) NOT NULL  ENCODE bytedict
	,businesssourcecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,canceldt DATE NOT NULL  ENCODE az64
	,carriergroupcd VARCHAR(255) NOT NULL  ENCODE lzo
	,cseemployeediscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,fullpaydiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,glaggregatelimit VARCHAR(255) NOT NULL  ENCODE lzo
	,gloccurrencelimit VARCHAR(255) NOT NULL  ENCODE lzo
	,homerelatedpolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,inceptiondt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,landlordind VARCHAR(255) NOT NULL  ENCODE lzo
	,liabilitylimitcpl VARCHAR(255) NOT NULL  ENCODE bytedict
	,liabilitylimitolt VARCHAR(255) NOT NULL  ENCODE bytedict
	,liabilityreductionind VARCHAR(255) NOT NULL  ENCODE lzo
	,medpaylimit VARCHAR(255) NOT NULL  ENCODE bytedict
	,multicardiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyautodiscount VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyautonumber VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicydiscount VARCHAR(3) NOT NULL  ENCODE bytedict
	,multipolicyhomediscount VARCHAR(255) NOT NULL  ENCODE bytedict
	,multipolicyumbrelladiscount VARCHAR(255) NOT NULL  ENCODE lzo
	,payplancd VARCHAR(255) NOT NULL  ENCODE lzo
	,pdlimit VARCHAR(255) NOT NULL  ENCODE bytedict
	,persistencydiscountdt DATE NOT NULL  ENCODE az64
	,personalinjuryind VARCHAR(255) NOT NULL  ENCODE lzo
	,personalliabilitylimit VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_spinn_status VARCHAR(255) NOT NULL  ENCODE bytedict
	,policyformcode VARCHAR(255) NOT NULL  ENCODE bytedict
	,previouscarriercd VARCHAR(255) NOT NULL  ENCODE lzo
	,previouspolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,primarypolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,priorpolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,producer_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,product_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,company_uniqueid VARCHAR(100) NOT NULL  ENCODE bytedict
	,programind VARCHAR(255) NOT NULL  ENCODE bytedict
	,quotenumber VARCHAR(255) NOT NULL  ENCODE lzo
	,reinstatedt DATE NOT NULL  ENCODE az64
	,relatedpolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,renewaltermcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,rewritefrompolicyref VARCHAR(255) NOT NULL  ENCODE lzo
	,rewritepolicyref VARCHAR(255) NOT NULL  ENCODE lzo
	,subtypecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,termdays INTEGER NOT NULL  ENCODE az64
	,twopaydiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,umbilimit VARCHAR(255) NOT NULL  ENCODE bytedict
	,umbrellarelatedpolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,waivepolicyfeeind VARCHAR(255) NOT NULL  ENCODE bytedict
	,closereasoncd VARCHAR(255) NOT NULL  ENCODE lzo
	,closesubreasoncd VARCHAR(255) NOT NULL  ENCODE lzo
	,closecomment VARCHAR(255) NOT NULL  ENCODE lzo
	,applicationstatus VARCHAR(255) NOT NULL  ENCODE bytedict
	,quotestatus VARCHAR(255) NOT NULL  ENCODE bytedict
	,assigned INTEGER NOT NULL  ENCODE az64
	,submitted INTEGER NOT NULL  ENCODE az64
	,approvalinprogress INTEGER NOT NULL  ENCODE az64
	,sendback INTEGER NOT NULL  ENCODE az64
	,unapproved INTEGER NOT NULL  ENCODE az64
	,approved INTEGER NOT NULL  ENCODE az64
	,rejected INTEGER NOT NULL  ENCODE az64
	,last_task_name VARCHAR(255) NOT NULL  ENCODE bytedict
	,last_completed_task_name VARCHAR(255) NOT NULL  ENCODE bytedict
	,validationerrors_ruleids VARCHAR(2000) NOT NULL  ENCODE lzo
	,validationerrors_msg VARCHAR(2000) NOT NULL  ENCODE lzo
	,original_policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,approved_policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,approved_policynumber VARCHAR(50) NOT NULL DEFAULT 'Unknown'::character varying ENCODE lzo
	,approved_policy_id INTEGER NOT NULL DEFAULT 0 ENCODE az64
	,approved_policybookdt DATE NOT NULL DEFAULT '1900-01-01'::date ENCODE az64
	,boundflg VARCHAR(1) NOT NULL DEFAULT 'N'::character varying ENCODE lzo
	,customer_uniqueid VARCHAR(100) NOT NULL DEFAULT 'Unknown'::character varying ENCODE lzo
	,lob VARCHAR(50) NOT NULL DEFAULT '~'::character varying ENCODE bytedict
	,vehiclelistconfirmedind VARCHAR(4)   ENCODE lzo
	,ratedind VARCHAR(4)   ENCODE lzo
	,altsubtypecd VARCHAR(32) NOT NULL DEFAULT '~'::character varying ENCODE bytedict
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,bc_basicpolicy_id VARCHAR(200) NOT NULL DEFAULT '~'::character varying ENCODE lzo
	,bc_basicpolicy_writtenpremiumamt NUMERIC(28,6) NOT NULL DEFAULT 0 ENCODE az64
	,bc_line_fulltermamt NUMERIC(28,6) NOT NULL DEFAULT 0 ENCODE az64
	,bc_line_finalpremiumamt NUMERIC(28,6) NOT NULL DEFAULT 0 ENCODE az64
	,bc_application_description VARCHAR(200) NOT NULL DEFAULT '~'::character varying ENCODE lzo
	,bc_quoteinfo_uniqueid INTEGER NOT NULL DEFAULT 0 ENCODE az64
	,bc_quoteinfo_adddt_tm TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1900-01-01 00:00:00'::timestamp without time zone ENCODE az64
	,bc_quoteinfo_updatedt_tm TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1900-01-01 00:00:00'::timestamp without time zone ENCODE az64
	,bc_quoyeinfo_adduser_uniqueid VARCHAR(255) NOT NULL DEFAULT 'Unknown'::character varying ENCODE lzo
	,bc_quoteinfo_updateuser_uniqueid VARCHAR(255) NOT NULL DEFAULT 'Unknown'::character varying ENCODE lzo
	,bc_application_updatetimestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,bc_quoteinfo_typecd VARCHAR(255)  DEFAULT '~'::character varying ENCODE bytedict
	,bc_basicpolicy_originalapplicationref VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_application owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_application IS 'Source:Appliaction, QuoteInfo, BasicPolicy,Task,Line, BasicPolicy, Building,Risk DW Table type: Dimension Type 1 Table description: Quotes and Applications base info';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_application.applicationnumber IS 'Unique identifying application number. Format is determined by product-setup.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.applicationtype IS 'prodcse_dw.Application.TypeCd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.transactioncd IS 'prodcse_dw.BasicPolicy.transactioncd: (i.e. Cancelled, Cancel Notice, On Hold)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.effectivedt IS 'prodcse_dw.BasicPolicy.effectivedt: Date the policy or transaction is effective';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.expirationdt IS 'prodcse_dw.BasicPolicy.expirationdt: Date the policy or transaction is no longer effective.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.affinitygroupcd IS 'prodcse_dw.BasicPolicy.affinitygroupcd: Affinity Group Code';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.batchquotesourcecd IS 'prodcse_dw.BasicPolicy.batchquotesourcecd: Code that determines from which company the quote has come from while loading though batch quote load.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bilimit IS 'Covereges: BISPL, BI - Bodily Injury Products: AZ-ICO , CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.businesssourcecd IS 'prodcse_dw.BasicPolicy.businesssourcecd: Source from which the business was original generated.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.canceldt IS 'prodcse_dw.BasicPolicy.canceldt: Last cancellation date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.carriergroupcd IS 'prodcse_dw.BasicPolicy.carriergroupcd: Carrier Group Code';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.cseemployeediscountind IS 'Line.CSEEmployeeDiscountInd for Auto or Building.EmployeeCreditInd for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.fullpaydiscountind IS 'prodcse_dw.Line.fullpaydiscountind: Specifies the Full Pay Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.glaggregatelimit IS 'prodcse_dw.Line.glaggregatelimit: General Liability Limit (aggregate)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.gloccurrencelimit IS 'prodcse_dw.Line.gloccurrencelimit: General Liability Limit (each occurrence)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.homerelatedpolicynumber IS 'PolicyNumber of a homeowners related policy for Auto - Line.RelatedPolicyNumber';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.inceptiondt IS 'prodcse_dw.BasicPolicy.inceptiondt: Original term&#8217;s effective date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.landlordind IS 'Building.LanLordInd discount if there are more then one DF policy/property insured by the same customer. Moved from risk level (Building) to policy level';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.liabilitylimitcpl IS 'prodcse_dw.Line.liabilitylimitcpl: Coverage L Liability limit for DF3, in general; in NXG Landlord policy also indicates whether DAU CPL coverage applies. (If both CPL and OLT apply, limits must match.)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.liabilitylimitolt IS 'Coverages: LIAB,D660ST1 - Premises Liability Products:AZ-DF3, CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.medpaylimit IS 'Coverages: MEDPAY Medical Payments to Others Products:AZ-DF3, CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.multicardiscountind IS 'prodcse_dw.Line.multicardiscountind: Override for Multi Car Discount on Single Car policies.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.multipolicyautodiscount IS 'Auto related policy indicator - Building..AutoHomeInd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.multipolicyautonumber IS 'PolicyNumber of Auto related policy - Building.MultiPolicyNumber or Building.OtherPolicyNumber1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.multipolicydiscount IS 'A multipolicy indicator if any type related policy exists based on: Line.MultiPolicyDiscountIn, Line.MultiPolicyDiscount2Ind for Auto and Building.MultiPolicyInd,Building.AutoHomeInd, Building.MultiPolicyIndUmbrella';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.multipolicyhomediscount IS 'Homeowners related policy indicator - Line.MultiPolicyHomeDiscount';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.multipolicyumbrelladiscount IS 'Umbrella related policy indicator - Line.PolicyDiscount2Ind for Auto or Building.MultiPolicyIndUmbrella for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.payplancd IS 'prodcse_dw.BasicPolicy.payplancd: Code describing the payment schedule defined for the policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.pdlimit IS 'Covereges: PD - Property Damage Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.personalinjuryind IS 'Coverages: PIHOM,F.31890 Personal Injury Products:AZ-DF3, CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.personalliabilitylimit IS 'prodcse_dw.Line.personalliabilitylimit: Personal Umbrella liability coverage limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.previouscarriercd IS 'prodcse_dw.BasicPolicy.previouscarriercd: Code describing the carrier prior to the current carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.previouspolicynumber IS 'prodcse_dw.BasicPolicy.previouspolicynumber: Policy number when business was with previous carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.primarypolicynumber IS 'Earthquake policy primary policy from Building.PrimaryPolicyNumber OR Umbrella policy underlying Auto policy (sometimes comma seprated list of auto policies)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.priorpolicynumber IS 'prodcse_dw.BasicPolicy.priorpolicynumber: Indicates the previous policy number when quote is loaded from other source using batch quote load.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.programind IS 'prodcse_dw.BasicPolicy.programind: Program CSE uses for rating in the Auto line but used in other lines for reference only.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.quotenumber IS 'Quotenumber is mostly available for all New Business applications(except the cases where a policy is cancelled or non-renewed and a new policy is created instead for the same customer and etc). For renewals,endorsements etc, it is populated as ~ . This field is populated from Quotenumber of BasicPolicy( SPINN table).';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.reinstatedt IS 'prodcse_dw.BasicPolicy.reinstatedt: Last reinstatement date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.relatedpolicynumber IS 'prodcse_dw.Line.relatedpolicynumber: Related Policy Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.renewaltermcd IS 'prodcse_dw.BasicPolicy.renewaltermcd: (i.e. 1 Year, 6 Months)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.rewritefrompolicyref IS 'prodcse_dw.BasicPolicy.rewritefrompolicyref: Link to policy from which the current policy was rewritten.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.rewritepolicyref IS 'prodcse_dw.BasicPolicy.rewritepolicyref: Link to policy that was rewritten from the current policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.subtypecd IS 'prodcse_dw.BasicPolicy.subtypecd: Code further defining the policy type.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.twopaydiscountind IS 'prodcse_dw.Line.twopaydiscountind: Specifies 2 Pay Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.umbilimit IS 'Covereges: UNDUM, UIMBI, UM, UMBI - Un[/Under in CA SG]insured Motorist Bodily Injury Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.umbrellarelatedpolicynumber IS 'PolicyNumber of Umbrella related policy - Line.RelatedPolicyNumber2 for Auto or Building.MultiPolicyNumberUmbrella for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.assigned IS 'Latest "Assigned" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.submitted IS 'Latest "Submitted" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.approvalinprogress IS 'Latest "ApprovalInProgress" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.sendback IS 'Latest "SendBack" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.unapproved IS 'Latest "UnApproved" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.approved IS 'Latest "Approved" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.rejected IS 'Latest "Rejected" task id (DIM_TASK)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.last_task_name IS 'Latest created task name';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.last_completed_task_name IS 'Latest completed task name';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.approved_policybookdt IS 'BookDt of a corresponding policy transaction for an approved application';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.vehiclelistconfirmedind IS 'CA SFG Auto, added Apr 2021;';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.ratedind IS 'Yes, if application was rated';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_basicpolicy_id IS 'PRODCSE_DW.BasicPolicy.Id - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_basicpolicy_writtenpremiumamt IS 'PRODCSE_DW.BasicPolicy.WrittenPremiumAmt - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_line_fulltermamt IS 'PRODCSE_DW.Line.FullTermAmt - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_line_finalpremiumamt IS 'PRODCSE_DW.Line.FinalPremiumAmt - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_application_description IS 'PRODCSE_DW.Application.Description - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_quoteinfo_uniqueid IS 'PRODCSE_DW.QuoteInfo.UniqueId - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_quoteinfo_adddt_tm IS 'PRODCSE_DW.QuoteInfo.AddDt and AddTm - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_quoteinfo_updatedt_tm IS 'PRODCSE_DW.QuoteInfo.UpdateDt and UpdateTm - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_quoyeinfo_adduser_uniqueid IS 'PRODCSE_DW.QuoteInfo.AddUser - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_quoteinfo_updateuser_uniqueid IS 'PRODCSE_DW.QuoteInfo.UpdateUser - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_application_updatetimestamp IS 'PRODCSE_DW.Application.Updatetimestamp - Added for backward compatibility with quote_building/quote_auto original tables. Most likely is not used anywhere.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_quoteinfo_typecd IS 'PRODCSE_DW.QuoteInfo.TypeCd - Added for backward compatibility with quote_building/quote_auto original tables.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_application.bc_basicpolicy_originalapplicationref IS 'PRODCSE_DW.BasicPolicy.OriginalApplicationRef - Added for backward compatibility with quote_building/quote_auto original tables.';


-- fsbi_dw_spinn.dim_building definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_building;

--DROP TABLE fsbi_dw_spinn.dim_building;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_building
(
	building_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,valid_todate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,record_version INTEGER   ENCODE lzo
	,building_uniqueid VARCHAR(500) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,spinnbuilding_id VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE lzo
	,building_naturalkey VARCHAR(500) NOT NULL  ENCODE lzo
	,stateprovcd VARCHAR(255)   ENCODE bytedict
	,county VARCHAR(255)   ENCODE bytedict
	,postalcode VARCHAR(255)   ENCODE lzo
	,city VARCHAR(255)   ENCODE lzo
	,addr1 VARCHAR(255)   ENCODE lzo
	,addr2 VARCHAR(255)   ENCODE lzo
	,latitude NUMERIC(18,12)   ENCODE lzo
	,longitude NUMERIC(18,12)   ENCODE lzo
	,bldgnumber INTEGER   ENCODE lzo
	,businesscategory VARCHAR(255)   ENCODE lzo
	,businessclass VARCHAR(255)   ENCODE lzo
	,constructioncd VARCHAR(255)   ENCODE bytedict
	,roofcd VARCHAR(255)   ENCODE bytedict
	,yearbuilt INTEGER   ENCODE lzo
	,sqft INTEGER   ENCODE lzo
	,stories INTEGER   ENCODE lzo
	,units INTEGER   ENCODE lzo
	,occupancycd VARCHAR(255)   ENCODE bytedict
	,protectionclass VARCHAR(255)   ENCODE bytedict
	,territorycd VARCHAR(255)   ENCODE bytedict
	,buildinglimit INTEGER   ENCODE lzo
	,contentslimit INTEGER   ENCODE lzo
	,valuationmethod VARCHAR(255)   ENCODE lzo
	,inflationguardpct INTEGER   ENCODE lzo
	,ordinanceorlawind VARCHAR(255)   ENCODE lzo
	,scheduledpremiummod INTEGER   ENCODE lzo
	,windhailexclusion VARCHAR(255)   ENCODE lzo
	,covalimit INTEGER   ENCODE lzo
	,covblimit INTEGER   ENCODE lzo
	,covclimit INTEGER   ENCODE lzo
	,covdlimit INTEGER   ENCODE lzo
	,covelimit INTEGER   ENCODE lzo
	,covflimit INTEGER   ENCODE lzo
	,allperilded VARCHAR(255)   ENCODE bytedict
	,burglaryalarmtype VARCHAR(255)   ENCODE bytedict
	,firealarmtype VARCHAR(255)   ENCODE bytedict
	,covblimitincluded INTEGER   ENCODE lzo
	,covblimitincrease INTEGER   ENCODE lzo
	,covclimitincluded INTEGER   ENCODE lzo
	,covclimitincrease INTEGER   ENCODE lzo
	,covdlimitincluded INTEGER   ENCODE lzo
	,covdlimitincrease INTEGER   ENCODE lzo
	,ordinanceorlawpct INTEGER   ENCODE lzo
	,neighborhoodcrimewatchind VARCHAR(255)   ENCODE bytedict
	,employeecreditind VARCHAR(255)   ENCODE bytedict
	,multipolicyind VARCHAR(255)   ENCODE bytedict
	,homewarrantycreditind VARCHAR(255)   ENCODE bytedict
	,yearoccupied INTEGER   ENCODE lzo
	,yearpurchased INTEGER   ENCODE lzo
	,typeofstructure VARCHAR(255)   ENCODE bytedict
	,feettofirehydrant INTEGER   ENCODE lzo
	,numberoffamilies INTEGER   ENCODE lzo
	,milesfromfirestation INTEGER   ENCODE lzo
	,rooms INTEGER   ENCODE lzo
	,roofpitch VARCHAR(255)   ENCODE bytedict
	,firedistrict VARCHAR(255)   ENCODE lzo
	,sprinklersystem VARCHAR(255)   ENCODE bytedict
	,fireextinguisherind VARCHAR(255)   ENCODE bytedict
	,kitchenfireextinguisherind VARCHAR(255)   ENCODE bytedict
	,deadboltind VARCHAR(255)   ENCODE bytedict
	,gatedcommunityind VARCHAR(255)   ENCODE bytedict
	,centralheatingind VARCHAR(255)   ENCODE bytedict
	,foundation VARCHAR(255)   ENCODE bytedict
	,wiringrenovation VARCHAR(255)   ENCODE bytedict
	,wiringrenovationcompleteyear VARCHAR(255)   ENCODE bytedict
	,plumbingrenovation VARCHAR(255)   ENCODE bytedict
	,heatingrenovation VARCHAR(255)   ENCODE bytedict
	,plumbingrenovationcompleteyear VARCHAR(255)   ENCODE bytedict
	,exteriorpaintrenovation VARCHAR(255)   ENCODE bytedict
	,heatingrenovationcompleteyear VARCHAR(255)   ENCODE bytedict
	,circuitbreakersind VARCHAR(255)   ENCODE bytedict
	,copperwiringind VARCHAR(255)   ENCODE bytedict
	,exteriorpaintrenovationcompleteyear VARCHAR(255)   ENCODE bytedict
	,copperpipesind VARCHAR(255)   ENCODE bytedict
	,earthquakeretrofitind VARCHAR(255)   ENCODE bytedict
	,primaryfuelsource VARCHAR(255)   ENCODE bytedict
	,secondaryfuelsource VARCHAR(255)   ENCODE bytedict
	,usagetype VARCHAR(255)   ENCODE bytedict
	,homegardcreditind VARCHAR(255)   ENCODE bytedict
	,multipolicynumber VARCHAR(255)   ENCODE lzo
	,localfirealarmind VARCHAR(255)   ENCODE bytedict
	,numlosses INTEGER   ENCODE lzo
	,covalimitincrease INTEGER   ENCODE lzo
	,covalimitincluded INTEGER   ENCODE lzo
	,monthsrentedout INTEGER   ENCODE lzo
	,roofreplacement VARCHAR(255)   ENCODE bytedict
	,safeguardplusind VARCHAR(255)   ENCODE bytedict
	,covelimitincluded INTEGER   ENCODE lzo
	,roofreplacementcompleteyear VARCHAR(255)   ENCODE bytedict
	,covelimitincrease INTEGER   ENCODE lzo
	,owneroccupiedunits INTEGER   ENCODE lzo
	,tenantoccupiedunits INTEGER   ENCODE lzo
	,replacementcostdwellingind VARCHAR(255)   ENCODE bytedict
	,feettopropertyline VARCHAR(255)   ENCODE lzo
	,galvanizedpipeind VARCHAR(255)   ENCODE bytedict
	,workerscompinservant INTEGER   ENCODE lzo
	,workerscompoutservant INTEGER   ENCODE lzo
	,liabilityterritorycd VARCHAR(255)   ENCODE bytedict
	,premisesliabilitymedpayind VARCHAR(255)   ENCODE bytedict
	,relatedprivatestructureexclusion VARCHAR(255)   ENCODE lzo
	,vandalismexclusion VARCHAR(255)   ENCODE lzo
	,vandalismind VARCHAR(255)   ENCODE lzo
	,roofexclusion VARCHAR(255)   ENCODE lzo
	,expandedreplacementcostind VARCHAR(255)   ENCODE lzo
	,replacementvalueind VARCHAR(255)   ENCODE lzo
	,otherpolicynumber1 VARCHAR(255)   ENCODE lzo
	,otherpolicynumber2 VARCHAR(255)   ENCODE lzo
	,otherpolicynumber3 VARCHAR(255)   ENCODE lzo
	,primarypolicynumber VARCHAR(255)   ENCODE lzo
	,otherpolicynumbers VARCHAR(255)   ENCODE lzo
	,reportedfirehazardscore VARCHAR(255)   ENCODE bytedict
	,firehazardscore VARCHAR(255)   ENCODE bytedict
	,reportedsteepslopeind VARCHAR(255)   ENCODE bytedict
	,steepslopeind VARCHAR(255)   ENCODE bytedict
	,reportedhomereplacementcost INTEGER   ENCODE lzo
	,reportedprotectionclass VARCHAR(255)   ENCODE bytedict
	,earthquakezone VARCHAR(255)   ENCODE bytedict
	,mmiscore VARCHAR(255)   ENCODE lzo
	,homeinspectiondiscountind VARCHAR(255)   ENCODE bytedict
	,ratingtier VARCHAR(255)   ENCODE bytedict
	,soiltypecd VARCHAR(255)   ENCODE bytedict
	,reportedfirelineassessment VARCHAR(255)   ENCODE bytedict
	,aaisfireprotectionclass VARCHAR(255)   ENCODE lzo
	,inspectionscore VARCHAR(255)   ENCODE bytedict
	,annualrents INTEGER   ENCODE lzo
	,pitchofroof VARCHAR(255)   ENCODE lzo
	,totallivingsqft INTEGER   ENCODE lzo
	,parkingsqft INTEGER   ENCODE lzo
	,parkingtype VARCHAR(255)   ENCODE lzo
	,retrofitcompleted VARCHAR(255)   ENCODE lzo
	,numpools VARCHAR(255)   ENCODE lzo
	,fullyfenced VARCHAR(255)   ENCODE lzo
	,divingboard VARCHAR(255)   ENCODE lzo
	,gym VARCHAR(255)   ENCODE lzo
	,freeweights VARCHAR(255)   ENCODE lzo
	,wirefencing VARCHAR(255)   ENCODE lzo
	,otherrecreational VARCHAR(255)   ENCODE lzo
	,otherrecreationaldesc VARCHAR(255)   ENCODE lzo
	,healthinspection VARCHAR(255)   ENCODE lzo
	,healthinspectiondt TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,healthinspectioncited VARCHAR(255)   ENCODE lzo
	,priordefectrepairs VARCHAR(255)   ENCODE lzo
	,msbreconstructionestimate VARCHAR(255)   ENCODE lzo
	,biindemnityperiod VARCHAR(255)   ENCODE lzo
	,equipmentbreakdown VARCHAR(255)   ENCODE bytedict
	,moneysecurityonpremises VARCHAR(255)   ENCODE lzo
	,moneysecurityoffpremises VARCHAR(255)   ENCODE lzo
	,waterbackupsump VARCHAR(255)   ENCODE lzo
	,sprinkleredbuildings VARCHAR(255)   ENCODE lzo
	,surveillancecams VARCHAR(255)   ENCODE lzo
	,gatedcomplexkeyaccess VARCHAR(255)   ENCODE lzo
	,eqretrofit VARCHAR(255)   ENCODE lzo
	,unitsperbuilding VARCHAR(255)   ENCODE lzo
	,numstories VARCHAR(255)   ENCODE lzo
	,constructionquality VARCHAR(255)   ENCODE lzo
	,burglaryrobbery VARCHAR(255)   ENCODE lzo
	,nfpaclassification VARCHAR(255)   ENCODE lzo
	,areasofcoverage VARCHAR(255)   ENCODE lzo
	,codetector VARCHAR(255)   ENCODE lzo
	,smokedetector VARCHAR(255)   ENCODE lzo
	,smokedetectorinspectind VARCHAR(255)   ENCODE lzo
	,waterheatersecured VARCHAR(255)   ENCODE lzo
	,boltedorsecured VARCHAR(255)   ENCODE lzo
	,softstorycripple VARCHAR(255)   ENCODE lzo
	,seniorhousingpct VARCHAR(255)   ENCODE lzo
	,designatedseniorhousing VARCHAR(255)   ENCODE lzo
	,studenthousingpct VARCHAR(255)   ENCODE lzo
	,designatedstudenthousing VARCHAR(255)   ENCODE lzo
	,priorlosses INTEGER   ENCODE lzo
	,tenantevictions VARCHAR(255)   ENCODE lzo
	,vacancyrateexceed VARCHAR(255)   ENCODE lzo
	,seasonalrentals VARCHAR(255)   ENCODE lzo
	,condoinsuingagmt VARCHAR(255)   ENCODE lzo
	,gasvalve VARCHAR(255)   ENCODE lzo
	,owneroccupiedpct VARCHAR(255)   ENCODE lzo
	,restaurantname VARCHAR(255)   ENCODE lzo
	,hoursofoperation VARCHAR(255)   ENCODE lzo
	,restaurantsqft INTEGER   ENCODE lzo
	,seatingcapacity INTEGER   ENCODE lzo
	,annualgrosssales INTEGER   ENCODE lzo
	,seasonalorclosed VARCHAR(255)   ENCODE lzo
	,barcocktaillounge VARCHAR(255)   ENCODE lzo
	,liveentertainment VARCHAR(255)   ENCODE lzo
	,beerwinegrosssales VARCHAR(255)   ENCODE lzo
	,distilledspiritsserved VARCHAR(255)   ENCODE lzo
	,kitchendeepfryer VARCHAR(255)   ENCODE lzo
	,solidfuelcooking VARCHAR(255)   ENCODE lzo
	,ansulsystem VARCHAR(255)   ENCODE lzo
	,ansulannualinspection VARCHAR(255)   ENCODE lzo
	,tenantnameslist VARCHAR(255)   ENCODE lzo
	,tenantbusinesstype VARCHAR(255)   ENCODE lzo
	,tenantglliability VARCHAR(255)   ENCODE lzo
	,insuredoccupiedportion VARCHAR(255)   ENCODE lzo
	,valetparking VARCHAR(255)   ENCODE lzo
	,lessorsqft INTEGER   ENCODE lzo
	,buildingrisknumber INTEGER   ENCODE lzo
	,multipolicyindumbrella VARCHAR(255)   ENCODE bytedict
	,poolind VARCHAR(255)   ENCODE bytedict
	,studsuprenovation VARCHAR(255)   ENCODE lzo
	,studsuprenovationcompleteyear VARCHAR(255)   ENCODE lzo
	,multipolicynumberumbrella VARCHAR(255)   ENCODE lzo
	,rctmsbamt VARCHAR(255)   ENCODE lzo
	,rctmsbhomestyle VARCHAR(255)   ENCODE bytedict
	,winsoverridenonsmokerdiscount VARCHAR(255)   ENCODE lzo
	,winsoverrideseniordiscount VARCHAR(255)   ENCODE lzo
	,itv INTEGER   ENCODE lzo
	,itvdate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,msbreporttype VARCHAR(255)   ENCODE bytedict
	,vandalismdesiredind VARCHAR(255)   ENCODE lzo
	,woodshakesiding VARCHAR(255)   ENCODE lzo
	,cseagent VARCHAR(3)   ENCODE bytedict
	,propertymanager VARCHAR(3)   ENCODE bytedict
	,rentersinsurance VARCHAR(3)   ENCODE bytedict
	,waterdetectiondevice VARCHAR(3)   ENCODE bytedict
	,autohomeind VARCHAR(3)   ENCODE bytedict
	,earthquakeumbrellaind VARCHAR(3)   ENCODE bytedict
	,landlordind VARCHAR(3)   ENCODE bytedict
	,lossassessment VARCHAR(16)   ENCODE bytedict
	,gasshutoffind VARCHAR(4)   ENCODE bytedict
	,waterded VARCHAR(16)   ENCODE bytedict
	,serviceline VARCHAR(4)   ENCODE bytedict
	,functionalreplacementcost VARCHAR(4)   ENCODE bytedict
	,milesofstreet VARCHAR(32)   ENCODE lzo
	,hoaexteriorstructure VARCHAR(3)   ENCODE lzo
	,retailportiondevelopment VARCHAR(32)   ENCODE lzo
	,lightindustrialtype VARCHAR(128)   ENCODE lzo
	,lightindustrialdescription VARCHAR(128)   ENCODE lzo
	,poolcoveragelimit INTEGER   ENCODE lzo
	,multifamilyresidentialbuildings INTEGER   ENCODE lzo
	,singlefamilydwellings INTEGER   ENCODE lzo
	,annualpayroll INTEGER   ENCODE lzo
	,annualrevenue INTEGER   ENCODE lzo
	,bedsoccupied VARCHAR(16)   ENCODE lzo
	,emergencylighting VARCHAR(4)   ENCODE lzo
	,exitsignsposted VARCHAR(4)   ENCODE lzo
	,fulltimestaff VARCHAR(4)   ENCODE lzo
	,licensedbeds VARCHAR(10)   ENCODE lzo
	,numberoffireextinguishers INTEGER   ENCODE lzo
	,otherfireextinguishers VARCHAR(16)   ENCODE lzo
	,oxygentanks VARCHAR(4)   ENCODE lzo
	,parttimestaff VARCHAR(4)   ENCODE lzo
	,smokingpermitted VARCHAR(4)   ENCODE lzo
	,staffonduty VARCHAR(4)   ENCODE lzo
	,typeoffireextinguishers VARCHAR(32)   ENCODE lzo
	,covaddrr_secondaryresidence VARCHAR(3)   ENCODE lzo
	,covaddrrprem_secondaryresidence NUMERIC(13,2)   ENCODE lzo
	,hodeluxe VARCHAR(3)   ENCODE lzo
	,sourcesystem VARCHAR(5) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE lzo
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_record_version INTEGER NOT NULL  ENCODE lzo
	,wuiclass VARCHAR(30)  DEFAULT '~'::character varying ENCODE bytedict
	,censusblock VARCHAR(30)  DEFAULT '~'::character varying ENCODE lzo
	,waterriskscore INTEGER  DEFAULT 0 ENCODE az64
	,water_risk_fre_3_blk INTEGER  DEFAULT 0 ENCODE az64
	,water_risk_sev_3_blk INTEGER  DEFAULT 0 ENCODE az64
	,water_risk_3_blk INTEGER  DEFAULT 0 ENCODE az64
	,waterh_fail_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,fixture_leak_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,ustructure_fail_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,pipe_froze_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,appl_fail_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,plumb_leak_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,rep_cost_3_blk VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,locationinc_source VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,landlordlosspreventionservices VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,enhancedwatercoverage VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,landlordproperty VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,liabilityextendedtoothers VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,lossofuseextendedtime VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,onpremisestheft INTEGER  DEFAULT 0 ENCODE az64
	,bedbugmitigation VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,habitabilityexclusion VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,wildfirehazardpotential VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,backupofsewersanddrains INTEGER  DEFAULT 0 ENCODE az64
	,vegetationsetbackft INTEGER  DEFAULT 0 ENCODE az64
	,yarddebriscoveragearea INTEGER  DEFAULT 0 ENCODE az64
	,yarddebriscoveragepercentage VARCHAR(5)  DEFAULT '~'::character varying ENCODE bytedict
	,capetrampoline VARCHAR(16)  DEFAULT '~'::character varying ENCODE bytedict
	,capepool VARCHAR(16)  DEFAULT '~'::character varying ENCODE bytedict
	,roofconditionrating VARCHAR(16)  DEFAULT '~'::character varying ENCODE bytedict
	,trampolineind VARCHAR(16)  DEFAULT '~'::character varying ENCODE bytedict
	,plumbingmaterial VARCHAR(16)  DEFAULT '~'::character varying ENCODE bytedict
	,centralizedheating VARCHAR(16)  DEFAULT '~'::character varying ENCODE bytedict
	,firedistrictsubscriptioncode VARCHAR(8)  DEFAULT '~'::character varying ENCODE bytedict
	,roofcondition VARCHAR(20)  DEFAULT '~'::character varying ENCODE bytedict
	,PRIMARY KEY (building_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	water_risk_fre_3_blk
	)
;
ALTER TABLE fsbi_dw_spinn.dim_building owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_building IS ' 	Source: 	Building, Addr, Coverage	DW Table type:	Slowly Changing Dimension Type 2	Table description:	Homeowners, LandLords and Commercial buildings details at the level of mid-term changes. ValidFrom - ValidTo are based on transaction effective dates';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_building.status IS 'Current status of the Building record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.bldgnumber IS 'Unique number identifying the building within a line.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.businesscategory IS 'Business Category (grouping of business classes) for commercial';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.businessclass IS 'Business Class for commercial';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.constructioncd IS 'from first or largest percentage(CA SFG) % in MSB RCT data report';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.roofcd IS 'Code describing the type of roof.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.yearbuilt IS 'Year the building construction was completed.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.sqft IS 'Total square footage of the building.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.stories IS 'Number of building stories.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.units IS 'Number of building units.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.occupancycd IS 'Code describing the building occupancy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.buildinglimit IS 'Building coverage limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.contentslimit IS 'Contents (business personal property) limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.valuationmethod IS 'Valuation method (e.g. Replacement Cost or ACV)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.inflationguardpct IS 'Inflation guard percentage.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.ordinanceorlawind IS 'Building Ordinance or Law';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.scheduledpremiummod IS 'Modifier to the building premium.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covalimit IS 'Coverage A Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covblimit IS 'Coverage B Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covclimit IS 'Coverages:   PP,CovC  -  C - Personal Property Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covdlimit IS 'Coverages:   LOU,CovD  -  D - Loss of Use, D - Fair Rental Value Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covelimit IS 'Coverages: ALEXP,PL,CovE  -  E - Personal Liability, E - Additional Living Expense Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covflimit IS 'Coverages: MEDPAY,MEDPM,CovF  -  F - Medical Payments to Others Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covblimitincrease IS 'The column is NOT populated consistently and correctly. It''s 0 when CovB(OS) is a standard 10% of CovA and populated if a non standard limit. The name of the column is close to INCB coverage description but it is not supposed to be populated for INCB. On the other hand, there are sometimes mid-term policy changes with numbers which match INCB coverage limit.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covclimitincrease IS 'CSE decided to price it in two step: a basic limit + anything above that basic limit so they created two coverage codes (PP and INCC) but what CSE would pay under that coverage is really the sum of both.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.ordinanceorlawpct IS 'Coverages: F.30630,BOLAW,F.30655  -  Building Ordinance or Law Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3  AZ-DF3,CA-ICO-DF3,CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.feettofirehydrant IS 'Distance to Fire Station,  mapped from PPC data report';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.roofpitch IS 'from MSB RCT data report Roof Style/Slope: Flat to Flat or all other in MSB RCT to Slant in SPINN';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.foundation IS 'Mapped from MSB RCT. Slab in SPINN: Slab at Grade; Basement, Daylight; Basement, Walkout; Basement, Below Grade; Crawl Space Unexcavated; rawl Space, Excavated. Piers or Posts  in SPINN: Piers; Hillside; Hillside Slope';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.usagetype IS 'Only for value COC: COC, Course of Construction        Products:    CA-SG-DF3,CA-SG-DF6';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.homegardcreditind IS 'Coverages: HomeGard      Determines whether to rate with credit Products:    CA-ICO-HO3 ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.numlosses IS 'Populated for Dwelling and Homeowners ONLY. Not clear how if it`s populated from LossHistory.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covalimitincrease IS 'CovALimitIncrease';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.covalimitincluded IS 'CovALimitIncluded';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.safeguardplusind IS 'Indicates Safeguard Plus Endorsement is selected.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.replacementcostdwellingind IS 'Coverages: FVREP  D515ST1    Extended Replacement Cost Dwelling Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3. 150, 175 or other numbers representg the percentage of the replacement cost';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.feettopropertyline IS 'Feet to property line';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.galvanizedpipeind IS 'Type of plumbing pipes';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.workerscompinservant IS 'Coverages: WCPIN,  H090CA0-Inservant  -  Workers Compensation - Inservant Products:    CA-ICO-HO3      CA-ICO-DF3,CA-SG-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.workerscompoutservant IS 'Coverages: WCPOT,  H090CA0-Outservant  -  Workers Compensation - Outservant Products:    CA-ICO-HO3      CA-ICO-DF3,CA-SG-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.premisesliabilitymedpayind IS 'Indicator for Premises Liability Med Pay (OL&amp;T)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.reportedfirehazardscore IS 'Score designation for Fire Hazard Assessment retrieved from Data Report.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.firehazardscore IS 'Score for Fire Hazard Assessment.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.reportedsteepslopeind IS 'Indicates whether the slope is over 35 degrees and retrieved from Data Report in ISO Fireline slope sub-score.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.steepslopeind IS 'It`s a flag to indicate if Slope over 35 Degrees in ISO Fireline slope sub-score. If ReportedSteepSlopeInd is "S3,S4,S5" the value will be set to “Yes”.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.reportedhomereplacementcost IS 'Replacement Cost Value returned by AIR.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.reportedprotectionclass IS 'Protection class number retrieved from Data Report.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.mmiscore IS 'The MMI Score.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.homeinspectiondiscountind IS 'Indicates whether a building qualifies for Home Inspection Discount.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.ratingtier IS 'Plus: LL1 - Landlord Plus Coverage Package; Premier: LL2 - Landlord Premier Coverage Package        Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.soiltypecd IS 'New field for EarthQuake in Dwelling tab.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.reportedfirelineassessment IS 'Fire Hazard Assessment retrieved from Data Report.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.aaisfireprotectionclass IS 'AAIS Fire Protection Class.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.inspectionscore IS 'a measure of this property&apos;s likelihood of having an actionable inspection discovery';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.annualrents IS 'Annual Rents';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.pitchofroof IS 'Pitch of Roof';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.totallivingsqft IS 'Total Sq Ft Living Area';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.parkingsqft IS 'Total Sq Ft Parking Area';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.parkingtype IS 'Parking Type';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.retrofitcompleted IS 'Soft story seismic retrofit completed';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.numpools IS 'Number of Pools';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.fullyfenced IS 'Fully fenced with self-locking gate?';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.divingboard IS 'Diving Board';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.gym IS 'Gym on premises';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.freeweights IS 'Free Weights in Gym';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.wirefencing IS 'Wire Fencing';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.otherrecreational IS 'Other Recreational Facility other than Gym or Pool';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.otherrecreationaldesc IS 'Other Recreational Facility Description';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.healthinspection IS 'Whether all premises been inspected by the Housing Authority or Public Health in the past three years';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.healthinspectiondt IS 'Inspection date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.healthinspectioncited IS 'Cited';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.priordefectrepairs IS 'Prior defects or major repairs needed';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.msbreconstructionestimate IS 'MSB Reconstruction Estimate';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.biindemnityperiod IS 'Business Income Period of Indemnity';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.equipmentbreakdown IS 'Coverages: EQPBK      Equipment Breakdown Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.moneysecurityonpremises IS 'Money and Securities On Premises';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.moneysecurityoffpremises IS 'Money and Securities Off Premises';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.waterbackupsump IS 'Water Backup and Sump Pump';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.sprinkleredbuildings IS 'Sprinklered Buildings';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.surveillancecams IS 'Surveillance video cameras';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.gatedcomplexkeyaccess IS 'Gated Complex Key Access Only';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.eqretrofit IS 'Earthquake Retrofit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.unitsperbuilding IS '# of Units Per Building';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.numstories IS '# of Stories';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.constructionquality IS 'Code describing the building construction quality';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.burglaryrobbery IS 'Burglary and Robbery';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.nfpaclassification IS 'NFPA Classification';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.areasofcoverage IS 'Areas Of Coverage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.codetector IS 'Carbon Monoxide Detector';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.smokedetector IS 'Smoke Detector';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.smokedetectorinspectind IS 'Smoke Detector Inspection Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.waterheatersecured IS 'Water Heater Secured';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.boltedorsecured IS 'Bolted or secured to foundation';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.softstorycripple IS 'Soft-story or Cripple Wall Braced';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.seniorhousingpct IS 'Senior Housing Percentage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.designatedseniorhousing IS 'Designated Senior Housing';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.studenthousingpct IS 'Student Housing Percentage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.designatedstudenthousing IS 'Designated Student Housing';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.priorlosses IS 'Populated only for BusinessOwners ONLY. Not clear how if it`s populated from LossHistory.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.tenantevictions IS 'Yes/No original coverage source is unknown. One time hist update and going forward starting 2023/11/07 "Yes" if there is an Active OLT coverage.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.vacancyrateexceed IS 'Vacancy Rate Exceed';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.seasonalrentals IS 'Seasonal Rentals';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.condoinsuingagmt IS 'Condo Insuing Agreement';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.gasvalve IS 'Automatic gas shut off valve installed?';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.owneroccupiedpct IS '% Owner-occupied Units';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.restaurantname IS 'Restaurant Name';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.hoursofoperation IS 'Hours Of Operation';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.restaurantsqft IS 'Restaurant Square Footage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.seatingcapacity IS 'Seating Capacity';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.annualgrosssales IS 'AnnualGrossSales';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.seasonalorclosed IS 'Is the operation seasonal or closed 30 consecutive days annually';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.barcocktaillounge IS 'Is there a Bar or Cocktail Lounge';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.liveentertainment IS 'Is there Live Entertainment';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.beerwinegrosssales IS 'Beer Wine Gross Sales';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.distilledspiritsserved IS 'Distilled Spirits Served';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.kitchendeepfryer IS 'Kitchen Deep Fryer';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.solidfuelcooking IS 'Solid Fuel Cooking';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.ansulsystem IS 'ANSUL System';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.ansulannualinspection IS 'ANSUL Annual Inspection';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.tenantnameslist IS 'Tenant Names List';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.tenantbusinesstype IS 'TenantBusinessType';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.tenantglliability IS 'Tenant GL Liability';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.insuredoccupiedportion IS 'Insured Occupied Portion';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.valetparking IS 'Valet Parking';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.lessorsqft IS 'Other Lessor&apos;s Square Footage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.buildingrisknumber IS 'Building Risk Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.multipolicyindumbrella IS 'Umbrella Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.poolind IS 'The info is provided by agent. Not used in rules. There is an additional info in QuestionReply (not in Redshift DW) regarding standing step ladder, slide, spa and hot tube';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.studsuprenovation IS 'A renovation from-the-studs-up may qualify a building with an older original construction year for options available to newer construction.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.studsuprenovationcompleteyear IS 'A renovation from-the-studs-up may qualify a building with an older original construction year for options available to newer construction.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.multipolicynumberumbrella IS 'Umbrella Policy Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.rctmsbamt IS 'MSB RCT Amount';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.rctmsbhomestyle IS 'MSB RCT Home Style';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.winsoverridenonsmokerdiscount IS 'Indicator for applying non smoker discount for converted policies from WINS';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.winsoverrideseniordiscount IS 'Indicator for applying senior discount for converted policies from WINS';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.itv IS 'Field for storing the Pending Renewal CovALimit value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.itvdate IS 'Field for storing the date the MSB was ordered for ITV';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.msbreporttype IS 'Indicates whether MSB report received is HighValue or Mainstreet';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.vandalismdesiredind IS 'SEL FL-1 VAC/COC is issued without Vandalism coverage, though it may be added if the risk qualifies after an exterior/interior inspection. This indicator allows the insured to express the desire that Vandalism coverage be added if the risk qualifies, or to decline Vandalism up-front, in which case there is no need to order an interior inspection. See PCSInspectionReport.getInspectionCategory().';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.woodshakesiding IS 'Wood Shake Siding';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.cseagent IS 'CSE Agent discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.propertymanager IS 'Property Manager discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.rentersinsurance IS 'Renters Insurance discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.waterdetectiondevice IS 'Water Detection Device discount indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.autohomeind IS 'Auto or Home Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.earthquakeumbrellaind IS 'Earthquake or Umbrella Policy Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.landlordind IS 'Discount if there is more then 1 Landlord policy per customer';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.lossassessment IS 'Homeowners: Building.LossAssessment - Coverages:   LAC,H035ST0  -  Loss Assessment Products: AZ-HO3, CA-ICO-HO3,CA-SG-HO3,NV-HO3 Dwelling - value of Limit1  (LAC coverage) from Limit table';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.gasshutoffind IS 'Gas Shut Off Valve Indicator';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.serviceline IS 'Coverages: UTLDB      Service Line Products:AZ-DF3,  CA-SG-DF3,  NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.functionalreplacementcost IS 'Coverages: FXRC      Functional Replacement Cost Products:    CA-SG-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.milesofstreet IS 'Miles of Street to Insure';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.hoaexteriorstructure IS 'Is the HOA responsible for the exterior structure?';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.retailportiondevelopment IS 'Retail Portion of Development';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.lightindustrialtype IS 'Light Industrial Type';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.lightindustrialdescription IS 'Light Industrial Description';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.poolcoveragelimit IS 'Pool Coverage Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.multifamilyresidentialbuildings IS '# of Multi-family Residential Buildings';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.singlefamilydwellings IS '# of Single-family Dwellings';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.annualpayroll IS 'Annual Payroll';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.annualrevenue IS 'Annual Revenue';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.bedsoccupied IS '# Beds Occupied';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.emergencylighting IS 'Emergency Lighting';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.exitsignsposted IS 'Exit Sign Posted';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.fulltimestaff IS '# Full-Time Staff';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.licensedbeds IS '# Licensed Beds';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.numberoffireextinguishers IS 'Number of Fire Extinguishers';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.otherfireextinguishers IS 'Other Fire Extinguishers';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.oxygentanks IS 'Oxygen Tanks';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.parttimestaff IS '# Part-Time Staff';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.smokingpermitted IS 'Smoking Permitted';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.staffonduty IS 'Is staff on duty and available 24/7';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.typeoffireextinguishers IS 'Type of Fire Extinguishers';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.wuiclass IS 'Wildland Urban Interface Area value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.waterriskscore IS 'water_risk_3.blk from LocationInc data report and table, used to increase WaterDed if gretaer 300';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.water_risk_fre_3_blk IS 'Non-weather Water Claim Frequency Index relative to Nation (0 to 5000: 100=average, 50=0.5x average, 500=5x average)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.water_risk_sev_3_blk IS 'Non-weather Water Claim Severity Index relative to Nation (0 to 5000: 100=average, 50=0.5x average, 500=5x average)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.water_risk_3_blk IS 'Non-weather Water Damage Loss Index relative to Nation (0 to 5000: 100=average, 50=0.5x average, 500=5x average)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.waterh_fail_3_blk IS 'Water heater failure rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.fixture_leak_3_blk IS 'Fixture leak / overflow rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.ustructure_fail_3_blk IS 'Understructure plumbing failure rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.pipe_froze_3_blk IS 'Frozen pipe rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.appl_fail_3_blk IS 'Appliance failure rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.plumb_leak_3_blk IS 'Plumbing leak rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.rep_cost_3_blk IS 'Property repair cost rating';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.locationinc_source IS 'Is it historical load or ongoing report';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.landlordlosspreventionservices IS 'CA SFG NX2 DF3; Landlord Loss Prevention Services checkbox; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.enhancedwatercoverage IS 'CA SFG NX2 DF3; Enhanced Water Coverage checkbox; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.landlordproperty IS 'CA SFG NX2 DF3; Landlord Property checkbox; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.liabilityextendedtoothers IS 'CA SFG NX2 DF3; Liability Extended to Others dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.lossofuseextendedtime IS 'CA SFG NX2 DF3; Loss of Use â€“ Extended Time dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.onpremisestheft IS 'CA SFG NX2 DF3; On Premises Theft dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.bedbugmitigation IS 'CA SFG NX2 DF3; Bed Bug Mitigation dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.habitabilityexclusion IS 'CA SFG NX2 DF3; Habitability Exclusion dropdown; Saved in Application/Line/Risk/Building or Policy/Line/Risk/Building ;  US21484';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.wildfirehazardpotential IS 'CA SFG NX2 HO3 and CA SFG NX2 DF3; Wildfire Hazard Potential from Cape Analytics Data Report;  US21208 and US21592';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.backupofsewersanddrains IS ' 	CA SFG Homeguard , added Apr 2022;	Coverage limit for Backup Of Sewers And Drains';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.vegetationsetbackft IS ' 	Cape Analytics, used in rules, added Apr 2022;	"Distance between the primary
structure perimeter and nearest
large vegetation.
Distance, measured in units of
feet. Returns null when attribute
is not available for a parcel.
“Large vegetation” is defined as
trees and large bushes. Smaller
shrubs, lawns, and undergrowth
are excluded."';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.yarddebriscoveragearea IS ' 	Cape Analytics, used in rules, added Apr 2022;	"Square footage value and ratio
of yard covered by debris (e.g.
junk cars, appliances,
construction materials,
disorganized piles).
Yard Debris returns are limited
to parcels with area less than
500,000 sqft. In cases in which
parcel area is greater than that
limit, the response will be NULL."';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.yarddebriscoveragepercentage IS ' 	Cape Analytics, used in rules, added Apr 2022;	"Square footage value and ratio
of yard covered by debris (e.g.
junk cars, appliances,
construction materials,
disorganized piles).
Yard Debris returns are limited
to parcels with area less than
500,000 sqft. In cases in which
parcel area is greater than that
limit, the response will be NULL."';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.capetrampoline IS ' 	Cape Analytics, added Apr 2022; There is also one CSE Rule that use this field in the condition. (US20225) in contrast to TrampolineInd column.Detects presence of a trampoline on a parcel. with_trampoline - one or more trampolines were detected on the parcel; no_trampoline - no trampolines were detected on the parcel; unknown - cape is unable to determine whether or not';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.capepool IS ' 	Cape Analytics, used in rules, added Apr 2022;	Detects presence of an in ground or above- ground pool on a property. with_pool - home has a pool; no_pool - home does not have a pool; ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.roofconditionrating IS ' 	Cape Analytics, used in rules, added Apr 2022;	"Severity rating of the exterior roof condition. 
2 - Excellent - No visible signs of roof defects; 
1 - Good - Minimal signs of defects that are not visibly pronounced. Minor discoloration and/or cosmetic flaws; 
0 - Fair - Visible defects that are not as strongly pronounced or as clearly obvious as a poor roof (-1). Faint or localized streaking/discoloration; 
-1 - Poor - Obvious, pronounced signs of defects that affect the function and safety of the roof. Large patches of streaking/discoloration, or warped shingles
-2 - Severe - Obvious, pronounced signs of defects that significantly affect the function and safety of the roof. Tarp on the roof, missing shingles, organic matter, patches from repair, visible damage, or signs of ponding unknown - Property visibly obstructed, often by trees or shadow. Cape is unable to provide a rating with sufficient confidence"';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.trampolineind IS ' 	CA SFG HO3 , added Apr 2021;	The info is provided by agent. Not used in rules. There is an additional info in QuestionReply (not in Redshift DW) regarding a trampoline safety net enclosure.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.plumbingmaterial IS ' 	CA SFG HO3 , added Apr 2021;	is used in CA SFG HO3 instead of galvanizedpipeind and  copperpipesind';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.centralizedheating IS ' 	CA SFG Homeguard , added Apr 2022;	Centralized or thermostatically controlled heating system:';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.firedistrictsubscriptioncode IS ' 	CA SFG Homeguard , added Apr 2022;	mapped from PPC: S indicates the Risk address is within a subscription fire protection area. T indicates, it doesn’t have a subscription.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_building.roofcondition IS ' 	CA SFG Homeguard , added Apr 2022;	mapped from Cape Analytics report, and made read only for producer users (editable for company users). 2 - Excellent; 1 - Good; 0 - Fair; -1 - Poor; -2 - Severe; unknown - Unknown; not_available - Not Available';


-- fsbi_dw_spinn.dim_buildingrisk definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_buildingrisk;

--DROP TABLE fsbi_dw_spinn.dim_buildingrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_buildingrisk
(
	buildingrisk_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,valid_todate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,record_version INTEGER   ENCODE lzo
	,buildingrisk_uniqueid VARCHAR(255)   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_id INTEGER   ENCODE lzo
	,spinnbuildingrisk_id VARCHAR(255)   ENCODE lzo
	,status VARCHAR(255)   ENCODE lzo
	,bldgnumber INTEGER   ENCODE lzo
	,constructioncd VARCHAR(255)   ENCODE lzo
	,roofcd VARCHAR(255)   ENCODE lzo
	,yearbuilt INTEGER   ENCODE lzo
	,buildinglimit INTEGER   ENCODE lzo
	,contentslimit INTEGER   ENCODE lzo
	,inflationguardpct INTEGER   ENCODE lzo
	,ordinanceorlawind INTEGER   ENCODE lzo
	,pitchofroof VARCHAR(255)   ENCODE lzo
	,totallivingsqft INTEGER   ENCODE lzo
	,msbreconstructionestimate VARCHAR(255)   ENCODE lzo
	,sprinkleredbuildings VARCHAR(255)   ENCODE lzo
	,unitsperbuilding VARCHAR(255)   ENCODE lzo
	,numstories VARCHAR(255)   ENCODE lzo
	,constructionquality VARCHAR(255)   ENCODE lzo
	,areasofcoverage VARCHAR(255)   ENCODE lzo
	,rpc125pct INTEGER   ENCODE lzo
	,increasedconstcost INTEGER   ENCODE lzo
	,tiv_spinn INTEGER   ENCODE lzo
	,tiv INTEGER   ENCODE lzo
	,timeelement INTEGER   ENCODE lzo
	,subjectamount INTEGER   ENCODE lzo
	,facultativecededpremium INTEGER   ENCODE lzo
	,cededpremiumfactor VARCHAR(255)   ENCODE lzo
	,buildingrisknumber INTEGER   ENCODE lzo
	,buildingtype VARCHAR(255)   ENCODE lzo
	,saunaroom VARCHAR(255)   ENCODE lzo
	,fitnesscenter VARCHAR(255)   ENCODE lzo
	,annualrevenue INTEGER   ENCODE lzo
	,licensedbeds VARCHAR(255)   ENCODE lzo
	,riskgroupnumber INTEGER   ENCODE lzo
	,riskgrouptype VARCHAR(255)   ENCODE lzo
	,riskgroupdescrtiption VARCHAR(255)   ENCODE lzo
	,sourcesystem VARCHAR(5) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE lzo
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_record_version INTEGER NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	valid_todate
	)
;
ALTER TABLE fsbi_dw_spinn.dim_buildingrisk owner to kdrogaieva;


-- fsbi_dw_spinn.dim_carrier definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_carrier;

--DROP TABLE fsbi_dw_spinn.dim_carrier;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_carrier
(
	carrier_id INTEGER NOT NULL  ENCODE RAW
	,carrier_uniqueid VARCHAR(10) NOT NULL  ENCODE RAW
	,carr_code VARCHAR(10) NOT NULL  ENCODE lzo
	,carr_name VARCHAR(20) NOT NULL  ENCODE lzo
	,carr_abbr VARCHAR(10) NOT NULL  ENCODE lzo
	,carr_legalname VARCHAR(50) NOT NULL  ENCODE lzo
	,carr_description VARCHAR(100) NOT NULL  ENCODE lzo
	,carr_naic_group_code VARCHAR(3) NOT NULL  ENCODE lzo
	,carr_naic_code VARCHAR(5) NOT NULL  ENCODE lzo
	,carr_fin_gl_code VARCHAR(2) NOT NULL  ENCODE lzo
	,fin_company_id VARCHAR(2) NOT NULL DEFAULT ''::character varying ENCODE bytedict
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.dim_carrier owner to emiller;
COMMENT ON TABLE fsbi_dw_spinn.dim_carrier IS 'List of insurance carriers plus descriptive information compiled from SPINN, WINS, Finance GL, and other systems.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carrier_id IS 'Primary key to join dimension to fact tables. Continuous, increasing integers. 0 is Unknown.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carrier_uniqueid IS 'Unique character identifier for this carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_code IS 'Carrier Code. The code used in SPINN and other systems to identify this carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_name IS 'Carrier Name. The commonly used name of the insurance carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_abbr IS 'Carrier Abbreviation. The abbreviation used to represent the insurance carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_legalname IS 'Carrier Name. The full legally registered name of the insurance carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_description IS 'Carrier Description. Currently this is just the legal name.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_naic_group_code IS 'Carrier NAIC Group Code. The three-digit NAIC code used to identify the carrier group to which this carrier belongs.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_naic_code IS 'Carrier NAIC Code. The five-digit NAIC code used to identify this specific insurance carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_carrier.carr_fin_gl_code IS 'Carrier Finance General Ledger Code. The two-digit code used in Finance''s Chart of Accounts to identify this specific carrier in the General Ledger.';


-- fsbi_dw_spinn.dim_ccfr_status definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_ccfr_status;

--DROP TABLE fsbi_dw_spinn.dim_ccfr_status;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_ccfr_status
(
	ccfr_stat_key BIGINT   ENCODE az64
	,claimnumber VARCHAR(50)   ENCODE lzo
	,claimantcd VARCHAR(3)   ENCODE bytedict
	,featurecd VARCHAR(25)   ENCODE bytedict
	,adjustment VARCHAR(10)   ENCODE lzo
	,indemnity VARCHAR(10)   ENCODE bytedict
	,defense VARCHAR(10)   ENCODE lzo
	,subrogation VARCHAR(10)   ENCODE lzo
	,salvage VARCHAR(10)   ENCODE lzo
	,adjustment_status_chng SMALLINT   ENCODE az64
	,indemnity_status_chng SMALLINT   ENCODE az64
	,defense_status_chng SMALLINT   ENCODE az64
	,subrogation_status_chng SMALLINT   ENCODE az64
	,salvage_status_chng SMALLINT   ENCODE az64
	,bookdt DATE   ENCODE az64
	,transactionnumber INTEGER   ENCODE az64
	,current_flag SMALLINT   ENCODE az64
	,created_by VARCHAR(250)   ENCODE lzo
	,updated_by VARCHAR(250)   ENCODE lzo
	,created_date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,updated_date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (claimnumber)
;
ALTER TABLE fsbi_dw_spinn.dim_ccfr_status owner to root;


-- fsbi_dw_spinn.dim_claim definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_claim;

--DROP TABLE fsbi_dw_spinn.dim_claim;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_claim
(
	claim_id INTEGER NOT NULL  ENCODE delta
	,clm_claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,clm_featurenumber VARCHAR(50)   ENCODE lzo
	,clm_featuredeleteflag VARCHAR(1)   ENCODE lzo
	,clm_groupnumber VARCHAR(50)   ENCODE lzo
	,clm_typeloss VARCHAR(100)   ENCODE runlength
	,clm_description VARCHAR(2000)   ENCODE runlength
	,clm_catcode VARCHAR(50)   ENCODE lzo
	,clm_catdescription VARCHAR(256)   ENCODE lzo
	,clm_causelosscode VARCHAR(50)   ENCODE lzo
	,clm_causelossdescription VARCHAR(256)   ENCODE lzo
	,clm_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,policy_id INTEGER   ENCODE delta
	,dateofloss DATE   ENCODE lzo
	,datereported DATE   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE runlength
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (claim_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	clm_claimnumber
	)
;
ALTER TABLE fsbi_dw_spinn.dim_claim owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_claim IS ' 	Source: 	ClaimStats	DW Table type:	Dimension Type 1	Table description:	Claimnumber, date of loss, reported date, policy term';


-- fsbi_dw_spinn.dim_claimant definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_claimant;

--DROP TABLE fsbi_dw_spinn.dim_claimant;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_claimant
(
	claimant_id INTEGER NOT NULL  ENCODE delta
	,claimant_role VARCHAR(50)   ENCODE lzo
	,claimant_type VARCHAR(50)   ENCODE bytedict
	,claimant_number VARCHAR(50)   ENCODE bytedict
	,name VARCHAR(100)   ENCODE lzo
	,dob DATE   ENCODE lzo
	,occupation VARCHAR(256)   ENCODE lzo
	,gender VARCHAR(10)   ENCODE bytedict
	,maritalstatus VARCHAR(256)   ENCODE lzo
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,city VARCHAR(50)   ENCODE lzo
	,state VARCHAR(50)   ENCODE bytedict
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,fax VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,jobtitle VARCHAR(100)   ENCODE lzo
	,claimant_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE runlength
	,loaddate DATE   ENCODE lzo
	,watermitigationind VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,publicadjusterind VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (claimant_id)
)
DISTSTYLE AUTO
 DISTKEY (claimant_id)
 SORTKEY (
	claimant_type
	)
;
ALTER TABLE fsbi_dw_spinn.dim_claimant owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_claimant IS ' 	Source: 	Claim, Claimant, AllContacts, PersonInfo	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Claimant names, contact info';


-- fsbi_dw_spinn.dim_claimextension definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_claimextension;

--DROP TABLE fsbi_dw_spinn.dim_claimextension;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_claimextension
(
	claimextension_id INTEGER NOT NULL  ENCODE delta
	,claim_uniqueid VARCHAR(100)   ENCODE lzo
	,riskcd VARCHAR(255)   ENCODE lzo
	,coveragecd VARCHAR(255)   ENCODE bytedict
	,carriercd VARCHAR(255)   ENCODE bytedict
	,carriergroupcd VARCHAR(255)   ENCODE lzo
	,claimantcd VARCHAR(255)   ENCODE bytedict
	,featurecd VARCHAR(255)   ENCODE bytedict
	,featuresubcd VARCHAR(255)   ENCODE lzo
	,featuretypecd VARCHAR(255)   ENCODE bytedict
	,reservecd VARCHAR(255)   ENCODE lzo
	,reservetypecd VARCHAR(255)   ENCODE bytedict
	,annualstatementlinecd VARCHAR(255)   ENCODE lzo
	,sublinecd VARCHAR(255)   ENCODE lzo
	,companycd VARCHAR(255)   ENCODE lzo
	,linecd VARCHAR(255)   ENCODE bytedict
	,atfaultcd VARCHAR(255)   ENCODE bytedict
	,sourcecd VARCHAR(255)   ENCODE lzo
	,categorycd VARCHAR(255)   ENCODE lzo
	,losscausecd VARCHAR(255)   ENCODE bytedict
	,reportedto VARCHAR(255)   ENCODE lzo
	,reportedby VARCHAR(255)   ENCODE lzo
	,damagedesc VARCHAR(255)   ENCODE lzo
	,shortdesc VARCHAR(255)   ENCODE lzo
	,description VARCHAR(255)   ENCODE lzo
	,"comment" VARCHAR(255)   ENCODE lzo
	,clm_catcode VARCHAR(100)   ENCODE lzo
	,clm_catdescription VARCHAR(255)   ENCODE lzo
	,suitfiledind VARCHAR(10)   ENCODE lzo
	,totallossind VARCHAR(255)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,insiuind VARCHAR(3)  DEFAULT 'No'::character varying ENCODE lzo
	,sublosscausecd VARCHAR(50)  DEFAULT '~'::character varying ENCODE bytedict
	,losscauseseverity VARCHAR(10)  DEFAULT '~'::character varying ENCODE bytedict
	,negligencepct INTEGER  DEFAULT 0 ENCODE az64
	,emergencyservice VARCHAR(20)  DEFAULT '~'::character varying ENCODE lzo
	,emergencyservicevendor VARCHAR(20)  DEFAULT '~'::character varying ENCODE lzo
	,salvageownerretainedind VARCHAR(255)  DEFAULT 'No'::character varying ENCODE lzo
	,occursite VARCHAR(50) NOT NULL DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (claimextension_id)
)
DISTSTYLE AUTO
 DISTKEY (claimextension_id)
 SORTKEY (
	clm_catcode
	)
;
ALTER TABLE fsbi_dw_spinn.dim_claimextension owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_claimextension IS ' 	Source: 	ClaimStats,Claim,Propertydamaged,Catastrophe	DW Table type:	Dimension Type 1	Table description:	Claim details. See dim_claimextension for more details';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_claimextension.salvageownerretainedind IS 'prodcse_dw.PropertyDamaged.SalvageOwnerRetainedInd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_claimextension.occursite IS 'prodcse_dw.Claim.OccurSite - This identifies (based on selection) where a multivehicle or any auto accident occurred. (I.e., freeway, intersection, sidestreet, etc...) Set values.  US23213';


-- fsbi_dw_spinn.dim_claimrisk definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_claimrisk;

--DROP TABLE fsbi_dw_spinn.dim_claimrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_claimrisk
(
	claimrisk_id INTEGER NOT NULL  ENCODE RAW
	,claimref VARCHAR(100) NOT NULL  ENCODE lzo
	,claimnumber VARCHAR(100) NOT NULL  ENCODE lzo
	,clrsk_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,cvrsk_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE RAW
	,clrsk_item_id INTEGER NOT NULL  ENCODE RAW
	,clrsk_item_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,clrsk_item_type VARCHAR(10) NOT NULL  ENCODE bytedict
	,clrsk_item_id2 BIGINT NOT NULL  ENCODE lzo
	,clrsk_item_uniqueid2 VARCHAR(255) NOT NULL  ENCODE lzo
	,clrsk_item_type2 VARCHAR(10) NOT NULL  ENCODE bytedict
	,clrsk_lossdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,clrsk_number INTEGER NOT NULL  ENCODE RAW
	,clrsk_number2 INTEGER NOT NULL  ENCODE RAW
	,clvrsk_item_naturalkey VARCHAR(500) NOT NULL  ENCODE lzo
	,clrsk_item_naturalkey2 VARCHAR(255) NOT NULL  ENCODE lzo
	,primaryrisk_naturalkey VARCHAR(255)   ENCODE lzo
	,primaryrisk_number VARCHAR(255)   ENCODE bytedict
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE runlength
	,coveredrisk_id INTEGER NOT NULL  ENCODE RAW
	,audit_id INTEGER   ENCODE RAW
	,PRIMARY KEY (claimrisk_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	clrsk_item_type
	)
;
ALTER TABLE fsbi_dw_spinn.dim_claimrisk owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_claimrisk IS ' 	Source: 	ClaimPolicyInfo,PolicyRisk,PropertyDamaged,Vehicle,Risk,DriverInfo,PersonInfo,Building,Location	DW Table type:	Dimension Type 0	Table description:	Claim risks. Use FACT_CLAIMTRANSACTION.PRIMARYRISK_ID to join. It''s a table for a special purposes. Use direct links to risk items from FACT tables via VEHICLE_ID, DRIVER_ID, BUILDING_ID and LOCATION_ID';


-- fsbi_dw_spinn.dim_claimtransactiontype definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_claimtransactiontype;

--DROP TABLE fsbi_dw_spinn.dim_claimtransactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_claimtransactiontype
(
	claimtransactiontype_id INTEGER NOT NULL  ENCODE RAW
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
	,ctrans_losspaid_historical VARCHAR(1)   ENCODE lzo
	,ctrans_lossreserve_historical VARCHAR(1)   ENCODE lzo
	,ctrans_alaepaid_historical VARCHAR(1)   ENCODE lzo
	,ctrans_alaereserve_historical VARCHAR(1)   ENCODE lzo
	,ctrans_ulaepaid_historical VARCHAR(1)   ENCODE lzo
	,ctrans_ulaereserve_historical VARCHAR(1)   ENCODE lzo
	,ctrans_subroreceived_historical VARCHAR(1)   ENCODE lzo
	,ctrans_subroreserve_historical VARCHAR(1)   ENCODE lzo
	,ctrans_dccpaid VARCHAR(1)   ENCODE lzo
	,ctrans_dccreserve VARCHAR(1)   ENCODE lzo
	,ctrans_dccpaid_historical VARCHAR(1)   ENCODE lzo
	,ctrans_dccreserve_historical VARCHAR(1)   ENCODE lzo
	,ctrans_aaopaid VARCHAR(1)   ENCODE lzo
	,ctrans_aaoreserve VARCHAR(1)   ENCODE lzo
	,ctrans_aaopaid_historical VARCHAR(1)   ENCODE lzo
	,ctrans_aaoreserve_historical VARCHAR(1)   ENCODE lzo
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
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (claimtransactiontype_id)
)
DISTSTYLE AUTO
 SORTKEY (
	claimtransactiontype_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_claimtransactiontype owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_claimtransactiontype IS ' 	Source: 		DW Table type:	Dimension Type 1 (Dictionary)	Table description:	DW special table';


-- fsbi_dw_spinn.dim_classification definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_classification;

--DROP TABLE fsbi_dw_spinn.dim_classification;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_classification
(
	class_id INTEGER NOT NULL  ENCODE RAW
	,class_code VARCHAR(50)   ENCODE lzo
	,class_codename VARCHAR(50)   ENCODE lzo
	,class_codedescription VARCHAR(256)   ENCODE lzo
	,class_subcode VARCHAR(50)   ENCODE lzo
	,class_subcodename VARCHAR(50)   ENCODE lzo
	,class_subcodedescription VARCHAR(256)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (class_id)
)
DISTSTYLE AUTO
 SORTKEY (
	class_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_classification owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_classification IS ' 	Source: 	PolicyStats	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Insured items (Bicycles,Cameras,Coins) Rare used';


-- fsbi_dw_spinn.dim_coverage definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_coverage;

--DROP TABLE fsbi_dw_spinn.dim_coverage;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_coverage
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
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (coverage_id)
)
DISTSTYLE AUTO
 SORTKEY (
	coverage_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_coverage owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_coverage IS ' 	Source: 	PolicyStats, ClaimStats	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary table.  All available Coverage codes, ASL, SubLine';


-- fsbi_dw_spinn.dim_coveredrisk definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_coveredrisk;

--DROP TABLE fsbi_dw_spinn.dim_coveredrisk;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_coveredrisk
(
	coveredrisk_id INTEGER NOT NULL  ENCODE delta
	,cvrsk_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,deleted_indicator INTEGER NOT NULL  ENCODE lzo
	,cvrsk_typedescription VARCHAR(255) NOT NULL  ENCODE bytedict
	,cvrsk_item_id INTEGER NOT NULL  ENCODE RAW
	,cvrsk_item_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,cvrsk_item_type VARCHAR(10) NOT NULL  ENCODE bytedict
	,cvrsk_item_id2 INTEGER NOT NULL  ENCODE lzo
	,cvrsk_item_uniqueid2 VARCHAR(100) NOT NULL  ENCODE lzo
	,cvrsk_item_type2 VARCHAR(10) NOT NULL  ENCODE runlength
	,cvrsk_startdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,cvrsk_number INTEGER NOT NULL  ENCODE lzo
	,cvrsk_number2 INTEGER NOT NULL  ENCODE lzo
	,cvrsk_item_naturalkey VARCHAR(255) NOT NULL  ENCODE lzo
	,cvrsk_item_naturalkey2 VARCHAR(255) NOT NULL  ENCODE lzo
	,cvrsk_inceptiondate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,cvrsk_inceptiondate2 TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,policy_last_known_cvrsk_item_id INTEGER NOT NULL  ENCODE lzo
	,policy_last_known_cvrsk_item_id2 INTEGER NOT NULL  ENCODE lzo
	,policy_term_last_known_cvrsk_item_id INTEGER NOT NULL  ENCODE lzo
	,policy_term_last_known_cvrsk_item_id2 INTEGER NOT NULL  ENCODE lzo
	,spinn_systemid INTEGER NOT NULL  ENCODE lzo
	,polappinconsistency_flg VARCHAR(1) NOT NULL  ENCODE lzo
	,riskidduplicates_flg VARCHAR(1) NOT NULL  ENCODE runlength
	,risknumberduplicates_flg VARCHAR(1) NOT NULL  ENCODE runlength
	,risknaturalkeyduplicates_flg VARCHAR(1) NOT NULL  ENCODE runlength
	,risknaturalkey2duplicates_flg VARCHAR(1) NOT NULL  ENCODE runlength
	,excludeddrv_flg VARCHAR(1) NOT NULL  ENCODE lzo
	,source_system VARCHAR(5) NOT NULL  ENCODE runlength
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE runlength
	,PRIMARY KEY (coveredrisk_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	cvrsk_item_type2
	)
;
ALTER TABLE fsbi_dw_spinn.dim_coveredrisk owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_coveredrisk IS ' 	Source: 	Risk, DriverLink,Vehicle, Building, DriverInfo,PersonInfo, Location	DW Table type:	Dimension Type 0	Table description:	Risk details at the level of mid-term changes. There are very basic risk information (risk number, VIN, Driver License, inception date) and links to DIM_VEHICLE, DIM_BUILDING, DIM_DRIVER and DIM_LOCATION. Useful in special cases when Risk Type is needed. Widely used in ETL. Use direct links to risk items from FACT tables via VEHICLE_ID, DRIVER_ID, BUILDING_ID and LOCATION_ID';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_coveredrisk.cvrsk_inceptiondate IS 'Date when a vehicle (or property) was added to a policy based on transaction effective date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_coveredrisk.cvrsk_inceptiondate2 IS 'Date when a driver was added to a policy based on transaction effective date';


-- fsbi_dw_spinn.dim_coveredriskextension definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_coveredriskextension;

--DROP TABLE fsbi_dw_spinn.dim_coveredriskextension;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_coveredriskextension
(
	coveredriskextension_id INTEGER NOT NULL  ENCODE RAW
	,cvrsk_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE RAW
	,policy_id INTEGER NOT NULL  ENCODE RAW
	,deleted_indicator INTEGER NOT NULL  ENCODE RAW
	,cvrsk_startdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE RAW
	,cvrsk_group_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,cvrsk_group_id INTEGER NOT NULL  ENCODE RAW
	,cvrsk_group_name VARCHAR(100)   ENCODE RAW
	,cvrsk_group_description VARCHAR(100)   ENCODE lzo
	,spinn_systemid INTEGER NOT NULL  ENCODE RAW
	,source_system VARCHAR(100)   ENCODE RAW
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE RAW
	,PRIMARY KEY (coveredriskextension_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	loaddate
	)
;
ALTER TABLE fsbi_dw_spinn.dim_coveredriskextension owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_coveredriskextension IS ' 	Source: 	Risk,DriverInfo,Building,Location	DW Table type:	Dimension Type 0	Table description:	Risk groups description: Building Risks for Commercial, Drivers groups for Auto. See also DIM_GROUP_BRIDGE. Can be exluded in queries. The primary Id is the same as in DIM_COVEREDRISK. It was added just to describe relationshipd between risks';


-- fsbi_dw_spinn.dim_customer definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_customer;

--DROP TABLE fsbi_dw_spinn.dim_customer;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_customer
(
	customer_id INTEGER NOT NULL  ENCODE delta
	,customer_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(10) NOT NULL  ENCODE runlength
	,entitytypecd VARCHAR(30) NOT NULL  ENCODE bytedict
	,name VARCHAR(1000) NOT NULL  ENCODE lzo
	,commercialname VARCHAR(255) NOT NULL  ENCODE lzo
	,dob DATE NOT NULL  ENCODE az64
	,gender VARCHAR(5) NOT NULL  ENCODE runlength
	,maritalstatus VARCHAR(20) NOT NULL  ENCODE bytedict
	,address1 VARCHAR(255) NOT NULL  ENCODE lzo
	,address2 VARCHAR(255) NOT NULL  ENCODE lzo
	,county VARCHAR(255) NOT NULL  ENCODE lzo
	,city VARCHAR(255) NOT NULL  ENCODE lzo
	,state VARCHAR(255) NOT NULL  ENCODE bytedict
	,postalcode VARCHAR(5) NOT NULL  ENCODE lzo
	,country VARCHAR(3) NOT NULL  ENCODE runlength
	,phone VARCHAR(255) NOT NULL  ENCODE lzo
	,mobile VARCHAR(255) NOT NULL  ENCODE lzo
	,email VARCHAR(255) NOT NULL  ENCODE lzo
	,preferreddeliverymethod VARCHAR(10) NOT NULL  ENCODE lzo
	,portalinvitationsentdt DATE NOT NULL  ENCODE runlength
	,paymentreminderind VARCHAR(10) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE runlength
	,PRIMARY KEY (customer_id)
)
DISTSTYLE AUTO
 DISTKEY (customer_id)
 SORTKEY (
	email
	)
;
ALTER TABLE fsbi_dw_spinn.dim_customer owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_customer IS ' 	Source: 	Customer	DW Table type:	Dimension	Table description:	Customer name and contacts';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_customer.status IS 'Status (i.e. Active, Deleted)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_customer.entitytypecd IS 'Entity type (i.e. Individual, Business, Joint, Trust)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_customer.preferreddeliverymethod IS 'The preferred method for output delivery';
COMMENT ON COLUMN fsbi_dw_spinn.dim_customer.portalinvitationsentdt IS 'date/time when invitation to register on customer portal was last sent; in yyyyMMdd HH.mm.ss.SSS -ofst format';
COMMENT ON COLUMN fsbi_dw_spinn.dim_customer.paymentreminderind IS 'Payment Reminder Indicator';


-- fsbi_dw_spinn.dim_datareport definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_datareport;

--DROP TABLE fsbi_dw_spinn.dim_datareport;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_datareport
(
	datareport_id INTEGER NOT NULL  ENCODE az64
	,typecd VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,templateidref VARCHAR(255)   ENCODE lzo
	,vendor VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,detaildatain VARCHAR(1000)  DEFAULT '~'::character varying ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.dim_datareport owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_datareport IS 'Source: DataReportRequest, DataReport; Type: dictionary dimension with available data reports, vendors etc in SPINN';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_datareport.typecd IS 'Type of Data Report: Credit Score, CLUE, MVR';
COMMENT ON COLUMN fsbi_dw_spinn.dim_datareport.templateidref IS 'Reference id to the data report template';


-- fsbi_dw_spinn.dim_deductible definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_deductible;

--DROP TABLE fsbi_dw_spinn.dim_deductible;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_deductible
(
	deductible_id INTEGER NOT NULL  ENCODE RAW
	,cov_deductible1 NUMERIC(13,2)   ENCODE lzo
	,cov_deductible1type VARCHAR(50)   ENCODE lzo
	,cov_deductible2 NUMERIC(13,2)   ENCODE lzo
	,cov_deductible2type VARCHAR(50)   ENCODE lzo
	,cov_deductible3 NUMERIC(13,2)   ENCODE lzo
	,cov_deductible3type VARCHAR(50)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (deductible_id)
)
DISTSTYLE AUTO
 SORTKEY (
	deductible_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_deductible owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_deductible IS ' 	Source: 	PolicyStats, ClaimStats	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary table.  All available deductibles. Based on PolicyStats. As good as PolicyStats';


-- fsbi_dw_spinn.dim_discount definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_discount;

--DROP TABLE fsbi_dw_spinn.dim_discount;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_discount
(
	dim_discount_id INTEGER NOT NULL  ENCODE lzo
	,discount_name VARCHAR(250)   ENCODE lzo
	,discount_description VARCHAR(250)   ENCODE lzo
	,detail_source VARCHAR(100)   ENCODE lzo
	,created_date TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,created_by VARCHAR(250)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,PRIMARY KEY (dim_discount_id)
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.dim_discount owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_discount IS ' 	Source: 		DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary of discounts';


-- fsbi_dw_spinn.dim_driver definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_driver;

--DROP TABLE fsbi_dw_spinn.dim_driver;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_driver
(
	driver_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,record_version INTEGER NOT NULL  ENCODE lzo
	,driver_uniqueid VARCHAR(520) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(15) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,spinndriver_parentid VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE bytedict
	,driverinfocd VARCHAR(255) NOT NULL  ENCODE lzo
	,drivernumber INTEGER NOT NULL  ENCODE lzo
	,drivertypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,driverstatuscd VARCHAR(255) NOT NULL  ENCODE bytedict
	,licensenumber VARCHAR(255) NOT NULL  ENCODE lzo
	,licensedt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,licensedstateprovcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,relationshiptoinsuredcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,scholasticdiscountind VARCHAR(255) NOT NULL  ENCODE bytedict
	,mvrrequestind VARCHAR(255) NOT NULL  ENCODE lzo
	,mvrstatus VARCHAR(255) NOT NULL  ENCODE bytedict
	,mvrstatusdt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,maturedriverind VARCHAR(255) NOT NULL  ENCODE bytedict
	,drivertrainingind VARCHAR(255) NOT NULL  ENCODE lzo
	,gooddriverind VARCHAR(255) NOT NULL  ENCODE bytedict
	,accidentpreventioncoursecompletiondt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,drivertrainingcompletiondt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,accidentpreventioncourseind VARCHAR(255) NOT NULL  ENCODE lzo
	,scholasticcertificationdt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,activemilitaryind VARCHAR(255) NOT NULL  ENCODE lzo
	,permanentlicenseind VARCHAR(255) NOT NULL  ENCODE lzo
	,newtostateind VARCHAR(255) NOT NULL  ENCODE lzo
	,persontypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,gendercd VARCHAR(255) NOT NULL  ENCODE bytedict
	,birthdt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,maritalstatuscd VARCHAR(255) NOT NULL  ENCODE bytedict
	,occupationclasscd VARCHAR(255) NOT NULL  ENCODE lzo
	,positiontitle VARCHAR(255) NOT NULL  ENCODE lzo
	,currentresidencecd VARCHAR(255) NOT NULL  ENCODE lzo
	,civilservantind VARCHAR(255) NOT NULL  ENCODE lzo
	,retiredind VARCHAR(255) NOT NULL  ENCODE lzo
	,newteenexpirationdt DATE NOT NULL  ENCODE lzo
	,attachedvehicleref VARCHAR(255) NOT NULL  ENCODE lzo
	,viol_pointschargedterm INTEGER NOT NULL  ENCODE lzo
	,acci_pointschargedterm INTEGER NOT NULL  ENCODE lzo
	,susp_pointschargedterm INTEGER NOT NULL  ENCODE lzo
	,other_pointschargedterm INTEGER NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE lzo
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_record_version INTEGER NOT NULL  ENCODE lzo
	,gooddriverind_adj VARCHAR(10) NOT NULL DEFAULT 'Unknown'::character varying ENCODE lzo
	,viol_pointscharged_adj INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,acci_pointscharged_adj INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,missedviolationpoints INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,acci5yr INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,pointscharged INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,gd2a INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,gd2b INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,acci7yr INTEGER  DEFAULT 0 ENCODE az64
	,sr22feeind VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,maturecertificationdt TIMESTAMP WITHOUT TIME ZONE  DEFAULT '1900-01-01 00:00:00'::timestamp without time zone ENCODE az64
	,gooddriverpoints_chargedterm INTEGER  DEFAULT 0 ENCODE az64
	,agefirstlicensed INTEGER  DEFAULT 0 ENCODE az64
	,firstname VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,lastname VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (driver_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	driver_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_driver owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_driver IS ' 	Source: 	DriverInfo, PersonInfo, DriverPoints, LossHistory	DW Table type:	Slowly Changing Dimension Type 2	Table description:	Drivers attributes, discounts, MVR at the level of mid-term changes. ValidFrom - ValidTo are based on transaction effective dates';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.status IS 'Current status of the Driver record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.drivernumber IS 'Sequential number indicating in what order the driver was added to the policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.licensedstateprovcd IS 'State the driver is licensed in.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.gooddriverind_adj IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.viol_pointscharged_adj IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.acci_pointscharged_adj IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.missedviolationpoints IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.acci5yr IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.pointscharged IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.gd2a IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.gd2b IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.acci7yr IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.sr22feeind IS 'CA SFG Auto, added Apr 2021;	SR 22 Filing Fee applies';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.maturecertificationdt IS 'CA SFG Auto, added Apr 2021;	Mature Certificationc  date See also MatureDriverInd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.gooddriverpoints_chargedterm IS 'CA SFG Auto, added Apr 2021;	points for the good driver';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.agefirstlicensed IS 'used in Portal Quick Quote';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.firstname IS 'Driver First name based on NameInfo.GivenName and NameTypeCd = ContactName';
COMMENT ON COLUMN fsbi_dw_spinn.dim_driver.lastname IS 'Driver Last name based on NameInfo.SurName and NameTypeCd = ContactName';


-- fsbi_dw_spinn.dim_geography definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_geography;

--DROP TABLE fsbi_dw_spinn.dim_geography;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_geography
(
	geography_id INTEGER NOT NULL  ENCODE RAW
	,geo_county VARCHAR(50)   ENCODE lzo
	,geo_city VARCHAR(50)   ENCODE lzo
	,geo_state VARCHAR(50)   ENCODE bytedict
	,geo_postalcode VARCHAR(20)   ENCODE lzo
	,geo_country VARCHAR(50)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE runlength
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (geography_id)
)
DISTSTYLE AUTO
 DISTKEY (geography_id)
 SORTKEY (
	geography_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_geography owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_geography IS ' 	Source: 	Addr	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary table. The same as address but with less details (no postal code, street address etc)';


-- fsbi_dw_spinn.dim_group_bridge definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_group_bridge;

--DROP TABLE fsbi_dw_spinn.dim_group_bridge;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_group_bridge
(
	group_bridge_id INTEGER NOT NULL  ENCODE RAW
	,coveredriskextension_id INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,cvrsk_startdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,cvrsk_item_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,cvrsk_item_id INTEGER NOT NULL  ENCODE lzo
	,cvrsk_item_role VARCHAR(255) NOT NULL  ENCODE bytedict
	,status VARCHAR(10) NOT NULL  ENCODE lzo
	,cvrsk_number INTEGER NOT NULL  ENCODE lzo
	,cvrsk_item_naturalkey VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_last_known_cvrsk_item_id INTEGER NOT NULL  ENCODE lzo
	,policy_term_last_known_cvrsk_item_id INTEGER NOT NULL  ENCODE lzo
	,sourcesystem VARCHAR(10) NOT NULL  ENCODE lzo
	,spinn_systemid INTEGER NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,PRIMARY KEY (group_bridge_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	loaddate
	)
;
ALTER TABLE fsbi_dw_spinn.dim_group_bridge owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_group_bridge IS ' 	Source: 	Risk,DriverInfo,Building,Location	DW Table type:	Dimension Type 0	Table description:	Detail relationships between risks: location and buildings (buildinrisks); vehicles and not primary assigned drivers at the level of mid-term changes. If you need just number of buildings (building risks) per location or TIV you can use DIM_LOCATION';


-- fsbi_dw_spinn.dim_insured definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_insured;

--DROP TABLE fsbi_dw_spinn.dim_insured;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_insured
(
	insured_id INTEGER NOT NULL  ENCODE delta
	,policy_id INTEGER   ENCODE delta
	,insured_role VARCHAR(50)   ENCODE lzo
	,fullname VARCHAR(200)   ENCODE lzo
	,commercialname VARCHAR(200)   ENCODE lzo
	,dob TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,occupation VARCHAR(256)   ENCODE lzo
	,gender VARCHAR(10)   ENCODE lzo
	,maritalstatus VARCHAR(256)   ENCODE bytedict
	,address1 VARCHAR(150)   ENCODE lzo
	,address2 VARCHAR(150)   ENCODE lzo
	,county VARCHAR(50)   ENCODE lzo
	,city VARCHAR(50)   ENCODE text32k
	,state VARCHAR(50)   ENCODE bytedict
	,postalcode VARCHAR(20)   ENCODE lzo
	,country VARCHAR(50)   ENCODE lzo
	,telephone VARCHAR(20)   ENCODE lzo
	,fax VARCHAR(20)   ENCODE lzo
	,mobile VARCHAR(20)   ENCODE lzo
	,email VARCHAR(100)   ENCODE lzo
	,jobtitle VARCHAR(100)   ENCODE lzo
	,insured_uniqueid VARCHAR(100)   ENCODE lzo
	,insurancescore VARCHAR(255)   ENCODE lzo
	,overriddeninsurancescore VARCHAR(255)   ENCODE bytedict
	,applieddt DATE   ENCODE lzo
	,insurancescorevalue VARCHAR(5)   ENCODE lzo
	,ratepageeffectivedt TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,insscoretiervalueband VARCHAR(20)   ENCODE lzo
	,financialstabilitytier VARCHAR(20)   ENCODE bytedict
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,PRIMARY KEY (insured_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_insured owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_insured IS ' 	Source: 	Insured,NameInfo,PersonInfo,Addr,AllContacts,InsuranceScore	DW Table type:	Dimension Type 1	Table description:	Insured names, date of birth, credit scores';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_insured.applieddt IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.dim_insured.insurancescorevalue IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.dim_insured.ratepageeffectivedt IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.dim_insured.insscoretiervalueband IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.dim_insured.financialstabilitytier IS 'No historical data populated, Almost empty';


-- fsbi_dw_spinn.dim_legalentity_other definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_legalentity_other;

--DROP TABLE fsbi_dw_spinn.dim_legalentity_other;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_legalentity_other
(
	legalentity_id INTEGER NOT NULL  ENCODE RAW
	,lenty_role VARCHAR(50)   ENCODE lzo
	,lenty_number VARCHAR(50)   ENCODE lzo
	,lenty_name1 VARCHAR(100)   ENCODE lzo
	,lenty_uniqueid VARCHAR(100)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE runlength
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (legalentity_id)
)
DISTSTYLE AUTO
 SORTKEY (
	legalentity_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_legalentity_other owner to kdrogaieva;


-- fsbi_dw_spinn.dim_limit definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_limit;

--DROP TABLE fsbi_dw_spinn.dim_limit;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_limit
(
	limit_id INTEGER NOT NULL  ENCODE delta
	,cov_limit1 VARCHAR(255)   ENCODE lzo
	,cov_limit1type VARCHAR(50)   ENCODE lzo
	,cov_limit2 VARCHAR(255)   ENCODE lzo
	,cov_limit2type VARCHAR(50)   ENCODE lzo
	,cov_limit3 VARCHAR(255)   ENCODE lzo
	,cov_limit3type VARCHAR(50)   ENCODE lzo
	,cov_limit4 VARCHAR(255)   ENCODE lzo
	,cov_limit4type VARCHAR(50)   ENCODE lzo
	,cov_limit5 VARCHAR(255)   ENCODE lzo
	,cov_limit5type VARCHAR(50)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,cov_limit1_value NUMERIC(13,2)   ENCODE lzo
	,cov_limit2_value NUMERIC(13,2)   ENCODE lzo
	,cov_limit3_value NUMERIC(13,2)   ENCODE lzo
	,cov_limit4_value NUMERIC(13,2)   ENCODE lzo
	,cov_limit5_value NUMERIC(13,2)   ENCODE lzo
	,PRIMARY KEY (limit_id)
)
DISTSTYLE AUTO
 DISTKEY (limit_id)
 SORTKEY (
	cov_limit2_value
	)
;
ALTER TABLE fsbi_dw_spinn.dim_limit owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_limit IS ' 	Source: 	PolicyStats,ClaimStats	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary table.  All available  limits combinations. Based on PolicyStats. As good as PolicyStats';


-- fsbi_dw_spinn.dim_location definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_location;

--DROP TABLE fsbi_dw_spinn.dim_location;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_location
(
	location_id INTEGER NOT NULL  ENCODE RAW
	,record_version INTEGER   ENCODE lzo
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,valid_todate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,location_uniqueid VARCHAR(286)   ENCODE lzo
	,policy_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,spinnlocation_id VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE lzo
	,location_naturalkey VARCHAR(500) NOT NULL  ENCODE lzo
	,locationtypecd VARCHAR(255)   ENCODE lzo
	,locationnumber INTEGER   ENCODE lzo
	,locationdesc VARCHAR(255)   ENCODE lzo
	,classcode VARCHAR(255)   ENCODE lzo
	,protectionclass VARCHAR(255)   ENCODE lzo
	,territorycd VARCHAR(255)   ENCODE lzo
	,distfirehydrant VARCHAR(255)   ENCODE lzo
	,numbuildings VARCHAR(12)   ENCODE lzo
	,units VARCHAR(12)   ENCODE lzo
	,buildingdistance VARCHAR(255)   ENCODE lzo
	,soiltype VARCHAR(255)   ENCODE lzo
	,distbrusharea VARCHAR(255)   ENCODE lzo
	,distshoreline VARCHAR(255)   ENCODE lzo
	,manufacturedmodulartrailer VARCHAR(255)   ENCODE lzo
	,hillsideslope VARCHAR(255)   ENCODE lzo
	,locationunmodifiedliabpremium VARCHAR(12)   ENCODE lzo
	,acceptablecomprate VARCHAR(255)   ENCODE lzo
	,discountadjusted VARCHAR(255)   ENCODE lzo
	,wildfire VARCHAR(16)   ENCODE lzo
	,businessyears INTEGER   ENCODE lzo
	,businesslicenseissuedt VARCHAR(40)   ENCODE lzo
	,businesslicenseexpiredt VARCHAR(40)   ENCODE lzo
	,businesslicensestatecd VARCHAR(16)   ENCODE lzo
	,businesslicensesuspendind VARCHAR(4)   ENCODE lzo
	,accreditcarehome VARCHAR(4)   ENCODE lzo
	,firstyear INTEGER   ENCODE lzo
	,reinsurancegroup VARCHAR(1)   ENCODE lzo
	,buildinggroup VARCHAR(1)   ENCODE lzo
	,incomegroup VARCHAR(1)   ENCODE lzo
	,contentsgroup VARCHAR(1)   ENCODE lzo
	,cntbuildings INTEGER   ENCODE lzo
	,tiv_allbuildings NUMERIC(28,6)   ENCODE lzo
	,tiv_location_total NUMERIC(28,6)   ENCODE lzo
	,sourcesystem VARCHAR(5)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE lzo
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_record_version INTEGER NOT NULL  ENCODE lzo
	,PRIMARY KEY (location_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	valid_todate
	)
;
ALTER TABLE fsbi_dw_spinn.dim_location owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_location IS ' 	Source: 	Location, LocationRiskGroup, Risk, Building	DW Table type:	Slowly Changing Dimension Type 2	Table description:	Extension of DIM_BUILDING for commercial LOB  at the level of mid-term changes. ValidFrom - ValidTo are based on transaction effective dates.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_location.status IS 'Current status of the location record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_location.locationtypecd IS 'Code describing the type of location.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_location.locationnumber IS 'Sequentially incrementing number showing the order in which the location was added to the policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_location.locationdesc IS 'Description of the location.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_location.protectionclass IS 'Protection class.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_location.territorycd IS 'Code describing the territory.';


-- fsbi_dw_spinn.dim_month definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_month;

--DROP TABLE fsbi_dw_spinn.dim_month;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_month
(
	month_id INTEGER NOT NULL  ENCODE RAW
	,mon_monthname VARCHAR(25)   ENCODE text255
	,mon_monthabbr VARCHAR(4)   ENCODE text255
	,mon_reportperiod VARCHAR(6)   ENCODE lzo
	,mon_monthinquarter INTEGER   ENCODE lzo
	,mon_monthinyear INTEGER   ENCODE lzo
	,mon_year INTEGER   ENCODE lzo
	,mon_quarter INTEGER   ENCODE lzo
	,mon_startdate DATE   ENCODE lzo
	,mon_enddate DATE   ENCODE lzo
	,mon_sequence INTEGER   ENCODE lzo
	,mon_isodate VARCHAR(8)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (month_id)
)
DISTSTYLE AUTO
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_month owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_month IS 'DW Table type:	Dimension Type 1 (Dictionary)	Table description:	For backward compatibility only, not needed in new projects, all foreign keys (date fields) are integers in format YYYYMM';


-- fsbi_dw_spinn.dim_newrenewal definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_newrenewal;

--DROP TABLE fsbi_dw_spinn.dim_newrenewal;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_newrenewal
(
	newrenewal_id VARCHAR(10) NOT NULL  ENCODE RAW
	,newrenewal_type VARCHAR(25) NOT NULL  ENCODE lzo
	,PRIMARY KEY (newrenewal_id)
)
DISTSTYLE AUTO
 SORTKEY (
	newrenewal_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_newrenewal owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_newrenewal IS 'DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Not needed. New or Renewal values are available directly in FACT tables';


-- fsbi_dw_spinn.dim_policy definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_policy;

--DROP TABLE fsbi_dw_spinn.dim_policy;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_policy
(
	policy_id INTEGER NOT NULL  ENCODE delta
	,pol_policynumber VARCHAR(50)   ENCODE lzo
	,pol_policynumbersuffix VARCHAR(10)   ENCODE bytedict
	,pol_masterstate VARCHAR(50)   ENCODE bytedict
	,pol_mastercountry VARCHAR(50)   ENCODE lzo
	,pol_uniqueid VARCHAR(100)   ENCODE lzo
	,company_id INTEGER   ENCODE delta
	,pol_effectivedate DATE   ENCODE lzo
	,pol_expirationdate DATE   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (policy_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_policy owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_policy IS ' 	Source: 	BasicPolicy	DW Table type:	Dimension Type 1	Table description:	PolicyNumber, Version (pol_policynumbersuffix), State See dim_policyextension for more details';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_policy.pol_policynumber IS 'Policy number. The first 2 characters is a state abbrevation. The 3rd character defines the line of business: A for Auto, H for homeowners, F for Dwelling etc';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy.pol_policynumbersuffix IS 'Policy term version';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy.pol_masterstate IS 'PolicyNumber first 2 character';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy.pol_uniqueid IS 'Policy Term unique identifier in SPINN also known as PolicyRef in PolicyStats and some other table or SystemId and cmmContainer=''Policy''. It''s teh same as Policy_Uniqueid in all other tables in Redshift DW';


-- fsbi_dw_spinn.dim_policy_changes definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_policy_changes;

--DROP TABLE fsbi_dw_spinn.dim_policy_changes;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_policy_changes
(
	policy_changes_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,record_version INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,multicardiscountind VARCHAR(3) NOT NULL  ENCODE lzo
	,waivepolicyfeeind VARCHAR(255) NOT NULL  ENCODE lzo
	,liabilitylimitcpl VARCHAR(255) NOT NULL  ENCODE lzo
	,liabilityreductionind VARCHAR(255) NOT NULL  ENCODE lzo
	,liabilitylimitolt VARCHAR(20) NOT NULL  ENCODE lzo
	,personalliabilitylimit VARCHAR(255) NOT NULL  ENCODE lzo
	,gloccurrencelimit VARCHAR(255) NOT NULL  ENCODE lzo
	,glaggregatelimit VARCHAR(255) NOT NULL  ENCODE lzo
	,bilimit VARCHAR(255) NOT NULL  ENCODE lzo
	,pdlimit VARCHAR(255) NOT NULL  ENCODE lzo
	,umbilimit VARCHAR(255) NOT NULL  ENCODE lzo
	,medpaylimit VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_spinn_status VARCHAR(255)   ENCODE lzo
	,multipolicydiscount VARCHAR(3) NOT NULL  ENCODE lzo
	,multipolicyautodiscount VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyautonumber VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyhomediscount VARCHAR(255) NOT NULL  ENCODE lzo
	,homerelatedpolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,multipolicyumbrelladiscount VARCHAR(255) NOT NULL  ENCODE lzo
	,umbrellarelatedpolicynumber VARCHAR(255) NOT NULL  ENCODE lzo
	,cseemployeediscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,fullpaydiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,twopaydiscountind VARCHAR(255) NOT NULL  ENCODE lzo
	,eftdiscount VARCHAR(3) NOT NULL  ENCODE lzo
	,programind VARCHAR(255) NOT NULL  ENCODE lzo
	,producer_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,producer_id INTEGER NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,audit_id INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1900-01-01 00:00:00'::timestamp without time zone ENCODE lzo
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1900-01-01 00:00:00'::timestamp without time zone ENCODE lzo
	,original_record_version INTEGER NOT NULL DEFAULT 0 ENCODE lzo
	,landlordind VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,personalinjuryind VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (policy_changes_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_changes_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_policy_changes owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_policy_changes IS ' 	Source: 	BasicPolicy, Line,Building 	DW Table type:	Dimension Type 2	Table description:	Policy details';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.multicardiscountind IS 'prodcse_dw.Line.multicardiscountind: Override for Multi Car Discount on Single Car policies.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.liabilitylimitcpl IS 'prodcse_dw.Line.liabilitylimitcpl: Coverage L Liability limit for DF3, in general; in NXG Landlord policy also indicates whether DAU CPL coverage applies. (If both CPL and OLT apply, limits must match.)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.liabilitylimitolt IS 'Coverages: LIAB,D660ST1 - Premises Liability        Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.personalliabilitylimit IS 'prodcse_dw.Line.personalliabilitylimit: Personal Umbrella liability coverage limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.gloccurrencelimit IS 'prodcse_dw.Line.gloccurrencelimit: General Liability Limit (each occurrence)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.glaggregatelimit IS 'prodcse_dw.Line.glaggregatelimit: General Liability Limit (aggregate)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.bilimit IS 'Covereges: BISPL, BI  -  Bodily Injury Products: AZ-ICO , CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.pdlimit IS 'Covereges: PD  -  Property Damage Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.umbilimit IS 'Covereges: UNDUM, UIMBI, UM, UMBI  -  Un[/Under in CA SG]insured Motorist Bodily Injury Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.medpaylimit IS 'Coverages: MEDPAY      Medical Payments to Others Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.multipolicydiscount IS 'A multipolicy indicator if any type related policy exists based on: Line.MultiPolicyDiscountIn, Line.MultiPolicyDiscount2Ind for Auto and Building.MultiPolicyInd,Building.AutoHomeInd, Building.MultiPolicyIndUmbrella ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.multipolicyautodiscount IS 'Auto related policy indicator - Building..AutoHomeInd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.multipolicyautonumber IS 'PolicyNumber of Auto related policy - Building.MultiPolicyNumber or Building.OtherPolicyNumber1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.multipolicyhomediscount IS 'Homeowners related policy indicator - Line.MultiPolicyHomeDiscount';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.homerelatedpolicynumber IS 'PolicyNumber of a homeowners related policy for Auto - Line.RelatedPolicyNumber';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.multipolicyumbrelladiscount IS 'Umbrella related policy indicator - Line.PolicyDiscount2Ind for Auto or Building.MultiPolicyIndUmbrella for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.umbrellarelatedpolicynumber IS 'PolicyNumber of Umbrella related policy - Line.RelatedPolicyNumber2 for Auto or Building.MultiPolicyNumberUmbrella for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.cseemployeediscountind IS 'Line.CSEEmployeeDiscountInd for Auto or Building.EmployeeCreditInd for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.fullpaydiscountind IS 'prodcse_dw.Line.fullpaydiscountind: Specifies the Full Pay Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.twopaydiscountind IS 'prodcse_dw.Line.twopaydiscountind: Specifies 2 Pay Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.eftdiscount IS 'prodcse_dw.Line.eftdiscount: Specifies the EFT Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.programind IS 'prodcse_dw.BasicPolicy.programind: Program CSE uses for rating in the Auto line but used in other lines for reference only.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.landlordind IS 'Building.LanLordInd discount if there are more then one DF policy/property insured by the same customer. Moved from risk level (Building) to policy level';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policy_changes.personalinjuryind IS 'Coverages: PIHOM,F.31890    Personal Injury  Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';


-- fsbi_dw_spinn.dim_policyextension definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_policyextension;

--DROP TABLE fsbi_dw_spinn.dim_policyextension;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_policyextension
(
	policyextension_id INTEGER NOT NULL  ENCODE delta
	,policy_id INTEGER   ENCODE lzo
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,termdays VARCHAR(255)   ENCODE bytedict
	,carriergroupcd VARCHAR(255)   ENCODE lzo
	,statecd VARCHAR(255)   ENCODE bytedict
	,businesssourcecd VARCHAR(255)   ENCODE bytedict
	,previouscarriercd VARCHAR(255)   ENCODE lzo
	,policyformcode VARCHAR(255)   ENCODE bytedict
	,subtypecd VARCHAR(255)   ENCODE bytedict
	,payplancd VARCHAR(255)   ENCODE lzo
	,inceptiondt TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,winspolicynumber VARCHAR(255)   ENCODE lzo
	,priorpolicynumber VARCHAR(255)   ENCODE lzo
	,previouspolicynumber VARCHAR(255)   ENCODE lzo
	,affinitygroupcd VARCHAR(255)   ENCODE bytedict
	,programind VARCHAR(255)   ENCODE bytedict
	,relatedpolicynumber VARCHAR(255)   ENCODE lzo
	,quotenumber VARCHAR(255)   ENCODE lzo
	,renewaltermcd VARCHAR(255)   ENCODE bytedict
	,rewritepolicyref VARCHAR(255)   ENCODE lzo
	,rewritefrompolicyref VARCHAR(255)   ENCODE lzo
	,canceldt DATE   ENCODE lzo
	,reinstatedt DATE   ENCODE lzo
	,persistencydiscountdt DATE   ENCODE delta32k
	,paperlessdelivery VARCHAR(10)   ENCODE lzo
	,multicardiscountind VARCHAR(255)   ENCODE lzo
	,latefee VARCHAR(255)   ENCODE lzo
	,nsffee VARCHAR(255)   ENCODE lzo
	,installmentfee VARCHAR(255)   ENCODE lzo
	,batchquotesourcecd VARCHAR(255)   ENCODE bytedict
	,waivepolicyfeeind VARCHAR(255)   ENCODE bytedict
	,liabilitylimitcpl VARCHAR(255)   ENCODE bytedict
	,liabilityreductionind VARCHAR(255)   ENCODE bytedict
	,liabilitylimitolt VARCHAR(255)   ENCODE bytedict
	,personalliabilitylimit VARCHAR(255)   ENCODE lzo
	,gloccurrencelimit VARCHAR(255)   ENCODE lzo
	,glaggregatelimit VARCHAR(255)   ENCODE lzo
	,accountref VARCHAR(255)   ENCODE lzo
	,customerref VARCHAR(255)   ENCODE lzo
	,policy_spinn_status VARCHAR(255)   ENCODE bytedict
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,bilimit VARCHAR(255)   ENCODE bytedict
	,pdlimit VARCHAR(255)   ENCODE bytedict
	,umbilimit VARCHAR(255)   ENCODE bytedict
	,medpaylimit VARCHAR(255)   ENCODE bytedict
	,multipolicydiscount VARCHAR(3)   ENCODE bytedict
	,multipolicyautodiscount VARCHAR(255)   ENCODE lzo
	,multipolicyautonumber VARCHAR(255)   ENCODE lzo
	,multipolicyhomediscount VARCHAR(255)   ENCODE bytedict
	,homerelatedpolicynumber VARCHAR(255)   ENCODE lzo
	,multipolicyumbrelladiscount VARCHAR(255)   ENCODE lzo
	,umbrellarelatedpolicynumber VARCHAR(255)   ENCODE lzo
	,cseemployeediscountind VARCHAR(255)   ENCODE lzo
	,fullpaydiscountind VARCHAR(255)   ENCODE lzo
	,twopaydiscountind VARCHAR(255)   ENCODE lzo
	,primarypolicynumber VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,firstpayment DATE  DEFAULT '1900-01-01'::date ENCODE az64
	,lastpayment DATE  DEFAULT '1900-01-01'::date ENCODE az64
	,balanceamt NUMERIC(13,2)  DEFAULT 0.0 ENCODE az64
	,paidamt NUMERIC(13,2)  DEFAULT 0.0 ENCODE az64
	,landlordind VARCHAR(255)  DEFAULT 'No'::character varying ENCODE lzo
	,personalinjuryind VARCHAR(255)  DEFAULT 'No'::character varying ENCODE lzo
	,vehiclelistconfirmedind VARCHAR(4)   ENCODE lzo
	,product_uniqueid VARCHAR(100) NOT NULL DEFAULT '~'::character varying ENCODE lzo
	,altsubtypecd VARCHAR(32) NOT NULL DEFAULT '~'::character varying ENCODE bytedict
	,PRIMARY KEY (policyextension_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_policyextension owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_policyextension IS ' 	Source: 	BasicPolicy, Line, ArTrans, PaperlessDeliveryPolicy, 	DW Table type:	Dimension Type 1	Table description:	Policy details';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.carriergroupcd IS 'prodcse_dw.BasicPolicy.carriergroupcd: Carrier Group Code';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.businesssourcecd IS 'prodcse_dw.BasicPolicy.businesssourcecd: Source from which the business was original generated.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.previouscarriercd IS 'prodcse_dw.BasicPolicy.previouscarriercd: Code describing the carrier prior to the current carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.policyformcode IS 'outlines  the insuring conditions, what type of loss are coveraged, and what type of loss are excluded';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.subtypecd IS 'prodcse_dw.BasicPolicy.subtypecd: Code further defining the policy type.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.payplancd IS 'prodcse_dw.BasicPolicy.payplancd: Code describing the payment schedule defined for the policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.inceptiondt IS 'prodcse_dw.BasicPolicy.inceptiondt: Original term&#8217;s effective date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.winspolicynumber IS 'prodcse_dw.BasicPolicy.winspolicynumber: WINS Policy Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.priorpolicynumber IS 'prodcse_dw.BasicPolicy.priorpolicynumber: Indicates the previous policy number when quote is loaded from other source using batch quote load.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.previouspolicynumber IS 'prodcse_dw.BasicPolicy.previouspolicynumber: Policy number when business was with previous carrier.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.affinitygroupcd IS 'prodcse_dw.BasicPolicy.affinitygroupcd: Affinity Group Code';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.programind IS 'prodcse_dw.BasicPolicy.programind: Program CSE uses for rating in the Auto line but used in other lines for reference only.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.relatedpolicynumber IS 'prodcse_dw.Line.relatedpolicynumber: Related Policy Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.quotenumber IS 'prodcse_dw.BasicPolicy.quotenumber: Quote that the policy was generated from.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.renewaltermcd IS 'prodcse_dw.BasicPolicy.renewaltermcd: (i.e. 1 Year, 6 Months)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.rewritepolicyref IS 'prodcse_dw.BasicPolicy.rewritepolicyref: Link to policy that was rewritten from the current policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.rewritefrompolicyref IS 'prodcse_dw.BasicPolicy.rewritefrompolicyref: Link to policy from which the current policy was rewritten.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.canceldt IS 'prodcse_dw.BasicPolicy.canceldt: Last cancellation date. Important!!! Must be used with policy status column from DIM_POLICYEXTENSION because the column can be populated with other statuses';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.reinstatedt IS 'prodcse_dw.BasicPolicy.reinstatedt: Last reinstatement date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.multicardiscountind IS 'prodcse_dw.Line.multicardiscountind: Override for Multi Car Discount on Single Car policies.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.latefee IS 'Yes/No if there is LateFee AdjustmentCategoryCd transaction in ArTrans table';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.nsffee IS 'Yes/No if there is NSFFee AdjustmentCategoryCd transaction in ArTrans table';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.installmentfee IS 'Yes/No if there is InstallmentFee AdjustmentCategoryCd transaction in ArTrans table';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.batchquotesourcecd IS 'prodcse_dw.BasicPolicy.batchquotesourcecd: Code that determines from which company the quote has come from while loading though batch quote load.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.liabilitylimitcpl IS 'prodcse_dw.Line.liabilitylimitcpl: Coverage L Liability limit for DF3, in general; in NXG Landlord policy also indicates whether DAU CPL coverage applies. (If both CPL and OLT apply, limits must match.)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.liabilitylimitolt IS 'Coverages: LIAB,D660ST1 - Premises Liability        Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.personalliabilitylimit IS 'prodcse_dw.Line.personalliabilitylimit: Personal Umbrella liability coverage limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.gloccurrencelimit IS 'prodcse_dw.Line.gloccurrencelimit: General Liability Limit (each occurrence)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.glaggregatelimit IS 'prodcse_dw.Line.glaggregatelimit: General Liability Limit (aggregate)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.accountref IS 'prodcse_dw.Policy.accountref: Link to external billing account';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.customerref IS 'prodcse_dw.Policy.customerref: SystemId of the customer to which the policy is attached.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.bilimit IS 'Covereges: BISPL, BI  -  Bodily Injury Products: AZ-ICO , CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.pdlimit IS 'Covereges: PD  -  Property Damage Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.umbilimit IS 'Covereges: UNDUM, UIMBI, UM, UMBI  -  Un[/Under in CA SG]insured Motorist Bodily Injury Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.medpaylimit IS 'Coverages: MEDPAY      Medical Payments to Others Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.multipolicydiscount IS 'A multipolicy indicator if any type related policy exists based on: Line.MultiPolicyDiscountIn, Line.MultiPolicyDiscount2Ind for Auto and Building.MultiPolicyInd,Building.AutoHomeInd, Building.MultiPolicyIndUmbrella ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.multipolicyautodiscount IS 'Auto related policy indicator - Building..AutoHomeInd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.multipolicyautonumber IS 'PolicyNumber of Auto related policy - Building.MultiPolicyNumber or Building.OtherPolicyNumber1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.multipolicyhomediscount IS 'Homeowners related policy indicator - Line.MultiPolicyHomeDiscount';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.homerelatedpolicynumber IS 'PolicyNumber of a homeowners related policy for Auto - Line.RelatedPolicyNumber';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.multipolicyumbrelladiscount IS 'Umbrella related policy indicator - Line.PolicyDiscount2Ind for Auto or Building.MultiPolicyIndUmbrella for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.umbrellarelatedpolicynumber IS 'PolicyNumber of Umbrella related policy - Line.RelatedPolicyNumber2 for Auto or Building.MultiPolicyNumberUmbrella for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.cseemployeediscountind IS 'Line.CSEEmployeeDiscountInd for Auto or Building.EmployeeCreditInd for Property LOB';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.fullpaydiscountind IS 'prodcse_dw.Line.fullpaydiscountind: Specifies the Full Pay Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.twopaydiscountind IS 'prodcse_dw.Line.twopaydiscountind: Specifies 2 Pay Discount for the Policy.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.primarypolicynumber IS 'Earthquake policy primary policy from Building.PrimaryPolicyNumber OR Umbrella policy underlying Auto or Commercial policy (sometimes  comma seprated list of auto policies)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.firstpayment IS 'The date of the first policy payment from AccountStats starting from 2016';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.lastpayment IS 'The date of the last policy payment from AccountStats starting from 2016';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.balanceamt IS 'Total BalanceAmt for the policy from AccountStats starting from 2016';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.paidamt IS 'Total PaidAmt for the policy from AccountStats starting from 2016';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.landlordind IS 'Building.LanLordInd discount if there are more then one DF policy/property insured by the same customer. Moved from risk level (Building) to policy level';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.personalinjuryind IS 'Coverages: PIHOM,F.31890    Personal Injury  Products:AZ-DF3,  CA-SG-DF3,CA-SG-DF6,NV-DF3';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.vehiclelistconfirmedind IS 'CA SFG Auto, added Apr 2021;';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.product_uniqueid IS 'prodcse_dw.BasicPolicy.ProductVersionIdRef - Product UniqueId, can be used to join DIM_PRODUCT';
COMMENT ON COLUMN fsbi_dw_spinn.dim_policyextension.altsubtypecd IS 'prodcse.ProductVersionInfo.AltSubTypeCd - the same as SubTypeCd except HO3 - Homeguard as on 2022/06';


-- fsbi_dw_spinn.dim_policytransactionextension definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_policytransactionextension;

--DROP TABLE fsbi_dw_spinn.dim_policytransactionextension;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_policytransactionextension
(
	policytransactionextension_id INTEGER NOT NULL  ENCODE delta
	,policytransaction_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_id INTEGER   ENCODE delta
	,transactionnumber INTEGER   ENCODE lzo
	,policy_uniqueid VARCHAR(255)   ENCODE lzo
	,transactioncd VARCHAR(255)   ENCODE bytedict
	,transactionlongdescription VARCHAR(255)   ENCODE lzo
	,transactionshortdescription VARCHAR(255)   ENCODE lzo
	,canceltypecd VARCHAR(255)   ENCODE bytedict
	,cancelrequestedbycd VARCHAR(255)   ENCODE bytedict
	,cancelreason VARCHAR(255)   ENCODE lzo
	,policyprogramcode VARCHAR(255)   ENCODE bytedict
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE delta32k
	,PRIMARY KEY (policytransactionextension_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	transactioncd
	)
;
ALTER TABLE fsbi_dw_spinn.dim_policytransactionextension owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_policytransactionextension IS ' 	Source: 	PolicyStats, TransactionHistory	DW Table type:	Dimension Type 1	Table description:	Transaction descriptions';


-- fsbi_dw_spinn.dim_policytransactiontype definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_policytransactiontype;

--DROP TABLE fsbi_dw_spinn.dim_policytransactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_policytransactiontype
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
	,loaddate DATE NOT NULL  ENCODE lzo
	,PRIMARY KEY (policytransactiontype_id)
)
DISTSTYLE AUTO
 SORTKEY (
	policytransactiontype_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_policytransactiontype owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_policytransactiontype IS ' 	Source: 		DW Table type:	Dimension Type 1 (Dictionary)	Table description:	DW special table';


-- fsbi_dw_spinn.dim_portaluser definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_portaluser;

--DROP TABLE fsbi_dw_spinn.dim_portaluser;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_portaluser
(
	portaluser_id INTEGER NOT NULL  ENCODE RAW
	,portaluser_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,status VARCHAR(10)   ENCODE lzo
	,lastlogondt DATE   ENCODE lzo
	,registrationdt DATE   ENCODE lzo
	,logincounter INTEGER   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,PRIMARY KEY (portaluser_id)
)
DISTSTYLE AUTO
 DISTKEY (portaluser_id)
 SORTKEY (
	status
	)
;
ALTER TABLE fsbi_dw_spinn.dim_portaluser owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_portaluser IS ' 	Source: 	CustomerLogin	DW Table type:	Dimension	Table description:	Basic information about registration and last logon to Customer Portal';


-- fsbi_dw_spinn.dim_producer definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_producer;

--DROP TABLE fsbi_dw_spinn.dim_producer;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_producer
(
	producer_id INTEGER NOT NULL  ENCODE RAW
	,producer_number VARCHAR(20) NOT NULL  ENCODE lzo
	,producer_name VARCHAR(255) NOT NULL  ENCODE lzo
	,agency_type VARCHAR(11) NOT NULL  ENCODE lzo
	,address VARCHAR(510) NOT NULL  ENCODE lzo
	,city VARCHAR(80) NOT NULL  ENCODE lzo
	,state_cd VARCHAR(5) NOT NULL  ENCODE lzo
	,zip VARCHAR(10) NOT NULL  ENCODE lzo
	,phone VARCHAR(20) NOT NULL  ENCODE lzo
	,fax VARCHAR(15) NOT NULL  ENCODE lzo
	,email VARCHAR(255) NOT NULL  ENCODE lzo
	,agency_group VARCHAR(255) NOT NULL  ENCODE lzo
	,national_name VARCHAR(255) NOT NULL  ENCODE lzo
	,national_code VARCHAR(20) NOT NULL  ENCODE lzo
	,territory VARCHAR(50) NOT NULL  ENCODE lzo
	,territory_manager VARCHAR(50) NOT NULL  ENCODE lzo
	,dba VARCHAR(255) NOT NULL  ENCODE lzo
	,producer_status VARCHAR(10) NOT NULL  ENCODE lzo
	,commission_master VARCHAR(20) NOT NULL  ENCODE lzo
	,reporting_master VARCHAR(20) NOT NULL  ENCODE lzo
	,pn_appointment_date DATE NOT NULL  ENCODE az64
	,profit_sharing_master VARCHAR(20) NOT NULL  ENCODE lzo
	,producer_master VARCHAR(20) NOT NULL  ENCODE lzo
	,recognition_tier VARCHAR(100) NOT NULL  ENCODE lzo
	,rmaddress VARCHAR(100) NOT NULL  ENCODE lzo
	,rmcity VARCHAR(50) NOT NULL  ENCODE lzo
	,rmstate VARCHAR(25) NOT NULL  ENCODE lzo
	,rmzip VARCHAR(25) NOT NULL  ENCODE lzo
	,new_business_term_date DATE NOT NULL  ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,source_system VARCHAR(100) NOT NULL DEFAULT 'SPINN'::character varying ENCODE lzo
	,producer_uniqueid VARCHAR(20) NOT NULL  ENCODE lzo
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,record_version INTEGER NOT NULL  ENCODE az64
	,PRIMARY KEY (producer_id)
)
DISTSTYLE AUTO
 DISTKEY (producer_number)
 SORTKEY (
	valid_todate
	)
;
ALTER TABLE fsbi_dw_spinn.dim_producer owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_producer IS 'Current SPINN Source: AllContacts, Provider, ProducerInfo, LicensedProduct - Producer Historical changes table. It accumulates data from AMS (last export 2023-06-15) and now (2023-06-14) Agent Sync via SPINN.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.producer_id IS 'DW surrogate, unique key. 4 is default producer when there is no info. Negative IDs are from AMS entries except those which were used in FACT tables. There are different PRODUCER_IDs for the same producer (PRODUCER_NUMBER) in different period of time because the table is slowly changing dimension type 2.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.producer_number IS 'Unique producer number.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.producer_name IS 'Producer name.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.agency_type IS 'ProducerInfo.ProducerTypeCd - Agency type values are different in AMS and AgentSync.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.address IS 'AllContacts.BestAddr1 + AllContacts.BestAddr2 which are Addr table columns related to ProviderStreetAddr AddrTypeCd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.city IS 'AllContacts.BestCity which is Addr table column related to ProviderStreetAddr AddrTypeCd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.state_cd IS 'AllContacts.BestStateProvCd which is Addr table column related to ProviderStreetAddr AddrTypeCd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.zip IS 'AllContacts.BestPostalCode which is Addr table column related to ProviderStreetAddr AddrTypeCd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.phone IS 'AllContacts.PrimaryPhoneNumber';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.fax IS 'AllContacts.FaxNumber';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.email IS 'AllContacts.EmailAddress';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.agency_group IS 'ProducerInfo.AgencyGroup ';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.national_name IS 'ProducerInfo.NationalName';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.national_code IS 'ProducerInfo.NationalCode';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.territory IS 'ProducerInfo.branchcd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.territory_manager IS 'ProducerInfo.TerritoryManager';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.dba IS 'NameInfo.DBAName,"doing business as" Sub agency hired by the main agency we work with (we are B2B but our partners can be B2B too)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.producer_status IS 'Provider.Statuscd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.commission_master IS 'ProducerInfo.CommissionMaster';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.reporting_master IS 'ProducerInfo.ReportingMaster';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.pn_appointment_date IS 'ProducerInfo.appointeddt';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.profit_sharing_master IS 'ProducerInfo.ProfitSharingMaster';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.producer_master IS 'ProducerInfo.ProducerMaster';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.recognition_tier IS 'ProducerInfo.RecognitionTier';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.rmaddress IS 'Addr.Addr1+Addr.Addr2 ProviderBillingAddr AddrTypeCd. RM is "Reporting Master" and it is only AMS related entity. The data are coming into ProviderBillingAddr in SPINN from Agent Sync are market as "Shipping Addr" in AS UI and most likely is not used.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.rmcity IS 'Addr.City ProviderBillingAddr AddrTypeCd. RM is "Reporting Master" and it is only AMS related entity. The data are coming into ProviderBillingAddr in SPINN from Agent Sync are market as "Shipping Addr" in AS UI and most likely is not used.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.rmstate IS 'Addr.StateProvCd ProviderBillingAddr AddrTypeCd. RM is "Reporting Master" and it is only AMS related entity. The data are coming into ProviderBillingAddr in SPINN from Agent Sync are market as "Shipping Addr" in AS UI and most likely is not used.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.rmzip IS 'Addr.PostalCode ProviderBillingAddr AddrTypeCd. RM is "Reporting Master" and it is only AMS related entity. The data are coming into ProviderBillingAddr in SPINN from Agent Sync are market as "Shipping Addr" in AS UI and most likely is not used.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.new_business_term_date IS 'New Business Termination Date. It`s calculated in SPINN based data. Latest LicensedProduct.NewExpirationDt is used if status is NOT Active in All entries in the table. (One producer - several products and states in the table.)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.source_system IS 'AMS or SPINN as on 2023-06-14';
COMMENT ON COLUMN fsbi_dw_spinn.dim_producer.producer_uniqueid IS 'Unique producer number used in the process of load. The same as PRODUCER_NUMBER now but can be different.';


-- fsbi_dw_spinn.dim_product definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_product;

--DROP TABLE fsbi_dw_spinn.dim_product;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_product
(
	product_id INTEGER NOT NULL  ENCODE RAW
	,product_uniqueid VARCHAR(100)   ENCODE lzo
	,prdt_group VARCHAR(100)   ENCODE lzo
	,prdt_name VARCHAR(100)   ENCODE lzo
	,prdt_lob VARCHAR(50)   ENCODE lzo
	,prdt_description VARCHAR(2000)   ENCODE lzo
	,prdt_subname VARCHAR(100)   ENCODE lzo
	,prdt_amsname VARCHAR(100)   ENCODE lzo
	,prdt_portalparticipation VARCHAR(10)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,productversion VARCHAR(24)  DEFAULT '~'::character varying ENCODE lzo
	,name VARCHAR(64)  DEFAULT '~'::character varying ENCODE lzo
	,producttypecd VARCHAR(32)  DEFAULT '~'::character varying ENCODE lzo
	,carriercd VARCHAR(8)  DEFAULT '~'::character varying ENCODE lzo
	,isselect INTEGER  DEFAULT 0 ENCODE az64
	,linecd VARCHAR(32)  DEFAULT '~'::character varying ENCODE lzo
	,altsubtypecd VARCHAR(32)  DEFAULT '~'::character varying ENCODE lzo
	,subtypeshortdesc VARCHAR(64)  DEFAULT '~'::character varying ENCODE lzo
	,subtypefulldesc VARCHAR(64)  DEFAULT '~'::character varying ENCODE lzo
	,policynumberprefix VARCHAR(3)  DEFAULT '~'::character varying ENCODE lzo
	,startdt DATE  DEFAULT '1900-01-01'::date ENCODE az64
	,stopdt DATE  DEFAULT '2999-12-31'::date ENCODE az64
	,renewalstartdt DATE  DEFAULT '1900-01-01'::date ENCODE az64
	,renewalstopdt DATE  DEFAULT '2999-12-31'::date ENCODE az64
	,statecd VARCHAR(2)  DEFAULT '~'::character varying ENCODE lzo
	,contract VARCHAR(8)  DEFAULT '~'::character varying ENCODE lzo
	,lob VARCHAR(8)  DEFAULT '~'::character varying ENCODE lzo
	,propertyform VARCHAR(8)  DEFAULT '~'::character varying ENCODE lzo
	,prerenewaldays INTEGER  DEFAULT 0 ENCODE az64
	,autorenewaldays INTEGER  DEFAULT 0 ENCODE az64
	,prdt_version INTEGER  DEFAULT 0 ENCODE az64
	,elr VARCHAR(50)  DEFAULT '~'::character varying ENCODE lzo
	,ratechange_id INTEGER  DEFAULT 0 ENCODE az64
	,ratechange_name VARCHAR(100)  DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (product_id)
)
DISTSTYLE AUTO
 DISTKEY (product_id)
 SORTKEY (
	prdt_lob
	)
;
ALTER TABLE fsbi_dw_spinn.dim_product owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_product IS 'The data in the table are based on prodcse.ProductversionInfo plus calculations for backward compatibility';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_product.product_uniqueid IS 'prodcse.ProductVersionInfo.ProductVersionidRef';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_group IS 'prodcse.ProductversionInfo.CarrierGroupcd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_name IS 'Calculated based on prodcse.ProductversionInfo.SubTypeCd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_lob IS 'Calculated based on prodcse.ProductversionInfo.ProductTypecd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_description IS 'prodcse.ProductversionInfo.description';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_subname IS 'prodcse.ProductversionInfo.SubTypecd';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_amsname IS 'prodcse.ProductversionInfo.name';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_portalparticipation IS 'calculated, everything included except BusinessOwners and Commercial';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.isselect IS '1 if a product is part of the Safeguard Select program';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.contract IS 'prodcse.ProductversionInfo.Contract is a service field used in SPINN underwriting rules and user interface to make decisions about user interface stuff, like which fields to show';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.prdt_version IS 'Sequential product order number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.elr IS 'Product Grouping for Reserving';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.ratechange_id IS 'fsbi_dw_spinn.ratechange.ratechange_id';
COMMENT ON COLUMN fsbi_dw_spinn.dim_product.ratechange_name IS 'fsbi_dw_spinn.ratechange.ratechange_name';


-- fsbi_dw_spinn.dim_provider definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_provider;

--DROP TABLE fsbi_dw_spinn.dim_provider;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_provider
(
	dim_provider_key INTEGER   ENCODE az64
	,providerid INTEGER   ENCODE az64
	,lastversion VARCHAR(1)   ENCODE lzo
	,systemid INTEGER   ENCODE az64
	,updatetimestamp TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,indexname VARCHAR(255)   ENCODE lzo
	,providertypecd VARCHAR(255)   ENCODE lzo
	,statuscd VARCHAR(255)   ENCODE lzo
	,providernumber VARCHAR(255)   ENCODE lzo
	,commercialname VARCHAR(255)   ENCODE lzo
	,primaryphonenumber VARCHAR(255)   ENCODE lzo
	,emailaddr VARCHAR(255)   ENCODE lzo
	,mailingaddr1 VARCHAR(255)   ENCODE lzo
	,mailingcity VARCHAR(255)   ENCODE lzo
	,mailingpostalcode VARCHAR(255)   ENCODE lzo
	,billingaddr1 VARCHAR(255)   ENCODE lzo
	,billingcity VARCHAR(255)   ENCODE lzo
	,billingpostalcode VARCHAR(255)   ENCODE lzo
	,bestaddr1 VARCHAR(255)   ENCODE lzo
	,bestcity VARCHAR(255)   ENCODE lzo
	,bestpostalcode VARCHAR(255)   ENCODE lzo
	,providerindex1 VARCHAR(4)   ENCODE lzo
	,providerindex2 VARCHAR(4)   ENCODE lzo
	,fullindex1 VARCHAR(100)   ENCODE lzo
	,fullindex2 VARCHAR(100)   ENCODE lzo
	,insertby VARCHAR(250)   ENCODE lzo
	,insertdate VARCHAR(250)   ENCODE lzo
	,updatedby VARCHAR(250)   ENCODE lzo
	,updateddate VARCHAR(250)   ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.dim_provider owner to root;

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_provider.indexname IS 'Provider search/sort name';
COMMENT ON COLUMN fsbi_dw_spinn.dim_provider.providertypecd IS 'Type of service provider';
COMMENT ON COLUMN fsbi_dw_spinn.dim_provider.statuscd IS 'Status of Active, Inactive or Deleted';
COMMENT ON COLUMN fsbi_dw_spinn.dim_provider.providernumber IS 'Unique provider number/code';


-- fsbi_dw_spinn.dim_status definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_status;

--DROP TABLE fsbi_dw_spinn.dim_status;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_status
(
	status_id INTEGER NOT NULL  ENCODE RAW
	,stat_4sightbistatuscd VARCHAR(50) NOT NULL  ENCODE lzo
	,stat_statuscd VARCHAR(50) NOT NULL  ENCODE lzo
	,stat_status VARCHAR(100) NOT NULL  ENCODE lzo
	,stat_substatuscd VARCHAR(50) NOT NULL  ENCODE lzo
	,stat_substatus VARCHAR(100) NOT NULL  ENCODE lzo
	,stat_category VARCHAR(50) NOT NULL  ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE lzo
	,PRIMARY KEY (status_id)
)
DISTSTYLE AUTO
 SORTKEY (
	status_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_status owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_status IS 'DW Table type:	Dimension Type 1 (Dictionary)	Table description:	DW special table with policies and claims statuses';


-- fsbi_dw_spinn.dim_task definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_task;

--DROP TABLE fsbi_dw_spinn.dim_task;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_task
(
	task_id INTEGER NOT NULL  ENCODE RAW
	,task_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,templateid VARCHAR(100) NOT NULL  ENCODE bytedict
	,name VARCHAR(255) NOT NULL  ENCODE bytedict
	,description VARCHAR(255) NOT NULL  ENCODE lzo
	,text VARCHAR(255) NOT NULL  ENCODE lzo
	,note VARCHAR(255) NOT NULL  ENCODE lzo
	,comments VARCHAR(255) NOT NULL  ENCODE lzo
	,"priority" VARCHAR(255) NOT NULL  ENCODE bytedict
	,status VARCHAR(255) NOT NULL  ENCODE bytedict
	,adddt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,addedby VARCHAR(500) NOT NULL  ENCODE lzo
	,addedby_department VARCHAR(255) NOT NULL  ENCODE bytedict
	,workdt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,completedt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,completedbyuser VARCHAR(500) NOT NULL  ENCODE lzo
	,completedby_department VARCHAR(255) NOT NULL  ENCODE bytedict
	,currentowner VARCHAR(500) NOT NULL  ENCODE lzo
	,currentowner_department VARCHAR(255) NOT NULL  ENCODE bytedict
	,originalowner VARCHAR(500) NOT NULL  ENCODE lzo
	,originalowner_department VARCHAR(255) NOT NULL  ENCODE bytedict
	,criticaldtind VARCHAR(10) NOT NULL  ENCODE lzo
	,criticaldt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,reminderind VARCHAR(10) NOT NULL  ENCODE lzo
	,reminderdt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,workrequiredind VARCHAR(10) NOT NULL  ENCODE bytedict
	,applicationnumber VARCHAR(100) NOT NULL  ENCODE lzo
	,application_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policynumber VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,claimnumber VARCHAR(100) NOT NULL  ENCODE lzo
	,claimtransaction_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,claimlossnotice_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,claim_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
 SORTKEY (
	workdt
	)
;
ALTER TABLE fsbi_dw_spinn.dim_task owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_task IS 'Source:Task, TaskLink,Claim,UserInfo, Application, QuoteInfo, Basicpolicy, ClaimPolicyInfo, Provider DW Table type: Dimension Type 1 Table description: Tasks  base info';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_task.templateid IS 'Link to the template that populated the Task bean';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task."name" IS 'Task name - defaulted by template';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.description IS 'Contains the description of the task. Defaulted by the template.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.text IS 'Text of a descriptive nature to the task.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.note IS 'Additional notes descriptive to the task.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.comments IS 'Comments required when completing or deleting a task.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.priority IS 'Contains the values 0-9; 1 is the highest priority; 9 is the lowest priority; 0 is used by the system. Defaulted by the template.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.status IS 'Current status of the task.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.adddt IS 'Date the task was created.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.workdt IS 'Date that the task should be completed.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.completedt IS 'Date the status was changed to &apos;Completed&apos;.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.currentowner IS 'User or Group that the task is currently assigned to.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.originalowner IS 'User or Group that the task is originally assigned to.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.criticaldtind IS 'Indicates that a critical date is used';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.criticaldt IS 'Date after which the task will show up on a users worklist.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.reminderind IS 'Whether or not a remider should be sent to the current owner if the task is not completed by a given date.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.reminderdt IS 'Date after which reminders will be sent.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_task.workrequiredind IS 'Indicates if action is required to complete the task.';


-- fsbi_dw_spinn.dim_task_completion_category definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_task_completion_category;

--DROP TABLE fsbi_dw_spinn.dim_task_completion_category;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_task_completion_category
(
	task_completion_category_id INTEGER NOT NULL  ENCODE lzo
	,task_id INTEGER NOT NULL  ENCODE RAW
	,task_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,categorycd VARCHAR(100) NOT NULL  ENCODE lzo
	,subcategorycd VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
)
DISTSTYLE AUTO
 SORTKEY (
	task_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_task_completion_category owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_task_completion_category IS 'Source:TaskInfo DW Table type: Dimension Type 1 Table description: Tasks  base info';


-- fsbi_dw_spinn.dim_territory definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_territory;

--DROP TABLE fsbi_dw_spinn.dim_territory;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_territory
(
	territory_id INTEGER NOT NULL  ENCODE RAW
	,terr_code VARCHAR(5)   ENCODE lzo
	,terr_name VARCHAR(100)   ENCODE lzo
	,terr_category VARCHAR(50)   ENCODE lzo
	,source_system VARCHAR(100)   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (territory_id)
)
DISTSTYLE AUTO
 SORTKEY (
	territory_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_territory owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_territory IS ' 	Source: 	BasicPolicy	DW Table type:	Dimension Type 1 (Dictionary)	Table description:	Dictionary table.  All available territories. Rare used. Territory from dim_production_ams is more usable';


-- fsbi_dw_spinn.dim_time definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_time;

--DROP TABLE fsbi_dw_spinn.dim_time;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_time
(
	time_id INTEGER NOT NULL  ENCODE RAW
	,month_id INTEGER   ENCODE lzo
	,tm_date DATE   ENCODE lzo
	,tm_dayname VARCHAR(25)   ENCODE lzo
	,tm_dayabbr VARCHAR(4)   ENCODE lzo
	,tm_reportperiod VARCHAR(6)   ENCODE lzo
	,tm_isodate VARCHAR(8)   ENCODE lzo
	,tm_dayinweek INTEGER   ENCODE lzo
	,tm_dayinmonth INTEGER   ENCODE lzo
	,tm_dayinquarter INTEGER   ENCODE lzo
	,tm_dayinyear INTEGER   ENCODE lzo
	,tm_weekinmonth INTEGER   ENCODE lzo
	,tm_weekinquarter INTEGER   ENCODE lzo
	,tm_weekinyear INTEGER   ENCODE lzo
	,tm_monthname VARCHAR(25)   ENCODE lzo
	,tm_monthabbr VARCHAR(4)   ENCODE lzo
	,tm_monthinquarter INTEGER   ENCODE lzo
	,tm_monthinyear INTEGER   ENCODE lzo
	,tm_quarter INTEGER   ENCODE lzo
	,tm_year INTEGER   ENCODE lzo
	,loaddate DATE   ENCODE lzo
	,PRIMARY KEY (time_id)
)
DISTSTYLE AUTO
 SORTKEY (
	time_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_time owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_time IS 'DW Table type:	Dimension Type 1 (Dictionary)	Table description:	For backward compatibility only, not needed in new projects, all foreign keys are integers in format YYYYMMDD';


-- fsbi_dw_spinn.dim_transactiontype definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_transactiontype;

--DROP TABLE fsbi_dw_spinn.dim_transactiontype;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_transactiontype
(
	transactiontype_id SMALLINT NOT NULL  ENCODE RAW
	,trans_code VARCHAR(5) NOT NULL  ENCODE lzo
	,trans_name VARCHAR(100) NOT NULL  ENCODE lzo
	,trans_description VARCHAR(256) NOT NULL  ENCODE lzo
	,trans_subcode VARCHAR(5) NOT NULL  ENCODE runlength
	,trans_subname VARCHAR(100) NOT NULL  ENCODE runlength
	,trans_subdescription VARCHAR(256) NOT NULL  ENCODE runlength
	,trans_group VARCHAR(50)   ENCODE runlength
	,trans_rule1 VARCHAR(50)   ENCODE runlength
	,trans_rule2 VARCHAR(50)   ENCODE runlength
	,trans_rule3 VARCHAR(50)   ENCODE runlength
	,trans_category VARCHAR(50)   ENCODE text255
	,loaddate DATE NOT NULL  ENCODE runlength
	,PRIMARY KEY (transactiontype_id)
)
DISTSTYLE KEY
 DISTKEY (transactiontype_id)
 SORTKEY (
	transactiontype_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_transactiontype owner to kdrogaieva;


-- fsbi_dw_spinn.dim_userinfo definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_userinfo;

--DROP TABLE fsbi_dw_spinn.dim_userinfo;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_userinfo
(
	userinfo_id INTEGER NOT NULL  ENCODE lzo
	,userinfo_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,typecd VARCHAR(255) NOT NULL  ENCODE lzo
	,supervisor VARCHAR(255) NOT NULL  ENCODE lzo
	,lastname VARCHAR(255) NOT NULL  ENCODE lzo
	,firstname VARCHAR(255) NOT NULL  ENCODE lzo
	,terminateddt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,departmentcd VARCHAR(255) NOT NULL  ENCODE lzo
	,usermanagementgroupcd VARCHAR(250) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.dim_userinfo owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_userinfo IS 'Source:UserInfo DW Table type: Dimension Type 1 Table description: SPINN users';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.typecd IS 'The code of the user type';
COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.supervisor IS 'The supervisor of this user';
COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.lastname IS 'The last name of the user';
COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.firstname IS 'The first name of the user';
COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.terminateddt IS 'Date the user was terminated';
COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.departmentcd IS 'The department code of the user';
COMMENT ON COLUMN fsbi_dw_spinn.dim_userinfo.usermanagementgroupcd IS 'The User Management Group that the current user is a member of';


-- fsbi_dw_spinn.dim_uw_rule definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_uw_rule;

--DROP TABLE fsbi_dw_spinn.dim_uw_rule;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_uw_rule
(
	rule_id INTEGER NOT NULL  ENCODE lzo
	,rule_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,name VARCHAR(255) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.dim_uw_rule owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_uw_rule IS 'Source:ValidationError DW Table type: dictionary dimension Table description: Underwritting rules';


-- fsbi_dw_spinn.dim_uw_rules_applied definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_uw_rules_applied;

--DROP TABLE fsbi_dw_spinn.dim_uw_rules_applied;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_uw_rules_applied
(
	rules_applied_id INTEGER NOT NULL  ENCODE lzo
	,rule_id INTEGER NOT NULL  ENCODE lzo
	,application_id INTEGER NOT NULL  ENCODE RAW
	,rule_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,application_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,typecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,subtypecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,name VARCHAR(255) NOT NULL  ENCODE lzo
	,msg VARCHAR(255) NOT NULL  ENCODE lzo
	,permanentind VARCHAR(255) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_uw_rules_applied owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.dim_uw_rules_applied IS 'Source:ValidationError DW Table type: Dimension Type 1 Table description: Underwritting rules applied to Qoutes and Applications';


-- fsbi_dw_spinn.dim_vehicle definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.dim_vehicle;

--DROP TABLE fsbi_dw_spinn.dim_vehicle;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.dim_vehicle
(
	vehicle_id INTEGER NOT NULL  ENCODE RAW
	,valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,record_version INTEGER NOT NULL  ENCODE lzo
	,vehicle_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,spinnvehicle_id VARCHAR(255) NOT NULL  ENCODE lzo
	,stateprovcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,county VARCHAR(255) NOT NULL  ENCODE lzo
	,postalcode VARCHAR(255) NOT NULL  ENCODE lzo
	,city VARCHAR(255) NOT NULL  ENCODE lzo
	,addr1 VARCHAR(1023) NOT NULL  ENCODE lzo
	,addr2 VARCHAR(255) NOT NULL  ENCODE lzo
	,latitude NUMERIC(18,12) NOT NULL  ENCODE lzo
	,longitude NUMERIC(18,12) NOT NULL  ENCODE lzo
	,garagaddrflg VARCHAR(3) NOT NULL  ENCODE lzo
	,status VARCHAR(255) NOT NULL  ENCODE bytedict
	,manufacturer VARCHAR(255) NOT NULL  ENCODE lzo
	,"model" VARCHAR(255) NOT NULL  ENCODE lzo
	,modelyr VARCHAR(10) NOT NULL  ENCODE bytedict
	,vehidentificationnumber VARCHAR(255) NOT NULL  ENCODE lzo
	,validvinind VARCHAR(255) NOT NULL  ENCODE bytedict
	,vehlicensenumber VARCHAR(255) NOT NULL  ENCODE lzo
	,registrationstateprovcd VARCHAR(255) NOT NULL  ENCODE lzo
	,vehbodytypecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,performancecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,restraintcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,antibrakingsystemcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,antitheftcd VARCHAR(255) NOT NULL  ENCODE bytedict
	,enginesize VARCHAR(255) NOT NULL  ENCODE lzo
	,enginecylinders VARCHAR(255) NOT NULL  ENCODE lzo
	,enginehorsepower VARCHAR(255) NOT NULL  ENCODE lzo
	,enginetype VARCHAR(255) NOT NULL  ENCODE lzo
	,vehusecd VARCHAR(255) NOT NULL  ENCODE bytedict
	,garageterritory INTEGER NOT NULL  ENCODE lzo
	,collisionded VARCHAR(255) NOT NULL  ENCODE bytedict
	,comprehensiveded VARCHAR(255) NOT NULL  ENCODE bytedict
	,statedamt NUMERIC(28,6) NOT NULL  ENCODE lzo
	,classcd VARCHAR(255) NOT NULL  ENCODE lzo
	,ratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,costnewamt NUMERIC(28,6) NOT NULL  ENCODE lzo
	,estimatedannualdistance INTEGER NOT NULL  ENCODE lzo
	,estimatedworkdistance INTEGER NOT NULL  ENCODE lzo
	,leasedvehind VARCHAR(255) NOT NULL  ENCODE bytedict
	,purchasedt DATE NOT NULL  ENCODE lzo
	,statedamtind VARCHAR(255) NOT NULL  ENCODE lzo
	,neworusedind VARCHAR(255) NOT NULL  ENCODE bytedict
	,carpoolind VARCHAR(255) NOT NULL  ENCODE lzo
	,odometerreading VARCHAR(10) NOT NULL  ENCODE lzo
	,weekspermonthdriven VARCHAR(255) NOT NULL  ENCODE lzo
	,daylightrunninglightsind VARCHAR(255) NOT NULL  ENCODE bytedict
	,passiveseatbeltind VARCHAR(255) NOT NULL  ENCODE lzo
	,daysperweekdriven VARCHAR(255) NOT NULL  ENCODE bytedict
	,umpdlimit VARCHAR(255) NOT NULL  ENCODE lzo
	,towingandlaborind VARCHAR(255) NOT NULL  ENCODE bytedict
	,rentalreimbursementind VARCHAR(255) NOT NULL  ENCODE bytedict
	,liabilitywaiveind VARCHAR(255) NOT NULL  ENCODE bytedict
	,ratefeesind VARCHAR(255) NOT NULL  ENCODE lzo
	,optionalequipmentvalue INTEGER NOT NULL  ENCODE lzo
	,customizingequipmentind VARCHAR(255) NOT NULL  ENCODE lzo
	,customizingequipmentdesc VARCHAR(255) NOT NULL  ENCODE lzo
	,invalidvinacknowledgementind VARCHAR(255) NOT NULL  ENCODE lzo
	,ignoreumpdwcdind VARCHAR(255) NOT NULL  ENCODE lzo
	,recalculateratingsymbolind VARCHAR(255) NOT NULL  ENCODE lzo
	,programtypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,cmpratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,colratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,liabilityratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,medpayratingvalue VARCHAR(255) NOT NULL  ENCODE bytedict
	,racmpratingvalue VARCHAR(255) NOT NULL  ENCODE lzo
	,racolratingvalue VARCHAR(255) NOT NULL  ENCODE lzo
	,rabiratingsymbol VARCHAR(255) NOT NULL  ENCODE lzo
	,rapdratingsymbol VARCHAR(255) NOT NULL  ENCODE lzo
	,ramedpayratingsymbol VARCHAR(255) NOT NULL  ENCODE lzo
	,estimatedannualdistanceoverride VARCHAR(5) NOT NULL  ENCODE lzo
	,originalestimatedannualmiles VARCHAR(12) NOT NULL  ENCODE lzo
	,reportedmileagenonsave VARCHAR(12) NOT NULL  ENCODE lzo
	,mileage VARCHAR(12) NOT NULL  ENCODE bytedict
	,estimatednoncommutemiles VARCHAR(12) NOT NULL  ENCODE lzo
	,titlehistoryissue VARCHAR(3) NOT NULL  ENCODE bytedict
	,odometerproblems VARCHAR(3) NOT NULL  ENCODE lzo
	,bundle VARCHAR(15) NOT NULL  ENCODE bytedict
	,loanleasegap VARCHAR(3) NOT NULL  ENCODE lzo
	,equivalentreplacementcost VARCHAR(3) NOT NULL  ENCODE lzo
	,originalequipmentmanufacturer VARCHAR(3) NOT NULL  ENCODE lzo
	,optionalrideshare VARCHAR(3) NOT NULL  ENCODE lzo
	,medicalpartsaccessibility VARCHAR(4) NOT NULL  ENCODE bytedict
	,vehnumber INTEGER NOT NULL  ENCODE lzo
	,odometerreadingprior VARCHAR(10) NOT NULL  ENCODE lzo
	,reportedmileagenonsavedtprior DATE NOT NULL  ENCODE lzo
	,fullglasscovind VARCHAR(3) NOT NULL  ENCODE bytedict
	,recentaveragemileage INTEGER   ENCODE lzo
	,averagemileage INTEGER   ENCODE lzo
	,modeledannualmileage INTEGER   ENCODE lzo
	,firstodometermileage INTEGER   ENCODE lzo
	,firstodometerdt DATE   ENCODE lzo
	,lastodometermileage INTEGER   ENCODE lzo
	,lastodometerdt DATE   ENCODE lzo
	,lastownerlastodometermileage INTEGER   ENCODE lzo
	,californiarecentmileage INTEGER   ENCODE lzo
	,rebuiltreconstructed_firstdt DATE   ENCODE lzo
	,rebuiltreconstructed_lastdt DATE   ENCODE lzo
	,rebuiltreconstructed_firststate VARCHAR(255)   ENCODE lzo
	,rebuiltreconstructed_laststate VARCHAR(255)   ENCODE lzo
	,salvage_firstdt DATE   ENCODE lzo
	,salvage_lastdt DATE   ENCODE lzo
	,salvage_firststate VARCHAR(255)   ENCODE lzo
	,salvage_laststate VARCHAR(255)   ENCODE lzo
	,junk_firstdt DATE   ENCODE lzo
	,junk_lastdt DATE   ENCODE lzo
	,junk_firststate VARCHAR(255)   ENCODE lzo
	,junk_laststate VARCHAR(255)   ENCODE lzo
	,notactualmileage_firstdt DATE   ENCODE lzo
	,notactualmileage_lastdt DATE   ENCODE lzo
	,notactualmileage_firststate VARCHAR(255)   ENCODE lzo
	,notactualmileage_laststate VARCHAR(255)   ENCODE lzo
	,manufacturerbuybacklemon_firstdt DATE   ENCODE lzo
	,manufacturerbuybacklemon_lastdt DATE   ENCODE lzo
	,manufacturerbuybacklemon_firststate VARCHAR(255)   ENCODE lzo
	,manufacturerbuybacklemon_laststate VARCHAR(255)   ENCODE lzo
	,exceedsmechanicallimits_firstdt DATE   ENCODE lzo
	,exceedsmechanicallimits_lastdt DATE   ENCODE lzo
	,exceedsmechanicallimits_firststate VARCHAR(255)   ENCODE lzo
	,exceedsmechanicallimits_laststate VARCHAR(255)   ENCODE lzo
	,othertitlebrand VARCHAR(255)   ENCODE lzo
	,othertitlebrand_firstdt DATE   ENCODE lzo
	,othertitlebrand_lastdt DATE   ENCODE lzo
	,othertitlebrand_firststate VARCHAR(255)   ENCODE lzo
	,othertitlebrand_laststate VARCHAR(255)   ENCODE lzo
	,problemdescription VARCHAR(8000)   ENCODE lzo
	,carfaxsystemid INTEGER   ENCODE lzo
	,histcarfax201902_last_owner_average_miles INTEGER   ENCODE lzo
	,histcarfax201902_last_owner_recent_annual_mileage INTEGER   ENCODE lzo
	,histcarfax201902_last_owner_government_recent_annual_mileage INTEGER   ENCODE lzo
	,histcarfax201902_estimated_current_mileage INTEGER   ENCODE lzo
	,histcarfax201902_annual_mileage_estimate INTEGER   ENCODE lzo
	,carfaxsource VARCHAR(50)   ENCODE lzo
	,loaddate DATE NOT NULL  ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE lzo
	,original_valid_fromdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_valid_todate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,original_record_version INTEGER NOT NULL  ENCODE lzo
	,garagpostalcode VARCHAR(255)   ENCODE lzo
	,garagpostalcodeflg VARCHAR(3)   ENCODE lzo
	,boatlengthfeet VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,motorhorsepower VARCHAR(255)  DEFAULT '~'::character varying ENCODE lzo
	,replacementof INTEGER  DEFAULT 0 ENCODE az64
	,reportedmileagenonsavedt DATE  DEFAULT '1900-01-01'::date ENCODE az64
	,manufacturersymbol VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,modelsymbol VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,bodystylesymbol VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,symbolcode VARCHAR(12)  DEFAULT '~'::character varying ENCODE lzo
	,verifiedmileageoverride VARCHAR(4)  DEFAULT '~'::character varying ENCODE lzo
	,PRIMARY KEY (vehicle_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	vehicle_id
	)
;
ALTER TABLE fsbi_dw_spinn.dim_vehicle owner to kdrogaieva;

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.stateprovcd IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) State';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.county IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) County';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.postalcode IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) PostalCode';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.city IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) City';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.addr1 IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Addr1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.addr2 IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Addr2';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.latitude IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Latitude';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.longitude IS 'Vehicle or Boat Garage (if VehicleGarageAddr  State, PostalCode, City and Addr1 are all available) or Insured main location (InsuredLookupAddr AddrTypeCd) Longitude';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.garagaddrflg IS 'Flag indicating if VehicleGarageAddr (Yes) or InsuredLookupAddr (No) is used in address columns based on availability ALL VehicleGarageAddr 4 columns - State, PostalCode, City and Addr1';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.status IS 'Current status of the Vehicle record.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.manufacturer IS 'Vehicle manufacturer.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle."model" IS 'Vehicle model.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.modelyr IS 'Vehicle model year.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.vehidentificationnumber IS 'Vehicle identification number.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.validvinind IS 'Indicates if the vehicle contains a valid vin';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.vehlicensenumber IS 'Vehicle license plate number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.registrationstateprovcd IS 'State the vehicle is registered in.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.vehbodytypecd IS 'Code describing the vehicle body type.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.performancecd IS 'Vehicle performance (i.e. Standard, Intermediate, Sport, High)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.restraintcd IS 'Restaint system (i.e. Seat Belts, Air Bags)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.antibrakingsystemcd IS 'Anti-braking system (i.e. 2 Wheel, 4 Wheel)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.antitheftcd IS 'Anti-Theft (i.e. Alarm)';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.enginesize IS 'Engine Size in Liters';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.enginecylinders IS 'Number for Engine Cylinders';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.enginehorsepower IS 'Engine Horse Power';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.enginetype IS 'Engine Type';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.vehusecd IS 'Code describing the vehicle use.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.garageterritory IS 'Territory the vehicle is garaged in';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.collisionded IS 'Covereges: COLL, Collision  -  Collision Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.comprehensiveded IS 'Covereges: COMP, Comprehensive  -  Comprehensive Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.statedamt IS 'Stated amount that the vehicle is worth';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.classcd IS 'The class code of the vehicle.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.ratingvalue IS 'The vehicle&apos;s rating value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.costnewamt IS 'Cost if this vehicle was purchased new.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.estimatedannualdistance IS 'Estimated annual distance driven.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.estimatedworkdistance IS 'Estimated distance to work one way';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.leasedvehind IS 'Indicates if this is a leased vehicle.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.purchasedt IS 'Date vehicle was purchased.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.statedamtind IS 'Covereges: MPREM  -  Stated Amount Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.neworusedind IS 'Indicates if the vehicle is new or used';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.carpoolind IS 'Indicates if a car pool is used';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.odometerreading IS 'Odometer reading of the vehicle';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.weekspermonthdriven IS 'Weeks per month the vehicle is driven';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.daylightrunninglightsind IS 'Indicates if daylight running lights are equipment.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.passiveseatbeltind IS 'Indicates if passive seat belts are present';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.daysperweekdriven IS 'Number of Days per Week driven';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.umpdlimit IS 'UMPD Limit';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.towingandlaborind IS 'Covereges: ROAD  -  Roadside Assistance Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.rentalreimbursementind IS 'Covereges: RREIM, RentalReimbursement  -  Rental Reimbursement Products: AZ-ICO,CA-ICO,CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.invalidvinacknowledgementind IS 'Indicator to determine if a user acknowledges that they entered an invalid VIN.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.ignoreumpdwcdind IS 'Used to ignore the UMPD/WCD coverage validation for WINS policy types';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.recalculateratingsymbolind IS 'Used for conversion to determine when to recalculate/retrieve rating symbol.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.programtypecd IS 'Field that indicates that the vehicle is included in the SAVE Program. Value will be used to: determine which SAVE Mileage factors and Annual Mileage factors to use; determine what fields should display on the vehicle detail screen.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.cmpratingvalue IS 'Comprehensive Rating Value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.colratingvalue IS 'Collision Rating Value';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.liabilityratingvalue IS 'ISO Liability Rating Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.medpayratingvalue IS 'ISO Med Pay Rating Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.racmpratingvalue IS 'Risk Analyser Comprehensive Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.racolratingvalue IS 'Risk Analyzer Collision Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.rabiratingsymbol IS 'Risk Analyzer Bodily Injury Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.rapdratingsymbol IS 'Risk Analyzer Property Damage Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.ramedpayratingsymbol IS 'Risk Analyzer Medical Payment Symbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.estimatedannualdistanceoverride IS 'Field that determines how the EstimatedAnnualDistance value will be set if ProgramTypeCd = Save&quot;.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.originalestimatedannualmiles IS 'Field that indicates the originally estimated Annual Miles to be driven for that policy term. Value will assist in determining EstimatedAnnualDistance. Note: This field is separate from the EstimatedAnnualDistance because this value must be retained even if the EstimatedAnnualDistance changes.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.reportedmileagenonsave IS 'Mileage Reported as response to the Annual Mileage questionnaires correspondence.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.mileage IS 'Mileage';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.estimatednoncommutemiles IS 'Estimated number of miles driven for pleasure or other purposes';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.titlehistoryissue IS 'Title Salvage History issue reported by Carfax';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.bundle IS 'Bundle';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.loanleasegap IS 'Covereges: LOAN  -  Loan Lease Gap Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.equivalentreplacementcost IS 'Covereges: RRGAP  -  Equivalent Replacement Cost Products: AZ-ICO,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.originalequipmentmanufacturer IS 'Covereges: OEM  -  Original Equipment Manufacturer Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.optionalrideshare IS 'Covereges: RIDESH  -  Rideshare Products: AZ-ICO,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.medicalpartsaccessibility IS 'Covereges: CUSTE  -  Medical Parts and Accessibility Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.vehnumber IS 'Unique number identifying the vehicle within the line.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.odometerreadingprior IS 'Prior odometer reading of the vehicle';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.reportedmileagenonsavedtprior IS 'Prior date of the mileage reported as response to the Annual Mileage questionnaires correspondence';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.fullglasscovind IS 'Covereges: GLASA  -  Full Glass Products: AZ-ICO,  CA-SG,NV-ICO';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.garagpostalcode IS 'VehicleGarageAddr Postal Code even if State, City and Addr1 are not available. InsuredLookupAddr Postal Code if there is no VehicleGarageAddr Postal Code.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.garagpostalcodeflg IS 'Flag indicating if VehicleGarageAddr or InsuredLookupAddr Postal Code is used in GaragPostalCode.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.boatlengthfeet IS 'Length of boat in feet.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.motorhorsepower IS 'Horsepower of motor.';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.replacementof IS 'Replaced Vehicle Number';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.reportedmileagenonsavedt IS 'CA SFG Auto, added Apr 2021;	Odometer Date';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.manufacturersymbol IS 'CA SFG Auto, added Apr 2021;	code of the Manufacturer';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.modelsymbol IS 'CA SFG Auto, added Apr 2021;	code of the Model';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.bodystylesymbol IS 'CA SFG Auto, added Apr 2021;	code of the Body Style';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.symbolcode IS 'CA SFG Auto, added Apr 2021;	combined code of the ManufacturerSymbol,ModelSymbol and BodyStyleSymbol';
COMMENT ON COLUMN fsbi_dw_spinn.dim_vehicle.verifiedmileageoverride IS ' 	CA SFG Auto; Verified Mileage Override dropdown; Saved in Application/Line/Risk/Vehicle or Policy/Line/Risk/Vehicle ;  US21847		 ';


-- fsbi_dw_spinn.fact_application definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_application;

--DROP TABLE fsbi_dw_spinn.fact_application;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_application
(
	factapp_id INTEGER NOT NULL  ENCODE az64
	,application_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,company_id INTEGER NOT NULL  ENCODE az64
	,insured_id INTEGER NOT NULL  ENCODE az64
	,producer_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE az64
	,product_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coveragecd VARCHAR(255) NOT NULL  ENCODE lzo
	,limit_id INTEGER NOT NULL  ENCODE az64
	,deductible_id INTEGER NOT NULL  ENCODE az64
	,class_id INTEGER NOT NULL  ENCODE az64
	,building_app_id INTEGER NOT NULL  ENCODE az64
	,driver_app_id INTEGER NOT NULL  ENCODE az64
	,vehicle_app_id INTEGER NOT NULL  ENCODE az64
	,fulltermamt NUMERIC(28,6) NOT NULL  ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,customer_id INTEGER NOT NULL DEFAULT 0 ENCODE az64
	,adduser_id INTEGER NOT NULL DEFAULT 0 ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	building_app_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_application owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_application IS 'Source: Coverage,Limit,Deductible, DriverLink, Vehicle, DriverInfo, ParttyInfo, PersonalInfo,Building DW Tables type: transactional fact table Table description: Quotes and Applications coverages, limits, deductibles and premium (FullTermAmt)';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_application.application_id IS 'Foreign Key (link)  to DIM_APPLICATION ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.company_id IS 'Foreign Key (link)  to VDIM_COMPANY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.insured_id IS 'Foreign Key (link)  to DIM_INSURED ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.product_id IS 'Foreign Key (link)  to DIM_PRODUCT ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.limit_id IS 'Foreign Key (link)  to DIM_LIMIT ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.deductible_id IS 'Foreign Key (link)  to DIM_DEDUCTIBLE ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.class_id IS 'Foreign Key (link)  to DIM_CLASSIFICATION ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.building_app_id IS 'Foreign Key (link)  to DIM_APP_BUILDING ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.driver_app_id IS 'Foreign Key (link)  to DIM_APP_DRIVER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.vehicle_app_id IS 'Foreign Key (link)  to DIM_APP_VEHICLE ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.customer_id IS 'Foreign Key (link)  to DIM_CUSTOMER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_application.adduser_id IS 'adduser from prodcse_dw.QuoteInfo';


-- fsbi_dw_spinn.fact_auto_modeldata definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_auto_modeldata;

--DROP TABLE fsbi_dw_spinn.fact_auto_modeldata;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_auto_modeldata
(
	modeldata_id INTEGER   ENCODE lzo
	,systemidstart INTEGER   ENCODE lzo
	,systemidend INTEGER   ENCODE lzo
	,risk_id INTEGER   ENCODE lzo
	,risktype VARCHAR(255)   ENCODE lzo
	,policy_id INTEGER   ENCODE lzo
	,policy_changes_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER   ENCODE lzo
	,policy_uniqueid VARCHAR(20)   ENCODE lzo
	,risk_uniqueid VARCHAR(100)   ENCODE lzo
	,vehicle_id INTEGER   ENCODE lzo
	,vehicle_uniqueid VARCHAR(250)   ENCODE lzo
	,vin VARCHAR(100)   ENCODE lzo
	,risknumber INTEGER   ENCODE lzo
	,driver_id INTEGER   ENCODE lzo
	,driver_uniqueid VARCHAR(250)   ENCODE lzo
	,driverlicense VARCHAR(100)   ENCODE lzo
	,drivernumber INTEGER   ENCODE lzo
	,startdatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,enddatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,startdate DATE   ENCODE RAW
	,enddate DATE   ENCODE lzo
	,cntveh INTEGER   ENCODE lzo
	,cntdrv INTEGER   ENCODE lzo
	,cntnondrv INTEGER   ENCODE lzo
	,cntexcludeddrv INTEGER   ENCODE lzo
	,mindriverage INTEGER   ENCODE lzo
	,vehicleinceptiondate DATE   ENCODE lzo
	,driverinceptiondate DATE   ENCODE lzo
	,liabilityonly_flg VARCHAR(3)   ENCODE lzo
	,componly_flg VARCHAR(3)   ENCODE lzo
	,excludeddrv_flg VARCHAR(3)   ENCODE lzo
	,atfaultcdclaims_count INTEGER   ENCODE lzo
	,claim_count_le500 INTEGER   ENCODE lzo
	,claim_count_1000 INTEGER   ENCODE lzo
	,claim_count_1500 INTEGER   ENCODE lzo
	,claim_count_2000 INTEGER   ENCODE lzo
	,claim_count_2500 INTEGER   ENCODE lzo
	,claim_count_5k INTEGER   ENCODE lzo
	,claim_count_10k INTEGER   ENCODE lzo
	,claim_count_25k INTEGER   ENCODE lzo
	,claim_count_50k INTEGER   ENCODE lzo
	,claim_count_100k INTEGER   ENCODE lzo
	,claim_count_250k INTEGER   ENCODE lzo
	,claim_count_500k INTEGER   ENCODE lzo
	,claim_count_750k INTEGER   ENCODE lzo
	,claim_count_1m INTEGER   ENCODE lzo
	,claim_count INTEGER   ENCODE lzo
	,nc_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,coll_deductible VARCHAR(50)   ENCODE lzo
	,comp_deductible VARCHAR(50)   ENCODE lzo
	,bi_limit1 VARCHAR(50)   ENCODE lzo
	,bi_limit2 VARCHAR(50)   ENCODE lzo
	,umbi_limit1 VARCHAR(50)   ENCODE lzo
	,umbi_limit2 VARCHAR(50)   ENCODE lzo
	,pd_limit1 VARCHAR(50)   ENCODE lzo
	,pd_limit2 VARCHAR(50)   ENCODE lzo
	,coveragecd VARCHAR(6)   ENCODE bytedict
	,limit1 VARCHAR(50)   ENCODE bytedict
	,limit2 VARCHAR(50)   ENCODE bytedict
	,deductible VARCHAR(50)   ENCODE lzo
	,wp NUMERIC(38,2)   ENCODE lzo
	,cov_claim_count_le500 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_1000 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_1500 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_2000 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_2500 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_5k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_10k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_25k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_50k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_100k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_250k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_500k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_750k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_1m NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count NUMERIC(12,2)   ENCODE lzo
	,nc_cov_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,bilossinc1530 INTEGER NOT NULL  ENCODE lzo
	,umbilossinc1530 INTEGER NOT NULL  ENCODE lzo
	,uimbilossinc1530 INTEGER NOT NULL  ENCODE lzo
	,quality_polappinconsistency_flg VARCHAR(3)   ENCODE lzo
	,quality_riskidduplicates_flg VARCHAR(3)   ENCODE lzo
	,quality_excludeddrv_flg VARCHAR(3)   ENCODE lzo
	,quality_replacedvin_flg VARCHAR(3)   ENCODE lzo
	,quality_replaceddriver_flg VARCHAR(3)   ENCODE lzo
	,quality_claimok_flg INTEGER   ENCODE lzo
	,quality_claimunknownvin_flg INTEGER   ENCODE lzo
	,quality_claimunknownvinnotlisteddriver_flg INTEGER   ENCODE lzo
	,quality_claimpolicytermjoin_flg INTEGER   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (producer_id)
 SORTKEY (
	risktype
	)
;
ALTER TABLE fsbi_dw_spinn.fact_auto_modeldata owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_auto_modeldata IS 'The base of vauto_modeldata_allcov. There is a complex way to build mid-term changes from TransactionHistory, Risk, Vehicle, DriverInfo, DriverLink, Coverage, Limit, Deductible, and other claims related tables';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.risk_id IS 'Foreign Key (link)  to DIM_COVEREDRISK ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.policy_changes_id IS 'Foreign Key (link)  to DIM_POLICY_CHANGES ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.policy_uniqueid IS 'PolicyRef';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.vehicle_id IS 'Foreign Key (link)  to DIM_VEHICLE ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.vehicle_uniqueid IS 'SPINN Vehicle Id';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.driver_id IS 'Foreign Key (link)  to DIM_DRIVER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.startdatetm IS 'Exact Mid-Term Start date';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.enddatetm IS 'Exact Mid-Term End Date';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.enddate IS 'Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.cntveh IS 'Number of all vehicles in this mid-term change';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.cntdrv IS 'Number of all active drivers in this mid-term change, including non-assigned: count(distinct case when stg.status=`Active` then  stg.driver_uniqueid else null end) ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.cntnondrv IS 'Number of excluded drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) like `%EXCLUDED%`  then stg.driver_uniqueid else null end)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.cntexcludeddrv IS 'Number of Non drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) NOT like `%EXCLUDED%` and stg.DriverTypeCd in (`NonOperator`, `Excluded`, `UnderAged`) then  stg.driver_uniqueid else null end)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata.mindriverage IS 'A minimal driver age per this mid-term change. Non assigned drivers are taken into account';


-- fsbi_dw_spinn.fact_customer_rel definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_customer_rel;

--DROP TABLE fsbi_dw_spinn.fact_customer_rel;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_customer_rel
(
	customer_rel_id INTEGER NOT NULL  ENCODE lzo
	,customer_id INTEGER NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE delta
	,paperlessdeliveryind VARCHAR(10) NOT NULL  ENCODE lzo
	,lastenrollmentdt_id INTEGER NOT NULL  ENCODE lzo
	,lastunenrollmentdt_id INTEGER NOT NULL  ENCODE lzo
	,lastenrollmentmethod VARCHAR(10) NOT NULL  ENCODE bytedict
	,portaluser_id INTEGER NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE runlength
	,PRIMARY KEY (customer_rel_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	policy_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_customer_rel owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_customer_rel IS ' 	Source: 	Policy,CustomerLogin,PaperLessDeliveryPolicy	DW Table type:	Fact table	Table description:	Links between policies, customers and portal users.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_customer_rel.customer_id IS 'Foreign Key (link)  to DIM_CUSTOMER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_customer_rel.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_customer_rel.lastenrollmentdt_id IS 'Foreign Key (link)  to DIM_TIME ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_customer_rel.lastunenrollmentdt_id IS 'Foreign Key (link)  to DIM_TIME ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_customer_rel.portaluser_id IS 'Foreign Key (link)  to DIM_PORTALUSER ';


-- fsbi_dw_spinn.fact_datareport definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_datareport;

--DROP TABLE fsbi_dw_spinn.fact_datareport;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_datareport
(
	factdatareport_id INTEGER NOT NULL  ENCODE az64
	,application_id INTEGER   ENCODE RAW
	,policy_id INTEGER   ENCODE az64
	,product_id INTEGER   ENCODE az64
	,producer_id INTEGER   ENCODE az64
	,datareport_id INTEGER   ENCODE az64
	,building_app_id INTEGER   ENCODE az64
	,vehicle_app_id INTEGER   ENCODE az64
	,driver_app_id INTEGER   ENCODE az64
	,datareportrequeststatus VARCHAR(25)   ENCODE bytedict
	,datareportstatus VARCHAR(25)   ENCODE bytedict
	,datareportresult VARCHAR(255)   ENCODE lzo
	,datareportrequestadddt TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,datareportreceiveddt TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,datareporttransmitteddt TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,datareportadddt TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,policy_uniqueid VARCHAR(100)   ENCODE lzo
	,product_uniqueid VARCHAR(100)   ENCODE bytedict
	,producer_uniqueid VARCHAR(100)   ENCODE lzo
	,riskids VARCHAR(255)   ENCODE lzo
	,templateidref VARCHAR(255)   ENCODE bytedict
	,spinndatareportsystemid INTEGER   ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (application_id)
 SORTKEY (
	application_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_datareport owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_datareport IS 'Source: DataReportRequest, DataReport; Type: fact less table to join together applications, policies, products, agencies, data report requests and transmitted dates etc';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.application_id IS 'Foreign Key (link)  to DIM_APPLICATION ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.product_id IS 'Foreign Key (link)  to DIM_PRODUCT ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.datareport_id IS 'Foreign Key (link)  to DIM_DATAREPORT ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.building_app_id IS 'Foreign Key (link)  to DIM_APP_BUILDING ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.vehicle_app_id IS 'Foreign Key (link)  to DIM_APP_VEHICLE ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_datareport.driver_app_id IS 'Foreign Key (link)  to DIM_APP_DRIVER ';


-- fsbi_dw_spinn.fact_property_modeldata definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_property_modeldata;

--DROP TABLE fsbi_dw_spinn.fact_property_modeldata;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_property_modeldata
(
	modeldata_id INTEGER NOT NULL  ENCODE lzo
	,systemidstart INTEGER NOT NULL  ENCODE lzo
	,systemidend INTEGER NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policy_changes_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER NOT NULL  ENCODE lzo
	,risk_id INTEGER NOT NULL  ENCODE lzo
	,risk_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,risknumber INTEGER NOT NULL  ENCODE lzo
	,risktype VARCHAR(255) NOT NULL  ENCODE lzo
	,building_id INTEGER NOT NULL  ENCODE lzo
	,building_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,startdatetm TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,enddatetm TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,startdate DATE NOT NULL  ENCODE lzo
	,enddate DATE NOT NULL  ENCODE lzo
	,allcov_wp NUMERIC(38,2)   ENCODE lzo
	,allcov_lossinc NUMERIC(38,2)   ENCODE lzo
	,allcov_lossdcce NUMERIC(38,2)   ENCODE lzo
	,allcov_lossalae NUMERIC(38,2)   ENCODE lzo
	,cova_wp NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_wp NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_wp NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_wp NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_wp NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_wp NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_deductible VARCHAR(255) NOT NULL  ENCODE lzo
	,covb_deductible VARCHAR(255) NOT NULL  ENCODE lzo
	,covc_deductible VARCHAR(255) NOT NULL  ENCODE lzo
	,covd_deductible VARCHAR(255) NOT NULL  ENCODE lzo
	,cove_deductible VARCHAR(255) NOT NULL  ENCODE lzo
	,covf_deductible VARCHAR(255) NOT NULL  ENCODE lzo
	,cova_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,covb_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,covc_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,covd_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,cove_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,covf_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,onpremises_theft_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,awayfrompremises_theft_limit VARCHAR(255) NOT NULL  ENCODE lzo
	,quality_polappinconsistency_flg VARCHAR(3) NOT NULL  ENCODE lzo
	,quality_riskidduplicates_flg VARCHAR(3) NOT NULL  ENCODE lzo
	,quality_claimok_flg INTEGER NOT NULL  ENCODE lzo
	,quality_claimpolicytermjoin_flg INTEGER NOT NULL  ENCODE lzo
	,covabcdefliab_loss NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covabcdefliab_claim_count INTEGER NOT NULL  ENCODE lzo
	,cat_covabcdefliab_loss NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cat_covabcdefliab_claim_count INTEGER NOT NULL  ENCODE lzo
	,cova_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covb_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covc_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covd_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cove_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,covf_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo
	,liab_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo
	,cova_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,cova_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,cova_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,cova_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,cova_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,cova_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,cova_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covb_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,covb_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covb_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covb_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covb_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covb_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covb_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covc_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,covc_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covc_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covc_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covc_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covc_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covc_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covd_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,covd_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covd_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covd_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covd_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covd_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covd_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,cove_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,cove_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,cove_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,cove_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,cove_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,cove_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,cove_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covf_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,covf_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covf_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covf_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covf_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covf_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covf_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,liab_ic_nc_water INTEGER NOT NULL  ENCODE lzo
	,liab_ic_nc_wh INTEGER NOT NULL  ENCODE lzo
	,liab_ic_nc_tv INTEGER NOT NULL  ENCODE lzo
	,liab_ic_nc_fl INTEGER NOT NULL  ENCODE lzo
	,liab_ic_nc_ao INTEGER NOT NULL  ENCODE lzo
	,liab_ic_cat_fire INTEGER NOT NULL  ENCODE lzo
	,liab_ic_cat_ao INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo
	,cova_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covb_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covc_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covd_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covf_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo
	,liab_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,cova_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covb_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covc_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covd_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,cove_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,covf_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo
	,liab_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo
	,cova_fl INTEGER NOT NULL  ENCODE lzo
	,cova_sf INTEGER NOT NULL  ENCODE lzo
	,cova_ec INTEGER NOT NULL  ENCODE lzo
	,covc_fl INTEGER NOT NULL  ENCODE lzo
	,covc_sf INTEGER NOT NULL  ENCODE lzo
	,covc_ec INTEGER NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	startdatetm
	)
;
ALTER TABLE fsbi_dw_spinn.fact_property_modeldata owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_property_modeldata IS 'The base of vproperty_modeldata_allcov. There is a complex way to build mid-term changes from TransactionHistory, Risk, Building and other claim related tables.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.modeldata_id IS 'Mid-Term change unique identifier. It''s repeated for different coverages in the same mid-term change.	 ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.systemidstart IS 'Exact mid-term start SystemId from Application';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.systemidend IS 'Exact mid-term end SystemId from Application';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.policy_uniqueid IS 'PolicyRef in PolicyStats or SystemId in any other related table';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.policy_changes_id IS 'Foreign Key (link)  to DIM_POLICY_CHANGES ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.risk_id IS 'Foreign Key (link)  to DIM_COVEREDRISK ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.building_id IS 'Foreign Key (link)  to DIM_BUILDING ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.startdatetm IS 'Exact Mid-Term Start date';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.enddatetm IS 'Exact Mid-Term End Date';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.enddate IS ' 	case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end	Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.allcov_wp IS ' 	Total Policy WP 	including discounts but not fees. Total from Coverage List in SPINN UI Dwelling ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.allcov_lossinc IS ' 	Total for all coverages Paid and Incurred Losses 	See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.allcov_lossdcce IS ' 	Total for all coverages DCCE	Only DCCE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.allcov_lossalae IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.quality_polappinconsistency_flg IS 'Sometimes the latest known policy state is different from latest application data due to manual updates. I try to use "policy" instead of "aplication" data';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.quality_riskidduplicates_flg IS 'Different risks have the same number in SPINN. SPINN issue.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.quality_claimok_flg IS 'Claim is joined without an issue';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.quality_claimpolicytermjoin_flg IS 'There is an issue joining a claim to a specific mid-term change because of cancellations. It''s joined to a first mid-term change (record) per policy term.  In many cases there is just one record per policy term in homeowners policies.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covabcdefliab_loss IS ' 	Total Coverage A thru LIAB groups Paid and Incurred Loss';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cat_covabcdefliab_loss IS ' 	Catastrophe Total Coverage A thru LIAB groups  Paid and Incurred Loss';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cat_covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cova_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covb_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covc_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covd_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.cove_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.covf_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.liab_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_property_modeldata.loaddate IS 'Data last refresh date';


-- fsbi_dw_spinn.fact_task definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_task;

--DROP TABLE fsbi_dw_spinn.fact_task;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_task
(
	task_id INTEGER NOT NULL  ENCODE RAW
	,task_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,owner_id INTEGER NOT NULL  ENCODE lzo
	,owner_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo
	,workdt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,completedt TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
	,ownershiptype VARCHAR(100) NOT NULL  ENCODE bytedict
	,ageindays INTEGER   ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,product_id INTEGER NOT NULL  ENCODE lzo
	,company_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER NOT NULL  ENCODE lzo
	,customer_id INTEGER NOT NULL  ENCODE lzo
	,application_id INTEGER NOT NULL  ENCODE lzo
	,application_rule_applied_id INTEGER NOT NULL  ENCODE lzo
	,task_completion_category_id INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,customer_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,producer_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,application_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,claim_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)
DISTSTYLE AUTO
 SORTKEY (
	owner_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_task owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_task IS 'Source:Task, TaskHistory, TaskLink,Claim,UserInfo, Application, QuoteInfo, Basicpolicy, ClaimPolicyInfo, Provider DW Table type: Fact table Table description: Tasks  relations to policies, applications or quotes, owners (current and historical), applied applications rules, completion categories';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_task.task_id IS 'Foreign Key (link)  to DIM_TASK ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.owner_id IS 'Foreign Key (link)  to DIM_USERINFO ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.product_id IS 'Foreign Key (link)  to DIM_PRODUCT ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.company_id IS 'Foreign Key (link)  to VDIM_COMPANY ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.customer_id IS 'Foreign Key (link)  to DIM_CUSTOMER ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.application_id IS 'Foreign Key (link)  to DIM_APPLICATION ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.application_rule_applied_id IS 'Foreign Key (link)  to DIM_UW_RULE_APPLIED ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_task.task_completion_category_id IS 'Foreign Key (link)  to DIM_TASK_COMPLETION_CATEGORY ';


-- fsbi_dw_spinn.pcsinspectionreport definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.pcsinspectionreport;

--DROP TABLE fsbi_dw_spinn.pcsinspectionreport;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.pcsinspectionreport
(
	insp_id INTEGER NOT NULL  ENCODE az64
	,policynumber VARCHAR(50) NOT NULL  ENCODE lzo
	,insptypecd VARCHAR(255) NOT NULL  ENCODE lzo
	,inspreasoncd VARCHAR(255) NOT NULL  ENCODE lzo
	,inspreasondesccd VARCHAR(255) NOT NULL  ENCODE lzo
	,inspmemo VARCHAR(1000) NOT NULL  ENCODE lzo
	,inspordereddt DATE NOT NULL  ENCODE az64
	,inspreceiveddt DATE NOT NULL  ENCODE az64
	,inspresultcd VARCHAR(255) NOT NULL  ENCODE lzo
	,inspectionscore VARCHAR(255) NOT NULL  ENCODE lzo
	,inspdataquality VARCHAR(255) NOT NULL  ENCODE lzo
	,reinspdataquality VARCHAR(68) NOT NULL  ENCODE lzo
	,hazardscore INTEGER NOT NULL  ENCODE az64
	,casetype VARCHAR(30) NOT NULL  ENCODE lzo
	,casestatus VARCHAR(10) NOT NULL  ENCODE lzo
	,locationstate VARCHAR(2) NOT NULL  ENCODE lzo
	,locationpostalcode VARCHAR(10) NOT NULL  ENCODE lzo
	,locationcity VARCHAR(30) NOT NULL  ENCODE lzo
	,locationaddress VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE az64
	,producer_id INTEGER NOT NULL  ENCODE az64
	,task_id INTEGER NOT NULL  ENCODE az64
	,task_completion_category_id INTEGER NOT NULL  ENCODE az64
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
;
ALTER TABLE fsbi_dw_spinn.pcsinspectionreport owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.pcsinspectionreport IS 'Reporting table used in PCSInspection Report. Business Owner: Khen Pa. Source tables: Output, QuestionReply, Attachment, TaskLink, Building, reinspection data from an excel or csv file';


-- fsbi_dw_spinn.fact_claim definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_claim;

--DROP TABLE fsbi_dw_spinn.fact_claim;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_claim
(
	claimsummary_id INTEGER NOT NULL  ENCODE zstd
	,month_id INTEGER NOT NULL  ENCODE zstd
	,coverage_id INTEGER NOT NULL  ENCODE zstd
	,coverageextension_id INTEGER NOT NULL  ENCODE az64
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,adjuster_id INTEGER NOT NULL  ENCODE bytedict
	,claimant_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE zstd
	,company_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyextension_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE az64
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE az64
	,producer_id INTEGER NOT NULL  ENCODE zstd
	,policymasterterritory_id INTEGER NOT NULL  ENCODE delta
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE bytedict
	,claim_id INTEGER NOT NULL  ENCODE delta32k
	,claimextension_id INTEGER NOT NULL  ENCODE delta32k
	,claimstatus_id INTEGER NOT NULL  ENCODE lzo
	,claimlossgeography_id INTEGER NOT NULL  ENCODE delta32k
	,claimlossaddress_id INTEGER NOT NULL  ENCODE delta32k
	,datereported_id INTEGER NOT NULL  ENCODE lzo
	,dateofloss_id INTEGER NOT NULL  ENCODE lzo
	,openeddate_id INTEGER NOT NULL  ENCODE lzo
	,closeddate_id INTEGER NOT NULL  ENCODE delta32k
	,firstinsured_id INTEGER NOT NULL  ENCODE lzo
	,limit_id INTEGER NOT NULL  ENCODE lzo
	,deductible_id INTEGER NOT NULL  ENCODE delta
	,primaryrisk_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskextension_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE delta32k
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE delta32k
	,class_id INTEGER NOT NULL  ENCODE lzo
	,vehicle_id INTEGER NOT NULL  ENCODE lzo
	,driver_id INTEGER NOT NULL  ENCODE lzo
	,building_id INTEGER NOT NULL  ENCODE lzo
	,location_id INTEGER NOT NULL  ENCODE lzo
	,claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,insuredage INTEGER NOT NULL  ENCODE delta
	,loss_pd_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,loss_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,init_loss_rsrv_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,alc_exp_pd_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,alc_exp_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,ualc_exp_pd_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,ualc_exp_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,subro_recv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,subro_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,subro_paid_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,salvage_recv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,salvage_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,dedrecov_recv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,dedrecov_rsrv_chng_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,loss_pd_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,loss_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,alc_exp_pd_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,alc_exp_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,ualc_exp_pd_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,ualc_exp_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,subro_recv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,subro_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,subro_paid_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,salvage_recv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,salvage_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,dedrecov_recv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,dedrecov_rsrv_chng_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,loss_pd_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,loss_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,alc_exp_pd_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,alc_exp_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,ualc_exp_pd_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,ualc_exp_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,subro_recv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,subro_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,subro_paid_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,salvage_recv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,salvage_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,dedrecov_recv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,dedrecov_rsrv_chng_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,feat_days_open INTEGER NOT NULL  ENCODE lzo
	,feat_days_open_itd INTEGER NOT NULL  ENCODE delta32k
	,feat_opened_in_month INTEGER NOT NULL  ENCODE lzo
	,feat_closed_in_month INTEGER NOT NULL  ENCODE lzo
	,feat_closed_without_pay INTEGER NOT NULL  ENCODE lzo
	,feat_closed_with_pay INTEGER NOT NULL  ENCODE lzo
	,clm_days_open INTEGER NOT NULL  ENCODE lzo
	,clm_days_open_itd INTEGER NOT NULL  ENCODE bytedict
	,clm_opened_in_month INTEGER NOT NULL  ENCODE lzo
	,clm_closed_in_month INTEGER NOT NULL  ENCODE lzo
	,clm_closed_without_pay INTEGER NOT NULL  ENCODE lzo
	,clm_closed_with_pay INTEGER NOT NULL  ENCODE lzo
	,masterclaim INTEGER NOT NULL  ENCODE delta
	,source_system VARCHAR(100) NOT NULL  ENCODE runlength
	,loaddate DATE NOT NULL  ENCODE runlength
	,clm_reopened_in_month INTEGER   ENCODE lzo
	,feat_reopened_in_month INTEGER   ENCODE lzo
	,claim_uniqueid VARCHAR(100)   ENCODE lzo
	,clm_closed_in_month_counter INTEGER   ENCODE lzo
	,clm_closed_without_pay_counter INTEGER   ENCODE lzo
	,clm_closed_with_pay_counter INTEGER   ENCODE lzo
	,clm_reopened_in_month_counter INTEGER   ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE lzo
	,PRIMARY KEY (claimsummary_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_claim owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_claim IS ' 	Source: 	The same info as in ClaimSummaryStats but build independently in DW	DW Table type:	Fact Monthly Summary table	Table description:	Monthly claim summaries. Months are based on accounting dates. You need to aggregate amounts from this table';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.adjuster_id IS 'Foreign Key (link)  to dim_adjuster.adjuster_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claim_id IS 'Foreign Key (link)  to dim_claim.claim_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claimextension_id IS 'Foreign Key (link)  to dim_claimextension.claimextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claimstatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claimlossgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claimlossaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.datereported_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.dateofloss_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.openeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.closeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.primaryriskextension_id IS 'Foreign Key (link)  to dim_coveredriskextension.coveredriskextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.class_id IS 'Foreign Key (link)  to dim_classification.class_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claimnumber IS 'The number associated with this claim.  This is inserted into the fact table to do distinct counts.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.policy_uniqueid IS 'The policy unique ID that uniquely identifies each policy.  This value has been degenerated from the policy dimension table to provide unique counts and improved query performance.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.coverage_uniqueid IS 'The coverage unique ID that uniquely identifies each coverage.  This value has been degenerated from the coverage dimension table to provide improved performance when loading the warehouse.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.insuredage IS 'Age of the first insured.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.loss_pd_amt IS 'Loss(Indemnity) paid amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.loss_rsrv_chng_amt IS 'Change in the loss reserve(Outstanding case reserve) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.alc_exp_pd_amt IS 'Amount of allocated expenses(ALAE) paid (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.alc_exp_rsrv_chng_amt IS 'Change in allocated expense reserve(Outstanding ALAE reserve) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.ualc_exp_pd_amt IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.ualc_exp_rsrv_chng_amt IS 'Change in Defense & Cost Containment Expenses (DCCE) reserve amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.subro_recv_chng_amt IS 'Change in received(recovered) subrogation amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.subro_rsrv_chng_amt IS 'Change in reserve subrogation amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.salvage_recv_chng_amt IS 'Change in salvage received(recovered) amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.salvage_rsrv_chng_amt IS 'Change in salvage reserve amount (monthly amount)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.loss_pd_amt_ytd IS 'Loss(Indemnity) paid amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.loss_rsrv_chng_amt_ytd IS 'Change in the loss reserve(Outstanding case reserve) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.alc_exp_pd_amt_ytd IS 'Amount of allocated expenses(ALAE) paid (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.alc_exp_rsrv_chng_amt_ytd IS 'Change in allocated expense reserve(Outstanding ALAE reserve) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.ualc_exp_pd_amt_ytd IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.ualc_exp_rsrv_chng_amt_ytd IS 'Change in Defense & Cost Containment Expenses (DCCE) reserve amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.subro_recv_chng_amt_ytd IS 'Change in received(recovered) subrogation amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.subro_rsrv_chng_amt_ytd IS 'Change in reserve subrogation amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.salvage_recv_chng_amt_ytd IS 'Change in salvage received(recovered) amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.salvage_rsrv_chng_amt_ytd IS 'Change in salvage reserve amount (year-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.loss_pd_amt_itd IS 'Loss(Indemnity) paid amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.loss_rsrv_chng_amt_itd IS 'Loss reserve(Outstanding case reserve) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.alc_exp_pd_amt_itd IS 'Amount of allocated expenses(ALAE) paid (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.alc_exp_rsrv_chng_amt_itd IS 'Allocated expense reserve(Outstanding ALAE reserve) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.ualc_exp_pd_amt_itd IS 'Amount of Defense & Cost Containment Expenses (DCCE) paid (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.ualc_exp_rsrv_chng_amt_itd IS 'Defense & Cost Containment Expenses (DCCE) reserve amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.subro_recv_chng_amt_itd IS 'Change in received(recovered) subrogation amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.subro_rsrv_chng_amt_itd IS 'Amount of reserve subrogation  (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.salvage_recv_chng_amt_itd IS 'Change in salvage received(recovered) amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.salvage_rsrv_chng_amt_itd IS 'Change in salvage reserve amount (inception-to-date) *** This is a point-in-time number and should only be used with an Accounting Month and Accounting Year included in the report';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.feat_days_open IS 'Returns the number of days a claim feature has been open (month-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.feat_days_open_itd IS 'Returns the number of days a claim feature has been open (inception-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.feat_opened_in_month IS 'Indicates if the claim feature was opened in the month.  1 = Opened In the Month, 0 = Not Opened in the Month.  The field can be summed to get the number of claim  features opened in a given month.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.feat_closed_in_month IS 'Indicates if the claim feature was closed in the month.  1 = Closed In the Month, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed in a given month.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.feat_closed_without_pay IS 'Indicates if the claim feature was closed in the month and had no losses paid on it.  1 = Closed In the Month without Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed in a given month without pay.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.feat_closed_with_pay IS 'Indicates if the claim feature was closed with losses paid in the month.  1 = Closed In the Month with Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claim features closed with pay in a given month.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.clm_days_open IS 'Returns the number of days a claim has been open (month-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.clm_days_open_itd IS 'Returns the number of days a claim has been open (inception-to-date)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.clm_opened_in_month IS 'Indicates if the claim was opened in the month.  1 = Opened In the Month, 0 = Not Opened in the Month.  The field can be summed to get the number of claims opened in a given month.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.clm_closed_in_month IS 'Indicates if the claim was closed in the month.  1 = Closed In the Month, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed in a given month.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.clm_closed_without_pay IS 'Indicates if the claim was closed in the month and had no losses paid on it.  1 = Closed In the Month without Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed in a given month without pay.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.clm_closed_with_pay IS 'Indicates if the claim was closed with losses paid in the month.  1 = Closed In the Month with Pay, 0 = Not Closed in the Month.  The field can be summed to get the number of claims closed with pay in a given month.';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.masterclaim IS 'Indicates that this is the master record for the claim - the record that contains the overall claim status counts';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claim.claim_uniqueid IS 'The claim unique ID that uniquely identifies each claim.  This value has been degenerated from the claim dimension table to provide unique counts and improved query performance.';


-- fsbi_dw_spinn.fact_claimtransaction definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_claimtransaction;

--DROP TABLE fsbi_dw_spinn.fact_claimtransaction;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_claimtransaction
(
	claimtransaction_id INTEGER NOT NULL  ENCODE delta
	,transactiondate_id INTEGER NOT NULL  ENCODE runlength
	,accountingdate_id INTEGER NOT NULL  ENCODE lzo
	,claimtransactiontype_id INTEGER NOT NULL  ENCODE delta
	,adjuster_id INTEGER NOT NULL  ENCODE bytedict
	,claimant_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER NOT NULL  ENCODE lzo
	,product_id INTEGER NOT NULL  ENCODE bytedict
	,company_id INTEGER NOT NULL  ENCODE lzo
	,firstinsured_id INTEGER NOT NULL  ENCODE lzo
	,claim_id INTEGER NOT NULL  ENCODE lzo
	,claimextension_id INTEGER NOT NULL  ENCODE lzo
	,claimstatus_id INTEGER NOT NULL  ENCODE lzo
	,claimlossgeography_id INTEGER NOT NULL  ENCODE lzo
	,claimlossaddress_id INTEGER NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,policyextension_id INTEGER NOT NULL  ENCODE lzo
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE lzo
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE lzo
	,coverage_id INTEGER NOT NULL  ENCODE bytedict
	,coverageextension_id INTEGER NOT NULL  ENCODE lzo
	,limit_id INTEGER NOT NULL  ENCODE lzo
	,deductible_id INTEGER NOT NULL  ENCODE delta
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE lzo
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE lzo
	,openeddate_id INTEGER NOT NULL  ENCODE delta
	,closeddate_id INTEGER NOT NULL  ENCODE lzo
	,datereported_id INTEGER NOT NULL  ENCODE delta
	,dateofloss_id INTEGER NOT NULL  ENCODE delta
	,policymasterterritory_id INTEGER NOT NULL  ENCODE delta
	,primaryrisk_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskextension_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE bytedict
	,claimtransactionextension_id INTEGER NOT NULL  ENCODE lzo
	,class_id INTEGER NOT NULL  ENCODE lzo
	,vehicle_id INTEGER NOT NULL  ENCODE lzo
	,driver_id INTEGER NOT NULL  ENCODE lzo
	,building_id INTEGER NOT NULL  ENCODE lzo
	,location_id INTEGER NOT NULL  ENCODE lzo
	,claimnumber VARCHAR(50) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100)   ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,claimtransaction_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,transactionsequence BIGINT NOT NULL  ENCODE lzo
	,transactionflag VARCHAR(1) NOT NULL  ENCODE runlength
	,transactionstatus VARCHAR(50) NOT NULL  ENCODE runlength
	,transactionrollup VARCHAR(1) NOT NULL  ENCODE runlength
	,transactiondeleted VARCHAR(1) NOT NULL  ENCODE runlength
	,currentrecord VARCHAR(1) NOT NULL  ENCODE runlength
	,amount NUMERIC(13,2) NOT NULL  ENCODE lzo
	,source_system VARCHAR(100) NOT NULL  ENCODE runlength
	,loaddate DATE NOT NULL  ENCODE runlength
	,audit_id INTEGER NOT NULL  ENCODE runlength
	,PRIMARY KEY (claimtransaction_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	accountingdate_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_claimtransaction IS ' 	Source: 	ClaimStats	DW Table type:	Fact table	Table description:	Claim transactions with links to risk items (vehicle, driver, building)';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.transactiondate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.accountingdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.claimtransactiontype_id IS 'Foreign Key (link)  to dim_claimtransactiontype.claimtransactiontype_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.adjuster_id IS 'Foreign Key (link)  to dim_adjuster.adjuster_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.claim_id IS 'Foreign Key (link)  to dim_claim.claim_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.claimextension_id IS 'Foreign Key (link)  to dim_claimextension.claimextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.claimstatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.claimlossgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.claimlossaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.openeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.closeddate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.datereported_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.dateofloss_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.primaryriskextension_id IS 'Foreign Key (link)  to dim_coveredriskextension.coveredriskextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_claimtransaction.class_id IS 'Foreign Key (link)  to dim_classification.class_id ';


-- fsbi_dw_spinn.fact_policy definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_policy;

--DROP TABLE fsbi_dw_spinn.fact_policy;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_policy
(
	factpolicy_id INTEGER NOT NULL  ENCODE delta
	,month_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER NOT NULL  ENCODE lzo
	,product_id INTEGER NOT NULL  ENCODE bytedict
	,company_id INTEGER NOT NULL  ENCODE delta
	,firstinsured_id INTEGER NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE lzo
	,policyextension_id INTEGER NOT NULL  ENCODE lzo
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE delta32k
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE delta32k
	,policystatus_id INTEGER NOT NULL  ENCODE delta
	,policymasterterritory_id INTEGER NOT NULL  ENCODE delta
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,insuredage INTEGER NOT NULL  ENCODE delta
	,policynewissuedind INTEGER NOT NULL  ENCODE lzo
	,policyneweffectiveind INTEGER NOT NULL  ENCODE lzo
	,policyrenewedissuedind INTEGER NOT NULL  ENCODE lzo
	,policyrenewedeffectiveind INTEGER NOT NULL  ENCODE lzo
	,policyexpiredeffectiveind INTEGER NOT NULL  ENCODE lzo
	,policycancelledissuedind INTEGER NOT NULL  ENCODE lzo
	,policycancelledeffectiveind INTEGER NOT NULL  ENCODE lzo
	,policynonrenewalissuedind INTEGER NOT NULL  ENCODE lzo
	,policynonrenewaleffectiveind INTEGER NOT NULL  ENCODE lzo
	,policyendorsementissuedind INTEGER NOT NULL  ENCODE lzo
	,policyendorsementeffectiveind INTEGER NOT NULL  ENCODE lzo
	,comm_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,comm_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,comm_amt_itd NUMERIC(13,2) NOT NULL  ENCODE delta32k
	,wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,gross_wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,gross_wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,gross_wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,man_wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,man_wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,man_wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,orig_wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,orig_wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,orig_wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,term_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,term_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,term_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,earned_prem_amt NUMERIC(13,2) NOT NULL  ENCODE delta32k
	,earned_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,earned_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,unearned_prem NUMERIC(13,2) NOT NULL  ENCODE lzo
	,gross_earned_prem_amt NUMERIC(13,2) NOT NULL  ENCODE delta32k
	,gross_earned_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,gross_earned_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,comm_earned_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,comm_earned_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,comm_earned_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,endorse_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,endorse_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,endorse_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,audit_prem_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,audit_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,audit_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,cncl_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,cncl_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,cncl_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,rein_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,rein_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,rein_prem_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,taxes_amt NUMERIC(13,2) NOT NULL  ENCODE runlength
	,taxes_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,taxes_amt_itd NUMERIC(13,2) NOT NULL  ENCODE runlength
	,fees_amt NUMERIC(13,2) NOT NULL  ENCODE lzo
	,fees_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,fees_amt_itd NUMERIC(13,2) NOT NULL  ENCODE lzo
	,source_system VARCHAR(100) NOT NULL  ENCODE runlength
	,loaddate DATE NOT NULL  ENCODE runlength
	,audit_id INTEGER NOT NULL  ENCODE runlength
	,PRIMARY KEY (factpolicy_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_policy owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_policy IS 'DW Table type:	Fact Monthly Summary table	Table description:	Monthly summaries at policy term level. Months are based on accounting dates';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policyextension_id IS 'Foreign Key (link)  to dim_policyextension.policyextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policystatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.insuredage IS 'Age of the first insured. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policynewissuedind IS '"Identifies if a policy is a new policy that was *issued* for the given month and year.  Valid values are:1 = New policy issued in the month 0 = Not new in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policyrenewedissuedind IS '"Identifies if a policy is a renewal policy that was *issued* for the given month and year.  Valid values are:1 = Renewal issued in the month 0 = Not renewed in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policycancelledissuedind IS '"Identifies if a policy that was *issued* a cancellation for the given month and year.  Valid values are:1 = Cancellation issued  in the month 0 = Not cancelled in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policynonrenewalissuedind IS '"Identifies if a policy was a non-renewed policy that was *issued* in the given month and year.  Valid values are:1 = Non-renewal issued in the month 0 = Not non-renewed in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.policyendorsementissuedind IS '"Identifies if a policy had an endorsement that was *issued* for the given month and year.  Valid values are:1 = Endorsement issued in the month 0 = No endorsement issued in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.comm_amt IS 'Month-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.comm_amt_ytd IS 'Year-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.comm_amt_itd IS 'Inception-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.wrtn_prem_amt IS 'Month-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.wrtn_prem_amt_ytd IS 'Year-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.wrtn_prem_amt_itd IS 'Inception-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.gross_wrtn_prem_amt IS 'Month-to-date gross written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.gross_wrtn_prem_amt_ytd IS 'Month-to-date written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.gross_wrtn_prem_amt_itd IS 'Month-to-date written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.orig_wrtn_prem_amt IS 'Premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.orig_wrtn_prem_amt_ytd IS 'Year-to-date premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.orig_wrtn_prem_amt_itd IS 'Inception-to-date premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.term_prem_amt IS 'Full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.term_prem_amt_ytd IS 'Year-to-date full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.term_prem_amt_itd IS 'Inception-to-date Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.earned_prem_amt IS 'Month-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.earned_prem_amt_ytd IS 'Year-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.earned_prem_amt_itd IS 'Inception-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.unearned_prem IS 'Amount of premium unearned (left to be earned)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.gross_earned_prem_amt IS 'Month-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.gross_earned_prem_amt_ytd IS 'Year-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.gross_earned_prem_amt_itd IS 'Inception-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.endorse_prem_amt IS 'Month-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.endorse_prem_amt_ytd IS 'Year-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.endorse_prem_amt_itd IS 'Inception-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.cncl_prem_amt IS 'Month-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.cncl_prem_amt_ytd IS 'Year-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.cncl_prem_amt_itd IS 'Inception-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.rein_prem_amt_ytd IS 'Year-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.rein_prem_amt_itd IS 'Inception-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.rein_prem_amt IS 'Month-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.fees_amt IS 'Month-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.fees_amt_ytd IS 'Year-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policy.fees_amt_itd IS 'Inception-to-date fees collected on a policy';


-- fsbi_dw_spinn.fact_policycoverage definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_policycoverage;

--DROP TABLE fsbi_dw_spinn.fact_policycoverage;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_policycoverage
(
	factpolicycoverage_id BIGINT NOT NULL  ENCODE az64
	,month_id INTEGER NOT NULL  ENCODE zstd
	,producer_id INTEGER NOT NULL  ENCODE zstd
	,product_id INTEGER NOT NULL  ENCODE zstd
	,company_id INTEGER NOT NULL  ENCODE zstd
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyextension_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE zstd
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE zstd
	,policystatus_id INTEGER NOT NULL  ENCODE zstd
	,coverage_id INTEGER NOT NULL  ENCODE zstd
	,coverageextension_id INTEGER NOT NULL  ENCODE az64
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE zstd
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE zstd
	,policymasterterritory_id INTEGER NOT NULL  ENCODE zstd
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE zstd
	,limit_id INTEGER NOT NULL  ENCODE zstd
	,deductible_id INTEGER NOT NULL  ENCODE zstd
	,class_id INTEGER NOT NULL  ENCODE zstd
	,primaryrisk_id INTEGER NOT NULL  ENCODE zstd
	,primaryriskextension_id INTEGER NOT NULL  ENCODE az64
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE zstd
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE zstd
	,vehicle_id INTEGER NOT NULL  ENCODE zstd
	,driver_id INTEGER NOT NULL  ENCODE zstd
	,building_id INTEGER NOT NULL  ENCODE zstd
	,location_id INTEGER NOT NULL  ENCODE az64
	,month_vehicle_id INTEGER NOT NULL  ENCODE zstd
	,month_driver_id INTEGER NOT NULL  ENCODE zstd
	,month_building_id INTEGER NOT NULL  ENCODE zstd
	,month_location_id INTEGER NOT NULL  ENCODE az64
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE zstd
	,coverage_deletedindicator VARCHAR(1) NOT NULL  ENCODE zstd
	,risk_deletedindicator VARCHAR(1) NOT NULL  ENCODE zstd
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE zstd
	,coverage_uniqueid VARCHAR(100)   ENCODE zstd
	,insuredage INTEGER NOT NULL  ENCODE zstd
	,policynewissuedind INTEGER NOT NULL  ENCODE zstd
	,policyneweffectiveind INTEGER NOT NULL  ENCODE az64
	,policyrenewedissuedind INTEGER NOT NULL  ENCODE zstd
	,policyrenewedeffectiveind INTEGER NOT NULL  ENCODE az64
	,policyexpiredeffectiveind INTEGER NOT NULL  ENCODE zstd
	,policycancelledissuedind INTEGER NOT NULL  ENCODE zstd
	,policycancelledeffectiveind INTEGER NOT NULL  ENCODE zstd
	,policynonrenewalissuedind INTEGER NOT NULL  ENCODE az64
	,policynonrenewaleffectiveind INTEGER NOT NULL  ENCODE az64
	,policyendorsementissuedind INTEGER NOT NULL  ENCODE zstd
	,policyendorsementeffectiveind INTEGER NOT NULL  ENCODE az64
	,exposureamount1 VARCHAR(25) NOT NULL  ENCODE zstd
	,exposureamount2 VARCHAR(25) NOT NULL  ENCODE zstd
	,exposureamount3 VARCHAR(25) NOT NULL  ENCODE zstd
	,exposureamount4 VARCHAR(25) NOT NULL  ENCODE zstd
	,exposureamount5 VARCHAR(25) NOT NULL  ENCODE zstd
	,comm_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,comm_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,comm_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,gross_wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,gross_wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,gross_wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,man_wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,man_wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,man_wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,orig_wrtn_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,orig_wrtn_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,orig_wrtn_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,term_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,term_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,term_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,earned_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,earned_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,earned_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,unearned_prem NUMERIC(13,2) NOT NULL  ENCODE zstd
	,gross_earned_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,gross_earned_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,gross_earned_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,comm_earned_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,comm_earned_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,comm_earned_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,endorse_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,endorse_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,endorse_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,audit_prem_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,audit_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,audit_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,cncl_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,cncl_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,cncl_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,rein_prem_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,rein_prem_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,rein_prem_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,taxes_amt NUMERIC(13,2) NOT NULL  ENCODE az64
	,taxes_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE az64
	,taxes_amt_itd NUMERIC(13,2) NOT NULL  ENCODE az64
	,fees_amt NUMERIC(13,2) NOT NULL  ENCODE zstd
	,fees_amt_ytd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,fees_amt_itd NUMERIC(13,2) NOT NULL  ENCODE zstd
	,source_system VARCHAR(100) NOT NULL  ENCODE zstd
	,loaddate DATE NOT NULL  ENCODE az64
	,audit_id INTEGER NOT NULL  ENCODE zstd
	,we INTEGER  DEFAULT 0 ENCODE zstd
	,ee INTEGER  DEFAULT 0 ENCODE zstd
	,we_ytd INTEGER  DEFAULT 0 ENCODE zstd
	,ee_ytd INTEGER  DEFAULT 0 ENCODE zstd
	,we_itd INTEGER  DEFAULT 0 ENCODE zstd
	,ee_itd INTEGER  DEFAULT 0 ENCODE zstd
	,we_rm NUMERIC(38,4)  DEFAULT 0 ENCODE zstd
	,ee_rm NUMERIC(38,4)  DEFAULT 0 ENCODE zstd
	,we_rm_ytd NUMERIC(38,4)  DEFAULT 0 ENCODE zstd
	,ee_rm_ytd NUMERIC(38,4)  DEFAULT 0 ENCODE zstd
	,we_rm_itd NUMERIC(38,4)  DEFAULT 0 ENCODE zstd
	,ee_rm_itd NUMERIC(38,4)  DEFAULT 0 ENCODE zstd
	,policy_changes_id INTEGER  DEFAULT 0 ENCODE zstd
	,PRIMARY KEY (factpolicycoverage_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_policycoverage owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_policycoverage IS ' 	Source: 	The same info as in PolicySummaryStats but build independently in DW	DW Table type:	Fact Monthly Summary table	Table description:	Monthly summaries at coverage level plus monthly policy state of coverages and risks (limits, deductibles) Months are based on accounting dates. You need to aggregate amounts from this table.';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.month_id IS 'Foreign Key (link)  to dim_month.month_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policyextension_id IS 'Foreign Key (link)  to dim_policyextension.policyextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policystatus_id IS 'Foreign Key (link)  to dim_status.status_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.class_id IS 'Foreign Key (link)  to dim_classification.class_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.primaryriskextension_id IS 'Foreign Key (link)  to dim_coveredriskextension.coveredriskextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.building_id IS 'Foreign Key (link)  to dim_building.building_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.location_id IS 'Foreign Key (link)  to dim_location.location_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.month_vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the end of the specific month. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.month_driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the end of the specific month. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.month_building_id IS 'Foreign Key (link)  to dim_building.building_id	  Use this column to get attributes effective at the end of the specific month. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.month_location_id IS 'Foreign Key (link)  to dim_location.location_id	  Use this column to get attributes effective at the end of the specific month. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.insuredage IS 'Age of the first insured. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policynewissuedind IS '"Identifies if a policy is a new policy that was *issued* for the given month and year.  Valid values are:1 = New policy issued in the month 0 = Not new in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policyrenewedissuedind IS '"Identifies if a policy is a renewal policy that was *issued* for the given month and year.  Valid values are:1 = Renewal issued in the month 0 = Not renewed in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policycancelledissuedind IS '"Identifies if a policy that was *issued* a cancellation for the given month and year.  Valid values are:1 = Cancellation issued  in the month 0 = Not cancelled in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policynonrenewalissuedind IS '"Identifies if a policy was a non-renewed policy that was *issued* in the given month and year.  Valid values are:1 = Non-renewal issued in the month 0 = Not non-renewed in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policyendorsementissuedind IS '"Identifies if a policy had an endorsement that was *issued* for the given month and year.  Valid values are:1 = Endorsement issued in the month 0 = No endorsement issued in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.comm_amt IS 'Month-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.comm_amt_ytd IS 'Year-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.comm_amt_itd IS 'Inception-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.wrtn_prem_amt IS 'Month-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.wrtn_prem_amt_ytd IS 'Year-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.wrtn_prem_amt_itd IS 'Inception-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.gross_wrtn_prem_amt IS 'Month-to-date gross written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.gross_wrtn_prem_amt_ytd IS 'Month-to-date written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.gross_wrtn_prem_amt_itd IS 'Month-to-date written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.orig_wrtn_prem_amt IS 'Premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.orig_wrtn_prem_amt_ytd IS 'Year-to-date premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.orig_wrtn_prem_amt_itd IS 'Inception-to-date premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.term_prem_amt IS 'Full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.term_prem_amt_ytd IS 'Year-to-date Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.term_prem_amt_itd IS 'Inception-to-date full Inforced amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.earned_prem_amt IS 'Month-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.earned_prem_amt_ytd IS 'Year-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.earned_prem_amt_itd IS 'Inception-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.unearned_prem IS 'Amount of premium unearned (left to be earned)';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.gross_earned_prem_amt IS 'Month-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.gross_earned_prem_amt_ytd IS 'Year-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.gross_earned_prem_amt_itd IS 'Inception-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.endorse_prem_amt IS 'Month-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.endorse_prem_amt_ytd IS 'Year-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.endorse_prem_amt_itd IS 'Inception-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.cncl_prem_amt IS 'Month-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.cncl_prem_amt_ytd IS 'Year-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.cncl_prem_amt_itd IS 'Inception-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.rein_prem_amt_ytd IS 'Year-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.rein_prem_amt_itd IS 'Inception-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.rein_prem_amt IS 'Month-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.fees_amt IS 'Month-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.fees_amt_ytd IS 'Year-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.fees_amt_itd IS 'Inception-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.we IS 'Written Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.ee IS 'Earned Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.we_ytd IS 'Year To Date Written Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.ee_ytd IS 'Year To Date Earned Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.we_itd IS 'Inception To Date Written Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.ee_itd IS 'Inception To Date Earned Exposures based on  1 month = 1 exposure per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.we_rm IS 'Written Exposures  (fractional) based on term length, since what day a policy is effective in a month and number of days in a month. E.g. 1 month exposure can be 0.03 or 1.018 per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.ee_rm IS 'Earned Exposures  (fractional) based on term length, since what day a policy is effective in a month and number of days in a month. E.g. 1 month exposure can be 0.03 or 1.018 per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.we_rm_ytd IS 'Year To Date Written Exposures  (fractional) based on term length, since what day a policy is effective in a month and number of days in a month. E.g. 1 month exposure can be 0.03 or 1.018 per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.ee_rm_ytd IS 'Year To Date Earned Exposures  (fractional) based on term length, since what day a policy is effective in a month and number of days in a month. E.g. 1 month exposure can be 0.03 or 1.018 per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.we_rm_itd IS 'Inception To Date Written Exposures  (fractional) based on term length, since what day a policy is effective in a month and number of days in a month. E.g. 1 month exposure can be 0.03 or 1.018 per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.ee_rm_itd IS 'Inception To Date Earned Exposures  (fractional) based on term length, since what day a policy is effective in a month and number of days in a month. E.g. 1 month exposure can be 0.03 or 1.018 per policy term/coverage/Risk';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policycoverage.policy_changes_id IS 'NOT READY FOR USE yet. Reference to DIM_POLICY_CHANGES (variable policy level attributes). DIM_POLICY_CHANGES is updated after this table is populated';


-- fsbi_dw_spinn.fact_policytransaction definition

-- Drop table

-- DROP TABLE fsbi_dw_spinn.fact_policytransaction;

--DROP TABLE fsbi_dw_spinn.fact_policytransaction;
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.fact_policytransaction
(
	policytransaction_id INTEGER NOT NULL  ENCODE delta
	,transactiondate_id INTEGER NOT NULL  ENCODE lzo
	,accountingdate_id INTEGER NOT NULL  ENCODE lzo
	,effectivedate_id INTEGER NOT NULL  ENCODE lzo
	,firstinsured_id INTEGER NOT NULL  ENCODE az64
	,product_id INTEGER NOT NULL  ENCODE bytedict
	,company_id INTEGER NOT NULL  ENCODE delta
	,policymasterterritory_id INTEGER NOT NULL  ENCODE delta
	,primaryriskterritory_id INTEGER NOT NULL  ENCODE bytedict
	,policytransactiontype_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER NOT NULL  ENCODE lzo
	,policy_id INTEGER NOT NULL  ENCODE az64
	,policyextension_id INTEGER NOT NULL  ENCODE az64
	,policyeffectivedate_id INTEGER NOT NULL  ENCODE lzo
	,policyexpirationdate_id INTEGER NOT NULL  ENCODE lzo
	,coverage_id INTEGER NOT NULL  ENCODE bytedict
	,coverageextension_id INTEGER NOT NULL  ENCODE lzo
	,coverageeffectivedate_id INTEGER NOT NULL  ENCODE lzo
	,coverageexpirationdate_id INTEGER NOT NULL  ENCODE lzo
	,limit_id INTEGER NOT NULL  ENCODE lzo
	,deductible_id INTEGER NOT NULL  ENCODE lzo
	,policytransactionextension_id INTEGER NOT NULL  ENCODE az64
	,earnfromdate_id INTEGER NOT NULL  ENCODE lzo
	,primaryrisk_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskextension_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskgeography_id INTEGER NOT NULL  ENCODE lzo
	,primaryriskaddress_id INTEGER NOT NULL  ENCODE lzo
	,earntodate_id INTEGER NOT NULL  ENCODE lzo
	,class_id INTEGER NOT NULL  ENCODE lzo
	,vehicle_id INTEGER NOT NULL  ENCODE lzo
	,driver_id INTEGER NOT NULL  ENCODE lzo
	,building_id INTEGER NOT NULL  ENCODE lzo
	,location_id INTEGER NOT NULL  ENCODE lzo
	,trn_vehicle_id INTEGER NOT NULL  ENCODE lzo
	,trn_driver_id INTEGER NOT NULL  ENCODE lzo
	,trn_building_id INTEGER NOT NULL  ENCODE lzo
	,trn_location_id INTEGER NOT NULL  ENCODE lzo
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,coverage_uniqueid VARCHAR(100)   ENCODE lzo
	,policyneworrenewal VARCHAR(10) NOT NULL  ENCODE bytedict
	,earningstype VARCHAR(1) NOT NULL  ENCODE runlength
	,policytransaction_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo
	,transactionsequence BIGINT NOT NULL  ENCODE lzo
	,percentearnedinception NUMERIC(6,3) NOT NULL  ENCODE runlength
	,amount NUMERIC(13,2) NOT NULL DEFAULT 0 ENCODE mostly16
	,term_amount NUMERIC(13,2) NOT NULL  ENCODE lzo
	,commission_amount NUMERIC(13,2) NOT NULL DEFAULT 0 ENCODE delta32k
	,source_system VARCHAR(100) NOT NULL  ENCODE runlength
	,loaddate DATE NOT NULL  ENCODE runlength
	,transactioncd VARCHAR(255)   ENCODE bytedict
	,transactionnumber INTEGER   ENCODE lzo
	,audit_id INTEGER NOT NULL  ENCODE runlength
	,PRIMARY KEY (policytransaction_id)
)
DISTSTYLE AUTO
 DISTKEY (policy_id)
 SORTKEY (
	coverage_id
	)
;
ALTER TABLE fsbi_dw_spinn.fact_policytransaction owner to kdrogaieva;
COMMENT ON TABLE fsbi_dw_spinn.fact_policytransaction IS ' 	Source: 	PolicyStats	DW Table type:	Fact table	Table description:	Policy transactions with correct risk addresses and fully  populated risk items (vehicle, building, drivers)';

-- Column comments

COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.transactiondate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.accountingdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.effectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.firstinsured_id IS 'Foreign Key (link)  to dim_insured.insured_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.product_id IS 'Foreign Key (link)  to dim_product.product_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.company_id IS 'Foreign Key (link)  to dim_legalentity_other.legalentity_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policymasterterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.primaryriskterritory_id IS 'Foreign Key (link)  to dim_territory.territory_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policytransactiontype_id IS 'Foreign Key (link)  to dim_policytransactiontype.policytransactiontype_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.producer_id IS 'Foreign Key (link)  to dim_producer.producer_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policy_id IS 'Foreign Key (link)  to dim_policy.policy_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policyextension_id IS 'Foreign Key (link)  to dim_policyextension.policyextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policyeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policyexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.coverage_id IS 'Foreign Key (link)  to dim_coverage.coverage_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.coverageeffectivedate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.coverageexpirationdate_id IS 'Foreign Key (link)  to dim_time.time_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.limit_id IS 'Foreign Key (link)  to dim_limit.limit_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.deductible_id IS 'Foreign Key (link)  to dim_deductible.deductible_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.policytransactionextension_id IS 'Foreign Key (link)  to dim_policytransactionextension.policytransactionextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.primaryrisk_id IS 'Foreign Key (link)  to dim_coveredrisk.coveredrisk_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.primaryriskextension_id IS 'Foreign Key (link)  to dim_coveredriskextension.coveredriskextension_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.primaryriskgeography_id IS 'Foreign Key (link)  to dim_geography.geography_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.primaryriskaddress_id IS 'Foreign Key (link)  to dim_address.address_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.class_id IS 'Foreign Key (link)  to dim_classification.class_id ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.building_id IS 'Foreign Key (link)  to dim_building.building_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.location_id IS 'Foreign Key (link)  to dim_location.location_id	  Use this column to get attributes effective at the moment of a policy term expiration date or current state of the policy if it`s still active. ';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.trn_vehicle_id IS 'Foreign Key (link)  to dim_vehicle.vehicle_id	 Use this column to get attributes effective at the moment of the specific transaction';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.trn_driver_id IS 'Foreign Key (link)  to dim_driver.driver_id	 Use this column to get attributes effective at the moment of the specific transaction';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.trn_building_id IS 'Foreign Key (link)  to dim_building.building_id	 Use this column to get attributes effective at the moment of the specific transaction';
COMMENT ON COLUMN fsbi_dw_spinn.fact_policytransaction.trn_location_id IS 'Foreign Key (link)  to dim_location.location_id	 Use this column to get attributes effective at  the moment of the specific transaction';


-- fsbi_dw_spinn.fact_claim foreign keys

ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_adjuster_id_fkey FOREIGN KEY (adjuster_id) REFERENCES fsbi_dw_spinn.dim_adjuster(adjuster_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_building_id_fkey FOREIGN KEY (building_id) REFERENCES fsbi_dw_spinn.dim_building(building_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES fsbi_dw_spinn.dim_claim(claim_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claimant_id_fkey FOREIGN KEY (claimant_id) REFERENCES fsbi_dw_spinn.dim_claimant(claimant_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claimextension_id_fkey FOREIGN KEY (claimextension_id) REFERENCES fsbi_dw_spinn.dim_claimextension(claimextension_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claimlossaddress_id_fkey FOREIGN KEY (claimlossaddress_id) REFERENCES fsbi_dw_spinn.dim_address(address_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claimlossgeography_id_fkey FOREIGN KEY (claimlossgeography_id) REFERENCES fsbi_dw_spinn.dim_geography(geography_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claimrisk_id_fkey FOREIGN KEY (primaryrisk_id) REFERENCES fsbi_dw_spinn.dim_claimrisk(claimrisk_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_claimstatus_id_fkey FOREIGN KEY (claimstatus_id) REFERENCES fsbi_dw_spinn.dim_status(status_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_class_id_fkey FOREIGN KEY (class_id) REFERENCES fsbi_dw_spinn.dim_classification(class_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_closeddate_id_fkey FOREIGN KEY (closeddate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_company_id_fkey FOREIGN KEY (company_id) REFERENCES fsbi_dw_spinn.dim_legalentity_other(legalentity_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_coverage_id_fkey FOREIGN KEY (coverage_id) REFERENCES fsbi_dw_spinn.dim_coverage(coverage_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_coverageeffectivedate_id_fkey FOREIGN KEY (coverageeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_coverageexpirationdate_id_fkey FOREIGN KEY (coverageexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_dateofloss_id_fkey FOREIGN KEY (dateofloss_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_datereported_id_fkey FOREIGN KEY (datereported_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_deductible_id_fkey FOREIGN KEY (deductible_id) REFERENCES fsbi_dw_spinn.dim_deductible(deductible_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES fsbi_dw_spinn.dim_driver(driver_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_firstinsured_id_fkey FOREIGN KEY (firstinsured_id) REFERENCES fsbi_dw_spinn.dim_insured(insured_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_limit_id_fkey FOREIGN KEY (limit_id) REFERENCES fsbi_dw_spinn.dim_limit(limit_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_location_id_fkey FOREIGN KEY (location_id) REFERENCES fsbi_dw_spinn.dim_location(location_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_month_id_fkey FOREIGN KEY (month_id) REFERENCES fsbi_dw_spinn.dim_month(month_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_openeddate_id_fkey FOREIGN KEY (openeddate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES fsbi_dw_spinn.dim_policy(policy_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_policyeffectivedate_id_fkey FOREIGN KEY (policyeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_policyexpirationdate_id_fkey FOREIGN KEY (policyexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_policyextension_id_fkey FOREIGN KEY (policyextension_id) REFERENCES fsbi_dw_spinn.dim_policyextension(policyextension_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_policymasterterritory_id_fkey FOREIGN KEY (policymasterterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_primaryrisk_id_fkey FOREIGN KEY (primaryrisk_id) REFERENCES fsbi_dw_spinn.dim_coveredrisk(coveredrisk_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_primaryriskaddress_id_fkey FOREIGN KEY (primaryriskaddress_id) REFERENCES fsbi_dw_spinn.dim_address(address_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_primaryriskext_id_fkey FOREIGN KEY (primaryriskextension_id) REFERENCES fsbi_dw_spinn.dim_coveredriskextension(coveredriskextension_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_primaryriskgeography_id_fkey FOREIGN KEY (primaryriskgeography_id) REFERENCES fsbi_dw_spinn.dim_geography(geography_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_primaryriskterritory_id_fkey FOREIGN KEY (primaryriskterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES fsbi_dw_spinn.dim_producer_obsolete(producer_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_product_id_fkey FOREIGN KEY (product_id) REFERENCES fsbi_dw_spinn.dim_product(product_id);
ALTER TABLE fsbi_dw_spinn.fact_claim ADD CONSTRAINT fact_claim_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES fsbi_dw_spinn.dim_vehicle(vehicle_id);


-- fsbi_dw_spinn.fact_claimtransaction foreign keys

ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_accountingdate_id_fkey FOREIGN KEY (accountingdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_adjuster_id_fkey FOREIGN KEY (adjuster_id) REFERENCES fsbi_dw_spinn.dim_adjuster(adjuster_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_building_id_fkey FOREIGN KEY (building_id) REFERENCES fsbi_dw_spinn.dim_building(building_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES fsbi_dw_spinn.dim_claim(claim_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimant_id_fkey FOREIGN KEY (claimant_id) REFERENCES fsbi_dw_spinn.dim_claimant(claimant_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimextension_id_fkey FOREIGN KEY (claimextension_id) REFERENCES fsbi_dw_spinn.dim_claimextension(claimextension_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimlossaddress_id_fkey FOREIGN KEY (claimlossaddress_id) REFERENCES fsbi_dw_spinn.dim_address(address_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimlossgeography_id_fkey FOREIGN KEY (claimlossgeography_id) REFERENCES fsbi_dw_spinn.dim_geography(geography_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimrisk_id_fkey FOREIGN KEY (primaryrisk_id) REFERENCES fsbi_dw_spinn.dim_claimrisk(claimrisk_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimstatus_id_fkey FOREIGN KEY (claimstatus_id) REFERENCES fsbi_dw_spinn.dim_status(status_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_claimtransactiontype_id_fkey FOREIGN KEY (claimtransactiontype_id) REFERENCES fsbi_dw_spinn.dim_claimtransactiontype(claimtransactiontype_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_class_id_fkey FOREIGN KEY (class_id) REFERENCES fsbi_dw_spinn.dim_classification(class_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_closeddate_id_fkey FOREIGN KEY (closeddate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_company_id_fkey FOREIGN KEY (company_id) REFERENCES fsbi_dw_spinn.dim_legalentity_other(legalentity_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_coverage_id_fkey FOREIGN KEY (coverage_id) REFERENCES fsbi_dw_spinn.dim_coverage(coverage_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_coverageeffectivedate_id_fkey FOREIGN KEY (coverageeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_coverageexpirationdate_id_fkey FOREIGN KEY (coverageexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_dateofloss_id_fkey FOREIGN KEY (dateofloss_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_datereported_id_fkey FOREIGN KEY (datereported_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_deductible_id_fkey FOREIGN KEY (deductible_id) REFERENCES fsbi_dw_spinn.dim_deductible(deductible_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES fsbi_dw_spinn.dim_driver(driver_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_firstinsured_id_fkey FOREIGN KEY (firstinsured_id) REFERENCES fsbi_dw_spinn.dim_insured(insured_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_limit_id_fkey FOREIGN KEY (limit_id) REFERENCES fsbi_dw_spinn.dim_limit(limit_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_location_id_fkey FOREIGN KEY (location_id) REFERENCES fsbi_dw_spinn.dim_location(location_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_openeddate_id_fkey FOREIGN KEY (openeddate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES fsbi_dw_spinn.dim_policy(policy_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_policyeffectivedate_id_fkey FOREIGN KEY (policyeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_policyexpirationdate_id_fkey FOREIGN KEY (policyexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_policymasterterritory_id_fkey FOREIGN KEY (policymasterterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_primaryrisk_id_fkey FOREIGN KEY (primaryrisk_id) REFERENCES fsbi_dw_spinn.dim_coveredrisk(coveredrisk_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_primaryriskaddress_id_fkey FOREIGN KEY (primaryriskaddress_id) REFERENCES fsbi_dw_spinn.dim_address(address_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_primaryriskgeography_id_fkey FOREIGN KEY (primaryriskgeography_id) REFERENCES fsbi_dw_spinn.dim_geography(geography_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_primaryriskterritory_id_fkey FOREIGN KEY (primaryriskterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES fsbi_dw_spinn.dim_producer_obsolete(producer_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_product_id_fkey FOREIGN KEY (product_id) REFERENCES fsbi_dw_spinn.dim_product(product_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_transactiondate_id_fkey FOREIGN KEY (transactiondate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtransaction_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES fsbi_dw_spinn.dim_vehicle(vehicle_id);
ALTER TABLE fsbi_dw_spinn.fact_claimtransaction ADD CONSTRAINT fact_claimtrn_primaryriskext_id_fkey FOREIGN KEY (primaryriskextension_id) REFERENCES fsbi_dw_spinn.dim_coveredriskextension(coveredriskextension_id);


-- fsbi_dw_spinn.fact_policy foreign keys

ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_company_id_fkey FOREIGN KEY (company_id) REFERENCES fsbi_dw_spinn.dim_legalentity_other(legalentity_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_firstinsured_id_fkey FOREIGN KEY (firstinsured_id) REFERENCES fsbi_dw_spinn.dim_insured(insured_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_month_id_fkey FOREIGN KEY (month_id) REFERENCES fsbi_dw_spinn.dim_month(month_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES fsbi_dw_spinn.dim_policy(policy_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_policyeffectivedate_id_fkey FOREIGN KEY (policyeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_policyexpirationdate_id_fkey FOREIGN KEY (policyexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_policyextension_id_fkey FOREIGN KEY (policyextension_id) REFERENCES fsbi_dw_spinn.dim_policyextension(policyextension_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_policymasterterritory_id_fkey FOREIGN KEY (policymasterterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_policystatus_id_fkey FOREIGN KEY (policystatus_id) REFERENCES fsbi_dw_spinn.dim_status(status_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES fsbi_dw_spinn.dim_producer_obsolete(producer_id);
ALTER TABLE fsbi_dw_spinn.fact_policy ADD CONSTRAINT fact_policy_product_id_fkey FOREIGN KEY (product_id) REFERENCES fsbi_dw_spinn.dim_product(product_id);


-- fsbi_dw_spinn.fact_policycoverage foreign keys

ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycov_primaryriskext_id_fkey FOREIGN KEY (primaryriskextension_id) REFERENCES fsbi_dw_spinn.dim_coveredriskextension(coveredriskextension_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_building_id_fkey FOREIGN KEY (building_id) REFERENCES fsbi_dw_spinn.dim_building(building_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES fsbi_dw_spinn.dim_driver(driver_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_location_id_fkey FOREIGN KEY (location_id) REFERENCES fsbi_dw_spinn.dim_location(location_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_month_building_id_fkey FOREIGN KEY (month_building_id) REFERENCES fsbi_dw_spinn.dim_building(building_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_month_driver_id_fkey FOREIGN KEY (month_driver_id) REFERENCES fsbi_dw_spinn.dim_driver(driver_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_month_location_id_fkey FOREIGN KEY (month_location_id) REFERENCES fsbi_dw_spinn.dim_location(location_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_month_vehicle_id_fkey FOREIGN KEY (month_vehicle_id) REFERENCES fsbi_dw_spinn.dim_vehicle(vehicle_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_class_id_fkey FOREIGN KEY (class_id) REFERENCES fsbi_dw_spinn.dim_classification(class_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_company_id_fkey FOREIGN KEY (company_id) REFERENCES fsbi_dw_spinn.dim_legalentity_other(legalentity_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_coverage_id_fkey FOREIGN KEY (coverage_id) REFERENCES fsbi_dw_spinn.dim_coverage(coverage_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_coverageeffectivedate_id_fkey FOREIGN KEY (coverageeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_coverageexpirationdate_id_fkey FOREIGN KEY (coverageexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_deductible_id_fkey FOREIGN KEY (deductible_id) REFERENCES fsbi_dw_spinn.dim_deductible(deductible_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_firstinsured_id_fkey FOREIGN KEY (firstinsured_id) REFERENCES fsbi_dw_spinn.dim_insured(insured_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_limit_id_fkey FOREIGN KEY (limit_id) REFERENCES fsbi_dw_spinn.dim_limit(limit_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_month_id_fke FOREIGN KEY (month_id) REFERENCES fsbi_dw_spinn.dim_month(month_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES fsbi_dw_spinn.dim_policy(policy_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_policyeffectivedate_id_fkey FOREIGN KEY (policyeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_policyexpirationdate_id_fkey FOREIGN KEY (policyexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_policyextension_id_fkey FOREIGN KEY (policyextension_id) REFERENCES fsbi_dw_spinn.dim_policyextension(policyextension_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_policymasterterritory_id_fkey FOREIGN KEY (policymasterterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_policystatus_id_fkey FOREIGN KEY (policystatus_id) REFERENCES fsbi_dw_spinn.dim_status(status_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_primaryrisk_id_fkey FOREIGN KEY (primaryrisk_id) REFERENCES fsbi_dw_spinn.dim_coveredrisk(coveredrisk_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_primaryriskaddress_id_fkey FOREIGN KEY (primaryriskaddress_id) REFERENCES fsbi_dw_spinn.dim_address(address_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_primaryriskgeography_id_fkey FOREIGN KEY (primaryriskgeography_id) REFERENCES fsbi_dw_spinn.dim_geography(geography_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_primaryriskterritory_id_fkey FOREIGN KEY (primaryriskterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES fsbi_dw_spinn.dim_producer_obsolete(producer_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_temp_product_id_fkey FOREIGN KEY (product_id) REFERENCES fsbi_dw_spinn.dim_product(product_id);
ALTER TABLE fsbi_dw_spinn.fact_policycoverage ADD CONSTRAINT fact_policycoverage_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES fsbi_dw_spinn.dim_vehicle(vehicle_id);


-- fsbi_dw_spinn.fact_policytransaction foreign keys

ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_accountingdate_id_fkey FOREIGN KEY (accountingdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_building_id_fkey FOREIGN KEY (building_id) REFERENCES fsbi_dw_spinn.dim_building(building_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_class_id_fkey FOREIGN KEY (class_id) REFERENCES fsbi_dw_spinn.dim_classification(class_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_company_id_fkey FOREIGN KEY (company_id) REFERENCES fsbi_dw_spinn.dim_legalentity_other(legalentity_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_coverage_id_fkey FOREIGN KEY (coverage_id) REFERENCES fsbi_dw_spinn.dim_coverage(coverage_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_coverageeffectivedate_id_fkey FOREIGN KEY (coverageeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_coverageexpirationdate_id_fkey FOREIGN KEY (coverageexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_deductible_id_fkey FOREIGN KEY (deductible_id) REFERENCES fsbi_dw_spinn.dim_deductible(deductible_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES fsbi_dw_spinn.dim_driver(driver_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_effectivedate_id_fkey FOREIGN KEY (effectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_firstinsured_id_fkey FOREIGN KEY (firstinsured_id) REFERENCES fsbi_dw_spinn.dim_insured(insured_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_limit_id_fkey FOREIGN KEY (limit_id) REFERENCES fsbi_dw_spinn.dim_limit(limit_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_location_id_fkey FOREIGN KEY (location_id) REFERENCES fsbi_dw_spinn.dim_location(location_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES fsbi_dw_spinn.dim_policy(policy_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policyeffectivedate_id_fkey FOREIGN KEY (policyeffectivedate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policyexpirationdate_id_fkey FOREIGN KEY (policyexpirationdate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policyextension_id_fkey FOREIGN KEY (policyextension_id) REFERENCES fsbi_dw_spinn.dim_policyextension(policyextension_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policymasterterritory_id_fkey FOREIGN KEY (policymasterterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policytransactionextension_id_fkey FOREIGN KEY (policytransactionextension_id) REFERENCES fsbi_dw_spinn.dim_policytransactionextension(policytransactionextension_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_policytransactiontype_id_fkey FOREIGN KEY (policytransactiontype_id) REFERENCES fsbi_dw_spinn.dim_policytransactiontype(policytransactiontype_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_primaryrisk_id_fkey FOREIGN KEY (primaryrisk_id) REFERENCES fsbi_dw_spinn.dim_coveredrisk(coveredrisk_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_primaryriskaddress_id_fkey FOREIGN KEY (primaryriskaddress_id) REFERENCES fsbi_dw_spinn.dim_address(address_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_primaryriskgeography_id_fkey FOREIGN KEY (primaryriskgeography_id) REFERENCES fsbi_dw_spinn.dim_geography(geography_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_primaryriskterritory_id_fkey FOREIGN KEY (primaryriskterritory_id) REFERENCES fsbi_dw_spinn.dim_territory(territory_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES fsbi_dw_spinn.dim_producer_obsolete(producer_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_product_id_fkey FOREIGN KEY (product_id) REFERENCES fsbi_dw_spinn.dim_product(product_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_transactiondate_id_fkey FOREIGN KEY (transactiondate_id) REFERENCES fsbi_dw_spinn.dim_time(time_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_trn_building_id_fkey FOREIGN KEY (trn_building_id) REFERENCES fsbi_dw_spinn.dim_building(building_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_trn_driver_id_fkey FOREIGN KEY (trn_driver_id) REFERENCES fsbi_dw_spinn.dim_driver(driver_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_trn_location_id_fkey FOREIGN KEY (trn_location_id) REFERENCES fsbi_dw_spinn.dim_location(location_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_trn_vehicle_id_fkey FOREIGN KEY (trn_vehicle_id) REFERENCES fsbi_dw_spinn.dim_vehicle(vehicle_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytransaction_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES fsbi_dw_spinn.dim_vehicle(vehicle_id);
ALTER TABLE fsbi_dw_spinn.fact_policytransaction ADD CONSTRAINT fact_policytrn_primaryriskext_id_fkey FOREIGN KEY (primaryriskextension_id) REFERENCES fsbi_dw_spinn.dim_coveredriskextension(coveredriskextension_id);