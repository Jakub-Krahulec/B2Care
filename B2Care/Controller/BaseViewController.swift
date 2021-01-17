//
//  RequestViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 02.01.2021.
//

import UIKit
import Alamofire
import AVFoundation
import UserNotifications

class BaseViewController: UIViewController {

    // MARK: - Properties
    private var player = AVAudioPlayer()
    internal var dataRequests = Set<DataRequest>()
    internal var downloadRequests = Set<DownloadRequest>()
    internal var isKeyboardShown = false
    private let blurLoader = BlurLoader()
    
    private var isPrivacyEnabled: Bool {
        return B2CareService.shared.getUserData()?.enablePrivacy ?? false
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Při změně výšky navigace neudělá takový skok při zobrazení
        self.navigationController?.view.layoutSubviews()
        self.setupPrivacyNotificationObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      //  blurLoader.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for request in dataRequests{
            if !request.isFinished{
                request.cancel()
            }
        }
        dataRequests.removeAll()
        
        for request in downloadRequests{
            if !request.isFinished{
                request.cancel()
            }
        }
        downloadRequests.removeAll()
    }
    // MARK: - Actions
    
    @objc internal func logout(){
        B2CareService.shared.logout()
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                if let vc = rootVC as? UINavigationController{
                    vc.popToRootViewController(animated: true)
                }
            })
        }
        else {
            if let vc = rootVC as? UINavigationController{
                vc.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc internal func handleUserButtonTapped(){
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        let controller = UserViewController()
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @objc internal func handleDidEnterBackground(){
        if isPrivacyEnabled{
            let controller = SecurityViewController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    @objc func scheduleLocalNotification(
        title: String,
        body: String,
        categoryIdentifier: String,
        sound: UNNotificationSound){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = categoryIdentifier
        content.sound = sound
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        self.navigationItem.backButtonTitle = ""
        
//        self.view.addSubview(blurLoader)
//        blurLoader.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
        //blurLoader.isHidden = true
    }
    
    private func setupPrivacyNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    internal func removeRequests(){
        for request in dataRequests{
            if request.isFinished{
                dataRequests.remove(request)
            }
        }
        
        for request in downloadRequests{
            if request.isFinished{
                downloadRequests.remove(request)
            }
        }
    }
    
    internal func prepareUserButtonStyle(_ userButton: UIButton){
        userButton.setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        userButton.tintColor = .white
        userButton.addTarget(self, action: #selector(handleUserButtonTapped), for: .touchUpInside)
        userButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userButton)
    }
    
    internal func showBlurLoader() {
        view.bringSubviewToFront(blurLoader)
        blurLoader.isHidden = false
    }
    
    internal func removeBluerLoader() {
        blurLoader.isHidden = true
    }
    
    internal func setupKeyboardNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc internal func keyboardWillShow(notification: Notification){
       
    }
    
    @objc internal func keyboardWillHide(notification: Notification){
        
    }
    
    @objc internal func keyboardDidHide(notification: Notification){
        isKeyboardShown = false
    }
    
    @objc internal func keyboardDidShow(notification: Notification){
        isKeyboardShown = true
    }
    
    internal func playSound(url: URL) {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
