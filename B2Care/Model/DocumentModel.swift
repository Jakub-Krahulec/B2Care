//
//  DocumentModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.12.2020.
//

import Foundation

struct DocumentsData: Codable{
    var documents: [Document]
}

struct Document: Codable{
    var id: Int
    var name: String
    var created: String
    var updated: String
    var value: String
}
