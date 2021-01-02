//
//  PatientMenuViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import UIKit

class PatientMenuViewController: UIViewController, BackButtonDelegate {
    
    // MARK: - Properties
    private let tabbar = UITabBar()
    private var header: HeaderView?
    private let patientDetailView = PatientDetailsView()
    private var contentView = UIView()
    
    private lazy var patientDetailVC = PatientDetailViewController()
    private lazy var planVC = UIViewController()
    private lazy var documentVC = DocumentsViewController()
    private lazy var messagesVC = UIViewController()
    private lazy var grphsVC = UIViewController()
    private lazy var historyVC = UIViewController()
    
    private let buttonsStack = UIStackView()
    private let urgentButton = UIButton()
    private let addTaskButton = UIButton()
    
    var patientId: Int? {
        didSet{
            guard let id = patientId else {return}
            B2CareService.shared.fetchPatient(id: id) { (result) in
                switch result{
                    
                    case .success(let data):
                        self.data = data
                    case .failure(let error):
                        self.showMessage(withTitle: "Chyba", message: error.localizedDescription)
                }
            }
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
    
    override func viewDidLayoutSubviews() {
        if contentView.subviews.count < 1 {
            contentView.addSubview(patientDetailVC.view)
        }
        view.bringSubviewToFront(buttonsStack)
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    private func updateView(with person: Patient?){
        guard let person = person else {return}
        patientDetailVC.patientId = person.id
        header?.setTitle(person.fullName)
        patientDetailView.data = person
    }
    
    private func prepareView(){
        prepareHeaderViewStyle()
        prepareTabBarStyle()
        
        prepareUrgentButtonStyle()
        prepareAddTaskButtonStyle()
        prepareButtonStackStyle()
        prepareContentViewStyle()
        prepareBlurBackgroundStyle()
    }
    
    private func prepareButtonStackStyle(){
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 15
        buttonsStack.distribution = .fillEqually
        buttonsStack.alignment = .center
     //   buttonsStack.backgroundColor = .green
        
        buttonsStack.addArrangedSubview(urgentButton)
        buttonsStack.addArrangedSubview(addTaskButton)
        
        view.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func prepareBlurBackgroundStyle(){
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        blurEffectView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(buttonsStack).offset(-15)
        }
    }
    
    private func prepareUrgentButtonStyle(){
        urgentButton.setTitle("Urgentní zpáva", for: .normal)
        urgentButton.setImage(UIImage(systemName: "exclamationmark.bubble.fill"), for: .normal)
        urgentButton.tintColor = .white
        urgentButton.setTitleColor(.white, for: .normal)
        urgentButton.backgroundColor = .systemRed
        urgentButton.layer.cornerRadius = 10
        
        urgentButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    private func prepareAddTaskButtonStyle(){
        addTaskButton.setTitle("Přidat úkol", for: .normal)
        addTaskButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTaskButton.tintColor = .white
        addTaskButton.setTitleColor(.white, for: .normal)
        addTaskButton.backgroundColor = .systemGreen
        addTaskButton.layer.cornerRadius = 10
        
        addTaskButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    private func prepareContentViewStyle(){
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tabbar.snp.bottom)
        }
    }
    
    private func prepareHeaderViewStyle(){
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        patientDetailView.changeStyle(color: .white)
        let backButton = BackButton()
        backButton.delegate = self
        header = HeaderView(frame: frame, leftButton: backButton, title: "", bottomView: patientDetailView)
        guard let header = header else {return}
        view.addSubview(header)
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
        
        let infoTabItem = UITabBarItem(title: "Info", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        let planTabItem = UITabBarItem(title: "Plán", image: UIImage(systemName: "list.dash"), tag: 2)
        let documentTabItem = UITabBarItem(title: "Dokum.", image: UIImage(systemName: "doc.text.fill"), tag: 3)
        let messageTabItem = UITabBarItem(title: "Zprávy", image: UIImage(systemName: "message.fill"), tag: 4)
        let graphsTabItem = UITabBarItem(title: "Grafy", image: UIImage(systemName: "chart.bar.fill"), tag: 5)
        let historyTabItem = UITabBarItem(title: "Historie", image: UIImage(systemName: "tray.full.fill"), tag: 6)
        
        tabbar.items = [infoTabItem, planTabItem,documentTabItem,messageTabItem,graphsTabItem,historyTabItem]
        tabbar.selectedItem = infoTabItem
        
        
        view.addSubview(tabbar)
        if let header = header{
            tabbar.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                //  make.top.equalTo(headerView.snp.bottom)
                make.top.equalTo(header.snp.bottom)
            }
        }
    }
}

extension PatientMenuViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 1:
                if let data = data{
                    patientDetailVC.patientId = data.id
                }
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(patientDetailVC.view)
            case 2:
                planVC.view.backgroundColor = .systemPink
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(planVC.view)
            case 3:
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(documentVC.view)
            case 4:
                messagesVC.view.backgroundColor = .systemGreen
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(messagesVC.view)
            case 5:
                grphsVC.view.backgroundColor = .systemBlue
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(grphsVC.view)
            case 6:
                historyVC.view.backgroundColor = .systemOrange
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(historyVC.view)
            default:
                print("Default")
        }
        
    }
}
