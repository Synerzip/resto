//
//  MenuItemTableViewCell.swift
//  Resto
//
//  Created by synerzip on 25/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureMenuItemCell(menuItem: MenuItem) {
        itemNameLabel.text = menuItem.name
        itemPriceLabel.text = "₹ \(menuItem.price)"
        itemQuantityLabel.text = menuItem.quantity == 0 ? "" : "\(menuItem.quantity) Selected"
        if let image = UIImage(named: menuItem.imagePath) {
            itemImageView.image = image
        }
    }
}

