//
//  OKConfiguration.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

/// K线类型
enum OKKLineType: Int {
    case KLine // K线
    case timeLine // 分时图
    case other // 其他
}

/// 指标种类
enum OKIndexLineType: String {
    case MA
    case EMA
    case MACD
    case KDJ
    case BOLL
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
    
    static let shared: OKConfiguration = OKConfiguration()
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
    }
    
    // MARK: - Common
    var dateFormatter: DateFormatter
    
    ///临时数据
    var klineModels = [OKKLineModel]()
    
    var drawKLineModels = [OKKLineModel]()
//    var klineColors = [CGColor]()
//    var klinePositions = [CGPoint]()
    
    /// 是否显示价格
    var showPriceView: Bool = true
    
    /// 全局主题
    
    /// 主图图表的背景色
    var mainViewBgColor: CGColor = UIColor(hexRGB: 0x181C20).cgColor
    /// 成交量视图背景色
    var volumeViewBgColor: CGColor = UIColor(hexRGB: 0x181C20).cgColor
    /// 指标视图背景色
    var accessoryViewBgColor: CGColor = UIColor.gray.cgColor//UIColor(hexRGB: 0x181C20).cgColor
    
    /// 辅助视图背景色(e.g. 日期的背景色)
    var assistViewBgColor: CGColor = UIColor(hexRGB: 0x1D2227).cgColor
    /// 辅助视图字体颜色(e.g. 日期的字体颜色)
    var assistTextColor: CGColor = UIColor(hexRGB: 0x565A64).cgColor
    /// 辅助视图字体大小(e.g. 日期的字体大小)
    var assistTextFont: UIFont = UIFont.systemFont(ofSize: 11)
    /// 涨的颜色
    var increaseColor: CGColor = UIColor(hexRGB: 0xFF5353).cgColor
    /// 跌的颜色
    var decreaseColor: CGColor = UIColor(hexRGB: 0x00B07C).cgColor
    
    /// 分时线颜色
    var realtimeLineColor: CGColor = UIColor(hexRGB: 0x49A5FF).cgColor
    /// 长按辅助线颜色
    var longPressLineColor: CGColor = UIColor(hexRGB: 0xE1E2E6).cgColor
    
    /// MA颜色
    var MA7Color: CGColor = UIColor(hexRGB: 0xFF783C).cgColor
    var MA30Color: CGColor = UIColor(hexRGB: 0x49A5FF).cgColor
    var MALineWidth: CGFloat = 0.8
    /// 时间线
    var timeLineType: OKTimeLineType = .realTime
    /// k线的间隔
    var klineSpace: CGFloat = 1.0
    
    
    // MARK: - 主图
    
    /// 主图比例
    var mainScale: CGFloat = 0.50
    /// 主图顶部提示信息高度
    var mainTopAssistViewHeight: CGFloat = 20.0
    /// 主图底部时间线信息高度
    var mainBottomAssistViewHeight: CGFloat = 15.0
    /// 主图分时线宽度
    var realtimeLineWidth: CGFloat = 0.5
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
    /// 主图K线类型
    var klineType: OKKLineType = .KLine
    /// 主图指标类型
    var mainIndexType: OKIndexLineType = .MA
    
    // MARK: - 成交量图(volume)
    
    /// 是否显示成交量视图
    var showVolumeView: Bool = true
    /// 成交量比例
    var volumeScale: CGFloat = 0.25
    /// 顶部提示信息高度
    var volumeTopViewHeight: CGFloat = 20.0
    /// 成交量图分时线宽度
    var volumeLineWidth: CGFloat = 0.5
    /// 成交量指标类型
    var volumeIndexType: OKIndexLineType = .MA
    
    // MARK: - 指标图(accessory)
    
    /// 是否显示指标图
    var showAccessoryView: Bool = true
    /// 指标图比例
    var accessoryScale: CGFloat = 0.25
    /// 顶部提示信息高度
    var accessoryTopViewHeight: CGFloat = 20.0
    /// 指标图分时线宽度
    var accessoryLineWidth: CGFloat = 0.5
    /// 辅助图指标类型
    var accessoryIndexType: OKIndexLineType = .MA
 
    // MARK: - SegmentView
    var  showSegmentView: Bool = true
    
    
}

/// 皮肤主题
struct OKTheme {
    
}

struct OKDataSource {
    
}
