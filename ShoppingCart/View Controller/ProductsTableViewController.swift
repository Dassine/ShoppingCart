//
//  ProductsTableViewController.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-04.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, CartDelegate {
    
    fileprivate let products:[Product] = ProductsListHelper().all()
    fileprivate var cart = Cart()
    
    fileprivate let reuseIdentifier = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Workaround to avoid the fadout the right bar button item
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        //Update cart if some items quantity is equal to 0 and reload the product table and right button bar item
        cart.update()
        self.navigationItem.rightBarButtonItem?.title = "Checkout (\(cart.items.count))"
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCart" {
            if let cartViewController = segue.destination as? CartViewController {
                cartViewController.cart = self.cart
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.item]
        
        cell.delegate = self
        cell.nameLabel.text = product.name
        cell.priceLabel.text = String.init(format: "$ %.02f per %@", product.price, product.unit)
        
        cell.setButton(state: self.cart.contains(product: product))
        
        return cell
    }
    
    // MARK: - CartDelegate
    func updateCart(cell: ProductTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let product = products[indexPath.row]
        
        cart.update(product: product)
        
        self.navigationItem.rightBarButtonItem?.title = "Checkout (\(cart.items.count))"
    }
    
}
