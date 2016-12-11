//
//  OKKLineAccessoryView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

class OKKLineAccessoryView: OKView {
    
    // MARK: - Property
    private var configuration: OKConfiguration!
    private var accessoryDrawKLineModels: [OKKLineModel]?
    private var assistInfoLabel: UILabel!
    private var drawMaxY: CGFloat {
        get {
            return bounds.height
        }
    }
    private var drawHeight: CGFloat {
        get {
            return bounds.height - configuration.accessoryTopViewHeight
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
        assistInfoLabel = UILabel()
        assistInfoLabel.font = UIFont.systemFont(ofSize: 11)
        assistInfoLabel.textColor = UIColor(cgColor: configuration.assistTextColor)
        addSubview(assistInfoLabel)
        assistInfoLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(configuration.accessoryTopViewHeight)
        }
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.accessoryViewBgColor)
        context.fill(rect)
        
        // 没有数据 不绘制
        guard let accessoryDrawKLineModels = accessoryDrawKLineModels else {
            return
        }
        
        drawAssistView(model: nil)
        
        switch configuration.accessoryindicatorType {
        case .MACD:
            drawMACD(context: context, drawModels: accessoryDrawKLineModels)
            
        case .KDJ:
            drawKDJ(context: context, drawModels: accessoryDrawKLineModels)
            
        default:
            break
        }
    }
    
    public func drawAssistView(model: OKKLineModel?) {
        
        
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
        switch configuration.accessoryindicatorType {
        case .MACD:
            var string = "MACD(12,26,9) "
            if let dif = drawModel.DIF {
                string += String(format: "DIF: %.2f ", dif)
            }
            if let dea = drawModel.DEA {
                string += String(format: "DEA: %.2f ", dea)
            }
            if let macd = drawModel.MACD {
                string += String(format: "MACD: %.2f ", macd)
            }
            let attrs: [String : Any] = [
                NSForegroundColorAttributeName : UIColor(cgColor: configuration.assistTextColor),
                NSFontAttributeName : configuration.assistTextFont
            ]
            drawAttrsString.append(NSAttributedString(string: string, attributes: attrs))
            
        case .KDJ:
            var string = "KDJ(9,3,3) "
            if let value = drawModel.KDJ_K {
                string += String(format: "K: %.2f ", value)
            }
            if let value = drawModel.KDJ_D {
                string += String(format: "D: %.2f ", value)
            }
            if let value = drawModel.KDJ_J {
                string += String(format: "J: %.2f ", value)
            }
            let attrs: [String : Any] = [
                NSForegroundColorAttributeName : UIColor(cgColor: configuration.assistTextColor),
                NSFontAttributeName : configuration.assistTextFont
            ]
            drawAttrsString.append(NSAttributedString(string: string, attributes: attrs))
            
        default:
            break
        }
        assistInfoLabel.attributedText = drawAttrsString
    }
    
    
    // MARK: - Private

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
                
                context.setStrokeColor(macd > 0 ? configuration.increaseColor : configuration.decreaseColor)
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
        
        let KDJ_JLineBrush = OKLineBrush(indicatorType: .KDJ_K, context: context, configuration: configuration)
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
        
        switch configuration.accessoryindicatorType {
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
        
        switch configuration.accessoryindicatorType {
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
        
        return (minValue, maxValue)
    }
}
