//
//  DataSavedTableViewCell.swift
//  ChichBong
//
//  Created by autm on 24/12/2021.
//

import UIKit

class DataSavedTableViewCell: UITableViewCell {
    @IBOutlet weak var iconType: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sortDescription: UILabel!
    @IBOutlet weak var timeSave: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        self.isSelected = false
    }
    
}
