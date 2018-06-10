//
//  CurrencyTestCase.swift
//  ShoppingCartTests
//
//  Created by D. on 2018-06-08.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import XCTest

class CurrencyTestCase: XCTestCase {
    
    let currencyHelper = CurrencyHelper()
    
    func testApiKey() {
        //Verify CL api key validity
        XCTAssertNotNil(currencyHelper.apiKey)
        XCTAssertTrue(currencyHelper.apiKey.count > 30)
    }
    
    func testQuotes() {
        
        //Verify if the quotes are empty
        XCTAssertNil(currencyHelper.quotes())
        
        //Verify LC call and verify if the quotes are well loaded
        let expectation = self.expectation(description: "Download currencies from currencylayer server")
        
        currencyHelper.refresh{ result in
            XCTAssertNotNil(self.currencyHelper.quotes())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        //Convert a total to another currency
        guard let quotes =  self.currencyHelper.quotes() else {
            XCTFail("Expected to get the currency quotes")
            return
        }
        guard let rate =  quotes["USDCAD"] else {
            XCTFail("Expected to get the rate of currency quote USDCAD rate")
            return
        }
        
        XCTAssertEqual(currencyHelper.totalInCurrency(name: "CAD", for: 1), rate, accuracy: 0.1)
        
        //Verify a total in another currency
        let total: Float = 27.99
        let convertedTotal: Float = total * rate
        XCTAssertEqual(currencyHelper.totalInCurrency(name: "CAD", for: total), convertedTotal, accuracy: 0.1)
        
        //Verify total display
        XCTAssertEqual("\(String(format: "%.2f", convertedTotal)) CAD", currencyHelper.display(total: total))
    }
}

