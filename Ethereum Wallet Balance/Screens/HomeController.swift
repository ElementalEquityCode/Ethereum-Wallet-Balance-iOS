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
        setupDelegates()
    }
    
    private func setupSubviews() {
        view.addSubview(overallStackView)
        
        overallStackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
    }
    
    private func setupDelegates() {
        addressSearchTextField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.isEmpty && string != "0" {
            return false
        } else if textField.text!.count == 1 && string.lowercased() != "x" {
            return false
        } else if textField.text!.count > 36 {
            return false
        } else if textField.text!.count > 1 && !(["a", "b", "c", "d", "e", "f", "0", "1", "2", "3", "4", "5", "6", "7", "8", ",9"].contains(string.lowercased())) {
            return false
        }
        
        return true
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if addressSearchTextField.isFirstResponder {
            addressSearchTextField.resignFirstResponder()
        }
    }

}
