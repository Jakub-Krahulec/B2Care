//
//  BaseInputField.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class BaseInputField: UITextField {

   // MARK: - Properties
    
    internal var hasFocus = false
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didBegin(_ sender: UITextField){
        sender.layer.borderColor = UIColor.mainColor.cgColor
        hasFocus = true
    }
    
    @objc func didEnd(_ sender: UITextField){
        sender.layer.borderColor = UIColor.borderLight.cgColor
        hasFocus = false
    }
    
    // MARK: - Helpers
    private func prepareView(){
        self.keyboardType = .emailAddress
        backgroundColor = .backgroundLight
        layer.borderWidth = 2
        layer.borderColor = UIColor.borderLight.cgColor
        layer.cornerRadius = 10
        setLeftPaddingPoints(10)
        setRightPaddingPoints(10)
        addTarget(self, action: #selector(didBegin(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(didEnd(_:)), for: .editingDidEnd)
    }
}
