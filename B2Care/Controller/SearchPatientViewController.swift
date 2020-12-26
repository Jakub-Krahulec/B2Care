//
//  SearchPatientViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit
import AVFoundation

class SearchPatientViewController: UIViewController {
    // MARK: - Properties
    
   
    var previewLayer: AVCaptureVideoPreviewLayer!
    
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
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        
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
