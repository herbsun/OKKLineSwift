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
    public var positionModels: [OKKLinePositionModel]?
    
    
    private var context: CGContext?
    
    init(indicatorType: OKIndicatorType = .MA(5), context: CGContext?, positionModels: [OKKLinePositionModel]?) {
        self.context = context
        self.positionModels = positionModels
        self.indicatorType = indicatorType
    }
    
    public func draw() {
        
        guard let positionModels = positionModels,
            let context = context else {
            return
        }
        
        context.setLineWidth(OKConfiguration.shared.MALineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
//        switch indicatorType {
//        case .MA5, .MA5_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA5Color)
//        case .MA7, .MA7_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA7Color)
//        case .MA10, .MA10_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA10Color)
//        case .MA12, .MA12_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA12Color)
//        case .MA20, .MA20_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA20Color)
//        case .MA26, .MA26_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA26Color)
//        case .MA30, .MA30_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA30Color)
//        case .MA60, .MA60_VOLUME:
//            context.setStrokeColor(OKConfiguration.shared.MA60Color)
//        default: break
//        }
        
        var firstValueIndex: Int?
        
//        for (idx, positionModel) in positionModels.enumerated() {
//            var drawPoint: CGPoint?
    
//            switch indicatorType {
//            case .MA5:          drawPoint = positionModel.MA5Point
//            case .MA5_VOLUME:   drawPoint = positionModel.MA5_VOLUMEPoint
//            case .MA7:          drawPoint = positionModel.MA7Point
//            case .MA7_VOLUME:   drawPoint = positionModel.MA7_VOLUMEPoint
//            case .MA10:         drawPoint = positionModel.MA10Point
//            case .MA10_VOLUME:  drawPoint = positionModel.MA10_VOLUMEPoint
//            case .MA12:         drawPoint = positionModel.MA12Point
//            case .MA12_VOLUME:  drawPoint = positionModel.MA12_VOLUMEPoint
//            case .MA20:         drawPoint = positionModel.MA20Point
//            case .MA20_VOLUME:  drawPoint = positionModel.MA20_VOLUMEPoint
//            case .MA26:         drawPoint = positionModel.MA26Point
//            case .MA26_VOLUME:  drawPoint = positionModel.MA26_VOLUMEPoint
//            case .MA30:         drawPoint = positionModel.MA30Point
//            case .MA30_VOLUME:  drawPoint = positionModel.MA30_VOLUMEPoint
//            case .MA60:         drawPoint = positionModel.MA60Point
//            case .MA60_VOLUME:  drawPoint = positionModel.MA60_VOLUMEPoint
//            default: break
//            }
    
//            if drawPoint != nil {
//                if firstValueIndex == nil {
//                    firstValueIndex = idx
//                }
//                
//                if firstValueIndex == idx {
//                    context.move(to: drawPoint!)
//                } else {
//                    context.addLine(to: drawPoint!)
//                }
//            }
//        }
    
        context.strokePath()
    }
}
