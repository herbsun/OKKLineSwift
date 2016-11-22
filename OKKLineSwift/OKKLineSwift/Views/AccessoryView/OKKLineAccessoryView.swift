//
//  OKKLineAccessoryView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/7.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class OKKLineAccessoryView: UIView {
    
    // MARK: - Property
    public var startXPosition: CGFloat = 0.0
    
    private var drawAccessoryPositionModels = [OKVolumePositionModel]()
    private let configuration = OKConfiguration.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func drawAccessoryView() {
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        // 背景色
        ctx?.clear(rect)
        ctx?.setFillColor(configuration.accessoryViewBgColor)
        ctx?.fill(rect)
        
    }

    private func fetchDrawAccessoryPositionModels() {
        
    }
}
