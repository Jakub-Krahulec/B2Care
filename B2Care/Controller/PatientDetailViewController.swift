//
//  PatientDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PatientDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    

    // MARK: - Actions
    
    
    // MARK: - Helpers
    private func prepareView(){
        view.backgroundColor = .green
    }
}
