//
//  ViewController.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showKLine() {
        
        let klineVC = OKKLineViewController()
        klineVC.modalTransitionStyle = .crossDissolve
        present(klineVC, animated: true, completion: nil)
        
    }
    

}

