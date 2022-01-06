//
//  RootCategoryCollectionViewCell.swift
//  ChichBong
//
//  Created by autm on 02/01/2022.
//

import UIKit

class RootCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainContent: UIView!
    @IBOutlet weak var cateIcon: UIImageView!
    @IBOutlet weak var cateName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // corner radius
        mainContent.layer.cornerRadius = 8
        
        // shadow
        mainContent.layer.shadowColor = UIColor.black.cgColor
        mainContent.layer.shadowOffset = CGSize(width: 1, height: 1)
        mainContent.layer.shadowOpacity = 0.7
        mainContent.layer.shadowRadius = 2.0
    }
}
