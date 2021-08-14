//
//  Models.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import UIKit

class Coin: Codable {
    
    var ticker: String
    var price: Double
    var coinBalance: Double
    var usdBalance: Double
    var logoUrl: String
    var percentOfTotalPortfolio: Double = 0.0
    var logo: UIImage?

    var description: String {
        return "Ticker: \(ticker) -- Price: \(price) -- Coin Balance: \(coinBalance) -- USD Balance: \(usdBalance) -- % of Portfolio: \(percentOfTotalPortfolio)"
    }
    
    enum CodingKeys: String, CodingKey {
        case ticker="label"
        case price
        case coinBalance="balance"
        case usdBalance="balanceUSD"
        case logoUrl="img"
    }
    
    init(ticker: String, price: Double, coinBalance: Double, usdBalance: Double, logoUrl: String, percentOfTotalPortfolio: Double) {
        self.ticker = ticker
        self.price = price
        self.coinBalance = coinBalance
        self.usdBalance = usdBalance
        self.logoUrl = logoUrl
        self.percentOfTotalPortfolio = percentOfTotalPortfolio
        FetchCoinLogoSession(coin: self).getLogoImage()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.ticker = try container.decode(String.self, forKey: CodingKeys.ticker)
        self.price = try container.decode(Double.self, forKey: CodingKeys.price)
        self.coinBalance = try container.decode(Double.self, forKey: CodingKeys.coinBalance)
        self.usdBalance = try container.decode(Double.self, forKey: CodingKeys.usdBalance)
        self.logoUrl = try container.decode(String.self, forKey: CodingKeys.logoUrl)
        FetchCoinLogoSession(coin: self).getLogoImage()
    }
        
}
