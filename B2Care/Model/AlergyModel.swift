//
//  AlergyModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import Foundation

struct Alergy: Codable{
    var id: Int
    var code: AlergyCode
}

struct AlergyCode: Codable{
    var id: Int
    var title: String
}
