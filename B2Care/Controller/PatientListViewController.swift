//
//  PatientListViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PatientListViewController: UIViewController {
    // MARK: - Properties
    private let cellId = "cellId"
    private let table = UITableView()
    private let searchInput = SearchField()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        B2CareService.shared.getPatients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .mainColor
       // hideKeyboardWhenTappedAround()
        prepareSearchFieldStyle()
        prepareTableViewStyle()
    }
    
    private func prepareTableViewStyle(){
        table.delegate = self
        table.dataSource = self
        table.register(PatientCell.self, forCellReuseIdentifier: cellId)
        table.backgroundColor = .backgroundLight
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.allowsSelection = true
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchInput.snp.bottom).offset(5)
        }
    }
    
    private func prepareSearchFieldStyle(){
        view.addSubview(searchInput)
        searchInput.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(view.frame.height / 10)
            make.height.equalTo(30)
        }
    }
}

extension PatientListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PatientCell{
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let urgentMessageAction = UIContextualAction(style: .normal, title: "Urgentní zpráva OL") { (action, sourceView, completionHandler) in
            
        }
        urgentMessageAction.image = UIImage(systemName: "exclamationmark.bubble.fill")
        urgentMessageAction.image?.withTintColor(.white)
        urgentMessageAction.backgroundColor = .systemPink
        
        let addTaskAction = UIContextualAction(style: .normal, title: "Nový úkol") { (action, sourceView, completionHandler) in
            
        }
        addTaskAction.image = UIImage(systemName: "plus")
        addTaskAction.image?.withTintColor(.white)
        addTaskAction.backgroundColor = .systemGreen
        
        
        return UISwipeActionsConfiguration(actions: [addTaskAction,urgentMessageAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(PatientDetailViewController(), animated: true)
    }
    
    
}
