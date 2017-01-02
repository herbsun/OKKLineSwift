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

class OKKLineDrawView: UIView {
    
    // MARK: - Property
    public var doubleTapHandle: (() -> Void)?
    
    fileprivate var configuration: OKConfiguration!
    
    fileprivate let drawValueViewWidth: CGFloat = 50.0
    
    fileprivate var mainView: OKKLineMainView!
    fileprivate var mainValueView: OKValueView!
    
    fileprivate var volumeView: OKKLineVolumeView!
    fileprivate var volumeValueView: OKValueView!
    
    fileprivate var accessoryView: OKKLineAccessoryView!
    fileprivate var accessoryValueView: OKValueView!
    
    fileprivate var indicatorVerticalView: UIView!
    fileprivate var indicatorHorizontalView: UIView!
    
    fileprivate var lastScale: CGFloat = 1.0
    fileprivate var lastPanPoint: CGPoint?
    fileprivate var lastOffsetIndex: Int?
    
    /// 开始draw的数组下标
    fileprivate var drawStartIndex: Int?
    /// draw的个数
    fileprivate var drawCount: Int {
        get {
            let count = Int((bounds.width - drawValueViewWidth) / (configuration.theme.klineSpace + configuration.theme.klineWidth))
            return count > configuration.dataSource.klineModels.count ? configuration.dataSource.klineModels.count : count
        }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience init(configuration: OKConfiguration) {
        self.init()
        self.configuration = configuration
        
        backgroundColor = configuration.main.backgroundColor
        
        // 捏合手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        addGestureRecognizer(pinchGesture)
        // 长按手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        addGestureRecognizer(longPressGesture)
        // 双击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
        // 移动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        addGestureRecognizer(panGesture)
        
        setupSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 开启draw
    ///
    /// - Parameter initialize: 是否从最新数据位开始绘制
    public func drawKLineView(_ initialize: Bool = true) {
        
        if initialize {
            drawStartIndex = nil
            lastOffsetIndex = nil
        }
        
        fetchDrawModels()
        
        mainView.drawMainView()
        volumeView.drawVolumeView()
        accessoryView.drawAccessoryView()
    }
    
    /// 获取需要绘制的模型
    private func fetchDrawModels() {
        // 展示的个数
        
        if drawStartIndex == nil {
            drawStartIndex = configuration.dataSource.klineModels.count - drawCount - 1
        }
        
        if lastOffsetIndex != nil {
            drawStartIndex! -= lastOffsetIndex!
        }
        
        drawStartIndex! = drawStartIndex! > 0 ? drawStartIndex! : 0
        if drawStartIndex! > configuration.dataSource.klineModels.count - drawCount - 1 {
            drawStartIndex! = configuration.dataSource.klineModels.count - drawCount - 1
        }
        
        configuration.dataSource.drawKLineModels.removeAll()
        
        let loc = drawStartIndex! > 0 ? drawStartIndex! : 0
        
        configuration.dataSource.drawKLineModels = Array(configuration.dataSource.klineModels[loc...loc+drawCount])
        configuration.dataSource.drawRange = NSMakeRange(loc, drawCount)
        
    }
}

// MARK: - 子视图
extension OKKLineDrawView {
    fileprivate func setupSubviews() {
        
        setupMainView()
        setupVolumeView()
        setupAccessoryView()
        
        /// 指示器
        indicatorVerticalView = UIView()
        indicatorVerticalView.isHidden = true
        indicatorVerticalView.backgroundColor = configuration.theme.longPressLineColor
        addSubview(indicatorVerticalView)
        indicatorVerticalView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalTo(configuration.main.topAssistViewHeight)
            make.width.equalTo(configuration.theme.longPressLineWidth)
            make.leading.equalTo(0)
        }
        
        indicatorHorizontalView = UIView()
        indicatorHorizontalView.isHidden = true
        indicatorHorizontalView.backgroundColor = configuration.theme.longPressLineColor
        addSubview(indicatorHorizontalView)
        indicatorHorizontalView.snp.makeConstraints { (make) in
            make.leading.equalTo(drawValueViewWidth)
            make.trailing.equalTo(0)
            make.height.equalTo(configuration.theme.longPressLineWidth)
            make.top.equalTo(0)
        }

    }
    
    private func setupMainView() {
        /// Main View
        mainView = OKKLineMainView(configuration: configuration)
        mainView.limitValueChanged = { [weak self] (_ limitValue: (minValue: Double, maxValue: Double)?) -> Void in
            if let limitValue = limitValue {
                self?.mainValueView.limitValue = limitValue
            }
        }
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(drawValueViewWidth)
            make.height.equalToSuperview().multipliedBy(configuration.main.scale)
        }
        
        /// Main Value View
        let mainEdge = UIEdgeInsets(top: configuration.main.topAssistViewHeight,
                                    left: 0,
                                    bottom: configuration.main.bottomAssistViewHeight,
                                    right: 0)
        mainValueView = OKValueView(configuration: configuration, drawEdgeInsets: mainEdge)
        addSubview(mainValueView)
        mainValueView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.mainView.snp.leading)
            make.top.equalTo(self.mainView.snp.top)
            make.bottom.equalTo(self.mainView.snp.bottom)
        }
    }
    
    private func setupVolumeView() {
        /// Volume View
        volumeView = OKKLineVolumeView(configuration: configuration)
        volumeView.limitValueChanged = { [weak self] (_ limitValue: (minValue: Double, maxValue: Double)?) -> Void in
            if let limitValue = limitValue {
                self?.volumeValueView.limitValue = limitValue
            }
        }
        addSubview(volumeView)
        volumeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.mainView)
            make.top.equalTo(self.mainView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(configuration.volume.scale)
        }
        
        /// Volume Value View
        let volumeEdge = UIEdgeInsets(top: configuration.volume.topViewHeight, left: 0, bottom: 0, right: 0)
        volumeValueView = OKValueView(configuration: configuration, drawEdgeInsets: volumeEdge)
        addSubview(volumeValueView)
        volumeValueView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.volumeView.snp.leading)
            make.top.equalTo(self.volumeView.snp.top)
            make.bottom.equalTo(self.volumeView.snp.bottom)
        }
    }
    
    private func setupAccessoryView() {
        /// Accessory View
        accessoryView = OKKLineAccessoryView(configuration: configuration)
        accessoryView.limitValueChanged = { [weak self] (_ limitValue: (minValue: Double, maxValue: Double)?) -> Void in
            if let limitValue = limitValue {
                self?.accessoryValueView.limitValue = limitValue
            }
        }
        addSubview(accessoryView)
        accessoryView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.mainView)
            make.top.equalTo(self.volumeView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(configuration.accessory.scale)
        }
        
        /// Accessory Value View
        let asscessoryEdge = UIEdgeInsets(top: configuration.accessory.topViewHeight, left: 0, bottom: 0, right: 0)
        accessoryValueView = OKValueView(configuration: configuration, drawEdgeInsets: asscessoryEdge)
        addSubview(accessoryValueView)
        accessoryValueView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.accessoryView.snp.leading)
            make.top.equalTo(self.accessoryView.snp.top)
            make.bottom.equalTo(self.accessoryView.snp.bottom)
        }
    }
}


