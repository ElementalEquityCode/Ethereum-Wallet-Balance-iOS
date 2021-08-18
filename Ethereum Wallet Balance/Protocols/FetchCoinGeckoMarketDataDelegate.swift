//
//  FetchCoinGeckoDailyAssetChangeDelegate.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

protocol FetchCoinGeckoMarketDataDelegate: AnyObject {
    
    func didFetchDailyChangePercentage(amount: Double)
    func didFetchChartData(data: [ChartPoint])
    
}
