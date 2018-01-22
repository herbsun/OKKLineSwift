//
//  OKKLineViewController.swift
//  OKKLineSwift
//
//  Copyright © 2016年 Herb - https://github.com/Herb-Sun/OKKLineSwift
//

import UIKit

class OKKLineViewController: UIViewController {

    var klineView: OKKLineView!
    
    // fix data use database by CC on 22/01/2018.
    func sqliteHandle() {
        print(sqliteHandle)
        
        if let list = CCSQLiteData.readDefaultDataList() {
            let datas = list as! [[Double]]
            
            print(datas.count)
            var dataArray = [OKKLineModel]()
            for data in datas {
                
                let model = OKKLineModel(date: data[0], open: data[1], close: data[4], high: data[2], low: data[3], volume: data[5])
                dataArray.append(model)
            }
            
            self.klineView.drawKLineView(klineModels: dataArray)
        }
    }
    
    var backButton: UIButton!;
    func loadingUI() {
        print(loadingUI)
        
        backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(size: 12)
        backButton.backgroundColor = UIColor.blue
        backButton.addTarget(self, action:#selector(backHandle(button:)) , for: .touchUpInside)
        
        view.addSubview(backButton)
    }
    
    func backHandle(button: UIButton) {
        print("backHandle")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        klineView = OKKLineView()
        klineView.doubleTapHandle = { () -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        view.addSubview(self.klineView)
        klineView.snp.makeConstraints { (make) in
            make.edges.equalTo(OKEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        loadingUI()
        
//        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
        
        // fix data use database by CC on 22/01/2018.
        sqliteHandle()
        
//        fetchData()
        
//        timer.fire()
        
        //let unitValue = (limitValue.maxValue - limitValue.minValue) / Double(drawHeight)
        //let drawValue = Double(drawMaxY - drawY) * unitValue + limitValue.minValue
        //let drawY: CGFloat = abs(self.drawMaxY - CGFloat((drawValue - limitValue.minValue) / unitValue))

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
