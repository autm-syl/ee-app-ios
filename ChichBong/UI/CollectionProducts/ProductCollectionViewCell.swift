//
//  ProductCollectionViewCell.swift
//  ChichBong
//
//  Created by Sylvanas on 4/12/21.
//

import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    /// true = add, false = remove
    func addItemToFavorite(item_id: Int, addOrRemvoe: Bool)
}

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var wishBtn: UIButton!
    @IBOutlet weak var thumbview: UIView!
    @IBOutlet weak var descripProduct: UILabel!
    
    weak var delegate:ProductCollectionViewCellDelegate?
    open var itemId:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        
        thumbview.layer.cornerRadius = 6.0
        thumbview.layer.borderColor = #colorLiteral(red: 0.9487996697, green: 0.9529433846, blue: 0.9569553733, alpha: 1)
        thumbview.layer.borderWidth = 1.0
    }
    
    @IBAction func wishBtnClicked(_ sender: Any) {
        if (sender as! UIButton).isSelected == true {
            delegate?.addItemToFavorite(item_id: itemId, addOrRemvoe: false)
            wishBtn.isSelected = false;
            wishBtn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        } else {
            delegate?.addItemToFavorite(item_id: itemId, addOrRemvoe: true)
            wishBtn.isSelected = true;
            wishBtn.tintColor = #colorLiteral(red: 0.2446359098, green: 0.7584707737, blue: 0.7399889827, alpha: 1);
        }
    }
}
