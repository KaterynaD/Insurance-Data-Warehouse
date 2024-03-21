-- fsbi_dw_spinn.quote_auto source

CREATE OR REPLACE VIEW fsbi_dw_spinn.quote_auto
AS SELECT 1 AS quote_auto_key, 'PersonalAuto' AS linecd, a.subtypecd, a.application_id AS systemid, 'Application' AS cmmcontainer, "replace"(a.carriergroupcd::text, '~'::text, ''::text) AS carriergroupcd, "replace"(ltrim(rtrim(split_part(a.company_uniqueid::text, '-'::text, 1))), '~'::text, ''::text) AS carriercd, "replace"(ltrim(rtrim(split_part(a.company_uniqueid::text, '-'::text, 2))), '~'::text, ''::text) AS companycd, a.subtypecd AS subtypecd_bp, a.statecd AS controllingstatecd, "replace"(a.quotenumber::text, '~'::text, ''::text) AS quotenumber, "replace"(a.bc_basicpolicy_originalapplicationref::text, '~'::text, ''::text) AS originalapplicationref, a.bc_basicpolicy_id AS id, "replace"(a.approved_policynumber::text, 'Unknown'::text, ''::text) AS policynumber, 1 AS policyversion, a.effectivedt, a.expirationdt, "replace"(a.ratedind::text, 'No'::text, ''::text) AS ratedind, a.renewaltermcd, a.bc_basicpolicy_writtenpremiumamt AS writtenpremiumamt, "replace"(a.programind::text, '~'::text, ''::text) AS programind, "replace"(a.batchquotesourcecd::text, '~'::text, ''::text) AS batchquotesourcecd, "replace"(a.affinitygroupcd::text, '~'::text, ''::text) AS affinitygroupcd, "replace"(
        CASE
            WHEN "left"(a.applicationnumber::text, 2) = 'AP'::text THEN a.applicationnumber
            ELSE NULL::character varying
        END::text, '~'::text, ''::text) AS applicationnumber, 
        CASE
            WHEN a.bc_quoteinfo_typecd::text = 'Application'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS bridged, a.subtypecd AS subtypecd_qi, a.bc_quoteinfo_uniqueid AS uniqueid, to_date(to_char(a.bc_quoteinfo_adddt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) AS adddt, to_char(a.bc_quoteinfo_adddt_tm, 'hh24:mi:ss'::text) + ' PST'::text AS addtm, a.bc_quoyeinfo_adduser_uniqueid AS adduser, "replace"(a.producer_uniqueid::text, '~'::text, ''::text) AS agent, "replace"(ltrim(rtrim(cse_bi.ifempty(("replace"(ia.address1::text, '~'::text, ''::text) + ' '::text + "replace"(ia.address2::text, '~'::text, ''::text))::character varying, '~'::character varying)::text)), '~'::text, ''::text) AS addr, "replace"(ia.city::text, '~'::text, ''::text) AS city, "replace"(ia.postalcode::text, '~'::text, ''::text) AS zipcode, "replace"(ia.state::text, '~'::text, ''::text) AS mailingstatecd, "replace"(ia.commercial_name::text, '~'::text, ''::text) AS primaryinsured, "replace"("replace"(ia.telephone::text + ','::text + ia.mobile::text, '~,'::text, ''::text), '~'::text, ''::text) AS primaryphonenumber, NULL::"unknown" AS primaryphonename, "replace"(a.customer_uniqueid::text, 'Unknown'::text, ''::text) AS customernumber, "replace"(c.dob::text, '1900-01-01'::text, '1899-11-30'::text) AS birthdt, "replace"(
        CASE
            WHEN ia.telephone::text = '~'::text OR ia.telephone::text = '(000) 000-0000'::text THEN ia.mobile
            ELSE ia.telephone
        END::text, '~'::text, ''::text) + '|'::text + "replace"("substring"(ia.postalcode::text, 1, 5), '~'::text, ''::text) + '|'::text + 
        CASE
            WHEN a.customer_uniqueid::text = 'Unknown'::text THEN '1899-11-30'::text
            ELSE to_char(
            CASE
                WHEN c.dob = '1900-01-01'::date THEN '1899-11-30'::date
                ELSE c.dob
            END::timestamp without time zone, 'yyyy-mm-dd'::text)
        END AS uniquecustomerkey, 
        CASE
            WHEN a.bc_quoteinfo_typecd::text = 'Application'::text THEN "replace"(
            CASE
                WHEN ia.telephone::text = '~'::text OR ia.telephone::text = '(000) 000-0000'::text THEN ia.mobile
                ELSE ia.telephone
            END::text, '~'::text, ''::text) + '|'::text + "replace"("substring"(ia.postalcode::text, 1, 5), '~'::text, ''::text) + '|'::text + 
            CASE
                WHEN a.customer_uniqueid::text = 'Unknown'::text THEN '1899-11-30'::text
                ELSE to_char(
                CASE
                    WHEN c.dob = '1900-01-01'::date THEN '1899-11-30'::date
                    ELSE c.dob
                END::timestamp without time zone, 'yyyy-mm-dd'::text)
            END
            ELSE NULL::text
        END AS uniquecustomerkey_app, a.bc_application_updatetimestamp AS updatetimestamp_app, to_date(to_char(a.bc_quoteinfo_updatedt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) AS updatedt, to_char(a.bc_quoteinfo_updatedt_tm, 'hh24:mi:ss'::text) + ' PST'::text AS updatetm, "replace"(a.bc_quoteinfo_updateuser_uniqueid::text, 'Unknown'::text, ''::text) AS updateuser, "replace"(a.customer_uniqueid::text, 'Unknown'::text, ''::text) AS customerref, "replace"(a.approved_policy_uniqueid::text, 'Unknown'::text, ''::text) AS policyref, ' ' AS changeinforef, a.applicationtype AS typecd, a.applicationstatus AS status, "replace"(a.bc_application_description::text, '~'::text, ''::text) AS description, "replace"(v.vehidentificationnumber::text, '~'::text, ''::text) AS vehidentificationnumber, v.vehnumber, "replace"(COALESCE(v.comprehensiveded, '~'::character varying)::text, '~'::text, ''::text) AS comprehensiveded, "replace"(COALESCE(v.collisionded, '~'::character varying)::text, '~'::text, ''::text) AS collisionded, "replace"(a.bilimit::text, '~'::text, ''::text) AS bilimit, "replace"(a.pdlimit::text, '~'::text, ''::text) AS pdlimit, "replace"(a.umbilimit::text, '~'::text, ''::text) AS umbilimit, "replace"(a.medpaylimit::text, '~'::text, ''::text) AS medpaylimit, "replace"(a.multipolicyhomediscount::text, '~'::text, ''::text) AS mpd1, "replace"(a.multipolicyumbrelladiscount::text, '~'::text, ''::text) AS mpd2, "replace"(a.multicardiscountind::text, '~'::text, ''::text) AS multicar, a.bc_line_fulltermamt AS fulltermamt, a.bc_line_finalpremiumamt AS finalpremiumamt, a.loaddate AS insertdate, 'dbo' AS insertby, a.loaddate AS updatedate, 'dbo' AS updateby, to_date(
        CASE
            WHEN a.approved_policybookdt = '1900-01-01'::date THEN NULL::date
            ELSE a.approved_policybookdt
        END::text, 'yyyy-mm-dd'::text) AS firsttran, ag.agency_group, ag.dba, ag.territory, ui.departmentcd
   FROM fsbi_dw_spinn.dim_application a
   JOIN fsbi_dw_spinn.dim_app_insured ia ON a.application_id = ia.application_id
   JOIN fsbi_dw_spinn.dim_customer c ON a.customer_uniqueid::text = c.customer_uniqueid::text
   JOIN fsbi_dw_spinn.dim_producer ag ON 
CASE
WHEN a.producer_uniqueid::text = '~'::text THEN 'Unknown'::character varying
ELSE a.producer_uniqueid
END::text = ag.producer_uniqueid::text AND to_date(to_char(a.bc_quoteinfo_adddt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) >= ag.valid_fromdate AND to_date(to_char(a.bc_quoteinfo_adddt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) < ag.valid_todate
   JOIN fsbi_dw_spinn.dim_userinfo ui ON lower(a.bc_quoyeinfo_adduser_uniqueid::text) = lower(ui.userinfo_uniqueid::text)
   LEFT JOIN fsbi_dw_spinn.dim_app_vehicle v ON a.application_id = v.application_id
  WHERE a.transactioncd::text = 'New Business'::text AND a.subtypecd::text = 'PA'::text;

COMMENT ON VIEW fsbi_dw_spinn.quote_auto IS 'The view was created for backward compatibility with quote_auto table, now obsolete. It`s based on fsbi_dw_spinn.dim_application and other dimensions';


-- fsbi_dw_spinn.quote_building source

CREATE OR REPLACE VIEW fsbi_dw_spinn.quote_building
AS SELECT 
        CASE
            WHEN a.subtypecd::text = 'PA'::text THEN 'Auto'::character varying
            WHEN a.subtypecd::text = 'DF3'::text OR a.subtypecd::text = 'DF6'::text OR a.subtypecd::text = 'FL1-Basic'::text OR a.subtypecd::text = 'FL1-Vacant'::text OR a.subtypecd::text = 'FL2-Broad'::text OR a.subtypecd::text = 'FL3-Special'::text THEN 'Dwelling'::character varying
            WHEN a.subtypecd::text = 'Form3'::text OR a.subtypecd::text = 'HO3'::text OR a.subtypecd::text = 'HO4'::text OR a.subtypecd::text = 'HO6'::text THEN 'Home'::character varying
            WHEN a.subtypecd::text = 'PU'::text THEN 'Personal Umbrella'::character varying
            WHEN a.subtypecd::text = 'PB'::text THEN 'Boat'::character varying
            WHEN a.subtypecd::text = 'BOPN-B'::text OR a.subtypecd::text = 'CFIRE'::text OR a.subtypecd::text = 'CommercialUmbrella'::text OR a.subtypecd::text = 'PUD-B'::text OR a.subtypecd::text = 'BOPN-B'::text THEN 'Commercial'::character varying
            WHEN a.subtypecd::text = 'EQ'::text THEN 'Earthquake'::character varying
            ELSE a.subtypecd
        END AS linecd, a.subtypecd, a.application_id AS systemid, 'Application' AS cmmcontainer, "replace"(a.carriergroupcd::text, '~'::text, ''::text) AS carriergroupcd, "replace"(ltrim(rtrim(split_part(a.company_uniqueid::text, '-'::text, 1))), '~'::text, ''::text) AS carriercd, "replace"(ltrim(rtrim(split_part(a.company_uniqueid::text, '-'::text, 2))), '~'::text, ''::text) AS companycd, a.subtypecd AS subtypecd_bp, a.statecd AS controllingstatecd, "replace"(a.quotenumber::text, '~'::text, ''::text) AS quotenumber, "replace"(a.bc_basicpolicy_originalapplicationref::text, '~'::text, ''::text) AS originalapplicationref, a.bc_basicpolicy_id AS id, "replace"(a.approved_policynumber::text, 'Unknown'::text, ''::text) AS policynumber, 1 AS policyversion, a.effectivedt, a.expirationdt, "replace"(a.ratedind::text, 'No'::text, ''::text) AS ratedind, a.renewaltermcd, a.bc_basicpolicy_writtenpremiumamt AS writtenpremiumamt, "replace"(a.programind::text, '~'::text, ''::text) AS programind, "replace"(a.batchquotesourcecd::text, '~'::text, ''::text) AS batchquotesourcecd, "replace"(a.affinitygroupcd::text, '~'::text, ''::text) AS affinitygroupcd, "replace"(
        CASE
            WHEN "left"(a.applicationnumber::text, 2) = 'AP'::text THEN a.applicationnumber
            ELSE NULL::character varying
        END::text, '~'::text, ''::text) AS applicationnumber, 
        CASE
            WHEN a.bc_quoteinfo_typecd::text = 'Application'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS bridged, a.subtypecd AS subtypecd_qi, a.bc_quoteinfo_uniqueid AS uniqueid, to_date(to_char(a.bc_quoteinfo_adddt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) AS adddt, to_char(a.bc_quoteinfo_adddt_tm, 'hh24:mi:ss'::text) + ' PST'::text AS addtm, a.bc_quoyeinfo_adduser_uniqueid AS adduser, to_date(to_char(a.bc_quoteinfo_updatedt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) AS updatedt, to_char(a.bc_quoteinfo_updatedt_tm, 'hh24:mi:ss'::text) + ' PST'::text AS updatetm, "replace"(a.bc_quoteinfo_updateuser_uniqueid::text, 'Unknown'::text, ''::text) AS updateuser, "replace"(a.producer_uniqueid::text, '~'::text, ''::text) AS agent, "replace"(ltrim(rtrim(cse_bi.ifempty(("replace"(ia.address1::text, '~'::text, ''::text) + ' '::text + "replace"(ia.address2::text, '~'::text, ''::text))::character varying, '~'::character varying)::text)), '~'::text, ''::text) AS addr, "replace"(ia.city::text, '~'::text, ''::text) AS city, "replace"(ia.postalcode::text, '~'::text, ''::text) AS zipcode, "replace"(ia.state::text, '~'::text, ''::text) AS mailingstatecd, "replace"(ia.commercial_name::text, '~'::text, ''::text) AS primaryinsured, "replace"("replace"(ia.telephone::text + ','::text + ia.mobile::text, '~,'::text, ''::text), '~'::text, ''::text) AS primaryphonenumber, NULL::"unknown" AS primaryphonename, "replace"(a.customer_uniqueid::text, 'Unknown'::text, ''::text) AS customernumber, "replace"(c.dob::text, '1900-01-01'::text, '1899-11-30'::text) AS birthdt, "replace"(
        CASE
            WHEN ia.telephone::text = '~'::text OR ia.telephone::text = '(000) 000-0000'::text THEN ia.mobile
            ELSE ia.telephone
        END::text, '~'::text, ''::text) + '|'::text + "replace"("substring"(ia.postalcode::text, 1, 5), '~'::text, ''::text) + '|'::text + 
        CASE
            WHEN a.customer_uniqueid::text = 'Unknown'::text THEN '1899-11-30'::text
            ELSE to_char(
            CASE
                WHEN c.dob = '1900-01-01'::date THEN '1899-11-30'::date
                ELSE c.dob
            END::timestamp without time zone, 'yyyy-mm-dd'::text)
        END AS uniquecustomerkey, 
        CASE
            WHEN a.bc_quoteinfo_typecd::text = 'Application'::text THEN "replace"(
            CASE
                WHEN ia.telephone::text = '~'::text OR ia.telephone::text = '(000) 000-0000'::text THEN ia.mobile
                ELSE ia.telephone
            END::text, '~'::text, ''::text) + '|'::text + "replace"("substring"(ia.postalcode::text, 1, 5), '~'::text, ''::text) + '|'::text + 
            CASE
                WHEN a.customer_uniqueid::text = 'Unknown'::text THEN '1899-11-30'::text
                ELSE to_char(
                CASE
                    WHEN c.dob = '1900-01-01'::date THEN '1899-11-30'::date
                    ELSE c.dob
                END::timestamp without time zone, 'yyyy-mm-dd'::text)
            END
            ELSE NULL::text
        END AS uniquecustomerkey_app, a.bc_application_updatetimestamp AS updatetimestamp_app, "replace"(a.customer_uniqueid::text, 'Unknown'::text, ''::text) AS customerref, "replace"(a.approved_policy_uniqueid::text, 'Unknown'::text, ''::text) AS policyref, ' ' AS changeinforef, a.applicationtype AS typecd, a.applicationstatus AS status, "replace"(a.bc_application_description::text, '~'::text, ''::text) AS description, b.covalimit, 
        CASE
            WHEN b.sqft = 0 THEN NULL::integer
            ELSE b.sqft
        END AS sqft, 
        CASE
            WHEN b.yearbuilt = 0 THEN NULL::integer
            ELSE b.yearbuilt
        END AS yearbuilt, "replace"(b.roofcd::text, '~'::text, ''::text) AS roofcd, "replace"(b.allperilded::text, '~'::text, ''::text) AS deductible, "replace"(b.protectionclass::text, '~'::text, ''::text) AS protectionclass, "replace"(b.waterded::text, '~'::text, ''::text) AS waterded, "replace"(b.stories::text, '~'::text, ''::text) AS stories, "replace"(a.multipolicyhomediscount::text, '~'::text, ''::text) AS mpd1, "replace"(a.multipolicyumbrelladiscount::text, '~'::text, ''::text) AS mpd2, "replace"(a.multicardiscountind::text, '~'::text, ''::text) AS multicar, a.loaddate AS insertdate, 'dbo' AS insertby, a.loaddate AS updatedate, 'dbo' AS updateby, 
        CASE
            WHEN a.approved_policybookdt = '1900-01-01'::date THEN NULL::date
            ELSE a.approved_policybookdt
        END AS firsttran, "replace"(b.safeguardplusind::text, '~'::text, ''::text) AS safeguardplusind, "replace"(b.ratingtier::text, '~'::text, ''::text) AS ratingtier, "replace"(b.waterriskscore::text, '~'::text, ''::text) AS waterriskscore, "replace"(b.postalcode::text, '~'::text, ''::text) AS building_zipcode, ag.agency_group, ag.dba, ag.territory, ui.departmentcd, a.producer_uniqueid
   FROM fsbi_dw_spinn.dim_application a
   JOIN fsbi_dw_spinn.dim_app_insured ia ON a.application_id = ia.application_id
   JOIN fsbi_dw_spinn.dim_customer c ON a.customer_uniqueid::text = c.customer_uniqueid::text
   JOIN fsbi_dw_spinn.dim_producer ag ON 
CASE
WHEN a.producer_uniqueid::text = '~'::text THEN 'Unknown'::character varying
ELSE a.producer_uniqueid
END::text = ag.producer_uniqueid::text AND to_date(to_char(a.bc_quoteinfo_adddt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) >= ag.valid_fromdate AND to_date(to_char(a.bc_quoteinfo_adddt_tm, 'yyyy-mm-dd'::text), 'yyyy-mm-dd'::text) < ag.valid_todate
   JOIN fsbi_dw_spinn.dim_userinfo ui ON lower(a.bc_quoyeinfo_adduser_uniqueid::text) = lower(ui.userinfo_uniqueid::text)
   LEFT JOIN fsbi_dw_spinn.dim_app_building b ON a.application_id = b.application_id
  WHERE a.transactioncd::text = 'New Business'::text AND (a.subtypecd::text = 'DF3'::text OR a.subtypecd::text = 'DF6'::text OR a.subtypecd::text = 'FL1-Basic'::text OR a.subtypecd::text = 'FL1-Vacant'::text OR a.subtypecd::text = 'FL2-Broad'::text OR a.subtypecd::text = 'FL3-Special'::text OR a.subtypecd::text = 'Form3'::text OR a.subtypecd::text = 'HO3'::text OR a.subtypecd::text = 'HO4'::text OR a.subtypecd::text = 'HO6'::text);

COMMENT ON VIEW fsbi_dw_spinn.quote_building IS 'The view was created for backward compatibility with quote_building table, now obsolete.  It`s based on fsbi_dw_spinn.dim_application and other dimensions';


-- fsbi_dw_spinn.vauto_modeldata_allcov source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vauto_modeldata_allcov
AS SELECT p.pol_policynumber AS policynumber, m.policy_uniqueid, m.vin, m.vehicle_uniqueid, cr.cvrsk_number AS riskcd, m.risktype AS risktypecd, d.licensenumber AS driver, cr.cvrsk_number2 AS drivernumber, m.driver_uniqueid AS driverparentid, pgdate_part('year'::text, m.startdate::timestamp without time zone)::integer AS cal_year, m.startdate, 
        CASE
            WHEN m.enddate > date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone)
            ELSE m.enddate::timestamp without time zone
        END AS enddate, m.startdatetm, m.enddatetm, date_diff('d'::text, m.startdate::timestamp without time zone, 
        CASE
            WHEN m.enddate > date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone)
            ELSE m.enddate::timestamp without time zone
        END)::numeric / 365.25 AS ecy, m.coveragecd AS coverage, m.limit1, m.limit2, m.deductible, m.wp, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * m.wp * (date_diff('d'::text, m.startdate::timestamp without time zone, 
        CASE
            WHEN m.enddate > date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone)
            ELSE m.enddate::timestamp without time zone
        END)::numeric / 365.25) AS ep, m.coll_deductible, m.comp_deductible, m.bi_limit1, m.bi_limit2, m.umbi_limit1, m.umbi_limit2, m.pd_limit1, m.pd_limit2, m.cntveh, m.cntdrv, m.cntnondrv, m.cntexcludeddrv, m.mindriverage, 
        CASE
            WHEN m.cntveh > (m.cntdrv - m.cntnondrv - m.cntexcludeddrv) THEN 'Yes'::text
            ELSE 'No'::text
        END AS extra_vehicles, vdc.comp_number AS companycd, vdc.comp_name1 AS carriercd, pe.programind, pe.previouscarriercd, 
        CASE
            WHEN p.pol_policynumbersuffix::text = '01'::text THEN 'New'::text
            ELSE 'Renewal'::text
        END AS policyneworrenewal, pe.renewaltermcd, p.pol_effectivedate AS effectivedate, p.pol_expirationdate AS expirationdate, 
        CASE
            WHEN pe.inceptiondt <= '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::timestamp without time zone
            ELSE pe.inceptiondt
        END AS inceptiondt, 
        CASE
            WHEN pe.persistencydiscountdt <= '1900-01-01'::date THEN NULL::date
            ELSE pe.persistencydiscountdt
        END AS persistencydiscountdt, pr.prdr_number AS producercode, pr.prdr_name1 AS producername, pr.prdr_address1 AS produceraddress, pr.prdr_city AS producercity, pr.prdr_state AS producerstate, pr.prdr_zipcode AS producerpostalcode, pr.producer_status, pr.territory, di.multipolicydiscount AS multipolicydiscountind, di.multipolicyhomediscount AS multipolicydiscountind_value, di.homerelatedpolicynumber, di.umbrellarelatedpolicynumber, di.multicardiscountind, di.cseemployeediscountind, pe.installmentfee, pe.nsffee, pe.latefee, di.liabilityreductionind, di.fullpaydiscountind, di.twopaydiscountind, di.eftdiscount, 
        CASE
            WHEN pe.persistencydiscountdt > '1900-01-01'::date THEN "date_part"('y'::text, p.pol_effectivedate) - "date_part"('y'::text, pe.persistencydiscountdt)
            ELSE 0
        END AS persistency, "date_part"('y'::text, p.pol_effectivedate) AS policyyear, m.vehicleinceptiondate, v.stateprovcd AS state, v.county, v.postalcode, v.city, v.addr1, v.addr2, v.garagaddrflg, v.garagpostalcode, v.garagpostalcodeflg, v.vehbodytypecd, v.performancecd, v.modelyr, v.vehusecd, v.estimatedannualdistance, v.estimatedworkdistance, v.odometerreading, v.weekspermonthdriven, v.daysperweekdriven, v.manufacturer, v.neworusedind, v.antitheftcd, v.restraintcd, v.towingandlaborind, v.rentalreimbursementind, v.medicalpartsaccessibility, v.mileage, v.titlehistoryissue, v.californiarecentmileage, v.recentaveragemileage, v.averagemileage, v.modeledannualmileage, v.histcarfax201902_last_owner_average_miles AS last_owner_average_miles, v.histcarfax201902_last_owner_recent_annual_mileage AS last_owner_recent_annual_mileage, v.histcarfax201902_last_owner_government_recent_annual_mileage AS last_owner_government_recent_annual_mileage, v.histcarfax201902_estimated_current_mileage AS estimated_current_mileage, v.histcarfax201902_annual_mileage_estimate AS annual_mileage_estimate, 
        CASE
            WHEN v.salvage_firstdt > '1900-01-01'::date OR v.junk_firstdt > '1900-01-01'::date OR v.rebuiltreconstructed_firstdt > '1900-01-01'::date OR v.othertitlebrand_firstdt > '1900-01-01'::date OR v.manufacturerbuybacklemon_firstdt > '1900-01-01'::date THEN 'Yes'::text
            ELSE 'No'::text
        END AS salvage, 
        CASE
            WHEN v.mileage::text = 'Estimated'::text THEN 'Estimated'::text
            WHEN v.mileage::text = 'Recommended'::text AND v.carfaxsource::text ~~ 'DataReport%'::text THEN 
            CASE
                WHEN v.estimatedannualdistance = v.californiarecentmileage THEN 'CaliforniaRecentMileage Carfax DataReport'::text
                WHEN v.estimatedannualdistance = v.recentaveragemileage THEN 'RecentAverageMileage Carfax DataReport'::text
                WHEN v.estimatedannualdistance = v.averagemileage THEN 'AverageMileage Carfax DataReport'::text
                WHEN v.estimatedannualdistance = v.modeledannualmileage THEN 'ModeledAnnualMileage Carfax DataReport'::text
                ELSE 'Not Match Carfax DataReport'::text
            END
            WHEN v.mileage::text = 'Recommended'::text AND v.carfaxsource::text ~~ 'Extend%'::text THEN 
            CASE
                WHEN v.estimatedannualdistance = v.californiarecentmileage THEN 'CaliforniaRecentMileage Prev Term Carfax DataReport'::text
                WHEN v.estimatedannualdistance = v.recentaveragemileage THEN 'RecentAverageMileage  Prev Term Carfax DataReport'::text
                WHEN v.estimatedannualdistance = v.averagemileage THEN 'AverageMileage  Prev Term Carfax DataReport'::text
                WHEN v.estimatedannualdistance = v.modeledannualmileage THEN 'ModeledAnnualMileage  Prev Term Carfax DataReport'::text
                ELSE 'Not Match Prev Term Carfax DataReport'::text
            END
            ELSE 'N/A'::text
        END AS matchcarfax, v.carfaxsource, v.classcd, v.ratingvalue, v.cmpratingvalue, v.colratingvalue, v.liabilityratingvalue, v.medpayratingvalue, v.racmpratingvalue, v.racolratingvalue, v.rabiratingsymbol, v.rapdratingsymbol, v.ramedpayratingsymbol, v.garageterritory, v.daylightrunninglightsind, v.costnewamt, v.statedamt, v.statedamtind, v.fullglasscovind, 
        CASE
            WHEN COALESCE(v.racolratingvalue, '~'::character varying)::text <> '~'::text THEN 
            CASE
                WHEN "left"(v.racolratingvalue::text, 1) = 'A'::text THEN 10586
                WHEN "left"(v.racolratingvalue::text, 1) = 'B'::text THEN 13200
                WHEN "left"(v.racolratingvalue::text, 1) = 'C'::text THEN 14189
                WHEN "left"(v.racolratingvalue::text, 1) = 'D'::text THEN 16910
                WHEN "left"(v.racolratingvalue::text, 1) = 'E'::text THEN 18166
                WHEN "left"(v.racolratingvalue::text, 1) = 'F'::text THEN 19244
                WHEN "left"(v.racolratingvalue::text, 1) = 'G'::text THEN 20886
                WHEN "left"(v.racolratingvalue::text, 1) = 'H'::text THEN 22921
                WHEN "left"(v.racolratingvalue::text, 1) = 'J'::text THEN 26561
                WHEN "left"(v.racolratingvalue::text, 1) = 'K'::text THEN 31190
                WHEN "left"(v.racolratingvalue::text, 1) = 'L'::text THEN 33907
                WHEN "left"(v.racolratingvalue::text, 1) = 'M'::text THEN 38111
                WHEN "left"(v.racolratingvalue::text, 1) = 'N'::text THEN 51608
                WHEN "left"(v.racolratingvalue::text, 1) = 'P'::text THEN 87479
                ELSE NULL::integer
            END::numeric
            ELSE v.costnewamt
        END AS vehicle_value, m.liabilityonly_flg AS liabilityonlyflg, m.componly_flg AS componlyflg, m.driverinceptiondate, d.licensenumber, 
        CASE
            WHEN d.birthdt <= '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::timestamp without time zone
            ELSE d.birthdt
        END AS birthdt, d.gendercd, d.maritalstatuscd, d.acci_pointschargedterm, d.viol_pointschargedterm, d.susp_pointschargedterm, d.other_pointschargedterm, d.driverstatuscd, d.drivertypecd, 
        CASE
            WHEN d.licensedt <= '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::timestamp without time zone
            ELSE d.licensedt
        END AS licensedt, d.licensedstateprovcd, d.newtostateind, d.scholasticdiscountind, d.gooddriverind, d.maturedriverind, d.occupationclasscd, d.mvrstatusdt, d.mvrstatus, d.newteenexpirationdt, d.drivertrainingind, d.viol_pointscharged_adj, d.acci_pointscharged_adj, d.missedviolationpoints, d.acci5yr, d.acci7yr, d.pointscharged, 
        CASE
            WHEN d.birthdt <= '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::bigint
            ELSE date_diff('month'::text, d.birthdt, p.pol_effectivedate::timestamp without time zone) / 12
        END AS driverage, 
        CASE
            WHEN d.licensedt <= '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::bigint
            ELSE date_diff('month'::text, d.licensedt, p.pol_effectivedate::timestamp without time zone) / 12
        END AS driverlicenseage, 
        CASE
            WHEN d.licensenumber::text = '~'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS excess_veh_ind, i.insurancescore, i.overriddeninsurancescore, i.insurancescorevalue, i.ratepageeffectivedt, i.insscoretiervalueband, i.applieddt, i.financialstabilitytier, m.excludeddrv_flg AS excludeddrvflg, m.cov_claim_count_le500 AS claim_count_le500, m.cov_claim_count_1000 AS claim_count_1000, m.cov_claim_count_1500 AS claim_count_1500, m.cov_claim_count_2000 AS claim_count_2000, m.cov_claim_count_2500 AS claim_count_2500, m.cov_claim_count_5k AS claim_count_5k, m.cov_claim_count_10k AS claim_count_10k, m.cov_claim_count_25k AS claim_count_25k, m.cov_claim_count_50k AS claim_count_50k, m.cov_claim_count_100k AS claim_count_100k, m.cov_claim_count_250k AS claim_count_250k, m.cov_claim_count_500k AS claim_count_500k, m.cov_claim_count_750k AS claim_count_750k, m.cov_claim_count_1m AS claim_count_1m, m.cov_claim_count AS claim_count, m.nc_cov_inc_loss_le500 AS nc_inc_loss_le500, m.nc_cov_inc_loss_1000 AS nc_inc_loss_1000, m.nc_cov_inc_loss_1500 AS nc_inc_loss_1500, m.nc_cov_inc_loss_2000 AS nc_inc_loss_2000, m.nc_cov_inc_loss_2500 AS nc_inc_loss_2500, m.nc_cov_inc_loss_5k AS nc_inc_loss_5k, m.nc_cov_inc_loss_10k AS nc_inc_loss_10k, m.nc_cov_inc_loss_25k AS nc_inc_loss_25k, m.nc_cov_inc_loss_50k AS nc_inc_loss_50k, m.nc_cov_inc_loss_100k AS nc_inc_loss_100k, m.nc_cov_inc_loss_250k AS nc_inc_loss_250k, m.nc_cov_inc_loss_500k AS nc_inc_loss_500k, m.nc_cov_inc_loss_750k AS nc_inc_loss_750k, m.nc_cov_inc_loss_1m AS nc_inc_loss_1m, m.nc_cov_inc_loss AS nc_inc_loss, m.cat_cov_inc_loss_le500 AS cat_inc_loss_le500, m.cat_cov_inc_loss_1000 AS cat_inc_loss_1000, m.cat_cov_inc_loss_1500 AS cat_inc_loss_1500, m.cat_cov_inc_loss_2000 AS cat_inc_loss_2000, m.cat_cov_inc_loss_2500 AS cat_inc_loss_2500, m.cat_cov_inc_loss_5k AS cat_inc_loss_5k, m.cat_cov_inc_loss_10k AS cat_inc_loss_10k, m.cat_cov_inc_loss_25k AS cat_inc_loss_25k, m.cat_cov_inc_loss_50k AS cat_inc_loss_50k, m.cat_cov_inc_loss_100k AS cat_inc_loss_100k, m.cat_cov_inc_loss_250k AS cat_inc_loss_250k, m.cat_cov_inc_loss_500k AS cat_inc_loss_500k, m.cat_cov_inc_loss_750k AS cat_inc_loss_750k, m.cat_cov_inc_loss_1m AS cat_inc_loss_1m, m.cat_cov_inc_loss AS cat_inc_loss, m.nc_cov_inc_loss_dcce_le500 AS nc_inc_loss_dcce_le500, m.nc_cov_inc_loss_dcce_1000 AS nc_inc_loss_dcce_1000, m.nc_cov_inc_loss_dcce_1500 AS nc_inc_loss_dcce_1500, m.nc_cov_inc_loss_dcce_2000 AS nc_inc_loss_dcce_2000, m.nc_cov_inc_loss_dcce_2500 AS nc_inc_loss_dcce_2500, m.nc_cov_inc_loss_dcce_5k AS nc_inc_loss_dcce_5k, m.nc_cov_inc_loss_dcce_10k AS nc_inc_loss_dcce_10k, m.nc_cov_inc_loss_dcce_25k AS nc_inc_loss_dcce_25k, m.nc_cov_inc_loss_dcce_50k AS nc_inc_loss_dcce_50k, m.nc_cov_inc_loss_dcce_100k AS nc_inc_loss_dcce_100k, m.nc_cov_inc_loss_dcce_250k AS nc_inc_loss_dcce_250k, m.nc_cov_inc_loss_dcce_500k AS nc_inc_loss_dcce_500k, m.nc_cov_inc_loss_dcce_750k AS nc_inc_loss_dcce_750k, m.nc_cov_inc_loss_dcce_1m AS nc_inc_loss_dcce_1m, m.nc_cov_inc_loss_dcce AS nc_inc_loss_dcce, m.cat_cov_inc_loss_dcce_le500 AS cat_inc_loss_dcce_le500, m.cat_cov_inc_loss_dcce_1000 AS cat_inc_loss_dcce_1000, m.cat_cov_inc_loss_dcce_1500 AS cat_inc_loss_dcce_1500, m.cat_cov_inc_loss_dcce_2000 AS cat_inc_loss_dcce_2000, m.cat_cov_inc_loss_dcce_2500 AS cat_inc_loss_dcce_2500, m.cat_cov_inc_loss_dcce_5k AS cat_inc_loss_dcce_5k, m.cat_cov_inc_loss_dcce_10k AS cat_inc_loss_dcce_10k, m.cat_cov_inc_loss_dcce_25k AS cat_inc_loss_dcce_25k, m.cat_cov_inc_loss_dcce_50k AS cat_inc_loss_dcce_50k, m.cat_cov_inc_loss_dcce_100k AS cat_inc_loss_dcce_100k, m.cat_cov_inc_loss_dcce_250k AS cat_inc_loss_dcce_250k, m.cat_cov_inc_loss_dcce_500k AS cat_inc_loss_dcce_500k, m.cat_cov_inc_loss_dcce_750k AS cat_inc_loss_dcce_750k, m.cat_cov_inc_loss_dcce_1m AS cat_inc_loss_dcce_1m, m.cat_cov_inc_loss_dcce AS cat_inc_loss_dcce, m.bilossinc1530, m.umbilossinc1530, m.uimbilossinc1530, m.quality_replacedvin_flg AS qualityflgreplacedvin, m.quality_replaceddriver_flg AS qualityflgreplaceddriver, m.quality_claimok_flg AS qualityclaimokflg, m.quality_claimunknownvin_flg AS qualityclaimunknownvinflg, m.quality_claimunknownvinnotlisteddriver_flg AS qualityclaimunknownvinnotlisteddriverflg, m.quality_claimpolicytermjoin_flg AS qualityclaimpolicytermjoinflg, m.loaddate
   FROM fsbi_dw_spinn.fact_auto_modeldata m
   JOIN fsbi_dw_spinn.dim_vehicle v ON m.vehicle_id = v.vehicle_id AND m.policy_id = v.policy_id
   JOIN fsbi_dw_spinn.dim_policy p ON m.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.dim_policyextension pe ON m.policy_id = pe.policy_id
   JOIN fsbi_dw_spinn.dim_driver d ON m.driver_id = d.driver_id
   JOIN fsbi_dw_spinn.dim_policy_changes di ON m.policy_changes_id = di.policy_changes_id
   JOIN fsbi_dw_spinn.vdim_producer pr ON m.producer_id = pr.producer_id
   JOIN fsbi_dw_spinn.dim_coveredrisk cr ON cr.coveredrisk_id = m.risk_id
   JOIN fsbi_dw_spinn.vdim_company vdc ON p.company_id = vdc.company_id
   JOIN fsbi_dw_spinn.dim_insured i ON p.policy_id = i.policy_id
  WHERE m.startdate < date_add('month'::text, -2::bigint, 'now'::text::date::timestamp without time zone);

COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.policy_uniqueid IS 'PolicyRef';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.vehicle_uniqueid IS 'SPINN Vehicle Id';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.riskcd IS 'Vehicle Number';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.risktypecd IS 'PrivatePassangerAuto only';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driver IS 'LicenseNumber';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driverparentid IS 'SPINN Driver parent Id';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cal_year IS 'Year of Start Date';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.enddate IS 'Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.startdatetm IS 'Exact Mid-Term Start date';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.enddatetm IS 'Exact Mid-Term End Date';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.ecy IS 'DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.coverage IS 'Depend on a view, not applicable forvauto_modeldata,  all coverage groups for _allcov or a specific one for the rest.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.ep IS 'case when renewaltermcd=''1 Year'' then 1 else 2 end * wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntveh IS 'Number of all vehicles in this mid-term change';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntdrv IS 'Number of all active drivers in this mid-term change, including non-assigned: count(distinct case when stg.status=`Active` then  stg.driver_uniqueid else null end) ';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntnondrv IS 'Number of excluded drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) like `%EXCLUDED%`  then stg.driver_uniqueid else null end)';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntexcludeddrv IS 'Number of Non drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) NOT like `%EXCLUDED%` and stg.DriverTypeCd in (`NonOperator`, `Excluded`, `UnderAged`) then  stg.driver_uniqueid else null end)';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.mindriverage IS 'A minimal driver age per this mid-term change. Non assigned drivers are taken into account';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.extra_vehicles IS 'Number of vehicles without assigned drivers';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.salvage IS 'case when v.Salvage_FirstDt>`1900-01-01` then `Yes` else `No` end Salvage';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.matchcarfax IS 'case 
 when v.Mileage=''Estimated'' then ''Estimated''
 when v.Mileage=''Recommended'' and v.CarfaxSource like ''DataReport%''  then 
  case
   when v.EstimatedAnnualDistance = v.CaliforniaRecentMileage then ''CaliforniaRecentMileage Carfax DataReport''
   when v.EstimatedAnnualDistance = v.RecentAverageMileage then ''RecentAverageMileage Carfax DataReport''
   when v.EstimatedAnnualDistance = v.AverageMileage then ''AverageMileage Carfax DataReport''
   when v.EstimatedAnnualDistance = v.ModeledAnnualMileage then ''ModeledAnnualMileage Carfax DataReport''
   else ''Not Match Carfax DataReport''
  end
   when v.Mileage=''Recommended'' and v.CarfaxSource like ''Extend%''  then 
  case
   when v.EstimatedAnnualDistance = v.CaliforniaRecentMileage then ''CaliforniaRecentMileage Prev Term Carfax DataReport''
   when v.EstimatedAnnualDistance = v.RecentAverageMileage then ''RecentAverageMileage  Prev Term Carfax DataReport''
   when v.EstimatedAnnualDistance = v.AverageMileage then ''AverageMileage  Prev Term Carfax DataReport''
   when v.EstimatedAnnualDistance = v.ModeledAnnualMileage then ''ModeledAnnualMileage  Prev Term Carfax DataReport''
   else ''Not Match Prev Term Carfax DataReport''
  end
   else ''N/A''
end matchCarfax';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.vehicle_value IS 'Calculated based on RACOLRatingValue';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.liabilityonlyflg IS 'Y if there are only BI, UM, PD, Med coverages exists for this vehicle in the mid-term change';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.componlyflg IS 'Y if there are only COLL and COMP coverages exists for this vehicle in the mid-term change';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.viol_pointscharged_adj IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.acci_pointscharged_adj IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.missedviolationpoints IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.acci5yr IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.acci7yr IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.pointscharged IS 'Stale, no updates starting 2023-03-23. See Modeldata in Atlan and ETL ModelData Workbook v2.xlsx for more details.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driverage IS 'Age based of DIM_DRIVER.BirthDate';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driverlicenseage IS 'Age based on DIM_DRIVER.DriverLicenseDate';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.excess_veh_ind IS 'Y if there are more vehicles then drivers';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.insurancescorevalue IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.ratepageeffectivedt IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.insscoretiervalueband IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.applieddt IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.financialstabilitytier IS 'No historical data populated, Almost empty';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.excludeddrvflg IS 'Excluded drivers in SPINN have the same ID. If there is a claim for an excluded driver it is not possible to assign to a proper driver even in SPINN itself. The number of excluded driver also can be afected';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityflgreplacedvin IS 'It`s Y if a vehicle was not set as "Deleted" but rather replaced with an other vehicle';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityflgreplaceddriver IS 'It`s Y if a driver was not set as "Deleted" but rather replaced with an other driver';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimokflg IS 'Y if no issues to assign a claim to a proper mid-term change';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimunknownvinflg IS 'A claim with Unknown VIN in the system';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimunknownvinnotlisteddriverflg IS 'A claim with Unknown VIN and a driver not primary assigned to a vehicle';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimpolicytermjoinflg IS 'A claim is assign to a first record in a policy term due to issues in a related policy ref and/or loss date.';
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.loaddate IS 'When data were loaded';


-- fsbi_dw_spinn.vdim_accountingdate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_accountingdate
AS SELECT dim_time.time_id AS accountingdate_id, dim_time.tm_date AS acct_date, dim_time.tm_dayname AS acct_dayname, dim_time.tm_dayabbr AS acct_dayabbr, dim_time.tm_dayinweek AS acct_dayinweek, dim_time.tm_dayinmonth AS acct_dayinmonth, dim_time.tm_dayinquarter AS acct_dayinquarter, dim_time.tm_dayinyear AS acct_dayinyear, dim_time.tm_weekinmonth AS acct_weekinmonth, dim_time.tm_weekinquarter AS acct_weekinquarter, dim_time.tm_weekinyear AS acct_weekinyear, dim_time.tm_monthname AS acct_monthname, dim_time.tm_monthabbr AS acct_monthabbr, dim_time.tm_monthinquarter AS acct_monthinquarter, dim_time.tm_monthinyear AS acct_monthinyear, dim_time.tm_quarter AS acct_quarter, dim_time.tm_year AS acct_year, dim_time.tm_reportperiod AS acct_reportperiod, dim_time.tm_isodate AS acct_isodate, dim_time.month_id AS acct_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_adjuster source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_adjuster
AS SELECT dim_adjuster.adjuster_id, dim_adjuster.adjuster_type AS adj_type, dim_adjuster.adjuster_number AS adj_number, dim_adjuster.name AS adj_name1, dim_adjuster.name AS adj_fullname, dim_adjuster.address1 AS adj_address1, dim_adjuster.address2 AS adj_address2, dim_adjuster.city AS adj_city, dim_adjuster.state AS adj_state, dim_adjuster.postalcode AS adj_postalcode, dim_adjuster.country AS adj_country, dim_adjuster.telephone AS adj_telephone, dim_adjuster.fax AS adj_fax, dim_adjuster.email AS adj_email, dim_adjuster.adjuster_uniqueid AS adj_uniqueid, dim_adjuster.source_system, dim_adjuster.loaddate
   FROM fsbi_dw_spinn.dim_adjuster;


-- fsbi_dw_spinn.vdim_bookeffectivedate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_bookeffectivedate
AS SELECT dim_time.time_id AS bookeffectivedate_id, dim_time.tm_date AS bkeff_date, dim_time.tm_dayname AS bkeff_dayname, dim_time.tm_dayabbr AS bkeff_dayabbr, dim_time.tm_dayinweek AS bkeff_dayinweek, dim_time.tm_dayinmonth AS bkeff_dayinmonth, dim_time.tm_dayinquarter AS bkeff_dayinquarter, dim_time.tm_dayinyear AS bkeff_dayinyear, dim_time.tm_weekinmonth AS bkeff_weekinmonth, dim_time.tm_weekinquarter AS bkeff_weekinquarter, dim_time.tm_weekinyear AS bkeff_weekinyear, dim_time.tm_monthname AS bkeff_monthname, dim_time.tm_monthabbr AS bkeff_monthabbr, dim_time.tm_monthinquarter AS bkeff_monthinquarter, dim_time.tm_monthinyear AS bkeff_monthinyear, dim_time.tm_quarter AS bkeff_quarter, dim_time.tm_year AS bkeff_year, dim_time.tm_reportperiod AS bkeff_reportperiod, dim_time.tm_isodate AS bkeff_isodate, dim_time.month_id AS bkeff_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_bookexpirationdate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_bookexpirationdate
AS SELECT dim_time.time_id AS bookexpirationdate_id, dim_time.tm_date AS bkexp_date, dim_time.tm_dayname AS bkexp_dayname, dim_time.tm_dayabbr AS bkexp_dayabbr, dim_time.tm_dayinweek AS bkexp_dayinweek, dim_time.tm_dayinmonth AS bkexp_dayinmonth, dim_time.tm_dayinquarter AS bkexp_dayinquarter, dim_time.tm_dayinyear AS bkexp_dayinyear, dim_time.tm_weekinmonth AS bkexp_weekinmonth, dim_time.tm_weekinquarter AS bkexp_weekinquarter, dim_time.tm_weekinyear AS bkexp_weekinyear, dim_time.tm_monthname AS bkexp_monthname, dim_time.tm_monthabbr AS bkexp_monthabbr, dim_time.tm_monthinquarter AS bkexp_monthinquarter, dim_time.tm_monthinyear AS bkexp_monthinyear, dim_time.tm_quarter AS bkexp_quarter, dim_time.tm_year AS bkexp_year, dim_time.tm_reportperiod AS bkexp_reportperiod, dim_time.tm_isodate AS bkexp_isodate, dim_time.month_id AS bkexp_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_buildingrisk source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_buildingrisk
AS
select
	cvrskx.coveredriskextension_id
,	loc.location_id
,	loc.locationnumber
,	bldgrsk.buildingrisknumber
,	bldgrsk.policy_uniqueid
,	bldgrsk.policy_id
,	grpbrdg.group_bridge_id
,	bldgrsk.buildingrisk_id
,	cvrskx.cvrsk_uniqueid, cvrskx.deleted_indicator as cvrsk_deleted_indicator, cast(cvrskx.cvrsk_startdate as date) as cvrsk_startdate, cvrskx.cvrsk_group_uniqueid
,	cvrskx.cvrsk_group_name, cvrskx.cvrsk_group_description, cvrskx.spinn_systemid as cvrsk_spinn_systemid
,	grpbrdg.spinn_systemid as grpbrdg_spinn_systemid
,	cast(bldgrsk.valid_fromdate as date) as valid_fromdate, cast(bldgrsk.valid_todate as date) as valid_todate, bldgrsk.record_version, bldgrsk.buildingrisk_uniqueid, bldgrsk.spinnbuildingrisk_id, bldgrsk.status
,	bldgrsk.bldgnumber, bldgrsk.constructioncd, bldgrsk.roofcd, bldgrsk.yearbuilt, bldgrsk.buildinglimit, bldgrsk.contentslimit, bldgrsk.inflationguardpct, bldgrsk.ordinanceorlawind, bldgrsk.pitchofroof
,	bldgrsk.totallivingsqft, bldgrsk.msbreconstructionestimate, bldgrsk.sprinkleredbuildings, bldgrsk.unitsperbuilding, bldgrsk.numstories, bldgrsk.constructionquality, bldgrsk.areasofcoverage, bldgrsk.rpc125pct
,	bldgrsk.increasedconstcost, bldgrsk.tiv_spinn, bldgrsk.tiv, bldgrsk.timeelement, bldgrsk.subjectamount, bldgrsk.facultativecededpremium, bldgrsk.cededpremiumfactor, bldgrsk.buildingtype, bldgrsk.saunaroom
,	bldgrsk.fitnesscenter, bldgrsk.annualrevenue, bldgrsk.licensedbeds, bldgrsk.riskgroupnumber, bldgrsk.riskgrouptype, bldgrsk.riskgroupdescrtiption, bldgrsk.loaddate, bldgrsk.audit_id
,	cast(bldgrsk.original_valid_fromdate as date) as original_valid_fromdate, cast(bldgrsk.original_valid_todate as date) as original_valid_todate, bldgrsk.original_record_version
from fsbi_dw_spinn.dim_location loc
join fsbi_dw_spinn.dim_coveredriskextension cvrskx on loc.location_id = cvrskx.cvrsk_group_id -- and loc.policy_id=cvrskx.policy_id and cvrskx.cvrsk_group_name='LOCATION'
join fsbi_dw_spinn.dim_group_bridge grpbrdg on cvrskx.coveredriskextension_id = grpbrdg.coveredriskextension_id and loc.location_id = cvrskx.cvrsk_group_id -- and grpbrdg.cvrsk_item_role='BuildingRisk' -- and grpbrdg.policy_id=cvrskx.policy_id
join fsbi_dw_spinn.dim_buildingrisk bldgrsk on grpbrdg.cvrsk_item_id = bldgrsk.buildingrisk_id -- and grpbrdg.policy_id=bldgrsk.policy_id
with no schema binding;


-- fsbi_dw_spinn.vdim_claimant source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_claimant
AS SELECT dim_legalentity.claimant_id, dim_legalentity.claimant_role AS clmnt_role, dim_legalentity.claimant_type AS clmnt_type, dim_legalentity.claimant_number AS clmnt_number, dim_legalentity.name AS clmnt_name1, dim_legalentity.name AS clmnt_fullname, dim_legalentity.dob AS clmnt_dob, dim_legalentity.occupation AS clmnt_occupation, dim_legalentity.gender AS clmnt_gender, dim_legalentity.maritalstatus AS clmnt_maritalstatus, dim_legalentity.address1 AS clmnt_address1, dim_legalentity.address2 AS clmnt_address2, dim_legalentity.city AS clmnt_city, dim_legalentity.state AS clmnt_state, dim_legalentity.postalcode AS clmnt_postalcode, dim_legalentity.country AS clmnt_country, dim_legalentity.telephone AS clmnt_telephone, dim_legalentity.fax AS clmnt_fax, dim_legalentity.email AS clmnt_email, dim_legalentity.jobtitle AS clmnt_jobtitle, dim_legalentity.claimant_uniqueid AS clmnt_uniqueid, dim_legalentity.source_system, dim_legalentity.loaddate
   FROM fsbi_dw_spinn.dim_claimant dim_legalentity;


-- fsbi_dw_spinn.vdim_claimlossaddress source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_claimlossaddress
AS SELECT dim_address.address_id AS claimlossaddress_id, dim_address.addr_address1 AS clmadd_address1, dim_address.addr_address2 AS clmadd_address2, dim_address.addr_address3 AS clmadd_address3, dim_address.addr_county AS clmadd_county, dim_address.addr_city AS clmadd_city, dim_address.addr_state AS clmadd_state, dim_address.addr_postalcode AS clmadd_postalcode, dim_address.addr_country AS clmadd_country, dim_address.addr_latitude AS clmadd_latitude, dim_address.addr_longitude AS clmadd_longitude, dim_address.source_system, dim_address.loaddate
   FROM fsbi_dw_spinn.dim_address;


-- fsbi_dw_spinn.vdim_claimlossgeography source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_claimlossgeography
AS SELECT dim_geography.geography_id AS claimgeography_id, dim_geography.geo_county AS clmgeo_county, dim_geography.geo_city AS clmgeo_city, dim_geography.geo_state AS clmgeo_state, dim_geography.geo_postalcode AS clmgeo_postalcode, dim_geography.geo_country AS clmgeo_country, dim_geography.source_system, dim_geography.loaddate
   FROM fsbi_dw_spinn.dim_geography;


-- fsbi_dw_spinn.vdim_claimstatus source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_claimstatus
AS SELECT dim_status.status_id AS claimstatus_id, dim_status.stat_4sightbistatuscd AS clmst_4sightbistatuscd, dim_status.stat_statuscd AS clmst_statuscd, dim_status.stat_status AS clmst_status, dim_status.stat_substatuscd AS clmst_substatuscd, dim_status.stat_substatus AS clmst_substatus
   FROM fsbi_dw_spinn.dim_status
  WHERE dim_status.stat_category::text = 'claim'::character varying::text;


-- fsbi_dw_spinn.vdim_closedate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_closedate
AS SELECT dim_time.time_id AS closeddate_id, dim_time.tm_date AS clsdt_date, dim_time.tm_dayname AS clsdt_dayname, dim_time.tm_dayabbr AS clsdt_dayabbr, dim_time.tm_dayinweek AS clsdt_dayinweek, dim_time.tm_dayinmonth AS clsdt_dayinmonth, dim_time.tm_dayinquarter AS clsdt_dayinquarter, dim_time.tm_dayinyear AS clsdt_dayinyear, dim_time.tm_weekinmonth AS clsdt_weekinmonth, dim_time.tm_weekinquarter AS clsdt_weekinquarter, dim_time.tm_weekinyear AS clsdt_weekinyear, dim_time.tm_monthname AS clsdt_monthname, dim_time.tm_monthabbr AS clsdt_monthabbr, dim_time.tm_monthinquarter AS clsdt_monthinquarter, dim_time.tm_monthinyear AS clsdt_monthinyear, dim_time.tm_quarter AS clsdt_quarter, dim_time.tm_year AS clsdt_year, dim_time.tm_reportperiod AS clsdt_reportperiod, dim_time.tm_isodate AS clsdt_isodate, dim_time.month_id AS clsdt_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_company source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_company
AS SELECT dim_legalentity.legalentity_id AS company_id, dim_legalentity.lenty_role AS comp_role, dim_legalentity.lenty_number AS comp_number, dim_legalentity.lenty_name1 AS comp_name1, dim_legalentity.lenty_uniqueid AS comp_uniqueid, dim_legalentity.source_system, dim_legalentity.loaddate
   FROM fsbi_dw_spinn.dim_legalentity_other dim_legalentity
  WHERE dim_legalentity.lenty_role::text = 'COMPANY'::character varying::text;

COMMENT ON VIEW fsbi_dw_spinn.vdim_company IS 'DW Table type:	Dimension	Table description:	Physical table dim_legalentity_other contains few entities like Company with very small number of records';


-- fsbi_dw_spinn.vdim_coverage source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_coverage
AS SELECT dim_coverage.coverage_id, dim_coverage.cov_type, dim_coverage.cov_code, dim_coverage.cov_name, dim_coverage.cov_description, dim_coverage.cov_subcode, dim_coverage.cov_subcodename, dim_coverage.cov_subcodedescription, dim_coverage.cov_asl, dim_coverage.cov_subline, dim_coverage.loaddate, 
        CASE
            WHEN dim_coverage.cov_code::text = ANY (ARRAY['ACVGP'::text, 'ADDLL'::text, 'BLDG'::text, 'BOLCC'::text, 'BURMN'::text, 'BUSRN'::text, 'BUSPR'::text, 'BUSP'::text, 'BUSRN2'::text, 'TENTL'::text, 'PRDCO'::text, 'BOLAW'::text, 'BuildingOrdinance'::text, 'FVREP'::text, 'FRV'::text, 'FXRC'::text, 'F.34410A'::text, 'F.34405A'::text, 'F.34415A'::text, 'F.34420A'::text, 'F.30630'::text, 'F30630'::text, 'F.30655'::text, 'F30655'::text, 'F.30850'::text, 'F.31025'::text, 'F30745'::text, 'F.30745'::text, 'F34410A'::text, 'H056ST0'::text, 'CovA'::text, 'CovA-FL'::text, 'DWELL'::text, 'CovA-EC'::text, 'CovA-SF'::text, 'CovB'::text, 'OS'::text, 'CovC'::text, 'CovD'::text, 'CovE'::text, 'AddCovC'::text, 'CovC-EC'::text, 'CovC-FL'::text, 'CovC-SF'::text, 'ALEXP'::text, 'PP'::text, 'SPP'::text, 'G.30980'::text, 'G30980'::text, 'H051ST0'::text, 'H312ST0'::text, 'H071ST0'::text, 'H043ST0'::text, 'H042ST0'::text, 'H065ST0'::text, 'H050ST0'::text, 'H065ST0'::text, 'H032ST0'::text, 'ML55'::text, 'ML0055'::text, 'DAU1143'::text, 'D016ST1'::text]) THEN '1st Party Property'::character varying
            WHEN dim_coverage.cov_code::text = 'LBMED'::character varying::text OR dim_coverage.cov_code::text = 'MEDEX'::character varying::text OR dim_coverage.cov_code::text = 'PIADV'::character varying::text OR dim_coverage.cov_code::text = 'CovF'::character varying::text OR dim_coverage.cov_code::text = 'PIHOM'::character varying::text OR dim_coverage.cov_code::text = 'H082ST0'::character varying::text OR dim_coverage.cov_code::text = 'DAUPI'::character varying::text OR dim_coverage.cov_code::text = 'F31890'::character varying::text OR dim_coverage.cov_code::text = 'F.31890'::character varying::text OR dim_coverage.cov_code::text = 'L9287'::character varying::text THEN '3rd Party Property'::character varying
            WHEN dim_coverage.cov_code::text = 'MEDPAY'::character varying::text THEN '3rd Party Liability'::character varying
            WHEN dim_coverage.cov_code::text = ANY (ARRAY['F32465'::text, 'F.32470'::text, 'F.32465'::text, 'F32470'::text, 'F.32470'::text, 'F.34350A'::text, 'F.34355A'::text, 'F30960'::text, 'F.30960'::text, 'F34350A'::text, 'H072ST0'::text, 'H053ST0'::text, 'H308ST0'::text, 'H313ST0'::text, 'H074ST0'::text, 'H075ST0'::text, 'H164ST0'::text, 'H314ST0'::text, 'HO5'::text, 'LVREP'::text, 'ML545'::text]) THEN 'Enhc Home Covg'::character varying
            WHEN dim_coverage.cov_code::text = ANY (ARRAY['ANFPO'::text, 'BLDDC'::text, 'EMPDH'::text, 'HNA'::text, 'MSECP'::text, 'MSOFF'::text, 'SDB'::text, 'AHIPH'::text, 'EE'::text, 'F34415A'::text, 'OLT'::text]) THEN 'Enhc Comm Covg'::character varying
            WHEN dim_coverage.cov_code::text = ANY (ARRAY['MBEBU'::text, 'EQPBK'::text, 'F.34395A'::text, 'BRKDN'::text, 'F.32815'::text, 'F.32820'::text, 'F.32825'::text, 'F.32830'::text, 'F32830'::text, 'F32825'::text, 'F32820'::text, 'F32815'::text, 'F34395A'::text]) THEN 'MBR'::character varying
            WHEN dim_coverage.cov_code::text = 'BI'::character varying::text OR dim_coverage.cov_code::text = 'BISPL'::character varying::text THEN 'Auto BI'::character varying
            WHEN dim_coverage.cov_code::text = 'PD'::character varying::text THEN 'Auto PD'::character varying
            WHEN dim_coverage.cov_code::text = 'COLL'::character varying::text OR dim_coverage.cov_code::text = 'Collision'::character varying::text OR dim_coverage.cov_code::text = 'CWAIV'::character varying::text OR dim_coverage.cov_code::text = 'WaiverOfCollision'::character varying::text OR dim_coverage.cov_code::text = 'RRGAP'::character varying::text THEN 'Col'::character varying
            WHEN dim_coverage.cov_code::text = 'COMP'::character varying::text OR dim_coverage.cov_code::text = 'Comprehensive'::character varying::text THEN 'Comp'::character varying
            WHEN dim_coverage.cov_code::text = 'CUSTE'::character varying::text OR dim_coverage.cov_code::text = 'LOAN'::character varying::text OR dim_coverage.cov_code::text = 'MPREM'::character varying::text OR dim_coverage.cov_code::text = 'OEM'::character varying::text OR dim_coverage.cov_code::text = 'RIDESH'::character varying::text THEN 'Enhc Auto Covg'::character varying
            WHEN dim_coverage.cov_code::text = 'GLASA'::character varying::text THEN 'Glass AZ'::character varying
            WHEN dim_coverage.cov_code::text = 'RentalReimbursement'::character varying::text OR dim_coverage.cov_code::text = 'RREIM'::character varying::text THEN 'LU'::character varying
            WHEN (dim_coverage.cov_code::text = 'MedPay'::character varying::text OR dim_coverage.cov_code::text = 'MEDPM'::character varying::text) AND (dim_coverage.cov_asl::text = 192::character varying::text OR dim_coverage.cov_asl::text = 211::character varying::text) THEN 'MP'::character varying
            WHEN dim_coverage.cov_code::text = 'ROAD'::character varying::text OR dim_coverage.cov_code::text = 'TOW'::character varying::text THEN 'Tow'::character varying
            WHEN dim_coverage.cov_code::text = 'LAC'::character varying::text OR dim_coverage.cov_code::text = 'H035ST0'::character varying::text OR dim_coverage.cov_code::text = 'H037ST0'::character varying::text OR dim_coverage.cov_code::text = 'DAU0463'::character varying::text THEN 'LAC'::character varying
            WHEN dim_coverage.cov_code::text = 'INCB'::character varying::text OR dim_coverage.cov_code::text = 'H048ST0'::character varying::text THEN 'INCB'::character varying
            WHEN dim_coverage.cov_code::text = 'PPREP'::character varying::text OR dim_coverage.cov_code::text = 'H500ST0'::character varying::text THEN 'PPREP'::character varying
            WHEN dim_coverage.cov_code::text = 'H061ST0'::character varying::text OR dim_coverage.cov_code::text = 'SPP'::character varying::text THEN 'SPP'::character varying
            WHEN dim_coverage.cov_code::text = 'SRORP'::character varying::text OR dim_coverage.cov_code::text = 'H033ST0'::character varying::text OR dim_coverage.cov_code::text = 'H070ST0'::character varying::text OR dim_coverage.cov_code::text = 'H040ST0'::character varying::text THEN 'SRORP'::character varying
            WHEN dim_coverage.cov_code::text = 'THEFA'::character varying::text OR dim_coverage.cov_code::text = 'H080ST0'::character varying::text OR dim_coverage.cov_code::text = 'DAU0472'::character varying::text THEN 'Theft'::character varying
            WHEN dim_coverage.cov_code::text = ANY (ARRAY['WCINC'::text, 'HO2490-Inservant'::text, 'H090CA0-Inservant'::text, 'H090CA0-Occasional'::text, 'HO2490-Occasional'::text, 'H090CA0-Outservant'::text, 'ML0090Inservant'::text, 'ML0090Occasional'::text, 'ML0090Outservant'::text, 'WCPIN'::text, 'WCPOT'::text, 'H090CA0'::text, 'HO2490'::text, 'ML0090'::text]) THEN 'WCINC'::character varying
            WHEN dim_coverage.cov_code::text = 'DAUCPL'::character varying::text OR dim_coverage.cov_code::text = 'D650ST1'::character varying::text OR dim_coverage.cov_code::text = 'CPL'::character varying::text THEN 'CPL'::character varying
            WHEN dim_coverage.cov_code::text = 'GL600'::character varying::text OR dim_coverage.cov_code::text = 'GL1'::character varying::text THEN 'GL1'::character varying
            WHEN dim_coverage.cov_code::text = 'LIAB'::character varying::text OR dim_coverage.cov_code::text = 'D660ST1'::character varying::text OR dim_coverage.cov_code::text = 'DAUOLT'::character varying::text THEN 'LIAB'::character varying
            WHEN dim_coverage.cov_code::text = 'PersonalExcessLiability'::character varying::text OR dim_coverage.cov_code::text = 'XSLIAB'::character varying::text OR dim_coverage.cov_code::text = 'F.31580A'::character varying::text OR dim_coverage.cov_code::text = 'F.31580A2'::character varying::text THEN 'XSLIAB'::character varying
            WHEN dim_coverage.cov_code::text = 'FVREP'::character varying::text OR dim_coverage.cov_code::text = 'DAU0156'::character varying::text OR dim_coverage.cov_code::text = 'D515ST1'::character varying::text THEN 'FVREP'::character varying
            WHEN dim_coverage.cov_code::text = 'F34420A'::character varying::text OR dim_coverage.cov_code::text = 'PPREP'::character varying::text THEN 'PPREP'::character varying
            WHEN dim_coverage.cov_code::text = 'F34390A'::character varying::text OR dim_coverage.cov_code::text = 'UTLDB'::character varying::text THEN 'UTLDB'::character varying
            WHEN dim_coverage.cov_code::text = ANY (ARRAY['APMP'::text, 'MINR'::text, 'REINS'::text, 'STRT'::text, 'SWMPL'::text, 'XCBUL'::text, 'APMP'::text, 'TRIA'::text, 'F.32630'::text, 'CUMBR'::text, 'CUMBR2'::text, 'F.30005B'::text, 'F.30005B2'::text, 'MinimumPremium'::text, 'BUSPR'::text, 'H1008'::text, 'H1009'::text, 'H1016'::text, 'H1010'::text, 'INADJ'::text, 'MISC'::text, 'LL1'::text, 'LL2'::text, 'F.34090B'::text, 'F.34090'::text, 'F.34385A'::text, 'F.34390A'::text, 'CatFactor'::text, 'ClaimFreePersistency'::text, 'ClaimHistory'::text, 'MultiPolicy'::text, 'NonSmoker'::text, 'ProtectiveDevices'::text, 'IncreasedOtherStructures'::text, 'LogHome'::text, 'MobileHome'::text, 'NewRenovatedHome'::text, 'NewHomeF.30970'::text, 'FireProtection'::text, 'PRTDVC'::text, 'ALARM'::text, 'EMP'::text, 'ConstructionAge'::text, 'AdditionalResidencesOccupiedInsured'::text, 'ADDRR'::text, 'GROUP'::text, 'H525ST0'::text, 'H216ST0'::text, 'PRTDVC'::text, 'H590ST0'::text, 'MATUR'::text, 'MatureResidence'::text, 'Senior'::text, 'F.30970'::text, 'PropertyLine'::text, 'TerritorialFactor'::text, 'Seasonal'::text, 'RoofType'::text, 'GalvanizedPipe'::text, 'ResidenceUnderRenovation'::text, 'WoodCoalPelletStove'::text, 'WoodStove'::text, 'SWNPL'::text, 'WindHailExclusion'::text, 'SpaceHeater'::text, 'StructuresExclusion'::text, 'RoofExclusion'::text, 'NumberOfFamilies'::text, 'PropertyManager'::text, 'RentersInsurance'::text]) THEN 'Not Claims'::character varying
            WHEN dim_coverage.cov_code::text ~~ '%Fee%'::character varying::text OR dim_coverage.cov_code::text ~~ '%Discount%'::character varying::text OR dim_coverage.cov_code::text ~~ '%Credit%'::character varying::text OR dim_coverage.cov_code::text ~~ '%Surcharge%'::character varying::text OR dim_coverage.cov_code::text ~~ '%Deductible%'::character varying::text OR dim_coverage.cov_code::text ~~ 'Vandalism%'::character varying::text THEN 'Not Claims'::character varying
            ELSE dim_coverage.cov_code
        END AS claims_cov_group
   FROM fsbi_dw_spinn.dim_coverage;


-- fsbi_dw_spinn.vdim_coverageeffectivedate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_coverageeffectivedate
AS SELECT dim_time.time_id AS coverageeffectivedate_id, dim_time.tm_date AS coveff_date, dim_time.tm_dayname AS coveff_dayname, dim_time.tm_dayabbr AS coveff_dayabbr, dim_time.tm_dayinweek AS coveff_dayinweek, dim_time.tm_dayinmonth AS coveff_dayinmonth, dim_time.tm_dayinquarter AS coveff_dayinquarter, dim_time.tm_dayinyear AS coveff_dayinyear, dim_time.tm_weekinmonth AS coveff_weekinmonth, dim_time.tm_weekinquarter AS coveff_weekinquarter, dim_time.tm_weekinyear AS coveff_weekinyear, dim_time.tm_monthname AS coveff_monthname, dim_time.tm_monthabbr AS coveff_monthabbr, dim_time.tm_monthinquarter AS coveff_monthinquarter, dim_time.tm_monthinyear AS coveff_monthinyear, dim_time.tm_quarter AS coveff_quarter, dim_time.tm_year AS coveff_year, dim_time.tm_reportperiod AS coveff_reportperiod, dim_time.tm_isodate AS coveff_isodate, dim_time.month_id AS coveff_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_coverageexpirationdate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_coverageexpirationdate
AS SELECT dim_time.time_id AS coverageexpirationdate_id, dim_time.tm_date AS covexp_date, dim_time.tm_dayname AS covexp_dayname, dim_time.tm_dayabbr AS covexp_dayabbr, dim_time.tm_dayinweek AS covexp_dayinweek, dim_time.tm_dayinmonth AS covexp_dayinmonth, dim_time.tm_dayinquarter AS covexp_dayinquarter, dim_time.tm_dayinyear AS covexp_dayinyear, dim_time.tm_weekinmonth AS covexp_weekinmonth, dim_time.tm_weekinquarter AS covexp_weekinquarter, dim_time.tm_weekinyear AS covexp_weekinyear, dim_time.tm_monthname AS covexp_monthname, dim_time.tm_monthabbr AS covexp_monthabbr, dim_time.tm_monthinquarter AS covexp_monthinquarter, dim_time.tm_monthinyear AS covexp_monthinyear, dim_time.tm_quarter AS covexp_quarter, dim_time.tm_year AS covexp_year, dim_time.tm_reportperiod AS covexp_reportperiod, dim_time.tm_isodate AS covexp_isodate, dim_time.month_id AS covexp_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_dateofloss source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_dateofloss
AS SELECT dim_time.time_id AS dateofloss_id, dim_time.tm_date AS dol_date, dim_time.tm_dayname AS dol_dayname, dim_time.tm_dayabbr AS dol_dayabbr, dim_time.tm_dayinweek AS dol_dayinweek, dim_time.tm_dayinmonth AS dol_dayinmonth, dim_time.tm_dayinquarter AS dol_dayinquarter, dim_time.tm_dayinyear AS dol_dayinyear, dim_time.tm_weekinmonth AS dol_weekinmonth, dim_time.tm_weekinquarter AS dol_weekinquarter, dim_time.tm_weekinyear AS dol_weekinyear, dim_time.tm_monthname AS dol_monthname, dim_time.tm_monthabbr AS dol_monthabbr, dim_time.tm_monthinquarter AS dol_monthinquarter, dim_time.tm_monthinyear AS dol_monthinyear, dim_time.tm_quarter AS dol_quarter, dim_time.tm_year AS dol_year, dim_time.tm_reportperiod AS dol_reportperiod, dim_time.tm_isodate AS dol_isodate, dim_time.month_id AS dol_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_effectivedate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_effectivedate
AS SELECT dim_time.time_id AS effectivedate_id, dim_time.tm_date AS eff_date, dim_time.tm_dayname AS eff_dayname, dim_time.tm_dayabbr AS eff_dayabbr, dim_time.tm_dayinweek AS eff_dayinweek, dim_time.tm_dayinmonth AS eff_dayinmonth, dim_time.tm_dayinquarter AS eff_dayinquarter, dim_time.tm_dayinyear AS eff_dayinyear, dim_time.tm_weekinmonth AS eff_weekinmonth, dim_time.tm_weekinquarter AS eff_weekinquarter, dim_time.tm_weekinyear AS eff_weekinyear, dim_time.tm_monthname AS eff_monthname, dim_time.tm_monthabbr AS eff_monthabbr, dim_time.tm_monthinquarter AS eff_monthinquarter, dim_time.tm_monthinyear AS eff_monthinyear, dim_time.tm_quarter AS eff_quarter, dim_time.tm_year AS eff_year, dim_time.tm_reportperiod AS eff_reportperiod, dim_time.tm_isodate AS eff_isodate, dim_time.month_id AS eff_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_expirationdate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_expirationdate
AS SELECT dim_time.time_id AS expirationdate_id, dim_time.tm_date AS exp_date, dim_time.tm_dayname AS exp_dayname, dim_time.tm_dayabbr AS exp_dayabbr, dim_time.tm_dayinweek AS exp_dayinweek, dim_time.tm_dayinmonth AS exp_dayinmonth, dim_time.tm_dayinquarter AS exp_dayinquarter, dim_time.tm_dayinyear AS exp_dayinyear, dim_time.tm_weekinmonth AS exp_weekinmonth, dim_time.tm_weekinquarter AS exp_weekinquarter, dim_time.tm_weekinyear AS exp_weekinyear, dim_time.tm_monthname AS exp_monthname, dim_time.tm_monthabbr AS exp_monthabbr, dim_time.tm_monthinquarter AS exp_monthinquarter, dim_time.tm_monthinyear AS exp_monthinyear, dim_time.tm_quarter AS exp_quarter, dim_time.tm_year AS exp_year, dim_time.tm_reportperiod AS exp_reportperiod, dim_time.tm_isodate AS exp_isodate, dim_time.month_id AS exp_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_openeddate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_openeddate
AS SELECT dim_time.time_id AS openeddate_id, dim_time.tm_date AS opndt_date, dim_time.tm_dayname AS opndt_dayname, dim_time.tm_dayabbr AS opndt_dayabbr, dim_time.tm_dayinweek AS opndt_dayinweek, dim_time.tm_dayinmonth AS opndt_dayinmonth, dim_time.tm_dayinquarter AS opndt_dayinquarter, dim_time.tm_dayinyear AS opndt_dayinyear, dim_time.tm_weekinmonth AS opndt_weekinmonth, dim_time.tm_weekinquarter AS opndt_weekinquarter, dim_time.tm_weekinyear AS opndt_weekinyear, dim_time.tm_monthname AS opndt_monthname, dim_time.tm_monthabbr AS opndt_monthabbr, dim_time.tm_monthinquarter AS opndt_monthinquarter, dim_time.tm_monthinyear AS opndt_monthinyear, dim_time.tm_quarter AS opndt_quarter, dim_time.tm_year AS opndt_year, dim_time.tm_reportperiod AS opndt_reportperiod, dim_time.tm_isodate AS opndt_isodate, dim_time.month_id AS opndt_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_policy source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_policy
AS SELECT dim_policy.pol_policynumber, dim_policy.pol_policynumbersuffix, dim_policy.policy_id, dim_policy.pol_policynumber::text + 
        CASE
            WHEN dim_policy.pol_policynumbersuffix::text <> '~'::character varying::text THEN ('-'::character varying::text + dim_policy.pol_policynumbersuffix::text)::character varying
            ELSE ''::character varying
        END::text AS pol_completepolicynumber, dim_policy.pol_masterstate, dim_policy.pol_uniqueid, dim_policy.source_system, dim_policy.loaddate
   FROM fsbi_dw_spinn.dim_policy;


-- fsbi_dw_spinn.vdim_policyeffectivedate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_policyeffectivedate
AS SELECT dim_time.time_id AS policyeffectivedate_id, dim_time.tm_date AS poleff_date, dim_time.tm_dayname AS poleff_dayname, dim_time.tm_dayabbr AS poleff_dayabbr, dim_time.tm_dayinweek AS poleff_dayinweek, dim_time.tm_dayinmonth AS poleff_dayinmonth, dim_time.tm_dayinquarter AS poleff_dayinquarter, dim_time.tm_dayinyear AS poleff_dayinyear, dim_time.tm_weekinmonth AS poleff_weekinmonth, dim_time.tm_weekinquarter AS poleff_weekinquarter, dim_time.tm_weekinyear AS poleff_weekinyear, dim_time.tm_monthname AS poleff_monthname, dim_time.tm_monthabbr AS poleff_monthabbr, dim_time.tm_monthinquarter AS poleff_monthinquarter, dim_time.tm_monthinyear AS poleff_monthinyear, dim_time.tm_quarter AS poleff_quarter, dim_time.tm_year AS poleff_year, dim_time.tm_reportperiod AS poleff_reportperiod, dim_time.tm_isodate AS poleff_isodate, dim_time.month_id AS poleff_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_policyexpirationdate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_policyexpirationdate
AS SELECT dim_time.time_id AS policyexpirationdate_id, dim_time.tm_date AS polexp_date, dim_time.tm_dayname AS polexp_dayname, dim_time.tm_dayabbr AS polexp_dayabbr, dim_time.tm_dayinweek AS polexp_dayinweek, dim_time.tm_dayinmonth AS polexp_dayinmonth, dim_time.tm_dayinquarter AS polexp_dayinquarter, dim_time.tm_dayinyear AS polexp_dayinyear, dim_time.tm_weekinmonth AS polexp_weekinmonth, dim_time.tm_weekinquarter AS polexp_weekinquarter, dim_time.tm_weekinyear AS polexp_weekinyear, dim_time.tm_monthname AS polexp_monthname, dim_time.tm_monthabbr AS polexp_monthabbr, dim_time.tm_monthinquarter AS polexp_monthinquarter, dim_time.tm_monthinyear AS polexp_monthinyear, dim_time.tm_quarter AS polexp_quarter, dim_time.tm_year AS polexp_year, dim_time.tm_reportperiod AS polexp_reportperiod, dim_time.tm_isodate AS polexp_isodate, dim_time.month_id AS polexp_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_policymasterterritory source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_policymasterterritory
AS SELECT dim_territory.territory_id AS policymasterterritory_id, dim_territory.terr_code AS pmstrterr_code, dim_territory.terr_name AS pmstrterr_name, dim_territory.source_system
   FROM fsbi_dw_spinn.dim_territory
  WHERE dim_territory.terr_category::text = 'POLICY'::character varying::text;


-- fsbi_dw_spinn.vdim_policystatus source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_policystatus
AS SELECT dim_status.status_id AS policystatus_id, dim_status.stat_4sightbistatuscd AS polst_4sightbistatuscd, dim_status.stat_statuscd AS polst_statuscd, dim_status.stat_status AS polst_status, dim_status.stat_substatuscd AS polst_substatuscd, dim_status.stat_substatus AS polst_substatus
   FROM fsbi_dw_spinn.dim_status
  WHERE dim_status.stat_category::text = 'policy'::character varying::text;


-- fsbi_dw_spinn.vdim_primaryriskaddress source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_primaryriskaddress
AS SELECT dim_address.address_id AS primaryriskaddress_id, dim_address.addr_address1 AS prskadd_address1, dim_address.addr_address2 AS prskadd_address2, dim_address.addr_address3 AS prskadd_address3, dim_address.addr_county AS prskadd_county, dim_address.addr_city AS prskadd_city, dim_address.addr_state AS prskadd_state, dim_address.addr_postalcode AS prskadd_postalcode, dim_address.addr_country AS prskadd_country, dim_address.addr_latitude AS prskadd_latitude, dim_address.addr_longitude AS prskadd_longitude, dim_address.source_system, dim_address.loaddate
   FROM fsbi_dw_spinn.dim_address;


-- fsbi_dw_spinn.vdim_primaryriskgeography source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_primaryriskgeography
AS SELECT dim_geography.geography_id AS primaryriskgeography_id, dim_geography.geo_county AS prskgeo_county, dim_geography.geo_city AS prskgeo_city, dim_geography.geo_state AS prskgeo_state, dim_geography.geo_postalcode AS prskgeo_postalcode, dim_geography.geo_country AS prskgeo_country, dim_geography.source_system, dim_geography.loaddate
   FROM fsbi_dw_spinn.dim_geography;


-- fsbi_dw_spinn.vdim_primaryriskterritory source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_primaryriskterritory
AS SELECT dim_territory.territory_id AS primaryriskterritory_id, dim_territory.terr_code AS prskterr_code, dim_territory.terr_name AS prskterr_name, dim_territory.source_system
   FROM fsbi_dw_spinn.dim_territory
  WHERE dim_territory.terr_category::text = 'RISK'::character varying::text;


-- fsbi_dw_spinn.vdim_producer source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_producer
AS SELECT dim_legalentity.producer_id, 'PRODUCER'::character varying::character varying(50) AS prdr_role, dim_legalentity.producer_number::character varying(50) AS prdr_number, dim_legalentity.producer_name AS prdr_name1, dim_legalentity.address AS prdr_address1, '~'::character varying::character varying(150) AS prdr_address2, dim_legalentity.city AS prdr_city, dim_legalentity.state_cd::character varying(50) AS prdr_state, dim_legalentity.zip::character varying(20) AS prdr_zipcode, 'US'::character varying::character varying(50) AS prdr_country, dim_legalentity.phone AS prdr_telephone, dim_legalentity.email AS prdr_email, dim_legalentity.agency_group, dim_legalentity.national_name, dim_legalentity.national_code, dim_legalentity.territory, dim_legalentity.territory_manager, dim_legalentity.dba, dim_legalentity.producer_status, dim_legalentity.commission_master, dim_legalentity.reporting_master, dim_legalentity.pn_appointment_date, dim_legalentity.producer_uniqueid::character varying(100) AS prdr_uniqueid, dim_legalentity.source_system, dim_legalentity.loaddate::date AS loaddate
   FROM fsbi_dw_spinn.dim_producer dim_legalentity;

COMMENT ON VIEW fsbi_dw_spinn.vdim_producer IS 'The same as FSBI_DW_SPINN.DIM_PRODUCER with all historical records and AMS + Agent Sync (SPINN) data';


-- fsbi_dw_spinn.vdim_producer_lookup source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_producer_lookup
AS SELECT dim_legalentity.producer_id, 'PRODUCER'::character varying::character varying(50) AS prdr_role, dim_legalentity.producer_number::character varying(50) AS prdr_number, dim_legalentity.producer_name AS prdr_name1, dim_legalentity.address AS prdr_address1, '~'::character varying::character varying(150) AS prdr_address2, dim_legalentity.city AS prdr_city, dim_legalentity.state_cd::character varying(50) AS prdr_state, dim_legalentity.zip::character varying(20) AS prdr_zipcode, 'US'::character varying::character varying(50) AS prdr_country, dim_legalentity.phone AS prdr_telephone, dim_legalentity.email AS prdr_email, dim_legalentity.agency_group, dim_legalentity.national_name, dim_legalentity.national_code, dim_legalentity.territory, dim_legalentity.territory_manager, dim_legalentity.dba, dim_legalentity.producer_status, dim_legalentity.commission_master, dim_legalentity.reporting_master, dim_legalentity.pn_appointment_date, dim_legalentity.producer_uniqueid::character varying(100) AS prdr_uniqueid, dim_legalentity.source_system, dim_legalentity.loaddate::date AS loaddate
   FROM fsbi_dw_spinn.dim_producer dim_legalentity
  WHERE dim_legalentity.valid_todate = '2200-01-01 00:00:00'::timestamp without time zone;

COMMENT ON VIEW fsbi_dw_spinn.vdim_producer_lookup IS 'Agency (Producer) data to join by PRDR_NUMBER (PRODUCER_UNIQUEID). Only latest state of a producer data in this view. No history in contrast to vdim_producer. Use VDIM_PRODUCER to join by PRODUCER_ID and get all history.';


-- fsbi_dw_spinn.vdim_reporteddate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_reporteddate
AS SELECT dim_time.time_id AS datereported_id, dim_time.tm_date AS rptdt_date, dim_time.tm_dayname AS rptdt_dayname, dim_time.tm_dayabbr AS rptdt_dayabbr, dim_time.tm_dayinweek AS rptdt_dayinweek, dim_time.tm_dayinmonth AS rptdt_dayinmonth, dim_time.tm_dayinquarter AS rptdt_dayinquarter, dim_time.tm_dayinyear AS rptdt_dayinyear, dim_time.tm_weekinmonth AS rptdt_weekinmonth, dim_time.tm_weekinquarter AS rptdt_weekinquarter, dim_time.tm_weekinyear AS rptdt_weekinyear, dim_time.tm_monthname AS rptdt_monthname, dim_time.tm_monthabbr AS rptdt_monthabbr, dim_time.tm_monthinquarter AS rptdt_monthinquarter, dim_time.tm_monthinyear AS rptdt_monthinyear, dim_time.tm_quarter AS rptdt_quarter, dim_time.tm_year AS rptdt_year, dim_time.tm_reportperiod AS rptdt_reportperiod, dim_time.tm_isodate AS rptdt_isodate, dim_time.month_id AS rptdt_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vdim_transactiondate source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vdim_transactiondate
AS SELECT dim_time.time_id AS transactiondate_id, dim_time.tm_date AS trans_date, dim_time.tm_dayname AS trans_dayname, dim_time.tm_dayabbr AS trans_dayabbr, dim_time.tm_dayinweek AS trans_dayinweek, dim_time.tm_dayinmonth AS trans_dayinmonth, dim_time.tm_dayinquarter AS trans_dayinquarter, dim_time.tm_dayinyear AS trans_dayinyear, dim_time.tm_weekinmonth AS trans_weekinmonth, dim_time.tm_weekinquarter AS trans_weekinquarter, dim_time.tm_weekinyear AS trans_weekinyear, dim_time.tm_monthname AS trans_monthname, dim_time.tm_monthabbr AS trans_monthabbr, dim_time.tm_monthinquarter AS trans_monthinquarter, dim_time.tm_monthinyear AS trans_monthinyear, dim_time.tm_quarter AS trans_quarter, dim_time.tm_year AS trans_year, dim_time.tm_reportperiod AS trans_reportperiod, dim_time.tm_isodate AS trans_isodate, dim_time.month_id AS trans_month_id
   FROM fsbi_dw_spinn.dim_time;


-- fsbi_dw_spinn.vfact_claim source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vfact_claim
AS SELECT fact_claim.claimsummary_id, fact_claim.claim_id, fact_claim.claimant_id, fact_claim.firstinsured_id, fact_claim.primaryrisk_id, fact_claim.policy_id, fact_claim.limit_id, fact_claim.coverageeffectivedate_id, fact_claim.coverageexpirationdate_id, fact_claim.policyeffectivedate_id, fact_claim.policyexpirationdate_id, fact_claim.dateofloss_id, fact_claim.openeddate_id, fact_claim.datereported_id, fact_claim.producer_id, fact_claim.closeddate_id, fact_claim.coverage_id, fact_claim.adjuster_id, fact_claim.month_id, fact_claim.product_id, fact_claim.primaryriskterritory_id, fact_claim.deductible_id, fact_claim.policymasterterritory_id, fact_claim.company_id, fact_claim.primaryriskgeography_id, fact_claim.claimlossgeography_id, fact_claim.class_id, fact_claim.claimstatus_id, fact_claim.claimextension_id, fact_claim.policyextension_id, fact_claim.primaryriskaddress_id, fact_claim.claimlossaddress_id, fact_claim.loss_pd_amt, fact_claim.loss_pd_amt_ytd, fact_claim.loss_pd_amt_itd, fact_claim.loss_rsrv_chng_amt, fact_claim.loss_rsrv_chng_amt_ytd, fact_claim.loss_rsrv_chng_amt_itd, fact_claim.alc_exp_pd_amt, fact_claim.alc_exp_pd_amt_ytd, fact_claim.alc_exp_pd_amt_itd, fact_claim.alc_exp_rsrv_chng_amt, fact_claim.alc_exp_rsrv_chng_amt_ytd, fact_claim.alc_exp_rsrv_chng_amt_itd, fact_claim.salvage_recv_chng_amt, fact_claim.salvage_recv_chng_amt_ytd, fact_claim.salvage_recv_chng_amt_itd, fact_claim.salvage_rsrv_chng_amt, fact_claim.salvage_rsrv_chng_amt_ytd, fact_claim.salvage_rsrv_chng_amt_itd, fact_claim.subro_recv_chng_amt, fact_claim.subro_recv_chng_amt_ytd, fact_claim.subro_recv_chng_amt_itd, fact_claim.subro_rsrv_chng_amt, fact_claim.subro_rsrv_chng_amt_ytd, fact_claim.subro_rsrv_chng_amt_itd, fact_claim.ualc_exp_pd_amt, fact_claim.ualc_exp_pd_amt_ytd, fact_claim.ualc_exp_pd_amt_itd, fact_claim.ualc_exp_rsrv_chng_amt, fact_claim.ualc_exp_rsrv_chng_amt_ytd, fact_claim.ualc_exp_rsrv_chng_amt_itd, fact_claim.feat_days_open, fact_claim.feat_days_open_itd, fact_claim.feat_opened_in_month, fact_claim.feat_closed_in_month, fact_claim.feat_closed_without_pay, fact_claim.feat_closed_with_pay, fact_claim.clm_days_open, fact_claim.clm_days_open_itd, fact_claim.clm_opened_in_month, fact_claim.clm_closed_in_month, fact_claim.clm_closed_without_pay, fact_claim.clm_closed_with_pay, fact_claim.masterclaim, fact_claim.insuredage, fact_claim.source_system, fact_claim.vehicle_id, fact_claim.driver_id, fact_claim.building_id, fact_claim.location_id
   FROM fsbi_dw_spinn.fact_claim;

COMMENT ON VIEW fsbi_dw_spinn.vfact_claim IS 'Basic fact claim  information summarized at a claim level for each month';


-- fsbi_dw_spinn.vfact_claimtransaction source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vfact_claimtransaction
AS SELECT f.claimtransaction_id, f.claim_id, f.claimant_id, f.firstinsured_id, f.primaryrisk_id, f.policy_id, f.limit_id, f.transactiondate_id, f.accountingdate_id, f.policyeffectivedate_id, f.policyexpirationdate_id, f.coverageeffectivedate_id, f.coverageexpirationdate_id, f.openeddate_id, f.closeddate_id, f.datereported_id, f.dateofloss_id, f.producer_id, f.coverage_id, f.adjuster_id, f.primaryriskterritory_id, f.product_id, f.claimtransactiontype_id, f.deductible_id, f.claimstatus_id, f.policymasterterritory_id, f.company_id, f.primaryriskgeography_id, f.claimlossgeography_id, f.class_id, f.policyextension_id, f.claimextension_id, f.claimlossaddress_id, f.primaryriskaddress_id, f.amount, 
        CASE
            WHEN tt.ctrans_code::text = 'LP'::character varying::text AND (tt.ctrans_subcode::text = 'LP'::character varying::text OR tt.ctrans_subcode::text = '10'::character varying::text OR tt.ctrans_subcode::text = '20'::character varying::text OR tt.ctrans_subcode::text = '50'::character varying::text OR tt.ctrans_subcode::text = '51'::character varying::text OR tt.ctrans_subcode::text = '52'::character varying::text OR tt.ctrans_subcode::text = '55'::character varying::text) THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS losses, 
        CASE
            WHEN (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'LR_ILR'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'LR_LRC'::character varying::text OR tt.ctrans_code::text = 'Indemnity-Adjust Reserve'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS reserve, 
        CASE
            WHEN "right"(f.claimtransaction_uniqueid::text, 1) = 3::character varying::text AND ((tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'AEP_AEP'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'AEP_60'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'AEP_61'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'AEP_62'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'AEP_65'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'LIT_61'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'LIT_62'::character varying::text OR tt.ctrans_code::text = 'Adjustment-Deny'::character varying::text OR tt.ctrans_code::text = 'Adjustment-Payment'::character varying::text OR tt.ctrans_code::text = 'Adjustment-ReverseVoid'::character varying::text OR tt.ctrans_code::text = 'Adjustment-StopPayment'::character varying::text OR tt.ctrans_code::text = 'Adjustment-VoidPayment'::character varying::text) THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS expenses, 
        CASE
            WHEN (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'SAL_SALR'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'SAL_70'::character varying::text OR tt.ctrans_code::text = 'Salvage-Payment'::character varying::text OR tt.ctrans_code::text = 'Salvage-RecoveryPost'::character varying::text OR tt.ctrans_code::text = 'Salvage-StopRecovery'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS salvage, 
        CASE
            WHEN (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'SUB_SUBR'::character varying::text OR (tt.ctrans_code::text + '_'::character varying::text + tt.ctrans_subcode::text) = 'SUB_80+'::character varying::text OR tt.ctrans_code::text = 'Subrogation-NSFRecovery'::character varying::text OR tt.ctrans_code::text = 'Subrogation-Payment'::character varying::text OR tt.ctrans_code::text = 'Subrogation-RecoveryPost'::character varying::text OR tt.ctrans_code::text = 'Subrogation-StopRecovery'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS subrogation, 
        CASE
            WHEN "right"(f.claimtransaction_uniqueid::text, 1) = 'A'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS reservechangeamt, 
        CASE
            WHEN "right"(f.claimtransaction_uniqueid::text, 1) = 'B'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS expectedrecoverychangeamt, 
        CASE
            WHEN "right"(f.claimtransaction_uniqueid::text, 1) = 'C'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS paidamt, 
        CASE
            WHEN "right"(f.claimtransaction_uniqueid::text, 1) = 'D'::character varying::text THEN f.amount
            ELSE 0::numeric::numeric(18,0)
        END AS postedrecoveryamt, f.source_system, tt.ctrans_name AS trans_name, f.vehicle_id, f.driver_id, f.building_id, f.location_id
   FROM fsbi_dw_spinn.fact_claimtransaction f
   JOIN fsbi_dw_spinn.dim_claimtransactiontype tt ON f.claimtransactiontype_id = tt.claimtransactiontype_id;

COMMENT ON VIEW fsbi_dw_spinn.vfact_claimtransaction IS 'Basic fact claimtransaction view with measures';


-- fsbi_dw_spinn.vfact_policy source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vfact_policy
AS SELECT fact_policy.factpolicy_id, fact_policy.firstinsured_id, fact_policy.policy_id, fact_policy.producer_id, fact_policy.company_id, fact_policy.policyextension_id, fact_policy.month_id, fact_policy.product_id, fact_policy.policyeffectivedate_id, fact_policy.policyexpirationdate_id, fact_policy.policystatus_id, fact_policy.policymasterterritory_id, fact_policy.comm_amt, fact_policy.comm_amt_ytd, fact_policy.comm_amt_itd, fact_policy.wrtn_prem_amt, fact_policy.wrtn_prem_amt_ytd, fact_policy.wrtn_prem_amt_itd, fact_policy.gross_wrtn_prem_amt, fact_policy.gross_wrtn_prem_amt_ytd, fact_policy.gross_wrtn_prem_amt_itd, fact_policy.orig_wrtn_prem_amt, fact_policy.orig_wrtn_prem_amt_ytd, fact_policy.orig_wrtn_prem_amt_itd, fact_policy.term_prem_amt, fact_policy.term_prem_amt_ytd, fact_policy.term_prem_amt_itd, fact_policy.earned_prem_amt, fact_policy.earned_prem_amt_ytd, fact_policy.earned_prem_amt_itd, fact_policy.unearned_prem, fact_policy.gross_earned_prem_amt, fact_policy.gross_earned_prem_amt_ytd, fact_policy.gross_earned_prem_amt_itd, fact_policy.endorse_prem_amt, fact_policy.endorse_prem_amt_ytd, fact_policy.endorse_prem_amt_itd, fact_policy.cncl_prem_amt, fact_policy.cncl_prem_amt_ytd, fact_policy.cncl_prem_amt_itd, fact_policy.rein_prem_amt_ytd, fact_policy.rein_prem_amt_itd, fact_policy.rein_prem_amt, fact_policy.fees_amt, fact_policy.fees_amt_ytd, fact_policy.fees_amt_itd, fact_policy.insuredage, fact_policy.policynewissuedind, fact_policy.policyrenewedissuedind, fact_policy.policyexpiredeffectiveind, fact_policy.policycancelledissuedind, fact_policy.policycancelledeffectiveind, fact_policy.policynonrenewalissuedind, fact_policy.policyendorsementissuedind, fact_policy.policyneworrenewal, fact_policy.source_system
   FROM fsbi_dw_spinn.fact_policy;

COMMENT ON VIEW fsbi_dw_spinn.vfact_policy IS 'Basic fact policy  information summarized at a policy level for each month';


-- fsbi_dw_spinn.vfact_policycoverage source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vfact_policycoverage
AS SELECT fact_policycoverage.factpolicycoverage_id, fact_policycoverage.primaryrisk_id, fact_policycoverage.firstinsured_id, fact_policycoverage.policy_id, fact_policycoverage.policyextension_id, fact_policycoverage.limit_id, fact_policycoverage.producer_id, fact_policycoverage.coverageeffectivedate_id, fact_policycoverage.coverageexpirationdate_id, fact_policycoverage.primaryriskgeography_id, fact_policycoverage.primaryriskaddress_id, fact_policycoverage.policyeffectivedate_id, fact_policycoverage.policyexpirationdate_id, fact_policycoverage.coverage_id, fact_policycoverage.deductible_id, fact_policycoverage.primaryriskterritory_id, fact_policycoverage.month_id, fact_policycoverage.product_id, fact_policycoverage.class_id, fact_policycoverage.policymasterterritory_id, fact_policycoverage.policystatus_id, fact_policycoverage.company_id, fact_policycoverage.comm_amt, fact_policycoverage.comm_amt_ytd, fact_policycoverage.comm_amt_itd, fact_policycoverage.wrtn_prem_amt, fact_policycoverage.wrtn_prem_amt_ytd, fact_policycoverage.wrtn_prem_amt_itd, fact_policycoverage.gross_wrtn_prem_amt, fact_policycoverage.gross_wrtn_prem_amt_ytd, fact_policycoverage.gross_wrtn_prem_amt_itd, fact_policycoverage.orig_wrtn_prem_amt, fact_policycoverage.orig_wrtn_prem_amt_ytd, fact_policycoverage.orig_wrtn_prem_amt_itd, fact_policycoverage.term_prem_amt, fact_policycoverage.term_prem_amt_ytd, fact_policycoverage.term_prem_amt_itd, fact_policycoverage.earned_prem_amt, fact_policycoverage.earned_prem_amt_ytd, fact_policycoverage.earned_prem_amt_itd, fact_policycoverage.unearned_prem, fact_policycoverage.gross_earned_prem_amt, fact_policycoverage.gross_earned_prem_amt_ytd, fact_policycoverage.gross_earned_prem_amt_itd, fact_policycoverage.endorse_prem_amt, fact_policycoverage.endorse_prem_amt_ytd, fact_policycoverage.endorse_prem_amt_itd, fact_policycoverage.cncl_prem_amt, fact_policycoverage.cncl_prem_amt_ytd, fact_policycoverage.cncl_prem_amt_itd, fact_policycoverage.rein_prem_amt_ytd, fact_policycoverage.rein_prem_amt_itd, fact_policycoverage.rein_prem_amt, fact_policycoverage.fees_amt, fact_policycoverage.fees_amt_ytd, fact_policycoverage.fees_amt_itd, fact_policycoverage.insuredage, fact_policycoverage.policynewissuedind, fact_policycoverage.policyrenewedissuedind, fact_policycoverage.policycancelledissuedind, fact_policycoverage.policynonrenewalissuedind, fact_policycoverage.policyendorsementissuedind, fact_policycoverage.source_system, fact_policycoverage.vehicle_id, fact_policycoverage.driver_id, fact_policycoverage.building_id, fact_policycoverage.location_id, fact_policycoverage.month_vehicle_id, fact_policycoverage.month_driver_id, fact_policycoverage.month_building_id, fact_policycoverage.month_location_id
   FROM fsbi_dw_spinn.fact_policycoverage;

COMMENT ON VIEW fsbi_dw_spinn.vfact_policycoverage IS 'Basic fact policycoverage  information summarized at a policy and coverage level for each month';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.comm_amt IS 'Month-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.comm_amt_ytd IS 'Year-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.comm_amt_itd IS 'Inception-to-date producer commission amount';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.wrtn_prem_amt IS 'Month-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.wrtn_prem_amt_ytd IS 'Year-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.wrtn_prem_amt_itd IS 'Inception-to-date written premium amount for this coverage. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.gross_wrtn_prem_amt IS 'Month-to-date gross written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.gross_wrtn_prem_amt_ytd IS 'Month-to-date written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.gross_wrtn_prem_amt_itd IS 'Month-to-date written premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.orig_wrtn_prem_amt IS 'Premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.orig_wrtn_prem_amt_ytd IS 'Year-to-date premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.orig_wrtn_prem_amt_itd IS 'Inception-to-date premium written for the policy when it was issued (does not include endorsement/amendment or audit premium)';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.term_prem_amt IS 'Full term premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.term_prem_amt_ytd IS 'Year-to-date full term premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.term_prem_amt_itd IS 'Inception-to-date full term premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.earned_prem_amt IS 'Month-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.earned_prem_amt_ytd IS 'Year-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.earned_prem_amt_itd IS 'Inception-to-date earned premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.unearned_prem IS 'Amount of premium unearned (left to be earned)';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.gross_earned_prem_amt IS 'Month-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.gross_earned_prem_amt_ytd IS 'Year-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.gross_earned_prem_amt_itd IS 'Inception-to-date gross earned premium amount for this coverage.  Does not include cancellation or reinstatement premium. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.endorse_prem_amt IS 'Month-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.endorse_prem_amt_ytd IS 'Year-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.endorse_prem_amt_itd IS 'Inception-to-date endorsement premium amount';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.cncl_prem_amt IS 'Month-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.cncl_prem_amt_ytd IS 'Year-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.cncl_prem_amt_itd IS 'Inception-to-date cancellation premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.rein_prem_amt_ytd IS 'Year-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.rein_prem_amt_itd IS 'Inception-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.rein_prem_amt IS 'Month-to-date reinstated premium amount. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.fees_amt IS 'Month-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.fees_amt_ytd IS 'Year-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.fees_amt_itd IS 'Inception-to-date fees collected on a policy';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.insuredage IS 'Age of the first insured. ';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.policynewissuedind IS '"Identifies if a policy is a new policy that was *issued* for the given month and year.  Valid values are:1 = New policy issued in the month 0 = Not new in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.policyrenewedissuedind IS '"Identifies if a policy is a renewal policy that was *issued* for the given month and year.  Valid values are:1 = Renewal issued in the month 0 = Not renewed in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.policycancelledissuedind IS '"Identifies if a policy that was *issued* a cancellation for the given month and year.  Valid values are:1 = Cancellation issued  in the month 0 = Not cancelled in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.policynonrenewalissuedind IS '"Identifies if a policy was a non-renewed policy that was *issued* in the given month and year.  Valid values are:1 = Non-renewal issued in the month 0 = Not non-renewed in the month"';
COMMENT ON COLUMN fsbi_dw_spinn.vfact_policycoverage.policyendorsementissuedind IS '"Identifies if a policy had an endorsement that was *issued* for the given month and year.  Valid values are:1 = Endorsement issued in the month 0 = No endorsement issued in the month"';


-- fsbi_dw_spinn.vfact_policytransaction source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vfact_policytransaction
AS SELECT fp.policytransaction_id, fp.policytransaction_uniqueid, fp.primaryrisk_id, fp.policy_id, fp.firstinsured_id, fp.limit_id, fp.producer_id, fp.transactiondate_id, fp.accountingdate_id, fp.effectivedate_id, fp.policyeffectivedate_id, fp.policyexpirationdate_id, fp.coverageeffectivedate_id, fp.coverageexpirationdate_id, fp.primaryriskgeography_id, fp.coverage_id, fp.deductible_id, fp.product_id, fp.primaryriskterritory_id, fp.class_id, fp.policymasterterritory_id, fp.policytransactiontype_id, fp.company_id, fp.policyextension_id, fp.primaryriskaddress_id, fp.policytransactionextension_id, fp.amount, 
        CASE
            WHEN dptt.ptrans_writtenprem::text = '+'::character varying::text THEN fp.amount
            ELSE 0::numeric::numeric(18,0)
        END AS writtenpremiumamt, 
        CASE
            WHEN dptt.ptrans_code::text = 'FS'::character varying::text AND dptt.ptrans_subcode::text = 'PF'::character varying::text THEN fp.amount
            ELSE 0::numeric::numeric(18,0)
        END AS writtenpremiumfeeamt, fp.commission_amount, fp.term_amount, fp.policyneworrenewal, fp.source_system, fp.vehicle_id, fp.driver_id, fp.building_id, fp.location_id
   FROM fsbi_dw_spinn.fact_policytransaction fp
   JOIN fsbi_dw_spinn.dim_policytransactiontype dptt ON fp.policytransactiontype_id = dptt.policytransactiontype_id;

COMMENT ON VIEW fsbi_dw_spinn.vfact_policytransaction IS 'Basic fact policytransaction view with measures for SPINN data';


-- fsbi_dw_spinn.vproperty_allcov source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vproperty_allcov
AS SELECT f.modeldata_id, f.systemidstart, f.systemidend, pgdate_part('year'::text, f.startdate::timestamp without time zone)::integer AS cal_year, f.startdate, f.enddate, f.startdatetm, f.enddatetm, date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25 AS ecy, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.cova_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25) AS cova_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covb_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25) AS covb_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covc_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25) AS covc_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covd_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25) AS covd_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.cove_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25) AS cove_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covf_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, f.enddate::timestamp without time zone)::numeric / 365.25) AS covf_ep, p.pol_policynumber AS policynumber, f.policy_uniqueid, pe.inceptiondt, p.pol_policynumbersuffix AS policyterm, 
        CASE
            WHEN p.pol_policynumbersuffix::text = '01'::text THEN 'New'::text
            ELSE 'Renewal'::text
        END AS policytype, p.pol_effectivedate AS effectivedate, p.pol_expirationdate AS expirationdate, p.pol_masterstate AS policystate, pe.policyformcode AS policyform, pe.persistencydiscountdt, 
        CASE
            WHEN pe.persistencydiscountdt > '1900-01-01'::date THEN (date_diff('month'::text, pe.persistencydiscountdt::timestamp without time zone, p.pol_effectivedate::timestamp without time zone) / 12)::integer
            ELSE 0
        END AS persistency, co.comp_number AS companycd, co.comp_name1 AS carriercd, pe.installmentfee, pe.nsffee, pe.latefee, pc.programind, b.employeecreditind AS cseemployeediscountind, pc.liabilitylimitolt, pc.liabilitylimitcpl, upper("replace"(pc.personalinjuryind::text, '~'::text, 'No'::text)) AS personalinjuryind, a.prdr_number AS producercode, a.prdr_name1 AS producername, a.prdr_address1 AS produceraddress, a.prdr_city AS producercity, a.prdr_state AS producerstate, a.prdr_zipcode AS producerpostalcode, a.producer_status, a.territory, f.risk_uniqueid, f.risknumber, f.risktype, b.stateprovcd AS state, b.county, b.postalcode, b.city, b.addr1, b.addr2, f.building_uniqueid, b.yearbuilt, b.sqft, b.stories, b.roofcd, 
        CASE
            WHEN f.risktype::text = 'Homeowners'::text THEN b.numberoffamilies
            ELSE b.owneroccupiedunits + b.tenantoccupiedunits
        END AS units, b.occupancycd, b.allperilded, b.waterded, b.protectionclass, b.constructioncd, b.reportedfirelineassessment, b.firehazardscore, b.reportedfirehazardscore, upper("replace"(pc.multipolicyautodiscount::text, '~'::text, 'No'::text)) AS multipolicyind, pc.multipolicyautonumber AS multipolicynumber, upper("replace"(pc.multipolicyumbrelladiscount::text, '~'::text, 'No'::text)) AS multipolicyindumbrella, pc.umbrellarelatedpolicynumber AS multipolicynumberumbrella, upper("replace"(b.earthquakeumbrellaind::text, '~'::text, 'No'::text)) AS earthquakeumbrellaind, b.usagetype, b.covaddrr_secondaryresidence AS secondaryresidence, b.ordinanceorlawpct, b.functionalreplacementcost, upper("replace"(b.homegardcreditind::text, '~'::text, 'No'::text)) AS homegardcreditind, upper("replace"(b.sprinklersystem::text, '~'::text, 'No'::text)) AS sprinklersystem, upper("replace"(pc.landlordind::text, '~'::text, 'No'::text)) AS landlordind, upper("replace"(b.cseagent::text, '~'::text, 'No'::text)) AS cseagent, upper("replace"(b.rentersinsurance::text, '~'::text, 'No'::text)) AS rentersinsurance, upper("replace"(b.firealarmtype::text, '~'::text, 'No'::text)) AS firealarmtype, upper("replace"(b.burglaryalarmtype::text, '~'::text, 'No'::text)) AS burglaryalarmtype, upper("replace"(b.waterdetectiondevice::text, '~'::text, 'No'::text)) AS waterdetectiondevice, upper("replace"(b.neighborhoodcrimewatchind::text, '~'::text, 'No'::text)) AS neighborhoodcrimewatchind, upper("replace"(b.propertymanager::text, '~'::text, 'No'::text)) AS propertymanager, upper("replace"(b.safeguardplusind::text, '~'::text, 'No'::text)) AS safeguardplusind, upper("replace"(b.hodeluxe::text, '~'::text, 'No'::text)) AS deluxepackageind, b.ratingtier, b.wuiclass, upper("replace"(b.kitchenfireextinguisherind::text, '~'::text, 'No'::text)) AS kitchenfireextinguisherind, upper("replace"(b.smokedetector::text, '~'::text, 'No'::text)) AS smokedetector, upper("replace"(b.gatedcommunityind::text, '~'::text, 'No'::text)) AS gatedcommunityind, upper("replace"(b.deadboltind::text, '~'::text, 'No'::text)) AS deadboltind, upper("replace"(b.poolind::text, '~'::text, 'No'::text)) AS poolind, upper("replace"(b.replacementcostdwellingind::text, '~'::text, 'No'::text)) AS replacementcostdwellingind, upper("replace"(b.replacementvalueind::text, '~'::text, 'No'::text)) AS replacementvalueind, upper("replace"(b.serviceline::text, '~'::text, 'No'::text)) AS serviceline, upper("replace"(b.equipmentbreakdown::text, '~'::text, 'No'::text)) AS equipmentbreakdown, upper("replace"(b.tenantevictions::text, '~'::text, 'No'::text)) AS tenantevictions, b.lossassessment, b.numberoffamilies, "substring"(i.fullname::text, 1, charindex(' '::text, i.fullname::text)) AS insuredfirstname, "substring"(i.fullname::text, charindex(' '::text, i.fullname::text) + 1, len(i.fullname::text)) AS insuredlastname, 
        CASE
            WHEN i.dob = '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::timestamp without time zone
            ELSE i.dob
        END AS insureddob, 
        CASE
            WHEN i.dob = '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::bigint
            ELSE date_diff('y'::text, i.dob, p.pol_effectivedate::timestamp without time zone)
        END AS insuredage, i.maritalstatus, i.insurancescore, i.overriddeninsurancescore, i.insurancescorevalue, i.ratepageeffectivedt, i.insscoretiervalueband, i.applieddt, i.financialstabilitytier, f.allcov_wp, f.allcov_lossinc, f.allcov_lossdcce, f.allcov_lossalae, f.cova_wp, f.covb_wp, f.covc_wp, f.covd_wp, f.cove_wp, f.covf_wp, f.cova_deductible, f.covb_deductible, f.covc_deductible, f.covd_deductible, f.cove_deductible, f.covf_deductible, f.cova_limit, f.covb_limit, f.covc_limit, b.covclimit AS covcincreasedlimit, f.covd_limit, f.cove_limit, f.covf_limit, f.onpremises_theft_limit, f.awayfrompremises_theft_limit, f.quality_polappinconsistency_flg, f.quality_riskidduplicates_flg, f.quality_claimok_flg, f.quality_claimpolicytermjoin_flg, f.covabcdefliab_loss, f.covabcdefliab_claim_count, f.cat_covabcdefliab_loss, f.cat_covabcdefliab_claim_count, f.cova_il_nc_water, f.cova_il_nc_wh, f.cova_il_nc_tv, f.cova_il_nc_fl, f.cova_il_nc_ao, f.cova_il_cat_fire, f.cova_il_cat_ao, f.covb_il_nc_water, f.covb_il_nc_wh, f.covb_il_nc_tv, f.covb_il_nc_fl, f.covb_il_nc_ao, f.covb_il_cat_fire, f.covb_il_cat_ao, f.covc_il_nc_water, f.covc_il_nc_wh, f.covc_il_nc_tv, f.covc_il_nc_fl, f.covc_il_nc_ao, f.covc_il_cat_fire, f.covc_il_cat_ao, f.covd_il_nc_water, f.covd_il_nc_wh, f.covd_il_nc_tv, f.covd_il_nc_fl, f.covd_il_nc_ao, f.covd_il_cat_fire, f.covd_il_cat_ao, f.cove_il_nc_water, f.cove_il_nc_wh, f.cove_il_nc_tv, f.cove_il_nc_fl, f.cove_il_nc_ao, f.cove_il_cat_fire, f.cove_il_cat_ao, f.covf_il_nc_water, f.covf_il_nc_wh, f.covf_il_nc_tv, f.covf_il_nc_fl, f.covf_il_nc_ao, f.covf_il_cat_fire, f.covf_il_cat_ao, f.liab_il_nc_water, f.liab_il_nc_wh, f.liab_il_nc_tv, f.liab_il_nc_fl, f.liab_il_nc_ao, f.liab_il_cat_fire, f.liab_il_cat_ao, f.cova_il_dcce_nc_water, f.cova_il_dcce_nc_wh, f.cova_il_dcce_nc_tv, f.cova_il_dcce_nc_fl, f.cova_il_dcce_nc_ao, f.cova_il_dcce_cat_fire, f.cova_il_dcce_cat_ao, f.covb_il_dcce_nc_water, f.covb_il_dcce_nc_wh, f.covb_il_dcce_nc_tv, f.covb_il_dcce_nc_fl, f.covb_il_dcce_nc_ao, f.covb_il_dcce_cat_fire, f.covb_il_dcce_cat_ao, f.covc_il_dcce_nc_water, f.covc_il_dcce_nc_wh, f.covc_il_dcce_nc_tv, f.covc_il_dcce_nc_fl, f.covc_il_dcce_nc_ao, f.covc_il_dcce_cat_fire, f.covc_il_dcce_cat_ao, f.covd_il_dcce_nc_water, f.covd_il_dcce_nc_wh, f.covd_il_dcce_nc_tv, f.covd_il_dcce_nc_fl, f.covd_il_dcce_nc_ao, f.covd_il_dcce_cat_fire, f.covd_il_dcce_cat_ao, f.cove_il_dcce_nc_water, f.cove_il_dcce_nc_wh, f.cove_il_dcce_nc_tv, f.cove_il_dcce_nc_fl, f.cove_il_dcce_nc_ao, f.cove_il_dcce_cat_fire, f.cove_il_dcce_cat_ao, f.covf_il_dcce_nc_water, f.covf_il_dcce_nc_wh, f.covf_il_dcce_nc_tv, f.covf_il_dcce_nc_fl, f.covf_il_dcce_nc_ao, f.covf_il_dcce_cat_fire, f.covf_il_dcce_cat_ao, f.liab_il_dcce_nc_water, f.liab_il_dcce_nc_wh, f.liab_il_dcce_nc_tv, f.liab_il_dcce_nc_fl, f.liab_il_dcce_nc_ao, f.liab_il_dcce_cat_fire, f.liab_il_dcce_cat_ao, f.cova_il_alae_nc_water, f.cova_il_alae_nc_wh, f.cova_il_alae_nc_tv, f.cova_il_alae_nc_fl, f.cova_il_alae_nc_ao, f.cova_il_alae_cat_fire, f.cova_il_alae_cat_ao, f.covb_il_alae_nc_water, f.covb_il_alae_nc_wh, f.covb_il_alae_nc_tv, f.covb_il_alae_nc_fl, f.covb_il_alae_nc_ao, f.covb_il_alae_cat_fire, f.covb_il_alae_cat_ao, f.covc_il_alae_nc_water, f.covc_il_alae_nc_wh, f.covc_il_alae_nc_tv, f.covc_il_alae_nc_fl, f.covc_il_alae_nc_ao, f.covc_il_alae_cat_fire, f.covc_il_alae_cat_ao, f.covd_il_alae_nc_water, f.covd_il_alae_nc_wh, f.covd_il_alae_nc_tv, f.covd_il_alae_nc_fl, f.covd_il_alae_nc_ao, f.covd_il_alae_cat_fire, f.covd_il_alae_cat_ao, f.cove_il_alae_nc_water, f.cove_il_alae_nc_wh, f.cove_il_alae_nc_tv, f.cove_il_alae_nc_fl, f.cove_il_alae_nc_ao, f.cove_il_alae_cat_fire, f.cove_il_alae_cat_ao, f.covf_il_alae_nc_water, f.covf_il_alae_nc_wh, f.covf_il_alae_nc_tv, f.covf_il_alae_nc_fl, f.covf_il_alae_nc_ao, f.covf_il_alae_cat_fire, f.covf_il_alae_cat_ao, f.liab_il_alae_nc_water, f.liab_il_alae_nc_wh, f.liab_il_alae_nc_tv, f.liab_il_alae_nc_fl, f.liab_il_alae_nc_ao, f.liab_il_alae_cat_fire, f.liab_il_alae_cat_ao, f.cova_ic_nc_water, f.cova_ic_nc_wh, f.cova_ic_nc_tv, f.cova_ic_nc_fl, f.cova_ic_nc_ao, f.cova_ic_cat_fire, f.cova_ic_cat_ao, f.covb_ic_nc_water, f.covb_ic_nc_wh, f.covb_ic_nc_tv, f.covb_ic_nc_fl, f.covb_ic_nc_ao, f.covb_ic_cat_fire, f.covb_ic_cat_ao, f.covc_ic_nc_water, f.covc_ic_nc_wh, f.covc_ic_nc_tv, f.covc_ic_nc_fl, f.covc_ic_nc_ao, f.covc_ic_cat_fire, f.covc_ic_cat_ao, f.covd_ic_nc_water, f.covd_ic_nc_wh, f.covd_ic_nc_tv, f.covd_ic_nc_fl, f.covd_ic_nc_ao, f.covd_ic_cat_fire, f.covd_ic_cat_ao, f.cove_ic_nc_water, f.cove_ic_nc_wh, f.cove_ic_nc_tv, f.cove_ic_nc_fl, f.cove_ic_nc_ao, f.cove_ic_cat_fire, f.cove_ic_cat_ao, f.covf_ic_nc_water, f.covf_ic_nc_wh, f.covf_ic_nc_tv, f.covf_ic_nc_fl, f.covf_ic_nc_ao, f.covf_ic_cat_fire, f.covf_ic_cat_ao, f.liab_ic_nc_water, f.liab_ic_nc_wh, f.liab_ic_nc_tv, f.liab_ic_nc_fl, f.liab_ic_nc_ao, f.liab_ic_cat_fire, f.liab_ic_cat_ao, f.cova_ic_dcce_nc_water, f.cova_ic_dcce_nc_wh, f.cova_ic_dcce_nc_tv, f.cova_ic_dcce_nc_fl, f.cova_ic_dcce_nc_ao, f.cova_ic_dcce_cat_fire, f.cova_ic_dcce_cat_ao, f.covb_ic_dcce_nc_water, f.covb_ic_dcce_nc_wh, f.covb_ic_dcce_nc_tv, f.covb_ic_dcce_nc_fl, f.covb_ic_dcce_nc_ao, f.covb_ic_dcce_cat_fire, f.covb_ic_dcce_cat_ao, f.covc_ic_dcce_nc_water, f.covc_ic_dcce_nc_wh, f.covc_ic_dcce_nc_tv, f.covc_ic_dcce_nc_fl, f.covc_ic_dcce_nc_ao, f.covc_ic_dcce_cat_fire, f.covc_ic_dcce_cat_ao, f.covd_ic_dcce_nc_water, f.covd_ic_dcce_nc_wh, f.covd_ic_dcce_nc_tv, f.covd_ic_dcce_nc_fl, f.covd_ic_dcce_nc_ao, f.covd_ic_dcce_cat_fire, f.covd_ic_dcce_cat_ao, f.covf_ic_dcce_nc_water, f.covf_ic_dcce_nc_wh, f.covf_ic_dcce_nc_tv, f.covf_ic_dcce_nc_fl, f.covf_ic_dcce_nc_ao, f.covf_ic_dcce_cat_fire, f.covf_ic_dcce_cat_ao, f.liab_ic_dcce_nc_water, f.liab_ic_dcce_nc_wh, f.liab_ic_dcce_nc_tv, f.liab_ic_dcce_nc_fl, f.liab_ic_dcce_nc_ao, f.liab_ic_dcce_cat_fire, f.liab_ic_dcce_cat_ao, f.cova_ic_alae_nc_water, f.cova_ic_alae_nc_wh, f.cova_ic_alae_nc_tv, f.cova_ic_alae_nc_fl, f.cova_ic_alae_nc_ao, f.cova_ic_alae_cat_fire, f.cova_ic_alae_cat_ao, f.covb_ic_alae_nc_water, f.covb_ic_alae_nc_wh, f.covb_ic_alae_nc_tv, f.covb_ic_alae_nc_fl, f.covb_ic_alae_nc_ao, f.covb_ic_alae_cat_fire, f.covb_ic_alae_cat_ao, f.covc_ic_alae_nc_water, f.covc_ic_alae_nc_wh, f.covc_ic_alae_nc_tv, f.covc_ic_alae_nc_fl, f.covc_ic_alae_nc_ao, f.covc_ic_alae_cat_fire, f.covc_ic_alae_cat_ao, f.covd_ic_alae_nc_water, f.covd_ic_alae_nc_wh, f.covd_ic_alae_nc_tv, f.covd_ic_alae_nc_fl, f.covd_ic_alae_nc_ao, f.covd_ic_alae_cat_fire, f.covd_ic_alae_cat_ao, f.cove_ic_alae_nc_water, f.cove_ic_alae_nc_wh, f.cove_ic_alae_nc_tv, f.cove_ic_alae_nc_fl, f.cove_ic_alae_nc_ao, f.cove_ic_alae_cat_fire, f.cove_ic_alae_cat_ao, f.covf_ic_alae_nc_water, f.covf_ic_alae_nc_wh, f.covf_ic_alae_nc_tv, f.covf_ic_alae_nc_fl, f.covf_ic_alae_nc_ao, f.covf_ic_alae_cat_fire, f.covf_ic_alae_cat_ao, f.liab_ic_alae_nc_water, f.liab_ic_alae_nc_wh, f.liab_ic_alae_nc_tv, f.liab_ic_alae_nc_fl, f.liab_ic_alae_nc_ao, f.liab_ic_alae_cat_fire, f.liab_ic_alae_cat_ao, f.cova_fl, f.cova_sf, f.cova_ec, f.covc_fl, f.covc_sf, f.covc_ec, f.loaddate
   FROM fsbi_dw_spinn.fact_property_modeldata f
   JOIN fsbi_dw_spinn.dim_policy p ON f.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.dim_building b ON f.policy_id = b.policy_id AND f.building_id = b.building_id
   JOIN fsbi_dw_spinn.vdim_producer a ON f.producer_id = a.producer_id
   JOIN fsbi_dw_spinn.dim_policyextension pe ON f.policy_id = pe.policy_id
   JOIN fsbi_dw_spinn.dim_insured i ON f.policy_id = i.policy_id
   JOIN fsbi_dw_spinn.vdim_company co ON p.company_id = co.company_id
   JOIN fsbi_dw_spinn.dim_policy_changes pc ON f.policy_changes_id = pc.policy_changes_id AND f.policy_id = pc.policy_id;

COMMENT ON VIEW fsbi_dw_spinn.vproperty_allcov IS 'The same as Property Modeling data but without 3 months limitations on exposures. However theer are no losses for the recent 3 months';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.modeldata_id IS 'Mid-Term change unique identifier. It''s repeated for different coverages in the same mid-term change. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.systemidstart IS 'Exact mid-term start SystemId from Application';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.systemidend IS 'Exact mid-term end SystemId from Application';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cal_year IS ' 	cast(date_part(year, startdate) as int) 	Year of Start Date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.enddate IS ' 	case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end	Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.startdatetm IS 'Exact Mid-Term Start date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.enddatetm IS 'Exact Mid-Term End Date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.ecy IS ' 	DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovA_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovB_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovC_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovD_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovE_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovF_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.policy_uniqueid IS 'PolicyRef in PolicyStats or SystemId in any other related table';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.units IS ' 	case when risktype=''Homeowners'' then NumberOfFamilies else OwnerOccupiedUnits + TenantOccupiedUnits end';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.multipolicyind IS ' 	upper(replace(pc.MultiPolicyAutoDiscount,''~'',''No''))	It''s based on 2 different fields from Building table: MultiPolicyInd (Safeguard) and AutoHomeInd (ICO products). They are the same discount (if there is an auto policy) but for different products';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.multipolicynumber IS ' 	pc.MultiPolicyAutoNumber	It''s based on 2 different fields from Building table: MultiPolicyNumber (Safeguard) and otherpolicynumber1 (ICO products). They are the same discount (if there is an auto policy) but for different products';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.multipolicyindumbrella IS ' 	upper(replace(pc.MultiPolicyUmbrellaDiscount,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.multipolicynumberumbrella IS ' 	pc.UmbrellaRelatedPolicyNumber';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.earthquakeumbrellaind IS ' 	upper(replace(earthquakeumbrellaind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.homegardcreditind IS ' 	upper(replace(homegardcreditind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.sprinklersystem IS ' 	upper(replace(sprinklersystem,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.landlordind IS ' 	upper(replace(pc.landlordind,''~'',''No'')) 	Discount if there is more then 1 Landlord policy per customer';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cseagent IS ' 	upper(replace(cseagent,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.rentersinsurance IS ' 	upper(replace(rentersinsurance,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.firealarmtype IS ' 	upper(replace(FireAlarmType,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.burglaryalarmtype IS ' 	upper(replace(BurglaryAlarmType,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.waterdetectiondevice IS ' 	upper(replace(WaterDetectionDevice,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.neighborhoodcrimewatchind IS ' 	upper(replace(NeighborhoodCrimeWatchInd,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.propertymanager IS ' 	upper(replace(PropertyManager,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.safeguardplusind IS ' 	upper(replace(SafeguardPlusInd,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.deluxepackageind IS ' 	upper(replace(HODeluxe,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.kitchenfireextinguisherind IS ' 	upper(replace(kitchenfireextinguisherind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.smokedetector IS ' 	 upper(replace(smokedetector,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.gatedcommunityind IS ' 	upper(replace(gatedcommunityind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.deadboltind IS ' 	upper(replace(deadboltind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.poolind IS ' 	upper(replace(poolind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.replacementcostdwellingind IS ' 	upper(replace(ReplacementCostDwellingInd,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.replacementvalueind IS ' 	upper(replace(replacementvalueind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.serviceline IS ' 	upper(replace(serviceline,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.equipmentbreakdown IS ' 	upper(replace(equipmentbreakdown,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.tenantevictions IS ' 	upper(replace(tenantevictions,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.allcov_wp IS ' 	Total Policy WP 	including discounts but not fees. Total from Coverage List in SPINN UI Dwelling ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.allcov_lossinc IS ' 	Total for all coverages Paid and Incurred Losses 	See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.allcov_lossdcce IS ' 	Total for all coverages DCCE	Only DCCE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.allcov_lossalae IS ' 	Total for all coverages ALAE	Only ALAE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covcincreasedlimit IS 'CSE decided to price it in two step: a basic limit + anything above that basic limit so they created two coverage codes (PP and INCC) but what CSE would pay under that coverage is really the sum of both. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.quality_polappinconsistency_flg IS 'Sometimes the latest known policy state is different from latest application data due to manual updates. I try to use "policy" instead of "aplication" data';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.quality_riskidduplicates_flg IS 'Different risks have the same number in SPINN. SPINN issue. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.quality_claimok_flg IS 'Claim is joined without an issue';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.quality_claimpolicytermjoin_flg IS 'There is an issue joining a claim to a specific mid-term change because of cancellations. It''s joined to a first mid-term change (record) per policy term.  In many cases there is just one record per policy term in homeowners policies. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covabcdefliab_loss IS ' 	Total Coverage A thru LIAB groups Paid and Incurred Loss';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cat_covabcdefliab_loss IS ' 	Catastrophe Total Coverage A thru LIAB groups  Paid and Incurred Loss';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cat_covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cova_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covb_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covc_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covd_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.cove_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.covf_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.liab_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_allcov.loaddate IS 'Data last refresh date';


-- fsbi_dw_spinn.vproperty_modeldata_allcov source

CREATE OR REPLACE VIEW fsbi_dw_spinn.vproperty_modeldata_allcov
AS SELECT f.modeldata_id, f.systemidstart, f.systemidend, pgdate_part('year'::text, f.startdate::timestamp without time zone)::integer AS cal_year, f.startdate, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END AS enddate, f.startdatetm, f.enddatetm, date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25 AS ehy, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.cova_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS cova_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covb_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS covb_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covc_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS covc_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covd_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS covd_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.cove_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS cove_ep, 
        CASE
            WHEN pe.renewaltermcd::text = '1 Year'::text THEN 1
            ELSE 2
        END::numeric * f.covf_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS covf_ep, p.pol_policynumber AS policynumber, f.policy_uniqueid, pe.inceptiondt, p.pol_policynumbersuffix AS policyterm, 
        CASE
            WHEN p.pol_policynumbersuffix::text = '01'::text THEN 'New'::text
            ELSE 'Renewal'::text
        END AS policytype, p.pol_effectivedate AS effectivedate, p.pol_expirationdate AS expirationdate, p.pol_masterstate AS policystate, pe.policyformcode AS policyform, pe.persistencydiscountdt, 
        CASE
            WHEN pe.persistencydiscountdt > '1900-01-01'::date THEN (date_diff('month'::text, pe.persistencydiscountdt::timestamp without time zone, p.pol_effectivedate::timestamp without time zone) / 12)::integer
            ELSE 0
        END AS persistency, co.comp_number AS companycd, co.comp_name1 AS carriercd, pe.installmentfee, pe.nsffee, pe.latefee, pc.programind, b.employeecreditind AS cseemployeediscountind, pc.liabilitylimitolt, pc.liabilitylimitcpl, upper("replace"(pc.personalinjuryind::text, '~'::text, 'No'::text)) AS personalinjuryind, a.prdr_number AS producercode, a.prdr_name1 AS producername, a.prdr_address1 AS produceraddress, a.prdr_city AS producercity, a.prdr_state AS producerstate, a.prdr_zipcode AS producerpostalcode, a.producer_status, a.territory, f.risk_uniqueid, f.risknumber, f.risktype, b.stateprovcd AS state, b.county, b.postalcode, b.city, b.addr1, b.addr2, f.building_uniqueid, b.yearbuilt, b.sqft, b.stories, b.roofcd, 
        CASE
            WHEN f.risktype::text = 'Homeowners'::text THEN b.numberoffamilies
            ELSE b.owneroccupiedunits + b.tenantoccupiedunits
        END AS units, b.occupancycd, b.allperilded, b.waterded, b.protectionclass, b.constructioncd, b.reportedfirelineassessment, b.firehazardscore, b.reportedfirehazardscore, upper("replace"(pc.multipolicyautodiscount::text, '~'::text, 'No'::text)) AS multipolicyind, pc.multipolicyautonumber AS multipolicynumber, upper("replace"(pc.multipolicyumbrelladiscount::text, '~'::text, 'No'::text)) AS multipolicyindumbrella, pc.umbrellarelatedpolicynumber AS multipolicynumberumbrella, upper("replace"(b.earthquakeumbrellaind::text, '~'::text, 'No'::text)) AS earthquakeumbrellaind, b.usagetype, b.covaddrr_secondaryresidence AS secondaryresidence, b.ordinanceorlawpct, b.functionalreplacementcost, upper("replace"(b.homegardcreditind::text, '~'::text, 'No'::text)) AS homegardcreditind, upper("replace"(b.sprinklersystem::text, '~'::text, 'No'::text)) AS sprinklersystem, upper("replace"(pc.landlordind::text, '~'::text, 'No'::text)) AS landlordind, upper("replace"(b.cseagent::text, '~'::text, 'No'::text)) AS cseagent, upper("replace"(b.rentersinsurance::text, '~'::text, 'No'::text)) AS rentersinsurance, upper("replace"(b.firealarmtype::text, '~'::text, 'No'::text)) AS firealarmtype, upper("replace"(b.burglaryalarmtype::text, '~'::text, 'No'::text)) AS burglaryalarmtype, upper("replace"(b.waterdetectiondevice::text, '~'::text, 'No'::text)) AS waterdetectiondevice, upper("replace"(b.neighborhoodcrimewatchind::text, '~'::text, 'No'::text)) AS neighborhoodcrimewatchind, upper("replace"(b.propertymanager::text, '~'::text, 'No'::text)) AS propertymanager, upper("replace"(b.safeguardplusind::text, '~'::text, 'No'::text)) AS safeguardplusind, upper("replace"(b.hodeluxe::text, '~'::text, 'No'::text)) AS deluxepackageind, b.ratingtier, b.wuiclass, upper("replace"(b.kitchenfireextinguisherind::text, '~'::text, 'No'::text)) AS kitchenfireextinguisherind, upper("replace"(b.smokedetector::text, '~'::text, 'No'::text)) AS smokedetector, upper("replace"(b.gatedcommunityind::text, '~'::text, 'No'::text)) AS gatedcommunityind, upper("replace"(b.deadboltind::text, '~'::text, 'No'::text)) AS deadboltind, upper("replace"(b.poolind::text, '~'::text, 'No'::text)) AS poolind, upper("replace"(b.replacementcostdwellingind::text, '~'::text, 'No'::text)) AS replacementcostdwellingind, upper("replace"(b.replacementvalueind::text, '~'::text, 'No'::text)) AS replacementvalueind, upper("replace"(b.serviceline::text, '~'::text, 'No'::text)) AS serviceline, upper("replace"(b.equipmentbreakdown::text, '~'::text, 'No'::text)) AS equipmentbreakdown, upper("replace"(b.tenantevictions::text, '~'::text, 'No'::text)) AS tenantevictions, b.lossassessment, b.numberoffamilies, "substring"(i.fullname::text, 1, charindex(' '::text, i.fullname::text)) AS insuredfirstname, "substring"(i.fullname::text, charindex(' '::text, i.fullname::text) + 1, len(i.fullname::text)) AS insuredlastname, 
        CASE
            WHEN i.dob = '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::timestamp without time zone
            ELSE i.dob
        END AS insureddob, 
        CASE
            WHEN i.dob = '1900-01-01 00:00:00'::timestamp without time zone THEN NULL::bigint
            ELSE date_diff('y'::text, i.dob, p.pol_effectivedate::timestamp without time zone)
        END AS insuredage, i.maritalstatus, i.insurancescore, i.overriddeninsurancescore, i.insurancescorevalue, i.ratepageeffectivedt, i.insscoretiervalueband, i.applieddt, i.financialstabilitytier, f.allcov_wp, f.allcov_lossinc, f.allcov_lossdcce, f.allcov_lossalae, f.cova_wp, f.covb_wp, f.covc_wp, f.covd_wp, f.cove_wp, f.covf_wp, f.cova_deductible, f.covb_deductible, f.covc_deductible, f.covd_deductible, f.cove_deductible, f.covf_deductible, f.cova_limit, f.covb_limit, f.covc_limit, b.covclimit AS covcincreasedlimit, f.covd_limit, f.cove_limit, f.covf_limit, f.onpremises_theft_limit, f.awayfrompremises_theft_limit, f.quality_polappinconsistency_flg, f.quality_riskidduplicates_flg, f.quality_claimok_flg, f.quality_claimpolicytermjoin_flg, f.covabcdefliab_loss, f.covabcdefliab_claim_count, f.cat_covabcdefliab_loss, f.cat_covabcdefliab_claim_count, f.cova_il_nc_water, f.cova_il_nc_wh, f.cova_il_nc_tv, f.cova_il_nc_fl, f.cova_il_nc_ao, f.cova_il_cat_fire, f.cova_il_cat_ao, f.covb_il_nc_water, f.covb_il_nc_wh, f.covb_il_nc_tv, f.covb_il_nc_fl, f.covb_il_nc_ao, f.covb_il_cat_fire, f.covb_il_cat_ao, f.covc_il_nc_water, f.covc_il_nc_wh, f.covc_il_nc_tv, f.covc_il_nc_fl, f.covc_il_nc_ao, f.covc_il_cat_fire, f.covc_il_cat_ao, f.covd_il_nc_water, f.covd_il_nc_wh, f.covd_il_nc_tv, f.covd_il_nc_fl, f.covd_il_nc_ao, f.covd_il_cat_fire, f.covd_il_cat_ao, f.cove_il_nc_water, f.cove_il_nc_wh, f.cove_il_nc_tv, f.cove_il_nc_fl, f.cove_il_nc_ao, f.cove_il_cat_fire, f.cove_il_cat_ao, f.covf_il_nc_water, f.covf_il_nc_wh, f.covf_il_nc_tv, f.covf_il_nc_fl, f.covf_il_nc_ao, f.covf_il_cat_fire, f.covf_il_cat_ao, f.liab_il_nc_water, f.liab_il_nc_wh, f.liab_il_nc_tv, f.liab_il_nc_fl, f.liab_il_nc_ao, f.liab_il_cat_fire, f.liab_il_cat_ao, f.cova_il_dcce_nc_water, f.cova_il_dcce_nc_wh, f.cova_il_dcce_nc_tv, f.cova_il_dcce_nc_fl, f.cova_il_dcce_nc_ao, f.cova_il_dcce_cat_fire, f.cova_il_dcce_cat_ao, f.covb_il_dcce_nc_water, f.covb_il_dcce_nc_wh, f.covb_il_dcce_nc_tv, f.covb_il_dcce_nc_fl, f.covb_il_dcce_nc_ao, f.covb_il_dcce_cat_fire, f.covb_il_dcce_cat_ao, f.covc_il_dcce_nc_water, f.covc_il_dcce_nc_wh, f.covc_il_dcce_nc_tv, f.covc_il_dcce_nc_fl, f.covc_il_dcce_nc_ao, f.covc_il_dcce_cat_fire, f.covc_il_dcce_cat_ao, f.covd_il_dcce_nc_water, f.covd_il_dcce_nc_wh, f.covd_il_dcce_nc_tv, f.covd_il_dcce_nc_fl, f.covd_il_dcce_nc_ao, f.covd_il_dcce_cat_fire, f.covd_il_dcce_cat_ao, f.cove_il_dcce_nc_water, f.cove_il_dcce_nc_wh, f.cove_il_dcce_nc_tv, f.cove_il_dcce_nc_fl, f.cove_il_dcce_nc_ao, f.cove_il_dcce_cat_fire, f.cove_il_dcce_cat_ao, f.covf_il_dcce_nc_water, f.covf_il_dcce_nc_wh, f.covf_il_dcce_nc_tv, f.covf_il_dcce_nc_fl, f.covf_il_dcce_nc_ao, f.covf_il_dcce_cat_fire, f.covf_il_dcce_cat_ao, f.liab_il_dcce_nc_water, f.liab_il_dcce_nc_wh, f.liab_il_dcce_nc_tv, f.liab_il_dcce_nc_fl, f.liab_il_dcce_nc_ao, f.liab_il_dcce_cat_fire, f.liab_il_dcce_cat_ao, f.cova_il_alae_nc_water, f.cova_il_alae_nc_wh, f.cova_il_alae_nc_tv, f.cova_il_alae_nc_fl, f.cova_il_alae_nc_ao, f.cova_il_alae_cat_fire, f.cova_il_alae_cat_ao, f.covb_il_alae_nc_water, f.covb_il_alae_nc_wh, f.covb_il_alae_nc_tv, f.covb_il_alae_nc_fl, f.covb_il_alae_nc_ao, f.covb_il_alae_cat_fire, f.covb_il_alae_cat_ao, f.covc_il_alae_nc_water, f.covc_il_alae_nc_wh, f.covc_il_alae_nc_tv, f.covc_il_alae_nc_fl, f.covc_il_alae_nc_ao, f.covc_il_alae_cat_fire, f.covc_il_alae_cat_ao, f.covd_il_alae_nc_water, f.covd_il_alae_nc_wh, f.covd_il_alae_nc_tv, f.covd_il_alae_nc_fl, f.covd_il_alae_nc_ao, f.covd_il_alae_cat_fire, f.covd_il_alae_cat_ao, f.cove_il_alae_nc_water, f.cove_il_alae_nc_wh, f.cove_il_alae_nc_tv, f.cove_il_alae_nc_fl, f.cove_il_alae_nc_ao, f.cove_il_alae_cat_fire, f.cove_il_alae_cat_ao, f.covf_il_alae_nc_water, f.covf_il_alae_nc_wh, f.covf_il_alae_nc_tv, f.covf_il_alae_nc_fl, f.covf_il_alae_nc_ao, f.covf_il_alae_cat_fire, f.covf_il_alae_cat_ao, f.liab_il_alae_nc_water, f.liab_il_alae_nc_wh, f.liab_il_alae_nc_tv, f.liab_il_alae_nc_fl, f.liab_il_alae_nc_ao, f.liab_il_alae_cat_fire, f.liab_il_alae_cat_ao, f.cova_ic_nc_water, f.cova_ic_nc_wh, f.cova_ic_nc_tv, f.cova_ic_nc_fl, f.cova_ic_nc_ao, f.cova_ic_cat_fire, f.cova_ic_cat_ao, f.covb_ic_nc_water, f.covb_ic_nc_wh, f.covb_ic_nc_tv, f.covb_ic_nc_fl, f.covb_ic_nc_ao, f.covb_ic_cat_fire, f.covb_ic_cat_ao, f.covc_ic_nc_water, f.covc_ic_nc_wh, f.covc_ic_nc_tv, f.covc_ic_nc_fl, f.covc_ic_nc_ao, f.covc_ic_cat_fire, f.covc_ic_cat_ao, f.covd_ic_nc_water, f.covd_ic_nc_wh, f.covd_ic_nc_tv, f.covd_ic_nc_fl, f.covd_ic_nc_ao, f.covd_ic_cat_fire, f.covd_ic_cat_ao, f.cove_ic_nc_water, f.cove_ic_nc_wh, f.cove_ic_nc_tv, f.cove_ic_nc_fl, f.cove_ic_nc_ao, f.cove_ic_cat_fire, f.cove_ic_cat_ao, f.covf_ic_nc_water, f.covf_ic_nc_wh, f.covf_ic_nc_tv, f.covf_ic_nc_fl, f.covf_ic_nc_ao, f.covf_ic_cat_fire, f.covf_ic_cat_ao, f.liab_ic_nc_water, f.liab_ic_nc_wh, f.liab_ic_nc_tv, f.liab_ic_nc_fl, f.liab_ic_nc_ao, f.liab_ic_cat_fire, f.liab_ic_cat_ao, f.cova_ic_dcce_nc_water, f.cova_ic_dcce_nc_wh, f.cova_ic_dcce_nc_tv, f.cova_ic_dcce_nc_fl, f.cova_ic_dcce_nc_ao, f.cova_ic_dcce_cat_fire, f.cova_ic_dcce_cat_ao, f.covb_ic_dcce_nc_water, f.covb_ic_dcce_nc_wh, f.covb_ic_dcce_nc_tv, f.covb_ic_dcce_nc_fl, f.covb_ic_dcce_nc_ao, f.covb_ic_dcce_cat_fire, f.covb_ic_dcce_cat_ao, f.covc_ic_dcce_nc_water, f.covc_ic_dcce_nc_wh, f.covc_ic_dcce_nc_tv, f.covc_ic_dcce_nc_fl, f.covc_ic_dcce_nc_ao, f.covc_ic_dcce_cat_fire, f.covc_ic_dcce_cat_ao, f.covd_ic_dcce_nc_water, f.covd_ic_dcce_nc_wh, f.covd_ic_dcce_nc_tv, f.covd_ic_dcce_nc_fl, f.covd_ic_dcce_nc_ao, f.covd_ic_dcce_cat_fire, f.covd_ic_dcce_cat_ao, f.covf_ic_dcce_nc_water, f.covf_ic_dcce_nc_wh, f.covf_ic_dcce_nc_tv, f.covf_ic_dcce_nc_fl, f.covf_ic_dcce_nc_ao, f.covf_ic_dcce_cat_fire, f.covf_ic_dcce_cat_ao, f.liab_ic_dcce_nc_water, f.liab_ic_dcce_nc_wh, f.liab_ic_dcce_nc_tv, f.liab_ic_dcce_nc_fl, f.liab_ic_dcce_nc_ao, f.liab_ic_dcce_cat_fire, f.liab_ic_dcce_cat_ao, f.cova_ic_alae_nc_water, f.cova_ic_alae_nc_wh, f.cova_ic_alae_nc_tv, f.cova_ic_alae_nc_fl, f.cova_ic_alae_nc_ao, f.cova_ic_alae_cat_fire, f.cova_ic_alae_cat_ao, f.covb_ic_alae_nc_water, f.covb_ic_alae_nc_wh, f.covb_ic_alae_nc_tv, f.covb_ic_alae_nc_fl, f.covb_ic_alae_nc_ao, f.covb_ic_alae_cat_fire, f.covb_ic_alae_cat_ao, f.covc_ic_alae_nc_water, f.covc_ic_alae_nc_wh, f.covc_ic_alae_nc_tv, f.covc_ic_alae_nc_fl, f.covc_ic_alae_nc_ao, f.covc_ic_alae_cat_fire, f.covc_ic_alae_cat_ao, f.covd_ic_alae_nc_water, f.covd_ic_alae_nc_wh, f.covd_ic_alae_nc_tv, f.covd_ic_alae_nc_fl, f.covd_ic_alae_nc_ao, f.covd_ic_alae_cat_fire, f.covd_ic_alae_cat_ao, f.cove_ic_alae_nc_water, f.cove_ic_alae_nc_wh, f.cove_ic_alae_nc_tv, f.cove_ic_alae_nc_fl, f.cove_ic_alae_nc_ao, f.cove_ic_alae_cat_fire, f.cove_ic_alae_cat_ao, f.covf_ic_alae_nc_water, f.covf_ic_alae_nc_wh, f.covf_ic_alae_nc_tv, f.covf_ic_alae_nc_fl, f.covf_ic_alae_nc_ao, f.covf_ic_alae_cat_fire, f.covf_ic_alae_cat_ao, f.liab_ic_alae_nc_water, f.liab_ic_alae_nc_wh, f.liab_ic_alae_nc_tv, f.liab_ic_alae_nc_fl, f.liab_ic_alae_nc_ao, f.liab_ic_alae_cat_fire, f.liab_ic_alae_cat_ao, f.cova_fl, f.cova_sf, f.cova_ec, f.covc_fl, f.covc_sf, f.covc_ec, f.loaddate, f.allcov_wp * (date_diff('d'::text, f.startdate::timestamp without time zone, 
        CASE
            WHEN f.enddate > date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone) THEN date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone)
            ELSE f.enddate::timestamp without time zone
        END)::numeric / 365.25) AS allcov_ep
   FROM fsbi_dw_spinn.fact_property_modeldata f
   JOIN fsbi_dw_spinn.dim_policy p ON f.policy_id = p.policy_id
   JOIN fsbi_dw_spinn.dim_building b ON f.policy_id = b.policy_id AND f.building_id = b.building_id
   JOIN fsbi_dw_spinn.vdim_producer a ON f.producer_id = a.producer_id
   JOIN fsbi_dw_spinn.dim_policyextension pe ON f.policy_id = pe.policy_id
   JOIN fsbi_dw_spinn.dim_insured i ON f.policy_id = i.policy_id
   JOIN fsbi_dw_spinn.vdim_company co ON p.company_id = co.company_id
   JOIN fsbi_dw_spinn.dim_policy_changes pc ON f.policy_changes_id = pc.policy_changes_id AND f.policy_id = pc.policy_id
  WHERE f.startdate < date_add('month'::text, -3::bigint, 'now'::text::date::timestamp without time zone);

COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.modeldata_id IS 'Mid-Term change unique identifier. It''s repeated for different coverages in the same mid-term change. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.systemidstart IS 'Exact mid-term start SystemId from Application';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.systemidend IS 'Exact mid-term end SystemId from Application';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cal_year IS ' 	cast(date_part(year, startdate) as int) 	Year of Start Date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.enddate IS ' 	case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end	Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.startdatetm IS 'Exact Mid-Term Start date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.enddatetm IS 'Exact Mid-Term End Date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.ehy IS '  earned home years	DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovA_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovB_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovC_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovD_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovE_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovF_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.policy_uniqueid IS 'PolicyRef in PolicyStats or SystemId in any other related table';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.units IS ' 	case when risktype=''Homeowners'' then NumberOfFamilies else OwnerOccupiedUnits + TenantOccupiedUnits end';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicyind IS ' 	upper(replace(pc.MultiPolicyAutoDiscount,''~'',''No''))	It''s based on 2 different fields from Building table: MultiPolicyInd (Safeguard) and AutoHomeInd (ICO products). They are the same discount (if there is an auto policy) but for different products';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicynumber IS ' 	pc.MultiPolicyAutoNumber	It''s based on 2 different fields from Building table: MultiPolicyNumber (Safeguard) and otherpolicynumber1 (ICO products). They are the same discount (if there is an auto policy) but for different products';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicyindumbrella IS ' 	upper(replace(pc.MultiPolicyUmbrellaDiscount,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicynumberumbrella IS ' 	pc.UmbrellaRelatedPolicyNumber';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.earthquakeumbrellaind IS ' 	upper(replace(earthquakeumbrellaind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.homegardcreditind IS ' 	upper(replace(homegardcreditind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.sprinklersystem IS ' 	upper(replace(sprinklersystem,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.landlordind IS ' 	upper(replace(pc.landlordind,''~'',''No'')) 	Discount if there is more then 1 Landlord policy per customer';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cseagent IS ' 	upper(replace(cseagent,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.rentersinsurance IS ' 	upper(replace(rentersinsurance,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.firealarmtype IS ' 	upper(replace(FireAlarmType,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.burglaryalarmtype IS ' 	upper(replace(BurglaryAlarmType,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.waterdetectiondevice IS ' 	upper(replace(WaterDetectionDevice,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.neighborhoodcrimewatchind IS ' 	upper(replace(NeighborhoodCrimeWatchInd,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.propertymanager IS ' 	upper(replace(PropertyManager,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.safeguardplusind IS ' 	upper(replace(SafeguardPlusInd,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.deluxepackageind IS ' 	upper(replace(HODeluxe,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.kitchenfireextinguisherind IS ' 	upper(replace(kitchenfireextinguisherind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.smokedetector IS ' 	 upper(replace(smokedetector,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.gatedcommunityind IS ' 	upper(replace(gatedcommunityind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.deadboltind IS ' 	upper(replace(deadboltind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.poolind IS ' 	upper(replace(poolind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.replacementcostdwellingind IS ' 	upper(replace(ReplacementCostDwellingInd,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.replacementvalueind IS ' 	upper(replace(replacementvalueind,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.serviceline IS ' 	upper(replace(serviceline,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.equipmentbreakdown IS ' 	upper(replace(equipmentbreakdown,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.tenantevictions IS ' 	upper(replace(tenantevictions,''~'',''No''))';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_wp IS ' 	Total Policy WP 	including discounts but not fees. Total from Coverage List in SPINN UI Dwelling ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_lossinc IS ' 	Total for all coverages Paid and Incurred Losses 	See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_lossdcce IS ' 	Total for all coverages DCCE	Only DCCE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_lossalae IS ' 	Total for all coverages ALAE	Only ALAE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covcincreasedlimit IS 'CSE decided to price it in two step: a basic limit + anything above that basic limit so they created two coverage codes (PP and INCC) but what CSE would pay under that coverage is really the sum of both. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_polappinconsistency_flg IS 'Sometimes the latest known policy state is different from latest application data due to manual updates. I try to use "policy" instead of "aplication" data';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_riskidduplicates_flg IS 'Different risks have the same number in SPINN. SPINN issue. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_claimok_flg IS 'Claim is joined without an issue';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_claimpolicytermjoin_flg IS 'There is an issue joining a claim to a specific mid-term change because of cancellations. It''s joined to a first mid-term change (record) per policy term.  In many cases there is just one record per policy term in homeowners policies. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covabcdefliab_loss IS ' 	Total Coverage A thru LIAB groups Paid and Incurred Loss';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cat_covabcdefliab_loss IS ' 	Catastrophe Total Coverage A thru LIAB groups  Paid and Incurred Loss';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cat_covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.loaddate IS 'Data last refresh date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_ep IS ' 	AllCov_WP*ehy	 ';