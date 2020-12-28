//
//  DocumentsViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.12.2020.
//

import UIKit

class DocumentsViewController: UIViewController {
    
    // MARK: - Properties
    private let documentTable = UITableView()
    private let labTable = UITableView()
    private let cellId = "CellID"
    
    var data: DocumentsData? {
        didSet{
            documentTable.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
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
        if let data = data{
            return data.documents.count
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = documentTable.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DocumentCell{
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
        //        }
        //        return nil
    }
    
}
