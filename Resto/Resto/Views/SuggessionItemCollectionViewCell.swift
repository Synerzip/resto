//
//  SuggessionItemCollectionViewCell.swift
//  Resto
//
//  Created by synerzip on 26/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class SuggessionItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = addButton.frame.width/2
    }
    
    func configureSuggestedItemCell(suggestedItem: MenuItem) {
        itemNameLabel.text = suggestedItem.name
        itemImageView.image = UIImage(named: suggestedItem.imagePath) ?? nil
    }
}
