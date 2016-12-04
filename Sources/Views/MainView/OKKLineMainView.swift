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

class OKKLineMainView: OKView {
    
    // MARK: - Property
    private var assistLabel: UILabel!
    private let configuration = OKConfiguration.shared
    private var drawPositionModels = [OKKLinePositionModel]()
    
    private var drawIndicationDatas:[[Double?]] {
        get {
            guard configuration.dataSource.drawKLineModels.count > 0 else {
                return []
            }
            
            var datas: [[Double?]] = []
            
            for indicator in configuration.mainIndicatorTypes {
                switch indicator {
                    
                case .MA(let day):
                    let maModel = OKMAModel(day: day, klineModels: configuration.dataSource.klineModels)
                    datas.append(maModel.fetchDrawMAData(drawRange: configuration.dataSource.drawRange))
                    
                case .EMA(let day):
                    let emaModel = OKEMAModel(day: day, klineModels: configuration.dataSource.klineModels)
                    datas.append(emaModel.fetchDrawEMAData(drawRange: configuration.dataSource.drawRange))
//                case .BOLL
                default:
                    break
                }
            }
            return datas
        }
    }
    
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
    
    private var lastDrawDatePoint: CGPoint = CGPoint.zero
    private let dateAttributes: [String : Any] = [
        NSForegroundColorAttributeName : UIColor(cgColor: OKConfiguration.shared.assistTextColor),
        NSFontAttributeName : OKConfiguration.shared.assistTextFont
    ]
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        assistLabel = UILabel()
        addSubview(assistLabel)
        assistLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.height.equalTo(configuration.mainTopAssistViewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        // 背景色
        context?.clear(rect)
        context?.setFillColor(configuration.mainViewBgColor)
        context?.fill(rect)
        
        // 没有数据 不绘制
        guard configuration.dataSource.klineModels.count > 0,
            let limitValue = fetchLimitValue() else {
            return
        }
        
        // 设置日期背景色
        context?.setFillColor(configuration.assistViewBgColor)
        let assistRect = CGRect(x: 0,
                                y: rect.height - configuration.mainBottomAssistViewHeight,
                                width: rect.width,
                                height: configuration.mainBottomAssistViewHeight)
        context?.fill(assistRect)
        
        lastDrawDatePoint = CGPoint.zero
        
        // 绘制提示数据
        drawAssistView(model: configuration.dataSource.drawKLineModels.last!)

        let unitValue = (limitValue.highest - limitValue.lowest) / Double(drawHeight)
        
        
        for (idx, klineModel) in configuration.dataSource.drawKLineModels.enumerated() {
            let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                configuration.klineWidth * 0.5 + configuration.klineSpace
            
            let openPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.open - limitValue.lowest) / unitValue)))
            let closePoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.close - limitValue.lowest) / unitValue)))
            let highPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.high - limitValue.lowest) / unitValue)))
            let lowPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.low - limitValue.lowest) / unitValue)))
            
            switch configuration.klineType {
            case .KLine: // K线模式
                
                    // 决定K线颜色
                    let strokeColor = klineModel.open < klineModel.close ?
                        configuration.increaseColor : configuration.decreaseColor
                    context?.setStrokeColor(strokeColor)
                    
                    // 画开盘-收盘
                    context?.setLineWidth(configuration.klineWidth)
                    context?.strokeLineSegments(between: [openPoint, closePoint])
                    
                    // 画上下影线
                    context?.setLineWidth(configuration.klineShadowLineWidth)
                    context?.strokeLineSegments(between: [highPoint, lowPoint])
     
                    // 画日期
                    drawDateLine(klineModel: configuration.dataSource.drawKLineModels[idx],
                                 positionX: xPosition)
            case .timeLine: // 分时线模式
                // 画线
                context?.setLineWidth(configuration.realtimeLineWidth)
                context?.setStrokeColor(configuration.realtimeLineColor)

                if idx == 0 { // 处理第一个点
                    context?.move(to: closePoint)
                } else {
                    context?.addLine(to: closePoint)
                }
                    
                    // 画日期
    //                drawDateLine(klineModel: configuration.dataSource.drawKLineModels[idx],
    //                             positionModel: positionModel)

            default: break
            }
        }
        context?.strokePath()
        
        // 绘制指标
        for (idx, datas) in drawIndicationDatas.enumerated() {
            
            var points: [CGPoint?] = []
            
            for (idx, value) in datas.enumerated() {
                if let value = value {
                    let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                        configuration.klineWidth * 0.5 + configuration.klineSpace
                    points.append(CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((value - limitValue.lowest) / unitValue))))
                } else {
                    points.append(nil)
                }
            }
            
            let lineBrush = OKLineBrush(indicatorType: configuration.mainIndicatorTypes[idx],
                                        context: context,
                                        drawPoints: points)
            // 画指标线
            lineBrush.draw()
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
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: configuration.mainBottomAssistViewHeight)
        
        let dateWidth: CGFloat = dateString.stringSize(maxSize: size, fontSize: 11.0).width
        
        let drawDatePoint = CGPoint(x: positionX - dateWidth * 0.5,
                                    y: bounds.height - configuration.mainBottomAssistViewHeight)
        
        if drawDatePoint.x < 0 || (drawDatePoint.x + dateWidth) > bounds.width {
            return
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
    
    // MARK: - Public
    
    public func drawMainView() {
        
//        fetchDrawPositionModels()
        setNeedsDisplay()
    }
    
    /// 绘制辅助说明视图
    ///
    /// - Parameter model: 绘制的模型 如果为nil 取当前画得最后一个模型
    public func drawAssistView(model: OKKLineModel?) {
        
        guard configuration.dataSource.drawKLineModels.count > 0 else { return }
        
        let drawModel = model == nil ? configuration.dataSource.drawKLineModels.last! : model!
        
        let date = Date(timeIntervalSince1970: drawModel.date/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = formatter.string(from: date) + " "
        
        let openStr = String(format: "开: %.2f ", drawModel.open)
        let highStr = String(format: "高: %.2f ", drawModel.high)
        let lowStr = String(format: "低: %.2f ", drawModel.low)
        let closeStr = String(format: "收: %.2f ", drawModel.close)
        
//        for indicator in configuration.mainIndicatorTypes {
//            switch indicator {
//            case .MA(let day):
//                
//            case .EMA(let day):
//            default:
//                break
//            }
//        }
        
        var string = openStr + highStr + lowStr + closeStr
        
        if let ma5 = drawModel.MA5 {
            string += String(format: "MA5: %.2f ", ma5)
        }
        
        if let ma12 = drawModel.MA12 {
            string += String(format: "MA12: %.2f ", ma12)
        }
        
        if let ma26 = drawModel.MA26 {
            string += String(format: "MA26: %.2f ", ma26)
        }

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
        
//        dateAttrsString.draw(at: CGPoint(x: 0, y: 0))
//        dateAttrsString.draw(in: CGRect(x: 0, y: 0, width: bounds.width, height: 30))
        assistLabel.attributedText = dateAttrsString

    }
    
    // MARK: - Private
    
    private func fetchLimitValue() -> (lowest: Double, highest: Double)? {
        
        guard configuration.dataSource.drawKLineModels.count > 0 else {
            return nil
        }
        
        let firstModel = configuration.dataSource.drawKLineModels[0]
        var lowest = firstModel.low
        var highest = firstModel.high
        
        // 先求K线数据的最大最小
        for model in configuration.dataSource.drawKLineModels {
            if model.low < lowest {
                lowest = model.low
            }
            if model.high > highest {
                highest = model.high
            }
        }
        
        // 求指标数据的最大最小
        for indicators in drawIndicationDatas {
            for value in indicators {
                if value != nil {
                    if value! > highest {
                        highest = value!
                    }
                    if value! < lowest {
                        lowest = value!
                    }
                }
            }
        }
        return (lowest, highest)
    }
    
    /// 获取位置模型
    ///
    /// - Returns: 位置模型数组
//    private func fetchDrawPositionModels() {
//
//        guard configuration.dataSource.drawKLineModels.count > 0 else {
//            return
//        }
//        
//        let firstModel = configuration.dataSource.drawKLineModels[0]
//        
//        var lowest = firstModel.low
//        var highest = firstModel.high
//        // 求最大最小值
//        for (_, model) in configuration.dataSource.drawKLineModels.enumerated() {
//            
//            if model.low < lowest {
//                lowest = model.low
//            }
//            if model.high > highest {
//                highest = model.high
//            }
    
//            if let ma5 = model.MA5 {
//                if ma5 > highest {
//                    highest = ma5
//                }
//                
//                if ma5 < lowest {
//                    lowest = ma5
//                }
//            }
//            
//            if let ma12 = model.MA12 {
//                if ma12 > highest {
//                    highest = ma12
//                }
//                
//                if ma12 < lowest {
//                    lowest = ma12
//                }
//            }
//            if let ma26 = model.MA26 {
//                if ma26 > highest {
//                    highest = ma26
//                }
//                
//                if ma26 < lowest {
//                    lowest = ma26
//                }
//            }
//        }
    
        // 查看指标值
        
        
        
//        lowest *= 0.9999
//        highest *= 1.0001
        
//        let drawHeight = bounds.height - configuration.mainTopAssistViewHeight - configuration.mainTopAssistViewHeight
//        let unitValue = (highest - lowest) / Double(drawHeight)
//        let maxY = bounds.height - configuration.mainTopAssistViewHeight
//        
//        drawPositionModels.removeAll()
//        
//        for (idx, model) in configuration.dataSource.drawKLineModels.enumerated() {
//            
//            let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
//            configuration.klineWidth * 0.5 + configuration.klineSpace
//            
//            let openPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.open - lowest) / unitValue)))
//            let closePoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.close - lowest) / unitValue)))
//            let hightPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.high - lowest) / unitValue)))
//            let lowPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat((model.low - lowest) / unitValue)))
//            // TODO: 坐标转换
//            var MA5Point: CGPoint?
//            var MA12Point: CGPoint?
//            var MA26Point: CGPoint?
//
//            if let ma5 = model.MA5 {
//                MA5Point = CGPoint(x: xPosition, y: abs(maxY - CGFloat((ma5 - lowest) / unitValue)))
//            }
//            if let ma12 = model.MA12 {
//                MA12Point = CGPoint(x: xPosition, y: abs(maxY - CGFloat((ma12 - lowest) / unitValue)))
//            }
//            if let ma26 = model.MA26 {
//                MA26Point = CGPoint(x: xPosition, y: abs(maxY - CGFloat((ma26 - lowest) / unitValue)))
//            }
//            
//            let positionModel = OKKLinePositionModel(openPoint: openPoint,
//                                                     closePoint: closePoint,
//                                                     highPoint: hightPoint,
//                                                     lowPoint: lowPoint)
//            positionModel.MA5Point = MA5Point
//            positionModel.MA12Point = MA12Point
//            positionModel.MA26Point = MA26Point
//            
//            drawPositionModels.append(positionModel)
//            
//        }
//    }
}

