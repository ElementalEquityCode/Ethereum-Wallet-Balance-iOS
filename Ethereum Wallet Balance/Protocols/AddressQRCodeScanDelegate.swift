//
//  AddressQRCodeScanDelegate.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/14/21.
//

import Foundation

protocol AddressQRCodeScanDelegate: AnyObject {
    
    func didScanQRCode(value: String)
    
}
