//
//  RequestViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 02.01.2021.
//

import UIKit
import Alamofire

class RequestViewController: UIViewController {

    // MARK: - Properties
    internal var requests = Set<DataRequest>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for request in requests{
            if !request.isFinished{
                request.cancel()
            }
        }
        requests.removeAll()
    }
    
    internal func removeRequests(){
        for request in requests{
            if request.isFinished{
                requests.remove(request)
            }
        }
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers

}
