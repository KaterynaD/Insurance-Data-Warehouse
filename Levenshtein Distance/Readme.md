**Levenshtein distance** is a number that tells you what's the minimum steps you need to perform to transform one string into another. The higher the number, the more different the two strings are. 

Levenshtein distance can be used to combine data from disconnected data sources based on the same but slightly different keys.

Let's say a Dwelling policy covers 2 houses with different addresses. We receive a data report from a 3rd party agency regarding each of these houses and we need to load the data report attributes into DIM_BUILDING dimension.
There is a policy number in the data report but the addresses of the buildings are not exactly the same as we have in the dimension. 

![image](https://github.com/KaterynaD/Insurance-Data-Warehouse/assets/16999229/a004c872-b342-403a-99a2-904687134962)

Instead of "=" (Equals To) on Address fields Levenshtein distance<N can be used. N=5 works for my use case.

UDF Python function was created in Redshift for this purpose and used in data loads from 3rd party data feeds to compare addresses and names. 
Levenshtein distance is added in a quality column to review the automatic load.

![image](https://github.com/KaterynaD/Insurance-Data-Warehouse/assets/16999229/d393daa9-c142-4620-b8e3-23acb79b3aee)


![image](https://github.com/KaterynaD/Insurance-Data-Warehouse/assets/16999229/0971d938-6520-47e7-a3bf-64ccd0f0fb9a)


EDITDISTANCE is built-in function in Snowflake and no need for custom development.
