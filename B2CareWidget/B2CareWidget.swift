//
//  B2CareWidget.swift
//  B2CareWidget
//
//  Created by Jakub Krahulec on 12.01.2021.
//

import WidgetKit
import SwiftUI

struct PatientEntry: TimelineEntry{
    var date: Date
    var name: String
    var diagnosis: String
}


struct Provider: TimelineProvider{
    
    func placeholder(in context: Context) -> PatientEntry {
        return PatientEntry(date: Date(), name: "Jakub Krahulec", diagnosis: "Diagnóza")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PatientEntry) -> Void) {
        let entry = PatientEntry(date: Date(),name: "Jméno pacienta", diagnosis: "Diagnóza")
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PatientEntry>) -> Void) {
        
        var entry = PatientEntry(date: Date(),name: "", diagnosis: "")
        
        if let _ = B2CareService.shared.getUserData() {
            if let patient = B2CareService.shared.getLastSelectedPatient(){
                entry.name = patient.fullName
            } else {
                entry.name = "Žádná data"
            }
        } else {
            entry.name = "Přístup odepřen"
        }
        
        
                
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntryView: View{
    let entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View{
        switch family {
            case .systemSmall:
                Text(entry.name)
            case .systemMedium:
                Text(entry.name)
            default:
                VStack {
                    Text(entry.name)
                }
        }
        
    }
}

@main
struct B2CareWidget: Widget {
    private let kind = "B2CareWidget"
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.mainColor))
        }
        .supportedFamilies([.systemLarge])
    }
}
