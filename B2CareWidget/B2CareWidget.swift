
import WidgetKit
import SwiftUI

struct PatientEntry: TimelineEntry{
    var date: Date
    var error: String
    var patient: Patient?
}


struct Provider: TimelineProvider{
    
    func placeholder(in context: Context) -> PatientEntry {
        return PatientEntry(date: Date(), error: "Jakub Krahulec")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PatientEntry) -> Void) {
        let entry = PatientEntry(date: Date(),error: "Jméno pacienta")
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PatientEntry>) -> Void) {
        
        var entry = PatientEntry(date: Date(),error: "")
        
        if let user = B2CareService.shared.fetchUserData() {
            if user.enablePrivacy ?? false{
                entry.error = NSLocalizedString("turn-off-privacy", comment: "")
            } else{
                if let patient = B2CareService.shared.getLastSelectedPatient(){
                    entry.error = ""
                    entry.patient = patient
                } else {
                    entry.error = NSLocalizedString("no-data", comment: "")
                }
            }
        } else {
            entry.error = NSLocalizedString("access-denied", comment: "")
        }
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntryView: View{
    var entry: Provider.Entry
    private var diagnosis: String {
        if let patient = entry.patient {
            return patient.hospitalizations.count > 0 ? patient.hospitalizations[0].diagnosis.value : "N/A"
        }
        return "N/A"
    }
    
    private var hospitalization: String {
        if let patient = entry.patient {
            if patient.hospitalizations.count > 0{
                var location = ""
                if let name = patient.hospitalizations[0].location.name{
                    location += "\(name)"
                }
                if let room = patient.hospitalizations[0].location.room{
                    if location.count > 0 {
                        location += ", "
                    }
                    location += "Pokoj \(room)"
                }
                return location
            }
        }
        return "N/A"
    }
    
    private var age: String{
        if let patient = entry.patient {
            if let age = patient.age {
                return "\(age), \(patient.person.gender.title.first ?? " ")"
            }
            else {
                return "N/A, \(patient.person.gender.title.first ?? " ")"
            }
        }
        return "N/A"
    }
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View{
        VStack(alignment: .leading, spacing: 6, content: {
            switch family {
                case .systemSmall:
                    Text(entry.error)
                case .systemMedium:
                    if entry.error == ""{
                        HStack{
                            Image(systemName: "person.fill")
                            Text(entry.patient?.fullName ?? entry.error)
                                .fontWeight(.heavy)
                            Spacer()
                            Text(age)
                                .fontWeight(.heavy)
                        }
                        Divider()
                        HStack{
                            Image(systemName: "location.fill")
                                .foregroundColor(.green)
                            Text(hospitalization)
                        }
                        HStack{
                            Image(systemName: "bandage")
                                .foregroundColor(.orange)
                            Text(diagnosis)
                        }
                        HStack{
                            Image(systemName: "heart.slash.fill")
                                .foregroundColor(.red)
                            Text(entry.patient?.allergiesString ?? "")
                        }
                        Divider()
                    }
                    else{
                        Text(entry.error)
                    }
                default:
                    Text(entry.error)    
            }
        })
        .padding(.leading,20)
        .padding(.trailing, 20)
        .foregroundColor(.white)
        .multilineTextAlignment(.leading)
        .frame(alignment: .leading)
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
        .supportedFamilies([.systemMedium])
    }
}
