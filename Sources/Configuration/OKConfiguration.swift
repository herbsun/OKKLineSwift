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

/// K线类型
enum OKKLineType: Int {
    case KLine // K线
    case timeLine // 分时图
    case other // 其他
}

/// 指标种类
enum OKIndicatorType {
    case NONE
    case MA([Int])
    case MA_VOLUME([Int])
    case EMA([Int])
    case EMA_VOLUME([Int])
    case DIF, DEA, MACD
    case KDJ, KDJ_K, KDJ_D, KDJ_J
    case BOLL(Int), BOLL_MB, BOLL_UP, BOLL_DN
    case RSI
    case VOL
    case DMI
}

/// 时间线分隔
enum OKTimeLineType: Int {
    case realTime = 1 // 分时
    case oneMinute = 60 // 1分
    case fiveMinute = 300 // 5分
    case fifteenMinute = 900 // 15分
    case thirtyMinute = 1800 // 30分
    case oneHour = 3600 // 60分
    case oneDay = 86400 // 日
    case oneWeek = 604800 // 周
}

public final class OKConfiguration {
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
    }
    
    // MARK: - Common
    var dateFormatter: DateFormatter
    
    let dataSource: OKDataSource = OKDataSource()
    
    /// 全局主题
    let theme: OKTheme = OKTheme()
    
    /// 主图Configuration(main)
    let main: OKMainConfiguration = OKMainConfiguration()
    
    /// 成交量图Configuration(volume)
    let volume: OKVolumeConfiguration = OKVolumeConfiguration()
    
    /// 指标图Configuration(accessory)
    let accessory: OKAccessoryConfiguration = OKAccessoryConfiguration()
    
    /// 价格视图Configuration(value)
    let value: OKValueConfiguration = OKValueConfiguration()
    
}

public class OKDataSource {
    
    var drawRange: NSRange?
    var klineModels = [OKKLineModel]()
    var drawKLineModels = [OKKLineModel]()
}

// MARK: - 皮肤主题
public class OKTheme {
    
    // MARK: K线主题
    
    /// 涨的颜色
    var increaseColor: UIColor = UIColor(hexRGB: 0xFF5353)
    
    /// 跌的颜色
    var decreaseColor: UIColor = UIColor(hexRGB: 0x00B07C)
    
    /// k线的间隔
    var klineSpace: CGFloat = 1.0
    
    /// k线图主体宽度
    var klineWidth: CGFloat = 5.0
    
    /// 上下影线宽度
    var klineShadowLineWidth: CGFloat = 1.0
    
    /// k线最大宽度
    var klineMaxWidth: CGFloat = 20.0
    
    /// k线最小宽度
    var klineMinWidth: CGFloat = 2.0
    
    /// k线缩放界限
    var klineScale: CGFloat = 0.03
    
    /// k线缩放因子
    var klineScaleFactor: CGFloat = 0.03
    
    /// 指标线宽度
    var indicatorLineWidth: CGFloat = 0.8

    /// 十字线颜色
    var longPressLineColor: UIColor = UIColor(hexRGB: 0xE1E2E6)
    
    /// 十字线宽度
    var longPressLineWidth: CGFloat = 0.5
    
    // MARK: 指标颜色
    
    var DIFColor: UIColor = UIColor(hexRGB: 0xFF8D1D)
    var DEAColor: UIColor = UIColor(hexRGB: 0x0DAEE6)
    var MACDColor: UIColor = UIColor(hexRGB: 0xFFC90E)
    
    var KDJ_KColor: UIColor = UIColor(hexRGB: 0xFF8D1D)
    var KDJ_DColor: UIColor = UIColor(hexRGB: 0x0DAEE6)
    var KDJ_JColor: UIColor = UIColor(hexRGB: 0xE970DC)
    
    var BOLL_MBColor: UIColor = UIColor(hexRGB: 0xFFAEBF)
    var BOLL_UPColor: UIColor = UIColor(hexRGB: 0xFFC90E)
    var BOLL_DNColor: UIColor = UIColor(hexRGB: 0x0DAEE6)
    
    public func MAColor(day: Int) -> UIColor {
        return UIColor(hexRGB: 0x4498EA + day)
    }
    
    public func EMAColor(day: Int) -> UIColor {
        return UIColor(hexRGB: 0x4498EA + day)
    }
}

// MARK: - 主图Configuration(main)

public class OKMainConfiguration {
    
    /// 主图图表的背景色
    var backgroundColor: UIColor = UIColor(hexRGB: 0x181C20)
    
    /// 主图比例
    var scale: CGFloat = 0.50
    
    /// 主图顶部提示信息高度
    var topAssistViewHeight: CGFloat = 30.0
    
    /// 主图底部时间线信息高度
    var bottomAssistViewHeight: CGFloat = 15.0
    
    /// 时间线
    var timeLineType: OKTimeLineType = .realTime
    
    /// 主图K线类型
    var klineType: OKKLineType = .KLine
    
    /// 主图分时线宽度
    var realtimeLineWidth: CGFloat = 1.0
    
    /// 分时线颜色
    var realtimeLineColor: UIColor = UIColor(hexRGB: 0xFFFFFF)
    
    /// 主图指标类型
    var indicatorType: OKIndicatorType = .MA([12, 26])
    
    /// 辅助视图背景色(e.g. 日期的背景色)
    var assistViewBgColor: UIColor = UIColor(hexRGB: 0x1D2227)
    
    /// 辅助视图字体颜色(e.g. 日期的字体颜色)
    var assistTextColor: UIColor = UIColor(hexRGB: 0x565A64)
    
    /// 辅助视图字体大小(e.g. 日期的字体大小)
    var assistTextFont: UIFont = UIFont.systemFont(ofSize: 11)
}

// MARK: - 成交量图Configuration(volume)

public class OKVolumeConfiguration {
    
    /// 是否显示成交量视图
    var show: Bool = true
    
    /// 成交量视图背景色
    var backgroundColor: UIColor = UIColor(hexRGB: 0x181C20)
    
    /// 成交量比例
    var scale: CGFloat = 0.25
    
    /// 顶部提示信息高度
    var topViewHeight: CGFloat = 20.0
    
    /// 成交量图分时线宽度
    var lineWidth: CGFloat = 0.5
    
    /// 成交量指标类型
    var indicatorType: OKIndicatorType = .EMA_VOLUME([12, 26])
}

// MARK: - 指标图Configuration(accessory)

public class OKAccessoryConfiguration {
    
    /// 是否显示指标图
    var show: Bool = true
    
    /// 指标视图背景色
    var backgroundColor: UIColor = UIColor(hexRGB: 0x181C20)
    
    /// 指标图比例
    var scale: CGFloat = 0.25
    
    /// 顶部提示信息高度
    var topViewHeight: CGFloat = 20.0
    
    /// 指标图分时线宽度
    var lineWidth: CGFloat = 0.5
    
    /// 辅助图指标类型
    var indicatorType: OKIndicatorType = .MACD
}

// MARK: - 价格视图Configuration(value)

public class OKValueConfiguration {
    var backgroundColor: UIColor = UIColor(hexRGB: 0x181C20)
    var textFont: UIFont = UIFont.systemFont(ofSize: 11)
    var textColor: UIColor = UIColor(hexRGB: 0xDCDADC)
    
}
