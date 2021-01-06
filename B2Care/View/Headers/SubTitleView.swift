//
//  SubTitleView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import UIKit

class SubTitleView: UIView {

    // MARK: - Properties
    private let titleLabel = UILabel()
    
    var data: Any? {
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
        guard let headline = data as? String else {return}
        titleLabel.text = headline
    }

    private func prepareView(){
        prepareTitleLabelStyle()
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.text = "Název grafu"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
}
