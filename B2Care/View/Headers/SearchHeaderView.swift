//
//  SearchHeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 26.12.2020.
//

import UIKit

class SearchHeaderView: UIView {

    // MARK: - Properties

    private let titleLabel = UILabel()
    let logoutButton = UserButton()
    
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
        backgroundColor = .mainColor
        
        prepareTitleLabelStyle()
        prepareLogoutButtonStyle()
    }
    
    private func prepareLogoutButtonStyle(){
        addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(titleLabel).offset(-3)
            make.height.width.equalTo(30)
        }
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.text = "Vyhledání pacienta"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(35)
        }
    }
}
