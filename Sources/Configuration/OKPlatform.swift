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
    public typealias OKFont = UIFont
    public typealias OKColor = UIColor
    public typealias OKEdgeInsets = UIEdgeInsets
    
    func OKGraphicsGetCurrentContext() -> CGContext? {
        return UIGraphicsGetCurrentContext()
    }
    
#else
    
    import Cocoa
    public typealias OKFont = NSFont
    public typealias OKColor = NSColor
    public typealias OKEdgeInsets = EdgeInsets
    
    func OKGraphicsGetCurrentContext() -> CGContext? {
        return NSGraphicsContext.current()?.cgContext
    }
    
#endif

extension OKFont {
    
    public class func systemFont(size: CGFloat) -> OKFont {
        return systemFont(ofSize: size)
    }
    
    public class func boldSystemFont(size: CGFloat) -> OKFont {
        return boldSystemFont(ofSize: size)
    }
    
    #if os(OSX)
        public var lineHeight: CGFloat {
            // Not sure if this is right, but it looks okay
            return self.boundingRectForFont.size.height
        }
    #endif
}

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


#if os(iOS) || os(tvOS)

    class OKView: UIView {
        
        public var okBackgroundColor: OKColor? {
            didSet {
                backgroundColor = okBackgroundColor
            }
        }
        
        public func okSetNeedsDisplay() {
            setNeedsDisplay()
        }
        
        public func okSetNeedsDisplay(_ rect: CGRect) {
            setNeedsDisplay(rect)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override func draw(_ rect: CGRect) {
            super.draw(rect)
        }
    }

    class OKScrollView: UIScrollView {

    }
    
    class OKButton: UIButton {
        
    }
    
#else

    class OKView: NSView {
        
        public var okBackgroundColor: OKColor? {
            didSet {
                wantsLayer = true
                layer?.backgroundColor = okBackgroundColor?.cgColor
            }
        }
        
        public func okSetNeedsDisplay() {
            setNeedsDisplay(bounds)
        }
        
        public func okSetNeedsDisplay(_ rect: CGRect) {
            setNeedsDisplay(rect)
        }
        
        public override var isFlipped: Bool {
            get {
                return true
            }
        }
        
        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
        
            // Drawing code here.
        }
    }
    
    class OKScrollView: NSScrollView {
        
        public override var isFlipped: Bool {
            get {
                return true
            }
        }
        
        public var showsVerticalScrollIndicator: Bool = true {
            didSet {
                hasVerticalScroller = showsVerticalScrollIndicator
            }
        }
        
        public var showsHorizontalScrollIndicator: Bool = true {
            didSet {
                hasHorizontalRuler = showsHorizontalScrollIndicator
            }
        }
    }
    
    class OKButton: NSButton {
        
        public var okBackgroundColor: OKColor? {
            didSet {
                if let buttonCell = cell as? NSButtonCell {
                    buttonCell.isBordered = false
                    buttonCell.backgroundColor = okBackgroundColor
                }
            }
        }
        
    }
    
#endif

public func OKPrint(_ object: @autoclosure() -> Any?,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
    #if DEBUG
        guard let value = object() else {
            return
        }
        var stringRepresentation: String?
        
        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        }
        else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss:SSS"
        let timestamp = formatter.string(from: Date())
        let queue = Thread.isMainThread ? "UI" : "BG"
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        
        if let string = stringRepresentation {
            print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(string)")
        } else {
            print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(value)")
        }
    #endif
}

