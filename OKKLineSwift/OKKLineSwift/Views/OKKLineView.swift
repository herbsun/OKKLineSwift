//
//  OKKLineView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class OKKLineView: UIView {
    
    // MARK: - Property

    private let configuration = OKConfiguration.shared
    
    private var contentView: UIView!

    
    private var mainView: OKKLineMainView!
    private var mainViewH: CGFloat = 0.0
    private var mainSegmentView: OKSegmentView!
    
    private var volumeView: OKKLineVolumeView!
    private var volumeViewH: CGFloat = 0.0
    private var volumeSegmentView: OKSegmentView!
    
    private var accessoryView: OKKLineAccessoryView!
    private var accessoryViewH: CGFloat = 0.0
    private var accessorySegmentView: OKSegmentView!

    private var pinchStartIndex: Int = 0
    private var lastOffsetIndex: Int = 0
    
    /// draw的个数
    private var drawCount: Int {
        get {
            let count = Int((contentView.frame.width) / (configuration.klineSpace + configuration.klineWidth))
            return count > configuration.klineModels.count ? configuration.klineModels.count : count
        }
    }
    
    /// 开始draw的数组下标
    private var drawStartIndex: Int = -1
//        {
//        get {
//
//            var index = configuration.klineModels.count - drawCount - 1
//            let offsetIndex = Int(totalOffsetX / (configuration.klineSpace + configuration.klineWidth))
//            index -= offsetIndex
//            
////            if let lastOffsetX = lastOffsetX {
////            }
//            
//            index = index > 0 ? index : 0
//            
//            index =  index > (configuration.klineModels.count - 1) ? configuration.klineModels.count - drawCount - 1 : index
//            
//            return index
//        }
//        set(newValue) {
//            self.drawStartIndex = newValue
//        }
//    }
    
    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Parent View
        contentView = UIView()
        // 捏合手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        contentView.addGestureRecognizer(pinchGesture)
        // 长按手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        contentView.addGestureRecognizer(longPressGesture)
        // 双击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(tapGesture)
        // 移动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        contentView.addGestureRecognizer(panGesture)
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-50)
        }
        
        /// Main View
        mainView = OKKLineMainView()
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.contentView.snp.height).multipliedBy(configuration.mainScale)
        }
        
        mainSegmentView = OKSegmentView()
        addSubview(mainSegmentView)
        // TODO: mainSegmentView
        
        /// Volume View
        volumeView = OKKLineVolumeView()
        contentView.addSubview(volumeView)
        volumeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.mainView)
            make.top.equalTo(self.mainView.snp.bottom)
            make.height.equalTo(self.contentView.snp.height).multipliedBy(configuration.volumeScale)
        }
        
        volumeSegmentView = OKSegmentView()
        addSubview(volumeSegmentView)
        // TODO: volumeSegmentView
        
        /// Accessory View
        accessoryView = OKKLineAccessoryView()
        contentView.addSubview(accessoryView)
        accessoryView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.mainView)
            make.top.equalTo(self.volumeView.snp.bottom)
            make.height.equalTo(self.contentView.snp.height).multipliedBy(configuration.accessoryScale)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawKLineView(lastest: Bool) {
        
        fetchDrawModels()
        
        
        
//        if lastest {
//            //设置contentOffset
//            let klineViewWidth = CGFloat(configuration.klineModels.count) * (configuration.klineWidth + configuration.klineSpace) + 10
//            let offset = klineViewWidth - contentView.bounds.width
//            contentView.contentOffset = CGPoint(x: (offset > 0 ? offset : 0), y: 0)
//        }
        
        mainView.drawMainView()

//        volumeView.startXPosition = startXPosition
//        volumeView.drawVolumeView()
//        accessoryView.drawAccessoryView()
    }
    
    /// 获取需要绘制的模型
    private func fetchDrawModels() {
        // 展示的个数

        if drawStartIndex < 0 {
            drawStartIndex = configuration.klineModels.count - drawCount - 1
        }
        
        drawStartIndex -= lastOffsetIndex
        
        drawStartIndex = drawStartIndex > 0 ? drawStartIndex : 0
        if drawStartIndex > configuration.klineModels.count - drawCount - 1 {
            drawStartIndex = configuration.klineModels.count - drawCount - 1
        }

        var startIndex: Int = drawStartIndex
        
//        if pinchStartIndex > 0 {
//            startIndex = pinchStartIndex
//            drawStartIndex = pinchStartIndex
//            pinchStartIndex = -1
//
//        }
        
        configuration.drawKLineModels.removeAll()
        
        configuration.drawKLineModels = (configuration.klineModels as NSArray).subarray(with: NSMakeRange(drawStartIndex, drawCount)) as! [OKKLineModel]
//        if startIndex < configuration.klineModels.count {
//            
//            if (startIndex + drawCount) <= configuration.klineModels.count {
//                configuration.drawKLineModels = (configuration.klineModels as NSArray).subarray(with: NSMakeRange(startIndex, drawCount)) as! [OKKLineModel]
//                
//            } else {
//                configuration.drawKLineModels = (configuration.klineModels as NSArray).subarray(with: NSMakeRange(startIndex, configuration.klineModels.count - startIndex)) as! [OKKLineModel]
//            }
//        }
    }
    
    // MARK: - 手势事件
    // MARK: 捏合手势
    @objc
    private func pinchAction(_ sender: UIPinchGestureRecognizer) {
        
//        var lastScale: CGFloat = 1.0
//        let difValue = sender.scale - lastScale
//        
//        if abs(difValue) > configuration.klineScale {
//            
//            let lastKLineWidth: CGFloat = configuration.klineWidth
//            
//            configuration.klineWidth = configuration.klineWidth * (difValue > 0 ?
//                (1 + configuration.klineScaleFactor) : (1 - configuration.klineScaleFactor))
//            lastScale = sender.scale
//
//            if sender.numberOfTouches == 2 {
//                let pinchPoint1 = sender.location(ofTouch: 0, in: contentView)
//                let pinchPoint2 = sender.location(ofTouch: 1, in: contentView)
//                
//                let centerPoint = CGPoint(x: (pinchPoint1.x + pinchPoint2.x) * 0.5,
//                                          y: (pinchPoint1.y + pinchPoint2.y) * 0.5)
//                
//                let oldOffsetCount = abs(centerPoint.x - lastOffset) /
//                    (configuration.klineSpace + lastKLineWidth)
//                
//                let newOffsetCount = abs(centerPoint.x - lastOffset) /
//                    (configuration.klineSpace + configuration.klineWidth)
//                
//                pinchStartIndex = drawStartIndex + Int(oldOffsetCount - newOffsetCount)
//                
//            }
//            drawKLineView(lastest: false)
//        }
    }
    
    // MARK: 长按手势
    @objc
    private func longPressAction(_ recognizer: UILongPressGestureRecognizer) {
        
        
    }
    
    // MARK: 双击手势
    @objc
    private func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        
    }

    // MARK: 移动手势
    // 左 -> 右 : x递增, x > 0
    // 右 -> 左 : x递减, x < 0
    @objc
    private func panGestureAction(_ recognizer: UIPanGestureRecognizer) {
        
        // 偏移量
        var offsetX = recognizer.translation(in: recognizer.view).x
        if (offsetX > 100) {
            offsetX = offsetX / 2;
        } else if (offsetX > 50) {
            offsetX = offsetX / 4;
        } else {
            offsetX = offsetX / 8;
        }
        
        // 偏移几个
        lastOffsetIndex = Int(offsetX / (configuration.klineSpace + configuration.klineWidth))

        drawKLineView(lastest: false)
    
//        recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
//        lastOffsetX = nil
        
    }
 
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
