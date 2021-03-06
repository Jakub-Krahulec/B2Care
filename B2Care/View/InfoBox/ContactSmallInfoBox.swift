//
//  ContactSmallInfoBox.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import UIKit

protocol ContactSmallInfoBoxDelegate{
    func callButtonTapped(phoneNumber: String)
}

class ContactSmallInfoBox: SmallInfoBox {

    // MARK: - Properties
    
    let callButton = UIButton()
    var delegate: ContactSmallInfoBoxDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleCallButtonTapped(){
        guard let number = super.valueLabel.text else {return}
        delegate?.callButtonTapped(phoneNumber: number)
    }
    
    // MARK: - Helpers
    

    override func updateView(image: UIImage?, title: String, value: String) {
        super.updateView(image: image, title: title, value: value)
        if value == "-"{
            callButton.tintColor = .darkGray
            callButton.isEnabled = false
        }
    }
    
    private func prepareView(){
        super.titleImageView.removeFromSuperview()
        prepareCallButtonStyle()
    }
    
    private func prepareCallButtonStyle(){
        callButton.tintColor = .mainColor
        callButton.setTitle(" \(NSLocalizedString("call", comment: ""))", for: .normal)
        callButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        callButton.setTitleColor(.mainColor, for: .normal)
        callButton.setTitleColor(.darkGray, for: .disabled)
        callButton.setImage(UIImage(systemName: "phone.fill.arrow.up.right"), for: .normal)
        callButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        callButton.addTarget(self, action: #selector(handleCallButtonTapped), for: .touchUpInside)
        
        addSubview(callButton)
        callButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(super.valueLabel.snp.bottom).offset(15)
            make.height.equalTo(18)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
