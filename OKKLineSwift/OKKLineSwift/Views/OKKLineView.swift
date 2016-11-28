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
    public var doubleTapHandle: (() -> Void)?
    
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

    private var lastScale: CGFloat = 1.0
    private var lastPanPoint: CGPoint?
    private var lastOffsetIndex: Int?
    
    /// 开始draw的数组下标
    private var drawStartIndex: Int?
    /// draw的个数
    private var drawCount: Int {
        get {
            let count = Int((contentView.frame.width) / (configuration.klineSpace + configuration.klineWidth))
            return count > configuration.klineModels.count ? configuration.klineModels.count : count
        }
    }
    
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
    
    public func drawKLineView(_ initialize: Bool = true) {
        
        fetchDrawModels()
        
//        if lastest {
//            //设置contentOffset
//            let klineViewWidth = CGFloat(configuration.klineModels.count) * (configuration.klineWidth + configuration.klineSpace) + 10
//            let offset = klineViewWidth - contentView.bounds.width
//            contentView.contentOffset = CGPoint(x: (offset > 0 ? offset : 0), y: 0)
//        }
        
        mainView.drawMainView()

        
        volumeView.drawVolumeView()
//        accessoryView.drawAccessoryView()
    }
    
    /// 获取需要绘制的模型
    private func fetchDrawModels() {
        // 展示的个数
        
        if drawStartIndex == nil {
            drawStartIndex = configuration.klineModels.count - drawCount - 1
        }
        
        if lastOffsetIndex != nil {
            drawStartIndex! -= lastOffsetIndex!
        }

        drawStartIndex! = drawStartIndex! > 0 ? drawStartIndex! : 0
        if drawStartIndex! > configuration.klineModels.count - drawCount - 1 {
            drawStartIndex! = configuration.klineModels.count - drawCount - 1
        }

        configuration.drawKLineModels.removeAll()
        
        configuration.drawKLineModels = (configuration.klineModels as NSArray).subarray(with: NSMakeRange(drawStartIndex! > 0 ? drawStartIndex! : 0, drawCount)) as! [OKKLineModel]
//        for model in configuration.drawKLineModels {
//            
//            print(model.propertyDescription())
//        }
    }
    
    // MARK: - 手势事件
    // MARK: 捏合手势
    
    /// 捏合手势
    /// 内 -> 外: recognizer.scale 递增, 且recognizer.scale > 1.0
    /// 外 -> 内: recognizer.scale 递减, 且recognizer.scale < 1.0
    /// - Parameter recognizer: UIPinchGestureRecognizer
    @objc
    private func pinchAction(_ recognizer: UIPinchGestureRecognizer) {
        
        let difValue = recognizer.scale - lastScale
        
        if abs(difValue) > configuration.klineScale {

            let lastKLineWidth: CGFloat = configuration.klineWidth
            let newKLineWidth: CGFloat = configuration.klineWidth * (difValue > 0 ?
                (1 + configuration.klineScaleFactor) : (1 - configuration.klineScaleFactor))
            
            // 超过限制 不在绘制
            if newKLineWidth > configuration.klineMaxWidth || newKLineWidth < configuration.klineMinWidth {
                return
            }
        
            configuration.klineWidth = newKLineWidth
            lastScale = recognizer.scale

            if recognizer.numberOfTouches == 2 {
                
                let pinchPoint1 = recognizer.location(ofTouch: 0, in: recognizer.view)
                let pinchPoint2 = recognizer.location(ofTouch: 1, in: recognizer.view)

                let centerPoint = CGPoint(x: (pinchPoint1.x + pinchPoint2.x) * 0.5,
                                          y: (pinchPoint1.y + pinchPoint2.y) * 0.5)
                
                let lastOffsetCount = Int(centerPoint.x / (configuration.klineSpace + lastKLineWidth))
                let newOffsetCount = Int(centerPoint.x / (configuration.klineSpace + configuration.klineWidth))
                
                lastOffsetIndex = newOffsetCount - lastOffsetCount
                
            }
            drawKLineView(false)
            lastOffsetIndex = nil
        }
    }
    
    // MARK: 长按手势
    @objc
    private func longPressAction(_ recognizer: UILongPressGestureRecognizer) {
        
        
    }

    // MARK: 移动手势

    /// 移动手势
    /// 左 -> 右 : x递增, x > 0
    /// 右 -> 左 : x递减, x < 0
    /// - Parameter recognizer: UIPanGestureRecognizer
    @objc
    private func panGestureAction(_ recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
        case .began:
            lastPanPoint = recognizer.location(in: recognizer.view)
        case .changed:
            
            let location = recognizer.location(in: recognizer.view)
            let klineUnit = configuration.klineWidth + configuration.klineSpace

            if abs(location.x - lastPanPoint!.x) < klineUnit {
                return
            }
            
            lastOffsetIndex = Int((location.x - lastPanPoint!.x) / klineUnit)
            
            drawKLineView(false)
            // 记录上次点
            lastPanPoint = location
            
        case .ended:
            
            lastOffsetIndex = nil
            lastPanPoint = nil

        default: break
        }
    }
    
    // MARK: 双击手势
    @objc
    private func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        doubleTapHandle?()
    }
 
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
