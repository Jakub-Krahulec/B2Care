//
//  PlaceDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.01.2021.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let dragLine = UIView()
    private let titleLabel = UILabel()
    private let middleLabel = UILabel()
    private let bottomLabel = UILabel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        view.backgroundColor = .white
    
        prepareTitleLabelStyle()
        prepareMiddleLabelStyle()
        prepareBottomLabelStyle()
    }
    
   
    
    private func prepareTitleLabelStyle(){
        titleLabel.text = "Helfštýn"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = UIColor.black.withAlphaComponent(1)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    private func prepareBottomLabelStyle(){
        middleLabel.text = "Kousek nad středem"
        middleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        middleLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        
        view.addSubview(middleLabel)
        middleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func prepareMiddleLabelStyle(){
        bottomLabel.text = "Kousek nad spodem"
        bottomLabel.font = UIFont.boldSystemFont(ofSize: 25)
        bottomLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        
        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}
