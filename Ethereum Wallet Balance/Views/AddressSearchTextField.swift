//
//  AddressSearchTextField.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import UIKit

class AddressSearchTextField: UITextField {
    
    // MARK: - Properties
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 40, dy: 16)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 40, dy: 16)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        attributedPlaceholder = NSAttributedString(string: "Enter an Ethereum Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor])
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075).isActive = true
        
        backgroundColor = .primaryViewBackgroundColor
        textColor = .primaryTextFieldTextColor
        
        layer.cornerRadius = viewCornerRadius
        
        let leftViewContainerView = UIView()
        leftViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftViewImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
        leftViewImageView.translatesAutoresizingMaskIntoConstraints = false
        leftViewImageView.tintColor = .primaryTextFieldTextColor
        
        leftViewContainerView.addSubview(leftViewImageView)
        leftViewImageView.anchor(topAnchor: leftViewContainerView.topAnchor, trailingAnchor: leftViewContainerView.trailingAnchor, bottomAnchor: leftViewContainerView.bottomAnchor, leadingAnchor: leftViewContainerView.leadingAnchor, topPadding: 5, trailingPadding: 10, bottomPadding: 5, leadingPadding: 10, height: 0, width: 0)
        
        leftView = leftViewContainerView
        leftViewMode = .always
    }
    
}
