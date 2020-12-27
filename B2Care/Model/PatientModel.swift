//
//  PatientModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import Foundation

struct Patient: Codable {
    var id: Int
    var birthNumber: String
    var jobDescription: String?
    var importantInfo: String
    var allergies: [Alergy]
    var person: Person
    var medicationDispenses: [MedicationDispenses]
    var created: String?
    var updated: String?
    var generalPractitioners: [Doctor]
}



