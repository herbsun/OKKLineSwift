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
    private let configuration = OKConfiguration.shared
    private var drawPositionModels = [OKKLinePositionModel]()
    private var assistInfoLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        assistInfoLabel = UILabel()
//        assistInfoLabel.font = UIFont.systemFont(ofSize: 11)
//        assistInfoLabel.textColor = UIColor(cgColor: configuration.assistTextColor)
//        addSubview(assistInfoLabel)
//        assistInfoLabel.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(configuration.mainTopAssistViewHeight)
////            make.width.equalTo(0)
//        }
        
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
        drawAssistView(model: configuration.drawKLineModels.last!)
        
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
                
                let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: configuration.mainBottomAssistViewHeight)
                
                let dateWidth: CGFloat = dateString.stringSize(maxSize: size, fontSize: 11.0).width
                
                let drawDatePoint = CGPoint(x: positionModel.closePoint.x - dateWidth * 0.5,
                                            y: bounds.height - configuration.mainBottomAssistViewHeight)
                
                if drawDatePoint.x < 0 || (drawDatePoint.x + dateWidth) > bounds.width {
                    continue
                }
                
                if lastDrawDatePoint.equalTo(CGPoint.zero) ||
                    abs(drawDatePoint.x - lastDrawDatePoint.x) > (dateWidth * 2) {
                
                    //(dateString as NSString).draw(at: drawDatePoint, withAttributes: dateAttributes)
                    let rect = CGRect(x: drawDatePoint.x,
                                      y: drawDatePoint.y,
                                      width: dateWidth,
                                      height: configuration.mainBottomAssistViewHeight)
                    
                    (dateString as NSString).draw(in: rect, withAttributes: dateAttributes)
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
                
                // 画日期
                let date = Date(timeIntervalSince1970: klineModel.date/1000)
                let dateString = configuration.dateFormatter.string(from: date)
                
                let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: configuration.mainBottomAssistViewHeight)
                
                let dateWidth: CGFloat = dateString.stringSize(maxSize: size, fontSize: 11.0).width
                
                let drawDatePoint = CGPoint(x: positionModel.closePoint.x - dateWidth * 0.5,
                                            y: bounds.height - configuration.mainBottomAssistViewHeight)
                
                if drawDatePoint.x < 0 || (drawDatePoint.x + dateWidth) > bounds.width {
                    continue
                }
                
                if lastDrawDatePoint.equalTo(CGPoint.zero) ||
                    abs(drawDatePoint.x - lastDrawDatePoint.x) > (dateWidth * 2) {
                    
                    //(dateString as NSString).draw(at: drawDatePoint, withAttributes: dateAttributes)
                    let rect = CGRect(x: drawDatePoint.x,
                                      y: drawDatePoint.y,
                                      width: dateWidth,
                                      height: configuration.mainBottomAssistViewHeight)
                    
                    (dateString as NSString).draw(in: rect, withAttributes: dateAttributes)
                    lastDrawDatePoint = drawDatePoint
                }
            }
            ctx?.strokePath()
            
        default: break
        }
    }
    
    // MARK: - Public
    
    public func drawMainView() {
        
        fetchDrawPositionModels()
        setNeedsDisplay()
    }
    
    public func drawAssistView(model: OKKLineModel?) {
        
        guard let model = model else { return }
        
        let date = Date(timeIntervalSince1970: model.date/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = formatter.string(from: date) + "  "
        
        let openStr = String(format: "%.2f", model.open)
        let closeStr = String(format: "%.2f", model.close)
        let highStr = String(format: "%.2f", model.high)
        let lowStr = String(format: "%.2f", model.low)
        
        let string = openStr + closeStr + highStr + lowStr

        let dateAttrs: [String : Any] = [
            NSForegroundColorAttributeName : UIColor.red,
            NSFontAttributeName : configuration.assistTextFont
        ]

        
        let attrs: [String : Any] = [
            NSForegroundColorAttributeName : UIColor(cgColor: configuration.assistTextColor),
            NSFontAttributeName : configuration.assistTextFont
        ]
        
        let dateAttrsString =  NSMutableAttributedString(string: dateStr, attributes: dateAttrs)
        
        let assistAttrsString = NSAttributedString(string: string, attributes: attrs)
        
        dateAttrsString.append(assistAttrsString)
        
        dateAttrsString.draw(at: CGPoint(x: 0, y: 0))
//        dateAttrsString.draw(in: CGRect(x: 0, y: 0, width: bounds.width, height: 100))
//        assistInfoLabel.attributedText = NSAttributedString(string: string, attributes: attrs)
    }
    
    // MARK: - Private
    
    /// 获取位置模型
    ///
    /// - Returns: 位置模型数组
    private func fetchDrawPositionModels() {

        guard configuration.drawKLineModels.count > 0 else {
            return
        }
        
        let firstModel = configuration.drawKLineModels[0]
        
        var lowest = firstModel.low
        var highest = firstModel.high
        
        for (idx, model) in configuration.drawKLineModels.enumerated() {
            
            if model.low < lowest {
                lowest = model.low
            }
            
            if model.high > highest {
                highest = model.high
            }
            
            // TODO: MA指标计算
            
        }
        
//        lowest *= 0.9999
//        highest *= 1.0001
        
        let maxY = bounds.height - configuration.mainTopAssistViewHeight
        let unitValue = (highest - lowest) / Double((maxY - configuration.mainTopAssistViewHeight))
        
        drawPositionModels.removeAll()
        
        for (idx, model) in configuration.drawKLineModels.enumerated() {
            
            let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
            configuration.klineWidth * 0.5 + configuration.klineSpace
            
            let openPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.open - lowest) / unitValue)))
            let closePoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.close - lowest) / unitValue)))
            let hightPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.high - lowest) / unitValue)))
            let lowPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.low - lowest) / unitValue)))
            
            let positionModel = OKKLinePositionModel(openPoint: openPoint,
                                                     closePoint: closePoint,
                                                     highPoint: hightPoint,
                                                     lowPoint: lowPoint)
            
            drawPositionModels.append(positionModel)
            // TODO: MA坐标转换
        }
        
    }
}
