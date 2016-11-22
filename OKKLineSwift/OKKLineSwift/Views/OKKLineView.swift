//
//  OKKLineView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class OKKLineView: UIView, UIScrollViewDelegate {
    
    // MARK: - Property

    private let configuration = OKConfiguration.shared
    
    private var scrollView: UIScrollView!
    private var lastOffsetX: CGFloat = 0.0
    private var pinchStartIndex: Int = 0
    
    private var mainView: OKKLineMainView!
    private var mainViewH: CGFloat = 0.0
    private var mainSegmentView: OKSegmentView!
    
    private var volumeView: OKKLineVolumeView!
    private var volumeViewH: CGFloat = 0.0
    private var volumeSegmentView: OKSegmentView!
    
    private var accessoryView: OKKLineAccessoryView!
    private var accessoryViewH: CGFloat = 0.0
    private var accessorySegmentView: OKSegmentView!
    
    /// 视图总宽度
    private var drawViewWidth: CGFloat {
        get {
            var totalW = CGFloat(configuration.klineModels.count) *
                (configuration.klineWidth + configuration.klineSpace)
            
            totalW = totalW > scrollView.bounds.width ? totalW : scrollView.bounds.width
            scrollView.contentSize = CGSize(width: totalW, height: scrollView.contentSize.height)
            return totalW
        }
        set(newValue) {
            self.drawViewWidth = newValue
        }
    }

    /// 开始draw的数组下标
    private var drawStartIndex: Int {
        get {
            let offsetX = scrollView.contentOffset.x < 0 ? 0 : scrollView.contentOffset.x
            let offsetCount = abs(offsetX) / (configuration.klineSpace + configuration.klineWidth)
            return Int(offsetCount)
        }
        set(newValue) {
            self.drawStartIndex = newValue
        }
    }

    /// 开始draw x的位置
    private var startXPosition: CGFloat {
        get {
            return CGFloat(drawStartIndex) * (configuration.klineSpace + configuration.klineWidth) +
            configuration.klineWidth / 2
        }
        set(newValue) {
            self.startXPosition = newValue
        }
    }
    
    
    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Parent View
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.delegate = self
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        scrollView.addGestureRecognizer(pinchGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        scrollView.addGestureRecognizer(longPressGesture)
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-50)
        }
        
        /// Main View
        mainView = OKKLineMainView()
        scrollView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.width.equalTo(self.drawViewWidth)
            make.height.equalTo(self.scrollView.snp.height).multipliedBy(configuration.mainScale)
        }
        
        mainSegmentView = OKSegmentView()
        addSubview(mainSegmentView)
        // TODO: mainSegmentView
        
        /// Volume View
        volumeView = OKKLineVolumeView()
        scrollView.addSubview(volumeView)
        volumeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.mainView)
            make.top.equalTo(self.mainView.snp.bottom)
            make.height.equalTo(self.scrollView.snp.height).multipliedBy(configuration.volumeScale)
        }
        
        volumeSegmentView = OKSegmentView()
        addSubview(volumeSegmentView)
        // TODO: volumeSegmentView
        
        /// Accessory View
        accessoryView = OKKLineAccessoryView()
        scrollView.addSubview(accessoryView)
        accessoryView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.mainView)
            make.top.equalTo(self.volumeView.snp.bottom)
            make.height.equalTo(self.scrollView.snp.height).multipliedBy(configuration.accessoryScale)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawKLineView(lastest: Bool) {
        
        mainView.snp.updateConstraints { (make) in
            make.width.equalTo(self.drawViewWidth)
        }
        
        fetchDrawModels()
        if lastest {
            //设置contentOffset
            let klineViewWidth = CGFloat(configuration.klineModels.count) * (configuration.klineWidth + configuration.klineSpace) + 10
            let offset = klineViewWidth - scrollView.bounds.width
            scrollView.contentOffset = CGPoint(x: (offset > 0 ? offset : 0), y: 0)
        }
        
        mainView.startXPosition = startXPosition
        mainView.drawMainView()

        volumeView.startXPosition = startXPosition
        volumeView.drawVolumeView()
        accessoryView.drawAccessoryView()
    }
    
    /// 获取需要绘制的模型
    private func fetchDrawModels() {

        let drawModelsCount = Int((scrollView.frame.width) / (configuration.klineSpace + configuration.klineWidth))

        var startIndex: Int  = 0

        if pinchStartIndex > 0 {
            startIndex = pinchStartIndex
            drawStartIndex = pinchStartIndex
            pinchStartIndex = -1

        } else {
            startIndex = drawStartIndex
        }

        configuration.drawKLineModels.removeAll()
        
        if startIndex < configuration.klineModels.count {
            if (startIndex + drawModelsCount) < configuration.klineModels.count {

                configuration.drawKLineModels = (configuration.klineModels as NSArray).subarray(with: NSMakeRange(startIndex, drawModelsCount)) as! [OKKLineModel]

            } else {
                configuration.drawKLineModels = (configuration.klineModels as NSArray).subarray(with: NSMakeRange(startIndex, configuration.klineModels.count - startIndex)) as! [OKKLineModel]
            }
        }
    }
    
    @objc
    private func pinchAction(_ sender: UIPinchGestureRecognizer) {
        
        var lastScale: CGFloat = 1.0
        let difValue = sender.scale - lastScale
        
        if abs(difValue) > configuration.klineScale {
            
            let lastKLineWidth: CGFloat = configuration.klineWidth
            
            configuration.klineWidth = configuration.klineWidth * (difValue > 0 ?
                (1 + configuration.klineScaleFactor) : (1 - configuration.klineScaleFactor))
            lastScale = sender.scale
            
            mainView.snp.updateConstraints { (make) in
                make.width.equalTo(self.drawViewWidth)
            }
            
            if sender.numberOfTouches == 2 {
                let pinchPoint1 = sender.location(ofTouch: 0, in: scrollView)
                let pinchPoint2 = sender.location(ofTouch: 1, in: scrollView)
                
                let centerPoint = CGPoint(x: (pinchPoint1.x + pinchPoint2.x) * 0.5,
                                          y: (pinchPoint1.y + pinchPoint2.y) * 0.5)
                
                let oldOffsetCount = abs(centerPoint.x - scrollView.contentOffset.x) /
                    (configuration.klineSpace + lastKLineWidth)
                
                let newOffsetCount = abs(centerPoint.x - scrollView.contentOffset.x) /
                    (configuration.klineSpace + configuration.klineWidth)
                
                pinchStartIndex = drawStartIndex + Int(oldOffsetCount - newOffsetCount)
                
            }
            drawKLineView(lastest: false)
        }
    }
    
    @objc
    private func longPressAction(_ sender: UILongPressGestureRecognizer) {
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let difValue = abs(scrollView.contentOffset.x - lastOffsetX)
        if difValue >= (configuration.klineWidth + configuration.klineSpace) {
            lastOffsetX = scrollView.contentOffset.x
            drawKLineView(lastest: false)
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
