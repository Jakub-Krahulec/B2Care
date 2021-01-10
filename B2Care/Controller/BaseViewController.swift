//
//  RequestViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 02.01.2021.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {

    // MARK: - Properties
    internal var dataRequests = Set<DataRequest>()
    internal var downloadRequests = Set<DownloadRequest>()
    internal var isKeyboardShown = false
    
    internal var tabbarHeight: CGFloat{
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
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
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        self.navigationItem.backButtonTitle = ""
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
        userButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        userButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userButton)
    }
    
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
}
