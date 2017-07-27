//
//  OrderItemTableViewCell.swift
//  Resto
//
//  Created by synerzip on 26/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemtotalAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureOrderItemCell(orderItem: OrderItem) {
        let menuItem = orderItem.menuItem
        itemNameLabel.text = menuItem.name
        itemSubtitleLabel.text = "\(orderItem.quantity) items selected"
        itemImageView.image = UIImage(named:menuItem.imagePath) ?? nil
        itemPriceLabel.text = "₹ \(menuItem.price)"
        itemQuantityLabel.text = "x \(orderItem.quantity)"
        itemtotalAmountLabel.text = "₹ \(orderItem.totalAmount)"
    }
}
