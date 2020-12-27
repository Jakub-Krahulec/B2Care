//
//  MedicationModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import Foundation

struct MedicationDispenses: Codable{
    var id: Int
    var medication: Medication
}

struct Medication: Codable{
    var id: Int
    var title: String
}
