//
//  PatientMenuViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import UIKit

class PatientDetailViewController: BaseViewController {
    
    // MARK: - Properties
    private let headerView = UIView()
    private let tabbar = UITabBar()
    private let titleLabel = UILabel()
    private let patientDetailLine = PatientDetailLine()
    
    private lazy var patientDetailVC = PatientInfoViewController()
    private lazy var planVC = UIViewController()
    private lazy var documentVC = PatientDocumentsViewController()
    private lazy var messagesVC = UIViewController()
    private lazy var grphsVC = PatientGraphsViewController()
    private lazy var historyVC = UIViewController()
    private lazy var currentVC: UIViewController = UIViewController()
    
    lazy var blurEffect = UIBlurEffect(style: .extraLight)
    lazy var buttonsBlurBackground = UIVisualEffectView(effect: blurEffect)
    private let buttonsStack = UIStackView()
    private let urgentButton = UIButton()
    private let addTaskButton = UIButton()
    
    var patientId: Int? {
        didSet{
            guard let id = patientId else {return}
            let request = B2CareService.shared.fetchPatient(id: id) { [weak self] (result) in
                guard let this = self else {return}
                switch result{
                    
                    case .success(let data):
                        this.data = data
                    case .failure(let error):
                        this.showMessage(withTitle: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
                }
                this.removeRequests()
            }
            dataRequests.insert(request)
        }
    }
    
    var data: Patient?{
        didSet{
            updateView(with: data)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    // MARK: - Actions
    
   
    // MARK: - Helpers
    
    private func updateView(with person: Patient?){
        guard let person = person else {return}
        
        patientDetailVC.patientId = person.id
        titleLabel.text = person.fullName
        patientDetailLine.data = person
        patientDetailVC.patientId = person.id
    }
    
    private func prepareView(){
        prepareHeaderViewStyle()
        prepareTabBarStyle()
        prepareBottomButtonStyle(addTaskButton, title: NSLocalizedString("add-task", comment: ""), image: UIImage(systemName: "plus"), backgroundColor: .systemGreen)
        prepareBottomButtonStyle(urgentButton, title: NSLocalizedString("urgent-message", comment: ""), image: UIImage(systemName: "exclamationmark.bubble.fill"), backgroundColor: .systemRed)
        prepareButtonStackStyle()
        prepareBlurBackgroundStyle()
        changeContentView(index: 0)
    }
    
    private func prepareHeaderViewStyle(){
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        patientDetailLine.changeStyle(color: .white)
        headerView.addSubview(patientDetailLine)
        patientDetailLine.snp.makeConstraints { (make) in
            make.center.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        navigationItem.titleView = headerView
    }
    
    private func prepareButtonStackStyle(){
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 15
        buttonsStack.distribution = .fillEqually
        buttonsStack.alignment = .center
        
        buttonsStack.addArrangedSubview(urgentButton)
        buttonsStack.addArrangedSubview(addTaskButton)
    }
    
    private func prepareBlurBackgroundStyle(){
        
        buttonsBlurBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func prepareBottomButtonStyle(_ button: UIButton, title: String, image: UIImage?, backgroundColor: UIColor){
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        
        button.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    

    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        // vytvořím čteverec o velikosti tabbaritemu
        let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
        // vytvořím čáru na spodu
        let rectLine = CGRect(x:0, y:size.height-lineSize.height,width: lineSize.width,height: lineSize.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func prepareTabBarStyle(){
        tabbar.delegate = self
        tabbar.backgroundColor = .white
        tabbar.tintColor = .mainColor
        
        let tabItemWidth = self.view.frame.width / 6
        tabbar.selectionIndicatorImage = getImageWithColorPosition(color: UIColor.mainColor.withAlphaComponent(0.7), size: CGSize(width: tabItemWidth, height: 49), lineSize: CGSize(width: tabItemWidth, height: 2))
        
        let infoTabItem = UITabBarItem(title: NSLocalizedString("info", comment: ""), image: UIImage(systemName: "info.circle.fill"), tag: 0)
        let planTabItem = UITabBarItem(title: NSLocalizedString("plan", comment: ""), image: UIImage(systemName: "list.dash"), tag: 1)
        let documentTabItem = UITabBarItem(title: NSLocalizedString("doc", comment: ""), image: UIImage(systemName: "doc.text.fill"), tag: 2)
        let messageTabItem = UITabBarItem(title: NSLocalizedString("messages", comment: ""), image: UIImage(systemName: "message.fill"), tag: 3)
        let graphsTabItem = UITabBarItem(title: NSLocalizedString("graphs", comment: ""), image: UIImage(systemName: "chart.bar.fill"), tag: 4)
        let historyTabItem = UITabBarItem(title: NSLocalizedString("history", comment: ""), image: UIImage(systemName: "tray.full.fill"), tag: 5)
        
        tabbar.items = [infoTabItem, planTabItem,documentTabItem,messageTabItem,graphsTabItem,historyTabItem]
        tabbar.selectedItem = infoTabItem
        
        
        view.addSubview(tabbar)
        tabbar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func changeChildVC(to controller: UIViewController, showButtons: Bool = true){
        currentVC.remove()
        add(controller)
        currentVC = controller
        
        controller.view.snp.makeConstraints { (make) in
            make.top.equalTo(tabbar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        if showButtons {
            controller.view.insertSubview(buttonsBlurBackground, at: controller.view.subviews.count + 1)
            controller.view.insertSubview(buttonsStack, at: controller.view.subviews.count + 1)
                        
            buttonsBlurBackground.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(100)
            }
            
            buttonsStack.snp.makeConstraints { (make) in
                make.centerY.equalTo(buttonsBlurBackground)
                make.left.right.equalToSuperview().inset(20)
            }
        }
    }
    
    private func changeContentView(index: Int){
        
        
        switch index {
            case 0:
                if let data = data{
                    patientDetailVC.patientId = data.id
                }
                changeChildVC(to: patientDetailVC)
            case 1:
                changeChildVC(to: planVC, showButtons: false)
                planVC.view.backgroundColor = .systemPink
            case 2:
                changeChildVC(to: documentVC, showButtons: false)
            case 3:
                changeChildVC(to: messagesVC)
                messagesVC.view.backgroundColor = .systemGreen
            case 4:
                if let data = data{
                    grphsVC.data = data
                }
                changeChildVC(to: grphsVC)
            case 5:
                changeChildVC(to: historyVC)
                historyVC.view.backgroundColor = .systemOrange
            default:
                print("Default")
        }
    }
}

extension PatientDetailViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        changeContentView(index: item.tag)
    }
}

extension PatientDetailViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
