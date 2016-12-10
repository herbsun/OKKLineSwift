//
//  OKView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/1.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(macOS)
    import AppKit
    public typealias BaseView = NSView
#else
    import UIKit
    public typealias BaseView = UIView
#endif

class OKView: BaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor =
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
