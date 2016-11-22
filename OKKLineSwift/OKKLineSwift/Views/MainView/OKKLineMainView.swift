//
//  OKKLineMainView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

class OKKLineMainView: UIView {
    
    // MARK: - Property
    public var startXPosition: CGFloat = 0.0
    
    private let configuration = OKConfiguration.shared
    private var drawPositionModels = [OKKLinePositionModel]()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let ctx = UIGraphicsGetCurrentContext()
        // 背景色
        ctx?.clear(rect)
        ctx?.setFillColor(configuration.mainViewBgColor)
        ctx?.fill(rect)
        
        // 没有数据 不绘制
        guard drawPositionModels.count > 0 else {
            return
        }
        
        // 设置日期背景色
        ctx?.setFillColor(configuration.assistViewBgColor)
        let assistRect = CGRect(x: 0,
                                y: frame.height - configuration.mainBottomAssistViewHeight,
                                width: frame.width,
                                height: configuration.mainBottomAssistViewHeight)
        ctx?.fill(assistRect)
        
        var lastDrawDatePoint = CGPoint.zero
        
        let dateAttributes: [String : Any] = [
            NSForegroundColorAttributeName : UIColor(cgColor: configuration.assistTextColor),
            NSFontAttributeName : configuration.assistTextFont
        ]
        
        // 绘制指标数据
        drawMAView(model: configuration.drawKLineModels.last!)
        
        switch configuration.klineType {
        case .KLine: // K线模式

            for (idx, positionModel) in drawPositionModels.enumerated() {
                
                let klineModel: OKKLineModel = configuration.drawKLineModels[idx]
                
                // 决定K线颜色
                let strokeColor = positionModel.openPoint.y < positionModel.closePoint.y ?
                    configuration.increaseColor : configuration.decreaseColor
                ctx?.setStrokeColor(strokeColor)
                
                // 画开盘-收盘
                ctx?.setLineWidth(configuration.klineWidth)
                ctx?.strokeLineSegments(between: [positionModel.openPoint, positionModel.closePoint])
                
                // 画上下影线
                ctx?.setLineWidth(configuration.klineShadowLineWidth)
                ctx?.strokeLineSegments(between: [positionModel.highPoint, positionModel.lowPoint])
                
                // 画日期
                let date = Date(timeIntervalSince1970: klineModel.date/1000)
                let dateString = configuration.dateFormatter.string(from: date)
                let drawDatePoint = CGPoint(x: positionModel.closePoint.x + 1,
                                            y: frame.height - configuration.mainBottomAssistViewHeight)
                
                if lastDrawDatePoint.equalTo(CGPoint.zero) ||
                    abs(drawDatePoint.x - lastDrawDatePoint.x) > 60 {
                
                    (dateString as NSString).draw(at: drawDatePoint, withAttributes: dateAttributes)
                    
                    lastDrawDatePoint = drawDatePoint
                }
            }
            
        case .timeLine: // 分时线模式
            
            for (idx, positionModel) in drawPositionModels.enumerated() {
                
                let klineModel: OKKLineModel = configuration.drawKLineModels[idx]
                
                // 决定K线颜色
                let strokeColor = positionModel.openPoint.y < positionModel.closePoint.y ?
                    configuration.increaseColor : configuration.decreaseColor
                ctx?.setStrokeColor(strokeColor)
                
                // 画线
                ctx?.setLineWidth(configuration.realtimeLineWidth)
                ctx?.setStrokeColor(configuration.realtimeLineColor)
                if idx == 0 { // 处理第一个点
                    ctx?.move(to: positionModel.closePoint)
                } else {
                    ctx?.addLine(to: positionModel.closePoint)
                }
                ctx?.strokePath()
                
                // 画日期
                let date = Date(timeIntervalSince1970: klineModel.date/1000)
                let dateString = configuration.dateFormatter.string(from: date)
                let drawDatePoint = CGPoint(x: positionModel.lowPoint.x + 1,
                                            y: frame.height - configuration.mainBottomAssistViewHeight)
                
                if lastDrawDatePoint.equalTo(CGPoint.zero) ||
                    drawDatePoint.x - lastDrawDatePoint.x > 60 {
                    
                    (dateString as NSString).draw(at: drawDatePoint, withAttributes: dateAttributes)
                    
                    lastDrawDatePoint = drawDatePoint
                }
            }
            
        default: break
        }
    }
    
    // MARK: - Public
    
    public func drawMainView() {
        
        fetchDrawPositionModels()
        setNeedsDisplay()
    }
    
    // MARK: - Private
    
    private func drawMAView(model: OKKLineModel) {
        
    }
    
    
    /// 获取位置模型
    ///
    /// - Returns: 位置模型数组
    private func fetchDrawPositionModels() {

        guard configuration.drawKLineModels.count > 0 else {
            return
        }
        
        let firstModel = configuration.drawKLineModels[0]
        
        var minAssert = firstModel.low
        var maxAssert = firstModel.high
        
        for (idx, model) in configuration.drawKLineModels.enumerated() {
            
            if model.low < minAssert {
                minAssert = model.low
            }
            
            if model.high > maxAssert {
                maxAssert = model.high
            }
            
            // TODO: MA指标计算
            
        }
        
        minAssert *= 0.9991
        maxAssert *= 1.0001
        
//        CGFloat yUnitValue = (_maxPrice - _minPrice) / (maxFrameY - minFrameY);
//        yPosition = (maxFrameY - (timeLineModel.price - _minPrice) / yUnitValue);
        
        let maxY = bounds.height - configuration.mainTopAssistViewHeight
        
        let unitValue = (maxAssert - minAssert) / Double((maxY - configuration.mainTopAssistViewHeight))
        
        drawPositionModels.removeAll()
        
        for (idx, model) in configuration.drawKLineModels.enumerated().reversed() {
            
            let xPosition = startXPosition + CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace)
            let openPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.open - minAssert) / unitValue)))
            let closePoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.close - minAssert) / unitValue)))
            let hightPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.high - minAssert) / unitValue)))
            let lowPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.low - minAssert) / unitValue)))
            
            let positionModel = OKKLinePositionModel(openPoint: openPoint,
                                                     closePoint: closePoint,
                                                     highPoint: hightPoint,
                                                     lowPoint: lowPoint)
            
            drawPositionModels.append(positionModel)
            // TODO: MA坐标转换
        }
        
    }
}
