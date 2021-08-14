//
//  FetchCoinLogoSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import UIKit

class FetchCoinLogoSession {
    
    private unowned let coin: Coin
    
    private let baseUrl: String = "https://zapper.fi/images/"
    
    private let logoUrl: String
    
    private lazy var endPoint = baseUrl + logoUrl
    
    private var logo: UIImage? {
        didSet {
            if logo != nil {
                coin.logo = logo
            }
        }
    }
    
    init(coin: Coin) {
        self.coin = coin
        self.logoUrl = coin.logoUrl
    }
    
    func getLogoImage() {
        guard let url = URL(string: endPoint) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.logo = image
                    }
                }
            }
        }.resume()
    }
    
}
