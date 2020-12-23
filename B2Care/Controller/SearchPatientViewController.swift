//
//  SearchPatientViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit
import AVFoundation

class SearchPatientViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: - Properties
    var captureSession = AVCaptureSession()
    var previewLayer =  AVCaptureVideoPreviewLayer()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadtaOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadtaOutput){
            captureSession.addOutput(metadtaOutput)
            
            metadtaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadtaOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
   
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
    }
    
    func failed() {
        showMessage(withTitle: "Chyba", message: "Skenování není podporováno")
    }
    
    func found(code: String) {
        print(code)
    }

}
