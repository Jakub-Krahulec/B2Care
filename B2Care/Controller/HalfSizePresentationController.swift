//
//  ForgotPasswordPresentationController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.01.2021.
//

import UIKit

class HalfSizePresentationController: UIPresentationController{
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = containerView else {
            return
        }
        container.frame = CGRect(x: 0, y: container.bounds.height/2, width: container.bounds.width, height: container.bounds.height/2)
    }
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer){
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDrag(_ sender: UIPanGestureRecognizer){
        guard let view = presentedView else {return}
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: presentedView)
      //  print(velocity.y)
        
        if translation.y > 0{
                view.frame = CGRect(x: 0, y: translation.y, width: view.frame.width, height: view.frame.height)
        }
        
        if sender.state == .ended{
            let absVelocity = abs(velocity.y)
            let duration = absVelocity > 200 ? 0.1 : absVelocity > 100 ? 0.3 : absVelocity > 50 ? 0.4 : absVelocity > 25 ? 0.5 : 0.6
            
            if translation.y > (view.frame.height / 100) * 20{
                UIView.animate(withDuration: duration, animations: {
                    view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
                }, completion: { (finished) in
                    self.presentingViewController.dismiss(animated: true, completion: nil)
                })
            } else {
                UIView.animate(withDuration: duration) {
                    view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                }
            }
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        presentedView?.addGestureRecognizer(swipeDown)
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        presentedView?.isUserInteractionEnabled = true
        presentedView?.addGestureRecognizer(pangesture)
    }
}
