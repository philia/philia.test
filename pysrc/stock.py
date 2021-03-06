import tushare as ts
import pandas as pd  
import datetime as dt
import talib as ta
import backtrader as bt
import numpy as np

from talib import abstract
from backtrader import strategies
from operator import itemgetter
from itertools import chain 

class BaseStrategy(bt.Strategy):
    params = (
        ('printlog', False),
    )

    def log(self, txt, dt=None, doprint=False):
        if self.params.printlog or doprint:
            dt = dt or self.datas[0].datetime.date(0)
            print('%s, %s' % (dt.isoformat(), txt))

    def __init__(self):

        self.trade_dates = []

        bt.indicators.MACDHisto(self.datas[0])
        rsi = bt.indicators.RSI(self.datas[0])
        bt.indicators.StochasticSlow(self.datas[0])
        bt.indicators.BBands(self.datas[0])
        bt.indicators.WilliamsR(self.datas[0])

    def stop(self):
        self.portfolio = self.broker.getvalue()

    def notify_order(self, order):
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

    def notify_trade(self, trade):
        if not trade.isclosed:
            return
        self.log('[OPERATION PROFIT] GROSS: %.2f, NET: %.2f, PRICE: %.2f, VALUE: %.2f, SIZE: %.2f' % (trade.pnl, trade.pnlcomm, trade.price, trade.value, trade.size))
        self.log('[PORTFOLIO] CASH: %.2f, VALUE: %.2f' % (self.broker.get_cash(), self.broker.get_value()))

class MACDStrategy(BaseStrategy):
    params = (
        ('macd1', 12),
        ('macd2', 26),
        ('macdsig', 9),
        ('atrperiod', 14),  # ATR Peroid (standard)
        ('atrdist', 3.0),   # ATR distance for stop price
        ('smaperiod', 30),  # SMA Period (pretty standard)
        ('dirperiod', 10),  # Lookback period to consider SMA trend direction
    )

    def __init__(self):
        self.macd = bt.indicators.MACD(self.datas[0],
                period_me1=self.p.macd1,
                period_me2=self.p.macd2,
                period_signal=self.p.macdsig)
        # Cross of macd.macd and macd.signal
        self.mcross = bt.indicators.CrossOver(self.macd.macd, self.macd.signal)
        # To set the stop price
        self.atr = bt.indicators.ATR(self.datas[0], period=self.p.atrperiod)
        # Control market trend
        self.sma = bt.indicators.SMA(self.datas[0], period=self.p.smaperiod)
        self.smadir = self.sma - self.sma(-self.p.dirperiod)
        super().__init__()

    def notify_order(self, order):
        super().notify_order(order)

        if not order.alive():
            self.order = None # indicate no order is pending

    def start(self):
        self.order = None # sentinel to avoid operations on pending order

    def next(self):
        if self.order:
            return  # pending order execution
        if not self.position:    # not in the market
            if self.mcross[0] > 0.0 and self.smadir < 0.0:
                self.order = self.buy()
                pdist = self.atr[0] * self.p.atrdist
                self.pstop = self.datas[0].close - pdist
        else:   # in the market
            pclose = self.datas[0].close
            pstop = self.pstop
            if pclose < pstop:
                self.close()    # stop met - get out
            else:
                pdist = self.atr[0] * self.p.atrdist
                # Update only if greater than
                self.pstop = max(pstop, pclose - pdist)

class MAStrategy(BaseStrategy):
    params = (
        ('exitbars', 5),
        ('maperiod', 15),
    )

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

        super().__init__()

    def notify_order(self, order):
        if order.status in [order.Submitted, order.Accepted]:
            # Buy/Sell order submitted/accepted to/by broker - Nothing to do
            return
        elif order.status in [order.Canceled, order.Margin, order.Rejected]:
            self.log('Order Canceled/Margin/Rejected')

        super().notify_order(order)

        # Write down: no pending order
        self.order = None

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
    #strategy = dfiter['strategy']   # This is the strategy we want to optimize against

    cerebro = get_cerebro(df, name)
    cerebro.optstrategy(MAStrategy, maperiod=range(10, 31))
    ma_opted_st = cerebro.run(maxcpus=1, optreturn=False)

    cerebro = get_cerebro(df, name)
    cerebro.optstrategy(MACDStrategy, macd1=range(7,12), macd2=range(26,31))
    macd_opted_st = cerebro.run(maxcpus=1, optreturn=False)


    max_portfolio = -1
    opt_st = None
    for ret in list(chain.from_iterable(ma_opted_st + macd_opted_st)):
        final_port_value = ret.portfolio
        if max_portfolio < final_port_value:
            max_portfolio = final_port_value
            opt_st = ret

    roi = (max_portfolio - initial_portfolio) * 100 / initial_portfolio
    dfiter['roi'] = roi
    dfiter['opt_strategy'] = opt_st
    opt_st_name = type(opt_st).__name__
    dfiter['opt_strategy_name'] = opt_st_name

    if opt_st_name == 'MAStrategy':
        dfiter['ma'] = opt_st.p.maperiod
    elif opt_st_name == 'MACDStrategy':
        dfiter['macd1'] = opt_st.p.macd1
        dfiter['macd2'] = opt_st.p.macd2

    recent_order = opt_st.trade_dates[-1]
    if dt.datetime.strptime(recent_order['date'], '%Y%m%d') > dt.datetime.today() - dt.timedelta(7):
        # 7天/一周内有交易
        notifier = '[交易: %s, %s]' % (recent_order['action'], recent_order['date'])
    else:
        notifier = ''

    dfiter['report'] = '%s[%s] Max ROI: %.2f%%' % (notifier, dfmap['name'], roi)

def generate_report(dfmap, doplot=False):

    df = dfmap['data']
    name = dfmap['name']
    strategy = dfmap['opt_strategy_name']

    cerebro = get_cerebro(df, name)

    if strategy == 'MAStrategy':
        cerebro.addstrategy(eval(strategy), maperiod=dfmap['ma'])
    else:
        cerebro.addstrategy(eval(strategy), macd1=dfmap['macd1'], macd2=dfmap['macd2'])

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

    dt_start = (dt.datetime.today() - dt.timedelta(days=hist_range)).strftime("%Y%m%d")
    dt_end = dt.datetime.today().strftime("%Y%m%d")
    #dt_end = (dt.datetime.today() - dt.timedelta(days=1)).strftime("%Y%m%d")

    ts.set_token(token)
    pro = ts.pro_api()
    #df = pro.daily(ts_code=s_code, start_date='20200101', end_date='20180718')
    #data = pro.namechange(ts_code=s_code, fields='name,start_date,end_date,change_reason')
    dfs = []
    for s_code in s_codes:
        dfs.append({
            'data': ts.pro_bar(ts_code=s_code[0], adj='qfq', start_date=dt_start, end_date=dt_end),
            'name': s_code[1],
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

        #generate_report(dfmap, doplot=False)

    dfs_s = sorted(dfs, key = lambda x: x['roi'], reverse = True)

    print("\n".join(list(map(itemgetter('report'), dfs_s))))
