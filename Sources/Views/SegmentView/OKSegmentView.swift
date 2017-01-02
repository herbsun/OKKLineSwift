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

enum OKSegmentDirection {
    case horizontal
    case vertical
}

@objc
protocol OKSegmentViewDelegate: NSObjectProtocol {
    @objc
    optional func didSelectedSegment(segmentView: OKSegmentView, index: Int, title: String)
}


class OKSegmentView: UIView {

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
        
        backgroundColor = configuration.main.backgroundColor
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        for (index, title) in titles.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
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
