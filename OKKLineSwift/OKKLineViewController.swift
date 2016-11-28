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
        klineView = OKKLineView()
        klineView.doubleTapHandle = { () -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        view.addSubview(self.klineView)
        klineView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
        
        
        
        timer.fire()
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
    
    @objc
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
                    var dataArray = [OKKLineModel]()
                    for data in datas {
                        
                        let model = OKKLineModel(date: data[0], open: data[1], close: data[4], high: data[2], low: data[3], volume: data[5])
                        dataArray.append(model)
                    }
                    OKConfiguration.shared.klineModels = OKKLineTool.handleKLineModels(klineModels: dataArray)
                    
//                    for model in OKConfiguration.shared.klineModels {
//                        print(model.propertyDescription())
//                    }
                    
                    
                    self.klineView.drawKLineView(true)
                }
                
                
            })
            
        })
    }
}
