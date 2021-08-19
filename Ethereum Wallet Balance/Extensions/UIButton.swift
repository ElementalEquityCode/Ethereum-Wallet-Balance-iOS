//
//  UIButton.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/20/21.
//

import UIKit

extension UIButton {
    
    static func makeLineChartViewTimeFrameButton(with string: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(string, for: .normal)
        button.setTitleColor(.placeholderTextColor, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
