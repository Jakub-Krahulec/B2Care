//
//  PatientListViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PatientListViewController: RequestViewController, UserButtonDelegate {
    // MARK: - Properties
    private let cellId = "cellId"
    private var isKeyboardShown = false
    
    private var header: HeaderView?
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
        setupNotificationObservers()
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
    
    @objc private func handleSearchChangedValue(){
        fetchPatients()
    }
    
    @objc private func keyboardWillShow(notification: Notification){
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            table.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc private func keyboardDidHide(notification: Notification){
        table.scrollIndicatorInsets = .zero
        table.contentInset = .zero
        table.layoutIfNeeded()
        isKeyboardShown = false
    }
    
    @objc private func keyboardDidShow(notification: Notification){
        isKeyboardShown = true
    }
    
    
    // MARK: - Helpers
    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func prepareView(){
        view.backgroundColor = .mainColor
        
        prepareHeaderViewStyle()
        prepareTableViewStyle()
        prepareRefreshControlStyle()
    }
    
    private func prepareHeaderViewStyle(){
        userButton.delegate = self
        searchInput.addTarget(self, action: #selector(handleSearchChangedValue), for: .editingChanged)
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        header = HeaderView(frame: frame, leftButton: userButton, title: "Seznam pacientů", bottomView: searchInput, bottomViewAlign: .left)
        guard let header = header else {return}
        view.addSubview(header)
    }
    
    private func fetchPatients(){
        var params = ""
        if let text = searchInput.text  {
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
        requests.insert(request)
    }
    
    private func prepareRefreshControlStyle(){
      //  refreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
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
