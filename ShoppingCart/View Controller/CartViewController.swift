//
//  CartViewController.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-08.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    @IBOutlet weak var cartStateLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var cart: Cart? = nil
    var quotes : [(key: String, value: Float)] = []
    let currencyHelper = CurrencyHelper()
    
    
    fileprivate let apiKey = Bundle.main.object(forInfoDictionaryKey: "CL_APIKey") as! String
    fileprivate let reuseIdentifier = "CartItemCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Show the acitvity indicator
        showActivityIndicator()
        
        //Fill PickerView components
        //Get asynchronisly component on a background thread
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
            self.currencyHelper.refresh() { result in
                //Update picker on main thread
                DispatchQueue.main.async(execute: {
                    //reload the picket view with the new quotes
                    self.quotes = self.currencyHelper.all()
                    self.currencyPickerView.reloadAllComponents()
                    
                    //Update Cart Total lale
                    self.totalLabel.text = (self.cart?.total.description)! + " " + self.currencyHelper.selectedCurrency
                    
                    self.hideActivityIndicator()
                })
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActivityIndicator() {
        //Hide the view components
        tableView.alpha = 0
        totalView.alpha = 0
        cartStateLabel.alpha = 0
        
        //Start the indicator
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        //Animate the cart view display
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            
            //show the view components
            self.tableView.alpha = 1
            self.totalView.alpha = 1
            self.cartStateLabel.alpha = self.cart?.items.count == 0 ? 1 : 0
            
            //Stop the activity indicator
            self.activityIndicatorView.stopAnimating()
        }, completion: nil)
    }
}
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.delegate = self as CartItemDelegate
            
            cell.nameLabel.text = cartItem.product.name
            cell.priceLabel.text = cartItem.product.displayPrice()
            cell.quantityLabel.text = String(describing: cartItem.quantity)
            cell.quantity = cartItem.quantity
        }
        
        return cell
    }
}

extension CartViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        if !quotes.isEmpty {
            //Update selectedCurrency
            currencyHelper.selectedCurrency = quotes[row].key
            
            //Update displayed cart total
            guard let total = cart?.total else { return }
            totalLabel.text = currencyHelper.display(total: total)
        }
    }
}

extension CartViewController: CartItemDelegate {
    
    // MARK: - CartItemDelegate
    func updateCartItem(cell: CartItemTableViewCell, quantity: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let cartItem = cart?.items[indexPath.row] else { return }
        
        //Update cart item quantity
        cartItem.quantity = quantity
        
        //Update displayed cart total
        guard let total = cart?.total else { return }
        totalLabel.text = currencyHelper.display(total: total)
    }
    
}
