/**https://github.com/martinblech/xmltodict*/
create or replace library xmltodict 
language plpythonu 
from 's3://cse-bi/temp/Python/xmltodict.zip' 
IAM_ROLE 'arn:aws:iam::171874763805:role/cseredshiftrole';
