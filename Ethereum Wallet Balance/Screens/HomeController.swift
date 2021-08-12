//
//  ViewController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/12/21.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [addressSearchTextField, UIView()], distribution: .fill, spacing: 0)
    
    private let addressSearchTextField = AddressSearchTextField()
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .primaryBackgroundColor
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(overallStackView)
        
        overallStackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, topPadding: 0, trailingPadding: 24, bottomPadding: 0, leadingPadding: 24, height: 0, width: 0)
    }

}
