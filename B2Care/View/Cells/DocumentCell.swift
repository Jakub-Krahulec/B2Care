//
//  DocumentCell.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.12.2020.
//

import UIKit

class DocumentCell: UITableViewCell {
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let arrowImage = UIImageView()
    
    var data: Any? {
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
        guard let data = data as? Document else {return}
        titleLabel.text = data.name
        dateLabel.text = data.created
    }
    
    private func prepareView(){
        backgroundColor = .white
        
        prepareTitleLabelStyle()
        prepareArrowImageStyle()
        prepareDateLabelStyle()
        
    }
    
    private func prepareTitleLabelStyle(){
       // titleLabel.text = "Příjmová zpráva"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }
    
    private func prepareDateLabelStyle(){
       // dateLabel.text = "4.5.2020 ve 3:10"
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImage.snp.left).offset(-15)
        }
    }
    
    private func prepareArrowImageStyle(){
        arrowImage.image = UIImage(systemName: "chevron.right")
        arrowImage.tintColor = .mainColor
        
        addSubview(arrowImage)
        arrowImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
    }
    
}
