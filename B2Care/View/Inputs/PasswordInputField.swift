//
//  PasswordInputField.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PasswordInputField: BaseInputField {

   // MARK: - Properties
    private let showPasswordButton = UIButton()
      
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleShowPasswordTapped(sender: UIButton){
        isSecureTextEntry.toggle()
        let image = isSecureTextEntry ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash")
        sender.setImage(image, for: .normal)
    }
    
    override func didBegin(_ sender: UITextField) {
        super.didBegin(sender)
        showPasswordButton.isHidden = false
    }
    
    override func didEnd(_ sender: UITextField) {
        super.didEnd(sender)
        showPasswordButton.isHidden = true
    }
    
    // MARK: - Helpers

    private func prepareView(){
        isSecureTextEntry = true
        prepareShowPasswordButtonStyle()
        
    }
    
    private func prepareShowPasswordButtonStyle(){
        showPasswordButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        showPasswordButton.tintColor = .gray
        showPasswordButton.isHidden = true
        showPasswordButton.addTarget(self, action: #selector(handleShowPasswordTapped), for: .touchUpInside)
        showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        self.rightView = showPasswordButton
        
        addSubview(showPasswordButton)
        showPasswordButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
        }
    }
    
    public func setErrorMode(){
        layer.borderColor = UIColor.systemPink.cgColor
    }
}
