//
//  OKSegmentView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif

enum OKSegmentDirection {
    case horizontal
    case vertical
}

@objc
protocol OKSegmentViewDelegate: NSObjectProtocol {
    @objc
    optional func didSelectedSegment(segmentView: OKSegmentView, index: Int, title: String)
}


class OKSegmentView: OKView {

    /// 展示文本数组
    public var titles: [String] = [String]()
    public var direction: OKSegmentDirection = .horizontal
    public weak var delegate: OKSegmentViewDelegate?
    public var didSelectedSegment: ((_ segmentView: OKSegmentView, _ result: (index: Int, title: String)) -> Void)?
    
    private var scrollView: UIScrollView!
    private var btns = [UIButton]()
    private var configuration: OKConfiguration!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(direction: OKSegmentDirection, titles: [String], configuration: OKConfiguration) {
        self.init()
        self.direction = direction
        self.titles = titles
        self.configuration = configuration
        
        backgroundColor = configuration.mainViewBgColor
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        for (index, title) in titles.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(OKColor.white, for: .normal)
            btn.titleLabel?.font = OKFont.systemFont(size: 12)
            btn.tag = index
            btn.addTarget(self, action: #selector(selectedAction(_:)), for: .touchUpInside)
            scrollView.addSubview(btn)
            btns.append(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        
        var lastBtn: UIButton?

        for (index, btn) in btns.enumerated() {
            switch direction {
            case .horizontal:
                
                let x = lastBtn == nil ? 0 : lastBtn!.frame.maxX
                
                let textWidth = titles[index].stringSize(maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height), fontSize: 12).width + 10
                
                let width = textWidth < 60 ? 60 : textWidth
                
                btn.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)

                lastBtn = btn
                scrollView.contentSize = CGSize(width: lastBtn!.frame.maxX, height: bounds.height)
                
            case .vertical:
                
                let y = lastBtn == nil ? 0 : lastBtn!.frame.maxY
                btn.frame = CGRect(x: 0, y: y, width: bounds.width, height: 44.0)
                lastBtn = btn
                scrollView.contentSize = CGSize(width: bounds.width, height: lastBtn!.frame.maxY)
            }
        }
    }
    
    @objc
    private func selectedAction(_ sender: UIButton) {
        delegate?.didSelectedSegment?(segmentView: self, index: sender.tag, title: titles[sender.tag])
        didSelectedSegment?(self, (sender.tag, titles[sender.tag]))
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
