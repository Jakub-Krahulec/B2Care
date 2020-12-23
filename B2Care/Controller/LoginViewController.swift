//
//  ViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    // MARK: - Properties
    private let headerView = HeaderView()
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNotificationObservers()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        headerView.prepareGradientStyle()
    }
    
    // MARK: - Actions

    @objc private func keyboardWillShow(notification: Notification){
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            //  print("Notification: Keyboard will show")
            loginView.moveLoginButton(to: keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification){
        // print("Notification: Keyboard will hide")
        loginView.moveLoginButton(to: 0)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

extension LoginViewController: LoginViewDelegate{
    func userDidLogIn() {
        navigationController?.pushViewController(PatientListViewController(), animated: true)
    }
}
