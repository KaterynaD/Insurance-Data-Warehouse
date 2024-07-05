CREATE OR REPLACE FUNCTION kdlab.xml_to_json(s_xml varchar(65535))
	RETURNS varchar(65535)
	LANGUAGE plpythonu
	STABLE
AS $$
	
    import xmltodict, json
    
    o = xmltodict.parse(s_xml)

    return json.dumps(o)

$$
;
