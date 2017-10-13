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

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif
import CoreGraphics

class OKKLineMainView: OKView {

    // MARK: - Property
    public var limitValueChanged: ((_ limitValue: (minValue: Double, maxValue: Double)?) -> Void)?

    fileprivate let configuration = OKConfiguration.sharedConfiguration

    fileprivate var lastDrawDatePoint: CGPoint = CGPoint.zero
    // 辅助视图的显示内容
    fileprivate var drawAssistString: NSAttributedString?
    // 主图绘制K线模型数组
    fileprivate var mainDrawKLineModels: [OKKLineModel]?
    // 绘制区域的最大Y值
    fileprivate var drawMaxY: CGFloat {
        get {
            return bounds.height - configuration.main.bottomAssistViewHeight
        }
    }
    // 绘制区域的高度
    fileprivate var drawHeight: CGFloat {
        get {
            return bounds.height - configuration.main.topAssistViewHeight - configuration.main.bottomAssistViewHeight
        }
    }

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    //    convenience init(configuration: OKConfiguration) {
    //        self.init()
    //        self.configuration = configuration
    //    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public

    public func drawMainView() {

        fetchMainDrawKLineModels()

        okSetNeedsDisplay()
    }

    /// 绘制辅助说明视图
    ///
    /// - Parameter model: 绘制的模型 如果为nil 取当前绘制最后一个模型
    public func drawAssistView(model: OKKLineModel?) {

        fetchAssistString(model: model)

        let displayRect = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: configuration.main.topAssistViewHeight)

        okSetNeedsDisplay(displayRect)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = OKGraphicsGetCurrentContext() else {
            return
        }
        // 背景色
        context.clear(rect)
        context.setFillColor(configuration.main.backgroundColor.cgColor)
        context.fill(rect)

        // 没有数据 不绘制
        guard let mainDrawKLineModels = mainDrawKLineModels,
            let limitValue = fetchLimitValue() else {
                return
        }

        guard rect.origin == bounds.origin && rect.size == bounds.size else {
            drawAssistString?.draw(in: rect)
            return
        }

        // 设置日期背景色
        context.setFillColor(configuration.main.assistViewBgColor.cgColor)
        let assistRect = CGRect(x: 0,
                                y: rect.height - configuration.main.bottomAssistViewHeight,
                                width: rect.width,
                                height: configuration.main.bottomAssistViewHeight)
        context.fill(assistRect)

        lastDrawDatePoint = .zero

