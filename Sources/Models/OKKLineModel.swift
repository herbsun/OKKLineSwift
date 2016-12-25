//
//  OKKLineSwift
//
//  Copyright © 2016年 Herb - https://github.com/Herb-Sun/OKKLineSwift
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// k线类型
enum OKKLineDataType: Int {
    case BTC
    case LTC
    case ETH
    case other
}

class OKKLineModel: OKDescriptable {
    
    var klineDataType: OKKLineDataType
    // 日期
    var date: Double
    // 开盘价
    var open: Double
    // 收盘价
    var close: Double
    // 最高价
    var high: Double
    // 最低价
    var low: Double
    // 成交量
    var volume: Double
    
    // MARK: 指标
    // 该model以及之前所有开盘价之和
    var sumOpen: Double?
    
    // 该model以及之前所有收盘价之和
    var sumClose: Double?
    
    // 该model以及之前所有最高价之和
    var sumHigh: Double?
    
    // 该model以及之前所有最低价之和
    var sumLow: Double?
    
    // 该model以及之前所有成交量之和
    var sumVolume: Double?
    
    // MARK: MA - MA(N) = (C1+C2+……CN) / N, C:收盘价
    var MAs: [Double?]?
    var MA_VOLUMEs: [Double?]?
    
    // MARK: EMA - EMA(N) = 2 / (N+1) * (C-昨日EMA) + 昨日EMA, C:收盘价
    var EMAs: [Double?]?
    var EMA_VOLUMEs: [Double?]?
    
    // MARK: MACD
    
    // DIF = EMA(12) - EMA(26)
    var DIF: Double?
    // DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
    var DEA: Double?
    // MACD(12,26,9) = (DIF - DEA) * 2
    var MACD: Double?
    
    // MARK: KDJ(9,3,3) 代表指标分析周期为9天，K值D值为3天
    // 九个交易日内最低价
    var minPriceOfNineClock: Double?
    // 九个交易日最高价
    var maxPriceOfNineClock: Double?
    // RSV(9) =（今日收盘价－9日内最低价）/（9日内最高价－9日内最低价）* 100
    var RSV9: Double?
    // K(3) =（当日RSV值+2*前一日K值）/ 3
    var KDJ_K: Double?
    // D(3) =（当日K值 + 2*前一日D值）/ 3
    var KDJ_D: Double?
    // J = 3K － 2D
    var KDJ_J: Double?
    
    // MARK: BOLL
    // 中轨线
    var BOLL_MB: Double?
    // 上轨线
    var BOLL_UP: Double?
    // 下轨线
    var BOLL_DN: Double?
    
    init(klineDataType: OKKLineDataType = .BTC,
         date: Double,
         open: Double,
         close: Double,
         high: Double,
         low: Double,
         volume: Double) {
        
        self.klineDataType = klineDataType
        self.date = date
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.volume = volume
    }
}
