//
//  CoreDataManager.swift
//  shoppingFab
//
//  Created by susmita on 29/06/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
// save Cart items in core data

    func saveCartProduct(productId: Int64, productImage: UIImageView, productPrice: String, productQuantity: Int64, productTitle: String) {
        let context = self.context

        // Fetch the product with the given productId
        let fetchRequest: NSFetchRequest<CartProductList> = CartProductList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %ld", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let existingProduct = results.first {
                // Product exists, update the quantity
                existingProduct.productQuantity += productQuantity
                print("Product quantity updated.")
            } else {
                // Product does not exist, create a new entry
                guard let cartProductEntity = NSEntityDescription.entity(forEntityName: "CartProductList", in: context) else { return }
                let productList = NSManagedObject(entity: cartProductEntity, insertInto: context)
                productList.setValue(productId, forKey: "productId")
                if let image = productImage.image, let imageData = image.pngData() {
                    productList.setValue(imageData, forKey: "productImage")
                }
                productList.setValue(productPrice, forKey: "productPrice")
                productList.setValue(productQuantity, forKey: "productQuantity")
                productList.setValue(productTitle, forKey: "productTitle")
                print("New product added.")
            }
            
            // Save the context
            try context.save()
            print("CartProduct saved successfully.")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // fetch Cart items from core data
    func fetchCartProducts() -> [CartProductList]?{
        let context = self.context
        let fetchRequest = NSFetchRequest<CartProductList>(entityName: "CartProductList")

        do {
            let cartProducts = try context.fetch(fetchRequest)
            return cartProducts
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // update Cart items in core data
    func updateCartProduct(productId: Int64, productQuantity: Int64) {
        let context = self.context

        // Fetch the product with the given productId
        let fetchRequest: NSFetchRequest<CartProductList> = CartProductList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %ld", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let existingProduct = results.first {
                // Product exists, update the quantity
                existingProduct.productQuantity = productQuantity
                print("Product quantity updated.")
                
                // Save the context
                try context.save()
                print("CartProduct updated successfully.")
            } else {
                print("Product not found, cannot update.")
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
    // delete Cart items in core data
    func deleteCartProduct(withProductId productId: Int64) {
        let context = self.context
        let fetchRequest: NSFetchRequest<CartProductList> = CartProductList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)

        do {
            let results = try context.fetch(fetchRequest)
            if let productToDelete = results.first {
                context.delete(productToDelete)
                try context.save()
                print("Product deleted successfully")
            } else {
                print("No product found with the specified productId")
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    // save user info in core data
    func saveUserData(name: String , email: String,address: String,password:String){
        let context = self.context
        let userEntity = NSEntityDescription.entity(forEntityName: "UserData", in: context)!
        let userData = NSManagedObject(entity: userEntity, insertInto: context)
        userData.setValue(name, forKey: "name")
        userData.setValue(email, forKey: "mail")
        userData.setValue(address, forKey: "address")
        userData.setValue(password, forKey: "password")
                // Save the context
                do {
                    try context.save()
                    print("Text saved successfully")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
    }
    
    // fetch user info in core data
    func fetchUserData() -> [UserData]?{
        let context = self.context
        let fetchRequest = NSFetchRequest<UserData>(entityName: "UserData")

        do {
            let userRecord = try context.fetch(fetchRequest)
            return userRecord
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
