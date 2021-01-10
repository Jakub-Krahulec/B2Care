//
//  SmallInfoBox.swift
//  B2Care
//
//  Created by Jakub Krahulec on 24.12.2020.
//

import UIKit
import SnapKit

class SmallInfoBox: UIView {

    // MARK: - Properties
    internal let titleStack = UIStackView()
    internal let imageView = UIImageView()
    internal let titleLabel = UILabel()
    internal let valueLabel = UILabel()
    
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
        prepareTitleStackStyle()
        prepareValueLabelStyle()
        
        setBottomMargin()
    }
    
    func setBottomMargin(){
        self.snp.makeConstraints { (make) in
            //make.bottom.equalTo(valueLabel.snp.bottom).offset(15)
            make.bottom.greaterThanOrEqualTo(valueLabel.snp.bottom).offset(15)
        }
    }
    
    private func prepareTitleStackStyle(){
        titleStack.axis = .horizontal
        titleStack.spacing = 5
        titleStack.distribution = .equalSpacing
        titleStack.alignment = .center
        
        addSubview(titleStack)
        titleStack.addArrangedSubview(imageView)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.snp.makeConstraints { (make) in
          //  make.centerY.equalToSuperview().offset(-12)
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
        }
    }
    
    private func prepareImageViewStyle(){
        imageView.tintColor = .mainColor
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func prepareValueLabelStyle(){
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        valueLabel.numberOfLines = 0
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(titleStack.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
            
        }
    }
    
    public func updateView(image: UIImage?, title: String, value: String){
        imageView.image = image
        titleLabel.text = title
        valueLabel.text = value
    }
}
