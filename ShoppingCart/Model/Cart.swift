//
//  Cart.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

class Cart {
    
    private(set) var items : [CartItem] = []
    
    var total: Float {
        get { return items.reduce(0.0) { value, item in
            value + item.subTotal
            }
        }
    }
    
    var totalQuantity : Int {
        get { return items.reduce(0) { value, item in
            value + item.quantity
            }
        }
    }
    
    func update(product: Product) {
        if !self.contains(product: product) {
            self.add(product: product)
        } else {
            self.remove(product: product)
        }
    }
    
    func update() {
        
        for item in self.items {
            if item.quantity == 0 {
                update(product: item.product)
            }
        }
    }
    
    func add(product: Product) {
        let item = items.filter { $0.product == product }
        
        if item.first != nil {
            item.first!.quantity += 1
        } else {
            items.append(CartItem(product: product))
        }
    }
    
    func remove(product: Product) {
        guard let index = items.index(where: { $0.product == product }) else { return}
        items.remove(at: index)
    }
    
    func contains(product: Product) -> Bool {
        let item = items.filter { $0.product == product }
        return item.first != nil
    }
}
