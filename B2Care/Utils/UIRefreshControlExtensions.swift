//
//  UIRefreshControlExtensions.swift
//  B2Care
//
//  Created by Jakub Krahulec on 20.01.2021.
//

import UIKit

extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
