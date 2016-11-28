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
    
    public var lineType: OKIndexLineType = .MA
    public var positionModels: [OKKLinePositionModel]?
    
    private var context: CGContext?
    
    init(context: CGContext?, positionModels: [OKKLinePositionModel]?) {
        self.context = context
        self.positionModels = positionModels
    }
    
    public func draw() {
        
        guard let positionModels = positionModels,
            let context = context else {
            return
        }
        
        // 画MA线
        context.setStrokeColor(OKConfiguration.shared.MA7Color)
        context.setLineWidth(OKConfiguration.shared.MALineWidth)
        
        var firstValueIndex: Int?
        
        for (idx, positionModel) in positionModels.enumerated() {
            
            if positionModel.MA5Point != nil {
                if firstValueIndex == nil {
                    firstValueIndex = idx
                }
                
                if firstValueIndex == idx {
                    context.move(to: positionModel.MA5Point!)
                } else {
                    context.addLine(to: positionModel.MA5Point!)
                }
            }
        }
        context.strokePath()
    }
}
