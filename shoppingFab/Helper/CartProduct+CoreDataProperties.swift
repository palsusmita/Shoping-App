//
//  CartProduct+CoreDataProperties.swift
//  shoppingFab
//
//  Created by susmita on 29/06/24.
//
//

import Foundation
import CoreData


extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var productId: String?
    @NSManaged public var productQuantity: Int64

}

extension CartProduct : Identifiable {

}
