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

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif

class OKValueView: OKView {
    
    public var limitValue: (minValue: Double, maxValue: Double)? {
        didSet {
            okSetNeedsDisplay()
        }
    }
    
    public var currentValueDrawPoint: CGPoint? {
        didSet {
            okSetNeedsDisplay()
        }
    }

    private let configuration = OKConfiguration.sharedConfiguration
    private var drawEdgeInsets: OKEdgeInsets!
    private var limitValueAttrs: [NSAttributedStringKey : Any]?!
    private var currentValueAttrs: [NSAttributedStringKey : Any]?!
    private let separate: CGFloat = 20.0
    
    convenience init(drawEdgeInsets: OKEdgeInsets) {
        self.init()
        self.drawEdgeInsets = drawEdgeInsets
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        
        limitValueAttrs = [
            NSAttributedStringKey.foregroundColor : configuration.value.textColor,
            NSAttributedStringKey.font : configuration.value.textFont,
            NSAttributedStringKey.paragraphStyle : textStyle
        ]
        
        currentValueAttrs = [
            NSAttributedStringKey.foregroundColor : configuration.value.textColor,
            NSAttributedStringKey.font : configuration.value.textFont,
            NSAttributedStringKey.paragraphStyle : textStyle,
        ]

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = OKGraphicsGetCurrentContext() else {
            return
        }
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.value.backgroundColor.cgColor)
        context.fill(rect)
        
        guard let limitValue = limitValue else {
            return
        }
        
        let valueHeight: CGFloat = configuration.value.textFont.lineHeight
        let drawHeight = rect.height - drawEdgeInsets.top - drawEdgeInsets.bottom
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        let drawMaxY = rect.height - drawEdgeInsets.bottom
        
        // 四舍五入
        let separateCount: Int = Int(drawHeight / separate + 0.5)
        
        for i in 0..<separateCount {
            
            let drawY = CGFloat(i) * separate + drawEdgeInsets.top
            
            let drawValue = Double(drawMaxY - drawY) * unitValue + limitValue.minValue
            
            let valueStr = String(format: "%.2f", drawValue)
            let valueAttrStr = NSAttributedString(string: valueStr, attributes: limitValueAttrs)
            
            let y = drawY - valueHeight * 0.5
            let drawRect = CGRect(x: 0, y: y, width: rect.width, height: valueHeight)
            valueAttrStr.draw(in: drawRect)
        }
        
        if let currentValueDrawPoint = currentValueDrawPoint {
            
            let drawCurrentValue = Double(drawMaxY - currentValueDrawPoint.y) * unitValue + limitValue.minValue
            
            let currentValueStr = String(format: "%.2f", drawCurrentValue)
            let currentValueAttrStr = NSAttributedString(string: currentValueStr, attributes: currentValueAttrs)
            
            var y = currentValueDrawPoint.y - valueHeight * 0.5
            if y < 0 {
                y = 0
            } else if y > rect.height - valueHeight {
                y = rect.height - valueHeight
            }

            let drawRect = CGRect(x: 0, y: y, width: rect.width, height: valueHeight)
            
            // 画指示背景
            context.setFillColor(configuration.value.backgroundColor.cgColor)
            context.fill(drawRect)
            
            // 画指示框
            context.setStrokeColor(OKColor.white.cgColor)
            context.stroke(drawRect)

            currentValueAttrStr.draw(in: drawRect)
        }
    }
}
