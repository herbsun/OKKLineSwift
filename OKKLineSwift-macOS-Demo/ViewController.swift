//
//  ViewController.swift
//  OKKLineSwift-macOS-Demo
//
//  Created by SHB on 2016/12/2.
//
//

import Cocoa

class ViewController: NSViewController {

    var klineView: OKKLineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        klineView = OKKLineView()
        klineView.doubleTapHandle = { () -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        view.addSubview(self.klineView)
        klineView.snp.makeConstraints { (make) in

            make.edges.equalTo(NSEdgeInsetsMake(0, 0, 0, 0))
        }
    }
}

