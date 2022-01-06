//
//  QACollectionViewCell.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import UIKit

protocol QACollectionViewCellDelegate: AnyObject {
    func readMoreBtnClicked(index: Int)
}

class QACollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var createByLbl: UILabel!
    @IBOutlet weak var createAtLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var moreBtnLbl: UIButton!
    @IBOutlet weak var contentHeightConstraints: NSLayoutConstraint!
    
    var thisCellIndex:Int = -1
    weak var delegate:QACollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func moreBtnClicked(_ sender: Any) {
        delegate?.readMoreBtnClicked(index: thisCellIndex)
    }
    
}
