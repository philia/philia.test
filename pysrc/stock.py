import tushare as ts
import pandas as pd  
import mplfinance as mpf
import datetime as dt

with open('config.local') as conf:
    token = conf.readline().strip()
    s_code = conf.readline().strip()

dt_today = dt.datetime.now().strftime("%Y%m%d")

ts.set_token(token)
pro = ts.pro_api()
#df = pro.daily(ts_code=s_code, start_date='20200101', end_date='20180718')

data = pro.namechange(ts_code=s_code, fields='name,start_date,end_date,change_reason')
df = ts.pro_bar(ts_code=s_code, adj='qfq', start_date='20200101', end_date=dt_today)

# transform for mplfinance OHLC format
df.index = df.trade_date
df = df.rename(index=pd.Timestamp)
df.drop(columns=['ts_code', 'trade_date', 'pre_close', 'change', 'pct_chg', 'amount'], inplace=True)
df.columns = ['open', 'high', 'low', 'close', 'volume']
df.sort_index(inplace=True)

mpf.plot(df, type='candle', volume=True, style='yahoo', mav=(5, 10, 20, 30), title=data['name'][0] + '.' + s_code)
