//
//  CartViewController.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-08.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, CartItemDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cart: Cart? = nil
    var quotes : [(key: String, value: Float)] = []
    let currencyHelper = CurrencyHelper()
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    fileprivate let apiKey = Bundle.main.object(forInfoDictionaryKey: "CL_APIKey") as! String
    
    let prefix = "USD"
    var selectedCurrency: String = ""
    
    fileprivate let reuseIdentifier = "CartItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        selectedCurrency  = prefix
        totalLabel.text = (cart?.total.description)! + " " + selectedCurrency
        
        currencyHelper.refresh() { result in
            
            DispatchQueue.main.async(execute: {
                for (key, value) in result {
                    guard key.hasPrefix(self.prefix) else { return }
                    
                    self.quotes.append((key: String(key.dropFirst(self.prefix.count)), value: value))
                }
                self.currencyPickerView.reloadAllComponents()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshCurrency() {
        
        let urlString = "http://apilayer.net/api/live?access_key=\(apiKey)"
        guard let url:URL = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Currency.self, from: data)
                    
                    DispatchQueue.main.async(execute: {
                        for (key, value) in data.quotes{
                            guard key.hasPrefix(self.prefix) else { return }
                            
                            self.quotes.append((key: String(key.dropFirst(self.prefix.count)), value: value))
                        }
                        self.currencyPickerView.reloadAllComponents()
                    })
                    
                } catch let err {
                    print("Err", err)
                }
                }.resume()
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (cart?.items.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CartItemTableViewCell
        
        if let cartItem = cart?.items[indexPath.item] {
            cell.delegate = self
            
            cell.nameLabel.text = cartItem.product.name
            cell.priceLabel.text = String.init(format: "$ %.02f per %@", cartItem.product.price, cartItem.product.unit)
            cell.quantityLabel.text =  String(describing: cartItem.quantity)
            cell.quantity = cartItem.quantity
        }
        
        return cell
    }
    
    // MARK - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quotes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return quotes[row].key + " " + quotes[row].value.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = quotes[row].key
        let newTotal = ((cart?.total)! * quotes[row].value)
        totalLabel.text = String(format: "%.2f", newTotal) + " " + selectedCurrency
    }
    
    // MARK: - CartItemDelegate
    func updateCartItem(cell: CartItemTableViewCell, quantity: Int) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let cartItem = cart?.items[indexPath.row] else { return }
        
        cartItem.quantity = quantity
        
        totalLabel.text = (cart?.total.description)! + " " + selectedCurrency
    }
    
    
}
