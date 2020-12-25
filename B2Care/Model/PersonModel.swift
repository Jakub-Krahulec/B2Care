//
//  PersonModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import Foundation

struct Person: Codable {
    var id: Int
    var firstname: String
    var surname: String
    var gender: Gender
    var dateOfBirth: String
    
}
