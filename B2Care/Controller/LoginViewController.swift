//
//  ViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController, LoginViewDelegate {
    // MARK: - Properties
    private let headerView = LoginHeaderView()
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupKeyboardNotificationObservers()
        setupNotificationObservers()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        headerView.prepareGradientStyle()
        loginView.prepareGradientStyle()
    }
    
    // MARK: - Actions

    @objc internal override func keyboardWillShow(notification: Notification){
        super.keyboardWillShow(notification: notification)
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            loginView.moveLoginButton(to: keyboardHeight)
        }
    }
    
    @objc internal override func keyboardWillHide(notification: Notification){
        super.keyboardWillHide(notification: notification)
        loginView.moveLoginButton(to: 0)
    }
    
    @objc private func applicationWillEnterForegorund(notification: Notification){
        headerView.startAnimations()
        loginView.startAnimations()
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .white
        prepareHeaderViewStyle()
        prepareLoginViewStyle()
    }
    
    private func prepareHeaderViewStyle(){
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view.frame.height / 5)
        }
    }
    
    private func prepareLoginViewStyle(){
        loginView.delegate = self
        view.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(15)
            make.top.equalTo(headerView.snp.bottom).offset(70)
        }
    }

    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegorund(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
}

