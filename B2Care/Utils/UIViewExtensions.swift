//
//  UIViewExtensions.swift
//  B2Care
//
//  Created by Jakub Krahulec on 13.01.2021.
//

import UIKit

extension UIView{
    func showBlurLoader() {
        if let _ = subviews.first(where: { $0 is BlurLoader }) {
            return
        }
        let blurLoader = BlurLoader()
        self.addSubview(blurLoader)
        blurLoader.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func removeBluerLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
    
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 15
    }
    
    func addSpacer(width: CGFloat, color: UIColor){
        let spacer = CALayer()
        spacer.backgroundColor = color.cgColor
        
        spacer.frame = CGRect(x: 0, y: 0, width: self.superview?.frame.size.width ?? self.frame.size.width, height: width)
        self.layer.addSublayer(spacer)
    }
}
