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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidePlaceOrderButton(status: true)
        registerTableViewCell()
        registerForObservers()
        orderTableView.tableFooterView = UIView()
        displayTotalAmount()
    }
    
    private func registerForObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orderItemChanged), name:NSNotification.Name(rawValue: "orderItemChanged"), object: nil)
    }
    
    private func registerTableViewCell() {
        var nib = UINib(nibName: "OrderItemTableViewCell", bundle: nil)
        orderTableView.register(nib, forCellReuseIdentifier: "OrderItemCell")
        
        nib = UINib(nibName: "SuggessionItemCollectionViewCell", bundle: nil)
        suggestionsCollectionView.register(nib, forCellWithReuseIdentifier: "SuggestionItemCell")
    }
    
    // Observer Selector - update Total amount when order is changed
    @objc func orderItemChanged() {
        displayTotalAmount()
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
        if let homeVC = parent as? HomeViewController {
            homeVC.placeOrderButton.isHidden = false
            homeVC.loadMenuList()
        }
        AppManager.shared.currentOrder.removeAll()
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
        return cell
    }
}

extension PlaceOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionItemCell", for: indexPath) as! SuggessionItemCollectionViewCell
//        let suggestedItem = suggestedMenuItems[indexPath.row]
//        cell.itemNameLabel.text = suggestedItem.name
//        cell.itemImageView.image = UIImage(named: suggestedItem.imagePath) ?? nil
        return cell
    }
}
