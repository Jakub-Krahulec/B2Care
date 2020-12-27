//
//  PatientListViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PatientListViewController: UIViewController, UserButtonDelegate {
    // MARK: - Properties
    private let cellId = "cellId"
    private let table = UITableView()
    private let searchInput = SearchField()
    private let userButton = UserButton()
    private var refreshControl = UIRefreshControl()
    private var patients: PatientsData?
    {
        didSet{
            table.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround(cancelsTouchesInView: false)
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchPatients()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // searchInput.text = ""
      //  navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: AnyObject){
        fetchPatients()
    }
    
    @objc private func handleSearchChangedValue(){
        fetchPatients()
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .mainColor
       // hideKeyboardWhenTappedAround()
        prepareRefreshControlStyle()
        prepareUserButtonStyle()
        prepareSearchFieldStyle()
        prepareTableViewStyle()
    }
    
    private func fetchPatients(){
        var params = ""
        if let text = searchInput.text  {
            if text.count > 0{
                params = "?search=\(text)"
            }
        }
        B2CareService.shared.fetchPatients(parameters: params) { (result) in
            switch result{
                
                case .success(let data):
                    self.patients = data
                    self.refreshControl.endRefreshing()
                case .failure(let error):
                    self.showMessage(withTitle: "Chyba", message: error.localizedDescription)
            }
        }
    }
    
    private func prepareRefreshControlStyle(){
        refreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
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
    
    private func prepareUserButtonStyle(){
       // userButton.addTarget(self, action: #selector(handleUserButtonTapped), for: .touchUpInside)
        userButton.delegate = self
        
        view.addSubview(userButton)
        userButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.top.equalTo(view.frame.height / 10)
            make.height.width.equalTo(30)
        }
    }
    
    private func prepareSearchFieldStyle(){
       // searchInput.delegate = self
        searchInput.addTarget(self, action: #selector(handleSearchChangedValue), for: .editingChanged)
        
        view.addSubview(searchInput)
        searchInput.snp.makeConstraints { (make) in
            make.left.equalTo(userButton.snp.right).offset(5)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(view.frame.height / 10)
            make.height.equalTo(30)
        }
    }
}

extension PatientListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = patients{
            return data.data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PatientCell{
            cell.selectionStyle = .none
            if let data = patients {
                cell.data = data.data[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let urgentMessageAction = UIContextualAction(style: .normal, title: "Urgentní zpráva OL") { (action, sourceView, completionHandler) in
            completionHandler(true)
        }
        urgentMessageAction.image = UIImage(systemName: "exclamationmark.bubble.fill")
        urgentMessageAction.image?.withTintColor(.white)
        urgentMessageAction.backgroundColor = .systemPink
        
        let addTaskAction = UIContextualAction(style: .normal, title: "Nový úkol") { (action, sourceView, completionHandler) in
            completionHandler(true)
        }
        addTaskAction.image = UIImage(systemName: "plus")
        addTaskAction.image?.withTintColor(.white)
        addTaskAction.backgroundColor = .systemGreen
        
        
        return UISwipeActionsConfiguration(actions: [addTaskAction,urgentMessageAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !UIApplication.shared.isKeyboardPresented{
            let controller = PatientDetailViewController()
            controller.patientId = patients?.data[indexPath.row].id
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension PatientListViewController: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if string.count > 0 {
//            fetchPatients(parameters: "?search=\(string)")
//        } else {
//            fetchPatients()
//        }
//        return true
//    }
}
