//
//  OKView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/1.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias BaseView = UIView
#else
    import Cocoa
    public typealias BaseView = NSView
#endif

class OKView: BaseView {
    
    public var ok_backgroundColor: OKColor {
        didSet {
            #if os(iOS) || os(tvOS)
                backgroundColor = ok_backgroundColor
            #else
                wantsLayer = true
                layer?.backgroundColor = ok_backgroundColor.cgColor
            #endif
        }
    }

    #if os(iOS) || os(tvOS)
    
        override init(frame: CGRect) {
            super.init(frame: frame)
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
    #else
        override var isFlipped: Bool {
            get {
                return true
            }
        }
        override init(frame frameRect: NSRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
            
            // Drawing code here.
        }
    #endif

}
