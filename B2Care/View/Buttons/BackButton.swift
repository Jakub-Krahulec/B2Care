//
//  BackButton.swift
//  B2Care
//
//  Created by Jakub Krahulec on 02.01.2021.
//

import UIKit

protocol BackButtonDelegate where Self: UIViewController{
    
}

extension BackButtonDelegate{
    func backButtonTapped(){
        _ = navigationController?.popViewController(animated: true)
    }
}

class BackButton: UIButton {

    // MARK: - Properties
    public var delegate: BackButtonDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleBackButtonTapped(){
        delegate?.backButtonTapped()
    }
    
    // MARK: - Helpers

    private func prepareView(){
        tintColor = .white
        setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
        addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
    }
}
