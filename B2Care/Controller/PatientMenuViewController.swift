//
//  PatientMenuViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import UIKit

class PatientMenuViewController: RequestViewController, BackButtonDelegate {
    
    // MARK: - Properties
    private let tabbar = UITabBar()
    private var header: HeaderView?
    private let patientDetailView = PatientDetailsView()
    private var contentView = UIView()
    
    private lazy var patientDetailVC = PatientDetailViewController()
    private lazy var planVC = UIViewController()
    private lazy var documentVC = DocumentsViewController()
    private lazy var messagesVC = UIViewController()
    private lazy var grphsVC = GraphsViewController()
    private lazy var historyVC = UIViewController()
    
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
    
    override func viewDidLayoutSubviews() {
        if contentView.subviews.count < 1 {
            contentView.addSubview(patientDetailVC.view)
        }
        view.bringSubviewToFront(buttonsStack)
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
        header?.setTitle(person.fullName)
        patientDetailView.data = person
    }
    
    private func prepareView(){
        prepareHeaderViewStyle()
        prepareTabBarStyle()
        
        prepareBottomButtonStyle(addTaskButton, title: "Přidat úkol", image: UIImage(systemName: "plus"), backgroundColor: .systemGreen)
        prepareBottomButtonStyle(urgentButton, title: "Urgentní zpáva", image: UIImage(systemName: "exclamationmark.bubble.fill"), backgroundColor: .systemRed)
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
        
        let infoTabItem = UITabBarItem(title: "Info", image: UIImage(systemName: "info.circle.fill"), tag: 0)
        let planTabItem = UITabBarItem(title: "Plán", image: UIImage(systemName: "list.dash"), tag: 1)
        let documentTabItem = UITabBarItem(title: "Dokum.", image: UIImage(systemName: "doc.text.fill"), tag: 2)
        let messageTabItem = UITabBarItem(title: "Zprávy", image: UIImage(systemName: "message.fill"), tag: 3)
        let graphsTabItem = UITabBarItem(title: "Grafy", image: UIImage(systemName: "chart.bar.fill"), tag: 4)
        let historyTabItem = UITabBarItem(title: "Historie", image: UIImage(systemName: "tray.full.fill"), tag: 5)
        
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
    
    private func changeContentView(index: Int){
        switch index {
            case 0:
                if let data = data{
                    patientDetailVC.patientId = data.id
                }
                addChild(patientDetailVC)
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(patientDetailVC.view)
                
            case 1:
                addChild(planVC)
                planVC.view.backgroundColor = .systemPink
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(planVC.view)
            case 2:
                addChild(documentVC)
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(documentVC.view)
            case 3:
                addChild(messagesVC)
                messagesVC.view.backgroundColor = .systemGreen
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(messagesVC.view)
            case 4:
                addChild(grphsVC)
              //  grphsVC.view.backgroundColor = .systemBlue
                if let data = data{
                    grphsVC.data = data
                }
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(grphsVC.view)
            case 5:
                addChild(historyVC)
                historyVC.view.backgroundColor = .systemOrange
                contentView.subviews.forEach { $0.removeFromSuperview() }
                contentView.addSubview(historyVC.view)
            default:
                print("Default")
        }
    }
    
    override func addChild(_ childController: UIViewController) {
        if !children.contains(childController){
            super.addChild(childController)
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
