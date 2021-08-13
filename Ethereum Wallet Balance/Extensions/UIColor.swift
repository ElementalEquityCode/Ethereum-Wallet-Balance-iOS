//
//  UIColor.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import UIKit

extension UIColor {
    
    static let primaryColor = UIColor(red: 104/255, green: 142/255, blue: 255/255, alpha: 1)
    
    static let primaryBackgroundColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 244/255, green: 245/255, blue: 247/255, alpha: 1) : UIColor(red: 23/255, green: 28/255, blue: 36/255, alpha: 1)
    }
    
    static let primaryViewBackgroundColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor(red: 34/255, green: 43/255, blue: 54/255, alpha: 1)
    }
    
    static let primaryTextFieldTextColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 23/255, green: 43/255, blue: 77/255, alpha: 1) : UIColor.white
    }
    
    static let placeholderTextColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 107/255, green: 119/255, blue: 140/255, alpha: 1) : UIColor(red: 145/255, green: 158/255, blue: 171/255, alpha: 1)
    }
    
}
