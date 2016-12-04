//
//  OKKLineAccessoryView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class OKKLineAccessoryView: OKView {
    
    // MARK: - Property
    private let configuration = OKConfiguration.shared
    private var drawColors = [CGColor]()
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
    
    private var drawIndicationDatas:[[Double?]] {
        get {
            guard configuration.dataSource.drawKLineModels.count > 0 else {
                return []
            }
            
            var datas: [[Double?]] = []
            
            switch configuration.accessoryindicatorType {
            case .MACD:
                let macdModel = OKMACDModel(klineModels: configuration.dataSource.klineModels)
                datas =  macdModel.fetchDrawMACDData(drawRange: configuration.dataSource.drawRange)
            default:
                break
            }
            return datas
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        assistInfoLabel = UILabel()
        assistInfoLabel.font = UIFont.systemFont(ofSize: 11)
        assistInfoLabel.textColor = UIColor(cgColor: configuration.assistTextColor)
        addSubview(assistInfoLabel)
        assistInfoLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(configuration.accessoryTopViewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func drawAccessoryView() {
//        fetchDrawAccessoryPositionModels()
        setNeedsDisplay()
    }
    
    public func drawAssistView(model: OKKLineModel?) {
        
        
        let drawModel = model == nil ? configuration.dataSource.drawKLineModels.last! : model!
        
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
        assistInfoLabel.attributedText = NSAttributedString(string: string, attributes: attrs)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard configuration.dataSource.klineModels.count > 0 else {
                return
        }
        
        let context = UIGraphicsGetCurrentContext()
        // 背景色
        context?.clear(rect)
        context?.setFillColor(configuration.accessoryViewBgColor)
        context?.fill(rect)
        
//        drawAssistView(model: nil)

        switch configuration.accessoryindicatorType {
        case .MACD:
            drawMACD(context: context)
        default:
            break
        }
    }
    
    // MARK: - Private
    private func drawMACD(context: CGContext?) {
        
        guard let limitValue = fetchLimitValue() else { return }
        
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        let middleY = drawMaxY - CGFloat(abs(limitValue.minValue) / unitValue)
        
        if drawIndicationDatas.count == 3 {
            for (idx, value) in drawIndicationDatas[2].enumerated() {
                
                let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                    configuration.klineWidth * 0.5 + configuration.klineSpace
                
                var startPoint = CGPoint(x: xPosition, y: middleY)
                var endPoint = CGPoint(x: xPosition, y: middleY)
                if let macd = value {
                    
                    let offsetValue = CGFloat(abs(macd) / unitValue)
                    let startYPosition = macd > 0 ? middleY - offsetValue : middleY
                    let endYPosition = macd > 0 ? middleY : middleY + offsetValue
                    startPoint = CGPoint(x: xPosition, y: startYPosition)
                    endPoint = CGPoint(x: xPosition, y: endYPosition)
                    
                    context?.setStrokeColor(macd > 0 ? configuration.increaseColor : configuration.decreaseColor)
                    context?.setLineWidth(configuration.klineWidth)
                    context?.strokeLineSegments(between: [startPoint, endPoint])
                }
            }
            context?.strokePath()
            // 画指标线
            for (idx, datas) in drawIndicationDatas.enumerated() {
                if idx == 2 { return }
                
                var points: [CGPoint?] = []
                
                for (idx, value) in datas.enumerated() {
                    if let value = value {
                        let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                            configuration.klineWidth * 0.5 + configuration.klineSpace
                        points.append(CGPoint(x: xPosition, y: CGFloat(-(value) / unitValue) + middleY))
                    } else {
                        points.append(nil)
                    }
                }
                if idx == 0 {
                    let lineBrush = OKLineBrush(indicatorType: .DIF,
                                                context: context,
                                                drawPoints: points)
                    lineBrush.draw()
                    
                } else if idx == 1 {
                    let lineBrush = OKLineBrush(indicatorType: .DEA,
                                                context: context,
                                                drawPoints: points)
                    lineBrush.draw()
                }
            }
        }
    }
    
    
    private func fetchLimitValue() -> (minValue: Double, maxValue: Double)? {
        
        guard configuration.dataSource.drawKLineModels.count > 0 else {
            return nil
        }
        
        var minValue = 0.0
        var maxValue = 0.0
        
        // 求指标数据的最大最小
        for indicators in drawIndicationDatas {
            for value in indicators {
                if value != nil {
                    if value! > maxValue {
                        maxValue = value!
                    }
                    if value! < minValue {
                        minValue = value!
                    }
                }
            }
        }
        return (minValue, maxValue)
    }
}
