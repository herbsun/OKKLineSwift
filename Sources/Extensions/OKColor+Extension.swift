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
    public typealias OKColor = UIColor
#else
    import Cocoa
    public typealias OKColor = NSColor
#endif

extension OKColor {
    
    //MARK: - Hex
    
    public convenience init(hexRGB: Int, alpha: CGFloat = 1.0) {
        
        self.init(red:CGFloat((hexRGB >> 16) & 0xff) / 255.0,
                  green:CGFloat((hexRGB >> 8) & 0xff) / 255.0,
                  blue:CGFloat(hexRGB & 0xff) / 255.0,
                  alpha: alpha)
    }
    
    public class func randomColor() -> OKColor {
        
        return OKColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                       green: CGFloat(arc4random_uniform(255)) / 255.0,
                       blue: CGFloat(arc4random_uniform(255)) / 255.0,
                       alpha: 1.0)
        
    }
}
