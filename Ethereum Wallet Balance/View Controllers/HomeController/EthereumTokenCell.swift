//
//  EthereumTokenCell.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/15/21.
//

import UIKit

class EthereumTokenCell: UICollectionViewCell {
    
    // MARK: - Properties
        
    var coin: EthereumToken? {
        didSet {
            if let coin = self.coin {
                if let image = coin.logo {
                    coinLogoImageView.image = image
                }
                
                let attributedString1 = NSAttributedString(string: "\(formatDoubleToTwoDecimalPlaces(value: coin.coinBalance)) ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5, weight: .medium)])
                let attributedString2  = NSAttributedString(string: "\(coin.ticker)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5, weight: .light)])
                let array = NSMutableAttributedString()
                array.append(attributedString1)
                array.append(attributedString2)
                
                balanceValueLabel.attributedText = array
                tokenValueLabel.text = "$\(formatDoubleToTwoDecimalPlaces(value: coin.usdBalance))"
            }
        }
    }
    
    private let coinLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headerLabels = UIStackView.makeHorizontalStackView(with: [balanceLabel, valueLabel], distribution: .equalSpacing, spacing: 5)
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        label.textColor = .primaryTextColor
        label.text = "Balance"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        label.textColor = .primaryTextColor
        label.text = "Value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var footerLabels = UIStackView.makeHorizontalStackView(with: [balanceValueLabel, tokenValueLabel], distribution: .equalSpacing, spacing: 5)
    
    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .light)
        label.textColor = .placeholderTextColor
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tokenValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .light)
        label.textColor = .placeholderTextColor
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView = UIView.makeBorderView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        balanceValueLabel.attributedText = NSAttributedString()
        tokenValueLabel.text = ""
        coinLogoImageView.image = nil
        layer.cornerRadius = 0
        borderView.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .primaryViewBackgroundColor
    }
    
    private func setupSubviews() {
        addSubview(coinLogoImageView)
        addSubview(headerLabels)
        addSubview(footerLabels)
        
        coinLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        coinLogoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        coinLogoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        coinLogoImageView.layoutIfNeeded()
        coinLogoImageView.widthAnchor.constraint(equalToConstant: coinLogoImageView.frame.height).isActive = true
        coinLogoImageView.layer.cornerRadius = coinLogoImageView.frame.height / 2
        
        headerLabels.anchor(topAnchor: topAnchor, trailingAnchor: trailingAnchor, bottomAnchor: centerYAnchor, leadingAnchor: coinLogoImageView.trailingAnchor, topPadding: 12, trailingPadding: 12, bottomPadding: 12, leadingPadding: 12, height: 0, width: 0)
        
        footerLabels.anchor(topAnchor: centerYAnchor, trailingAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leadingAnchor: coinLogoImageView.trailingAnchor, topPadding: 12, trailingPadding: 12, bottomPadding: 12, leadingPadding: 12, height: 0, width: 0)
    }
    
    func setupTopCornerRadius() {
        layer.cornerRadius = viewCornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupBottomCornerRadius() {
        layer.cornerRadius = viewCornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupBorderView() {
        addSubview(borderView)
        borderView.anchor(topAnchor: nil, trailingAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 0, height: 0, width: 0)
    }
    
}
