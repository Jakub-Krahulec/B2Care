//
//  B2CareService.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import Foundation
import Alamofire

class B2CareService{
    
    static let shared = B2CareService()
    private let API_URL =  "https://hc-intro-backend.dico.dev05.b2a.cz"
    private var data: UserData?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let defaults = UserDefaults.standard
    private init(){
        if let user = defaults.object(forKey: "user") as? Data {
            if let decoded = try? decoder.decode(UserData.self, from: user){
                data = decoded
                return
            }
        }
    }
    
    fileprivate func save(){
        if let encoded = try? encoder.encode(data){
            defaults.setValue(encoded, forKey: "user")
        }
    }
    
    func fetchPatients(completion: @escaping (Result<PatientsData, Error>) -> Void){
        let patients = NetworkService.shared.performRequest(from: API_URL + "/hc/api/v1/patient", model: PatientsResponse.self, apiKey: "nzgnM6pLsmdCCKc7Zv7ctEPVc37pYkZ2XO9pX8stfuscOhvbiX1b20H9wGOu01MS") { (result) in
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
        guard let url = URL(string: API_URL + "/user/api/v1/auth") else { return}
        let params: NSMutableDictionary? = [
            "email" : userName,
            "password" : password
        ]
        var data: Data?
        do{
            data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) //JSONEncoder().encode("{ \"email\": \"staze@b2a.cz\", \"password\":\"eat.sleep.b2a.repeat\" }")
        } catch {
            completion(.failure(error))
        }
        guard let body = data else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        AF.request(request as URLRequestConvertible)
            .validate()
            .responseString { response in
                switch  response.result{
                    case .success(let data):
                        var userData: UserResponse?
                        do{
                            userData = try JSONDecoder().decode(UserResponse.self, from: Data(data.utf8))
                            if let user = userData{
                                self.data = user.data
                                completion(.success(true))
                            }
                        } catch{
                            completion(.failure(error))
                            return
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            } 
    }
    
}

// nzgnM6pLsmdCCKc7Zv7ctEPVc37pYkZ2XO9pX8stfuscOhvbiX1b20H9wGOu01MS
//  https://hc-intro-backend.dico.dev05.b2a.cz/user/api/v1/auth

// { "email": "staze@b2a.cz", "password":"eat.sleep.b2a.repeat" }
