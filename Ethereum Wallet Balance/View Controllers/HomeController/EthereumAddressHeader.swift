//
//  EthereumAddressHeader.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/15/21.
//

import UIKit

class EthereumAddressHeader: UICollectionViewCell {
    
    // MARK: - Properties
    
    var ethereumAddress: String = "" {
        didSet {
            ethereumAddressValueLabel.text = ethereumAddress
        }
    }
    
    var etherBalance: Double = 0.0 {
        didSet {
            etherBalanceValueLabel.text = "\(formatDoubleToTwoDecimalPlaces(value: etherBalance))"
        }
    }
    
    var erc20Tokens: Int = 0 {
        didSet {
            erc20TokensCountValueLabel.text = "\(erc20Tokens)"
        }
    }
    
    var addressValue: Double = 0.0 {
        didSet {
            addressValueLabel.text = "$\(formatDoubleToTwoDecimalPlaces(value: addressValue))"
        }
    }
    
    private let ethereumAddressLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ETH ADDRESS", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ethereumAddressValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView1 = UIView.createBorderView()
        
    private let etherBalanceLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ETHER BALANCE", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let etherBalanceValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView2 = UIView.createBorderView()
        
    private let erc20TokensCountLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ERC-20 TOKENS", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let erc20TokensCountValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let borderView3 = UIView.createBorderView()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ADDRESS VALUE", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .primaryViewBackgroundColor
        layer.cornerRadius = viewCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
        layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    private func setupSubviews() {
        addSubview(borderView1)
        addSubview(borderView2)
        addSubview(borderView3)
        addSubview(ethereumAddressLabel)
        addSubview(ethereumAddressValueLabel)
        addSubview(etherBalanceLabel)
        addSubview(etherBalanceValueLabel)
        addSubview(erc20TokensCountLabel)
        addSubview(erc20TokensCountValueLabel)
        addSubview(addressLabel)
        addSubview(addressValueLabel)
        
        borderView1.bottomAnchor.constraint(equalTo: topAnchor, constant: frame.height * (1/4)).isActive = true
        borderView1.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        borderView1.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        borderView2.bottomAnchor.constraint(equalTo: topAnchor, constant: frame.height * (2/4)).isActive = true
        borderView2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        borderView2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        borderView3.bottomAnchor.constraint(equalTo: topAnchor, constant: frame.height * (3/4)).isActive = true
        borderView3.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        borderView3.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        ethereumAddressLabel.anchor(topAnchor: topAnchor, trailingAnchor: centerXAnchor, bottomAnchor: borderView1.topAnchor, leadingAnchor: leadingAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        ethereumAddressValueLabel.anchor(topAnchor: topAnchor, trailingAnchor: trailingAnchor, bottomAnchor: borderView1.topAnchor, leadingAnchor: centerXAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        
        etherBalanceLabel.anchor(topAnchor: borderView1.bottomAnchor, trailingAnchor: centerXAnchor, bottomAnchor: borderView2.topAnchor, leadingAnchor: leadingAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        etherBalanceValueLabel.anchor(topAnchor: borderView1.bottomAnchor, trailingAnchor: trailingAnchor, bottomAnchor: borderView2.topAnchor, leadingAnchor: centerXAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        
        erc20TokensCountLabel.anchor(topAnchor: borderView2.bottomAnchor, trailingAnchor: centerXAnchor, bottomAnchor: borderView3.topAnchor, leadingAnchor: leadingAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        erc20TokensCountValueLabel.anchor(topAnchor: borderView2.bottomAnchor, trailingAnchor: trailingAnchor, bottomAnchor: borderView3.topAnchor, leadingAnchor: centerXAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        
        addressLabel.anchor(topAnchor: borderView3.bottomAnchor, trailingAnchor: centerXAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        addressValueLabel.anchor(topAnchor: borderView3.bottomAnchor, trailingAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leadingAnchor: centerXAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
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
