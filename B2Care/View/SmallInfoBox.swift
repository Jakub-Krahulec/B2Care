//
//  SmallInfoBox.swift
//  B2Care
//
//  Created by Jakub Krahulec on 24.12.2020.
//

import UIKit

class SmallInfoBox: UIView {

    // MARK: - Properties
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
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
        backgroundColor = .white
        layer.cornerRadius = 10
        
        
        prepareTitleLabelStyle()
        prepareImageViewStyle()
        prepareValueLabelStyle()
    }
    
    private func prepareImageViewStyle(){
        imageView.tintColor = .mainColor
       // imageView.image = UIImage(systemName: "staroflife.fill")
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-5)
            make.top.equalTo(titleLabel)
        }
    }
    
    private func prepareTitleLabelStyle(){
       // titleLabel.text = "Pojišťovna"
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func prepareValueLabelStyle(){
       // valueLabel.text = "111 - VZP"
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        valueLabel.numberOfLines = 0
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    public func updateView(image: UIImage, title: String, value: String){
        imageView.image = image
        titleLabel.text = title
        valueLabel.text = value
    }
}
