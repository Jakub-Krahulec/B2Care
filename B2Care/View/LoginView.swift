//
//  LoginView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit

protocol LoginViewDelegate{
    func userDidLogIn()
}

class LoginView: UIView {

    // MARK: - Properties
    private let userLabel = UILabel()
    private let userTextField = BaseInputField()
    private let passwordLabel = UILabel()
    private let passwordTextField = PasswordInputField()
    private let statusLabel = UILabel()
    private let forgotPasswordButton = UIButton()
    private let loginButton = UIButton()
    
    public var delegate: LoginViewDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleForgotPasswordButtonTapped(){
        print("Smůla")
    }
    
    @objc private func handleLoginButtonTapped(){
        print("Login")
        B2CareService.shared.login(userName: userTextField.text ?? "", password: passwordTextField.text ?? "") { res in
            switch res{
                case .success(let isLoggedIn):
                    print(isLoggedIn)
                    self.delegate?.userDidLogIn()
                case .failure(let error):
                    self.statusLabel.text = error.localizedDescription
                    self.passwordTextField.setErrorMode()
                    print(error)
                    return
            }
        }
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        prepareUserLabelStyle()
        prepareUserTextFieldStyle()
        preparePasswordLabelStyle()
        preparePasswordTextFieldStyle()
        prepareStatusLabelStyle()
        prepareForgotPasswordButtonStyle()
        prepareLoginButtonStyle()
    }
    
    private func prepareUserLabelStyle(){
        userLabel.text = "Uživatelské jméno"
        addSubview(userLabel)
        userLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
    }
    
    private func prepareUserTextFieldStyle(){
       
        addSubview(userTextField)
        userTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func preparePasswordLabelStyle(){
        passwordLabel.text = "Heslo"
        addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userTextField.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    private func preparePasswordTextFieldStyle(){
        
        
        addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func prepareStatusLabelStyle(){
        statusLabel.text = "Špatné heslo"
        statusLabel.textColor = .red
        statusLabel.isHidden = true
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(passwordTextField.snp.left)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
    }
    
    private func prepareForgotPasswordButtonStyle(){
        forgotPasswordButton.setTitle("Zapomenuté heslo ", for: .normal)
        forgotPasswordButton.setTitleColor(.gray, for: .normal)
        forgotPasswordButton.tintColor = .gray
        forgotPasswordButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        forgotPasswordButton.semanticContentAttribute = .forceRightToLeft
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPasswordButtonTapped), for: .touchUpInside)
        
        addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.right.equalTo(passwordTextField.snp.right)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
    }
    
    private func prepareLoginButtonStyle(){
        loginButton.setTitle("Přihlásit", for: .normal)
        loginButton.backgroundColor = .mainColor
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
    }
    
    public func moveLoginButton(to y: CGFloat){
        loginButton.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().inset(10 + y)
        }
        
        UIView.animate(withDuration: 2, animations: {
            self.layoutIfNeeded()
        })
    }

}
