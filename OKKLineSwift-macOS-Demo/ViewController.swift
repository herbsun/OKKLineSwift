//
//  ViewController.swift
//  OKKLineSwift-macOS-Demo
//
//  Created by Herb on 2016/12/2.
//
//

import Cocoa

class ViewController: NSViewController {

    var klineView: OKKLineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        klineView = OKKLineView()
        view.addSubview(klineView)
        klineView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        fetchData()
    }
    
    @objc
    func fetchData() {
        let param = ["type" : "5min",
                     "symbol" : "okcoincnbtccny",
                     "size" : "1000"]
        Just.post("https://www.btc123.com/kline/klineapi", params: param, asyncCompletionHandler: { (result) -> Void in
            
            print(result)
            DispatchQueue.main.async(execute: {
                
                if result.ok {
                    let resultData = result.json as! [String : Any]
                    let datas = resultData["datas"] as! [[Double]]
                    
                    var dataArray = [OKKLineModel]()
                    for data in datas {
                        
                        let model = OKKLineModel(date: data[0], open: data[1], close: data[4], high: data[2], low: data[3], volume: data[5])
                        dataArray.append(model)
                    }
                    
                    //                    for model in OKConfiguration.shared.klineModels {
                    //                        print(model.propertyDescription())
                    //                    }
                    self.klineView.drawKLineView(klineModels: dataArray)
                }
                
                
            })
            
        })
    }
}

