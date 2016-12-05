//
//  OKKLineView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

class OKKLineView: OKView {
    
    public var klineDrawView: OKKLineDrawView!
    public var doubleTapHandle: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        klineDrawView = OKKLineDrawView()
        // 双击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
        addSubview(klineDrawView)
        klineDrawView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 44, 50))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawKLineView(_ initialize: Bool = true) {
        klineDrawView.drawKLineView(initialize)
    }
    
    // MARK: 双击手势
    @objc
    private func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        doubleTapHandle?()
    }
}
