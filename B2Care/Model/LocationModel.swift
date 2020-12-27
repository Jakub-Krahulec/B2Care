//
//  LocationModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 27.12.2020.
//

import Foundation

struct Location: Codable{
    var id: Int
    var name: String?
    var building: String?
    var room: String?
}
