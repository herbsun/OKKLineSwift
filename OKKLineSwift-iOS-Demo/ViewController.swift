//
//  ViewController.swift
//  OKKLineSwift-iOS-Demo
//
//  Copyright © 2016年 Herb - https://github.com/Herb-Sun/OKKLineSwift
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showKLine() {
                
        let klineVC = OKKLineViewController()
        klineVC.modalTransitionStyle = .crossDissolve
        present(klineVC, animated: true, completion: nil)
        
    }
}

