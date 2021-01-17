//
//  TitleWithImageView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 17.01.2021.
//

import UIKit

class TitleWithImageView: UIView {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let titleImage = UIImageView()
    private let imageSize = 23
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func prepareView(){
        prepareTitleLabelStyle()
        prepareTitleImageStyle()
       
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(imageSize/2)
        }
    }
    
    private func prepareTitleImageStyle(){
        addSubview(titleImage)
        titleImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(imageSize)
            make.right.equalTo(titleLabel.snp.left)
            make.centerY.equalToSuperview()
        }
    }
    
    public func setTitle(_ title: String, color: UIColor){
        titleLabel.text = title
        titleLabel.textColor = color
    }
    
    public func setImage(_ image: UIImage?, color: UIColor){
        titleImage.image = image
        titleImage.tintColor = color
    }
}
