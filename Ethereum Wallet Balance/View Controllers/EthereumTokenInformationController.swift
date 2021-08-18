//
//  EthereumTokenInformationController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/16/21.
//

import UIKit

class EthereumTokenInformationController: UIViewController, FetchCoinGeckoCoinIdDelegate, FetchCoinGeckoMarketDataDelegate {
    
    // MARK: - Properties
    
    // ALGORITHM FETCH DAILY PRICE CHANGE
    
    // GET THE TICKER OF THE TOKEN
    
    // GET https://api.coingecko.com/api/v3/coins/list
    
    // FIND THE COIN WITH THE MATCHING SYMBOL PROPERTY
    
    // GET https://api.coingecko.com/api/v3/coins/coin
    
    // THE START DATA REQUIRED WILL BE IN THERE
    
    // SO WILL THE DAILY PRICE CHANGE DATA
    
    private let token: EthereumToken
    
    private var dailyChangePercentage: Double? {
        didSet {
            if dailyChangePercentage != nil {
                let dailyChangeCarrot = dailyChangePercentage! > 0 ? "▲" : "▼"
                let dailyChangeTextColor = dailyChangePercentage! > 0 ? UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1) : UIColor(red: 255/255, green: 94/255, blue: 86/255, alpha: 1)
                    
                let dailyChangeLabelString1 = NSAttributedString(string: "Daily - ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryTextColor])
                let dailyChangeLabelString2 = NSAttributedString(string: "\(dailyChangeCarrot) \(formatDoubleToTwoDecimalPlaces(value: dailyChangePercentage!))%", attributes: [NSAttributedString.Key.foregroundColor: dailyChangeTextColor])
                let dailyValueLabelArray = NSMutableAttributedString()
                dailyValueLabelArray.append(dailyChangeLabelString1)
                dailyValueLabelArray.append(dailyChangeLabelString2)
                
                DispatchQueue.main.async {
                    UIView.transition(with: self.dailyChangeLabel, duration: 0.15, options: .transitionCrossDissolve) {
                        self.dailyChangeLabel.attributedText = dailyValueLabelArray
                    }
                }
            }
        }
    }
    
    private var coinGeckoAssetID: String? {
        didSet {
            if coinGeckoAssetID != nil {
                FetchCoinGeckoDailyAssetChangeSession(delegate: self).getDailyPercentageChange(for: coinGeckoAssetID!)
                FetchCoinGeckoChartDataSession(coinID: coinGeckoAssetID!, delegate: self).getChartData()
            }
        }
    }
    
    private lazy var backgroundViewsStackView = UIStackView.makeVerticalStackView(with: [percentageOfWalletBackgroundView, tokenFactsBackgroundView], distribution: .fillEqually, spacing: 24)
    
