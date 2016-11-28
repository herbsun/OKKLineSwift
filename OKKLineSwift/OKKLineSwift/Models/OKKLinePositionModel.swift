//
//  OKKLinePositionModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
import CoreGraphics

class OKKLinePositionModel {
    
    /// 开盘点
    var openPoint: CGPoint
    /// 收盘点
    var closePoint: CGPoint
    /// 最高点
    var highPoint: CGPoint
    /// 最低点
    var lowPoint: CGPoint
    
    var MA5Point: CGPoint?
    
    init(openPoint: CGPoint, closePoint: CGPoint, highPoint: CGPoint, lowPoint: CGPoint, MA5Point: CGPoint?) {
        self.openPoint = openPoint
        self.closePoint = closePoint
        self.highPoint = highPoint
        self.lowPoint = lowPoint
        self.MA5Point = MA5Point
    }
    
}
