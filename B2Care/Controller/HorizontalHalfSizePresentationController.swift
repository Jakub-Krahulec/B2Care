//
//  HorizontalHalfSizePresentationController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 26.01.2021.
//

import UIKit

class HorizontalHalfSizePresentationController: UIPresentationController {
    
    private var lastPosition: CGFloat = 0
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = containerView else {
            return
        }
        let width = container.bounds.width - (container.bounds.width / 4)
        container.frame = CGRect(x: 0, y: 0, width: width, height: container.bounds.height)
    }
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer){
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDrag(_ sender: UIPanGestureRecognizer){
        guard let view = presentedView else {return}
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: presentedView)
        
        if translation.x < 0{
            // o kolik % se zmenší o tolik zprůhledním
            view.alpha = 1 - abs(translation.x / view.frame.width)
            view.frame = CGRect(x: 0 + translation.x, y: 0, width: view.frame.width, height: view.frame.height)
            
            lastPosition = translation.x
        }

        if sender.state == .ended{
           
            let absVelocity = abs(velocity.x)
            let duration = absVelocity > 200 ? 0.3 : absVelocity > 100 ? 0.4 : absVelocity > 50 ? 0.5 : absVelocity > 25 ? 0.6 : 0.7
            
            let cancel = lastPosition < velocity.x && velocity.x > 100
 
            if translation.x < ((view.frame.width / 100) * 20) * -1 && !cancel{
                UIView.animate(withDuration: duration, animations: {
                    view.alpha = 0
                    view.frame = CGRect(x: view.frame.width * -1
                                        , y: 0, width: view.frame.width, height: view.frame.height)
                }, completion: { [weak self] (finished) in
                    self?.presentingViewController.dismiss(animated: false, completion: nil)
                    self?.lastPosition = 0
                })
            } else {
                UIView.animate(withDuration: duration,animations: {
                    view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                    view.alpha = 1
                }) { [weak self] (finished) in
                    self?.lastPosition = 0
                }
            }
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .left
        presentedView?.addGestureRecognizer(swipeDown)
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        presentedView?.isUserInteractionEnabled = true
        presentedView?.addGestureRecognizer(pangesture)
    }
}
