//
//  UserModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import Foundation

struct UserResponse: Codable{
    var data: UserData
}

struct UserData: Codable{
    var id: Int
    var name: String
    var surname: String
    var email: String
    var apiKey: String
}
