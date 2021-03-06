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
    
    func performRequest<T: Decodable>(from url: String,
                                      model: T.Type,
                                      apiKey: String? = nil,
                                      method: HTTPMethod = .get,
                                      parameters: Parameters? = nil,
                                      completion: @escaping (Result<T, Error>) -> Void) -> DataRequest{
        
        var headers: HTTPHeaders? = nil
        
        if let API_KEY = apiKey{
            headers = HTTPHeaders([
                "Authorization": "Token token=\"\(API_KEY)\"",
            ])
        }
        
        let request = AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func downloadFile(from url: String, progressChanged: @escaping (Double) -> Void, completion: @escaping (Result<Data, Error>) -> Void) -> DownloadRequest{
        let request  = AF.download(url)
            .validate()
            .downloadProgress{(progress) in
                progressChanged(progress.fractionCompleted)
            }
            .responseData { (response) in
                switch response.result{
                    case .success(let data):
                        completion(.success(data))
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
