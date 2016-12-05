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
    public var configuration: OKConfiguration
    public var drawPoints: [CGPoint?]?
    private var context: CGContext?
    
    init(indicatorType: OKIndicatorType, context: CGContext?, drawPoints: [CGPoint?]?, configuration: OKConfiguration) {
        self.indicatorType = indicatorType
        self.context = context
        self.drawPoints = drawPoints
        self.configuration = configuration
    }
    
    public func draw() {
        
        guard let drawPoints = drawPoints,
            let context = context else {
            return
        }
        
        context.setLineWidth(configuration.indicatorLineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        switch indicatorType {
        case .MA(let day):
            context.setStrokeColor(configuration.theme.MAColor(day: day))
        case .EMA(let day):
            context.setStrokeColor(configuration.theme.EMAColor(day: day))
        case .DIF:
            context.setStrokeColor(configuration.theme.DIFColor)
        case .DEA:
            context.setStrokeColor(configuration.theme.DEAColor)
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
