//
//  EthereumAddress.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/15/21.
//

import UIKit

class EthereumAddress {
    
    let address: String
    var etherBalance: Double = 0
    var addressValue: Double?
    var coins = [EthereumToken]()
    
    init(address: String) {
        self.address = address
    }
    
}
