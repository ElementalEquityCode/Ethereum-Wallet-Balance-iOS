//
//  UIRefreshControl.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/31/21.
//

import UIKit

extension UIRefreshControl {
    
    static func makeRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        return refreshControl
    }
    
}
