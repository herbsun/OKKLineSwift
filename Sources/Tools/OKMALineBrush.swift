//
//  OKMALineBrush.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/30.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class OKMALineBrush {
    
    public var indicatorType: OKIndicatorType = .MA_VOLUME(5)
    public var positionModels: [OKIndicatorPositionModel]?
    
    private var context: CGContext?
    
    init(indicatorType: OKIndicatorType = .MA_VOLUME(5), context: CGContext?, positionModels: [OKIndicatorPositionModel]?) {
        self.context = context
        self.positionModels = positionModels
        self.indicatorType = indicatorType
    }
    
    public func draw() {
        
//        guard let positionModels = positionModels,
//            let context = context else {
//                return
//        }
//        
//        context.setLineWidth(OKConfiguration.shared.MALineWidth)
//        context.setLineCap(.round)
//        context.setLineJoin(.round)
//        
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
//        case .DIF:
//            context.setStrokeColor(OKConfiguration.shared.MA5Color)
//        case .DEA:
//            context.setStrokeColor(OKConfiguration.shared.MA7Color)
//        default: break
//        }
//        
//        var firstValueIndex: Int?
//        
//        for (idx, positionModel) in positionModels.enumerated() {
//            var drawPoint: CGPoint?
//            
//            switch indicatorType {
//            case .MA5_VOLUME:   drawPoint = positionModel.MA5_VOLUMEPoint
//            case .MA7_VOLUME:   drawPoint = positionModel.MA7_VOLUMEPoint
//            case .MA10_VOLUME:  drawPoint = positionModel.MA10_VOLUMEPoint
//            case .MA12_VOLUME:  drawPoint = positionModel.MA12_VOLUMEPoint
//            case .MA20_VOLUME:  drawPoint = positionModel.MA20_VOLUMEPoint
//            case .MA26_VOLUME:  drawPoint = positionModel.MA26_VOLUMEPoint
//            case .MA30_VOLUME:  drawPoint = positionModel.MA30_VOLUMEPoint
//            case .MA60_VOLUME:  drawPoint = positionModel.MA60_VOLUMEPoint
//            case .DIF:   drawPoint = positionModel.DIFPoint
//            case .DEA:   drawPoint = positionModel.DEAPoint
//            default: break
//            }
//            
//            
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
//        
//        context.strokePath()
    }
}
