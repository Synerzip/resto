//
//  MenuDetailsViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 17/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

protocol MenuDetailsActionDelegate: class {
    func didChangeItemQuantity(menuItem: MenuItem, quantity: Int, atIndexpath indexPath: IndexPath)
    func didSelectSuggestedItem(menuItem: MenuItem)
}

class MenuDetailsViewController: UIViewController {

    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var itemDescriptionText: UITextView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemIngredientsLabel: UILabel!
    @IBOutlet weak var qtyPlusButton: UIButton!
    @IBOutlet weak var qtyMinusButton: UIButton!
    @IBOutlet weak var selectedItemCountLabel: UILabel!
    
    var currentMenuItem: MenuItem?
    var suggestedMenuItems = [MenuItem]()
    weak var menuDetailsActionDelegate: MenuDetailsActionDelegate?
    var selectedIndexPath: NSIndexPath!
    
    var selectedItemsCount: Int = 0 {
        didSet {
            selectedItemCountLabel.text = "\(selectedItemsCount)"
            menuDetailsActionDelegate?.didChangeItemQuantity(menuItem: currentMenuItem!, quantity: selectedItemsCount, atIndexpath: selectedIndexPath as IndexPath)
            if selectedItemsCount != 0 {
                changeOrder()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate for MenuList actions
        let masterVC = (self.splitViewController!.viewControllers.first as! UINavigationController).topViewController as! MenuTableViewController
        masterVC.menuListActionDelegate = self
        
        configureView()
        registerCollectionViewCell()
        showMenuDetails()
    }
    
    private func configureView() {
        qtyPlusButton.layer.cornerRadius = qtyPlusButton.frame.width/2
        qtyMinusButton.layer.cornerRadius = qtyMinusButton.frame.width/2
    }
    
    private func registerCollectionViewCell() {
        let nib = UINib(nibName: "SuggessionItemCollectionViewCell", bundle: nil)
        suggestionsCollectionView.register(nib, forCellWithReuseIdentifier: "SuggestionItemCell")
    }
    
    private func showMenuDetails() {
        if let menuItem = currentMenuItem {
            itemNameLabel.text = menuItem.name
            itemImageView.layer.borderWidth = 1.0
            itemImageView.layer.borderColor = UIColor.lightGray.cgColor
            itemImageView.image = UIImage(named:menuItem.imagePath) ?? nil
            itemDescriptionText.text = menuItem.description
            itemIngredientsLabel.text = menuItem.ingredients
            selectedItemsCount = menuItem.quantity
        }
    }
    
    private func changeOrder() {
        var itemFound = false
        for orderItem in AppManager.shared.currentOrder {
            if orderItem.menuItem.name == currentMenuItem!.name {
                orderItem.quantity = selectedItemsCount
                itemFound = true
                break
            }
        }
        if !itemFound {
            let orderItem = OrderItem(menuItem: currentMenuItem!, quantity: selectedItemsCount)
            AppManager.shared.currentOrder.append(orderItem)
        }
    }
    
    @IBAction func qtyPlusButtonAction(sender: UIButton) {
        selectedItemsCount = selectedItemsCount < 10 ?  selectedItemsCount + 1 : 10
    }
    
    @IBAction func qtyMinusButtonAction(sender: UIButton) {
        selectedItemsCount = selectedItemsCount > 0 ?  selectedItemsCount - 1 : 0
    }
}

extension MenuDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionItemCell", for: indexPath) as! SuggessionItemCollectionViewCell
        let suggestedItem = suggestedMenuItems[indexPath.row]
        cell.configureSuggestedItemCell(suggestedItem: suggestedItem)
        cell.addButton.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = suggestedMenuItems[indexPath.row]
        currentMenuItem = menuItem
        menuDetailsActionDelegate?.didSelectSuggestedItem(menuItem: menuItem)
    }
}

extension MenuDetailsViewController: MenuListActionDelegate {
    func didSelectItem(menuItem: MenuItem, suggestedItems: [MenuItem], atIndexpath indexPath: IndexPath) {
        currentMenuItem = menuItem
        self.suggestedMenuItems = suggestedItems
        selectedIndexPath = indexPath as NSIndexPath
        showMenuDetails()
        suggestionsCollectionView.reloadData()
    }
}
