//
//  HomeController + UICollectionView.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/15/21.
//

import UIKit

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        ethereumAddressCollectionView.dataSource = self
        ethereumAddressCollectionView.delegate = self
        ethereumAddressCollectionView.register(EthereumAddressHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        ethereumAddressCollectionView.register(EthereumTokenCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !addresses.isEmpty ? addresses[section].coins.count : 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? EthereumAddressHeader {
            
            let address = addresses[indexPath.section]
            
            view.ethereumAddress = address.address
            view.etherBalance = address.etherBalance
            view.erc20Tokens = address.coins.count
            view.addressValue = address.addressValue ?? 0
            
            return view
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EthereumTokenCell {
            
            cell.coin = addresses[indexPath.section].coins[indexPath.row]
            
            if indexPath.row == 0 {
                if addresses[indexPath.section].coins.count == 1 {
                    cell.layer.cornerRadius = viewCornerRadius
                } else {
                    cell.setupTopCornerRadius()
                    cell.setupBorderView()
                }
            } else if indexPath.row < addresses[indexPath.section].coins.count - 1 {
                cell.setupBorderView()
            } else {
                cell.setupBottomCornerRadius()
            }
            
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
    }
        
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 266)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
}
