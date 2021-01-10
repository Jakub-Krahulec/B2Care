//
//  PatientModel.swift
//  B2Care
//
//  Created by Jakub Krahulec on 25.12.2020.
//

import Foundation

struct Patient: Codable {
    var id: Int
    var birthNumber: String
    var jobDescription: String?
    var importantInfo: String
    var allergies: [Alergy]
    var person: Person
    var medicationDispenses: [MedicationDispenses]
    var created: String?
    var updated: String?
    var generalPractitioners: [Doctor]
    var hospitalizations: [Hospitalization]
    
    var updatedDateString: String {
        let updatedDate = Date.getDateFromString(self.updated ?? self.created ?? "")
        var updated = ""
        if let updatedDate = updatedDate{
            updated = Date.getFormattedString(from: updatedDate)
        }
        return updated
    }
    
    var allergiesString: String {
        var allergies: [String] = []
        for alergy in self.allergies{
            allergies.append(alergy.code.title)
        }
        return allergies.joined(separator: "\n")
    }
    
    var medications: String {
        var medications: [String] = []
        for medication in self.medicationDispenses{
            medications.append(medication.medication.title)
        }
        return medications.joined(separator: "\n")
    }
    
    var fullAddress: String {
        var address: [String] = []
        if self.person.addresses.count > 0{
            if let address1 = self.person.addresses[0].address1{
                address.append(address1)
            }
            if let city = self.person.addresses[0].city{
                address.append(city)
            }
            if let postalCode = self.person.addresses[0].postalCode{
                address.append(postalCode)
            }
        } else {
            address.append("-")
        }
        return address.joined(separator: ",")
    }
    
    var fullName: String{
        return "\(self.person.firstname) \(self.person.surname)"
    }
    
    var age: Int?{
        let age = Date.getAgeFromString(person.dateOfBirth)
        if let age = age {
            return age
        }
        return nil
    }
    
}