    private lazy var percentageOfWalletBackgroundView: UIView = {
        let percentageOfWalletBackgroundView = UIView()
        percentageOfWalletBackgroundView.layer.shadowColor = UIColor.black.cgColor
        percentageOfWalletBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
        percentageOfWalletBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 2)
        percentageOfWalletBackgroundView.backgroundColor = .primaryViewBackgroundColor
        percentageOfWalletBackgroundView.layer.cornerRadius = viewCornerRadius
        percentageOfWalletBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return percentageOfWalletBackgroundView
    }()
    
    private let percentageOfPortfolioCircleLayer = CAShapeLayer()
    
    private let coinBalanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentageOfPortfolioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tokenFactsBackgroundView: UIView = {
        let tokenFactsBackgroundView = UIView()
        tokenFactsBackgroundView.layer.shadowColor = UIColor.black.cgColor
        tokenFactsBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
        tokenFactsBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 2)
        tokenFactsBackgroundView.backgroundColor = .primaryViewBackgroundColor
        tokenFactsBackgroundView.layer.cornerRadius = viewCornerRadius
        tokenFactsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return tokenFactsBackgroundView
    }()
    
    private let coinLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelsStackView = UIStackView.makeVerticalStackView(with: [pricePerTokenLabel, totalUSDValueLabel, dailyChangeLabel], distribution: .fillEqually, spacing: 10)
    
    private let pricePerTokenLabel: UILabel = {
        let label = UILabel()
        label.textColor = .placeholderTextColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalUSDValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .placeholderTextColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyChangeLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily - N/A"
        label.textColor = .placeholderTextColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    init(token: EthereumToken) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgroundColor
        setupSubviews()
        setupPercentageOfWalletBackgroundView()
        setupTokenFactsBackgroundView()
        setupNavigationBar()
        fetchAllCoinsFromCoinGecko()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        percentPercentageOfPortfolioCircleLayerAnimation()
    }
    
    private func setupSubviews() {
        view.addSubview(backgroundViewsStackView)
        
        backgroundViewsStackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, topPadding: 24, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: view.frame.height * 0.25, width: 0)
        backgroundViewsStackView.layoutIfNeeded()
        
        setupCAShapeLayers()
    }
    
    private func setupPercentageOfWalletBackgroundView() {
        coinBalanceLabel.text = "\(formatDoubleToTwoDecimalPlaces(value: token.coinBalance)) \(token.ticker)".uppercased()
        percentageOfPortfolioLabel.text = "\(formatDoubleToTwoDecimalPlaces(value: token.percentOfTotalPortfolio * 100))% of wallet"
        
        percentageOfWalletBackgroundView.addSubview(coinBalanceLabel)
        percentageOfWalletBackgroundView.addSubview(percentageOfPortfolioLabel)
        
        coinBalanceLabel.anchor(topAnchor: nil, trailingAnchor: percentageOfWalletBackgroundView.trailingAnchor, bottomAnchor: percentageOfWalletBackgroundView.centerYAnchor, leadingAnchor: percentageOfWalletBackgroundView.leadingAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 5, leadingPadding: (percentageOfWalletBackgroundView.frame.height / 3.5) * 3 + 24, height: 0, width: 0)
        
        percentageOfPortfolioLabel.anchor(topAnchor: percentageOfWalletBackgroundView.centerYAnchor, trailingAnchor: coinBalanceLabel.trailingAnchor, bottomAnchor: nil, leadingAnchor: coinBalanceLabel.leadingAnchor, topPadding: 5, trailingPadding: 0, bottomPadding: 0, leadingPadding: 0, height: 0, width: 0)
    }
    
    private func setupTokenFactsBackgroundView() {
        coinLogoImageView.image = token.logo
        
        let pricePerTokenLabelString1 = NSAttributedString(string: "Price - ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryTextColor])
        let pricePerTokenLabelString2 = NSAttributedString(string: "$\(formatDoubleToTwoDecimalPlaces(value: token.price))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor])
        let pricePerTokenLabelArray = NSMutableAttributedString()
        pricePerTokenLabelArray.append(pricePerTokenLabelString1)
        pricePerTokenLabelArray.append(pricePerTokenLabelString2)
        pricePerTokenLabel.attributedText = pricePerTokenLabelArray
        
        let totalUSDValueLabelString1 = NSAttributedString(string: "Value - ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryTextColor])
        let totalUSDValueLabelString2 = NSAttributedString(string: "$\(formatDoubleToTwoDecimalPlaces(value: token.usdBalance))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor])
        let totalUSDValueLabelArray = NSMutableAttributedString()
        totalUSDValueLabelArray.append(totalUSDValueLabelString1)
        totalUSDValueLabelArray.append(totalUSDValueLabelString2)
        totalUSDValueLabel.attributedText = totalUSDValueLabelArray
        
        tokenFactsBackgroundView.addSubview(coinLogoImageView)
        tokenFactsBackgroundView.addSubview(labelsStackView)
        
        coinLogoImageView.centerYAnchor.constraint(equalTo: tokenFactsBackgroundView.centerYAnchor).isActive = true
        coinLogoImageView.centerXAnchor.constraint(equalTo: tokenFactsBackgroundView.leadingAnchor, constant: (tokenFactsBackgroundView.frame.height / 3.5) * 2).isActive = true
        coinLogoImageView.widthAnchor.constraint(equalToConstant: (tokenFactsBackgroundView.frame.height / 3.5) * 2).isActive = true
        coinLogoImageView.heightAnchor.constraint(equalToConstant: (tokenFactsBackgroundView.frame.height / 3.5) * 2).isActive = true
        
        labelsStackView.centerYAnchor.constraint(equalTo: tokenFactsBackgroundView.centerYAnchor).isActive = true
        labelsStackView.heightAnchor.constraint(equalTo: tokenFactsBackgroundView.heightAnchor, constant: -24).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: tokenFactsBackgroundView.trailingAnchor).isActive = true
        labelsStackView.leadingAnchor.constraint(equalTo: tokenFactsBackgroundView.leadingAnchor, constant: (tokenFactsBackgroundView.frame.height / 3.5) * 3 + 24).isActive = true
    }
    
    private func setupCAShapeLayers() {
        let backgroundShapeLayerView = CAShapeLayer()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: (percentageOfWalletBackgroundView.frame.height / 3.5) * 2, y: percentageOfWalletBackgroundView.frame.midY), radius: percentageOfWalletBackgroundView.frame.height / 3.5, startAngle: -90 * (CGFloat.pi / 180), endAngle: 270 * (CGFloat.pi / 180), clockwise: true)
        
        percentageOfPortfolioCircleLayer.path = path.cgPath
        percentageOfPortfolioCircleLayer.fillColor = UIColor.clear.cgColor
        percentageOfPortfolioCircleLayer.strokeColor = UIColor(red: 85/255, green: 171/255, blue: 191/255, alpha: 1).cgColor
        percentageOfPortfolioCircleLayer.lineWidth = 6
        percentageOfPortfolioCircleLayer.strokeStart = 0
        percentageOfPortfolioCircleLayer.strokeEnd = 0
        
        backgroundShapeLayerView.path = path.cgPath
        backgroundShapeLayerView.fillColor = UIColor.clear.cgColor
        backgroundShapeLayerView.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        backgroundShapeLayerView.lineWidth = 6
        
        backgroundShapeLayerView.addSublayer(percentageOfPortfolioCircleLayer)
        
        percentageOfWalletBackgroundView.layer.addSublayer(backgroundShapeLayerView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = token.ticker
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.backward"), style: .plain, target: self, action: #selector(dismissThisViewController))
    }
    
    private func fetchAllCoinsFromCoinGecko() {
        FetchCoinGeckoAssetIDSession(delegate: self).getID(for: token.ticker)
    }
    
    // MARK: - FetchCoinGeckoDailyAssetChangeDelegate
    
    func didFetchDailyChangePercentage(amount: Double) {
        dailyChangePercentage = amount
    }
    
    func didFetchChartData(data: [ChartPoint]) {
        print(data)
    }
    
    // MARK: - FetchCoinGeckoCoinIdDelegate
    
    func didFetchID(string: String) {
        coinGeckoAssetID = string
    }
    
    // MARK: - Animations
    
    private func percentPercentageOfPortfolioCircleLayerAnimation() {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = CGFloat(token.percentOfTotalPortfolio)
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        percentageOfPortfolioCircleLayer.add(animation, forKey: nil)
    }
    
    // MARK: - TraitCollection
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            traitCollection.performAsCurrent {
                self.percentageOfWalletBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
                self.tokenFactsBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func dismissThisViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
