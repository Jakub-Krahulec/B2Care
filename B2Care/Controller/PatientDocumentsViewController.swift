//
//  DocumentsViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.12.2020.
//

import UIKit
import QuickLook

class PatientDocumentsViewController: BaseViewController {
    
    // MARK: - Properties
    private let table = UITableView()
    private let cellId = "CellID"
    private var fileURL: URL?
    private let refreshControl = UIRefreshControl()
    var sectionsOpened = [true, true]
    
    var documentsData: DocumentsData? {
        didSet{
            table.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    var labResultsData: DocumentsData? {
        didSet{
            table.reloadSections(IndexSet(integer: 1), with: .fade)
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
    
    @objc private func refresh(_ sender: AnyObject){
        refreshControl.endRefreshing()
    }
    
    @objc private func handleSectionCollapse(sender: UITapGestureRecognizer){
        guard let view = sender.view else {return}
        let section = view.tag
        var indexPaths = [IndexPath]()
        
        if section == 0 {
            guard let data = documentsData else {return}
            for row in data.documents.indices{
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        } else {
            guard let data = labResultsData else {return}
            for row in data.documents.indices{
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        }
        sectionsOpened[section].toggle()
        
        if sectionsOpened[section] {
            table.insertRows(at: indexPaths, with: .fade)
        } else {
            table.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight

        prepareTableStyle()
    }
    
    private func prepareTableStyle(){
        table.delegate = self
        table.dataSource = self
        table.register(DocumentCell.self, forCellReuseIdentifier: cellId)
        table.backgroundColor = .white
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .singleLine
        table.allowsSelection = true
        table.layer.cornerRadius = 10
        table.separatorInset = .zero
        
        table.refreshControl = refreshControl
     //   documentsRefreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(5)
        }
    }
    
    private func getHeaderViewForSection(_ section: Int) -> UIView? {
        let view = UIView()
        let image = UIImageView()
        let label = UILabel()
        
        if section == 0{
            image.image = UIImage(systemName: "person.fill")
            image.tintColor = .mainColor
            label.text = NSLocalizedString("documentation", comment: "")
            label.textColor = .mainColor
        } else {
            image.image = UIImage(systemName: "doc.fill")
            image.tintColor = .systemGreen
            label.text = NSLocalizedString("lab-results", comment: "")
            label.textColor = .systemGreen
        }
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        view.backgroundColor = .white
        view.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        view.tag = section
        
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(image.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSectionCollapse(sender:)))
        view.addGestureRecognizer(tapGesture)
                
        return view
    }
    
    private func downloadProgressChanged(value: Double){
        
    }
}

extension PatientDocumentsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !sectionsOpened[section]{
            return 0
        }
        if section == 0 {
            
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
        
        if let cell = table.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DocumentCell{
            
            if indexPath.section == 0{
                
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
        return getHeaderViewForSection(section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var document: Document?
        if indexPath.section == 0{
            if let data = documentsData{
                document = data.documents[indexPath.row]
            }
        } else {
            if let data = labResultsData{
                document = data.documents[indexPath.row]
            }
        }
        
        guard let documentData = document else { return } // , let itemURL = URL(string: data.value)
        
        
        //let dataFromUrl = try Data(contentsOf: itemURL)
        let request = NetworkService.shared.downloadFile(from: documentData.value, progressChanged: downloadProgressChanged(value:)) { [weak self] (result) in
            guard let this = self else {return}
            switch result{
                case .success(let data):
                    do {
                        this.fileURL = FileManager().temporaryDirectory.appendingPathComponent("\(documentData.name).pdf")
                        
                        if let fileURL = this.fileURL {
                            try data.write(to: fileURL, options: .atomic)
                            if QLPreviewController.canPreview(fileURL as QLPreviewItem) {
                                let previewController = QLPreviewController()
                                previewController.dataSource = this
                                previewController.modalPresentationStyle = .popover
                                previewController.modalTransitionStyle = .flipHorizontal
                                this.present(previewController, animated: true, completion: nil)
                            }
                            
                        }
                    } catch {
                        this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
                    }
                case .failure(let error):
                    this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
            }
            this.removeRequests()
        }
        downloadRequests.insert(request)
        
        
    }
}


extension PatientDocumentsViewController: QLPreviewControllerDataSource{
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
