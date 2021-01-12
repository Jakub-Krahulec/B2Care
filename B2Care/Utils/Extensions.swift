//
//  Extensions.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
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
}

extension UIViewController{
    
    var headerHeight: CGFloat {
        return (self.view.frame.height / 10) + 35
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

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIApplication {
    /// Checks if view hierarchy of application contains `UIRemoteKeyboardWindow` if it does, keyboard is presented
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
           self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}

