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
        getUpdatedDateString()
    }
    
    var allergiesString: String {
        getAlergiesString()
    }
    
    var medications: String {
        getMedicationsString()
    }
    
    var fullAddress: String {
        getFullAddress()
    }
    
    var fullName: String{
        return "\(self.person.firstname) \(self.person.surname)"
    }
    
    private func getUpdatedDateString() -> String {
        let updatedDate = DateService.shared.getDateFromString(self.updated ?? self.created ?? "")
        var updated = ""
        if let updatedDate = updatedDate{
            updated = DateService.shared.getFormattedString(from: updatedDate)
        }
        return updated
    }
    
    private func getFullAddress() -> String {
        var address = ""
        if self.person.addresses.count > 0{
            if let address1 = self.person.addresses[0].address1{
                address += address1 + ", "
            }
            if let city = self.person.addresses[0].city{
                address += city
            }
        } else {
            address = "-"
        }
        return address
    }
    
    private func getMedicationsString() -> String {
        var medications = ""
        for medication in self.medicationDispenses{
            medications += medication.medication.title + "\n"
            //  medications += medication.medication.title.trimmingCharacters(in: .whitespaces) + "\n"
        }
        medications = String(medications.dropLast(2))
        
        return medications
    }
    
    private func getAlergiesString() -> String{
        var allergies = ""
        for alergy in self.allergies{
            allergies += alergy.code.title + "\n"
        }
        allergies = String(allergies.dropLast(2))
        return allergies
    }
}







