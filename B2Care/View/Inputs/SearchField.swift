//
//  SearchField.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit

class SearchField: UITextField {
    // MARK: - Properties
    
    let searchImage = UIButton()
    
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
    public func setPlaceholder(_ placeholder: String){
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    private func prepareView(){
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        textColor = .white
        layer.cornerRadius = 8
        placeholder = ""
        attributedPlaceholder = NSAttributedString(string: "Vyhledat pacienta",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        setLeftPaddingPoints(35)
        setRightPaddingPoints(10)
        
        prepareSearchImageViewStyle()
       // leftView = searchImage

    }
    
    private func prepareSearchImageViewStyle(){
        searchImage.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)  // UIImage(systemName: "magnifyingglass")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        searchImage.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        searchImage.tintColor = .white
        addSubview(searchImage)
        searchImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
    }
}
