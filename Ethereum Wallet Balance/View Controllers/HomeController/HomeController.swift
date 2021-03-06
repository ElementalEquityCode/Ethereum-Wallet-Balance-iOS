//
//  ViewController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

// Issues so far
// Matching the ID's with the correct CoinGecko coin because some have repeated IDs

import UIKit

class HomeController: UIViewController, UITextFieldDelegate, AddressQRCodeScanDelegate, EthereumAddressDelegate {
    
    // MARK: - Properties
    
    var addresses = [CDEthereumAddress]()
        
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [addressSearchTextField, activityIndicatorViewStackView, ethereumAddressCollectionView], distribution: .fill, spacing: 5)
    
    private let addressSearchTextField = AddressSearchTextField()
    
    private lazy var activityIndicatorViewStackView = UIStackView.makeHorizontalStackView(with: [UIView(), activityIndicatorView, UIView()], distribution: .equalSpacing, spacing: 0)
    
    private let activityIndicatorView =  UIActivityIndicatorView.makeActivityIndicatorView()
    
    private let refreshControl = UIRefreshControl.makeRefreshControl()
    
    let ethereumAddressCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layer.cornerRadius = viewCornerRadius
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        view.backgroundColor = .primaryBackgroundColor
        setupSubviews()
        setupCollectionView()
        setupTargets()
        setupDelegates()
        setupNotificationCenter()
        fetchCDEthereumAddresses()
    }
    
    private func setupSubviews() {
        view.addSubview(overallStackView)
        
        overallStackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, topPadding: view.frame.height * 0.025, trailingPadding: 24, bottomPadding: view.frame.height * 0.025, leadingPadding: 24, height: 0, width: 0)
    }
    
    private func setupTargets() {
        ethereumAddressCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        addressSearchTextField.activateCameraBarButtonItem.action = #selector(presentScanAddressQRCodeController)
    }
    
    private func setupDelegates() {
        addressSearchTextField.delegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRepeatedAddressError), name: Notification.Name(rawValue: "repeatedAddressError"), object: nil)
    }
    
    private func fetchCDEthereumAddresses() {
        if let addresses = CoreDataManager.main.fetchAllCDEthereumAddresses() {
            self.addresses = addresses
            self.handleRefresh()
        }
    }
    
    // MARK: - CoinDelegate
    
    func didAddEthereumAddress(address: EthereumAddress?) {
        if address != nil {
            if address!.addressValue != 0 {
                DispatchQueue.main.async { [unowned self] in
                    if let CDEthereumAddress = CoreDataManager.main.createCDEthereumAddress(with: address!) {
                        addresses.append(CDEthereumAddress)
                        addresses.sort { (address1, address2) -> Bool in
                            return address1.addressValue > address2.addressValue
                        }
                        self.ethereumAddressCollectionView.reloadData()
                    }
                }
            } else if address!.addressValue == 0 {
                DispatchQueue.main.async {
                    self.handleError(with: "The Ethereum address entered has no assets")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.handleError(with: "Ethereum address not found")
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        let fullString = (textField.text! + string).replacingOccurrences(of: " ", with: "")
                
        if string.count > 1 { // Test pasting
            return testFullRegex(with: fullString)
        } else if string.count == 1 { // Test typing
            return testPartialRegex(with: fullString)
        }
        
        return true
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.count == 42 {
            textField.returnKeyType = .go
            textField.reloadInputViews()
        } else {
            textField.returnKeyType = .default
            textField.reloadInputViews()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count == 42 {
            textField.returnKeyType = .go
            textField.reloadInputViews()
        } else {
            textField.returnKeyType = .default
            textField.reloadInputViews()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.text!.count == 42 {
            searchForAddress(with: textField.text!)
        }
        
        return true
    }
    
    // MARK: - Selectors
    
    @objc private func handleRefresh() {
        if !addresses.isEmpty {
            var stringAddresses = [String]()
            
            addresses.forEach { (CDEthereumAddress) in
                if let address = CDEthereumAddress.address {
                    stringAddresses.append(address)
                }
            }
            
            var index = 0
            let addressCount = addresses.count
            
            addresses.removeAll()
            ethereumAddressCollectionView.reloadData()
            CoreDataManager.main.deleteAllData()
            
            stringAddresses.forEach { (address) in
                SearchForAddressSession(address: address, delegate: self).getCoinBalances { [unowned self] in
                    if index == addressCount {
                        DispatchQueue.main.async { [unowned self] in
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
                index += 1
            }
            
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func handleRepeatedAddressError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "This address has already been added", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    @objc private func presentScanAddressQRCodeController() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        let scanAddressQRCodeController = ScanAddressQRCodeController()
        scanAddressQRCodeController.delegate = self
        let navigationController = UINavigationController(rootViewController: scanAddressQRCodeController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func handleEthereumAddressHeaderTap(gesture: UITapGestureRecognizer) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete Address", style: .destructive, handler: { (_) in
            if let sectionToDeleteAsString = gesture.name {
                if let sectionToDelete = Int(sectionToDeleteAsString) {
                    CoreDataManager.main.deleteCDEthereumAddress(address: self.addresses.remove(at: sectionToDelete))
                    self.ethereumAddressCollectionView.deleteSections(IndexSet(integer: sectionToDelete))
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - URLSessions
    
    func searchForAddress(with address: String) {
        activityIndicatorView.startAnimating()
        
        SearchForAddressSession(address: address, delegate: self).getCoinBalances { [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                self.activityIndicatorView.stopAnimating()
                self.addressSearchTextField.text?.removeAll()
            }
        }
    }
    
    // MARK: - AddressQRCodeScanDelegate
    
    func didScanQRCode(value: String) {
        addressSearchTextField.text = value
        
        searchForAddress(with: value)
    }
    
    // MARK: - NotificationCenter
    
    private func handleError(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if addressSearchTextField.isFirstResponder {
            addressSearchTextField.resignFirstResponder()
        }
    }
    
    private func testFullRegex(with string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(0x([a-fA-F0-9]{40}))$")
                        
            return regex.numberOfMatches(in: string, options: [], range: NSRange(location: 0, length: string.count)) > 0 ? true : false
        } catch let error {
            print(error.localizedDescription)
        }
        
        return true
    }
    
    private func testPartialRegex(with string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(0)(x([a-fA-F0-9]{0,40}))?$", options: [])
            
            return regex.numberOfMatches(in: string, options: [], range: NSRange(location: 0, length: string.count)) > 0 ? true : false
        } catch let error {
            print(error.localizedDescription)
        }
        return true
    }

}
