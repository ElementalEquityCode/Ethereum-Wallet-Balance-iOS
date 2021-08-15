//
//  SearchForAddressSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import UIKit

class SearchForAddressSession {
    
    private unowned let delegate: EthereumAddressDelegate
    
    private let address: String
    
    private let apiKey = "96e0cc51-a62e-42ca-acee-910ea7d2a241"
    
    private lazy var endPoint = "https://api.zapper.fi/v1/protocols/tokens/balances?addresses[]=\(address)&api_key=\(apiKey)"
    
    init(address: String, delegate: EthereumAddressDelegate) {
        self.address = address
        self.delegate = delegate
    }
    
    func getCoinBalances(completion: @escaping () -> Void) {
        guard let url = URL(string: endPoint) else { return }
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else { return }
                    
                    if let address = json[json.keys.first!] as? [String: Any], let addressString = json.keys.first {
                        
                        let ethereumAddress = EthereumAddress(address: addressString)
                        ethereumAddress.addressValue = self.getPortfolioValue(address)
                                                
                        if let products = address["products"] as? NSArray {
                            for item in products {
                                if let dictionary = item as? [String: Any] {
                                    if let assets = dictionary["assets"] as? [[String: Any]] {
                                        for asset in assets {
                                            do {
                                                let coinData = try JSONSerialization.data(withJSONObject: asset)
                                                
                                                let coin = try decoder.decode(EthereumToken.self, from: coinData)
                                                
                                                if ethereumAddress.addressValue != nil {
                                                    coin.percentOfTotalPortfolio = coin.usdBalance / ethereumAddress.addressValue!
                                                }
                                                
                                                if coin.ticker == "ETH" {
                                                    ethereumAddress.etherBalance = coin.coinBalance
                                                }
                                                
                                                ethereumAddress.coins.append(coin)
                                            } catch let error {
                                                print(error.localizedDescription)
                                            }
                                        }
                                        self.delegate.didAddEthereumAddress(address: ethereumAddress)
                                        completion()
                                    }
                                }
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func getPortfolioValue(_ address: [String: Any]) -> Double? {
        if let meta = address["meta"] as? NSArray {
            for item in meta {
                if let values = item as? [String: Any] {
                    if values["label"] as? String == "Total" {
                        if let addressTotalValue = values["value"] as? Double {
                            return addressTotalValue
                        }
                    }
                }
            }
        }
        return nil
    }
    
}
