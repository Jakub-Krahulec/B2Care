//
//  UserViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 14.01.2021.
//

import UIKit
import LocalAuthentication

class UserViewController: BaseViewController {
    // MARK: - Properties
    
    private let backButton = UIButton()
    
    private let settingsTitleLabel = UILabel()
    
    // Pokud se bude přidávat předělat na table view
    private let privacyIcon = UIImageView()
    private let privacyLabel = UILabel()
    private let privacySwitch = UISwitch()
    private let logoutButton = UIButton()
    private let privacyBackgroundView = UIView()
    
    private let user = B2CareService.shared.getUserData()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    @objc private func handlePrivacySwitchChangedValue(){
        let context = LAContext()
        var error: NSError?
        
        // &syntaxe předává odkaz na místo v RAM (pointer)
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            B2CareService.shared.setPrivacyMode(enabled: privacySwitch.isOn)
        } else {
            privacySwitch.isOn = false
            B2CareService.shared.setPrivacyMode(enabled: privacySwitch.isOn)
            
            let alertController = UIAlertController (title: NSLocalizedString("device-not-set", comment: ""), message: NSLocalizedString("open-settings", comment: ""), preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                     //   print("Nastavení otevřeno: \(success)")
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    @objc private func back(sender: UIBarButtonItem) {
        
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.popViewController(animated:false)
    }
    
    // MARK: - Helpers

    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareNavigationView()
        
        preparePrivacyBackgroundStyle()
        preparePrivacyIconStyle()
        preparePrivacyLabelStyle()
        preparePrivacySwitchStyle()
        
        prepareLogoutButtonStyle()
    }
    
    private func preparePrivacyBackgroundStyle(){
        privacyBackgroundView.backgroundColor = .white
        
        view.addSubview(privacyBackgroundView)
        privacyBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(45)
            make.left.right.equalToSuperview()
        }
    }
    
    private func prepareNavigationView(){
        var title = ""
        if let user = user{
            title = " \(user.name) \(user.surname)"
        }
        let titleView = TitleWithImageView()
        titleView.setImage(UIImage(systemName: "person.fill"), color: .white)
        titleView.setTitle(title, color: .white)
        navigationItem.titleView = titleView
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .done, target: self, action: #selector(back(sender:)))
    }
    
    private func preparePrivacyIconStyle(){
        privacyIcon.image = UIImage(systemName: "lock.shield.fill")
        privacyIcon.tintColor = .mainColor
        
        view.addSubview(privacyIcon)
        privacyIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(privacyBackgroundView)
            make.height.width.equalTo(35)
        }
    }
    
    private func preparePrivacyLabelStyle(){
        privacyLabel.text = NSLocalizedString("privacy", comment: "")
        privacyLabel.textAlignment = .left
        privacyLabel.font = UIFont.systemFont(ofSize: 18)
        privacyLabel.textColor = .black
        
        view.addSubview(privacyLabel)
        privacyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(privacyIcon.snp.right).offset(5)
            make.centerY.equalTo(privacyBackgroundView)
        }
    }
    
    private func preparePrivacySwitchStyle(){
        if let isEnabled = user?.enablePrivacy{
            privacySwitch.isOn = isEnabled
        }
        privacySwitch.addTarget(self, action: #selector(handlePrivacySwitchChangedValue), for: .valueChanged)
        
        view.addSubview(privacySwitch)
        privacySwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(privacyBackgroundView)
            make.right.equalToSuperview().inset(25)
        }
    }
    
    private func prepareLogoutButtonStyle(){
        logoutButton.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        logoutButton.backgroundColor = .headerMainColor
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.layer.cornerRadius = 10
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.height.equalTo(50)
        }
    }
}
