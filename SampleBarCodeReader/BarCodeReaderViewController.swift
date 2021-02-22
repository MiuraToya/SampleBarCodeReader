//
//  BarCodeReaderViewController.swift
//  SampleBarCodeReader
//
//  Created by 三浦　登哉 on 2021/02/22.
//

import Foundation
import UIKit
import AVFoundation

final class BarCodeReaderViewController: UIViewController {
    
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // カメラ、マイクを管理するオブジェクトを生成(デバイスの条件指定)
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualWideCamera], mediaType: .video, position: .back)
        
        // 上記の条件に合致するデバイスを取得
        let devices = discoverySession.devices
        
        if let backCamera = devices.first {
            do {
                // デバイスをsessionに渡すための設定(カメラを取り込むイメージ)
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    
                    // 背面カメラの映像からQRコードを検出するための設定(データを取り込むイメージ)
                    let metadataOutput = AVCaptureMetadataOutput()
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        
                        // コードのデータ検出時の処理(第一引数はデリゲートの指定先 )
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        // バーコードの種類を指定
                        metadataOutput.metadataObjectTypes = [.ean13]
                        
                        // 検出可能範囲の設定
                        let x: CGFloat = 0.1
                        let y: CGFloat = 0.4
                        let width: CGFloat = 0.8
                        let height: CGFloat = 0.2
                        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                        
                        
                        // 背面カメラの映像を画面に表示するためのレイヤーを作成
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                                                previewLayer.frame = self.view.bounds
                                                previewLayer.videoGravity = .resizeAspectFill
                                                self.view.layer.addSublayer(previewLayer)
                        
                        // 読み取り可能エリアに赤い枠を追加する
                        let detectionArea = UIView()
                        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
                        detectionArea.layer.borderColor = UIColor.red.cgColor
                        detectionArea.layer.borderWidth = 3
                        view.addSubview(detectionArea)
                        
                        // 閉じるボタン
                        let closeBtn:UIButton = UIButton()
                        closeBtn.frame = CGRect(x: 20, y: 20, width: 100, height: 40)
                        closeBtn.setTitle("閉じる", for: UIControl.State.normal)
                        closeBtn.backgroundColor = UIColor.lightGray
                        closeBtn.addTarget(self, action: #selector(tappedBtn(sender:)), for: .touchUpInside)
                        
                        // 読み取る
                        self.session.startRunning()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // カメラの画質を設定
    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    // 閉じるボタンの処理
    @objc func tappedBtn(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension BarCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    // 取得したデータの具体的な処理
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadata == nil {
                return
            } else {
                let alert = UIAlertController(title: "バーコードの中身", message: metadata.stringValue, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
