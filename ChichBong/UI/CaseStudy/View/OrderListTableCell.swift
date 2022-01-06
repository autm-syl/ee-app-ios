//
//  CartTableCell.swift
//  ChichBong
//
//  Created by Sylvanas on 4/5/21.
//

import UIKit

protocol OrderListTableCellDelegate: AnyObject {
    func readmoreCaseStudy(index: Int)
}

class OrderListTableCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var createByandAtLbl: UILabel!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var sortContent: UILabel!
    @IBOutlet weak var readmoreBtn: UIButton!
    @IBOutlet weak var contentHeightConstraints: NSLayoutConstraint!
    
    var thisCellIndex:Int = -1
    
    weak var delegate:OrderListTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func readmoreBtnClicked(_ sender: Any) {
        delegate?.readmoreCaseStudy(index: thisCellIndex)
    }
}
