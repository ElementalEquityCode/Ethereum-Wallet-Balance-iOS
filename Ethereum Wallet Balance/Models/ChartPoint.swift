//
//  ChartPoint.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/18/21.
//

import Foundation

class ChartPoint: Decodable {
    
    // MARK: - Properties
    
    let timestamp: TimeInterval
    let value: Double
    
    // MARK: - Initialization
    
    init(timestamp: TimeInterval, value: Double) {
        self.timestamp = timestamp
        self.value = value
    }
    
}
