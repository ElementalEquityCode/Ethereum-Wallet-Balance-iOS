//
//  FetchCoinGeckoAssetIDSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

class FetchCoinGeckoAssetIDSession {
    
    weak var delegate: FetchCoinGeckoCoinIdDelegate?
    
    let session = URLSession(configuration: .ephemeral)
    
    func getID(for ticker: String) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/list") else { return }
                
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("FetchCoinGeckoAssetIDSession: \(error.localizedDescription)")
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? NSArray {
                        for coin in json {
                            if let coinJSON = coin as? [String: Any] {
                                if let coinSymbol = coinJSON["symbol"] as? String {
                                    if coinSymbol == ticker.lowercased() {
                                        if let coinID = coinJSON["id"] as? String {
                                            self.delegate?.didFetchID(string: coinID)
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch let error {
                    print("FetchCoinGeckoAssetIDSession JSONDecoder: \(error.localizedDescription)")
                }
            }
        }.resume()
        
        session.finishTasksAndInvalidate()
    }
    
}
