//
//  OKIndicatorPositionModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
import CoreGraphics

class OKIndicatorPositionModel: OKDescriptable {
    
    /// 开始点
    var startPoint: CGPoint
    /// 结束点
    var endPoint: CGPoint
    
    var MA5_VOLUMEPoint: CGPoint?
    var MA7_VOLUMEPoint: CGPoint?
    var MA10_VOLUMEPoint: CGPoint?
    var MA12_VOLUMEPoint: CGPoint?
    var MA20_VOLUMEPoint: CGPoint?
    var MA26_VOLUMEPoint: CGPoint?
    var MA30_VOLUMEPoint: CGPoint?
    var MA60_VOLUMEPoint: CGPoint?
    
    var EMA5_VOLUMEPoint: CGPoint?
    var EMA7_VOLUMEPoint: CGPoint?
    var EMA10_VOLUMEPoint: CGPoint?
    var EMA12_VOLUMEPoint: CGPoint?
    var EMA20_VOLUMEPoint: CGPoint?
    var EMA26_VOLUMEPoint: CGPoint?
    var EMA30_VOLUMEPoint: CGPoint?
    var EMA60_VOLUMEPoint: CGPoint?
    
    var DIFPoint: CGPoint?
    var DEAPoint: CGPoint?
    var MACDPoint: CGPoint?
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
