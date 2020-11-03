import tushare as ts
import pandas as pd  
import matplotlib.pyplot as plt
import mplfinance as mpf

with open('config.local') as conf:
    token = conf.readline()
    s_code = conf.readline()

ts.set_token(token)
pro = ts.pro_api()
#df = pro.daily(ts_code=s_code, start_date='20200101', end_date='20180718')

df = ts.pro_bar(ts_code=s_code, adj='qfq', start_date='20200101', end_date='20201001')

# transform for mplfinance OHLC format
df.index = df.trade_date
df = df.rename(index=pd.Timestamp)
df.drop(columns=['ts_code', 'trade_date', 'pre_close', 'change', 'pct_chg', 'amount'], inplace=True)
df.columns = ['open', 'high', 'low', 'close', 'volume']
df.sort_index(inplace=True)

mpf.plot(df, type='candle', volume=True, style='yahoo', mav=(5, 10, 20, 30))
