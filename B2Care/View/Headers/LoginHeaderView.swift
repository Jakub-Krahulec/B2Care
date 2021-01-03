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
    let logoView = UIView()
    let logoImage = UIImageView()
    let animation = CABasicAnimation(keyPath: "colors")
    let imageGradient = CAGradientLayer()
    let gradient = CAGradientLayer()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        imageGradient.removeAllAnimations()
        gradient.removeAllAnimations()
    }
    
    
    // MARK: - Actions
    
    
    // MARK: - Helpers

    private func prepareView(){
       // prepareGradientStyle()
        prepareHeaderImageViewStyle()
        prepareLogoImageViewStyle()
        prepareAnimationStyle()
    }
    
    private func prepareAnimationStyle(){
        animation.fromValue = [UIColor.mainColor.cgColor, UIColor.headerMainColor.cgColor]
        animation.toValue = [UIColor.headerMainColor.cgColor, UIColor.mainColor.cgColor]
        animation.duration = 10.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
    }
    
    private func prepareHeaderImageViewStyle(){
        logoView.backgroundColor = .clear
        addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.bottom.equalTo(self.snp.bottom).offset(30)
        }
    }
    
    private func prepareLogoImageViewStyle(){
        logoImage.image = UIImage(systemName: "sheqelsign.square") // waveform.path.ecg // staroflife.fill //circle.grid.hex
        logoImage.tintColor = UIColor.white.withAlphaComponent(1)
        logoView.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(70)
        }
    }
    
    func prepareGradientStyle(){
        
        gradient.colors = [UIColor.mainColor.cgColor, UIColor.headerMainColor.withAlphaComponent(1).cgColor]
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 1, y: 0.2)
        gradient.endPoint = CGPoint(x: 0.8, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
        
        imageGradient.colors = [UIColor.mainColor.cgColor, UIColor.headerMainColor.withAlphaComponent(0.9).cgColor]
        imageGradient.frame = logoView.bounds
        imageGradient.cornerRadius = 20
        imageGradient.startPoint = CGPoint(x: 0, y: 0.1)
        imageGradient.endPoint = CGPoint(x: 0, y: 1)
        imageGradient.borderWidth = 0
        imageGradient.borderColor = UIColor.white.cgColor
        logoView.layer.insertSublayer(imageGradient, at: 0)
        
        gradient.add(animation, forKey: nil)
        imageGradient.add(animation, forKey: nil)
    }
    
}
