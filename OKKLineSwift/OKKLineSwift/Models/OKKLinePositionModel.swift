//
//  OKKLinePositionModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
import CoreGraphics

struct OKKLinePositionModel {
    
    /// 开盘点
    var openPoint: CGPoint
    /// 收盘点
    var closePoint: CGPoint
    /// 最高点
    var highPoint: CGPoint
    /// 最低点
    var lowPoint: CGPoint
    
    init(openPoint: CGPoint, closePoint: CGPoint, highPoint: CGPoint, lowPoint: CGPoint) {
        self.openPoint = openPoint
        self.closePoint = closePoint
        self.highPoint = highPoint
        self.lowPoint = lowPoint
    }
    
}
