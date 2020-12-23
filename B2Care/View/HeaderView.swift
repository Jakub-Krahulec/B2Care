//
//  HeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit

class HeaderView: UIView {

   // MARK: - Properties
    let headerImage = UIImageView()
    
    
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
       // prepareGradientStyle()
        prepareHeaderImageViewStyle()
    }
    
    private func prepareHeaderImageViewStyle(){
        headerImage.image = UIImage(systemName: "app.fill")
        headerImage.tintColor = .green
        addSubview(headerImage)
        headerImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
            make.bottom.equalTo(self.snp.bottom).offset(50)
        }
    }
    
    func prepareGradientStyle(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.headerMainColor.cgColor, UIColor.headerSecondaryColor.cgColor]
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
