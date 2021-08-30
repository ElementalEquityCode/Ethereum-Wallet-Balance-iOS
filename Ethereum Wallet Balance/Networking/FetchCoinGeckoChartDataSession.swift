//
//  FetchCoinGeckoChartDataSession.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

class FetchCoinGeckoChartDataSession {
    
    weak var delegate: FetchCoinGeckoMarketDataDelegate?
    
    let session = URLSession(configuration: .ephemeral)
    
    private let coinID: String
    
    init(coinID: String) {
        self.coinID = coinID
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
                
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("FetchCoinGeckoChartDataSession: \(error.localizedDescription)")
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
                            case .daily: self.delegate?.didFetchDailyChartData(data: chartPoints)
                            case .weekly: self.delegate?.didFetchWeeklyChartData(data: chartPoints)
                            case .monthly: self.delegate?.didFetchMonthlyChartData(data: chartPoints)
                            }
                        }
                    }
                } catch let error {
                    checkForCoinGeckoRateLimitError(data: data)
                    print("FetchCoinGeckoChartDataSession JSONDecoder: \(error.localizedDescription)")
                }
            }
        }.resume()
        
        session.finishTasksAndInvalidate()
    }
    
}

enum TimeFrame: Int {
    case daily
    case weekly
    case monthly
}
