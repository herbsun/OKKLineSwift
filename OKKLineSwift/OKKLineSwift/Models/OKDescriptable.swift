//
//  OKDescriptable.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/1.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation

protocol OKDescriptable {
    func propertyDescription() -> String
}

extension OKDescriptable {
    func propertyDescription() -> String {
        let strings = Mirror(reflecting: self).children.flatMap { "\($0.label!): \($0.value)" }
        var string = ""
        for str in strings {
            string += str + "\n"
        }
        return string
    }
}
