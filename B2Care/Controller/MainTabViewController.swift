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
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .clear
        
        let patientListVC = PatientListViewController()
        patientListVC.tabBarItem.title = "Seznam pacientů"
        patientListVC.tabBarItem.image = UIImage(systemName: "person.3.fill")

        let cameraVC = SearchPatientViewController()
        cameraVC.tabBarItem.title = "Vyhledání pacienta"
        cameraVC.tabBarItem.image = UIImage(systemName: "qrcode.viewfinder")
        
        viewControllers = [patientListVC, cameraVC]
    }
    
}
