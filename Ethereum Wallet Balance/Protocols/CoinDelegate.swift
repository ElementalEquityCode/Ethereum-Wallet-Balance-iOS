//
//  CoinDelegate.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import Foundation

protocol CoinDelegate: AnyObject {
    
    func didAddCoin(coin: Coin)
    
}
