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
    
    private let configuration = OKConfiguration.sharedConfiguration
    private var scrollView: OKScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(direction: OKSegmentDirection, titles: [String]) {
        self.init()
        
        self.titles = titles
        self.direction = direction
        
        
        scrollView = OKScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = configuration.main.backgroundColor
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        #if os(iOS) || os(tvOS)

            var lastBtn: OKButton?
            for (index, title) in titles.enumerated() {
                let btn = OKButton(type: .custom)
                btn.tag = index
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(OKColor.white, for: .normal)
                btn.titleLabel?.font = OKFont.systemFont(size: 12)
                btn.addTarget(self, action: #selector(selectedAction(_:)), for: .touchUpInside)
                scrollView.addSubview(btn)
                
                switch direction {
                case .horizontal:
                    
                    btn.snp.makeConstraints({ (make) in
                        make.top.bottom.equalToSuperview()
                        make.size.equalTo(CGSize(width: 60, height: 44))
                        // 处理第一个button
                        if let lastBtn = lastBtn {
                            make.leading.equalTo(lastBtn.snp.trailing)
                        } else {
                            make.leading.equalToSuperview()
                        }
                        // 处理最后一个btn
                        if index == titles.count - 1 {
                            make.trailing.equalToSuperview()
                        }
                    })
                    
                case .vertical:
                    btn.snp.makeConstraints({ (make) in
                        make.leading.trailing.equalToSuperview()
                        make.size.equalTo(CGSize(width: 50, height: 44))
                        // 处理第一个button
                        if let lastBtn = lastBtn {
                            make.top.equalTo(lastBtn.snp.bottom)
                        } else {
                            make.top.equalToSuperview()
                        }
                        // 处理最后一个btn
                        if index == titles.count - 1 {
                            make.bottom.equalToSuperview()
                        }
                    })
                }
                lastBtn = btn
            }
            
        #else
            
            let containerView = OKView()
            
            var lastBtn: OKButton?
            for (index, title) in titles.enumerated() {

                let btn = OKButton()
                btn.tag = index
                btn.setButtonType(.pushOnPushOff)
                btn.bezelStyle = .rounded
                btn.target = self
                btn.action = #selector(selectedAction(_:))
                btn.okBackgroundColor = configuration.main.backgroundColor
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .center
                let attr: [NSAttributedStringKey : Any]? = [NSAttributedStringKey.font : OKFont.systemFont(size: 12),
                                            NSAttributedStringKey.foregroundColor : OKColor.white,
                                            NSAttributedStringKey.paragraphStyle : paragraph]
                btn.attributedTitle = NSAttributedString(string: title, attributes: attr)

                containerView.addSubview(btn)

                switch direction {

                case .horizontal:
                    btn.snp.makeConstraints({ (make) in
                        make.top.bottom.equalToSuperview()
                        make.width.equalTo(100)
                        if let lastBtn = lastBtn {
                            make.leading.equalTo(lastBtn.snp.trailing)
                        } else {
                            make.leading.equalToSuperview()
                        }
                    })

                case .vertical:

                    btn.snp.makeConstraints({ (make) in
                        make.leading.trailing.equalToSuperview()
                        make.height.equalTo(44.0)
                        if let lastBtn = lastBtn {
                            make.top.equalTo(lastBtn.snp.bottom)
                        } else {
                            make.top.equalToSuperview()
                        }
                    })
                }
                lastBtn = btn
            }
            
            scrollView.documentView = containerView

        #endif

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(OSX)
        override func layout() {
            super.layout()
            switch direction {
            case .horizontal:
                if let contentView = scrollView.documentView {
                    contentView.snp.makeConstraints({ (make) in
                        make.top.leading.bottom.equalToSuperview()
                        let width = CGFloat(100 * titles.count) > bounds.width ? CGFloat(100 * titles.count) : bounds.width
                        make.size.equalTo(CGSize(width: width, height: 44.0))
                    })
                }
            case .vertical:
                if let contentView = scrollView.documentView {
                    contentView.snp.makeConstraints({ (make) in
                        make.top.leading.bottom.equalToSuperview()
                        let height = CGFloat(44 * titles.count) > bounds.height ? CGFloat(44 * titles.count) : bounds.height
                        make.size.equalTo(CGSize(width: 50, height: height))
                    })
                }
            }
        }
    
    #endif
    
    
    @objc
    private func selectedAction(_ sender: OKButton) {

        delegate?.didSelectedSegment?(segmentView: self, index: sender.tag, title: titles[sender.tag])
        didSelectedSegment?(self, (sender.tag, titles[sender.tag]))
    }

}
