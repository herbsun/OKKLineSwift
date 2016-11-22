//
//  OKKLineViewController.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/21.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class OKKLineViewController: UIViewController {

    var klineView: OKKLineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.klineView = OKKLineView()
        self.view.addSubview(self.klineView)
        self.klineView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    func fetchData() {
        let param = ["type" : "5min",
                     "symbol" : "okcoincnbtccny",
                     "size" : "300"]
        Just.post("https://www.btc123.com/kline/klineapi", params: param, asyncCompletionHandler: { (result) -> Void in
            
            print(result)
            DispatchQueue.main.async(execute: { 
                
                if result.ok {
                    let resultData = result.json as! [String : Any]
                    let datas = resultData["datas"] as! [[Double]]
                    OKConfiguration.shared.klineModels.removeAll()
                    for data in datas {
                        
                        let model = OKKLineModel(coinType: .BTC, date: data[0], volume: data[5], open: data[1], close: data[4], high: data[2], low: data[3])
                        OKConfiguration.shared.klineModels.append(model)
                    }
                    self.klineView.drawKLineView(lastest: true)
                }
                
                
            })
            
        })
    }
}
