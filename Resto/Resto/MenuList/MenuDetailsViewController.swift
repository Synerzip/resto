//
//  MenuDetailsViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 17/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class MenuDetailsViewController: UIViewController {

    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var itemDescriptionText: UITextView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemIngredientsLabel: UILabel!
    @IBOutlet weak var qtyPlusButton: UIButton!
    @IBOutlet weak var qtyMinusButton: UIButton!
    
    var currentMenuItem: MenuItem?
    var suggestedMenuItems = [MenuItem]()
    
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
            itemImageView.image = UIImage(named:menuItem.imagePath) ?? nil
            itemDescriptionText.text = menuItem.description
            itemIngredientsLabel.text = menuItem.ingredients
        }
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
        cell.itemNameLabel.text = suggestedItem.name
        cell.itemImageView.image = UIImage(named: suggestedItem.imagePath) ?? nil
        return cell
    }
}

extension MenuDetailsViewController: MenuListActionDelegate {
    func didSelectItem(menuItem: MenuItem, suggestedItems: [MenuItem], atIndexpath indexPath: IndexPath) {
        currentMenuItem = menuItem
        self.suggestedMenuItems = suggestedItems
        showMenuDetails()
        suggestionsCollectionView.reloadData()
    }
}
