//
//  PlaceModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 30.01.2021.
//

import Foundation
import MapKit

struct PlacesData: Codable{
    var places: [Place]
}



struct Place: Codable{
    var id: Int
    var name: String
    var wikiArticle: String
    var imageURL: String
    var latitude: Double
    var longtitude: Double
    var created: String?
    var updated: String?
    var description: String?
    
    var coordinates: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longtitude))
    }
}
