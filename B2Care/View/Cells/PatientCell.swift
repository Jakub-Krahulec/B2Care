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
    
    private let nameLabel = UILabel()
    private let diagnosisLabel = UILabel()
    private let detailLine = PatientDetailLine()
   
    
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
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    private func updateView(with data: Any?){
        guard let data = data as? Patient else{return}
        nameLabel.text = data.fullName
        diagnosisLabel.text = data.hospitalizations.count > 0 ? data.hospitalizations[0].diagnosis.value : NSLocalizedString("without-diagnosis", comment: "")
        detailLine.data = data
    }
    
    private func prepareView(){
        prepareNameLabelStyle()
        prepareDiagnosisLabelStyle()
        prepareDetailLineStyle()
        
    }
    
    private func prepareDetailLineStyle(){
        addSubview(detailLine)
        detailLine.snp.makeConstraints { (make) in
            make.top.equalTo(diagnosisLabel.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func prepareNameLabelStyle(){
       // nameLabel.text = "Tomáš Juřík"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .darkGray
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
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
