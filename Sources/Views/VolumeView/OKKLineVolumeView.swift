//
//  OKKLineSwift
//
//  Copyright © 2016年 Herb - https://github.com/Herb-Sun/OKKLineSwift
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import CoreGraphics

class OKKLineVolumeView: UIView {

    // MARK: - Property
    public var limitValueChanged: ((_ limitValue: (minValue: Double, maxValue: Double)?) -> Void)?

    fileprivate var configuration: OKConfiguration!
    fileprivate var volumeDrawKLineModels: [OKKLineModel]?
    
    fileprivate var drawAssistString: NSAttributedString?
    
    fileprivate var drawMaxY: CGFloat {
        get {
            return bounds.height
        }
    }
    fileprivate var drawHeight: CGFloat {
        get {
            return bounds.height - configuration.volume.topViewHeight
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
    
    public func drawVolumeView() {
        fetchVolumeDrawKLineModels()
        setNeedsDisplay()
    }
    
    public func drawVolumeAssistView(model: OKKLineModel?) {
        fetchAssistString(model: model)
        let displayRect = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: configuration.volume.topViewHeight)

        setNeedsDisplay(displayRect)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.volume.backgroundColor.cgColor)
        context.fill(rect)
        
        // 没有数据 不绘制
        guard let volumeDrawKLineModels = volumeDrawKLineModels,
            let limitValue = fetchLimitValue() else {
            return
        }
        
        guard __CGPointEqualToPoint(rect.origin, bounds.origin) &&
            __CGSizeEqualToSize(rect.size, bounds.size)
            else {
                
                drawAssistString?.draw(in: rect)
                return
        }
        
        // 绘制指标数据
        fetchAssistString(model: volumeDrawKLineModels.last!)
        drawAssistString?.draw(in: rect)

        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        for (index, klineModel) in volumeDrawKLineModels.enumerated() {
            
            let xPosition = CGFloat(index) * (configuration.theme.klineWidth + configuration.theme.klineSpace) +
                configuration.theme.klineWidth * 0.5 + configuration.theme.klineSpace
            
            let yPosition = abs(drawMaxY - CGFloat((klineModel.volume - limitValue.minValue) / unitValue))
            let startPoint = CGPoint(x: xPosition, y: yPosition)
            let endPoint = CGPoint(x: xPosition, y: bounds.height)
            
            let strokeColor = klineModel.open < klineModel.close ?
                configuration.theme.increaseColor : configuration.theme.decreaseColor
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(configuration.theme.klineWidth)
            context.strokeLineSegments(between: [startPoint, endPoint])
        }
        context.strokePath()
        
        // 画指标线
        switch configuration.volume.indicatorType {
        case .MA_VOLUME(_):
            drawMA_VOLUME(context: context, limitValue: limitValue, drawModels: volumeDrawKLineModels)
        case .EMA_VOLUME(_):
            drawEMA_VOLUME(context: context, limitValue: limitValue, drawModels: volumeDrawKLineModels)
        default:
            break
        }
    }
}

// MARK: - 辅助视图相关
extension OKKLineVolumeView {
    
    fileprivate func fetchAssistString(model: OKKLineModel?) {
        
        guard let volumeDrawKLineModels = volumeDrawKLineModels else { return }
        
        var drawModel = volumeDrawKLineModels.last!
        
        if let model = model {
            for volumeModel in volumeDrawKLineModels {
                if model.date == volumeModel.date {
                    drawModel = volumeModel
                    break
                }
            }
        }
        let drawAttrsString = NSMutableAttributedString()
        let volumeStr = String(format: "VOLUME %.2f  ", drawModel.volume)
        
        let volumeAttrs: [String : Any] = [
            NSForegroundColorAttributeName : configuration.main.assistTextColor,
            NSFontAttributeName : configuration.main.assistTextFont
        ]
        drawAttrsString.append(NSAttributedString(string: volumeStr, attributes: volumeAttrs))
        
        switch configuration.volume.indicatorType {
        case .MA_VOLUME(let days):
            
            for (idx, day) in days.enumerated() {
                
                let attrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.MAColor(day: day),
                    NSFontAttributeName : configuration.main.assistTextFont
                ]
                if let value = drawModel.MA_VOLUMEs![idx] {
                    let maStr = String(format: "MAVOL\(day): %.2f ", value)
                    drawAttrsString.append(NSAttributedString(string: maStr, attributes: attrs))
                }
            }
            
        case .EMA_VOLUME(let days):
            for (idx, day) in days.enumerated() {
                
                let attrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.EMAColor(day: day),
                    NSFontAttributeName : configuration.main.assistTextFont
                ]
                if let value = drawModel.EMA_VOLUMEs![idx] {
                    let maStr = String(format: "EMAVOL\(day): %.2f ", value)
                    drawAttrsString.append(NSAttributedString(string: maStr, attributes: attrs))
                }
            }
            
