//
//  DocumentDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.12.2020.
//

import UIKit
import QuickLook

class DocumentDetailViewController: UIViewController {
    
    // MARK: - Properties
    let previewController = QLPreviewController()
    
    
    var data: Any? {
        didSet{
            updateView(with: data)
        }
    }
    private var fileURL: URL?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    private func updateView(with data: Any?){
        guard let data = data as? Document, let itemURL = URL(string: data.value) else { return }
        do {
            // Download the pdf and get it as data
            // This should probably be done in the background so we don't
            // freeze the app. Done inline here for simplicity
            let dataFromUrl = try Data(contentsOf: itemURL)
            
            // Give the file a name and append it to the file path
            fileURL = FileManager().temporaryDirectory.appendingPathComponent("sample.pdf")
            // Write the pdf to disk in the temp directory
            if let fileURL = fileURL {
                try dataFromUrl.write(to: fileURL, options: .atomic)
                
                
                // Make sure the file can be opened and then present the pdf
                if QLPreviewController.canPreview(fileURL as QLPreviewItem) {
                    present(previewController, animated: true, completion: nil)
                    previewController.navigationItem.backButtonTitle = "Zpět"
                    previewController.navigationItem.leftBarButtonItem?.title = "Zpět"
                }
            }
        } catch {
            // cant find the url resource
            showMessage(withTitle: "Chyba", message: error.localizedDescription)
        }
    }
    
    private func prepareView(){
        previewController.dataSource = self
        view.backgroundColor = .backgroundLight
    }
}



extension DocumentDetailViewController: QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = fileURL else {
            fatalError("Could not load pdf")
        }
        
        return url as QLPreviewItem
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().barTintColor = .mainColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)]
        return self
    }
    
}
