//
//  ProductsManager.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-04.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

class ProductsListHelper {
    
    private let productsJson = """
        [
            {
                "name": "Peas",
                "price": 0.95,
                "unit": "bag"
            },
            {
                "name": "Eggs",
                "price": 2.10,
                "unit": "dozen"
            },
            {
                "name": "Milk",
                "price": 1.30,
                "unit": "bottle"
            },
            {
                "name": "Beans",
                "price": 0.73,
                "unit": "can"
            }
        ]
        """.data(using: .utf8)!
    
    func all() -> [Product] {
        let decoder = JSONDecoder()
        let products = try! decoder.decode([Product].self, from: productsJson)
        
        return products
    }
}

