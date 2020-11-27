import tushare as ts
import pandas as pd  
import mplfinance as mpf
import datetime as dt
import talib as ta
import backtrader as bt
import numpy as np

from talib import abstract
from backtrader import strategies

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
        self.dataopen = self.datas[0].open
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
        self.log('[OPERATION PROFIT] GROSS: %.2f, NET: %.2f, PRICE: %.2f, VALUE: %.2f, SIZE: %.2f' % (trade.pnl, trade.pnlcomm, trade.price, trade.value, trade.size))
        self.log('[PORTFOLIO] CASH: %.2f, VALUE: %.2f' % (self.broker.get_cash(), self.broker.get_value()))

    def next(self):
        # Simply log the closing price of the series from the reference
        self.log('Open: %.2f, Close: %.2f' % (self.dataopen[0], self.dataclose[0]))

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
                self.buy(price=self.dataclose[0])
        else:
            # Already in the market ... we might sell
            #if len(self) >= (self.bar_executed + self.params.exitbars):
            if self.dataclose[0] < self.sma[0]:
                self.log('SELL CREATE, %.2f' % self.dataclose[0])

                # Keep track of the created order to avoid a 2nd order
                self.order = self.sell(price=self.dataclose[0])

    def stop(self):
        self.portfolio = self.broker.getvalue()
        self.log('(MA Period %2d) Ending Value %.2f' % (self.params.maperiod, self.broker.getvalue()), doprint=False)

def backtester(dfiter):
    df = dfiter['data']
    name = dfiter['name']
    # backtrader
    cerebro = bt.Cerebro()
    cerebro.addsizer(bt.sizers.FixedSize, stake=1000)

    #cerebro.addstrategy(TestStrategy)
    cerebro.optstrategy(TestStrategy, maperiod=range(10, 31))

    feed = bt.feeds.PandasData(dataname=df)
    cerebro.adddata(feed, name)

    cerebro.broker.setcash(initial_portfolio)
    cerebro.broker.setcommission(commission=0.003)

    return cerebro.run(maxcpus=1, optreturn=False)

def backtradeplot(df, name, maperiod):
    cerebro = bt.Cerebro()
    cerebro.addsizer(bt.sizers.FixedSize, stake=1000)
    cerebro.addstrategy(TestStrategy, maperiod=maperiod)
    feed = bt.feeds.PandasData(dataname=df)
    cerebro.adddata(feed, name)
    cerebro.broker.setcash(initial_portfolio)
    cerebro.broker.setcommission(commission=0.003)
    cerebro.run()

    # Pattern Recognition
    candle_names = ta.get_function_groups()['Pattern Recognition']
    for candle in candle_names:
        df[candle] = getattr(ta, candle)(df['open'], df['high'], df['low'], df['close'])

    patterns = np.array([])
    for index, row in df.iterrows():
        recoganized_patterns = 0
        for candle in candle_names:
            if (row[candle] != 0):
                recoganized_patterns += 1
        patterns = np.append(patterns, recoganized_patterns)
    df['pat'] = patterns.astype(int)

    # Plotting
    cerebro.plot()

    ### plot with mplfinance
    #index0 = mpf.make_addplot(abstract.BBANDS(df), panel = 0)
    #index1 = mpf.make_addplot(abstract.MACDEXT(df), panel = 2, ylabel = 'MACD')
    #index2 = mpf.make_addplot(abstract.RSI(df), panel = 3, ylabel = 'RSI')
    #index3 = mpf.make_addplot(abstract.STOCHRSI(df), panel = 4, ylabel = 'STOCHRSI')
    #mpf.plot(df, type='candle', volume=True, style='yahoo', mav=(5, 10, 20), title=s_code, addplot = [index0, index1, index2, index3])

if __name__ == '__main__':

    with open('config.local') as conf:
        token = conf.readline().strip()
        global initial_portfolio
        initial_portfolio = float (conf.readline().strip())
        hist_range = int (conf.readline().strip())

    s_codes = []
    with open('scode.local') as conf:
        for line in conf:
            s_codes.append(line.strip().split(','))

    #dt_end = dt.datetime.today().strftime("%Y%m%d")
    dt_start = (dt.datetime.today() - dt.timedelta(days=hist_range)).strftime("%Y%m%d")
    dt_end = dt.datetime.today().strftime("%Y%m%d")

    ts.set_token(token)
    pro = ts.pro_api()
    #df = pro.daily(ts_code=s_code, start_date='20200101', end_date='20180718')

    #data = pro.namechange(ts_code=s_code, fields='name,start_date,end_date,change_reason')
    dfs = []
    for s_code in s_codes:
        dfs.append({ 'name': s_code[1], 'data': ts.pro_bar(ts_code=s_code[0], adj='qfq', start_date=dt_start, end_date=dt_end)} )

    strats = []
    for dfmap in dfs:
        # transform for mplfinance OHLC format
        df = dfmap['data']
        df.index = df.trade_date
        df = df.rename(index=pd.Timestamp)
        df.drop(columns=['ts_code', 'trade_date', 'pre_close', 'change', 'pct_chg', 'amount'], inplace=True)
        df.columns = ['open', 'high', 'low', 'close', 'volume']
        df.sort_index(inplace=True)
        dfmap['data'] = df

        st = backtester(dfmap)

        # Get optimized roi and maperiod
        mp_val = -1
        mp_maperiod = 0
        for ret in st:
            final_port_value = ret[0].portfolio
            if (mp_val < final_port_value):
                mp_val = final_port_value
                mp_maperiod = ret[0].p.maperiod

        roi = (mp_val - initial_portfolio) * 100 / initial_portfolio
        dfmap['roi'] = roi
        dfmap['ma'] = mp_maperiod
        print('[%s] Max ROI: %.2f%% with MA: %d' % (dfmap['name'], roi, mp_maperiod))

    # Plotting
    for dfmap in dfs:
        backtradeplot(dfmap['data'], dfmap['name'], dfmap['ma'])
