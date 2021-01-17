//
//  SecurityViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 15.01.2021.
//

import LocalAuthentication
import UIKit

class SecurityViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let errorLabel = UILabel()
    private let identifyButton = UIButton()
    private let companyLabel = UILabel()
    
    private var errorMessage: String {
        return B2CareService.shared.getUserData()?.privacyError ?? ""
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    @objc private func identifyUser(){
        let context = LAContext()
        var error: NSError?
        
        // &syntaxe předává odkaz na místo v RAM (pointer)
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = NSLocalizedString("identify-yourself", comment: "")
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success{
                        let error = ""
                        B2CareService.shared.setPrivacyError(message: error)
                        self?.errorLabel.text = error
                        
                        self?.dismiss(animated: true, completion: {
                            
                        })
                    } else {
                        let error = NSLocalizedString("invalid-login-attempt", comment: "")
                        B2CareService.shared.setPrivacyError(message: error)
                        self?.errorLabel.text = error
                    }
                }
            }
        } else {
            showMessage(withTitle: "Chyba", message: NSLocalizedString("device-not-set", comment: ""))
        }
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareTitleLabelStyle()
        prepareErrorLabelStyle()
        prepareIdentifyButtonStyle()
        prepareCompanyLabelStyle()
    }
    
    private func prepareCompanyLabelStyle(){
        companyLabel.text = "B2CARE"
        companyLabel.font = UIFont.boldSystemFont(ofSize: 40)
        companyLabel.textColor = UIColor.mainColor.withAlphaComponent(0.5)
        companyLabel.textAlignment = .center
        
        view.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.left.right.equalToSuperview()
        }
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.text = NSLocalizedString("verify-identity", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func prepareIdentifyButtonStyle(){
        identifyButton.setBackgroundImage(UIImage(systemName: isFaceIDSupported ? "faceid" : "touchid"), for: .normal)
        identifyButton.tintColor = .mainColor
        identifyButton.addTarget(self, action: #selector(identifyUser), for: .touchUpInside)
        
        view.addSubview(identifyButton)
        identifyButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(70)
        }
    }
    
    private func prepareErrorLabelStyle(){
        errorLabel.text = errorMessage
        errorLabel.font = UIFont.systemFont(ofSize: 18)
        errorLabel.textColor = .systemRed
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
    }
}
