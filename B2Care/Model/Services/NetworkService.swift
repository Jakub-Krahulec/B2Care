//
//  NetworkService.swift
//  B2Care
//
//  Created by Jakub Krahulec on 22.12.2020.
//

import Foundation
import Alamofire

var imageCache = NSCache<NSString, UIImage>()

class NetworkService{
    
    static let shared = NetworkService()
    private init(){}
    
    func performRequest<T: Decodable>(from url: String, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> DataRequest{
        let request = AF.request(url)
            .validate()
            .responseDecodable(of: model, queue: .main, decoder: JSONDecoder()) { (response) in
                switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        return request
    }
    
    func performRequest<T: Decodable>(from url: String, model: T.Type, apiKey: String, completion: @escaping (Result<T, Error>) -> Void) -> DataRequest{
        let headers = HTTPHeaders([
            "Authorization": "Token token=\"\(apiKey)\"",
        ])
        let request = AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                    
                    case .success(_):
                        do{
                            if let data = response.data{
                                let decoded = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(decoded))
                            }
                        } catch{
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        return request
    }

    func getImageFromURL(_ url: String, progressChanged: @escaping (Double) -> Void ,completion: @escaping (Result<UIImage?, Error>) -> Void) -> DownloadRequest?{
        
        if let image = imageCache.object(forKey: url as NSString) {
            completion(.success(image))
            return nil
            // print("\(url): Z CACHE")
        } else {
            let request = AF.download(url)
                .downloadProgress {(progress) in
                    progressChanged(progress.fractionCompleted)
                }
                .responseData {
                    response in
                    switch response.result {
                        case .success(let data):
                            let image = UIImage(data: data)
                            completion(.success(image))
                            if let image = image {
                                imageCache.setObject(image, forKey: url as NSString)
                            }
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            return request
        }
    }
}
