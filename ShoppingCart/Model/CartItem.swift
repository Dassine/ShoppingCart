//
//  CartItem.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

class CartItem {
    
    var quantity : Int = 1
    var product : Product
    
    var subTotal : Float { get { return product.price * Float(quantity) } }
    
    init(product: Product) {
        self.product = product
    }
    
//    func displayPrice() -> String {
//        return "\(quantity) \(product.displayUnit(quantity: quantity)) * \(product.price)"
//    }
    
//    func displayQuantity() -> String {
//        return "\(quantity)"
//    }
    
}
