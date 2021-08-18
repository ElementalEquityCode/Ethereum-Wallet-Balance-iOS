//
//  FetchCoinGeckoDailyAssetChangeDelegate.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

protocol FetchCoinGeckoDailyAssetChangeDelegate: AnyObject {
    
    func didFetchDailyChangePercentage(amount: Double)
    
}
