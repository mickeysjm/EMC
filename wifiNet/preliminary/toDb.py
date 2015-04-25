import numpy as np
import pandas as pd
from sqlalchemy import create_engine 
import datetime as dt
from IPython.display import display
import plotly.plotly as py 
from plotly.graph_objs import Bar, Scatter, Marker, Layout 

#===In[1]
!wc -l < net_traffic.csv 

#===In[2]
disk_engine = create_engine('sqlite:///netdata_traffic.db')

#===In[3]

start = dt.datetime.now()
chunkfirst = 1
chunksize = 20000
j = 0
index_start = 1

for df in pd.read_csv('net_traffic.csv', chunksize=chunksize, 
                      iterator=True, encoding='utf-8'):
    
    df = df.rename(columns={c: c.replace(' ', '') for c in df.columns}) 
    df.index += index_start
    df.columns=['ID','Location','Duration','Start','Provider',
                'Type','Domain','Size','Req']    
    j+=1
    print '{} seconds: completed {} rows'.format((dt.datetime.now() - 
    	start).seconds, j*chunksize)
    df.to_sql('data', disk_engine, if_exists='append')
    index_start = df.index[-1] + 1

#===
df = pd.read_sql_query('SELECT * FROM data LIMIT 3', disk_engine)
df.head()