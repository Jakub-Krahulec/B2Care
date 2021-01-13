//
//  HeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit

class LoginHeaderView: UIView {

   // MARK: - Properties
    let logoBackgroundView = UIView()
    let logoImage = UIImageView()
    let gradientHeaderAnimation = CABasicAnimation(keyPath: "colors")
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
        gradientHeaderAnimation.fromValue = [UIColor.mainColor.cgColor, UIColor.headerMainColor.cgColor]
        gradientHeaderAnimation.toValue = [UIColor.headerMainColor.cgColor, UIColor.mainColor.cgColor]
        gradientHeaderAnimation.duration = 10.0
        gradientHeaderAnimation.autoreverses = true
        gradientHeaderAnimation.repeatCount = Float.infinity
        gradientHeaderAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        startAnimations()
    }
    
    private func prepareHeaderImageViewStyle(){
        logoBackgroundView.backgroundColor = .clear
        addSubview(logoBackgroundView)
        logoBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.bottom.equalTo(self.snp.bottom).offset(30)
        }
    }
    
    private func prepareLogoImageViewStyle(){
        logoImage.image = #imageLiteral(resourceName: "medical-symbol-transparent-background-20") //"sheqelsign.square" // waveform.path.ecg // staroflife.fill //circle.grid.hex
        logoImage.tintColor = UIColor.white.withAlphaComponent(1)
        logoImage.contentMode = .scaleAspectFit
        logoBackgroundView.addSubview(logoImage)
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
        
        imageGradient.colors = [UIColor.mainColor.cgColor, UIColor.headerMainColor.withAlphaComponent(1).cgColor]
        imageGradient.frame = logoBackgroundView.bounds
        imageGradient.cornerRadius = 20
        imageGradient.startPoint = CGPoint(x: 0, y: 0.1)
        imageGradient.endPoint = CGPoint(x: 0, y: 1)
        logoBackgroundView.layer.insertSublayer(imageGradient, at: 0)

        
    }
    
    public func startAnimations(){
        if (gradient.animationKeys()?.count ?? 0) <= 0{
            gradient.add(gradientHeaderAnimation, forKey: "colors")
        }
        if (imageGradient.animationKeys()?.count ?? 0) <= 0{
            imageGradient.add(gradientHeaderAnimation, forKey: "colors")
        }
    }
    
}
