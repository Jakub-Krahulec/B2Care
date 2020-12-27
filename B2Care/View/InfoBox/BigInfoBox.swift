//
//  BigInfoBox.swift
//  B2Care
//
//  Created by Jakub Krahulec on 24.12.2020.
//

import UIKit

class BigInfoBox: UIView {

    // MARK: - Properties
    private let updatedLabel = UILabel()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
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
    
    private func prepareView(){
        backgroundColor = .white
        layer.cornerRadius = 10
        
        prepareUpdatedLabelStyle()
        prepareImageViewStyle()
        prepareTitleLabelStyle()
        prepareValueLabelStyle()
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(valueLabel.snp.bottom).offset(20)
        }
    }
    
    private func prepareUpdatedLabelStyle(){
       // updatedLabel.text = "Aktualizováno 4.5.2020 ve 3:31"
        updatedLabel.textColor = .lightGray
        updatedLabel.textAlignment = .right
        updatedLabel.font = UIFont.systemFont(ofSize: 10)
        updatedLabel.numberOfLines = 0
        
        addSubview(updatedLabel)
        updatedLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(15)
        }
    }
    
    private func prepareImageViewStyle(){
        imageView.tintColor = .mainColor
      // imageView.image = UIImage(systemName: "waveform.path.ecg")
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
           // make.centerY.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    private func prepareTitleLabelStyle(){
      //  titleLabel.text = "DIAGNÓZA"
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            //make.centerY.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(imageView.snp.right).offset(5)
        }
    }
    
    private func prepareValueLabelStyle(){
       // valueLabel.text = "K 358 Akutní apencitida"
        valueLabel.textAlignment = .left
        valueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        valueLabel.numberOfLines = 0
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10) //.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().offset(10)
        }
    }
    
    public func updateView(image: UIImage?, title: String, value: String, updated: String, tintColor: UIColor = .mainColor){
        imageView.image = image
        imageView.tintColor = tintColor
        titleLabel.text = title
        valueLabel.text = value
        updatedLabel.text = "Aktualizováno \(updated)"
    }
}
