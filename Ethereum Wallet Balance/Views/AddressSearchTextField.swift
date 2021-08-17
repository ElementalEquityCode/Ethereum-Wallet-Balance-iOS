//
//  AddressSearchTextField.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import UIKit

class AddressSearchTextField: UITextField {
    
    // MARK: - Properties
    
    let activateCameraBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "camera.fill"), style: .plain, target: nil, action: nil)
        barButtonItem.tintColor = .primaryColor
        return barButtonItem
    }()
    
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
        setupToolBar()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
        layer.shadowOffset = CGSize(width: 1, height: 2)
        
        attributedPlaceholder = NSAttributedString(string: "Enter an Ethereum Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor])
        smartInsertDeleteType = .no
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075).isActive = true
        
        backgroundColor = .primaryViewBackgroundColor
        textColor = .primaryTextColor
        
        layer.cornerRadius = viewCornerRadius
        
        let leftViewContainerView = UIView()
        leftViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftViewImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
        leftViewImageView.translatesAutoresizingMaskIntoConstraints = false
        leftViewImageView.tintColor = .primaryTextColor
        
        leftViewContainerView.addSubview(leftViewImageView)
        leftViewImageView.anchor(topAnchor: leftViewContainerView.topAnchor, trailingAnchor: leftViewContainerView.trailingAnchor, bottomAnchor: leftViewContainerView.bottomAnchor, leadingAnchor: leftViewContainerView.leadingAnchor, topPadding: 5, trailingPadding: 10, bottomPadding: 5, leadingPadding: 10, height: 0, width: 0)
        
        leftView = leftViewContainerView
        leftViewMode = .always

        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        inputAccessoryView = toolBar
        toolBar.sizeToFit()
        
        toolBar.items = [activateCameraBarButtonItem]
    }
    
    private func setupTargets() {
        addTarget(self, action: #selector(performImpactFeedbackGenerator), for: .editingDidBegin)
    }
    
    // MARK: - Targets
    
    @objc private func performImpactFeedbackGenerator() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    // MARK: - TraitCollection
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            traitCollection.performAsCurrent {
                self.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
            }
        }
    }
    
}
