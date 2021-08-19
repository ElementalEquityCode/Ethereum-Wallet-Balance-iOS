//
//  EthereumTokenInformationController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/16/21.
//

import UIKit
import Charts

enum ChartTimeFrame {
    case daily
    case weekly
    case monthly
}

class EthereumTokenInformationController: UIViewController, FetchCoinGeckoCoinIdDelegate, FetchCoinGeckoMarketDataDelegate, ChartViewDelegate {
    
    // MARK: - Properties
    
    private var chartTimeFrame: ChartTimeFrame = .monthly {
        didSet {
            
            let line = LineChartData()
            
            switch chartTimeFrame {
            case .daily:
                dayButton.setTitleColor(.primaryColor, for: .normal)
                weekButton.setTitleColor(.placeholderTextColor, for: .normal)
                monthButton.setTitleColor(.placeholderTextColor, for: .normal)
                
                line.addDataSet(dailyLineChartDataSet)
                lineChart.data = line
            case .weekly:
                dayButton.setTitleColor(.placeholderTextColor, for: .normal)
                weekButton.setTitleColor(.primaryColor, for: .normal)
                monthButton.setTitleColor(.placeholderTextColor, for: .normal)
                
                line.addDataSet(weeklyLineChartDataSet)
                lineChart.data = line
            case .monthly:
                dayButton.setTitleColor(.placeholderTextColor, for: .normal)
                weekButton.setTitleColor(.placeholderTextColor, for: .normal)
                monthButton.setTitleColor(.primaryColor, for: .normal)
                
                line.addDataSet(monthlyLineChartDataSet)
                lineChart.data = line
            }
        }
    }
    
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
                
