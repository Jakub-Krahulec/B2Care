//
//  MainTabViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class MainTabViewController: UITabBarController {

    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .clear
        
        let patientListVC = PatientsListViewController()
        patientListVC.tabBarItem.title = NSLocalizedString("patient-list", comment: "")
        patientListVC.tabBarItem.image = UIImage(systemName: "person.3.fill")

        let cameraVC = SearchPatientViewController()
        cameraVC.tabBarItem.title = NSLocalizedString("patient-search", comment: "")
        cameraVC.tabBarItem.image = UIImage(systemName: "qrcode.viewfinder")
        
        let nav1 = UINavigationController(rootViewController: patientListVC)
        prepareNavigationControllerStyle(nav: nav1)
        
        let nav2 = UINavigationController(rootViewController: cameraVC)
        prepareNavigationControllerStyle(nav: nav2)
        
        viewControllers = [nav1 , nav2 ]
    }
    
    
    
}
