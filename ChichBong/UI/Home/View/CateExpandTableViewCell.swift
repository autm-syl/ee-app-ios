//
//  CateExpandTableViewCell.swift
//  ChichBong
//
//  Created by autm on 16/12/2021.
//

import UIKit

class CateExpandTableViewCell: UITableViewCell {
    @IBOutlet weak var detailedLabel: UILabel!
    @IBOutlet weak var customTitleLabel: UILabel!
    @IBOutlet weak var additionButton: UIButton!
//    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImg: UIImageView!
    
    public var additionButtonHidden:Bool = false
    let leadingValueForChildrenCell:CGFloat = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView.init()
        self.selectedBackgroundView!.backgroundColor = .clear
    }
    
    func setupCell(level:Int)
    {
        self.leadingConstraint.constant = leadingValueForChildrenCell * CGFloat(level + 1)
        switch level {
        case 0:
            self.detailedLabel.font = UIFont.systemFont(ofSize: 16)
        case 1:
            self.detailedLabel.font = UIFont.systemFont(ofSize: 12)
        case 2:
            self.detailedLabel.font = UIFont.systemFont(ofSize: 10)
        default:
            self.detailedLabel.font = UIFont.systemFont(ofSize: 10)
        }
        if level > 0 {
            iconImg.isHidden = true
        } else {
            iconImg.isHidden = false
        }
        
        self.layoutIfNeeded()
    }
    
    func getRandomColor() -> UIColor{
        
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
