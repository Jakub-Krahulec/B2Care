//
//  PatientCell.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit
import MGSwipeTableCell

class PatientCell: MGSwipeTableCell {

   // MARK: - Properties
    
    private let bgView = UIView()
    private let searchField = SearchField()
    private let nameLabel = UILabel()
    private let diagnosisLabel = UILabel()
    private let patientDetailsView = PatientDetailsView()
   
    
    public var data: Any?{
        didSet{
            updateView(with: data)
        }
    }
    
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
//        self.contentView.layer.cornerRadius = 13
//
//        self.contentView.layer.borderColor = UIColor.backgroundLight.cgColor
//        self.contentView.layer.borderWidth = 5
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    private func updateView(with data: Any?){
        guard let data = data as? Patient else{return}
        nameLabel.text = data.fullName
        diagnosisLabel.text = data.hospitalizations.count > 0 ? data.hospitalizations[0].diagnosis.value : NSLocalizedString("without-diagnosis", comment: "")
        patientDetailsView.data = data
    }
    
    private func prepareView(){
       // backgroundColor = .backgroundLight
        
//        contentView.layer.cornerRadius = 13
//        contentView.layer.borderWidth = 5
//        contentView.layer.borderColor = UIColor.backgroundLight.cgColor
        
       // prepareBackgroundViewStyle()
        prepareNameLabelStyle()
        prepareDiagnosisLabelStyle()
       
        preparePatientDetailsViewStyle()
    }
    
    private func preparePatientDetailsViewStyle(){
        addSubview(patientDetailsView)
        patientDetailsView.snp.makeConstraints { (make) in
            make.top.equalTo(diagnosisLabel.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func prepareBackgroundViewStyle(){
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 0
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(3)
            make.left.right.equalToSuperview().inset(6)
        }
        
    }
    
    private func prepareNameLabelStyle(){
       // nameLabel.text = "Tomáš Juřík"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .darkGray
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(30)
        }
    }
    
    private func prepareDiagnosisLabelStyle(){
      //  diagnosisLabel.text = "Pravostranná tříselná kýla"
        diagnosisLabel.font = UIFont.boldSystemFont(ofSize: 14)
        diagnosisLabel.numberOfLines = 0
        diagnosisLabel.textColor = .gray
        
        addSubview(diagnosisLabel)
        diagnosisLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
}
