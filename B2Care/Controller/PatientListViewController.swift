//
//  PatientListViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PatientListViewController: BaseViewController, UISearchControllerDelegate {
    // MARK: - Properties
    private let cellId = "cellId"
    
    private let table = UITableView()
    private let userButton = UIButton()
    private let searchBar = UISearchBar()
    private var refreshControl = UIRefreshControl()
    
    private var patients: PatientsData?
    {
        didSet{
            table.reloadSections(IndexSet(integer: 0), with: .automatic)
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
       // self.tabBarController?.tabBar.isHidden = false
        setupKeyboardNotificationObservers()
        fetchPatients()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: AnyObject){
        fetchPatients()
    }
    
    private func handleSearchChangedValue(){
        fetchPatients()
    }
    
    override func keyboardDidHide(notification: Notification) {
        super.keyboardDidHide(notification: notification)
        table.scrollIndicatorInsets = .zero
        table.contentInset = .zero
        table.layoutIfNeeded()
    }
    
    override func keyboardWillShow(notification: Notification) {
        super.keyboardWillShow(notification: notification)
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - tabbarHeight, right: 0)
            table.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
        table.setContentOffset(.zero, animated: true)
    }
    
    
    // MARK: - Helpers
    
    override func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
        searchBar.resignFirstResponder()
        super.hideKeyboardWhenTappedAround(cancelsTouchesInView: cancelsTouchesInView)
    }
    
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        
        prepareUserButtonStyle(userButton)
        prepareSearchInputStyle()
        prepareTableViewStyle()
        prepareRefreshControlStyle()
    }
    
    private func prepareSearchInputStyle(){
        searchBar.delegate = self
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Vyhledat pacienta",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
       // searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    private func fetchPatients(){
        var params = ""
        if let text = searchBar.text  {
            if text.count > 0{
                params = "?search=\(text)"
            }
        }
        let request = B2CareService.shared.fetchPatients(parameters: params) { [weak self] (result) in
            guard let this = self else {return}
            switch result{
                case .success(let data):
                    this.patients = data
                    this.refreshControl.endRefreshing()
                case .failure(let error):
                    this.showMessage(withTitle: "Chyba", message: error.localizedDescription)
            }
            this.removeRequests()
        }
        dataRequests.insert(request)
    }
    
    private func prepareRefreshControlStyle(){
      //  refreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        table.refreshControl = refreshControl
    }
      
    private func prepareTableViewStyle(){
        table.delegate = self
        table.dataSource = self
        table.register(PatientCell.self, forCellReuseIdentifier: cellId)
        table.backgroundColor = .backgroundLight
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.allowsSelection = true
        table.keyboardDismissMode = .interactive
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(5)
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
        if !isKeyboardShown{
            let controller = PatientMenuViewController()
            controller.patientId = patients?.data[indexPath.row].id
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension PatientListViewController: UISearchBarDelegate, UISearchDisplayDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchChangedValue()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        self.isEditing = false
    }
}

extension PatientListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        searchBar.resignFirstResponder()
       // searchBar.endEditing(true)
        return true
    }
}
