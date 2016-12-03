//
//  OKLineBrush.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/29.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit
import CoreGraphics

class OKLineBrush {
    
    public var indicatorType: OKIndicatorType = .MA(5)
    public var drawPoints: [CGPoint?]?
    private var context: CGContext?
    
    init(indicatorType: OKIndicatorType = .MA(5), context: CGContext?, drawPoints: [CGPoint?]?) {
        self.context = context
        self.drawPoints = drawPoints
        self.indicatorType = indicatorType
    }
    
    public func draw() {
        
        guard let drawPoints = drawPoints,
            let context = context else {
            return
        }
        
        context.setLineWidth(OKConfiguration.shared.MALineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        switch indicatorType {
        case .EMA(5):
            context.setStrokeColor(OKConfiguration.shared.MA5Color)
        case .EMA(12):
            context.setStrokeColor(OKConfiguration.shared.MA12Color)
        case .EMA(26):
            context.setStrokeColor(OKConfiguration.shared.MA26Color)
        default: break
        }
        
        var firstValueIndex: Int?
        
        for (idx, point) in drawPoints.enumerated() {

            if let point = point {
                if firstValueIndex == nil {
                    firstValueIndex = idx
                }
                
                if firstValueIndex == idx {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
        }
    
        context.strokePath()
    }
}
