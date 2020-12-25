//
//  BaseHeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import UIKit

protocol BaseHeaderDelegate{
    func backButtonTapped()
}

class BaseHeaderView: UIView {

   
    // MARK: - Properties
    
    private let backButton = UIButton()
    public var delegate: BaseHeaderDelegate?
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleBackButtonTapped(){
        delegate?.backButtonTapped()
    }
    
    // MARK: - Helpers
        
    private func prepareView(){
        backgroundColor = .mainColor
        prepareBackButtonStyle()
    }
    
    private func prepareBackButtonStyle(){
        backButton.tintColor = .white
        backButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        
        addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(20)
            make.left.equalTo(20)
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
    }
   
}
