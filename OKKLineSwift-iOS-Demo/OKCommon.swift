
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

//let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
//let drawValue = Double(drawMaxY - drawY) * unitValue + limitValue.minValue
//let drawY: CGFloat = abs(self.drawMaxY - CGFloat((drawValue - limitValue.minValue) / unitValue))




