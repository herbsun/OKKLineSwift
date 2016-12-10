//
//  OKColor.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/1.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias OKColor = NSView
#else
    import UIKit
    public typealias OKColor = UIColor
#endif

extension OKColor {
    
    //MARK: - Hex
    
    public convenience init(hexRGB: Int, alpha: CGFloat = 1.0) {
        
        self.init(red:CGFloat((hexRGB >> 16) & 0xff) / 255.0,
                  green:CGFloat((hexRGB >> 8) & 0xff) / 255.0,
                  blue:CGFloat(hexRGB & 0xff) / 255.0,
                  alpha: alpha)
    }
    
    public class func randomColor() -> UIColor {
        
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                       green: CGFloat(arc4random_uniform(255)) / 255.0,
                       blue: CGFloat(arc4random_uniform(255)) / 255.0,
                       alpha: 1.0)
        
    }
}
