//
//  ProductsTestCase.swift
//  ShoppingCartTests
//
//  Created by D. on 2018-06-08.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import XCTest

class ProductsTestCase: XCTestCase {
    
    let products = ProductsListHelper().all()
    
    func testProductCount() {
        XCTAssertEqual(products.count, 4)
    }
    
    func testProductPrices() {
        XCTAssertEqual(products[0].price, 0.95, "A bag of peas costs USD$ 0.95")
        XCTAssertEqual(products[1].price, 2.1, "A dozen of eggs costs USD$ 2.10")
        XCTAssertEqual(products[2].price, 1.3, "A bottle of milk costs USD$ 1.30")
        XCTAssertEqual(products[3].price, 0.73, "A can of beans costs USD$ 0.73")
    }
    
    func testProductNames() {
        let expectedNames = ["peas", "eggs", "milk", "beans"]
        
        for (index, expName) in expectedNames.enumerated() {
            XCTAssert(products[index].name.lowercased() == expName, "The product name is: \(expName)")
        }
    }
    
    func testProductUnits() {
        let expectedUnits = ["bag", "dozen", "bottle", "can"]
        
        for (index, expUnit) in expectedUnits.enumerated() {
            XCTAssert(products[index].unit.lowercased() == expUnit, "The product unit is: \(expUnit)")
        }
    }
}