// MARK: - 手势集合
extension OKKLineDrawView {
    
    // MARK: 移动手势
    
    /// 移动手势
    /// 左 -> 右 : x递增, x > 0
    /// 右 -> 左 : x递减, x < 0
    /// - Parameter recognizer: UIPanGestureRecognizer
    @objc
    fileprivate func panGestureAction(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            lastPanPoint = recognizer.location(in: recognizer.view)
        case .changed:
            
            let location = recognizer.location(in: recognizer.view)
            let klineUnit = configuration.theme.klineWidth + configuration.theme.klineSpace
            
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
    
    // MARK: 捏合手势
    
    /// 捏合手势
    /// 内 -> 外: recognizer.scale 递增, 且recognizer.scale > 1.0
    /// 外 -> 内: recognizer.scale 递减, 且recognizer.scale < 1.0
    /// - Parameter recognizer: UIPinchGestureRecognizer
    @objc
    fileprivate func pinchAction(_ recognizer: UIPinchGestureRecognizer) {
        
        let difValue = recognizer.scale - lastScale
        
        if abs(difValue) > configuration.theme.klineScale {
            
            let lastKLineWidth: CGFloat = configuration.theme.klineWidth
            let newKLineWidth: CGFloat = configuration.theme.klineWidth * (difValue > 0 ?
                (1 + configuration.theme.klineScaleFactor) : (1 - configuration.theme.klineScaleFactor))
            
            // 超过限制 不在绘制
            if newKLineWidth > configuration.theme.klineMaxWidth || newKLineWidth < configuration.theme.klineMinWidth {
                return
            }
            
            configuration.theme.klineWidth = newKLineWidth
            lastScale = recognizer.scale
            
            if recognizer.numberOfTouches == 2 {
                
                let pinchPoint1 = recognizer.location(ofTouch: 0, in: recognizer.view)
                let pinchPoint2 = recognizer.location(ofTouch: 1, in: recognizer.view)
                
                let centerPoint = CGPoint(x: (pinchPoint1.x + pinchPoint2.x) * 0.5,
                                          y: (pinchPoint1.y + pinchPoint2.y) * 0.5)
                
                let lastOffsetCount = Int(centerPoint.x / (configuration.theme.klineSpace + lastKLineWidth))
                let newOffsetCount = Int(centerPoint.x / (configuration.theme.klineSpace + configuration.theme.klineWidth))
                
                lastOffsetIndex = newOffsetCount - lastOffsetCount
                
            }
            drawKLineView(false)
            lastOffsetIndex = nil
        }
    }
    
    // MARK: 长按手势
    @objc
    fileprivate func longPressAction(_ recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .began || recognizer.state == .changed {
            
            let location: CGPoint = recognizer.location(in: recognizer.view)
            
            if location.x <= drawValueViewWidth { return }
            
            let unit = configuration.theme.klineWidth + configuration.theme.klineSpace
            
            let offsetCount: Int = Int((location.x - drawValueViewWidth) / unit)
            let previousOffset: CGFloat = (CGFloat(offsetCount) + 0.5) * unit + drawValueViewWidth
            let nextOffset: CGFloat = (CGFloat(offsetCount + 1) + 0.5) * unit + drawValueViewWidth
            
            /// 显示十字线
            indicatorVerticalView.isHidden = false
            indicatorHorizontalView.isHidden = false
            
            var drawModel: OKKLineModel?
            
            mainValueView.currentValueDrawPoint = nil
            volumeValueView.currentValueDrawPoint = nil
            accessoryValueView.currentValueDrawPoint = nil
            
            if mainView.point(inside: convert(location, to: mainView), with: nil) {
                
                mainValueView.currentValueDrawPoint = convert(location, to: mainView)
                
            } else if volumeView.point(inside: convert(location, to: volumeView), with: nil) {
                
                volumeValueView.currentValueDrawPoint = convert(location, to: volumeView)
                
            } else if accessoryView.point(inside: convert(location, to: accessoryView), with: nil) {
                
                accessoryValueView.currentValueDrawPoint = convert(location, to: accessoryView)
            }
            
            indicatorHorizontalView.snp.updateConstraints({ (make) in
                make.top.equalTo(location.y)
            })
            
            if abs(previousOffset - location.x) < abs(nextOffset - location.x) {
                
                indicatorVerticalView.snp.updateConstraints({ (make) in
                    make.leading.equalTo(previousOffset)
                })
                
                if configuration.dataSource.drawKLineModels.count > offsetCount {
                    drawModel = configuration.dataSource.drawKLineModels[offsetCount]
                }
                
            } else {
                
                indicatorVerticalView.snp.updateConstraints({ (make) in
                    make.leading.equalTo(nextOffset)
                })
                if configuration.dataSource.drawKLineModels.count > offsetCount {
                    drawModel = configuration.dataSource.drawKLineModels[offsetCount + 1]
                }
            }
            
            mainView.drawAssistView(model: drawModel)
            volumeView.drawVolumeAssistView(model: drawModel)
            accessoryView.drawAssistView(model: drawModel)
            
        } else if recognizer.state == .ended {
            // 隐藏十字线
            indicatorVerticalView.isHidden = true
            indicatorHorizontalView.isHidden = true
            
            mainValueView.currentValueDrawPoint = nil
            volumeValueView.currentValueDrawPoint = nil
            accessoryValueView.currentValueDrawPoint = nil
            
            mainView.drawAssistView(model: nil)
            volumeView.drawVolumeAssistView(model: nil)
            accessoryView.drawAssistView(model: nil)
        }
    }
    
    // MARK: 双击手势
    @objc
    fileprivate func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        doubleTapHandle?()
    }
}
