//
//  PatientsModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import Foundation

struct PatientsResponse: Codable{
    var data: PatientsData
}

struct PatientsData: Codable{
    var data: [Patient]
}

struct Patient: Codable {
    var id: Int
    var birthNumber: String
    var jobDespcription: String?
    var importantInfo: String
    var allergies: [Alergy]
    var person: Person
}


struct Alergy: Codable{
    var id: Int
    var code: AlergyCode
}

struct AlergyCode: Codable{
    var id: Int
    var title: String
}

struct Person: Codable {
    var id: Int
    var firstname: String
    var surname: String
    var gender: Gender
    var dateOfBirth: String
    
}

struct Gender: Codable{
    var id: Int
    var title: String
}
