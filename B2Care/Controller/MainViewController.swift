//
//  MainViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 07.01.2021.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Propeties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let user = B2CareService.shared.getUserData()
        if let _ = user{
            navigationController?.pushViewController(MainTabViewController(), animated: false)
        } else {
            navigationController?.pushViewController(LoginViewController(), animated: false)
        }
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers

}
