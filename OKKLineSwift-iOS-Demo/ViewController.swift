//
//  ViewController.swift
//  OKKLineSwift-iOS-Demo
//
//  Created by SHB on 2016/12/2.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showKLine() {
        
        //        OKConfiguration.shared.mainViewBgColor = UIColor.randomColor().cgColor
        
        let klineVC = OKKLineViewController()
        klineVC.modalTransitionStyle = .crossDissolve
        present(klineVC, animated: true, completion: nil)
        
    }


}

