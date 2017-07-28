//
//  OrderItemTableViewCell.swift
//  Resto
//
//  Created by synerzip on 26/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

protocol OrderItemActionDelegate: class {
    func didChangeItem(atIndex index: Int)
    func didItemQuantityBecomeZero(atIndex index: Int)
}

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemtotalAmountLabel: UILabel!
    @IBOutlet weak var qtyPlusButton: UIButton!
    @IBOutlet weak var qtyMinusButton: UIButton!
    @IBOutlet weak var qtySelectionLabel: UILabel!
    
    weak var orderItemActionDelegate: OrderItemActionDelegate?
    var currentIndex = 0
    var selectedItemsCount: Int = 0 {
        didSet {
            qtySelectionLabel.text = "\(selectedItemsCount)"
                let orderItem = AppManager.shared.currentOrder[currentIndex]
                orderItem.quantity = selectedItemsCount
                itemSubtitleLabel.text = "\(selectedItemsCount) items selected"
                itemQuantityLabel.text = "x \(selectedItemsCount)"
                itemtotalAmountLabel.text = "₹ \(orderItem.totalAmount)"
                qtySelectionLabel.text = "\(selectedItemsCount)"
                // Notify Place Order Controller about change in order
                orderItemActionDelegate?.didChangeItem(atIndex: currentIndex)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        qtyPlusButton.layer.cornerRadius = qtyPlusButton.frame.width/2
        qtyMinusButton.layer.cornerRadius = qtyMinusButton.frame.width/2
    }
    
    func configureOrderItemCell(orderItem: OrderItem, index: Int) {
        currentIndex = index
        selectedItemsCount = orderItem.quantity
        let menuItem = orderItem.menuItem
        itemNameLabel.text = menuItem.name
        itemSubtitleLabel.text = "\(orderItem.quantity) items selected"
        itemImageView.image = UIImage(named:menuItem.imagePath) ?? nil
        itemPriceLabel.text = "₹ \(menuItem.price)"
        itemQuantityLabel.text = "x \(orderItem.quantity)"
        itemtotalAmountLabel.text = "₹ \(orderItem.totalAmount)"
        qtySelectionLabel.text = "\(orderItem.quantity)"
    }
    
    @IBAction func qtyMinusButtonAction(sender: UIButton) {
        selectedItemsCount = selectedItemsCount > 0 ?  selectedItemsCount - 1 : 0
        // Remove item from list if its quantity becomes zero
        if selectedItemsCount == 0 {
            orderItemActionDelegate?.didItemQuantityBecomeZero(atIndex: currentIndex)
        }
    }
    
    @IBAction func qtyPlusButtonAction(sender: UIButton) {
        selectedItemsCount = selectedItemsCount < 10 ?  selectedItemsCount + 1 : 10
    }
}
