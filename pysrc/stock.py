import tushare as ts
import pandas as pd  
import mplfinance as mpf
import datetime as dt
from talib import abstract
import backtrader as bt

class SimpleSMAStrategy(bt.Strategy):
    params = (
        ('maperiod', 15),
    )

    def log(self, txt, dt=None, doprint=False):
        if doprint:
            dt = dt or self.datas[0].datetime.date(0)
            print('%s, %s' % (dt.isoformat(), txt))

    def __init__(self):
        self.dataclose = self.datas[0].close
        self.order = None
        self.sma = bt.indicators.MovingAverageSimple(self.datas[0], period=self.params.maperiod)

    def next(self):
        if self.order:
            return
        if not self.position:
            if self.dataclose[0] > self.sma[0]:
                self.buy()
        else:
            if self.dataclose[0] < self.sma[0]:
                self.sell()

    def stop(self):
        self.log('(MA Period %2d) Ending Value %.2f' % (self.params.maperiod, self.broker.getvalue()), doprint=True)


class SimpleHighLowStrategy(bt.Strategy):
    def __init__(self):
        self.dataclose = self.datas[0].close
        self.datahigh = self.datas[0].high
        self.datalow = self.datas[0].low
        self.order = None

    def next(self):
        if self.order:
            return
        if not self.position:
            if self.dataclose[0] > self.datahigh[-1]:
                self.buy()
        else:
            if self.dataclose[0] < self.datalow[-1]:
                self.sell()

class TestStrategy(bt.Strategy):
    params = (
        ('exitbars', 5),
        ('maperiod', 15),
        ('printlog', False),
    )

    def log(self, txt, dt=None, doprint=False):
        if self.params.printlog or doprint:
            dt = dt or self.datas[0].datetime.date(0)
            print('%s, %s' % (dt.isoformat(), txt))

    def __init__(self):
        # Keep a reference to the "close" line in the data[0] dataseries
        self.dataclose = self.datas[0].close
        # To keep track of pending orders and buy price/commission
        self.order = None
        self.buyprice = None
        self.buycomm = None
        self.sma = bt.indicators.MovingAverageSimple(self.datas[0], period=self.params.maperiod)

        bt.indicators.ExponentialMovingAverage(self.datas[0], period=25)
        bt.indicators.WeightedMovingAverage(self.datas[0], period=25, subplot=True)
        bt.indicators.StochasticSlow(self.datas[0])
        bt.indicators.MACDHisto(self.datas[0])
        rsi = bt.indicators.RSI(self.datas[0])
        bt.indicators.SmoothedMovingAverage(rsi, period=10)
        bt.indicators.ATR(self.datas[0], plot=False)

    def notify_order(self, order):
        if order.status in [order.Submitted, order.Accepted]:
            # Buy/Sell order submitted/accepted to/by broker - Nothing to do
            return

        # Check if an order has been completed
        # Attention: broker could reject order if not enough cash
        if order.status in [order.Completed]:
            if order.isbuy():
                self.log('BUY EXECUTED, Price: %.2f, Cost: %.2f, Comm: %.2f' % (order.executed.price, order.executed.value, order.executed.comm))
            elif order.issell():
                self.log('SELL EXECUTED, Price: %.2f, Cost: %.2f, Comm: %.2f' % (order.executed.price, order.executed.value, order.executed.comm))

            self.bar_executed = len(self)

        elif order.status in [order.Canceled, order.Margin, order.Rejected]:
            self.log('Order Canceled/Margin/Rejected')

        # Write down: no pending order
        self.order = None

    def notify_trade(self, trade):
        if not trade.isclosed:
            return
        self.log('OPERATION PROFIT, GROSS: %.2f, NET: %.2f' % (trade.pnl, trade.pnlcomm))

    def next(self):
        # Simply log the closing price of the series from the reference
        self.log('Close, %.2f' % self.dataclose[0])

        # Check if an order is pending ... If yes we cannot send a 2nd one
        if self.order:
            return

        # Check if we are in the market
        if not self.position:
            # Not yet ... we MIGHT BUY if ...
            # If the price has been falling 3 sessions in a row...BUY BUY BUY!!!
            #if self.dataclose[0] < self.dataclose[-1] and self.dataclose[-1] < self.dataclose[-2]:
            if self.dataclose[0] > self.sma[0]:
                self.log('BUY CREATE, %.2f' % self.dataclose[0])
                self.buy()
        else:
            # Already in the market ... we might sell
            #if len(self) >= (self.bar_executed + self.params.exitbars):
            if self.dataclose[0] < self.sma[0]:
                self.log('SELL CREATE, %.2f' % self.dataclose[0])

                # Keep track of the created order to avoid a 2nd order
                self.order = self.sell()

    def stop(self):
        self.log('(MA Period %2d) Ending Value %.2f' % (self.params.maperiod, self.broker.getvalue()), doprint=True)

if __name__ == '__main__':

    with open('config.local') as conf:
        token = conf.readline().strip()
        s_code = conf.readline().strip()

    #dt_end = dt.datetime.today().strftime("%Y%m%d")
    dt_start = (dt.datetime.today() - dt.timedelta(days=365)).strftime("%Y%m%d")
    dt_end = dt.datetime.today().strftime("%Y%m%d")

    ts.set_token(token)
    pro = ts.pro_api()
    #df = pro.daily(ts_code=s_code, start_date='20200101', end_date='20180718')

    data = pro.namechange(ts_code=s_code, fields='name,start_date,end_date,change_reason')
    df = ts.pro_bar(ts_code=s_code, adj='qfq', start_date=dt_start, end_date=dt_end)

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
    cerebro.addsizer(bt.sizers.FixedSize, stake=100)
    #cerebro.addstrategy(TestStrategy)
    #cerebro.optstrategy(TestStrategy, maperiod=range(10, 31))

    #cerebro.addstrategy(SimpleSMAStrategy)
    cerebro.optstrategy(SimpleSMAStrategy, maperiod=range(10, 31))

    feed = bt.feeds.PandasData(dataname=df)
    cerebro.adddata(feed)

    cerebro.broker.setcash(100000.0)
    cerebro.broker.setcommission(commission=0.003)

    #print('[√] Starting Portfolio Value: %.2f' % cerebro.broker.getvalue())
    results = cerebro.run(maxcpus=1, optreturn=False)
    #print('Max Value: %.2f' % max(results[0] 
    #print('[√] Final Portfolio Value: %.2f' % cerebro.broker.getvalue())
    cerebro.plot()
