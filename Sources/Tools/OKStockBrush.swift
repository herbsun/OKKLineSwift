//
//  OKStockBrush.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/3.
//
//

import UIKit

class OKStockBrush {
    
    public var klineModels: [OKKLineModel]
    
    private var context: CGContext?
    
    init(context: CGContext?, klineModels: [OKKLineModel]) {
        self.context = context
        self.klineModels = klineModels
    }
    
    public func draw() {
        
    }
}
