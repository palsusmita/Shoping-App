//
//  UserDataList.swift
//  shoppingFab
//
//  Created by susmita on 30/06/24.
//

import Foundation
import CoreData
import UIKit

@objc(UserDataList)
public class CartProductList: NSManagedObject {
}

extension CartProductList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProductList> {
        return NSFetchRequest<CartProductList>(entityName: "CartProductList")
    }

    @NSManaged public var productImage: Data?
    @NSManaged public var productPrice: String?
    @NSManaged public var productTitle: String?
    @NSManaged public var productId: Int64
    @NSManaged public var productQuantity: Int64

}
