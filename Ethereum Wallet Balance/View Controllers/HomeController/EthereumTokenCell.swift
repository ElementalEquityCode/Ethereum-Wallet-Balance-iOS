//
//  EthereumTokenCell.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/15/21.
//

import UIKit

class EthereumTokenCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var hasCellBeenPreviouslyDisplayed = false
    
    var coin: EthereumToken? {
        didSet {
            if let coin = self.coin {
                if let image = coin.logo {
                    coinLogoImageView.image = image
                }
                
                let attributedString1 = NSAttributedString(string: "\(formatDoubleToTwoDecimalPlaces(value: coin.usdBalance)) ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5, weight: .medium)])
                let attributedString2  = NSAttributedString(string: "\(coin.ticker)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5, weight: .light)])
                let array = NSMutableAttributedString()
                array.append(attributedString1)
                array.append(attributedString2)
                
                balanceValueLabel.attributedText = array
                tokenValueLabel.text = "$\(formatDoubleToTwoDecimalPlaces(value: coin.usdBalance))"
                performCircleShapeLayerStrokeEndAnimation(to: CGFloat(coin.percentOfTotalPortfolio))
            }
        }
    }
    
    private let coinLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let CAShapeLayerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabels = UIStackView.makeHorizontalStackView(with: [balanceLabel, valueLabel], distribution: .equalSpacing, spacing: 5)
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        label.textColor = .primaryTextFieldTextColor
        label.text = "Balance"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        label.textColor = .primaryTextFieldTextColor
        label.text = "Value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let circleLayer = CAShapeLayer()
    let bottomCAShapeLayer = CAShapeLayer()

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
    
    private let borderView = UIView.createBorderView()
    
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
        bottomCAShapeLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCAShapeLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .primaryViewBackgroundColor
    }
    
    private func setupSubviews() {
        addSubview(coinLogoImageView)
        addSubview(CAShapeLayerContainerView)
        addSubview(headerLabels)
        addSubview(footerLabels)
        
        coinLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        coinLogoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        coinLogoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        coinLogoImageView.layoutIfNeeded()
        coinLogoImageView.widthAnchor.constraint(equalToConstant: coinLogoImageView.frame.height).isActive = true
        coinLogoImageView.layer.cornerRadius = coinLogoImageView.frame.height / 2
        
        CAShapeLayerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        CAShapeLayerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        CAShapeLayerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        CAShapeLayerContainerView.layoutIfNeeded()
        CAShapeLayerContainerView.widthAnchor.constraint(equalToConstant: CAShapeLayerContainerView.frame.height).isActive = true
        CAShapeLayerContainerView.layer.cornerRadius = CAShapeLayerContainerView.frame.height / 2
        CAShapeLayerContainerView.layoutIfNeeded()
        
        headerLabels.anchor(topAnchor: topAnchor, trailingAnchor: CAShapeLayerContainerView.leadingAnchor, bottomAnchor: centerYAnchor, leadingAnchor: coinLogoImageView.trailingAnchor, topPadding: 12, trailingPadding: 24, bottomPadding: 12, leadingPadding: 24, height: 0, width: 0)
        
        footerLabels.anchor(topAnchor: centerYAnchor, trailingAnchor: CAShapeLayerContainerView.leadingAnchor, bottomAnchor: bottomAnchor, leadingAnchor: coinLogoImageView.trailingAnchor, topPadding: 12, trailingPadding: 24, bottomPadding: 12, leadingPadding: 24, height: 0, width: 0)
    }
    
    private func setupCAShapeLayer() {
        let path = UIBezierPath(arcCenter: CAShapeLayerContainerView.center, radius: CAShapeLayerContainerView.frame.width / 2, startAngle: -90 * (CGFloat.pi / 180), endAngle: 270 * (CGFloat.pi / 180), clockwise: true)
        
        bottomCAShapeLayer.path = path.cgPath
        bottomCAShapeLayer.fillColor = UIColor.clear.cgColor
        bottomCAShapeLayer.lineWidth = 5
        bottomCAShapeLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor

        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.primaryColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeStart = 0
        
        bottomCAShapeLayer.addSublayer(circleLayer)
        
        layer.addSublayer(bottomCAShapeLayer)
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
    
    // MARK: - Animations
    
    private func performCircleShapeLayerStrokeEndAnimation(to value: CGFloat) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = value
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        circleLayer.add(animation, forKey: nil)
    }
    
}
