//
//  OKKLineVolumeView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit
import CoreGraphics

class OKKLineVolumeView: OKView {

    // MARK: - Property
    private var configuration: OKConfiguration!
    private var assistInfoLabel: UILabel!

    private var drawMaxY: CGFloat {
        get {
            return bounds.height
        }
    }
    private var drawHeight: CGFloat {
        get {
            return bounds.height - configuration.volumeTopViewHeight
        }
    }
    
    private var drawIndicationDatas:[[Double?]] {
        get {
            guard configuration.dataSource.drawKLineModels.count > 0 else {
                return []
            }
            
            var datas: [[Double?]] = []
            
            for indicator in configuration.volumeIndicatorTypes {
                switch indicator {
                    
                case .MA_VOLUME(let day):
                    let maModel = OKMAVOLUMEModel(day: day, klineModels: configuration.dataSource.klineModels)
                    datas.append(maModel.fetchDrawMAVOLUMEData(drawRange: configuration.dataSource.drawRange))
                    
                case .EMA_VOLUME(let day):
                    let emaModel = OKEMAVOLUMEModel(day: day, klineModels: configuration.dataSource.klineModels)
                    datas.append(emaModel.fetchDrawEMAVOLUMEData(drawRange: configuration.dataSource.drawRange))
                default:
                    break
                }
            }
            return datas
        }
    }
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            make.height.equalTo(configuration.volumeTopViewHeight)
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
        context?.setFillColor(configuration.volumeViewBgColor)
        context?.fill(rect)
        
        // 没有数据 不绘制
        guard configuration.dataSource.drawKLineModels.count > 0,
            let limitValue = fetchLimitValue() else {
            return
        }
        
        // 绘制指标数据
        drawVolumeAssistView(model: configuration.dataSource.drawKLineModels.last!)

        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        for (idx, klineModel) in configuration.dataSource.drawKLineModels.enumerated() {
            
            let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                configuration.klineWidth * 0.5 + configuration.klineSpace
            
            let yPosition = abs(drawMaxY - CGFloat((klineModel.volume - limitValue.minValue) / unitValue))
            let startPoint = CGPoint(x: xPosition, y: yPosition)
            let endPoint = CGPoint(x: xPosition, y: bounds.height)
            
            let strokeColor = klineModel.open < klineModel.close ?
                configuration.increaseColor : configuration.decreaseColor
            context?.setStrokeColor(strokeColor)
            context?.setLineWidth(configuration.klineWidth)
            context?.strokeLineSegments(between: [startPoint, endPoint])
        }
        context?.strokePath()
        
        // 画指标线
        for (idx, datas) in drawIndicationDatas.enumerated() {
            
            var points: [CGPoint?] = []
            
            for (idx, value) in datas.enumerated() {
                if let value = value {
                    let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                        configuration.klineWidth * 0.5 + configuration.klineSpace
                    points.append(CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))))
                } else {
                    points.append(nil)
                }
            }
            
            let lineBrush = OKLineBrush(indicatorType: configuration.volumeIndicatorTypes[idx],
                                        context: context,
                                        drawPoints: points,
                                        configuration: configuration)
            lineBrush.draw()
        }
    }
    
    // MARK: - Public
    
    public func drawVolumeView() {
//        fetchDrawVolumePositionModels()
        setNeedsDisplay()
    }
    
    public func drawVolumeAssistView(model: OKKLineModel?) {
        
        let volumeModel = model == nil ? configuration.dataSource.drawKLineModels.last! : model!
        
        var volumeStr = String(format: "VOLUME %.2f", volumeModel.volume)
        
        if let ma5 = volumeModel.MA5_VOLUME {
            volumeStr += String(format: "MAVOL5 %.2f    ", ma5)
        }
        
        if let ma12 = volumeModel.MA26_VOLUME {
            volumeStr += String(format: "MAVOL12 %.2f   ", ma12)
        }
        
        if let ma26 = volumeModel.MA26_VOLUME {
            volumeStr += String(format: "MAVOL26 %.2f", ma26)
        }
        
        let attrs: [String : Any] = [
            NSForegroundColorAttributeName : UIColor(cgColor: configuration.assistTextColor),
            NSFontAttributeName : configuration.assistTextFont
        ]
        assistInfoLabel.attributedText = NSAttributedString(string: volumeStr, attributes: attrs)
    }
    
    // MARK: - Private
    
    private func fetchLimitValue() -> (minValue: Double, maxValue: Double)? {
        
        guard configuration.dataSource.drawKLineModels.count > 0 else {
            return nil
        }
        
        var minValue = configuration.dataSource.drawKLineModels[0].volume
        var maxValue = configuration.dataSource.drawKLineModels[0].volume
        
        // 先求K线数据的最大最小
        for model in configuration.dataSource.drawKLineModels {
            if model.volume < minValue {
                minValue = model.volume
            }
            if model.volume > maxValue {
                maxValue = model.volume
            }
        }
        
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
