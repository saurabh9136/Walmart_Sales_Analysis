import pandas as pd
from db_connection import get_engine

df = pd.read_csv("walmart.csv", encoding_errors='ignore')

# to know about data types
# print(df.info()) 
'''
ata columns (total 11 columns):
 #   Column          Non-Null Count  Dtype  
---  ------          --------------  -----  
 0   invoice_id      10051 non-null  int64  
 1   Branch          10051 non-null  object 
 2   City            10051 non-null  object 
 3   category        10051 non-null  object 
 4   unit_price      10020 non-null  object   - 30 rows are missing & data type should be a int
 5   quantity        10020 non-null  float64  - 30 rows are missing  
 6   date            10051 non-null  object 
 7   time            10051 non-null  object 
 8   payment_method  10051 non-null  object 
 9   rating          10051 non-null  float64
 10  profit_margin   10051 non-null  float64
'''

# now to find duplicates we use duplicated method i returns true or false and to know the count of duplicate record we add sum function
# print(df.duplicated().sum())

# now to find null values in data frame
# print(df.isnull().sum())
'''
unit_price        31
quantity          31
'''

# to remove duplicate use below command
df.drop_duplicates(inplace=True)

# Now if we don't have a alternate values for null just drop them else replace
df.dropna(inplace=True)
# print(df.isnull().sum())

# now the last problem is to conver unit price to int to perform calculation
# df['unit_price'].astype(float) # but this will through an error because we can't change string to it reason $ symbol

'''
steps to resolve:
1. replace the $ sign with blank value
2. Now only numbers are present so now we are able to convert that to float type
3. Note converting data type cannot affect actual data so we need to assign the changes to that coulmn
'''

df['unit_price'] = df['unit_price'].str.replace('$','').astype(float)

# Now lets create an new column -total  which is unit_price * quantity
df['total_amount'] = df['unit_price'] * df['quantity']
print(df.shape)

# export dataframe as csv
df.to_csv('walmart-clean-data.csv', index=False)


engine = get_engine()

if engine:
    df.to_sql(name='sales_data', con=engine, if_exists='append', index=False)
    print("Data transferred")