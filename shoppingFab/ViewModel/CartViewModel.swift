//
//  CartViewModel.swift
//  shoppingFab
//
//  Created by susmita on 01/07/24.
//

import Foundation
import UIKit

class CartViewModel {
    var cartItems: [CartProductModel] = []
    
    func fetchItems(completion: @escaping () -> Void) {
        if let cartProducts = CoreDataManager.shared.fetchCartProducts() {
            cartItems = cartProducts.map { cartProduct in
                return CartProductModel(
                    productId: cartProduct.productId,
                    productImage: cartProduct.productImage.flatMap { UIImage(data: $0) },
                    productPrice: cartProduct.productPrice ?? "",
                    productQuantity: cartProduct.productQuantity,
                    productTitle: cartProduct.productTitle ?? ""
                )
            }
            completion()
        }
    }
}
