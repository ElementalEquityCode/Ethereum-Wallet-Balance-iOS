//
//  FetchCoinGeckoChartDataSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

class FetchCoinGeckoChartDataSession {
    
    private let delegate: FetchCoinGeckoMarketDataDelegate
    
    private let coinID: String
    
    init(coinID: String, delegate: FetchCoinGeckoMarketDataDelegate) {
        self.coinID = coinID
        self.delegate = delegate
    }
        
    func getChartData(for timeFrame: TimeFrame) {
        var amountOfDays: Int!
        
        switch timeFrame {
        case .daily:
            amountOfDays = 1
        case .weekly:
            amountOfDays = 7
        case .monthly:
            amountOfDays = 30
        }
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinID.lowercased())/market_chart?vs_currency=usd&days=\(amountOfDays!)&interval=hourly") else { return }
        
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
                            switch timeFrame {
                            case .daily: self.delegate.didFetchDailyChartData(data: chartPoints)
                            case .weekly: self.delegate.didFetchWeeklyChartData(data: chartPoints)
                            case .monthly: self.delegate.didFetchMonthlyChartData(data: chartPoints)
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

enum TimeFrame: Int {
    case daily
    case weekly
    case monthly
}
