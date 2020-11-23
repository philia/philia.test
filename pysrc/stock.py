import tushare as ts
import pandas as pd  
import mplfinance as mpf
import datetime as dt
from talib import abstract
import backtrader as bt

class TestStrategy(bt.Strategy):
    def log(self, txt, dt=None):
        dt = dt or self.datas[0].datetime.date(0)
        print('%s, %s' % (dt.isoformat(), txt))

    def __init__(self):
        # Keep a reference to the "close" line in the data[0] dataseries
        self.dataclose = self.datas[0].close

    def next(self):
        # Simply log the closing price of the series from the reference
        self.log('Close, %.2f' % self.dataclose[0])

        # If the price has been falling 3 sessions in a row...BUY BUY BUY!!!
        if self.dataclose[0] < self.dataclose[-1] and self.dataclose[-1] < self.dataclose[-2]:
            self.log('BUY CREATE, %.2f' % self.dataclose[0])
            self.buy()


if __name__ == '__main__':

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

    # plot with mplfinance
    #index1 = mpf.make_addplot(abstract.MACDEXT(df), panel = 2, ylabel = 'MACD')
    #index2 = mpf.make_addplot(abstract.RSI(df), panel = 3, ylabel = 'RSI')
    #mpf.plot(df, type='candle', volume=True, style='yahoo', mav=(5, 10, 20, 30), title=data['name'][0] + '.' + s_code, addplot = [index1, index2])

    # backtrader

    cerebro = bt.Cerebro()
    cerebro.addstrategy(TestStrategy)
    feed = bt.feeds.PandasData(dataname=df)
    cerebro.adddata(feed)
    cerebro.broker.setcash(100000.0)
    print('Starting Portfolio Value: %.2f' % cerebro.broker.getvalue())
    cerebro.run()
    print('Final Portfolio Value: %.2f' % cerebro.broker.getvalue())
