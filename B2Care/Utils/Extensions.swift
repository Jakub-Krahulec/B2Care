//
//  Extensions.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import UIKit

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
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
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
