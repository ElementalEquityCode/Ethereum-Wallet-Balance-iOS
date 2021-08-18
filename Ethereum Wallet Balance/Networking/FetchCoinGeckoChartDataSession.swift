//
//  FetchCoinGeckoChartDataSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

class FetchCoinGeckoChartDataSession {
    
    private unowned let delegate: FetchCoinGeckoMarketDataDelegate
    
    private let coinID: String
    
    init(coinID: String, delegate: FetchCoinGeckoMarketDataDelegate) {
        self.coinID = coinID
        self.delegate = delegate
    }
    
    private lazy var endPoint = "https://api.coingecko.com/api/v3/coins/\(coinID)/market_chart?vs_currency=usd&days=30&interval=daily"
    
    func getChartData() {
        guard let url = URL(string: endPoint) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                        if let priceData = json["prices"] as? NSArray {
                            var chartPoints = [ChartPoint]()
                            
                            for chartPoint in priceData {
                                if let chartPointArray = chartPoint as? NSArray {
                                    guard let timestamp = chartPointArray[0] as? TimeInterval, let value = chartPointArray[1] as? Double else { return }
                                    chartPoints.append(ChartPoint(timestamp: timestamp, value: value))
                                }
                            }
                            
                            self.delegate.didFetchChartData(data: chartPoints)
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
