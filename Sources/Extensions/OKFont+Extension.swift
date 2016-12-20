//
//  OKFont+Extension.swift
//  OKKLineSwift-macOS-Demo
//
//  Created by SHB on 2016/12/1.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OKFont = UIFont
#else
    import Cocoa
    public typealias OKFont = NSFont
#endif

extension OKFont {
    
    public class func systemFont(size: CGFloat) -> OKFont {
        return systemFont(ofSize: size)
    }
    
    public class func boldSystemFont(size: CGFloat) -> OKFont {
        return boldSystemFont(ofSize: size)
    }
}
