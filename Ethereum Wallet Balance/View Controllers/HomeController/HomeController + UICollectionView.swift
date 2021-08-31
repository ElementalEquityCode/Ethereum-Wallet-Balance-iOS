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
        
        if !addresses.isEmpty {
            let address = addresses[section]
            
            if address.coins != nil {
                return address.coins!.count
            }
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? EthereumAddressHeader {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleEthereumAddressHeaderTap))
            tapGestureRecognizer.name = "\(indexPath.section)"
            view.addGestureRecognizer(tapGestureRecognizer)
            
            let address = addresses[indexPath.section]
            
            view.ethereumAddress = address.address ?? ""
            view.etherBalance = address.etherBalance
            if let coins = address.coins {
                view.erc20Tokens = coins.count
            }
            view.addressValue = address.addressValue
            
            return view
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EthereumTokenCell {
            
            if let coins = addresses[indexPath.section].coins?.allObjects as? [CDEthereumToken] {
                cell.coin = coins[indexPath.row]
                
                if indexPath.row == 0 {
                    if coins.count == 1 {
                        cell.layer.cornerRadius = viewCornerRadius
                    } else {
                        cell.setupTopCornerRadius()
                        cell.setupBorderView()
                    }
                } else if indexPath.row < coins.count - 1 {
                    cell.setupBorderView()
                } else {
                    cell.setupBottomCornerRadius()
                }
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
        return UIEdgeInsets(top: 20, left: 0, bottom: section == addresses.count - 1 ? 0 : 40, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = ethereumAddressCollectionView.cellForItem(at: indexPath) as? EthereumTokenCell {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if let token = cell.coin {
                let navigationController = UINavigationController(rootViewController: EthereumTokenInformationController(token: token))
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true)
            }
        }
    }
        
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 266)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 70)
    }
    
}