                let chartDataSession = FetchCoinGeckoChartDataSession(coinID: coinGeckoAssetID!, delegate: self)
                chartDataSession.getChartData(for: .daily)
                chartDataSession.getChartData(for: .weekly)
                chartDataSession.getChartData(for: .monthly)
            }
        }
    }
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [lineChartBackgroundView, percentageOfWalletBackgroundView, tokenFactsBackgroundView], distribution: .fill, spacing: 24)
    
    private lazy var lineChartBackgroundView: UIView = {
        let lineChartBackgroundView = UIView()
        lineChartBackgroundView.layer.masksToBounds = true
        lineChartBackgroundView.layer.shadowColor = UIColor.black.cgColor
        lineChartBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
        lineChartBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 2)
        lineChartBackgroundView.backgroundColor = .primaryViewBackgroundColor
        lineChartBackgroundView.layer.cornerRadius = viewCornerRadius
        lineChartBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return lineChartBackgroundView
    }()
    
    private lazy var selectedPriceAndDateLabelsStackView = UIStackView.makeVerticalStackView(with: [selectedPriceLabel, selectedDateLabel], distribution: .fill, spacing: 0)
    
    private let selectedPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = UIFont.systemFont(ofSize: 35, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectedDateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .placeholderTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineChart: LineChartView = {
        let lineChart = LineChartView(frame: CGRect.zero)
                        
        lineChart.legend.form = .none
                
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        
        lineChart.rightAxis.drawLabelsEnabled = false
        lineChart.rightAxis.drawAxisLineEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        
        lineChart.xAxis.drawLabelsEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        
        let borderView = UIView.makeBorderView()
        lineChart.addSubview(borderView)
        
        borderView.anchor(topAnchor: nil, trailingAnchor: lineChart.trailingAnchor, bottomAnchor: lineChart.bottomAnchor, leadingAnchor: lineChart.leadingAnchor, topPadding: 0, trailingPadding: 0, bottomPadding: 0, leadingPadding: 0, height: 0, width: 0)
        
        return lineChart
    }()
        
    private var dailyLineChartDataSet = LineChartDataSet()
    
    private var weeklyLineChartDataSet = LineChartDataSet()
    
    private var monthlyLineChartDataSet = LineChartDataSet()
    
    private lazy var percentageOfWalletBackgroundView: UIView = {
        let percentageOfWalletBackgroundView = UIView()
        percentageOfWalletBackgroundView.layer.shadowColor = UIColor.black.cgColor
        percentageOfWalletBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
        percentageOfWalletBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 2)
        percentageOfWalletBackgroundView.backgroundColor = .primaryViewBackgroundColor
        percentageOfWalletBackgroundView.layer.cornerRadius = viewCornerRadius
        percentageOfWalletBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        percentageOfWalletBackgroundView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.10).isActive = true
        return percentageOfWalletBackgroundView
    }()
    
    private lazy var timeFrameButtonsStackView = UIStackView.makeHorizontalStackView(with: [dayButton, weekButton, monthButton], distribution: .equalSpacing, spacing: 0)
        
    private let dayButton = UIButton.makeLineChartViewTimeFrameButton(with: "1D")
    
    private let weekButton = UIButton.makeLineChartViewTimeFrameButton(with: "1W")
    
    private let monthButton = UIButton.makeLineChartViewTimeFrameButton(with: "1M")
    
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
        tokenFactsBackgroundView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.10).isActive = true
        return tokenFactsBackgroundView
    }()
    
    private let coinLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tokenFactsLabelsStackView = UIStackView.makeVerticalStackView(with: [pricePerTokenLabel, totalUSDValueLabel, dailyChangeLabel], distribution: .fillEqually, spacing: 0)
    
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
        setupDelegates()
        setupTargets()
        setupPercentageOfWalletBackgroundView()
        setupTokenFactsBackgroundView()
        setupLineChartBackgroundView()
        setupNavigationBar()
        fetchAllCoinsFromCoinGecko()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        percentPercentageOfPortfolioCircleLayerAnimation()
    }
    
    private func setupSubviews() {
        view.addSubview(overallStackView)
        
        overallStackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, topPadding: 24, trailingPadding: 24, bottomPadding: 24, leadingPadding: 24, height: 0, width: 0)
        overallStackView.layoutIfNeeded()
        
        setupCAShapeLayers()
    }
    
    private func setupDelegates() {
        lineChart.delegate = self
    }
    
    private func setupPercentageOfWalletBackgroundView() {
        coinBalanceLabel.text = "\(formatDoubleToTwoDecimalPlaces(value: token.coinBalance)) \(token.ticker)".uppercased()
        percentageOfPortfolioLabel.text = "\(formatDoubleToTwoDecimalPlaces(value: token.percentOfTotalPortfolio * 100))% of wallet"
        
        percentageOfWalletBackgroundView.addSubview(coinBalanceLabel)
        percentageOfWalletBackgroundView.addSubview(percentageOfPortfolioLabel)
        
        coinBalanceLabel.anchor(topAnchor: nil, trailingAnchor: percentageOfWalletBackgroundView.trailingAnchor, bottomAnchor: percentageOfWalletBackgroundView.centerYAnchor, leadingAnchor: percentageOfWalletBackgroundView.leadingAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 5, leadingPadding: (percentageOfWalletBackgroundView.frame.height / 3.5) * 3 + 24, height: 0, width: 0)
        
        percentageOfPortfolioLabel.anchor(topAnchor: percentageOfWalletBackgroundView.centerYAnchor, trailingAnchor: coinBalanceLabel.trailingAnchor, bottomAnchor: nil, leadingAnchor: coinBalanceLabel.leadingAnchor, topPadding: 5, trailingPadding: 0, bottomPadding: 0, leadingPadding: 0, height: 0, width: 0)
    }
    
    private func setupTargets() {
        dayButton.addTarget(self, action: #selector(handleDayButtonTapped), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(handleWeekButtonTapped), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(handleMonthButtonTapped), for: .touchUpInside)
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
        tokenFactsBackgroundView.addSubview(tokenFactsLabelsStackView)
        
        coinLogoImageView.centerYAnchor.constraint(equalTo: tokenFactsBackgroundView.centerYAnchor).isActive = true
        coinLogoImageView.centerXAnchor.constraint(equalTo: tokenFactsBackgroundView.leadingAnchor, constant: (tokenFactsBackgroundView.frame.height / 3.5) * 2).isActive = true
        coinLogoImageView.widthAnchor.constraint(equalToConstant: (tokenFactsBackgroundView.frame.height / 3.5) * 2).isActive = true
        coinLogoImageView.heightAnchor.constraint(equalToConstant: (tokenFactsBackgroundView.frame.height / 3.5) * 2).isActive = true
        
        tokenFactsLabelsStackView.centerYAnchor.constraint(equalTo: tokenFactsBackgroundView.centerYAnchor).isActive = true
        tokenFactsLabelsStackView.heightAnchor.constraint(equalTo: tokenFactsBackgroundView.heightAnchor, constant: -24).isActive = true
        tokenFactsLabelsStackView.trailingAnchor.constraint(equalTo: tokenFactsBackgroundView.trailingAnchor).isActive = true
        tokenFactsLabelsStackView.leadingAnchor.constraint(equalTo: tokenFactsBackgroundView.leadingAnchor, constant: (tokenFactsBackgroundView.frame.height / 3.5) * 3 + 24).isActive = true
    }
    
    private func setupLineChartBackgroundView() {
        monthButton.setTitleColor(.primaryColor, for: .normal)
        selectedDateLabel.text = getGeneralDateFormatter().string(from: Date())
        setTextForSelectedPriceLabel(value: token.price)
        
        lineChartBackgroundView.addSubview(lineChart)
        lineChartBackgroundView.addSubview(selectedPriceAndDateLabelsStackView)
        lineChartBackgroundView.addSubview(timeFrameButtonsStackView)
        
        lineChart.heightAnchor.constraint(equalTo: lineChartBackgroundView.heightAnchor, multiplier: 0.7).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: lineChartBackgroundView.leadingAnchor, constant: -10).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: lineChartBackgroundView.trailingAnchor, constant: 10).isActive = true
        lineChart.topAnchor.constraint(equalTo: lineChartBackgroundView.topAnchor, constant: lineChartBackgroundView.frame.height * 0.15).isActive = true
        
        selectedPriceAndDateLabelsStackView.anchor(topAnchor: lineChartBackgroundView.topAnchor, trailingAnchor: lineChartBackgroundView.trailingAnchor, bottomAnchor: lineChart.topAnchor, leadingAnchor: lineChartBackgroundView.leadingAnchor, topPadding: 24, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
        
        timeFrameButtonsStackView.anchor(topAnchor: lineChart.bottomAnchor, trailingAnchor: lineChartBackgroundView.trailingAnchor, bottomAnchor: lineChartBackgroundView.bottomAnchor, leadingAnchor: lineChartBackgroundView.leadingAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
    }
    
    private func setupCAShapeLayers() {
        let backgroundShapeLayerView = CAShapeLayer()
                
        let path = UIBezierPath(arcCenter: CGPoint(x: (percentageOfWalletBackgroundView.frame.height / 3.5) * 2, y: percentageOfWalletBackgroundView.bounds.midY), radius: percentageOfWalletBackgroundView.bounds.height / 3.5, startAngle: -90 * (CGFloat.pi / 180), endAngle: 270 * (CGFloat.pi / 180), clockwise: true)
        
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
    
    // MARK: - Selectors
    
    @objc private func handleDayButtonTapped() {
        chartTimeFrame = .daily
    }
    
    @objc private func handleWeekButtonTapped() {
        chartTimeFrame = .weekly
    }
    
    @objc private func handleMonthButtonTapped() {
        chartTimeFrame = .monthly
    }
    
    // MARK: - FetchCoinGeckoDailyAssetChangeDelegate
    
    func didFetchDailyChangePercentage(amount: Double) {
        dailyChangePercentage = amount
    }
    
    func didFetchDailyChartData(data: [ChartPoint]) {
        var dataSet = [ChartDataEntry]()
        
        for point in data {
            dataSet.append(ChartDataEntry(x: point.timestamp, y: point.value))
        }
        
        DispatchQueue.main.async {
            self.dailyLineChartDataSet = LineChartDataSet(entries: dataSet)
            
            self.dailyLineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            self.dailyLineChartDataSet.highlightColor = .clear
            
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.primaryColor.cgColor, UIColor.clear.cgColor] as CFArray, locations: [1, 0])
            
            self.dailyLineChartDataSet.drawFilledEnabled = true
            self.dailyLineChartDataSet.fill = Fill(linearGradient: gradient!, angle: 90.0)

            self.dailyLineChartDataSet.lineCapType = .round
            self.dailyLineChartDataSet.lineWidth = 1.5
                        
            self.dailyLineChartDataSet.label = nil
            self.dailyLineChartDataSet.drawValuesEnabled = false
            
            self.dailyLineChartDataSet.drawCirclesEnabled = false
            self.dailyLineChartDataSet.drawCircleHoleEnabled = false
            
            self.dailyLineChartDataSet.colors = [UIColor.primaryColor]
        }
    }
    
    func didFetchWeeklyChartData(data: [ChartPoint]) {
        var dataSet = [ChartDataEntry]()
        
        for point in data {
            dataSet.append(ChartDataEntry(x: point.timestamp, y: point.value))
        }
        
        DispatchQueue.main.async {
            self.weeklyLineChartDataSet = LineChartDataSet(entries: dataSet)
            
            self.weeklyLineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            self.weeklyLineChartDataSet.highlightColor = .clear
            
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.primaryColor.cgColor, UIColor.clear.cgColor] as CFArray, locations: [1, 0])
            
            self.weeklyLineChartDataSet.drawFilledEnabled = true
            self.weeklyLineChartDataSet.fill = Fill(linearGradient: gradient!, angle: 90.0)

            self.weeklyLineChartDataSet.lineCapType = .round
            self.weeklyLineChartDataSet.lineWidth = 1.5
                        
            self.weeklyLineChartDataSet.label = nil
            self.weeklyLineChartDataSet.drawValuesEnabled = false
            
            self.weeklyLineChartDataSet.drawCirclesEnabled = false
            self.weeklyLineChartDataSet.drawCircleHoleEnabled = false
            
            self.weeklyLineChartDataSet.colors = [UIColor.primaryColor]
        }
    }
    
    func didFetchMonthlyChartData(data: [ChartPoint]) {
        var dataSet = [ChartDataEntry]()
        
        for point in data {
            dataSet.append(ChartDataEntry(x: point.timestamp, y: point.value))
        }
        
        DispatchQueue.main.async {
            self.monthlyLineChartDataSet = LineChartDataSet(entries: dataSet)
            
            self.monthlyLineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            self.monthlyLineChartDataSet.highlightColor = .clear
            
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.primaryColor.cgColor, UIColor.clear.cgColor] as CFArray, locations: [1, 0])
            
            self.monthlyLineChartDataSet.drawFilledEnabled = true
            self.monthlyLineChartDataSet.fill = Fill(linearGradient: gradient!, angle: 90.0)

            self.monthlyLineChartDataSet.lineCapType = .round
            self.monthlyLineChartDataSet.lineWidth = 1.5
                        
            self.monthlyLineChartDataSet.label = nil
            self.monthlyLineChartDataSet.drawValuesEnabled = false
            
            self.monthlyLineChartDataSet.drawCirclesEnabled = false
            self.monthlyLineChartDataSet.drawCircleHoleEnabled = false
            
            self.monthlyLineChartDataSet.colors = [UIColor.primaryColor]
            
            let line = LineChartData()
            line.addDataSet(self.monthlyLineChartDataSet)
            
            self.lineChart.data = line
        }
    }
    
    // MARK: - FetchCoinGeckoCoinIdDelegate
    
    func didFetchID(string: String) {
        coinGeckoAssetID = string
    }
    
    // MARK: - ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        setTextForSelectedPriceLabel(value: entry.y)
        selectedDateLabel.text = convertTimeStampToHumanReadableDate(timestamp: entry.x)
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        print("here")
    }
    
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        print("here 2")
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
                self.lineChartBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
                self.percentageOfWalletBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
                self.tokenFactsBackgroundView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.4 : 0.12
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setTextForSelectedPriceLabel(value: Double) {
        let attributedString1 = NSAttributedString(string: "$", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light), NSAttributedString.Key.baselineOffset: 9])
        let attributedString2 = NSAttributedString(string: "\(formatDoubleToTwoDecimalPlaces(value: value))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: .light)])
        let array = NSMutableAttributedString()
        array.append(attributedString1)
        array.append(attributedString2)
        
        selectedPriceLabel.attributedText = array
    }
    
    // MARK: - Time
    
    private func getGeneralDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
    
    private func convertTimeStampToHumanReadableDate(timestamp: TimeInterval) -> String {
        let dateFormatter = getGeneralDateFormatter()
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp / 1000.00))
    }
    
    // MARK: - Selectors
    
    @objc private func dismissThisViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
