//
//  OKValueView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/16.
//
//

import UIKit

class OKValueView: OKView {
    
    public var limitValue: (minValue: Double, maxValue: Double)? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var configuration: OKConfiguration!
    private var valueAttrs: [String : Any]!
    private let separate: CGFloat = 20.0
    
    convenience init(configuration: OKConfiguration) {
        self.init()
        self.configuration = configuration
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .right
        
        valueAttrs = [
            NSForegroundColorAttributeName : configuration.valueViewTextColor,
            NSFontAttributeName : configuration.valueViewFont,
            NSParagraphStyleAttributeName : textStyle,
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
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.valueViewBgColor.cgColor)
        context.fill(rect)
        
        guard let limitValue = limitValue else {
            return
        }
        
        let valueHeight: CGFloat = configuration.valueViewFont.lineHeight
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(rect.height)
        // 四舍五入
        let separateCount: Int = Int((rect.height - valueHeight * 0.5) / separate + 0.5)
        
        for i in 1...separateCount {
            let drawY = CGFloat(i) * separate
            let drawValue = Double(drawY) * unitValue + limitValue.minValue
            
            let valueStr = String(format: "%.2f", drawValue)
            let valueAttrStr = NSAttributedString(string: valueStr, attributes: valueAttrs)
            
            let drawMaxY = rect.height - valueHeight * 0.5
            let y = drawMaxY - (drawY > drawMaxY ? drawMaxY : drawY)
            let drawRect = CGRect(x: 0, y: y, width: rect.width, height: valueHeight)
            valueAttrStr.draw(in: drawRect)
        }
    }
    
    public func drawNowValue() {
        
    }
}
