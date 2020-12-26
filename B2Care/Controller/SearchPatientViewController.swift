//
//  SearchPatientViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit
import AVFoundation

class SearchPatientViewController: UIViewController, BaseHeaderDelegate, UserButtonDelegate {
    // MARK: - Properties
    private let headerView = SearchHeaderView()
  
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        let session  = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        guard let device = captureDevice else {return}
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            print(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        let headerHeight = (view.frame.height / 10) + 35
        previewLayer.frame =  CGRect(x: 0, y: headerHeight, width: view.frame.width, height: view.frame.height - headerHeight)
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        prepareHeaderViewStyle()
       

    }
    
    private func prepareHeaderViewStyle(){
        view.addSubview(headerView)
        headerView.logoutButton.delegate = self
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo((view.frame.height / 10) + 35)
        }
    }

}

extension SearchPatientViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count <= 0{
            return
        }
        guard let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {return}
        if object.type == AVMetadataObject.ObjectType.qr{
            showMessage(withTitle: "QR Kód", message: object.stringValue ?? "")
        }
    }
    
}

