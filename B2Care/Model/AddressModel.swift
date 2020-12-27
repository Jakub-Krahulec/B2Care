//
//  AddressModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import Foundation

struct Address: Codable{
    var id: Int
    var address1: String?
    var address2: String?
    var city: String?
    var postalCode: String?
}
