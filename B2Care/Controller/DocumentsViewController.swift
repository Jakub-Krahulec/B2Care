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
    private let documentsRefreshControl = UIRefreshControl()
    private let labRefreshControl = UIRefreshControl()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.showBlurLoader()
    }
    // MARK: - Actions
    
    @objc private func refreshDocuments(_ sender: AnyObject){
        documentsRefreshControl.endRefreshing()
    }
    
    @objc private func refreshLabs(_ sender: AnyObject){
        labRefreshControl.endRefreshing()
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        
        prepareDocumentTableViewStyle()
        prepareLabTableStyle()
    }
    
    private func prepareTableStyle(_ table: UITableView){
        table.delegate = self
        table.dataSource = self
        table.register(DocumentCell.self, forCellReuseIdentifier: cellId)
        table.backgroundColor = .white
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .singleLine
        table.allowsSelection = true
        table.layer.cornerRadius = 10
        table.separatorInset = .zero
    }
    
    private func prepareLabTableStyle(){
        prepareTableStyle(labTable)
        
        labTable.refreshControl = labRefreshControl
        labRefreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        labRefreshControl.addTarget(self, action: #selector(refreshLabs(_:)), for: .valueChanged)
        
        
        view.addSubview(labTable)
        labTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(documentTable.snp.bottom).offset(10)
            make.height.equalTo(view.frame.height / 3)
        }
    }
    
    private func prepareDocumentTableViewStyle(){
        prepareTableStyle(documentTable)
        
        documentTable.refreshControl = documentsRefreshControl
        documentsRefreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        documentsRefreshControl.addTarget(self, action: #selector(refreshDocuments(_:)), for: .valueChanged)
        
        
        view.addSubview(documentTable)
        documentTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(view.frame.height / 3)
        }
    }
    
    private func getHeaderViewForTable(_ table: UITableView) -> UIView? {
        let view = UIView()
        let image = UIImageView()
        let label = UILabel()
        
        if table == documentTable{
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
        
        view.backgroundColor = .white
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
        return 0
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
        return getHeaderViewForTable(tableView)
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
            fileURL = FileManager().temporaryDirectory.appendingPathComponent("\(data.name).pdf")
            
            if let fileURL = fileURL {
                try dataFromUrl.write(to: fileURL, options: .atomic)
                if QLPreviewController.canPreview(fileURL as QLPreviewItem) {
                    
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
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
