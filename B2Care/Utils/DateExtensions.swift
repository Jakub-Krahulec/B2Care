//
//  DateExtension.swift
//  B2Care
//
//  Created by Jakub Krahulec on 12.01.2021.
//

import Foundation

extension Date{
    
    static var dateformater = DateFormatter()
    
    public static func getAgeFromString(_ stringDate: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ") -> Int? {
        Date.dateformater.dateFormat = format
        let date = Date.dateformater.date(from: stringDate)
        
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
    
    public static func getDateFromString(_ stringDate: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ") -> Date? {
        Date.dateformater.dateFormat = format
        return Date.dateformater.date(from: stringDate)
    }
    
    public static func getFormattedString(from date: Date, format: String = "dd.MM.yyyy 'v' HH:mm") -> String {
        Date.dateformater.dateFormat = format
        return Date.dateformater.string(from: date)
    }
}
