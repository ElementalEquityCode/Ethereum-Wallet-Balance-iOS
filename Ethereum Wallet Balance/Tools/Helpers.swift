//
//  Helpers.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import CoreGraphics
import Foundation

let viewCornerRadius: CGFloat = 16

func formatDoubleToTwoDecimalPlaces(value: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 2
    return numberFormatter.string(from: NSNumber(value: value)) ?? ""
}

func checkForCoinGeckoRateLimitError(data: Data?) {
    if let data = data {
        if let string = String(data: data, encoding: .utf8) {
            if string.contains("has banned you temporarily from accessing this website") {
                NotificationCenter.default.post(Notification.init(name: Notification.Name("apiCallLimitError")))
            }
        }
    }
}
