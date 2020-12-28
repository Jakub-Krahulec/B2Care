//
//  DocumentsViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.12.2020.
//

import UIKit
import QuickLook

class DocumentsViewController: UIViewController {
    
    // MARK: - Properties
    private let documentTable = UITableView()
    private let labTable = UITableView()
    private let cellId = "CellID"
    private var fileURL: URL?
    private lazy var previewController = QLPreviewController()
    
    var documentsData: DocumentsData? {
        didSet{
            documentTable.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    var labResultsData: DocumentsData? {
        didSet{
            labTable.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        documentsData = documentsHardData
        labResultsData = laboratoryResultsHardData
    }
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        previewController.dataSource = self
        
        prepareDocumentTableViewStyle()
        prepareLabTableStyle()
    }
    
    private func prepareLabTableStyle(){
        labTable.delegate = self
        labTable.dataSource = self
        labTable.register(DocumentCell.self, forCellReuseIdentifier: cellId)
        labTable.backgroundColor = .white
        labTable.rowHeight = UITableView.automaticDimension
        labTable.separatorStyle = .singleLine
        labTable.allowsSelection = true
        labTable.layer.cornerRadius = 10
        labTable.separatorInset = .zero
        
        view.addSubview(labTable)
        labTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(documentTable.snp.bottom).offset(10)
            make.height.equalTo(view.frame.height / 3)
        }
    }
    
    private func prepareDocumentTableViewStyle(){
        documentTable.delegate = self
        documentTable.dataSource = self
        documentTable.register(DocumentCell.self, forCellReuseIdentifier: cellId)
        documentTable.backgroundColor = .white
        documentTable.rowHeight = UITableView.automaticDimension
        documentTable.separatorStyle = .singleLine
        documentTable.allowsSelection = true
        documentTable.layer.cornerRadius = 10
        documentTable.separatorInset = .zero
        
        view.addSubview(documentTable)
        documentTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(view.frame.height / 3)
        }
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == documentTable{
            if let data = documentsData{
                return data.documents.count
            }
        } else {
            if let data = labResultsData{
                return data.documents.count
            }
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = documentTable.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DocumentCell{
            if tableView == documentTable{
                if let data = documentsData{
                    cell.data = data.documents[indexPath.row]
                }
            } else {
                if let data = labResultsData{
                    cell.data = data.documents[indexPath.row]
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //  if section == 0 {
        let view = UIView()
        //  view.backgroundColor = .green
        
        
        let image = UIImageView()
        let label = UILabel()
        if tableView == documentTable{
            image.image = UIImage(systemName: "person.fill")
            image.tintColor = .mainColor
            label.text = "DOKUMENTACE PACIENTA"
            label.textColor = .mainColor
        } else {
            image.image = UIImage(systemName: "doc.fill")
            image.tintColor = .systemGreen
            label.text = "LABORATORNÍ VÝSLEDKY"
            label.textColor = .systemGreen
        }
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        view.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(image.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var document: Document?
        if tableView == documentTable{
            if let data = documentsData{
                document = data.documents[indexPath.row]
            }
        } else {
            if let data = labResultsData{
                document = data.documents[indexPath.row]
            }
        }
        
        guard let data = document, let itemURL = URL(string: data.value) else { return }
        do {
            let dataFromUrl = try Data(contentsOf: itemURL)
            fileURL = FileManager().temporaryDirectory.appendingPathComponent("nazev.pdf")
            if let fileURL = fileURL {
                try dataFromUrl.write(to: fileURL, options: .atomic)
                if QLPreviewController.canPreview(fileURL as QLPreviewItem) {
                    previewController.modalPresentationStyle = .popover
                    previewController.modalTransitionStyle = .flipHorizontal
                    present(previewController, animated: true, completion: nil)
                }
            }
        } catch {
            // cant find the url resource
            showMessage(withTitle: "Chyba", message: error.localizedDescription)
        }
    }
    
}


extension DocumentsViewController: QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = fileURL else {
            fatalError("Could not load pdf")
        }
        
        return url as QLPreviewItem
    }
    
    
}
