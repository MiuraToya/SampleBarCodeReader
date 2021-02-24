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
        self.view.backgroundColor = .white
        
        // バーコードリーダーのモーダルが開くボタン
        let buttonSize: CGFloat = 100
        let button: UIButton = UIButton()
        button.frame = CGRect(x: (self.view.frame.width - buttonSize) / 2, y: (self.view.frame.height - buttonSize) / 2, width: buttonSize, height: buttonSize)
        button.backgroundColor = .red
        button.setTitle("開く", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(taped(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    // ボタンが押されたら呼ばれます
    @objc func taped(sender: UIButton) {
        self.present(BarCodeReaderVC(), animated: true, completion: nil)
    }
}
