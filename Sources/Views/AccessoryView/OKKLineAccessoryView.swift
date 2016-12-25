//
//  OKKLineAccessoryView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif

class OKKLineAccessoryView: OKView {
    
    // MARK: - Property
    public var limitValueChanged: ((_ limitValue: (minValue: Double, maxValue: Double)?) -> Void)?

    private var configuration: OKConfiguration!
    private var accessoryDrawKLineModels: [OKKLineModel]?
    private var drawAssistString: NSAttributedString?
    
    private var drawMaxY: CGFloat {
        get {
            return bounds.height
        }
    }
    private var drawHeight: CGFloat {
        get {
            return bounds.height - configuration.accessory.topViewHeight
        }
    }
    
    
    private var drawIndicationModels: [OKKLineModel] {
        get {
            let kdjModel = OKKDJModel(klineModels: configuration.dataSource.klineModels)
            return kdjModel.fetchDrawKDJData(drawRange: configuration.dataSource.drawRange)
        }
    }

    convenience init(configuration: OKConfiguration) {
        self.init()
        self.configuration = configuration
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func drawAccessoryView() {
        
        fetchAccessoryDrawKLineModels()
        setNeedsDisplay()
    }
    
    public func drawAssistView(model: OKKLineModel?) {
        
        fetchAssistString(model: model)
        let displayRect = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: configuration.accessory.topViewHeight)
        
        setNeedsDisplay(displayRect)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.accessoryViewBgColor.cgColor)
        context.fill(rect)
        
        // 没有数据 不绘制
        guard let accessoryDrawKLineModels = accessoryDrawKLineModels else {
            return
        }
        
        guard __CGPointEqualToPoint(rect.origin, bounds.origin) &&
            __CGSizeEqualToSize(rect.size, bounds.size)
            else {
                
                drawAssistString?.draw(in: rect)
                return
        }
        
        fetchAssistString(model: accessoryDrawKLineModels.last!)
        drawAssistString?.draw(in: rect)
        
