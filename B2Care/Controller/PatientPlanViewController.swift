//
//  PatientPlanViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.01.2021.
//

import UIKit
import QuickLook

class PatientPlanViewController: BaseViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    private let addButton = UIButton()
    private let pickerController = UIImagePickerController()
    private let image = UIImageView()
    var photoURL: URL?
    
    // MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    @objc private func handleAddButtonTapped(_ sender: UIButton){
        present(pickerController, animated: true)
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .white
        
        prepareOpenButtonStyle()
        preparePickerController()
        
        view.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }
    
    private func preparePickerController(){
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
    }
    
    private func prepareOpenButtonStyle(){
        addButton.setTitle("Přidat", for: .normal)
        addButton.backgroundColor = .mainColor
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(handleAddButtonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }

}

extension PatientPlanViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            photoURL = imgUrl
            if QLPreviewController.canPreview(imgUrl as QLPreviewItem) {
                let previewController = QLPreviewController()
                previewController.dataSource = self
                previewController.delegate = self
                previewController.setEditing(true, animated: true)
                
                self.present(previewController, animated: true, completion: nil)
                return
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

extension PatientPlanViewController: QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = photoURL else {
            fatalError("Could not load pdf")
        }
        return url as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode{
        return .updateContents
    }

}

extension PatientPlanViewController: QLPreviewControllerDelegate{
    
}
