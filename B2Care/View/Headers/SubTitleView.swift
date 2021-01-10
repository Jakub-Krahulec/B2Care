//
//  SubTitleView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import UIKit

class SubTitleView: UIView {

    // MARK: - Properties
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
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
        prepareTitleLabelStyle()
        prepareSubTitleLabelStyle()
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
    }
    
    private func prepareSubTitleLabelStyle(){
        subTitleLabel.font = UIFont.systemFont(ofSize: 16)
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = .white
        
        self.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
        }
    }
    
    public func setTitle(_ title: String){
        titleLabel.text = title
    }
    
    public func setSubTitle(_ title: String){
        subTitleLabel.text = title
    }
  
}
