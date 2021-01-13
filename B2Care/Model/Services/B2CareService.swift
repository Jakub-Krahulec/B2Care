//
//  B2CareService.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import Foundation
import Alamofire
import WidgetKit

class B2CareService{
    
    static let shared = B2CareService()
    private let API_URL =  "https://hc-intro-backend.dico.dev05.b2a.cz"
    private var API_KEY = ""
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let defaults = UserDefaults(suiteName: "group.cz.jkrahulec.B2Care")
    
    private var data: UserData?{
        didSet {
            API_KEY = data?.apiKey ?? ""
        }
    }
    
    private init(){
        guard let defaults = defaults else {return}
        if let user = defaults.object(forKey: "user") as? Data {
            if let decoded = try? decoder.decode(UserData.self, from: user){
                data = decoded
                API_KEY = decoded.apiKey
                WidgetCenter.shared.reloadAllTimelines()
                return
            }
        }
    }
    
    fileprivate func save(){
        guard let defaults = defaults else {return}
        if let encoded = try? encoder.encode(data){
            defaults.setValue(encoded, forKey: "user")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func savePatient(_ data: Patient){
        guard let defaults = defaults else { return }
        if let encoded = try? encoder.encode(data){
            defaults.setValue(encoded, forKey: "patient")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func getLastSelectedPatient() -> Patient? {
        guard let defaults = defaults else {return nil}
        if let patient = defaults.object(forKey: "patient") as? Data {
            if let decoded = try? decoder.decode(Patient.self, from: patient){
                return decoded
            }
        }
        return nil
    }
    
    func logout(){
        guard let defaults = defaults else {return}
        defaults.removeObject(forKey: "user")
        data = nil
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func fetchPatient(id: Int, completion: @escaping (Result<Patient, Error>) -> Void) -> DataRequest{
       return NetworkService.shared.performRequest(from: API_URL + "/hc/api/v1/patient/\(id)", model: PatientResponse.self, apiKey: API_KEY) { (result) in
            switch result{
                case .success(let data):
                    completion(.success(data.data))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchPatients(parameters: String = "",completion: @escaping (Result<PatientsData, Error>) -> Void) -> DataRequest{
        return NetworkService.shared.performRequest(from: API_URL + "/hc/api/v1/patient" + parameters, model: PatientsResponse.self, apiKey: API_KEY) { (result) in
            switch result{
                case .success(let data):
                    completion(.success(data.data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getUserData() -> UserData? {
        return data
    }
    
    func login(userName: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void){
        let url = API_URL + "/user/api/v1/auth"
        
        let params: Parameters = [
            "email" : userName,
            "password" : password
        ]
        
        let _ = NetworkService.shared.performRequest(from: url, model: UserResponse.self, method: HTTPMethod.post, parameters: params) { [weak self] (result) in
            guard let this = self else {return}
            switch result{
                case .success(let data):
                    do{
                        this.data = data.data
                        this.save()
                        WidgetCenter.shared.reloadAllTimelines()
                        completion(.success(true))
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
