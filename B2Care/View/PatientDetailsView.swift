//
//  PatientDetailsView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import UIKit

class PatientDetailsView: UIView {

    // MARK: - Properties
    var data: Any? {
        didSet{
            updateView(with: data)
        }
    }
    
    private let locationImage = UIImageView()
    private let departmentLabel = UILabel()
    private let personImage = UIImageView()
    private let ageLabel = UILabel()
    
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
    
    public func changeStyle(color: UIColor){
        locationImage.tintColor = .white
        departmentLabel.textColor = .white
        personImage.tintColor = .white
        ageLabel.textColor = .white
    }
    
    private func updateView(with data: Any?){
        if let data = data as? Person{
            let age = DateService.shared.getAgeFromString(data.dateOfBirth)
            if let age = age {
                ageLabel.text = "\(age), \(data.gender.title.first ?? " ")"
            }
            else {
                ageLabel.text = "\(data.dateOfBirth), \(data.gender.title.first ?? " ")"
            }
        }
    }
    
    private func prepareView(){
        self.backgroundColor = .green
        prepareLocationImageStyle()
        prepareDepartmentLabelStyle()
        preparePersonImageStyle()
        prepareAgeLabelStyle()
        
        snp.makeConstraints { (make) in
           //make.left.equalTo(0)
            make.right.equalTo(ageLabel.snp.right)
        }
    }
    
    private func prepareLocationImageStyle(){
        locationImage.image = UIImage(systemName: "location.fill")
        locationImage.tintColor = .gray
        
        addSubview(locationImage)
        locationImage.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalToSuperview()
            make.height.width.equalTo(15)
        }
    }
    
    private func prepareDepartmentLabelStyle(){
        departmentLabel.text = "Chirurgie I, Pokoj 232/1"
        departmentLabel.font = UIFont.boldSystemFont(ofSize: 10)
        departmentLabel.textColor = .lightGray
        
        addSubview(departmentLabel)
        departmentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationImage.snp.right).offset(2)
            make.top.equalTo(locationImage).offset(2)
        }
    }
    
    private func preparePersonImageStyle(){
        personImage.image = UIImage(systemName: "person.fill")
        personImage.tintColor = .gray
        
        addSubview(personImage)
        personImage.snp.makeConstraints { (make) in
            make.left.equalTo(departmentLabel.snp.right).offset(10)
            make.top.equalTo(locationImage)
            make.height.width.equalTo(15)
        }
    }
    
    private func prepareAgeLabelStyle(){
        ageLabel.text = "57 let, M"
        ageLabel.font = UIFont.boldSystemFont(ofSize: 10)
        ageLabel.textColor = .lightGray
        
        addSubview(ageLabel)
        ageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(personImage.snp.right).offset(2)
            make.top.equalTo(personImage).offset(2)
        }
    }
}
