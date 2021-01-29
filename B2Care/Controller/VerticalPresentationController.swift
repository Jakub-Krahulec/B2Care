//
//  VerticalPresentationController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.01.2021.
//

import UIKit

class VerticalPresentationController: UIPresentationController {
    
    private enum VerticalPresentationState{
        case fullScreen
        case halfScreen
        case almostClosed
    }
    
    private let closeButton = UIButton()
    private let dragLine = UIView()
    
    private var state = VerticalPresentationState.halfScreen
    private var lastPositionY: CGFloat = 0
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = containerView else {
            return
        }
        container.frame = CGRect(x: 0, y: container.bounds.height / 2, width: container.bounds.width, height: container.bounds.height - 50)
    }
    
    @objc private func closeTapped(_ sender: UIButton){
        guard let view = presentedView else {return}
        UIView.animate(withDuration: 0.5, animations: {
            view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        }, completion: { (finished) in
            self.presentingViewController.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc private func handleDrag(_ sender: UIPanGestureRecognizer){
        guard let container = containerView else {return}
        
        let translation = sender.translation(in: container)
        let velocity = sender.velocity(in: presentedView)
        let bottomMargin: CGFloat = 20
        let height = UIScreen.main.bounds.height - 50
        
        let currentY: CGFloat =
            state == .halfScreen ? container.bounds.height / 2
            : state == .fullScreen ? 50
            : container.bounds.height - bottomMargin
        
        let nextPositionY = currentY + translation.y
        if nextPositionY <= container.bounds.height - bottomMargin && nextPositionY >= 50{
            container.frame = CGRect(x: 0, y: nextPositionY, width: container.bounds.width, height: container.bounds.height)
            lastPositionY = nextPositionY
        }
        
        
        if sender.state == .ended{
            let absVelocity = abs(velocity.y)
            let duration = absVelocity > 200 ? 0.1 : absVelocity > 100 ? 0.3 : absVelocity > 50 ? 0.4 : absVelocity > 25 ? 0.5 : 0.6
            
            if nextPositionY >= (container.bounds.height / 100) * 85{
                UIView.animate(withDuration: duration) {
                    container.frame = CGRect(x: 0, y: height - bottomMargin, width: container.bounds.width, height: container.bounds.height)
                }
                self.state = .almostClosed
                
            } else if nextPositionY > container.bounds.height / 3  {
                
                UIView.animate(withDuration: duration) {
                    container.frame = CGRect(x: 0, y: height / 2, width: container.bounds.width, height: container.bounds.height)
                }
                self.state = .halfScreen
            } else {
                UIView.animate(withDuration: duration){
                    container.frame = CGRect(x: 0, y: 50, width: container.bounds.width, height: container.bounds.height)
                }
                self.state = .fullScreen
            }
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        presentedView?.isUserInteractionEnabled = true
        presentedView?.addGestureRecognizer(pangesture)
        
        
        
        if let view = presentedView{
            closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
            closeButton.tintColor = UIColor.black.withAlphaComponent(0.8)
            closeButton.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
            
            view.addSubview(closeButton)
            closeButton.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(15)
                make.right.equalToSuperview().inset(10)
                make.width.height.equalTo(35)
            }
            
            dragLine.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            dragLine.layer.cornerRadius = 3
            
            view.addSubview(dragLine)
            dragLine.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(5)
                make.centerX.equalToSuperview()
                make.width.equalTo(50)
                make.height.equalTo(5)
            }
        }
    }
}
