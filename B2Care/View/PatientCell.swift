//
//  PatientCell.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class PatientCell: UITableViewCell {

   // MARK: - Properties
    private let bgView = UIView()
    private let searchField = SearchField()
    private let nameLabel = UILabel()
    private let diagnosisLabel = UILabel()
    private let locationImage = UIImageView()
    private let departmentLabel = UILabel()
    private let personImage = UIImageView()
    private let ageLabel = UILabel()
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        bounds = bounds.inset(by: padding)
//        contentView.frame = contentView.frame.inset(by: padding)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 13
        
        // Your border code here (set border to contentView)
        self.contentView.layer.borderColor = UIColor.backgroundLight.cgColor
        self.contentView.layer.borderWidth = 5
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    private func prepareView(){
        backgroundColor = .backgroundLight
        addSubview(bgView)
//        contentView.layer.cornerRadius = 13
//        contentView.layer.borderWidth = 5
//        contentView.layer.borderColor = UIColor.backgroundLight.cgColor
        
        
        prepareNameLabelStyle()
        prepareDiagnosisLabelStyle()
        prepareLocationImageStyle()
        prepareDepartmentLabelStyle()
        preparePersonImageStyle()
        prepareAgeLabelStyle()
        prepareBackgroundViewStyle()
    }
    
    private func prepareBackgroundViewStyle(){
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 8
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(3)
            make.left.right.equalToSuperview().inset(6)
        }
        
    }
    
    private func prepareNameLabelStyle(){
        nameLabel.text = "Tomáš Juřík"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .darkGray
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(30)
        }
    }
    
    private func prepareDiagnosisLabelStyle(){
        diagnosisLabel.text = "Pravostranná tříselná kýla"
        diagnosisLabel.font = UIFont.boldSystemFont(ofSize: 14)
        diagnosisLabel.textColor = .gray
        
        addSubview(diagnosisLabel)
        diagnosisLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    private func prepareLocationImageStyle(){
        locationImage.image = UIImage(systemName: "location.fill")
        locationImage.tintColor = .gray
        
        addSubview(locationImage)
        locationImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(diagnosisLabel.snp.bottom).offset(15)
            make.height.width.equalTo(15)
        }
    }
    
    private func prepareDepartmentLabelStyle(){
        departmentLabel.text = "Chirurgie I, Pokoj 232/1"
        departmentLabel.font = UIFont.boldSystemFont(ofSize: 10)
        departmentLabel.textColor = .lightGray
        
        addSubview(departmentLabel)
        departmentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationImage.snp.right).offset(10)
            make.top.equalTo(locationImage)
        }
    }
    
    private func preparePersonImageStyle(){
        personImage.image = UIImage(systemName: "person.fill")
        personImage.tintColor = .gray
        
        addSubview(personImage)
        personImage.snp.makeConstraints { (make) in
            make.left.equalTo(departmentLabel.snp.right).offset(20)
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
            make.left.equalTo(personImage.snp.right).offset(10)
            make.top.equalTo(personImage)
            make.bottom.equalToSuperview().inset(30)
        }
    }

}
