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

extension LoginViewDelegate where Self: UIViewController{
    func userDidLogIn(){
        navigationController?.pushViewController(MainTabViewController(), animated: true)
    }
}

class LoginView: UIView {

    // MARK: - Properties
    private var isInErrorMode = false
    
    let gradientButtonBackground = CAGradientLayer()
    let gradientButtonAnimation = CABasicAnimation(keyPath: "colors")
    
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
        print("Forgot button tapped")
    }
    
    @objc private func handleLoginButtonTapped(){
        endErrorMode()
       // refreshControl.startAnimating()
        showBlurLoader()
        B2CareService.shared.login(userName: userTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] result in
            guard let this = self else {return}
            //this.refreshControl.stopAnimating()
            switch result{
                case .success(let isLoggedIn):
                    if isLoggedIn{
                        this.delegate?.userDidLogIn()
                        this.endErrorMode()
                    }
                case .failure(let error):
                    this.startErrorMode(message: error.localizedDescription)
                    return
            }
            this.removeBluerLoader()
        }
    }
    
    @objc private func handleInputAnyEvent(sender: UITextField){
        endErrorMode()
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        prepareUserLabelStyle()
        prepareUserTextFieldStyle()
        preparePasswordLabelStyle()
        preparePasswordTextFieldStyle()
        prepareForgotPasswordButtonStyle()
        prepareStatusLabelStyle()
        prepareLoginButtonStyle()
        prepareAnimationStyle()
    }
    
    private func prepareAnimationStyle(){
        gradientButtonAnimation.fromValue = [UIColor.mainColor.cgColor, UIColor.headerMainColor.cgColor]
        gradientButtonAnimation.toValue = [UIColor.headerMainColor.withAlphaComponent(1).cgColor, UIColor.mainColor.withAlphaComponent(1).cgColor]
        gradientButtonAnimation.duration = 4.0
        gradientButtonAnimation.autoreverses = true
        gradientButtonAnimation.repeatCount = Float.infinity
        gradientButtonAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        startAnimations()
    }
    
    private func prepareUserLabelStyle(){
        userLabel.text = NSLocalizedString("user-name", comment: "")
        addSubview(userLabel)
        userLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
    }
    
    private func prepareUserTextFieldStyle(){
        userTextField.addTarget(self, action: #selector(handleInputAnyEvent(sender:)), for: .allEvents)
        
        addSubview(userTextField)
        userTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func preparePasswordLabelStyle(){
        passwordLabel.text = NSLocalizedString("password", comment: "")
        addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userTextField.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    private func preparePasswordTextFieldStyle(){
        passwordTextField.addTarget(self, action: #selector(handleInputAnyEvent(sender:)), for: .allEvents)
        
        addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func prepareStatusLabelStyle(){
       // statusLabel.text = "Špatné heslo"
        statusLabel.numberOfLines = 2
        statusLabel.textColor = .red
        
        statusLabel.isHidden = true
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(passwordTextField.snp.left)
          //  make.width.equalTo(self.frame.width / 2)
            make.right.equalTo(forgotPasswordButton.snp.left).inset(10)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
    }
    
    private func prepareForgotPasswordButtonStyle(){
        forgotPasswordButton.setTitle(NSLocalizedString("forgotten-password", comment: ""), for: .normal)
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
        loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.backgroundColor = .clear
        loginButton.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.bottom.lessThanOrEqualTo(loginButton.snp.top).offset(8)
        }
    }
    
    public func moveLoginButton(to y: CGFloat){
        let padding: CGFloat = y>0 ? 0 : 10
        let inset = padding + y
        loginButton.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(50)
        }
        
        UIView.animate(withDuration: 2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    private func endErrorMode(){
        if self.isInErrorMode{
            passwordTextField.setNormalMode()
            statusLabel.text = ""
            statusLabel.isHidden = true
            isInErrorMode = false
        }
    }
    
    private func startErrorMode(message: String){
        shake()
        statusLabel.text = message
        statusLabel.isHidden = false
        passwordTextField.setErrorMode()
        isInErrorMode = true
    }
    
    public func prepareGradientStyle(){
        
        gradientButtonBackground.colors = [UIColor.mainColor.cgColor, UIColor.headerMainColor.cgColor]
        gradientButtonBackground.frame = loginButton.bounds
        gradientButtonBackground.startPoint = CGPoint(x: 0, y: 1)
        gradientButtonBackground.endPoint = CGPoint(x: 0, y: 0.0)
        gradientButtonBackground.cornerRadius = 10
        loginButton.layer.insertSublayer(gradientButtonBackground, at: 0)
        
    }
    
    public func startAnimations(){
        if (gradientButtonBackground.animationKeys()?.count ?? 0) <= 0{
            gradientButtonBackground.add(gradientButtonAnimation, forKey: "colors")
        }
    }
    
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        loginButton.layer.add(animation, forKey: "shake")
    }

}

