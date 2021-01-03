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
    private let personLabel = UILabel()
    
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
        personLabel.textColor = .white
    }
    
    private func updatePersonLabelText(with person: Person){
        let age = DateService.shared.getAgeFromString(person.dateOfBirth)
        if let age = age {
            personLabel.text = "\(age), \(person.gender.title.first ?? " ")"
        }
        else {
            personLabel.text = "\(person.dateOfBirth), \(person.gender.title.first ?? " ")"
        }
    }
    
    private func updateDepartmentLabelText(with hospitalization: Hospitalization){
        var location = ""
        if let name = hospitalization.location.name{
            location += "\(name)"
        }
        if let room = hospitalization.location.room{
            if location.count > 0 {
                location += ", "
            }
            location += "Pokoj \(room)"
        }
        departmentLabel.text = location
    }
    
    private func updateView(with data: Any?){
        guard let data = data as? Patient else {return}
        
        updatePersonLabelText(with: data.person)
        if data.hospitalizations.count > 0 {
            updateDepartmentLabelText(with: data.hospitalizations[0])
            
        } else {
            departmentLabel.text = "V domácí péči"
        }
        
    }
    
    private func prepareView(){
        prepareLocationImageStyle()
        prepareDepartmentLabelStyle()
        preparePersonImageStyle()
        prepareAgeLabelStyle()
        
        snp.makeConstraints { (make) in
            make.right.equalTo(personLabel.snp.right)
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
       // departmentLabel.text = "Chirurgie I, Pokoj 232/1"
        departmentLabel.font = UIFont.boldSystemFont(ofSize: 12)
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
            make.left.equalTo(departmentLabel.snp.right).offset(12)
            make.top.equalTo(locationImage)
            make.height.width.equalTo(15)
        }
    }
    
    private func prepareAgeLabelStyle(){
       // ageLabel.text = "57 let, M"
        personLabel.font = UIFont.boldSystemFont(ofSize: 12)
        personLabel.textColor = .lightGray
        
        addSubview(personLabel)
        personLabel.snp.makeConstraints { (make) in
            make.left.equalTo(personImage.snp.right).offset(2)
            make.top.equalTo(personImage).offset(2)
        }
    }
}
