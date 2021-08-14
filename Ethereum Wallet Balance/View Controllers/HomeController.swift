//
//  ViewController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import UIKit

class HomeController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [addressSearchTextField, UIView()], distribution: .fill, spacing: 0)
    
    private let addressSearchTextField = AddressSearchTextField()
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .primaryBackgroundColor
        setupSubviews()
        setupTargets()
        setupDelegates()
    }
    
    private func setupSubviews() {
        view.addSubview(overallStackView)
        
        overallStackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, topPadding: view.frame.height * 0.025, trailingPadding: 24, bottomPadding: view.frame.height * 0.025, leadingPadding: 24, height: 0, width: 0)
    }
    
    private func setupTargets() {
        addressSearchTextField.activateCameraBarButtonItem.action = #selector(presentScanAddressQRCodeController)
    }
    
    private func setupDelegates() {
        addressSearchTextField.delegate = self
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
        if textField.text!.count == 36 {
            textField.returnKeyType = .go
            textField.reloadInputViews()
        } else {
            textField.returnKeyType = .default
            textField.reloadInputViews()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count == 36 {
            textField.returnKeyType = .go
            textField.reloadInputViews()
        } else {
            textField.returnKeyType = .default
            textField.reloadInputViews()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Selectors
    
    @objc private func presentScanAddressQRCodeController() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        let scanAddressQRCodeController = ScanAddressQRCodeController()
        scanAddressQRCodeController.modalTransitionStyle = .crossDissolve
        scanAddressQRCodeController.modalPresentationStyle = .fullScreen
        present(scanAddressQRCodeController, animated: true)
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if addressSearchTextField.isFirstResponder {
            addressSearchTextField.resignFirstResponder()
        }
    }
    
    private func testFullRegex(with string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(0x([a-fA-F0-9]{40}))$", options: .caseInsensitive)
                        
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
