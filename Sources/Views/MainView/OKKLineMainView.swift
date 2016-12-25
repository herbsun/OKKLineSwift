//
//  OKKLineMainView.swift
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
import CoreGraphics

class OKKLineMainView: OKView {
    
    // MARK: - Property
    public var limitValueChanged: ((_ limitValue: (minValue: Double, maxValue: Double)?) -> Void)?
    
    private var configuration: OKConfiguration!
    
    private var lastDrawDatePoint: CGPoint = CGPoint.zero
    
    private var drawAssistString: NSAttributedString?
    
    private var mainDrawKLineModels: [OKKLineModel]?
    
    private var drawMaxY: CGFloat {
        get {
            return bounds.height - configuration.mainBottomAssistViewHeight
        }
    }
    
    private var drawHeight: CGFloat {
        get {
            return bounds.height - configuration.mainTopAssistViewHeight - configuration.mainBottomAssistViewHeight
        }
    }

    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(configuration: OKConfiguration) {
        self.init()
        self.configuration = configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    public func drawMainView() {
        
        fetchMainDrawKLineModels()
        
        setNeedsDisplay()
    }
    
    /// 绘制辅助说明视图
    ///
    /// - Parameter model: 绘制的模型 如果为nil 取当前绘制最后一个模型
    public func drawAssistView(model: OKKLineModel?) {
        
        fetchAssistString(model: model)
        
        let displayRect = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: configuration.mainTopAssistViewHeight)

        setNeedsDisplay(displayRect)
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.mainViewBgColor.cgColor)
        context.fill(rect)
        
        // 没有数据 不绘制
        guard let mainDrawKLineModels = mainDrawKLineModels,
            let limitValue = fetchLimitValue() else {
                return
        }
        
        guard __CGPointEqualToPoint(rect.origin, bounds.origin) &&
            __CGSizeEqualToSize(rect.size, bounds.size)
        else {
        
            drawAssistString?.draw(in: rect)
            return
        }
        
        // 设置日期背景色
        context.setFillColor(configuration.assistViewBgColor.cgColor)
        let assistRect = CGRect(x: 0,
                                y: rect.height - configuration.mainBottomAssistViewHeight,
                                width: rect.width,
                                height: configuration.mainBottomAssistViewHeight)
        context.fill(assistRect)
        
        lastDrawDatePoint = CGPoint.zero
        
