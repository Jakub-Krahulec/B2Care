//
//  PatientListViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit
import MGSwipeTableCell

class PatientsListViewController: BaseViewController, UISearchControllerDelegate {
    // MARK: - Properties
    private let cellId = "cellId"
    
    private let table = UITableView()
    private let userButton = UIButton()
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchBar = UISearchBar()
    private var refreshControl = UIRefreshControl()
    
    private var patients: PatientsData?
    {
        didSet{
            refreshControl.programaticallyEndRefreshing(in: table)
//            UIView.transition(with: table, duration: 1.0, options: .transitionCrossDissolve, animations: {self.table.reloadData()}, completion: nil)
            table.reloadSections(IndexSet(integer: 0), with: .automatic)

         //   table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
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
        setupKeyboardNotificationObservers()
        fetchPatients()
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    private func downloadProgressChanged(value: Double){
        
    }
    
    override func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
        searchBar.resignFirstResponder()
        super.hideKeyboardWhenTappedAround(cancelsTouchesInView: cancelsTouchesInView)
    }
    
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareUserButtonStyle(userButton)
       // prepareSearchInputStyle()
        
        prepareTableViewStyle()
        prepareRefreshControlStyle()
        // test jiné implementace searchbaru
        prepareSearchControllerStyle()
    }
    
    private func prepareSearchControllerStyle(){
        title = "Seznam pacientů"
        searchController.searchBar.placeholder = NSLocalizedString("search-patient", comment: "")
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor.white.withAlphaComponent(1)
        searchController.searchBar.layer.cornerRadius = 12
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.backgroundColor = .white
        
        definesPresentationContext = true
    
        // UISearchbackground
        
        table.tableHeaderView = searchController.searchBar
    }
    
    private func prepareSearchInputStyle(){
        searchBar.delegate = self
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search-patient", comment: ""),
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    private func fetchPatients(){
        refreshControl.programaticallyBeginRefreshing(in: table)
        cancelDataRequests()
        var params = ""
//        if let text = searchBar.text  {
//            if text.count > 0{
//                params = "?search=\(text)"
//            }
//        }
            if let text = searchController.searchBar.text{
                if text.count > 0{
                    params = "?search=\(text)"
                }
            }
        
        let request = B2CareService.shared.fetchPatients(parameters: params) { [weak self] (result) in
            guard let this = self else {return}
            switch result{
                case .success(let data):
                    this.patients = data
                case .failure(let error):
                    if (!(error.asAFError?.isExplicitlyCancelledError ?? true)){
                    this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
                    }
            }
            
            this.removeRequests()
        }
        dataRequests.insert(request)
    }
    
    private func prepareRefreshControlStyle(){
       // refreshControl.attributedTitle = NSAttributedString(string: "Načítám")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = .backgroundLight
       // table.addSubview(refreshControl)
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
            make.left.right.bottom.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(5)
        }
        
        // TEST DRUHÉHO SEARCH BARU
//        table.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalToSuperview()
//        }
    }
}

extension PatientsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = patients{
            return data.data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PatientCell{
            if let data = patients {
            cell.selectionStyle = .none
            
            let urgentMessage = MGSwipeButton(title: NSLocalizedString("urgent-message", comment: ""), backgroundColor: .systemRed) { [weak self] (sender) -> Bool in
               
                self?.scheduleLocalNotification(title: "Urgentní zpráva", body: "Změna stavu \(data.data[indexPath.row].fullName)", categoryIdentifier: "Test", sound: UNNotificationSound.default)
               
                return true
            }
            
            
            urgentMessage.setImage(UIImage(systemName: "exclamationmark.bubble.fill"), for: .normal)
            urgentMessage.tintColor = .white
            urgentMessage.buttonWidth = 115
            
            let addTask = MGSwipeButton(title: NSLocalizedString("add-task", comment: ""),backgroundColor: .systemGreen) { (sender) -> Bool in
                
                let request = NetworkService.shared.downloadFile(from: "https://soundbible.com/grab.php?id=2185&type=mp3", progressChanged: self.downloadProgressChanged(value:)) { [weak self] (result) in
                    guard let this = self else {return}
                    switch result{
                        case .success(let data):
                            do{
                                let fileURL = FileManager().temporaryDirectory.appendingPathComponent("sound.mp3")
                                
                                try data.write(to: fileURL, options: .atomic)
                                this.playSound(url: fileURL)
                            } catch {
                                print(error.localizedDescription)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                    
                }
                self.downloadRequests.insert(request)
                
                return true
            }
            addTask.setImage(UIImage(systemName: "plus"), for: .normal)
            addTask.tintColor = .white
            addTask.buttonWidth = 115
            
            
            cell.rightButtons = [addTask, urgentMessage]
            
            cell.rightSwipeSettings.transition = .border
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 12
            cell.layer.borderColor = UIColor.backgroundLight.cgColor
            cell.layer.borderWidth = 2.5
            cell.clipsToBounds = true
            cell.layer.masksToBounds = true
            cell.swipeBackgroundColor = UIColor.white
            cell.swipeContentView.layer.borderWidth = 8
            cell.swipeContentView.layer.borderColor = UIColor.white.cgColor
            
            
                cell.data = data.data[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isKeyboardShown{
            if let patient = patients?.data[indexPath.row]{
                B2CareService.shared.savePatient(patient)
            }
            let controller = PatientDetailViewController()
            controller.patientId = patients?.data[indexPath.row].id
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension PatientsListViewController: UISearchBarDelegate, UISearchDisplayDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchChangedValue()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        searchBar.resignFirstResponder()
        //        self.isEditing = false
    }
}

extension PatientsListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        searchBar.resignFirstResponder()
        // searchBar.endEditing(true)
        return true
    }
}

extension PatientsListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        handleSearchChangedValue()
    }
    
    
}
