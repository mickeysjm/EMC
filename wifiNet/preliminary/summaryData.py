import numpy as np
import pandas as pd
from sqlalchemy import create_engine 
import datetime as dt
from IPython.display import display
import plotly.plotly as py 

#plotly.tools.set_credentials_file(username='zedyang', 
#                                  api_key='dyytlcpib3', 
#                                  stream_ids=['436iwi32ro', 
#                                              'sd3b8v5ucf'])

from plotly.graph_objs import Bar, Scatter, Marker, Layout 

df = pd.read_sql_query('SELECT * FROM data LIMIT 3', disk_engine)
df.head()

#===SQLQueryTest, In[1]
df = pd.read_sql_query('SELECT ID, Location, Duration, Start '
                       'FROM data '
                       'LIMIT 10', disk_engine)
df

#===In[2]
df = pd.read_sql_query('SELECT * '
                       'FROM data '
                       'WHERE Location IN ("东上院")'
                       'LIMIT 10', disk_engine)
df.head()

#===
df = pd.read_sql_query('SELECT * '
                       'FROM data '
                       'WHERE ID IN ("11000752")'
                       'LIMIT 10', disk_engine)
df.head()

#===In[3]
df = pd.read_sql_query('SELECT DISTINCT Location FROM data', 
						disk_engine)
df

#===In[4]
df = pd.read_sql_query('SELECT Location, COUNT(*) as `num_connection`'
                       'FROM data '
                       'GROUP BY Location ', disk_engine)

df.head()

#===plotlyTest,In[5]
df = pd.read_sql_query('SELECT Location, COUNT(*) as `num_connection`'
                       'FROM data '
                       'GROUP BY Location '
                       'ORDER BY -num_connection'
                       'LIMIT 20', disk_engine)

df = df[:20]
countByLocation_20 = df


#===
py.iplot({
    'data': [Bar(x=df['Location'], y=df.num_connection)],
    'layout': { 
        'margin': {'b': 160}, 
        'xaxis': {'tickangle': 35}} })

#===In[6], Count by person
df = pd.read_sql_query('SELECT ID, COUNT(*) as `num_connection`'
                       'FROM data '
                       'GROUP BY ID '
                       'ORDER BY -num_connection', disk_engine)

df[['ID']]=df[['ID']].astype(object)
countByPerson_All = df
df = df[:45]
countByPerson_45 = df
df
#===
py.iplot({
    'data': [Bar(x=countByPerson_45['ID'], 
    			 y=countByPerson_45.num_connection)],
    'layout': { 
        'margin': {'b': 160}, 
        'xaxis': {'tickangle': 35}} })