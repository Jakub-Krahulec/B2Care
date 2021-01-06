//
//  GraphModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import Foundation

struct GraphsData: Codable{
    var graphs: [Graph]
}

struct Graph: Codable{
    var id: Int
    var name: String
    var created: String
    var updated: String
    var value: String
    var Patient: Patient
}
