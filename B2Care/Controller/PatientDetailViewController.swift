//
//  PatientDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit



class PatientDetailViewController: BaseViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    private let verticalStack = UIStackView()
    private let insuranceInfoBox = SmallInfoBox()
    private let idNumberInfoBox = SmallInfoBox()
    private let firstLine = UIStackView()
    
    private let diagnosisInfoBox = BigInfoBox()
    private let alergiesInfoBox = BigInfoBox()
    private let medicationsInfoBox = BigInfoBox()
    private let importantInfoBox = BigInfoBox()
    
    private let personalPhoneInfoBox = ContactSmallInfoBox()
    private let doctorPhoneInfoBox = ContactSmallInfoBox()
    private let addressInfoBox = SmallInfoBox()
    private let proffesionInfoBox = SmallInfoBox()
    private let contactsStack = UIStackView()
    private let addressStack = UIStackView()
    
    var patientId: Int? {
        didSet{
            guard let id = patientId else {return}
            //  view.showBlurLoader()
            let request = B2CareService.shared.fetchPatient(id: id) { [weak self] (result) in
                guard let this = self else {return}
                switch result{
                    
                    case .success(let data):
                        this.data = data
                    case .failure(let error):
                        this.showMessage(withTitle: "Chyba", message: error.localizedDescription)
                }
                this.removeRequests()
            }
            dataRequests.insert(request)
        }
    }
    var data: Patient?{
        didSet{
            updateView(with: data)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        showBlurLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //  navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: AnyObject){
        refreshControl.endRefreshing()
        patientId = data?.id
    }
    
    // MARK: - Helpers
    
    private func updateView(with person: Patient?){
        guard let person = person else {return}
        let diagnosis = person.hospitalizations.count > 0 ? person.hospitalizations[0].diagnosis.value : ""
        let doctorNumber = person.generalPractitioners.count > 0 && person.generalPractitioners[0].person.contacts.count > 0 ? person.generalPractitioners[0].person.contacts[0].value : "-"
        
        insuranceInfoBox.updateView(image: UIImage(systemName: "staroflife.fill"), title: "POJIŠŤOVNA", value: "-")
        idNumberInfoBox.updateView(image: UIImage(systemName: "doc.fill"), title: "RODNÉ ČÍSLO", value: person.birthNumber)
        diagnosisInfoBox.updateView(image: UIImage(systemName: "waveform.path.ecg"), title: "DIAGNÓZA", value: diagnosis, updated: person.updatedDateString)
        alergiesInfoBox.updateView(image: UIImage(systemName: "heart.slash.fill"), title: "ALERGIE", value: person.allergiesString, updated: person.updatedDateString, tintColor: .systemRed)
        medicationsInfoBox.updateView(image: UIImage(systemName: "staroflife.fill"), title: "MEDIKACE", value: person.medications, updated: person.updatedDateString, tintColor: .systemGreen)
        importantInfoBox.updateView(image: UIImage(systemName: "info.circle.fill"), title: "DŮLEŽITÉ INFORMACE", value: person.importantInfo, updated:person.updatedDateString, tintColor: .gray)
        personalPhoneInfoBox.updateView(image: UIImage(systemName: ""), title: "OSOBNÍ TELEFON", value: person.person.contacts.count > 0 ? person.person.contacts[0].value : "-")
        doctorPhoneInfoBox.updateView(image: UIImage(systemName: ""), title: "OŠETŘUJÍCÍ LÉKAŘ", value: doctorNumber)
        addressInfoBox.updateView(image: UIImage(systemName: "house.fill"), title: "ADRESA", value: person.fullAddress)
        proffesionInfoBox.updateView(image: UIImage(systemName: "tag.fill"), title: "PROFESE", value: person.jobDescription  ?? "-")
        
        view.removeBluerLoader()
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareScrollViewStyle()
        prepareRefreshControlStyle()
        prepareHorizontalStack(firstLine, smallInfos: [insuranceInfoBox,idNumberInfoBox])
        prepareHorizontalStack(contactsStack, smallInfos: [personalPhoneInfoBox,doctorPhoneInfoBox])
        prepareHorizontalStack(addressStack, smallInfos: [addressInfoBox,proffesionInfoBox])
        prepareVerticalStackStyle()
        
        personalPhoneInfoBox.delegate = self
        doctorPhoneInfoBox.delegate = self
    }
    
    private func prepareRefreshControlStyle(){
      //  refreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        // scrollView.addSubview(refreshControl)
        scrollView.refreshControl = refreshControl
    }
    
    private func prepareHorizontalStack(_ stack: UIStackView, smallInfos: [SmallInfoBox]){
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.alignment = .fill
        
        for box in smallInfos{
            stack.addArrangedSubview(box)
        }
    }
    
    private func prepareScrollViewStyle(){
        scrollView.backgroundColor = .backgroundLight
        scrollView.isDirectionalLockEnabled = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(105)
        }
    }
    
    private func prepareVerticalStackStyle(){
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        verticalStack.distribution = .equalSpacing
        verticalStack.alignment = .fill
        
        verticalStack.addArrangedSubview(firstLine)
        verticalStack.addArrangedSubview(diagnosisInfoBox)
        verticalStack.addArrangedSubview(alergiesInfoBox)
        verticalStack.addArrangedSubview(medicationsInfoBox)
        verticalStack.addArrangedSubview(importantInfoBox)
        verticalStack.addArrangedSubview(contactsStack)
        verticalStack.addArrangedSubview(addressStack)
        
        scrollView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(scrollView)
        }
    }
}

extension PatientDetailViewController: ContactSmallInfoBoxDelegate{
    func callButtonTapped(phoneNumber: String) {
        let number = phoneNumber.filter { !$0.isWhitespace }
        
        if let phoneCallURL = URL(string: "telprompt://\(number)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
}


