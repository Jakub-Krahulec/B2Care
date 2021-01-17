//
//  UIViewControllerExtensions.swift
//  B2Care
//
//  Created by Jakub Krahulec on 13.01.2021.
//

import UIKit
import LocalAuthentication

extension UIViewController{
    
    var tabbarHeight: CGFloat{
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    var isFaceIDSupported: Bool {
        if #available(iOS 11.0, *) {
            let localAuthenticationContext = LAContext()
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return localAuthenticationContext.biometryType == .faceID
            }
        }
        return false
    }
    
    @objc func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        if let this = self as? UIGestureRecognizerDelegate{
            tapGesture.delegate = this
        }
        tapGesture.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func prepareNavigationControllerStyle(nav: UINavigationController){
        nav.navigationBar.barTintColor = .mainColor
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.tintColor = .white
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        nav.navigationBar.topItem?.title = " "
        //        nav.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
