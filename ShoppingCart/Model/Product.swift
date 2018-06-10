//
//  Product.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-04.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

struct Product: Codable, Equatable {
    
    var name: String
    var price: Float
    var unit: String
    
//    func displayUnit(quantity: Int) -> String {
//        return quantity == 1 ? unit : unit + "s"
//    }
    
    // MARK: Equatable
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.unit == rhs.unit
    }
}
