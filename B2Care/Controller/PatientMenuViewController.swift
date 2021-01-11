//
//  PatientMenuViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import UIKit

class PatientMenuViewController: BaseViewController {
    
    // MARK: - Properties
    private let headerView = UIView()
    private let tabbar = UITabBar()
    private let titleLabel = UILabel()
    private let patientDetailView = PatientDetailsView()
    private var contentView = UIView()
    
    private lazy var patientDetailVC = PatientDetailViewController()
    private lazy var planVC = UIViewController()
    private lazy var documentVC = DocumentsViewController()
    private lazy var messagesVC = UIViewController()
    private lazy var grphsVC = GraphsViewController()
    private lazy var historyVC = UIViewController()
    private lazy var currentVC: UIViewController = UIViewController()
    
    lazy var blurEffect = UIBlurEffect(style: .extraLight)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
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
                        this.showMessage(withTitle: "Chyba", message: error.localizedDescription)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.tabBarController?.tabBar.isHidden = true
        
    }
    
    // MARK: - Actions
    
    @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
                
                case UISwipeGestureRecognizer.Direction.right:
                    
                    if let items = self.tabbar.items, let selectedItem = self.tabbar.selectedItem{
                        let index = max(0, selectedItem.tag - 1)
                        tabbar.selectedItem = items[index]
                        changeContentView(index: index)
                    }
                    
                    print("Swipe right")
                    
                case UISwipeGestureRecognizer.Direction.left:
                    if let items = self.tabbar.items, let selectedItem = self.tabbar.selectedItem{
                        let total = items.count - 1
                        let index = min(total, selectedItem.tag + 1)
                        tabbar.selectedItem = items[index]
                        changeContentView(index: index)
                    }
                    tabbar.setNeedsLayout()
                    tabbar.reloadInputViews()
                    print("Swipe left")
                    
                default:
                    print("Default")
                    return
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateView(with person: Patient?){
        guard let person = person else {return}
        
        patientDetailVC.patientId = person.id
        titleLabel.text = person.fullName
        patientDetailView.data = person
        patientDetailVC.patientId = person.id
    }
    
    private func prepareView(){
        prepareHeaderViewStyle()
        prepareTabBarStyle()
        
        prepareBottomButtonStyle(addTaskButton, title: "Přidat úkol", image: UIImage(systemName: "plus"), backgroundColor: .systemGreen)
        prepareBottomButtonStyle(urgentButton, title: "Urgentní zpáva", image: UIImage(systemName: "exclamationmark.bubble.fill"), backgroundColor: .systemRed)
        prepareButtonStackStyle()
        
        prepareBlurBackgroundStyle()
        prepareContentViewStyle()
        
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
        patientDetailView.changeStyle(color: .white)
        headerView.addSubview(patientDetailView)
        patientDetailView.snp.makeConstraints { (make) in
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
     //   buttonsStack.backgroundColor = .green
        
        buttonsStack.addArrangedSubview(urgentButton)
        buttonsStack.addArrangedSubview(addTaskButton)
    }
    
    private func prepareBlurBackgroundStyle(){
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    private func prepareContentViewStyle(){
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        self.contentView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        self.contentView.addGestureRecognizer(swipeRight)
        
        contentView.backgroundColor = .backgroundLight
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(tabbar.snp.bottom)
          //  make.bottom.equalTo(blurEffectView.snp.top)
            make.bottom.equalToSuperview()
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
        
        let infoTabItem = UITabBarItem(title: "Info", image: UIImage(systemName: "info.circle.fill"), tag: 0)
        let planTabItem = UITabBarItem(title: "Plán", image: UIImage(systemName: "list.dash"), tag: 1)
        let documentTabItem = UITabBarItem(title: "Dokum.", image: UIImage(systemName: "doc.text.fill"), tag: 2)
        let messageTabItem = UITabBarItem(title: "Zprávy", image: UIImage(systemName: "message.fill"), tag: 3)
        let graphsTabItem = UITabBarItem(title: "Grafy", image: UIImage(systemName: "chart.bar.fill"), tag: 4)
        let historyTabItem = UITabBarItem(title: "Historie", image: UIImage(systemName: "tray.full.fill"), tag: 5)
        
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
         //   make.bottom.equalTo(buttonsStack.snp.top).offset(-10)
            make.left.right.bottom.equalToSuperview()
        }
        
        if showButtons {
            controller.view.insertSubview(blurEffectView, at: controller.view.subviews.count + 1)
            controller.view.insertSubview(buttonsStack, at: controller.view.subviews.count + 1)
                        
            blurEffectView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(100)
            }
            
            buttonsStack.snp.makeConstraints { (make) in
                make.centerY.equalTo(blurEffectView)
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

extension PatientMenuViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        changeContentView(index: item.tag)
    }
}

extension PatientMenuViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
