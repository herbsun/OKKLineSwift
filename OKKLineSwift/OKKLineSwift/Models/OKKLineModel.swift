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
    
}
