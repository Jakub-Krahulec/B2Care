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
    internal var dataRequests = Set<DataRequest>()
    internal var downloadRequests = Set<DownloadRequest>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for request in dataRequests{
            if !request.isFinished{
                request.cancel()
            }
        }
        dataRequests.removeAll()
        
        for request in downloadRequests{
            if !request.isFinished{
                request.cancel()
            }
        }
        downloadRequests.removeAll()
    }
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    internal func removeRequests(){
        for request in dataRequests{
            if request.isFinished{
                dataRequests.remove(request)
            }
        }
        
        for request in downloadRequests{
            if request.isFinished{
                downloadRequests.remove(request)
            }
        }
    }
}
