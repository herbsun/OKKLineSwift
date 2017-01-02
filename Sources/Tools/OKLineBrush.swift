//
//  OKKLineSwift
//
//  Copyright © 2016年 Herb - https://github.com/Herb-Sun/OKKLineSwift
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import CoreGraphics

class OKLineBrush {
    
    public var indicatorType: OKIndicatorType
    private var configuration: OKConfiguration
    private var context: CGContext
    private var firstValueIndex: Int?
    
    public var calFormula: ((Int, OKKLineModel) -> CGPoint?)?
    
    init(indicatorType: OKIndicatorType, context: CGContext, configuration: OKConfiguration) {
        self.indicatorType = indicatorType
        self.context = context
        self.configuration = configuration
        
        context.setLineWidth(configuration.theme.indicatorLineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        switch indicatorType {
        case .DIF:
            context.setStrokeColor(configuration.theme.DIFColor.cgColor)
        case .DEA:
            context.setStrokeColor(configuration.theme.DEAColor.cgColor)
        case .KDJ_K:
            context.setStrokeColor(configuration.theme.KDJ_KColor.cgColor)
        case .KDJ_D:
            context.setStrokeColor(configuration.theme.KDJ_DColor.cgColor)
        case .KDJ_J:
            context.setStrokeColor(configuration.theme.KDJ_JColor.cgColor)
        case .BOLL_MB:
            context.setStrokeColor(configuration.theme.BOLL_MBColor.cgColor)
        case .BOLL_UP:
            context.setStrokeColor(configuration.theme.BOLL_UPColor.cgColor)
        case .BOLL_DN:
            context.setStrokeColor(configuration.theme.BOLL_DNColor.cgColor)
        default: break
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