        default:
            break
        }
        
        drawAssistString = drawAttrsString
    }
}

// MARK: - 绘制指标
extension OKKLineVolumeView {
    
    fileprivate func drawMA_VOLUME(context: CGContext,
                                   limitValue: (minValue: Double, maxValue: Double),
                                   drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        switch configuration.volume.indicatorType {
        case .MA_VOLUME(let days):
            
            for (idx, day) in days.enumerated() {
                
                let maLineBrush = OKMALineBrush(brushType: .MA_VOLUME(day),
                                                context: context,
                                                configuration: configuration)
                
                maLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
                    
                    if let value = model.MA_VOLUMEs?[idx] {
                        
                        let xPosition = CGFloat(index) * (self.configuration.theme.klineWidth + self.configuration.theme.klineSpace) +
                            self.configuration.theme.klineWidth * 0.5 + self.configuration.theme.klineSpace
                        
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
    
    fileprivate func drawEMA_VOLUME(context: CGContext,
                                    limitValue: (minValue: Double, maxValue: Double),
                                    drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        
        switch configuration.volume.indicatorType {
        case .EMA_VOLUME(let days):
            
            for (idx, day) in days.enumerated() {
                
                let emaLineBrush = OKMALineBrush(brushType: .EMA_VOLUME(day),
                                                 context: context,
                                                 configuration: configuration)
                
                emaLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in
                    
                    if let value = model.EMA_VOLUMEs?[idx] {
                        
                        let xPosition = CGFloat(index) * (self.configuration.theme.klineWidth + self.configuration.theme.klineSpace) +
                            self.configuration.theme.klineWidth * 0.5 + self.configuration.theme.klineSpace
                        
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
}

// MARK: - 获取相关数据
extension OKKLineVolumeView {
    
    /// 获取视图绘制模型数据
    fileprivate func fetchVolumeDrawKLineModels() {
        
        guard configuration.dataSource.klineModels.count > 0 else {
            volumeDrawKLineModels = nil
            return
        }
        
        switch configuration.volume.indicatorType {
        case .MA_VOLUME(_):
            let maModel = OKMAVOLUMEModel(indicatorType: configuration.volume.indicatorType,
                                          klineModels: configuration.dataSource.klineModels)
            volumeDrawKLineModels = maModel.fetchDrawMAVOLUMEData(drawRange: configuration.dataSource.drawRange)
            
        case .EMA_VOLUME(_):
            let emaModel = OKEMAVOLUMEModel(indicatorType: configuration.volume.indicatorType,
                                            klineModels: configuration.dataSource.klineModels)
            volumeDrawKLineModels = emaModel.fetchDrawEMAVOLUMEData(drawRange: configuration.dataSource.drawRange)
            
        default:
            volumeDrawKLineModels = configuration.dataSource.drawKLineModels
        }
    }
    
    /// 获取极限值
    fileprivate func fetchLimitValue() -> (minValue: Double, maxValue: Double)? {
        
        guard let volumeDrawKLineModels = volumeDrawKLineModels else {
            return nil
        }
        
        var minValue = 0.0//volumeDrawKLineModels[0].volume
        var maxValue = volumeDrawKLineModels[0].volume
        
        // 先求K线数据的最大最小
        for model in volumeDrawKLineModels {
            if model.volume < minValue {
                minValue = model.volume
            }
            if model.volume > maxValue {
                maxValue = model.volume
            }
            
            // 求指标数据的最大最小
            switch configuration.volume.indicatorType {
            case .MA_VOLUME(_):
                if let MAs = model.MA_VOLUMEs {
                    for value in MAs {
                        if let value = value {
                            minValue = value < minValue ? value : minValue
                            maxValue = value > maxValue ? value : maxValue
                        }
                    }
                }
            case .EMA_VOLUME(_):
                if let EMAs = model.EMA_VOLUMEs {
                    for value in EMAs {
                        if let value = value {
                            minValue = value < minValue ? value : minValue
                            maxValue = value > maxValue ? value : maxValue
                        }
                    }
                }
            default:
                break
            }
        }
        limitValueChanged?((minValue, maxValue))
        return (minValue, maxValue)
    }
}
