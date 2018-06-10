//
//  CurrencyHelper.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-08.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//


import Foundation

class CurrencyHelper {
    
    let apiKey : String
    var currency : Currency?
    var selectedCurrency: String = "USD"
    
    init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "CL_APIKey") as! String
    }
    
    func quotes() -> Dictionary<String, Float>? {
        return self.currency?.quotes
    }
    
    func refresh(completionHandler:@escaping (_ result:Dictionary<String, Float>) -> Void) {
        
        let urlString = "http://apilayer.net/api/live?access_key=\(apiKey)"
        guard let url:URL = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.currency = try decoder.decode(Currency.self, from: data)
                
                completionHandler((self.currency?.quotes)!)
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
    }
    
    func all() -> [(key: String, value: Float)] {
        
        var quotes: [(key: String, value: Float)] = []
        for (key, value) in (self.currency?.quotes)! {
            guard key.hasPrefix(selectedCurrency) else { return [] }
            
            quotes.append((key: String(key.dropFirst(selectedCurrency.count)), value: value))
        }
        
        return quotes
    }
    
    func totalInCurrency(name: String, for total: Float) -> Float {
        self.selectedCurrency = name
        guard let rate = currency?.quotes["USD"+name] else { return -1 }
        return total * rate
    }
}

