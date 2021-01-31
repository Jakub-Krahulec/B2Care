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
    public var scrollView: UIScrollView?{
        didSet{
            guard let scroll = scrollView else {return}
            scroll.isScrollEnabled = state == .fullScreen ? true : false
            scroll.panGestureRecognizer.addTarget(self, action: #selector(handleScroll(_:)))
        }
    }
    
    private var state = VerticalPresentationState.halfScreen{
        didSet{
            guard let scroll = scrollView else {return}
            switch state {
                case .fullScreen:
                    scroll.isScrollEnabled = true
                case .halfScreen:
                    scroll.isScrollEnabled = false
                    scroll.setContentOffset(.zero, animated: true)
                case .almostClosed:
                    scroll.isScrollEnabled = false
                    scroll.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    private var lastPositionY: CGFloat = 0
    private let topMargin: CGFloat = 50
    private let bottomMargin: CGFloat = 20
    private var shouldScrollViewDrag = false
    private var maxScrolledY: CGFloat = 0
    private var modalHeight: CGFloat {
        return UIScreen.main.bounds.height - topMargin
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = containerView else {
            return
        }
        
        let height = UIScreen.main.bounds.height - topMargin
        container.frame = CGRect(x: 0, y: height / 2, width: container.bounds.width, height: height)
    }
    
    @objc private func closeTapped(_ sender: UIButton){
//        guard let container = containerView else {return}
//        UIView.animate(withDuration: 0.5, animations: {
//            container.frame = CGRect(x: 0, y: container.frame.height, width: container.frame.width, height: container.frame.height)
//        }, completion: { (finished) in
//            self.presentingViewController.dismiss(animated: false, completion: nil)
//        })
        
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func handleScroll(_ sender: UIPanGestureRecognizer){
        guard let scroll = scrollView,
              let container = containerView else {return}
        let scrollOffset = scroll.contentOffset.y;
        // Pokud uživatel scrolluje nad obsah, tak začnu hýbat celým modalem
        if scrollOffset <= 0{
            shouldScrollViewDrag = true
            scroll.contentOffset = CGPoint(x: 0, y: 0)
            handleDrag(sender)
            // Pokud se začne během dragování vracet (druhý směr - nahoru)
        } else if shouldScrollViewDrag {
            //Pokud není úplně nahoře tak draguju,
            if container.frame.origin.y > topMargin{
                scroll.contentOffset = CGPoint(x: 0, y: 0)
                handleDrag(sender)
                // jinak přejdu na scroll
            } else {
                shouldScrollViewDrag = false
                print("FALSE")
            }
            
        } else {
            // Pokud uživatel scrolluje tak si ukládám pozici
            maxScrolledY = sender.translation(in: scroll).y
        }
        
        if sender.state == .ended{
            shouldScrollViewDrag = false
            maxScrolledY = 0
        }
        
    }
    
    @objc private func handleDrag(_ sender: UIPanGestureRecognizer){
        guard let container = containerView else {return}
        
        let translation = sender.translation(in: container)
        
        let currentY: CGFloat =
            state == .halfScreen ? container.bounds.height / 2
            : state == .fullScreen ? topMargin
            : container.bounds.height - bottomMargin
        
        // Vemu aktuální Y (viditelnou výšku v podstatě) a přidám translation a odečtu co uživatel případně nascrolloval (defaultně je maxScrolledY 0)
        let nextPositionY = currentY + translation.y - maxScrolledY
        
        
        // Pokud uživatel překročí horní hranici modalu
        if nextPositionY < topMargin {
            container.frame = CGRect(x: 0, y: topMargin, width: container.bounds.width, height: modalHeight)
            if !shouldScrollViewDrag && nextPositionY <= 0{
                scrollView?.contentOffset = CGPoint(x: 0, y: abs(nextPositionY))
            }
        } else if nextPositionY > modalHeight - bottomMargin{
            container.frame = CGRect(x: 0, y: modalHeight - bottomMargin, width: container.bounds.width, height: modalHeight)
        } else {
            container.frame = CGRect(x: 0, y: nextPositionY, width: container.bounds.width, height: container.bounds.height)
            
            if let scroll = scrollView{
                if scroll.contentOffset.y > 0{
                    scroll.setContentOffset(.zero, animated: false)
                }
            }
        }
        
        if sender.state == .ended{
            let duration = 0.5
            
            if nextPositionY >= (container.bounds.height / 100) * 85{
                setAlmostClosed(duration: duration)
            } else if nextPositionY > container.bounds.height / 3  {
                setHalfScreen(duration: duration)
            } else {
                setFullScreen(duration: duration)
                print("FULLSCREEN")
            }
        }
    }
    
    private func setAlmostClosed(duration: Double){
        guard let container = containerView else {return}
        UIView.animate(withDuration: duration) {
            container.frame = CGRect(x: 0, y: self.modalHeight - self.bottomMargin, width: container.bounds.width, height: container.bounds.height)
        }
        self.state = .almostClosed
    }
    
    private func setHalfScreen(duration: Double){
        guard let container = containerView else {return}
        UIView.animate(withDuration: duration) {
            container.frame = CGRect(x: 0, y: self.modalHeight / 2, width: container.bounds.width, height: container.bounds.height)
        }
        self.state = .halfScreen
    }
    
    private func setFullScreen(duration: Double){
        guard let container = containerView else {return}
        UIView.animate(withDuration: duration){
            container.frame = CGRect(x: 0, y: 50, width: container.bounds.width, height: container.bounds.height)
        }
        self.state = .fullScreen
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
            
            dragLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
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
