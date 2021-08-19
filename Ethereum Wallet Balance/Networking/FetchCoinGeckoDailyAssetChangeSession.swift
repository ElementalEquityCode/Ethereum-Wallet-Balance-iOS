//
//  FetchCoinGeckoDailyAssetChangeSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

class FetchCoinGeckoDailyAssetChangeSession {
    
    private let delegate: FetchCoinGeckoMarketDataDelegate
    
    init(delegate: FetchCoinGeckoMarketDataDelegate) {
        self.delegate = delegate
    }
    
    private lazy var endPoint = "https://api.coingecko.com/api/v3/coins/"
    
    func getDailyPercentageChange(for coin: String) {
        guard let url = URL(string: endPoint + "/\(coin)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                        if let marketData = json["market_data"] as? [String: Any] {
                            if let dailyChangePercentage = marketData["price_change_percentage_24h"] as? Double {
                                self.delegate.didFetchDailyChangePercentage(amount: dailyChangePercentage)
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
