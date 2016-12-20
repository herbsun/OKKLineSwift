//
//  OKLabel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/21.
//
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias BaseLabel = UILabel
#else
    import Cocoa
    public typealias BaseLabel = NSTextField
#endif

class OKLabel: BaseLabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
