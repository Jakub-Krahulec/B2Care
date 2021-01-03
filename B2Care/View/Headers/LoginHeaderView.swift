//
//  HeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit

class LoginHeaderView: UIView {

   // MARK: - Properties
  //  let headerImage = UIImageView()
    let headerImage = UIView()
    let logoImage = UIImageView()
    
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
        prepareLogoImageViewStyle()
    }
    
    private func prepareHeaderImageViewStyle(){
//        headerImage.image = UIImage(systemName: "app.fill")
//        headerImage.tintColor = .mainColor
//        addSubview(headerImage)
//        headerImage.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.height.width.equalTo(120)
//            make.bottom.equalTo(self.snp.bottom).offset(50)
//        }
        
      //  headerImage.layer.cornerRadius = 30
      //  headerImage.backgroundColor = .mainColor
        addSubview(headerImage)
        headerImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.bottom.equalTo(self.snp.bottom).offset(30)
        }
        
        
    }
    
    private func prepareLogoImageViewStyle(){
        logoImage.image = UIImage(systemName: "sheqelsign.square") // waveform.path.ecg // staroflife.fill //circle.grid.hex
//        logoImage.tintColor = UIColor.white.withAlphaComponent(1)
//
//        headerImage.addSubview(logoImage)
//        logoImage.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.bottom.bottom.equalTo(self).offset(45)
//            make.width.equalTo(120)
//            make.height.equalTo(90)
//        }
        
        logoImage.tintColor = UIColor.white.withAlphaComponent(1)
        headerImage.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.bottom.bottom.equalTo(self).offset(29)
            make.center.equalToSuperview()
            make.width.height.equalTo(70)
        }
    }
    
    func prepareGradientStyle(){
        let gradient = CAGradientLayer()
       // gradient.colors = [UIColor.headerMainColor.cgColor, UIColor.headerSecondaryColor.cgColor]
        gradient.colors = [UIColor.mainColor.cgColor, UIColor.headerMainColor.withAlphaComponent(1).cgColor]
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 1, y: 0.2)
        gradient.endPoint = CGPoint(x: 0.8, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
        //headerImage.layer.addSublayer(gradient)
        
        let imageGradient = CAGradientLayer()
        imageGradient.colors = [UIColor.mainColor.cgColor, UIColor.headerMainColor.withAlphaComponent(0.9).cgColor]
        imageGradient.frame = headerImage.bounds
        imageGradient.cornerRadius = 20
        imageGradient.startPoint = CGPoint(x: 0, y: 0.1)
        imageGradient.endPoint = CGPoint(x: 0, y: 1)
        headerImage.layer.insertSublayer(imageGradient, at: 0)
    }
    
}
