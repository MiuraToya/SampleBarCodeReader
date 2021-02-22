//
//  ViewController.swift
//  SampleBarCodeReader
//
//  Created by 三浦　登哉 on 2021/02/22.
//

import UIKit

class ViewController: UIViewController {
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    @IBAction func BarCodeReader(_ sender: Any) {
        self.present(BarCodeReaderViewController(), animated: true, completion: nil)
    }
}

