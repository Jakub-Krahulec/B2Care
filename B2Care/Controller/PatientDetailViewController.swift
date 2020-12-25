//
//  PatientDetailViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import UIKit



class PatientDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let headerView = DetailHeaderView()
    private let verticalStack = UIStackView()
    private let insuranceInfoBox = SmallInfoBox()
    private let idNumberInfoBox = SmallInfoBox()
    private let firstLine = UIStackView()
    
    private let diagnosisInfoBox = BigInfoBox()
    private let alergiesInfoBox = BigInfoBox()
    private let medicationsInfoBox = BigInfoBox()
    private let importantInfoBox = BigInfoBox()
    
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
    
    
    // MARK: - Helpers
    
    private func updateView(with person: Patient?){
        guard let person = person else {return}
       // self.navigationItem.title = "\(person.person.firstname) \(person.person.surname)"
        headerView.data = data
        
        insuranceInfoBox.updateView(image: UIImage(systemName: "staroflife.fill")!, title: "POJIŠŤOVNA", value: person.birthNumber)
        idNumberInfoBox.updateView(image: UIImage(systemName: "doc.fill")!, title: "RODNÉ ČÍSLO", value: person.birthNumber)
        diagnosisInfoBox.updateView(image: UIImage(systemName: "waveform.path.ecg")!, title: "DIAGNÓZA", value: "Diagnóza")
        
        var allergies = ""
        for alergy in person.allergies{
            allergies += alergy.code.title + "\n"
        }
        allergies = String(allergies.dropLast(2))
        
        alergiesInfoBox.updateView(image: UIImage(systemName: "heart.slash.fill")!, title: "ALERGIE", value: allergies, tintColor: .systemRed)
        
        var medications = ""
        for medication in person.medicationDispenses{
            medications += medication.medication.title + "\n"
          //  medications += medication.medication.title.trimmingCharacters(in: .whitespaces) + "\n"
        }
        medications = String(medications.dropLast(2))
        
        
        medicationsInfoBox.updateView(image: UIImage(systemName: "staroflife.fill")!, title: "MEDIKACE", value: medications, tintColor: .systemGreen)
        importantInfoBox.updateView(image: UIImage(systemName: "info.circle.fill")!, title: "DŮLEŽITÉ INFORMACE", value: person.importantInfo, tintColor: .gray)
        
        
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight

     //   navigationController?.navigationBar.isTranslucent = false
//        let headerView = DetailHeaderView()
//        navigationItem.titleView = headerView
        
        prepareHeaderViewStyle()
        
        prepareScrollViewStyle()
        
        prepareSmallInfoBoxStyle(insuranceInfoBox)
        prepareSmallInfoBoxStyle(idNumberInfoBox)
        prepareFirstLineStyle()
        
        prepareBigInfoBoxStyle(diagnosisInfoBox)
        prepareBigInfoBoxStyle(alergiesInfoBox)
        prepareBigInfoBoxStyle(medicationsInfoBox)
        prepareBigInfoBoxStyle(importantInfoBox)
        
        prepareVerticalStackStyle()
        
        scrollView.snp.makeConstraints { (make) in
            make.bottom.equalTo(verticalStack).offset(20)
        }
    }
    
    private func prepareHeaderViewStyle(){
        headerView.delegate = self
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo((view.frame.height / 10) + 35)
        }
    }
    
    private func prepareSmallInfoBoxStyle(_ box: SmallInfoBox){
        box.snp.makeConstraints { (make) in
            make.width.equalTo((view.frame.width / 2) - 5)
            make.height.equalTo(80)
        }
    }
    
    private func prepareBigInfoBoxStyle(_ box: BigInfoBox){
        box.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width  - 10)
           // make.height.equalTo(80)
        }
    }
    
    private func prepareFirstLineStyle(){
        firstLine.axis = .horizontal
        firstLine.spacing = 5
        firstLine.distribution = .equalSpacing
        firstLine.alignment = .center
        
        firstLine.addArrangedSubview(insuranceInfoBox)
        firstLine.addArrangedSubview(idNumberInfoBox)
        firstLine.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width - 5)
            make.height.equalTo(80)
        }
    }
        
    private func prepareScrollViewStyle(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
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
        
        scrollView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.width.equalToSuperview()
        }
    }
}

extension PatientDetailViewController: BaseHeaderDelegate{
    func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
