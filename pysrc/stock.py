import tushare as ts
import pandas as pd  
import datetime as dt
import talib as ta
import backtrader as bt
import numpy as np

from talib import abstract
from backtrader import strategies

class NilStrategy(bt.Strategy):
    pass

class TestStrategy(bt.Strategy):
    def stop(self):
        print("TestStrategy executed")

class MAStrategy(bt.Strategy):
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
        self.trade_dates = []
        self.sma = bt.indicators.MovingAverageSimple(self.datas[0], period=self.params.maperiod)

        bt.indicators.MACDHisto(self.datas[0])
        rsi = bt.indicators.RSI(self.datas[0])
        #bt.indicators.SmoothedMovingAverage(rsi, period=self.params.maperiod)
        #bt.indicators.ExponentialMovingAverage(self.datas[0], period=self.params.maperiod)
        #bt.indicators.WeightedMovingAverage(self.datas[0], period=self.params.maperiod)
        bt.indicators.StochasticSlow(self.datas[0])
        #bt.indicators.ATR(self.datas[0], plot=False)
        bt.indicators.BBands(self.datas[0])
        bt.indicators.WilliamsR(self.datas[0])

    def notify_order(self, order):
        if order.status in [order.Submitted, order.Accepted]:
            # Buy/Sell order submitted/accepted to/by broker - Nothing to do
            return

        # Check if an order has been completed
        # Attention: broker could reject order if not enough cash
        if order.status in [order.Completed]:
            if order.isbuy():
                self.log('BUY EXECUTED, Price: %.2f, Cost: %.2f, Comm: %.2f' % (order.executed.price, order.executed.value, order.executed.comm))
                ac = "🔺BUY"
            elif order.issell():
                self.log('SELL EXECUTED, Price: %.2f, Cost: %.2f, Comm: %.2f' % (order.executed.price, order.executed.value, order.executed.comm))
                ac = "🔽SELL"

            self.bar_executed = len(self)
            self.trade_dates.append({"action": ac, "date": bt.num2date(order.created.dt).strftime("%Y%m%d")})

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

def get_cerebro(df, name):
    # initialize backtrader
    cerebro = bt.Cerebro()
    cerebro.addsizer(bt.sizers.FixedSize, stake=1000)

    feed = bt.feeds.PandasData(dataname=df)
    cerebro.adddata(feed, name)

    cerebro.broker.setcash(initial_portfolio)
    cerebro.broker.setcommission(commission=0.003)

    return cerebro

def optimize_strategy(dfiter):
    df = dfiter['data']
    name = dfiter['name']
    strategy = dfiter['strategy']   # This is the strategy we want to optimize against

    cerebro = get_cerebro(df, name)

    if strategy == 'MAStrategy':
        cerebro.optstrategy(eval(strategy), maperiod=range(10, 31))
    else:
        cerebro.addstrategy(NilStrategy)

    st = cerebro.run(maxcpus=1, optreturn=False)

    if strategy == 'MAStrategy':
        # Get optimized roi and maperiod
        mp_val = -1
        mp_maperiod = 0
        for ret in st:
            final_port_value = ret[0].portfolio
            if (mp_val < final_port_value):
                mp_val = final_port_value
                mp_maperiod = ret[0].p.maperiod

        roi = (mp_val - initial_portfolio) * 100 / initial_portfolio
        dfiter['roi'] = roi
        dfiter['ma'] = mp_maperiod
        dfiter['opt_strategy'] = st

        recent_order = st[0][0].trade_dates[-1]
        if dt.datetime.strptime(recent_order['date'], '%Y%m%d') > dt.datetime.today() - dt.timedelta(7):
            # 7天/一周内有交易
            notifier = '[交易: %s, %s]' % (recent_order['action'], recent_order['date'])
        else:
            notifier = ''
        print('%s[%s] Max ROI: %.2f%% with MA: %d' % (notifier, dfmap['name'], roi, mp_maperiod))

def generate_report(dfmap, doplot=False):

    df = dfmap['data']
    name = dfmap['name']
    strategy = dfmap['strategy']

    cerebro = get_cerebro(df, name)

    if strategy == 'MAStrategy':
        cerebro.addstrategy(eval(strategy), maperiod=dfmap['ma'])
    else:
        cerebro.addstrategy(eval(strategy))

    cerebro.run()
    if doplot:
        cerebro.plot()

'''
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
    '''

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
        dfs.append({
            'data': ts.pro_bar(ts_code=s_code[0], adj='qfq', start_date=dt_start, end_date=dt_end),
            'name': s_code[1],
            'strategy': s_code[2]
            })

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

        optimize_strategy(dfmap)

        generate_report(dfmap, doplot=False)
