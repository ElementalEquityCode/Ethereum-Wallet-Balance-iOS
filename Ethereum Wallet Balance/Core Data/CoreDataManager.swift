//
//  CoreDataManager.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/30/21.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let main = CoreDataManager()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    func save() {
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllData() {
        let deleteAddressesRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "CDEthereumAddress"))
        let deleteTokensRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "CDEthereumToken"))
        
        do {
            try viewContext.execute(deleteAddressesRequest)
            try viewContext.execute(deleteTokensRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - CRUD for CDEthereumAddress
    
    func createCDEthereumAddress(with address: EthereumAddress) -> CDEthereumAddress? {
        if let addressObject = NSEntityDescription.insertNewObject(forEntityName: "CDEthereumAddress", into: self.viewContext) as? CDEthereumAddress {
            addressObject.address = address.address
            addressObject.addressValue = address.addressValue ?? 0
            addressObject.etherBalance = address.etherBalance
            
            for coin in address.coins {
                if let tokenObject = NSEntityDescription.insertNewObject(forEntityName: "CDEthereumToken", into: self.viewContext) as? CDEthereumToken {
                    
                    tokenObject.ticker = coin.ticker
                    tokenObject.price = coin.price
                    tokenObject.coinBalance = coin.coinBalance
                    tokenObject.usdBalance = coin.usdBalance
                    tokenObject.logoUrl = coin.logoUrl
                    tokenObject.percentOfTotalPortfolio = coin.percentOfTotalPortfolio
                    tokenObject.address = addressObject
                    
                    if let coinLogo = coin.logo {
                        tokenObject.logo = coinLogo.pngData()
                    }
                }
            }
            
            self.save()
            
            return addressObject
        }
        return nil
    }
    
    func fetchAllCDEthereumAddresses() -> [CDEthereumAddress]? {
        let fetchRequest = NSFetchRequest<CDEthereumAddress>(entityName: "CDEthereumAddress")
        
        do {
            let addresses = try viewContext.fetch(fetchRequest)
            
            return addresses
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func deleteCDEthereumAddress(address: CDEthereumAddress) {
        if let coins = address.coins {
            coins.forEach { (managedObject) in
                if let coin = managedObject as? CDEthereumToken {
                    viewContext.delete(coin)
                }
            }
        }
        viewContext.delete(address)
        save()
    }
    
    // MARK: - CRUD for CDEthereumToken
    
    func setCDEthereumTokenLogo(for coin: CDEthereumToken, with image: UIImage) {
        coin.logo = image.pngData()
    }
    
}
