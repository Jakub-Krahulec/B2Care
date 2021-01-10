//
//  UserButton.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

protocol UserButtonDelegate where Self: BaseViewController{
    
}

extension UserButtonDelegate{
    func buttonTapped(){
        self.logout()
    }
}

class UserButton: UIButton {

    // MARK: - Properties
    var delegate: UserButtonDelegate?
    
    @objc private func handleUserButtonTapped(){
        delegate?.buttonTapped()
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    private func prepareView(){
//        setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
//        imageView?.contentMode = .scaleAspectFill
//        imageEdgeInsets = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
        setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        tintColor = .white
        self.addTarget(self, action: #selector(handleUserButtonTapped), for: .touchUpInside)
        self.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
        }
        
    }
}
