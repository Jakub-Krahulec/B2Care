//
//  PlaceDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.01.2021.
//

import UIKit
import MapKit

protocol PlaceDetailViewControllerDelegate{
    func navigationButtonTapped(coordinates: CLLocationCoordinate2D)
}

class PlaceDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    public let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let photo = UIImageView()
    private let navigateButton = UIButton()
    
    private let wikiLabel = UILabel()
    private let wikiTextLabel = UILabel()
    public var delegate: PlaceDetailViewControllerDelegate?
    
    open var data: Any?{
        didSet{
            updateView(with: data)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    
    // MARK: - Actions
    
    @objc private func updateProgress(with: Double){
        
    }
    
    @objc private func handleNavigateButtonTapped(_ sender: UIButton){
        guard let data = data as? Place else {return}
        delegate?.navigationButtonTapped(coordinates: data.coordinates)
    }
    
    
    // MARK: - Helpers
    
    private func updateView(with data: Any?){
        guard let data = data as? Place else {return}
        
        let _ = NetworkService.shared.getImageFromURL(data.imageURL, progressChanged: updateProgress(with:)) { [weak self] (result) in
            guard let this = self else {return}
            switch result {
                case .success(let image):
                    if let image = image{
                        this.photo.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        titleLabel.text = data.name
        wikiTextLabel.text = data.wikiArticle
    }
    
    private func prepareView(){
        view.backgroundColor = .white
    
        prepareTitleLabelStyle()
        prepareScrollViewStyle()
        prepareNavigateButtonStyle()
        preparePhotoStyle()
        prepareWikiLabelStyle()
        prepareWikiTextLabelStyle()
    }
    
   
    
    private func prepareTitleLabelStyle(){
        //titleLabel.text = "Hrad Helfštýn"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = UIColor.black.withAlphaComponent(1)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    private func prepareScrollViewStyle(){
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func prepareNavigateButtonStyle(){
        navigateButton.setTitle("Trasa", for: .normal)
        navigateButton.tintColor = .white
        navigateButton.backgroundColor = .mainColor
        navigateButton.layer.cornerRadius = 10
        navigateButton.addTarget(self, action: #selector(handleNavigateButtonTapped(_:)), for: .touchUpInside)
        
        scrollView.addSubview(navigateButton)
        navigateButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func preparePhotoStyle(){
        photo.image = UIImage(systemName: "camera")
        photo.tintColor = UIColor.black.withAlphaComponent(0.1)
        photo.contentMode = .scaleAspectFit
        scrollView.addSubview(photo)
        photo.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).inset(15)
            make.top.equalTo(navigateButton.snp.bottom).offset(10)
            make.height.equalTo(view.frame.height / 3)
        }
    }
    
    private func prepareWikiLabelStyle(){
        wikiLabel.text = "Wikipedia"
        wikiLabel.font = UIFont.boldSystemFont(ofSize: 25)
        wikiLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        
        scrollView.addSubview(wikiLabel)
        wikiLabel.snp.makeConstraints { (make) in
            make.top.equalTo(photo.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    private func prepareWikiTextLabelStyle(){
       // wikiTextLabel.text = text
      //  wikiLabel.font = UIFont.boldSystemFont(ofSize: 25)
        wikiTextLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        wikiTextLabel.numberOfLines = 0
        
        scrollView.addSubview(wikiTextLabel)
        wikiTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wikiLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(view).inset(15)
        }
    }
}


