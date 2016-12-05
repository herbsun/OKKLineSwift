//
//  OKKLineView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

class OKKLineView: OKView {
    
    public var doubleTapHandle: (() -> Void)?
    private var klineDrawView: OKKLineDrawView!
    private var timeSegmentView: OKSegmentView!
    private var indicatorSegmentView: OKSegmentView!
    private let configuration = OKConfiguration()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        klineDrawView = OKKLineDrawView(configuration: configuration)
        klineDrawView.doubleTapHandle = {
            self.doubleTapHandle?()
        }
        addSubview(klineDrawView)
        klineDrawView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 44, 50))
        }
        
        let timeTitles = ["分时", "1分", "5分", "15分", "30分", "60分", "日K", "周K", "月K", "季K", "年K"]
        timeSegmentView = OKSegmentView(direction: .horizontal, titles: timeTitles, configuration: configuration)
        timeSegmentView.didSelectedSegment = { [weak self] (segmentView, index) -> Void in
            if index == 0 {
                self?.configuration.klineType = .timeLine
            } else {
                self?.configuration.klineType = .KLine
            }
        
            self?.klineDrawView.drawKLineView(true)
        }
        addSubview(timeSegmentView)
        timeSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(klineDrawView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let indicatorTitles = ["MA", "EMA", "BOLL", "MACD", "KDJ", "RSI", "VOL"]
        indicatorSegmentView = OKSegmentView(direction: .vertical, titles: indicatorTitles, configuration: configuration)
        indicatorSegmentView.didSelectedSegment = { [weak self] (segmentView, index) -> Void in
            if index == 0 {
                self?.configuration.mainIndicatorTypes = [.MA(5), .MA(12), .MA(26)]
                self?.configuration.volumeIndicatorTypes = [.MA_VOLUME(5), .MA_VOLUME(12), .MA_VOLUME(26)]
            } else if index == 1 {
                self?.configuration.mainIndicatorTypes = [.EMA(5), .EMA(12), .EMA(26)]
                self?.configuration.volumeIndicatorTypes = [.EMA_VOLUME(5), .EMA_VOLUME(12), .EMA_VOLUME(26)]
            }
            
            self?.klineDrawView.drawKLineView(true)
        }
        
        addSubview(indicatorSegmentView)
        indicatorSegmentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(klineDrawView)
            make.leading.equalTo(klineDrawView.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawKLineView(klineModels: [OKKLineModel]) {
        configuration.dataSource.klineModels = OKKLineTool.handleKLineModels(klineModels: klineModels)
        klineDrawView.drawKLineView(true)
    }
}
