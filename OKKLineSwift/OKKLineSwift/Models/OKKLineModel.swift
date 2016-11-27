//
//  OKKLineModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

enum OKCoinType: Int {
    case BTC
    case LTC
    case ETH
    case other
}

struct OKKLineModel {
    
    var coinType: OKCoinType
    // 日期
    var date: Double
    /// 成交量
    var volume: Double
    /// 开盘价
    var open: Double
    /// 收盘价
    var close: Double
    /// 最高价
    var high: Double
    /// 最低价
    var low: Double
    
    // MARK: - 指标
    /// 该model以及之前所有成交量之和
    var sumVolume: Double
    /// 该model以及之前所有开盘价之和
    var sumOpen: Double
    /// 该model以及之前所有收盘价之和
    var sumClose: Double
    /// 该model以及之前所有最高价之和
    var sumHigh: Double
    /// 该model以及之前所有最低价之和
    var sumLow: Double
    
    // MARK: MA - MA(N) = (C1+C2+……CN) / N, C:收盘价
    var MA5: Double
    var MA7: Double
    var MA10: Double
    var MA20: Double
    var MA30: Double
    var MA60: Double
    var MA5_VOLUME: Double
    var MA7_VOLUME: Double
    var MA10_VOLUME: Double
    var MA20_VOLUME: Double
    var MA30_VOLUME: Double
    var MA60_VOLUME: Double
    
    // MARK: EMA - EMA(N) = 2 / (N+1) * (C-昨日EMA) + 昨日EMA, C:收盘价
    var EMA5: Double
    var EMA7: Double
    var EMA10: Double
    var EMA20: Double
    var EMA30: Double
    var EMA60: Double
    
    var DIF: Double
    var DEA: Double
    /// MACD(12,26,9)
    var MACD: Double
    
    // MARK: - KDJ
    /// 九个交易日内最低价
    var minPriceOfNineClock: Double
    /// 九个交易日最高价
    var maxPriceOfNineClock: Double
    //KDJ(9,3.3),下面以该参数为例说明计算方法。
    //9，3，3代表指标分析周期为9天，K值D值为3天
    //RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
    //K(3日)=（当日RSV值+2*前一日K值）÷3
    //D(3日)=（当日K值+2*前一日D值）÷3
    //J=3K－2D
    var RSV: Double
    var KDJ_K: Double
    var KDJ_D: Double
    var KDJ_J: Double
}
