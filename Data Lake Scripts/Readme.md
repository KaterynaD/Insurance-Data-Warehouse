Data Lake is based on files in AWS S3 bucket and AWS Glue. The files are queried via Amazon Redshift Spectrum.
There are 3 main areas were we use the files:

1. Data reports from 3rd party agencies provided in different formats time to time. The data are finally landed in dimensional attributes.
2. Historical snapshots of some Redshift tables and views for audit. The data just unloaded from Redshift queries directly to S3 in parquet format. They can be accessed if needed via queries or used in R/Python directly as files.
3. Staging data for some tables in the data warehouse in CSV format. These files are created in some subsidiary companies and the data are supposed to be consistent but in many cases they are not. E.g. no corresponding policies for claims or coverages for a risks. Data Lake tables allow to check staging files consistency before loading the data warehouse fact and dimensional tables. Tableau dashboards based on the files report the issues and made the load process more clean and fast.

   ![image](https://github.com/KaterynaD/Insurance-Data-Warehouse/assets/16999229/19cd3a67-1383-400b-968f-792f0bfcfbc6)
