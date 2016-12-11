//
//  OKMALineBrush.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/9.
//
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import CoreGraphics

enum OKBrushType {
    case MA(Int)
    case EMA(Int)
    case MA_VOLUME(Int)
    case EMA_VOLUME(Int)
}

class OKMALineBrush {
    
    public var calFormula: ((Int, OKKLineModel) -> CGPoint?)?
    public var brushType: OKBrushType
    private var configuration: OKConfiguration
    private var context: CGContext
    private var firstValueIndex: Int?
    

    init(brushType: OKBrushType, context: CGContext, configuration: OKConfiguration) {
        self.brushType = brushType
        self.context = context
        self.configuration = configuration
        
        context.setLineWidth(configuration.indicatorLineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        switch brushType {
        case .MA(let day):
            context.setStrokeColor(configuration.theme.MAColor(day: day).cgColor)
        case .EMA(let day):
            context.setStrokeColor(configuration.theme.EMAColor(day: day).cgColor)
        case .MA_VOLUME(let day):
            context.setStrokeColor(configuration.theme.MAColor(day: day).cgColor)
        case .EMA_VOLUME(let day):
            context.setStrokeColor(configuration.theme.EMAColor(day: day).cgColor)
        }
    }
    
    public func draw(drawModels: [OKKLineModel]) {
    
        for (index, model) in drawModels.enumerated() {
            
            if let point = calFormula?(index, model) {
                
                if firstValueIndex == nil {
                    firstValueIndex = index
                }
                
                if firstValueIndex == index {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
        }
        context.strokePath()
    }
}

