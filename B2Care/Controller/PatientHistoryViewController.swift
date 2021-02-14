//
//  PatientHistoryViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 11.02.2021.
//

import UIKit
import PhotosUI
import QuickLook

class PatientHistoryViewController: BaseViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    
    private let addButton = UIButton()
    private let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let cellID = "cellid"
    private var images = [UIImage]()
    private var imagesURL = [URL]()
    private var photoURL: URL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    @objc private func handleAddButtonTapped(sender: UIButton){
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        
//        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 30
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .white
        
        prepareAddButtonStyle()
        prepareCollectionStyle()
    }
    
    private func prepareCollectionStyle(){
        collection.delegate = self
        collection.dataSource = self
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collection.backgroundColor = .clear
        
        view.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    private func prepareAddButtonStyle(){
        addButton.setTitle("Přidat foto", for: .normal)
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(handleAddButtonTapped(sender:)), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
    }
}

extension PatientHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        if let cell = cell as? PhotoCollectionViewCell{
            cell.data = images[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let imgUrl = imagesURL[indexPath.row]
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
}

extension PatientHistoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width / 2) - 30
        return CGSize(width: size, height: size)
    }
}

extension PatientHistoryViewController: PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.count > 0{
            images = [UIImage]()
        }
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        let dispatchGroup = DispatchGroup()
        
        for (index,result) in results.enumerated(){
            dispatchGroup.enter()
            queue.async { [weak self] in
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    let name = "name\(index)"
                    print(name)
                    if let image = object as? UIImage, let url = self?.saveImage(image, name: name) {
                        DispatchQueue.main.async {
                            print("obrázek")
                            self?.imagesURL.append(url)
                            self?.images.append(image)
                        }
                    } else {
                        print("není obrázek")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main){ [weak self] in
            print("hotovo")
            self?.collection.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//        if results.count > 0{
//            images = [UIImage]()
//        }
//
//        let queue = DispatchQueue.global(qos: .userInitiated)
//        let dispatchGroup = DispatchGroup()
//
//        for result in results{
//            dispatchGroup.enter()
//            queue.async { [weak self] in
//                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.jpeg") { (url, error) in
//                    guard error == nil, let url = url else{
//                        dispatchGroup.leave()
//                        print(error?.localizedDescription)
//                        return
//                    }
//                    let stringUrl = url.path
//                    //  print(stringUrl)
//
//                    if let image = UIImage(contentsOfFile: stringUrl){
//                        self?.imagesURL.append(url)
//                        self?.images.append(image)
//                    } else{
//                        print("failed: \(stringUrl)")
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//        }
//
//        dispatchGroup.notify(queue: .main){ [weak self] in
//            print("hotovo")
//            self?.collection.reloadData()
//            picker.dismiss(animated: true, completion: nil)
//        }
//    }
}

extension PatientHistoryViewController: QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return images.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = imagesURL[index]
        return url as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode{
        return .updateContents
    }
    
}

extension PatientHistoryViewController: QLPreviewControllerDelegate{
    
}
