//
//  OKKLinePositionModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
import CoreGraphics

class OKKLinePositionModel: OKDescriptable {
    
    /// 开盘点
    var openPoint: CGPoint
    /// 收盘点
    var closePoint: CGPoint
    /// 最高点
    var highPoint: CGPoint
    /// 最低点
    var lowPoint: CGPoint
    
    var MA5Point: CGPoint?
    var MA7Point: CGPoint?
    var MA10Point: CGPoint?
    var MA12Point: CGPoint?
    var MA20Point: CGPoint?
    var MA26Point: CGPoint?
    var MA30Point: CGPoint?
    var MA60Point: CGPoint?
    var MA5_VOLUMEPoint: CGPoint?
    var MA7_VOLUMEPoint: CGPoint?
    var MA10_VOLUMEPoint: CGPoint?
    var MA12_VOLUMEPoint: CGPoint?
    var MA20_VOLUMEPoint: CGPoint?
    var MA26_VOLUMEPoint: CGPoint?
    var MA30_VOLUMEPoint: CGPoint?
    var MA60_VOLUMEPoint: CGPoint?
    
    // MARK: EMA - EMA(N) = 2 / (N+1) * (C-昨日EMA) + 昨日EMA, C:收盘价
    var EMA5Point: CGPoint?
    var EMA7Point: CGPoint?
    var EMA10Point: CGPoint?
    var EMA12Point: CGPoint?
    var EMA20Point: CGPoint?
    var EMA26Point: CGPoint?
    var EMA30Point: CGPoint?
    var EMA60Point: CGPoint?
    var EMA5_VOLUMEPoint: CGPoint?
    var EMA7_VOLUMEPoint: CGPoint?
    var EMA10_VOLUMEPoint: CGPoint?
    var EMA12_VOLUMEPoint: CGPoint?
    var EMA20_VOLUMEPoint: CGPoint?
    var EMA26_VOLUMEPoint: CGPoint?
    var EMA30_VOLUMEPoint: CGPoint?
    var EMA60_VOLUMEPoint: CGPoint?

    
    init(openPoint: CGPoint, closePoint: CGPoint, highPoint: CGPoint, lowPoint: CGPoint) {
        self.openPoint = openPoint
        self.closePoint = closePoint
        self.highPoint = highPoint
        self.lowPoint = lowPoint
    }
    
}