        // 绘制提示数据
        fetchAssistString(model: mainDrawKLineModels.last!)
        drawAssistString?.draw(in: rect)

        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        for (index, klineModel) in mainDrawKLineModels.enumerated() {
            let xPosition = CGFloat(index) * (configuration.klineWidth + configuration.klineSpace) +
                configuration.klineWidth * 0.5 + configuration.klineSpace
            
            let openPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.open - limitValue.minValue) / unitValue)))
            let closePoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.close - limitValue.minValue) / unitValue)))
            let highPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.high - limitValue.minValue) / unitValue)))
            let lowPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.low - limitValue.minValue) / unitValue)))
            
            switch configuration.klineType {
            case .KLine: // K线模式
                
                    // 决定K线颜色
                    let strokeColor = klineModel.open < klineModel.close ?
                        configuration.increaseColor : configuration.decreaseColor
                    context.setStrokeColor(strokeColor.cgColor)
                    
                    // 画开盘-收盘
                    context.setLineWidth(configuration.klineWidth)
                    context.strokeLineSegments(between: [openPoint, closePoint])
                    
                    // 画上下影线
                    context.setLineWidth(configuration.klineShadowLineWidth)
                    context.strokeLineSegments(between: [highPoint, lowPoint])
     
            case .timeLine: // 分时线模式
                // 画线
                context.setLineWidth(configuration.realtimeLineWidth)
                context.setStrokeColor(configuration.realtimeLineColor.cgColor)
                if index == 0 { // 处理第一个点
                    context.move(to: closePoint)
                } else {
                    context.addLine(to: closePoint)
                }

            default: break
            }
            
            // 画日期
            drawDateLine(klineModel: mainDrawKLineModels[index],
                         positionX: xPosition)
            
        }
        context.strokePath()
        
        // 绘制指标
        switch configuration.mainIndicatorType {
        case .MA(_):
            drawMA(context: context, limitValue: limitValue, drawModels: mainDrawKLineModels)
        case .EMA(_):
            drawEMA(context: context, limitValue: limitValue, drawModels: mainDrawKLineModels)
        case .BOLL(_):
            drawBOLL(context: context, limitValue: limitValue, drawModels: mainDrawKLineModels)
        default:
            break
        }
        
    }
    
    /// 画时间线
    ///
    /// - Parameters:
    ///   - klineModel: 数据模型
    ///   - positionModel: 位置模型
    private func drawDateLine(klineModel: OKKLineModel, positionX: CGFloat) {
        
        let date = Date(timeIntervalSince1970: klineModel.date/1000)
        let dateString = configuration.dateFormatter.string(from: date)
        
        let dateAttributes: [String : Any] = [
            NSForegroundColorAttributeName : configuration.assistTextColor,
            NSFontAttributeName : configuration.assistTextFont
        ]

        let dateAttrString = NSAttributedString(string: dateString, attributes: dateAttributes)
        
        let drawDatePoint = CGPoint(x: positionX - dateAttrString.size().width * 0.5,
                                    y: bounds.height - configuration.mainBottomAssistViewHeight)
        
        if drawDatePoint.x < 0 || (drawDatePoint.x + dateAttrString.size().width) > bounds.width {
            return
        }
        
        if lastDrawDatePoint.equalTo(CGPoint.zero) ||
            abs(drawDatePoint.x - lastDrawDatePoint.x) > (dateAttrString.size().width * 2) {
            
            let rect = CGRect(x: drawDatePoint.x,
                              y: drawDatePoint.y,
                              width: dateAttrString.size().width,
                              height: configuration.mainBottomAssistViewHeight)
            
            dateAttrString.draw(in: rect)
            lastDrawDatePoint = drawDatePoint
        }
    }

    
    // MARK: - Private
    
    private func fetchAssistString(model: OKKLineModel?) {
        
        guard let mainDrawKLineModels = mainDrawKLineModels else { return }
        
        var drawModel = mainDrawKLineModels.last!
        
        if let model = model {
            for mainModel in mainDrawKLineModels {
                if model.date == mainModel.date {
                    drawModel = mainModel
                    break
                }
            }
        }
        
        let drawAttrsString = NSMutableAttributedString()
        
        let date = Date(timeIntervalSince1970: drawModel.date/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = formatter.string(from: date) + " "
        
        let dateAttrs: [String : Any] = [
            NSForegroundColorAttributeName : configuration.assistTextColor,
            NSFontAttributeName : configuration.assistTextFont
        ]
        drawAttrsString.append(NSAttributedString(string: dateStr, attributes: dateAttrs))
        
        let openStr = String(format: "开: %.2f ", drawModel.open)
        let highStr = String(format: "高: %.2f ", drawModel.high)
        let lowStr = String(format: "低: %.2f ", drawModel.low)
        let closeStr = String(format: "收: %.2f ", drawModel.close)
        
        let string = openStr + highStr + lowStr + closeStr
        let attrs: [String : Any] = [
            NSForegroundColorAttributeName : configuration.assistTextColor,
            NSFontAttributeName : configuration.assistTextFont
        ]
        
        drawAttrsString.append(NSAttributedString(string: string, attributes: attrs))
        
        switch configuration.mainIndicatorType {
        case .MA(let days):
            
            for (idx, day) in days.enumerated() {
                
                let attrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.MAColor(day: day),
                    NSFontAttributeName : configuration.assistTextFont
                ]
                
                if let value = drawModel.MAs![idx] {
                    let maStr = String(format: "MA\(day): %.2f ", value)
                    drawAttrsString.append(NSAttributedString(string: maStr, attributes: attrs))
                }
            }
            
        case .EMA(let days):
            for (idx, day) in days.enumerated() {
                
                let attrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.EMAColor(day: day),
                    NSFontAttributeName : configuration.assistTextFont
                ]
                if let value = drawModel.MAs![idx] {
                    let maStr = String(format: "EMA\(day): %.2f ", value)
                    drawAttrsString.append(NSAttributedString(string: maStr, attributes: attrs))
                }
            }
        case .BOLL(_):
            
            //            let attrs: [String : Any] = [
            //                NSForegroundColorAttributeName : configuration.assistTextColor,
            //                NSFontAttributeName : configuration.assistTextFont
            //            ]
            //            drawAttrsString.append(NSAttributedString(string: "BOLL(\(day),2) ", attributes: attrs))
            
            if let value = drawModel.BOLL_UP {
                let upAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.BOLL_UPColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let upAttrsStr = NSAttributedString(string: String(format: "UP: %.2f ", value), attributes: upAttrs)
                drawAttrsString.append(upAttrsStr)
            }
            if let value = drawModel.BOLL_MB {
                let mbAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.BOLL_MBColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let mbAttrsStr = NSAttributedString(string: String(format: "MB: %.2f ", value), attributes: mbAttrs)
                drawAttrsString.append(mbAttrsStr)
            }
            if let value = drawModel.BOLL_DN {
                let dnAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.BOLL_DNColor,
                    NSFontAttributeName : configuration.assistTextFont
                ]
                let dnAttrsStr = NSAttributedString(string: String(format: "DN: %.2f ", value), attributes: dnAttrs)
                drawAttrsString.append(dnAttrsStr)
            }
            
        default:
            break
        }
        drawAssistString = drawAttrsString
    }
    
    private func drawMA(context: CGContext,
                        limitValue: (minValue: Double, maxValue: Double),
                        drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        switch configuration.mainIndicatorType {
        case .MA(let days):
            
            for (idx, day) in days.enumerated() {
                
                let maLineBrush = OKMALineBrush(brushType: .MA(day),
                                                context: context,
                                                configuration: configuration)
                
                maLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
                    
                    if let value = model.MAs?[idx] {
                    
                        let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                            self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                        
                        let yPosition = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                        
                        return CGPoint(x: xPosition, y: yPosition)
                    }
                    return nil
                }
                maLineBrush.draw(drawModels: drawModels)
            }
            
        default:
            break
        }
    }
    
    private func drawEMA(context: CGContext,
                         limitValue: (minValue: Double, maxValue: Double),
                         drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        switch configuration.mainIndicatorType {
        case .EMA(let days):
            
            for (idx, day) in days.enumerated() {
                
                let emaLineBrush = OKMALineBrush(brushType: .EMA(day),
                                                 context: context,
                                                 configuration: configuration)
                
                emaLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
                    
                    if let value = model.EMAs?[idx] {
                        
                        let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                            self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                        
                        let yPosition = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                        
                        return CGPoint(x: xPosition, y: yPosition)
                    }
                    return nil
                }
                emaLineBrush.draw(drawModels: drawModels)
            }
        default:
            break
        }
    }
    
    private func drawBOLL(context: CGContext,
                          limitValue: (minValue: Double, maxValue: Double),
                          drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        let MBLineBrush = OKLineBrush(indicatorType: .BOLL_MB, context: context, configuration: configuration)
        MBLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.BOLL_MB {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        MBLineBrush.draw(drawModels: drawModels)
        
        let UPLineBrush = OKLineBrush(indicatorType: .BOLL_UP, context: context, configuration: configuration)
        UPLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.BOLL_UP {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        UPLineBrush.draw(drawModels: drawModels)
        
        let DNLineBrush = OKLineBrush(indicatorType: .BOLL_DN, context: context, configuration: configuration)
        DNLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
            
            if let value = model.BOLL_DN {
                let xPosition = CGFloat(index) * (self.configuration.klineWidth + self.configuration.klineSpace) +
                    self.configuration.klineWidth * 0.5 + self.configuration.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        DNLineBrush.draw(drawModels: drawModels)

    }
    
    private func fetchMainDrawKLineModels() {
        
        guard configuration.dataSource.klineModels.count > 0 else {
            mainDrawKLineModels = nil
            return
        }
        
        switch configuration.mainIndicatorType {
        case .MA(_):
            let maModel = OKMAModel(indicatorType: configuration.mainIndicatorType,
                                    klineModels: configuration.dataSource.klineModels)
            mainDrawKLineModels = maModel.fetchDrawMAData(drawRange: configuration.dataSource.drawRange)
            
        case .EMA(_):
            let emaModel = OKEMAModel(indicatorType: configuration.mainIndicatorType,
                                      klineModels: configuration.dataSource.klineModels)
            mainDrawKLineModels = emaModel.fetchDrawEMAData(drawRange: configuration.dataSource.drawRange)
        case .BOLL(_):
            let bollModel = OKBOLLModel(indicatorType: configuration.mainIndicatorType,
                                        klineModels: configuration.dataSource.klineModels)
            mainDrawKLineModels = bollModel.fetchDrawBOLLData(drawRange: configuration.dataSource.drawRange)
        default:
            mainDrawKLineModels = configuration.dataSource.drawKLineModels
        }
    }
    
    private func fetchLimitValue() -> (minValue: Double, maxValue: Double)? {
        
        guard let mainDrawKLineModels = mainDrawKLineModels else {
            return nil
        }
        
        var minValue = mainDrawKLineModels[0].low
        var maxValue = mainDrawKLineModels[0].high
        
        // 先求K线数据的最大最小
        for model in mainDrawKLineModels {
            if model.low < minValue {
                minValue = model.low
            }
            if model.high > maxValue {
                maxValue = model.high
            }
            // 求指标数据的最大最小
            switch configuration.mainIndicatorType {
            case .MA(_):
                if let MAs = model.MAs {
                    for value in MAs {
                        if let value = value {
                            minValue = value < minValue ? value : minValue
                            maxValue = value > maxValue ? value : maxValue
                        }
                    }
                }
            case .EMA(_):
                if let EMAs = model.EMAs {
                    for value in EMAs {
                        if let value = value {
                            minValue = value < minValue ? value : minValue
                            maxValue = value > maxValue ? value : maxValue
                        }
                    }
                }
            case .BOLL(_):
                if let value = model.BOLL_MB {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                
                if let value = model.BOLL_UP {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
                if let value = model.BOLL_DN {
                    minValue = value < minValue ? value : minValue
                    maxValue = value > maxValue ? value : maxValue
                }
            
            default:
                break
            }
        }
        
        limitValueChanged?((minValue, maxValue))
        
        return (minValue, maxValue)
    }
}


