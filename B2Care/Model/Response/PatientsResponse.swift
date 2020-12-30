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
