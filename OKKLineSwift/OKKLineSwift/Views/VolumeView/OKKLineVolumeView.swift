//
//  OKKLineVolumeView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit
import CoreGraphics

class OKKLineVolumeView: UIView {

    // MARK: - Property
    private let configuration = OKConfiguration.shared
    private var drawVolumePositionModels = [OKVolumePositionModel]()
    private var klineColors = [CGColor]()
    
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
        ctx?.setFillColor(configuration.volumeViewBgColor)
        ctx?.fill(rect)
        
        // 没有数据 不绘制
        guard drawVolumePositionModels.count > 0 else {
            return
        }

        for (idx, positionModel) in drawVolumePositionModels.enumerated() {
            
            ctx?.setLineWidth(configuration.klineWidth)
            ctx?.setStrokeColor(klineColors[idx])
            ctx?.strokeLineSegments(between: [positionModel.startPoint, positionModel.endPoint])
        }
        
        // TODO: 画MA
    }
    
    // MARK: - Public
    
    public func drawVolumeView() {
        fetchDrawVolumePositionModels()
        setNeedsDisplay()
    }
    
    // MARK: - Private
    
    private func fetchDrawVolumePositionModels() {
        
        var minVolume = configuration.drawKLineModels[0].volume
        var maxVolume = configuration.drawKLineModels[0].volume
        
        for (idx, klineModel) in configuration.drawKLineModels.enumerated() {
            
            // 决定K线颜色
            let strokeColor = klineModel.open < klineModel.close ? configuration.increaseColor : configuration.decreaseColor
            klineColors.append(strokeColor)
            
            if klineModel.volume < minVolume {
                minVolume = klineModel.volume
            }
            
            if klineModel.volume > maxVolume {
                maxVolume = klineModel.volume
            }
            // TODO: 算MA
        }
        
        let unitValue = CGFloat((maxVolume - minVolume)) / (bounds.height - configuration.volumeTopViewHeight)
        
        drawVolumePositionModels.removeAll()

        for (idx, klineModel) in configuration.drawKLineModels.enumerated() {
            
            let xPosition = CGFloat(idx) * (configuration.klineWidth + configuration.klineSpace) +
                configuration.klineWidth * 0.5 + configuration.klineSpace
            
            var yPosition = abs(bounds.height - CGFloat((klineModel.volume - minVolume)) / unitValue)
            if abs(yPosition - bounds.height) < 0.5 {
                yPosition = bounds.height - 1
            }
            let startPoint = CGPoint(x: xPosition, y: yPosition)
            let endPoint = CGPoint(x: xPosition, y: bounds.height)
            let positionModel = OKVolumePositionModel(startPoint: startPoint, endPoint: endPoint)
            drawVolumePositionModels.append(positionModel)
            
            // TODO: MA
        }
        
    }
}
