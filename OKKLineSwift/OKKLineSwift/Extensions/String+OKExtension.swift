//
//  String+OKExtension.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/22.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func stringSize(maxSize: CGSize, fontSize: CGFloat) -> CGSize {
        
        let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)]
        
        let text: NSString = NSString(cString: self.cString(using: String.Encoding.utf8)!,
                                      encoding: String.Encoding.utf8.rawValue)!
        
        let rect = text.boundingRect(with: maxSize,
                                     options: [.usesLineFragmentOrigin],
                                     attributes: attrs, context: nil)
        return rect.size
    }
}

//extension NSAttributedString {
//    
//    func attributedStringSize(maxSize: CGSize, fontSize: CGFloat) -> CGSize {
//        
//        
//        boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
//    }
//}
