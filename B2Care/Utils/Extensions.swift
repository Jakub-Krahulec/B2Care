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
        let blurLoader = BlurLoader(frame: frame)
        self.addSubview(blurLoader)
        blurLoader.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func removeBluerLoader() {
//        for view in subviews.filter({$0 is BlurLoader}){
//            view.removeFromSuperview()
//        }
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
    
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 15
    }
}

extension UIColor{
    
    static var mainColor: UIColor {
        return UIColor(red: 71/255, green: 99/255, blue: 228/255, alpha: 1.0)
    }
    
    static var headerMainColor: UIColor {
        return UIColor(red: 48/255, green: 40/255, blue: 119/255, alpha: 1.0)
    }
    
    static var headerSecondaryColor: UIColor {
        return UIColor(red: 79/255, green: 66/255, blue: 186/255, alpha: 1.0)
    }
    
    static var backgroundLight: UIColor {
        return UIColor(red: 241/255, green: 241/255, blue: 246/255, alpha: 1.0)
    }
    
    static var borderLight: UIColor {
        return UIColor(red: 232/255, green: 237/255, blue: 243/255, alpha: 1.0)
    }
    
}

extension UIViewController{
    
    var headerHeight: CGFloat {
        return (self.view.frame.height / 10) + 35
    }
    
    func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
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

