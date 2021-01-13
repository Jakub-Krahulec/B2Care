//
//  SearchPatientViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit
import AVFoundation

class SearchPatientViewController: BaseViewController {
    // MARK: - Properties
    let userButton = UIButton()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    let session  = AVCaptureSession()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Kvůli simulátoru
        if let _ = AVCaptureDevice.default(for: AVMediaType.video) {
            session.startRunning()
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Kvůli simulátoru
        if let _ = AVCaptureDevice.default(for: AVMediaType.video) {
            session.stopRunning()
        }
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        prepareUserButtonStyle(userButton)
        prepareHeaderViewStyle()
       
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
        
        previewLayer.session = session
        // previewLayer =  AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame =  CGRect(x: 0, y: -100, width: view.frame.width, height: view.frame.height)
        view.layer.addSublayer(previewLayer)
    }
    
    private func prepareHeaderViewStyle(){
        navigationItem.title = NSLocalizedString("patient-search", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userButton)
    }

}

extension SearchPatientViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count <= 0{
            return
        }
        guard let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {return}
        
        if object.type == AVMetadataObject.ObjectType.qr{
          //  showMessage(withTitle: "QR Kód", message: object.stringValue ?? "")
            guard let patient = object.stringValue else {return}
            self.session.stopRunning()
            
            let request = B2CareService.shared.fetchPatients(parameters: "?search=\(patient)") { [weak self] (result) in
                guard let this = self else {return}
                switch result{
                    case .success(let data):
                        if data.data.count > 1{
                            
                            this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("more-patients-found", comment: ""))
                            this.session.startRunning()
                            
                            return
                        } else if data.data.count < 1{
                            
                            this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("patient-not-found", comment: ""))
                            this.session.startRunning()
                            
                        } else {
                            
                            let controller = PatientDetailViewController()
                            controller.patientId = data.data[0].id
                            controller.hidesBottomBarWhenPushed = true
                            this.navigationController?.pushViewController(controller, animated: true)
                            
                        }   
                    case .failure(let error):
                        
                        this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
                        this.session.startRunning()
                }
                this.removeRequests()
            }
            dataRequests.insert(request)
        }
    }
    
}

