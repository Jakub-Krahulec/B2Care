//
//  PatientPlanViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.01.2021.
//

import UIKit

class PatientPlanViewController: BaseViewController {

    // MARK: - Properties
    private let openButton = UIButton()
    
    // MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    @objc private func handleOpenButtonTapped(_ sender: UIButton){
        let controller = UserViewController()
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
     //   controller.modalTransitionStyle = .flipHorizontal
    //    controller.view.layer.cornerRadius = 40
        
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .white
        
        prepareOpenButtonStyle()
    }
    
    private func prepareOpenButtonStyle(){
        openButton.setTitle("Otevři modal", for: .normal)
        openButton.backgroundColor = .mainColor
        openButton.layer.cornerRadius = 10
        openButton.addTarget(self, action: #selector(handleOpenButtonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(openButton)
        openButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }

}

extension PatientPlanViewController{
    override func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
       // return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