        // 绘制提示数据
        fetchAssistString(model: mainDrawKLineModels.last!)
        drawAssistString?.draw(in: rect)

        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)

        for (index, klineModel) in mainDrawKLineModels.enumerated() {
            let xPosition = CGFloat(index) * (configuration.theme.klineWidth + configuration.theme.klineSpace) +
                configuration.theme.klineWidth * 0.5 + configuration.theme.klineSpace

            let openPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.open - limitValue.minValue) / unitValue)))
            let closePoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.close - limitValue.minValue) / unitValue)))
            let highPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.high - limitValue.minValue) / unitValue)))
            let lowPoint = CGPoint(x: xPosition, y: abs(drawMaxY - CGFloat((klineModel.low - limitValue.minValue) / unitValue)))

            switch configuration.main.klineType {
            case .KLine: // K线模式

                // 决定K线颜色
                let strokeColor = klineModel.open < klineModel.close ?
                    configuration.theme.increaseColor : configuration.theme.decreaseColor
                context.setStrokeColor(strokeColor.cgColor)

                // 画开盘-收盘
                context.setLineWidth(configuration.theme.klineWidth)
                context.strokeLineSegments(between: [openPoint, closePoint])

                // 画上下影线
                context.setLineWidth(configuration.theme.klineShadowLineWidth)
                context.strokeLineSegments(between: [highPoint, lowPoint])

            case .timeLine: // 分时线模式
                // 画线
                context.setLineWidth(configuration.main.realtimeLineWidth)
                context.setStrokeColor(configuration.main.realtimeLineColor.cgColor)
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
        switch configuration.main.indicatorType {
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
}

// MARK: - 辅助视图(时间线,顶部显示)
extension OKKLineMainView {

    /// 画时间线
    ///
    /// - Parameters:
    ///   - klineModel: 数据模型
    ///   - positionModel: 位置模型
    fileprivate func drawDateLine(klineModel: OKKLineModel, positionX: CGFloat) {

        let date = Date(timeIntervalSince1970: klineModel.date/1000)
        let dateString = configuration.dateFormatter.string(from: date)

        let dateAttributes: [String : Any] = [
            NSForegroundColorAttributeName : configuration.main.assistTextColor,
            NSFontAttributeName : configuration.main.assistTextFont
        ]

        let dateAttrString = NSAttributedString(string: dateString, attributes: dateAttributes)

        let drawDatePoint = CGPoint(x: positionX - dateAttrString.size().width * 0.5,
                                    y: bounds.height - configuration.main.bottomAssistViewHeight)

        if drawDatePoint.x < 0 || (drawDatePoint.x + dateAttrString.size().width) > bounds.width {
            return
        }

        if lastDrawDatePoint == .zero ||
            abs(drawDatePoint.x - lastDrawDatePoint.x) > (dateAttrString.size().width * 2) {

            let rect = CGRect(x: drawDatePoint.x,
                              y: drawDatePoint.y,
                              width: dateAttrString.size().width,
                              height: configuration.main.bottomAssistViewHeight)

            dateAttrString.draw(in: rect)
            lastDrawDatePoint = drawDatePoint
        }
    }

    /// 获取辅助视图显示文本
    ///
    /// - Parameter model: 当前要显示的model
    fileprivate func fetchAssistString(model: OKKLineModel?) {

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
            NSForegroundColorAttributeName : configuration.main.assistTextColor,
            NSFontAttributeName : configuration.main.assistTextFont
        ]
        drawAttrsString.append(NSAttributedString(string: dateStr, attributes: dateAttrs))

        let openStr = String(format: "开: %.2f ", drawModel.open)
        let highStr = String(format: "高: %.2f ", drawModel.high)
        let lowStr = String(format: "低: %.2f ", drawModel.low)
        let closeStr = String(format: "收: %.2f ", drawModel.close)

        let string = openStr + highStr + lowStr + closeStr
        let attrs: [String : Any] = [
            NSForegroundColorAttributeName : configuration.main.assistTextColor,
            NSFontAttributeName : configuration.main.assistTextFont
        ]

        drawAttrsString.append(NSAttributedString(string: string, attributes: attrs))

        switch configuration.main.indicatorType {
        case .MA(let days):

            for (idx, day) in days.enumerated() {

                let attrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.MAColor(day: day),
                    NSFontAttributeName : configuration.main.assistTextFont
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
                    NSFontAttributeName : configuration.main.assistTextFont
                ]
                if let value = drawModel.EMAs![idx] {
                    let maStr = String(format: "EMA\(day): %.2f ", value)
                    drawAttrsString.append(NSAttributedString(string: maStr, attributes: attrs))
                }
            }
        case .BOLL(_):

            if let value = drawModel.BOLL_UP {
                let upAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.BOLL_UPColor,
                    NSFontAttributeName : configuration.main.assistTextFont
                ]
                let upAttrsStr = NSAttributedString(string: String(format: "UP: %.2f ", value), attributes: upAttrs)
                drawAttrsString.append(upAttrsStr)
            }
            if let value = drawModel.BOLL_MB {
                let mbAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.BOLL_MBColor,
                    NSFontAttributeName : configuration.main.assistTextFont
                ]
                let mbAttrsStr = NSAttributedString(string: String(format: "MB: %.2f ", value), attributes: mbAttrs)
                drawAttrsString.append(mbAttrsStr)
            }
            if let value = drawModel.BOLL_DN {
                let dnAttrs: [String : Any] = [
                    NSForegroundColorAttributeName : configuration.theme.BOLL_DNColor,
                    NSFontAttributeName : configuration.main.assistTextFont
                ]
                let dnAttrsStr = NSAttributedString(string: String(format: "DN: %.2f ", value), attributes: dnAttrs)
                drawAttrsString.append(dnAttrsStr)
            }

        default:
            break
        }
        drawAssistString = drawAttrsString
    }
}

// MARK: - 绘制指标
extension OKKLineMainView {

