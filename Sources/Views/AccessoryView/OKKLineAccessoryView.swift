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
    private var drawIndicatorPositionModels = [OKIndicatorPositionModel]()
    private let configuration = OKConfiguration.shared
    private var drawColors = [CGColor]()
    
    private var assistInfoLabel: UILabel!
    
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
        fetchDrawAccessoryPositionModels()
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
        
        let context = UIGraphicsGetCurrentContext()
        // 背景色
        context?.clear(rect)
        context?.setFillColor(configuration.accessoryViewBgColor)
        context?.fill(rect)
        
        guard drawIndicatorPositionModels.count > 0 else { return }
        
        drawAssistView(model: nil)
        
        for (idx, positionModel) in drawIndicatorPositionModels.enumerated() {
            context?.setLineWidth(configuration.klineWidth)
            context?.setStrokeColor(drawColors[idx])
            context?.strokeLineSegments(between: [positionModel.startPoint, positionModel.endPoint])
        }
        
        // 画指标线
        let lineBrush = OKMALineBrush(context: context, positionModels: drawIndicatorPositionModels)
        for indicatorType in configuration.accessoryindicatorTypes {
            lineBrush.indicatorType = indicatorType
            lineBrush.draw()
        }
    }

    private func fetchDrawAccessoryPositionModels() {
        guard configuration.dataSource.drawKLineModels.count > 0 else { return }
        
        var minValue: Double = 0.0
        var maxValue: Double = 0.0
        
        drawColors.removeAll()
        
        for klineModel in configuration.dataSource.drawKLineModels {
  
            if let dif = klineModel.DIF {
                if dif > maxValue {
                    maxValue = dif
                }
                if dif < minValue {
                    minValue = dif
                }
            }
            
            if let dea = klineModel.DEA {
                if dea > maxValue {
                    maxValue = dea
                }
                if dea < minValue {
                    minValue = dea
                }
            }
            
            if let macd = klineModel.MACD {
                if macd > maxValue {
                    maxValue = macd
                }
                if macd < minValue {
                    minValue = macd
                }
                let color = macd > 0 ? configuration.increaseColor : configuration.decreaseColor
                drawColors.append(color)
            } else {
                drawColors.append(configuration.assistViewBgColor)
            }
        }
        
        let maxY = bounds.height
        let drawHeight = maxY - configuration.mainTopAssistViewHeight
        let unitValue = (maxValue - minValue) / Double(drawHeight)
        
        let middleY = maxY - CGFloat(abs(minValue) / unitValue)
        
        drawIndicatorPositionModels.removeAll()
        
        for (idx, klineModel) in configuration.dataSource.drawKLineModels.enumerated() {
            
            let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                configuration.klineWidth * 0.5 + configuration.klineSpace
            
            let startPoint = CGPoint(x: xPosition, y: middleY)
            let endPoint = CGPoint(x: xPosition, y: middleY)
            let positionModel = OKIndicatorPositionModel(startPoint: startPoint, endPoint: endPoint)
            
            if let macd = klineModel.MACD {
                
                let offsetValue = CGFloat(abs(macd) / unitValue)
                let startYPosition = macd > 0 ? middleY - offsetValue : middleY
                let endYPosition = macd > 0 ? middleY : middleY + offsetValue

                positionModel.startPoint = CGPoint(x: xPosition, y: startYPosition)
                positionModel.endPoint = CGPoint(x: xPosition, y: endYPosition)
            }
            
            
            // TODO: 坐标转换
            var DIFPoint: CGPoint?
            var DEAPoint: CGPoint?
            
            if let dif = klineModel.DIF {
                DIFPoint = CGPoint(x: xPosition, y: CGFloat(-(dif) / unitValue) + middleY)
            }
            if let dea = klineModel.DEA {
                DEAPoint = CGPoint(x: xPosition, y: CGFloat(-(dea) / unitValue) + middleY)
            }
            
            positionModel.DIFPoint = DIFPoint
            positionModel.DEAPoint = DEAPoint
      
            drawIndicatorPositionModels.append(positionModel)
        }
    }
}
