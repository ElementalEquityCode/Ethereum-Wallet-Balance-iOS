//
//  FetchCoinLogoSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import UIKit

class FetchCoinLogoSession {
    
    private unowned let delegate: FetchCoinLogoDelegate
    
    private let coin: EthereumToken
    
    private let baseUrl: String = "https://zapper.fi/images/"
    
    private let logoUrl: String
    
    private lazy var endPoint = baseUrl + logoUrl
    
    init(coin: EthereumToken, delegate: FetchCoinLogoDelegate) {
        self.coin = coin
        self.delegate = delegate
        self.logoUrl = coin.logoUrl
    }
    
    func getLogoImage() {
        guard let url = URL(string: endPoint) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
    }
    
}
