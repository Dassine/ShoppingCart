//
//  ProductTableViewCell.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-04.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

protocol CartDelegate {
    func updateCart(cell: ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var delegate: CartDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addToCartButton.layer.cornerRadius = 5
        addToCartButton.clipsToBounds = true
    }
    
    func setButton(state: Bool) {
        addToCartButton.isSelected = state
        addToCartButton.backgroundColor = (!addToCartButton.isSelected) ? .black : .red
    }
    
    @IBAction func addToCart(_ sender: Any) {
        setButton(state: !addToCartButton.isSelected)
        self.delegate?.updateCart(cell: self)
    }
}
