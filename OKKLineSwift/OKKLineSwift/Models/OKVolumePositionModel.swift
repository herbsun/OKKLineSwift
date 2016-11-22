//
//  OKVolumePositionModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
import CoreGraphics

struct OKVolumePositionModel {
    
    /// 开始点
    var startPoint: CGPoint
    /// 结束点
    var endPoint: CGPoint
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
