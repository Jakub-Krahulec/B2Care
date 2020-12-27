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
  
    private var previewLayer = AVCaptureVideoPreviewLayer()
    let session  = AVCaptureSession()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

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
        
        let headerHeight = (view.frame.height / 10) + 35
        previewLayer.frame =  CGRect(x: 0, y: headerHeight, width: view.frame.width, height: view.frame.height - headerHeight)
        view.layer.addSublayer(previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
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
          //  showMessage(withTitle: "QR Kód", message: object.stringValue ?? "")
            guard let patient = object.stringValue else {return}
            self.session.stopRunning()
            
            B2CareService.shared.fetchPatients(parameters: "?search=\(patient)") { [weak self] (result) in
                switch result{
                    case .success(let data):
                        if data.data.count > 1{
                            self?.showMessage(withTitle: "Chyba", message: "Nalezen víc než jeden pacient")
                            self?.session.startRunning()
                            return
                        } else if data.data.count < 1{
                            self?.showMessage(withTitle: "Chyba", message: "Pacient nenalezen")
                            self?.session.startRunning()
                        } else {
                            let controller = PatientDetailViewController()
                            
                            controller.patientId = data.data[0].id
                            self?.navigationController?.pushViewController(controller, animated: true)
                        }   
                    case .failure(let error):
                        self?.showMessage(withTitle: "Chyba", message: error.localizedDescription)
                        self?.session.startRunning()
                }
            }
        }
    }
    
}

