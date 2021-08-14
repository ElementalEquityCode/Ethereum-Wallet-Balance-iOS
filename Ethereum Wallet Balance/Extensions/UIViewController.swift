//
//  UIViewController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/13/21.
//

import UIKit

extension UIViewController {
    
    func presentAlertViewController(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
            if let completion = completion {
                completion()
            }
        }))
        present(alertController, animated: true)
    }
    
}