    /// 绘制MA指标
    ///
    /// - Parameters:
    ///   - context: contex
    ///   - limitValue: 极限值
    ///   - drawModels: 绘制的K线模型数据
    fileprivate func drawMA(context: CGContext,
                            limitValue: (minValue: Double, maxValue: Double),
                            drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)

        switch configuration.main.indicatorType {
        case .MA(let days):

            for (idx, day) in days.enumerated() {

                let maLineBrush = OKMALineBrush(brushType: .MA(day),
                                                context: context)

                maLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in

                    if let value = model.MAs?[idx] {

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

    /// 绘制EMA指标
    fileprivate func drawEMA(context: CGContext,
                             limitValue: (minValue: Double, maxValue: Double),
                             drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)

        switch configuration.main.indicatorType {
        case .EMA(let days):

            for (idx, day) in days.enumerated() {

                let emaLineBrush = OKMALineBrush(brushType: .EMA(day),
                                                 context: context)

                emaLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in

                    if let value = model.EMAs?[idx] {

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

    /// 绘制BOLL指标
    fileprivate func drawBOLL(context: CGContext,
                              limitValue: (minValue: Double, maxValue: Double),
                              drawModels: [OKKLineModel])
    {
        let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)

        let MBLineBrush = OKLineBrush(indicatorType: .BOLL_MB, context: context)
        MBLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in

            if let value = model.BOLL_MB {
                let xPosition = CGFloat(index) * (self.configuration.theme.klineWidth + self.configuration.theme.klineSpace) +
                    self.configuration.theme.klineWidth * 0.5 + self.configuration.theme.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        MBLineBrush.draw(drawModels: drawModels)

        let UPLineBrush = OKLineBrush(indicatorType: .BOLL_UP, context: context)
        UPLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in

            if let value = model.BOLL_UP {
                let xPosition = CGFloat(index) * (self.configuration.theme.klineWidth + self.configuration.theme.klineSpace) +
                    self.configuration.theme.klineWidth * 0.5 + self.configuration.theme.klineSpace
                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        UPLineBrush.draw(drawModels: drawModels)

        let DNLineBrush = OKLineBrush(indicatorType: .BOLL_DN, context: context)
        DNLineBrush.calFormula = { (index: Int, model: OKKLineModel) -> CGPoint? in

            if let value = model.BOLL_DN {
                let xPosition = CGFloat(index) * (self.configuration.theme.klineWidth + self.configuration.theme.klineSpace) +
                    self.configuration.theme.klineWidth * 0.5 + self.configuration.theme.klineSpace

                let yPosition: CGFloat = abs(self.drawMaxY - CGFloat((value - limitValue.minValue) / unitValue))
                return CGPoint(x: xPosition, y: yPosition)
            }
            return nil
        }
        DNLineBrush.draw(drawModels: drawModels)
    }
}

// MARK: - 获取相关数据
extension OKKLineMainView {

    /// 获取绘制主图所需的K线模型数据
    fileprivate func fetchMainDrawKLineModels() {

        guard configuration.dataSource.klineModels.count > 0 else {
            mainDrawKLineModels = nil
            return
        }

        switch configuration.main.indicatorType {
        case .MA(_):
            let maModel = OKMAModel(indicatorType: configuration.main.indicatorType,
                                    klineModels: configuration.dataSource.klineModels)
            mainDrawKLineModels = maModel.fetchDrawMAData(drawRange: configuration.dataSource.drawRange)

        case .EMA(_):
            let emaModel = OKEMAModel(indicatorType: configuration.main.indicatorType,
                                      klineModels: configuration.dataSource.klineModels)
            mainDrawKLineModels = emaModel.fetchDrawEMAData(drawRange: configuration.dataSource.drawRange)
        case .BOLL(_):
            let bollModel = OKBOLLModel(indicatorType: configuration.main.indicatorType,
                                        klineModels: configuration.dataSource.klineModels)
            mainDrawKLineModels = bollModel.fetchDrawBOLLData(drawRange: configuration.dataSource.drawRange)
        default:
            mainDrawKLineModels = configuration.dataSource.drawKLineModels
        }
    }


    /// 计算最大最小值
    ///
    /// - Returns: 用元组包装的最大最小值
    fileprivate func fetchLimitValue() -> (minValue: Double, maxValue: Double)? {

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
            switch configuration.main.indicatorType {
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

