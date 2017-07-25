//
//  MenuDetailsViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 17/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class MenuDetailsViewController: UIViewController {

    @IBOutlet weak var SuggestionsCollectionView: UICollectionView!
    @IBOutlet weak var itemDescriptionText: UITextView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var qtyPlusButton: UIButton!
    @IBOutlet weak var qtyMinusButton: UIButton!
    
    var currentMenuItem: MenuItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        showMenuDetails()
    }
    
    private func configureView() {
        qtyPlusButton.layer.cornerRadius = qtyPlusButton.frame.width/2
        qtyMinusButton.layer.cornerRadius = qtyMinusButton.frame.width/2
    }
    
    private func showMenuDetails() {
        if let menuItem = currentMenuItem {
            itemNameLabel.text = menuItem.name
            itemImageView.image = UIImage(named:menuItem.imagePath) ?? nil
        }
    }
}

extension MenuDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCollectionViewCell", for: indexPath)
        //configure cell
        return cell
    }
}
