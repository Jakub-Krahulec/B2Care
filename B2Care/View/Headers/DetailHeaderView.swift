//
//  DetailHeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import UIKit

class DetailHeaderView: BaseHeaderView {

    // MARK: - Properties
    
    
    public var data: Any?{
        didSet{
            updateView(with: data)
        }
    }
    private let titleLabel = UILabel()
    private let patientDetailView = PatientDetailsView()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func updateView(with data: Any?){
        guard let data = data as? Patient else {return}
        titleLabel.text = "\(data.person.firstname) \(data.person.surname)"
        patientDetailView.data = data
    }
    
    private func prepareView(){
        backgroundColor = .mainColor
        
        prepareTitleLabelStyle()
        preparePatientDetailViewStyle()
    }
    
    private func preparePatientDetailViewStyle(){
        patientDetailView.changeStyle(color: .white)
        addSubview(patientDetailView)
        patientDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.text = "Pavel Novák"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
    }
}
