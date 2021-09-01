//
//  FetchCoinLogoSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import UIKit

class FetchCoinLogoSession {
    
    private unowned let delegate: FetchCoinLogoDelegate
        
    private let assetUrl: String
    
    let session = URLSession(configuration: .ephemeral)
            
    init(coin: CDEthereumToken, delegate: FetchCoinLogoDelegate) {
        self.assetUrl = coin.logoUrl ?? ""
        self.delegate = delegate
    }
    
    func getLogoImage() {
        guard let url = URL(string: assetUrl) else { return }
                
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let urlResponse = response! as? HTTPURLResponse {
                    if urlResponse.statusCode == 404 {
                        self.delegate.didFetchLogo(image: UIImage(named: "eth"))
                    } else {
                        if let imageData = data {
                            if let image = UIImage(data: imageData) {
                                self.delegate.didFetchLogo(image: image)
                            }
                        }
                    }
                }
            }
        }.resume()
        
        session.finishTasksAndInvalidate()
    }
    
}
