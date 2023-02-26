#import numpy as np
import math, pyodbc, pandas as pd
import urllib.request, urllib.parse, urllib.error
from urllib.parse import quote_plus
from sqlalchemy import create_engine

class alcsql(object): 
    def import_table(self,df,schema,table):
        #transform
        try:
            
            chunk_size = 200 #orig was at 10000
            num_chunks = math.ceil(len(df) / chunk_size)

            for i in range(num_chunks):
                try:
                    
                    chunk_df = df[i*chunk_size:(i+1)*chunk_size]
                    chunk_df.to_sql(table, pysql.engine, if_exists = 'append', chunksize = chunk_size, schema=schema, index=False)

                except Exception as e:
                    print('failed to import chunk_df to ' + str(schema) + '.' + str(table) + ' ... {}'.format(e))
                    return False

            return True

        except Exception as e:
            print('failed to import df to ' + str(schema) + '.' + str(table) + ' ... {}'.format(e))
            return False

    def truncate_table(self,schema,table):
        try:
            query = f'''TRUNCATE TABLE [{schema}].[{table}]'''
            # print(query)
            pysql.cursor.execute(query)
            pysql.cursor.commit()

        except Exception as e:
            results = 'failed to truncate ' + str(schema) + '.' + str(table) + ' ... {}'.format(e)
            print(results)

    def execute_stored_proc(self,schema,proc):
        try:
            query = f'''EXEC [{schema}].[{proc}]'''
            # print(query)
            pysql.cursor.execute(query)
            pysql.cursor.commit()

        except Exception as e:
            results = 'failed to execute ' + str(schema) + '.' + str(proc) + ' ... {}'.format(e)
            print(results)
            
    def execute_query(self,query):
        try:
            #put query results into data frame using read_sql
            df = pd.read_sql(query,
                pysql.connection
            )
            return True, df
        except Exception as e:
            print(e)
            return False, None

            
class pysql(object):
    server = '(localdb)\Local'
    database = 'sports'
    username ='selkies'
    password = 'TheEndlessObsession'
    #Authentication='ActiveDirectoryPassword'
    driver= '{ODBC Driver 17 for SQL Server}'
    sqlconn = "DRIVER={ODBC Driver 17 for SQL Server};SERVER=(localdb)\Local;DATABASE=sports;UID=selkies;PWD=TheEndlessObsession"
    quoted = quote_plus(sqlconn)
    newconn = 'mssql+pyodbc:///?odbc_connect={}'.format(quoted)
    engine = create_engine(newconn,fast_executemany=True,connect_args={'autocommit': True})#echo=True,
    engine.connect()
    
    #transact
    cnxn = pyodbc.connect('DRIVER='+driver+
                      ';SERVER='+server+
                      ';PORT=1433;DATABASE='+database+
                      ';UID='+username+
                      ';PWD='+password#+
                    #';AUTHENTICATION='+Authentication
                      )
    cnxn.timeout = 0
    cnxn.autocommit = True
    cursor = cnxn.cursor()
    cursor.fast_executemany=True
    connection = engine.connect()