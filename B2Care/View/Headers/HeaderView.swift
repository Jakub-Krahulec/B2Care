//
//  HeaderView.swift
//  B2Care
//
//  Created by Jakub Krahulec on 01.01.2021.
//

import UIKit

enum HeaderBottomViewAlignment{
    case left
    case center
}

class HeaderView: UIView {
    
    // MARK: - Properties
    
    private var leftButton: UIButton?
    private var titleLabel = UILabel()
    private var bottomView: UIView?
    private let topPadding: CGFloat = 20
    private var bottomViewAlign: HeaderBottomViewAlignment
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, leftButton: UIButton? = nil, title: String = "", bottomView: UIView? = nil, bottomViewAlign: HeaderBottomViewAlignment = .center) {
        self.bottomViewAlign = bottomViewAlign
        super.init(frame: frame)
        self.leftButton = leftButton
        self.bottomView = bottomView
        self.titleLabel.text = title
        
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    private func prepareView(){
        backgroundColor = .mainColor
        
        prepareLeftButtonStyle()
        prepareTitleLabelStyle()
        prepareBottomViewStyle()
    }
    
    public func setTitle(_ title: String){
        titleLabel.text = title
    }
    
    private func prepareLeftButtonStyle(){
        guard let btn = leftButton else {return}
        addSubview(btn)
        let centerY = self.safeAreaInsets.top + (self.frame.height / 2) 
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(centerY)
        }
    }
    
    private func prepareTitleLabelStyle(){
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        let centerY = self.safeAreaInsets.top + (self.frame.height / 2)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(centerY)
        }
    }
    
    private func prepareBottomViewStyle(){
        guard let view = bottomView else {return}
        addSubview(view)
        
        view.snp.makeConstraints { [weak self] (make) in
            guard let this = self else {return}
            make.bottom.equalToSuperview().inset(5)
            if this.bottomViewAlign == .left{
                make.left.right.equalToSuperview().inset(5)
            } else if this.bottomViewAlign == .center {
                make.centerX.equalToSuperview()
            }
            make.height.equalTo(27)
        }
    }

}
