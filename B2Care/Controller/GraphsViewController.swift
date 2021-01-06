//
//  GraphsViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import UIKit

class GraphsViewController: UIViewController {
    // MARK: - Properties
    private let table = UITableView()
    private let cellId = "CellID"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        prepareTableStyle()
    }
    
    private func prepareTableStyle(){
        let headerHeight = (view.frame.height / 10) + 35
        let tabbarHeight: CGFloat = 50
        let buttonsHeight: CGFloat = 50
        let padding: CGFloat = 45
        let offset: CGFloat = view.frame.height - (headerHeight + tabbarHeight + buttonsHeight + padding) - 5
        
        table.register(DocumentCell.self, forCellReuseIdentifier: cellId)
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 10
        table.separatorInset = .zero
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(view.snp.top).offset(offset)
            make.left.right.equalToSuperview().inset(5)
        }
    }
}

extension GraphsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let cell = cell as? DocumentCell{
            cell.data = Document(id: 1, name: "Průběh nemoci 2020", created: "1.1.2020 ve 13:00", updated: "", value: "")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = BarChartViewController()
        controller.data = "POkus"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
