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
