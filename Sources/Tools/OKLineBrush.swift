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
    
    public var indicatorType: OKIndicatorType
    public var drawPoints: [CGPoint?]?
    private var context: CGContext?
    
    init(indicatorType: OKIndicatorType, context: CGContext?, drawPoints: [CGPoint?]?) {
        self.indicatorType = indicatorType
        self.context = context
        self.drawPoints = drawPoints
    }
    
    public func draw() {
        
        guard let drawPoints = drawPoints,
            let context = context else {
            return
        }
        
        context.setLineWidth(OKConfiguration.shared.indicatorLineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        switch indicatorType {
        case .MA(let day):
            context.setStrokeColor(OKConfiguration.shared.theme.MAColor(day: day))
        case .EMA(let day):
            context.setStrokeColor(OKConfiguration.shared.theme.EMAColor(day: day))
        case .DIF:
            context.setStrokeColor(OKConfiguration.shared.theme.DIFColor)
        case .DEA:
            context.setStrokeColor(OKConfiguration.shared.theme.DEAColor)
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
