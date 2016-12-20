//
//  OKEdgeInsets+Extension.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/21.
//
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OKEdgeInsets = UIEdgeInsets
#else
    import Cocoa
    public typealias OKEdgeInsets = EdgeInsets
#endif


