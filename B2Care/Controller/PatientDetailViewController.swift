//
//  PatientDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit



class PatientDetailViewController: UIViewController, BaseHeaderDelegate {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
  //  private let tabbar = UITabBar()

    private let refreshControl = UIRefreshControl()
  //  private let headerView = DetailHeaderView()
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
            B2CareService.shared.fetchPatient(id: id) { (result) in
                switch result{
                    
                    case .success(let data):
                        self.data = data
                    case .failure(let error):
                        self.showMessage(withTitle: "Chyba", message: error.localizedDescription)
                }
            }
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //  navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: AnyObject){
        //fetchPatients()
        refreshControl.endRefreshing()
        patientId = data?.id
        
    }
    
    // MARK: - Helpers
    
    private func updateView(with person: Patient?){
        guard let person = person else {return}
        // self.navigationItem.title = "\(person.person.firstname) \(person.person.surname)"
     //   headerView.data = person
        let diagnosis = person.hospitalizations.count > 0 ? person.hospitalizations[0].diagnosis.value : "-"
        let doctorNumber = person.generalPractitioners.count > 0 && person.generalPractitioners[0].person.contacts.count > 0 ? person.generalPractitioners[0].person.contacts[0].value : "-"
        
        insuranceInfoBox.updateView(image: UIImage(systemName: "staroflife.fill"), title: "POJIŠŤOVNA", value: "-")
        idNumberInfoBox.updateView(image: UIImage(systemName: "doc.fill"), title: "RODNÉ ČÍSLO", value: person.birthNumber)
        diagnosisInfoBox.updateView(image: UIImage(systemName: "waveform.path.ecg"), title: "DIAGNÓZA", value: diagnosis, updated: getUpdatedDateString(person: person))
        alergiesInfoBox.updateView(image: UIImage(systemName: "heart.slash.fill"), title: "ALERGIE", value: getAlergiesString(person: person), updated: getUpdatedDateString(person: person), tintColor: .systemRed)
        medicationsInfoBox.updateView(image: UIImage(systemName: "staroflife.fill"), title: "MEDIKACE", value: getMedicationsString(person: person), updated: getUpdatedDateString(person: person), tintColor: .systemGreen)
        importantInfoBox.updateView(image: UIImage(systemName: "info.circle.fill"), title: "DŮLEŽITÉ INFORMACE", value: person.importantInfo, updated: getUpdatedDateString(person: person), tintColor: .gray)
        personalPhoneInfoBox.updateView(image: UIImage(systemName: ""), title: "OSOBNÍ TELEFON", value: person.person.contacts.count > 0 ? person.person.contacts[0].value : "-")
        doctorPhoneInfoBox.updateView(image: UIImage(systemName: ""), title: "OŠETŘUJÍCÍ LÉKAŘ", value: doctorNumber)
        addressInfoBox.updateView(image: UIImage(systemName: "house.fill"), title: "ADRESA", value: getAddressString(person: person))
        proffesionInfoBox.updateView(image: UIImage(systemName: "tag.fill"), title: "PROFESE", value: person.jobDescription  ?? "-")
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareScrollViewStyle()
        prepareRefreshControlStyle()
        
        prepareSmallInfoBoxStyle(insuranceInfoBox)
        prepareSmallInfoBoxStyle(idNumberInfoBox)
        prepareHorizontalStack(firstLine, smallInfos: [insuranceInfoBox,idNumberInfoBox])
        
        prepareBigInfoBoxStyle(diagnosisInfoBox)
        prepareBigInfoBoxStyle(alergiesInfoBox)
        prepareBigInfoBoxStyle(medicationsInfoBox)
        prepareBigInfoBoxStyle(importantInfoBox)
        
        prepareSmallInfoBoxStyle(personalPhoneInfoBox)
        prepareSmallInfoBoxStyle(doctorPhoneInfoBox)
        prepareHorizontalStack(contactsStack, smallInfos: [personalPhoneInfoBox,doctorPhoneInfoBox])
        prepareSmallInfoBoxStyle(addressInfoBox)
        prepareSmallInfoBoxStyle(proffesionInfoBox)
        prepareHorizontalStack(addressStack, smallInfos: [addressInfoBox,proffesionInfoBox])
        
        prepareVerticalStackStyle()
        
        let headerHeight = (view.frame.height / 10) + 35
        let tabbarHeight: CGFloat = 50
        let buttonsHeight: CGFloat = 50
        let padding: CGFloat = 45
        let offset: CGFloat = headerHeight + tabbarHeight + buttonsHeight + padding
        scrollView.snp.makeConstraints { (make) in
            make.bottom.equalTo(verticalStack).offset(offset)
        }
    }
    
    private func prepareRefreshControlStyle(){
        refreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        // scrollView.addSubview(refreshControl)
        scrollView.refreshControl = refreshControl
    }

    private func prepareSmallInfoBoxStyle(_ box: SmallInfoBox){
        if let contactBox = box as? ContactSmallInfoBox{
            contactBox.delegate = self
        }
        
        box.snp.makeConstraints { (make) in
            make.width.equalTo((view.frame.width / 2) - 5)
            //make.height.equalTo(80)
        }
    }
    
    private func prepareBigInfoBoxStyle(_ box: BigInfoBox){
        box.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width  - 10)
            // make.height.equalTo(80)
        }
    }
    
    private func prepareHorizontalStack(_ stack: UIStackView, smallInfos: [SmallInfoBox]){
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        for box in smallInfos{
            stack.addArrangedSubview(box)
        }
        stack.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width - 5)
            // make.height.equalTo(80)
        }
    }
    
    private func prepareScrollViewStyle(){
        //scrollView.isScrollEnabled = true
        //scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            //make.top.equalTo(tabbar.snp.bottom).offset(5)
            make.top.equalToSuperview().offset(5)
            make.left.right.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func prepareVerticalStackStyle(){
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        verticalStack.distribution = .equalSpacing
        verticalStack.alignment = .center
        verticalStack.addArrangedSubview(firstLine)
        verticalStack.addArrangedSubview(diagnosisInfoBox)
        verticalStack.addArrangedSubview(alergiesInfoBox)
        verticalStack.addArrangedSubview(medicationsInfoBox)
        verticalStack.addArrangedSubview(importantInfoBox)
        verticalStack.addArrangedSubview(contactsStack)
        verticalStack.addArrangedSubview(addressStack)
        
        scrollView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.width.equalToSuperview()
        }
    }
    
    private func getUpdatedDateString(person: Patient) -> String {
        let updatedDate = DateService.shared.getDateFromString(person.updated ?? person.created ?? "")
        var updated = ""
        if let updatedDate = updatedDate{
            updated = DateService.shared.getFormattedString(from: updatedDate)
        }
        return updated
    }
    
    private func getAlergiesString(person: Patient) -> String{
        var allergies = ""
        for alergy in person.allergies{
            allergies += alergy.code.title + "\n"
        }
        allergies = String(allergies.dropLast(2))
        return allergies
    }
    
    private func getMedicationsString(person: Patient) -> String {
        var medications = ""
        for medication in person.medicationDispenses{
            medications += medication.medication.title + "\n"
            //  medications += medication.medication.title.trimmingCharacters(in: .whitespaces) + "\n"
        }
        medications = String(medications.dropLast(2))
        
        return medications
    }
    
    private func getAddressString(person: Patient) -> String {
        var address = ""
        if person.person.addresses.count > 0{
            if let address1 = person.person.addresses[0].address1{
                address += address1 + ", "
            }
            if let city = person.person.addresses[0].city{
                address += city
            }
        } else {
            address = "-"
        }
        return address
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
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
}

