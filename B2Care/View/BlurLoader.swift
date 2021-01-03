//
//  BlurLoader.swift
//  B2Care
//
//  Created by Jakub Krahulec on 03.01.2021.
//

import UIKit

class BlurLoader: UIView {
    // MARK: - Properties
    
    var blurEffectView: UIVisualEffectView?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        animator.stopAnimation(true)
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func prepareView(){
       
      //  let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView.frame = self.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1.0
        self.blurEffectView = blurEffectView
        self.addSubview(blurEffectView)
        
        prepareLoaderStyle()
        
        animator.addAnimations {
            blurEffectView.effect = UIBlurEffect(style: .light)
        }
        animator.fractionComplete = 0.1
    }
    
    private func prepareLoaderStyle() {
        guard let blurEffectView = blurEffectView else { return }
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }

}
