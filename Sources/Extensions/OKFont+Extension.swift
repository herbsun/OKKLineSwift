//
//  OKFont+Extension.swift
//  OKKLineSwift-macOS-Demo
//
//  Created by SHB on 2016/12/1.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
#if os(macOS)
    import AppKit
    public typealias OKFont = NSFont
#else
    import UIKit
    public typealias OKFont = UIFont
#endif

extension OKFont {
    
    public class func systemFont(size: CGFloat) -> OKFont {
        return systemFont(ofSize: size)
    }
    
    public class func boldSystemFont(size: CGFloat) -> OKFont {
        return boldSystemFont(ofSize: size)
    }
}
