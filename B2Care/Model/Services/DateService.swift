//
//  DateService.swift
//  B2Care
//
//  Created by Jakub Krahulec on 23.12.2020.
//

import Foundation

class DateService{
    
    static let shared = DateService()
    let dateformater = DateFormatter()
    private init(){}
    
    
    public func getAgeFromString(_ stringDate: String) -> Int? {
        dateformater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        let date = dateformater.date(from: stringDate)
        
        if let date = date{
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: date)
            let date2 = calendar.date(from: components)
            let now = Date()
            if let date2 = date2{
                let ageComponents = calendar.dateComponents([.year], from: date2, to: now)
                let age = ageComponents.year
                return age
            }        
        }
        return nil
    }
    
    public func getDateFromString(_ stringDate: String) -> Date? {
        dateformater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        return dateformater.date(from: stringDate)
    }
    
    public func getFormattedString(from date: Date) -> String {
        dateformater.dateFormat = "dd.MM.yyyy 'v' HH:mm"
        return dateformater.string(from: date)
    }
}
