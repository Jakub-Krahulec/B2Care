//
//  HospitalizationModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import Foundation

struct Hospitalization: Codable{
    var id: Int
    var location: Location
    var diagnosis: Diagnosis
}
