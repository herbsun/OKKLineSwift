/// @brief   全局字体 颜色 定义
/// @since   1.0

import Foundation
import UIKit

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
//        else {
//            fatalError("gLog only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
//        }
        
        let gFormatter = DateFormatter()
        gFormatter.dateFormat = "HH:mm:ss:SSS"
        let timestamp = gFormatter.string(from: Date())
        let queue = Thread.isMainThread ? "UI" : "BG"
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        
        if let string = stringRepresentation {
            print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(string)")
        } else {
            print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(value)")
        }
    #endif
}
