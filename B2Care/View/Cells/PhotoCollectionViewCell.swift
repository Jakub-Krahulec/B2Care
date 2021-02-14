//
//  PhotoCollectionViewCell.swift
//  B2Care
//
//  Created by Jakub Krahulec on 11.02.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let backgroundImage = UIImageView()
    
    open var data: Any? {
        didSet{
            updateView(with: data)
        }
    }
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func updateView(with data: Any?){
        guard let data = data as? UIImage else{return}
        backgroundImage.image = data
    }
    
    private func prepareView(){
        prepareBackgroundImageStyle()
    }
    
    private func prepareBackgroundImageStyle(){
        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
