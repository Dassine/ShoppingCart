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
    
    init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "CL_APIKey") as! String
    }
    
    func all() -> Dictionary<String, Float>? {
        return self.currency?.quotes
    }
    
    func refresh(completionHandler:@escaping (_ result:Dictionary<String, Float>) -> Void) {
        
        let urlString = "http://apilayer.net/api/live?access_key=\(apiKey)"
        guard let url:URL = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
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
        })
    }
}
