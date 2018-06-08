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
    
    @IBOutlet weak var checkoutBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
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
        
        cell.delegate = self
        cell.nameLabel.text = products[indexPath.item].name
        cell.priceLabel.text = String.init(format: "$ %.02f per %@", products[indexPath.item].price, products[indexPath.item].unit)

        return cell
    }
    
    
    // MARK: - CartDelegate
    func updateCart(cell: ProductTableViewCell) {
        
        guard  let indexPath = tableView.indexPath(for: cell)  else { return }
        let product = products[indexPath.row]
        
        if !cart.contains(product: product) {
            cart.add(product: product)
        } else {
            cart.remove(product: product)
        }
        
        checkoutBarButton.title = "Checkout (\(cart.items.count))"
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
