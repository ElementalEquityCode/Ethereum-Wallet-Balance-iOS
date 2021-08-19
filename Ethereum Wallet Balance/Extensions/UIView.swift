//
//  UIView.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import UIKit

extension UIView {
    
    func anchor(topAnchor: NSLayoutYAxisAnchor?, trailingAnchor: NSLayoutXAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, leadingAnchor: NSLayoutXAxisAnchor?, topPadding: CGFloat, trailingPadding: CGFloat, bottomPadding: CGFloat, leadingPadding: CGFloat, height: CGFloat, width: CGFloat) {
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topPadding).isActive = true
        }
        
        if let rightAnchor = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: rightAnchor, constant: -trailingPadding).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding).isActive = true
        }
        
        if let leftAnchor = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leftAnchor, constant: leadingPadding).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    static func makeBorderView() -> UIView {
        let view = UIView()
        view.backgroundColor = .borderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        return view
    }
    
}
