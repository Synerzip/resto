//
//  PlaceOrderViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 18/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class PlaceOrderViewController: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    var suggestedItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidePlaceOrderButton(status: true)
        registerTableViewCell()
        orderTableView.tableFooterView = UIView()
        
        suggestedItems = getSuggestedItems()
        suggestionsCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayTotalAmount()
    }
    
    private func registerTableViewCell() {
        var nib = UINib(nibName: "OrderItemTableViewCell", bundle: nil)
        orderTableView.register(nib, forCellReuseIdentifier: "OrderItemCell")
        
        nib = UINib(nibName: "SuggessionItemCollectionViewCell", bundle: nil)
        suggestionsCollectionView.register(nib, forCellWithReuseIdentifier: "SuggestionItemCell")
    }
    
    private func displayTotalAmount() {
        var total = 0
        for orderItem in AppManager.shared.currentOrder {
            total = total + orderItem.totalAmount
        }
        totalAmountLabel.text = "₹ \(total)"
    }
    
    private func hidePlaceOrderButton(status: Bool) {
        if let homeVC = parent as? HomeViewController {
            homeVC.placeOrderButton.isHidden = status
        }
    }
    
    @IBAction func cancelOrderButtonAction(_ sender: Any) {
        dismissController()
    }
    
    @IBAction func confirmOrderButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Resto", message: "Your Order has been Confirmed and It will be served Soon. Thanks!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismissController()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func dismissController() {
        if let homeVC = parent as? HomeViewController {
            homeVC.placeOrderButton.isHidden = false
            homeVC.loadMenuList()
        }
        AppManager.shared.currentOrder.removeAll()
    }
    
    func getSuggestedItems() -> [MenuItem] {
        let menuItems = AppManager.shared.menuItemList
        var suggestedItems = [MenuItem]()
        if menuItems.count > 0 {
            while suggestedItems.count < 3 {
                let randomNo = Utilities.randomNumber(MIN: 0, MAX: menuItems.count - 1)
                let item = menuItems[randomNo]
                //Do not repeat the sugession item and Existing Prdered Items
                let isItemPresentInSuggession = suggestedItems.contains(where: { menuItem in menuItem.name == item.name })
                let isItemPresentInOrder = AppManager.shared.currentOrder.contains(where: { orderItem in orderItem.menuItem.name == item.name })
                if !isItemPresentInSuggession && !isItemPresentInOrder {
                    suggestedItems.append(item)
                }
            }
        }
        return suggestedItems
    }
}

extension PlaceOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppManager.shared.currentOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemTableViewCell
        let orderItem = AppManager.shared.currentOrder[indexPath.row]
        cell.configureOrderItemCell(orderItem: orderItem, index: indexPath.row)
        cell.orderItemActionDelegate = self
        return cell
    }
}

extension PlaceOrderViewController: OrderItemActionDelegate {
    func didItemQuantityBecomeZero(atIndex index: Int) {
        AppManager.shared.currentOrder.remove(at: index)
        orderTableView.reloadData()
    }
    
    func didChangeItem(atIndex index: Int) {
       displayTotalAmount()
    }
}

extension PlaceOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionItemCell", for: indexPath) as! SuggessionItemCollectionViewCell
        let suggestedItem = suggestedItems[indexPath.row]
        cell.configureSuggestedItemCell(suggestedItem: suggestedItem)
        cell.addButton.isHidden = false
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(collectionCellAddButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func collectionCellAddButtonAction(sender: UIButton) {
        // Add Current menu item to current order
        let menuItem = suggestedItems[sender.tag]
        let orderItem = OrderItem(menuItem: menuItem, quantity: 1)
        AppManager.shared.currentOrder.append(orderItem)
        orderTableView.reloadData()
        
        // Remove selected item from suggession
        suggestedItems.remove(at: sender.tag)
        suggestionsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let menuPreviewVC = self.storyboard?.instantiateViewController(withIdentifier: "menuPreview") as? MenuPreviewViewController {
            present(menuPreviewVC, animated: true, completion: nil)
        }
    }
}
