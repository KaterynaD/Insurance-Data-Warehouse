The main source of the data warehouse is SPInn (SurePower Innovation). It is a web-based application and it uses XML (beans) saved in varchar columns of Aurora database. 

SPInn jobs shreads data from XML into relation tables once a day. Not all XML are loaded into these tables as well as not all attributes (but most of them) are shread.

Time to time we need some additional information available only in XML.

There is no way in Redshift to read XML data directly. First they need to be converted in JSON. 

XML_TO_JSON function was developed to convert XML to JSON using XMLTODICT library (https://github.com/martinblech/xmltodict). 

Tables with SPInn XML data are available in Redshift via federated queries. 
However, the XML LongText in many times are huge (larger then max Redshift varchar length which is 65535) and it is not possible directly process XML in SQL. 

Old fashioned Aurora ExtractValue function is easy to use.

