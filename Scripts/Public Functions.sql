-- Drop table

-- DROP TABLE public.vmfact_claim_blended;

--DROP TABLE public.vmfact_claim_blended;
CREATE TABLE IF NOT EXISTS public.vmfact_claim_blended
(
	month_id INTEGER   ENCODE RAW
	,claim_number VARCHAR(50)   ENCODE zstd
	,catastrophe_id INTEGER   ENCODE az64
	,claimant VARCHAR(50)   ENCODE bytedict
	,feature VARCHAR(75)   ENCODE bytedict
	,feature_desc VARCHAR(125)   ENCODE bytedict
	,feature_type VARCHAR(100)   ENCODE bytedict
	,aslob VARCHAR(5)   ENCODE bytedict
	,rag VARCHAR(3)   ENCODE bytedict
	,schedp_part CHAR(2)   ENCODE zstd
	,loss_paid NUMERIC(38,2)   ENCODE zstd
	,loss_reserve NUMERIC(38,2)   ENCODE zstd
	,aoo_paid NUMERIC(38,2)   ENCODE zstd
	,aoo_reserve NUMERIC(38,2)   ENCODE az64
	,dcc_paid NUMERIC(38,2)   ENCODE az64
	,dcc_reserve NUMERIC(38,2)   ENCODE az64
	,salvage_received NUMERIC(38,2)   ENCODE zstd
	,salvage_reserve NUMERIC(38,2)   ENCODE az64
	,subro_received NUMERIC(38,2)   ENCODE zstd
	,subro_reserve NUMERIC(38,2)   ENCODE az64
	,product_code VARCHAR(100)   ENCODE bytedict
	,product VARCHAR(100)   ENCODE bytedict
	,subproduct VARCHAR(100)   ENCODE bytedict
	,carrier VARCHAR(100)   ENCODE zstd
	,carrier_group VARCHAR(9)   ENCODE zstd
	,company VARCHAR(50)   ENCODE bytedict
	,policy_state VARCHAR(75)   ENCODE bytedict
	,policy_number VARCHAR(75)   ENCODE zstd
	,policyref INTEGER   ENCODE az64
	,poleff_date DATE   ENCODE az64
	,polexp_date DATE   ENCODE az64
	,producer_code VARCHAR(50)   ENCODE zstd
	,loss_date DATE   ENCODE az64
	,loss_year INTEGER   ENCODE az64
	,reported_date DATE   ENCODE az64
	,loss_cause VARCHAR(255)   ENCODE zstd
	,source_system VARCHAR(100)   ENCODE bytedict
	,loaddate DATE NOT NULL  ENCODE az64
)
DISTSTYLE AUTO
 DISTKEY (month_id)
 SORTKEY (
	month_id
	)
;
ALTER TABLE public.vmfact_claim_blended owner to kdrogaieva;
COMMENT ON TABLE public.vmfact_claim_blended IS 'Monthly summaries of public.vmfact_claimtransaction_blended based on month of acct_date';

CREATE OR REPLACE FUNCTION public.isnumeric(aval varchar)
	RETURNS bool
	LANGUAGE plpythonu
	IMMUTABLE
AS $$
	
    try:
       x = float(aval);
    except:
       return (1==2);
    else:
       return (1==1);

$$
;

CREATE OR REPLACE FUNCTION public.levenshtein(s varchar, t varchar)
	RETURNS int4
	LANGUAGE plpythonu
	STABLE
AS $$
	
    """
    levenshtein(s, t) -> ldist
    ldist is the Levenshtein distance between the strings
    s and t.
    For all i and j, dist[i,j] will contain the Levenshtein
    distance between the first i characters of s and the
    first j characters of t
    """
    if s is None and t is None:
        return 0
    if s is None:
        return len(t)
    if t is None:
        return len(s)

    rows = len(s)+1
    cols = len(t)+1
    dist = [[0 for x in range(cols)] for x in range(rows)]
    # source prefixes can be transformed into empty strings
    # by deletions:
    for i in range(1, rows):
        dist[i][0] = i
    # target prefixes can be created from an empty source string
    # by inserting the characters
    for i in range(1, cols):
        dist[0][i] = i

    for col in range(1, cols):
        for row in range(1, rows):
            if s[row-1] == t[col-1]:
                cost = 0
            else:
                cost = 1
            dist[row][col] = min(dist[row-1][col] + 1,      # deletion
                                 dist[row][col-1] + 1,      # insertion
                                 dist[row-1][col-1] + cost) # substitution

    return dist[rows-1][cols-1]

$$
;

CREATE OR REPLACE FUNCTION public.removenotnumeric(aval varchar)
	RETURNS varchar
	LANGUAGE plpythonu
	IMMUTABLE
AS $$
	
	if aval:
		import re
		non_decimal = re.compile(r'[^\d.]+')
		s=non_decimal.sub('', aval)
		if not s:
			s='0'
	else: 
		s='0'
 	return s

$$
;