        switch configuration.accessory.indicatorType {
        case .MACD:
            drawMACD(context: context, drawModels: accessoryDrawKLineModels)
            
        case .KDJ:
            drawKDJ(context: context, drawModels: accessoryDrawKLineModels)
            
        default:
            break
        }
    }

    
    
    // MARK: - Private
    
    private func fetchAssistString(model: OKKLineModel?) {
        
        guard let accessoryDrawKLineModels = accessoryDrawKLineModels else { return }
        
        var drawModel = accessoryDrawKLineModels.last!
        
        if let model = model {
            for accessoryModel in accessoryDrawKLineModels {
                if model.date == accessoryModel.date {
                    drawModel = accessoryModel
                    break
                }
            }
        }
        
        let drawAttrsString = NSMutableAttributedString()
        switch configuration.accessory.indicatorType {
        case .MACD:
            let attrs: [String : Any] = [
                NSForegroundColorAttributeName : configuration.assistTextColor,
                NSFontAttributeName : configuration.assistTextFont
            ]
            drawAttrsString.append(NSAttributedString(string: "MACD(12,26,9) ", attributes: attrs))
            
            
            if let dif = drawModel.DIF {
                let difAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.DIFColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let difAttrsStr = NSAttributedString(string: String(format: "DIF: %.2f ", dif), attributes: difAttrs)
                drawAttrsString.append(difAttrsStr)
            }
            if let dea = drawModel.DEA {
                let deaAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.DEAColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let deaAttrsStr = NSAttributedString(string: String(format: "DEA: %.2f ", dea), attributes: deaAttrs)
                drawAttrsString.append(deaAttrsStr)
            }
            if let macd = drawModel.MACD {
                
                let macdAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.MACDColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let macdAttrsStr = NSAttributedString(string: String(format: "MACD: %.2f ", macd), attributes: macdAttrs)
                drawAttrsString.append(macdAttrsStr)
            }
            
        case .KDJ:
            
            let attrs: [String : Any] = [
                NSForegroundColorAttributeName : configuration.assistTextColor,
                NSFontAttributeName : configuration.assistTextFont
            ]
            drawAttrsString.append(NSAttributedString(string: "KDJ(9,3,3) ", attributes: attrs))
            
            if let value = drawModel.KDJ_K {
                let kAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.KDJ_KColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let kAttrsStr = NSAttributedString(string: String(format: "K: %.2f ", value), attributes: kAttrs)
                drawAttrsString.append(kAttrsStr)
            }
            if let value = drawModel.KDJ_D {
                let dAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.KDJ_DColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let dAttrsStr = NSAttributedString(string: String(format: "D: %.2f ", value), attributes: dAttrs)
                drawAttrsString.append(dAttrsStr)
            }
            if let value = drawModel.KDJ_J {
                let jAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.KDJ_JColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let jAttrsStr = NSAttributedString(string: String(format: "J: %.2f ", value), attributes: jAttrs)
                drawAttrsString.append(jAttrsStr)
            }
            
        default:
            break
        }
        drawAssistString = drawAttrsString
    }

    // MARK: 绘制MACD
    private func drawMACD(context: CGContext, drawModels: [OKKLineModel]) {
        
        guard let limitValue = fetchLimitValue() else {
            return
        }
        
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        let middleY = drawMaxY - CGFloat(abs(limitValue.minValue) / unitValue)
        
        // 画柱状图
        for (index, model) in drawModels.enumerated() {
            
            let xPosition = CGFloat(index) * (configuration.klineWidth + configuration.klineSpace) +
                configuration.klineWidth * 0.5 + configuration.klineSpace
            
            var startPoint = CGPoint(x: xPosition, y: middleY)
            var endPoint = CGPoint(x: xPosition, y: middleY)
            if let macd = model.MACD {
                
                let offsetValue = CGFloat(abs(macd) / unitValue)
                
                startPoint.y = macd > 0 ? middleY - offsetValue : middleY
                endPoint.y = macd > 0 ? middleY : middleY + offsetValue
                
                context.setStrokeColor(macd > 0 ? configuration.increaseColor.cgColor : configuration.decreaseColor.cgColor)
                context.setLineWidth(configuration.klineWidth)
                context.strokeLineSegments(between: [startPoint, endPoint])
            }
        }
        context.strokePath()
        
        // 画DIF线
        let difLineBrush = OKLineBrush(indicatorType: .DIF,
                                       context: context,
                                       configuration: configuration)
        difLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
        
            let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
            if let value = model.DIF {
                let yPosition = CGFloat(-(value) / unitValue) + middleY
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        difLineBrush.draw(drawModels: drawModels)
        
        // 画DEA线
        let deaLineBrush = OKLineBrush(indicatorType: .DEA,
                                       context: context,
                                       configuration: configuration)
        deaLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.DEA {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition = CGFloat(-(value) / unitValue) + middleY
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        deaLineBrush.draw(drawModels: drawModels)
    }
    
    // MARK: 绘制KDJ
    private func drawKDJ(context: CGContext, drawModels: [OKKLineModel]) {
        guard let limitValue = fetchLimitValue() else { return }
        
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        let KDJ_KLineBrush = OKLineBrush(indicatorType: .KDJ_K, context: context, configuration: configuration)
        KDJ_KLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.KDJ_K {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        KDJ_KLineBrush.draw(drawModels: drawModels)
        
        let KDJ_DLineBrush = OKLineBrush(indicatorType: .KDJ_D, context: context, configuration: configuration)
        KDJ_DLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.KDJ_D {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        KDJ_DLineBrush.draw(drawModels: drawModels)
        
        let KDJ_JLineBrush = OKLineBrush(indicatorType: .KDJ_J, context: context, configuration: configuration)
        KDJ_JLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.KDJ_J {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        KDJ_JLineBrush.draw(drawModels: drawModels)
    }
    
    private func fetchAccessoryDrawKLineModels() {
        
        guard configuration.dataSource.klineModels.count > 0 else {
            accessoryDrawKLineModels = nil
            return
        }
        
        switch configuration.accessory.indicatorType {
        case .MACD:
            let macdModel = OKMACDModel(klineModels: configuration.dataSource.klineModels)
            accessoryDrawKLineModels = macdModel.fetchDrawMACDData(drawRange: configuration.dataSource.drawRange)
        
        case .KDJ:
            let kdjModel = OKKDJModel(klineModels: configuration.dataSource.klineModels)
            accessoryDrawKLineModels = kdjModel.fetchDrawKDJData(drawRange: configuration.dataSource.drawRange)
        
        default:
            break
        }
    }
    
    // MARK: - 获取指标数据最大最小值
    private func fetchLimitValue() -> (minValue: Double, maxValue: Double)? {
        
        guard let accessoryDrawKLineModels = accessoryDrawKLineModels else {
            return nil
        }
        
        var minValue = 0.0
        var maxValue = 0.0
        
        switch configuration.accessory.indicatorType {
        case .MACD:
            for model in accessoryDrawKLineModels {
                if let value = model.DIF {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.DEA {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.MACD {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
            }

        case .KDJ:
            
            for model in accessoryDrawKLineModels {
                            
                if let value = model.KDJ_K {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                
                if let value = model.KDJ_D {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.KDJ_J {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
            }
            
        default:
            break
        }
        limitValueChanged?((minValue, maxValue))
        return (minValue, maxValue)
    }
}
