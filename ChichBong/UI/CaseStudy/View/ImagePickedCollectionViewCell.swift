//
//  ImagePickedCollectionViewCell.swift
//  ChichBong
//
//  Created by autm on 10/01/2022.
//

import UIKit
protocol ImagePickedCollectionViewCellDelegate:AnyObject {
    func wantToPickImage(thisCell: UICollectionViewCell)
}

class ImagePickedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var addmoreBtn: UIButton!
    
    weak var delegate:ImagePickedCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImagePreview(imageUrl: String) {
        if imageUrl == "" {
            self.previewImg.isHidden = true;
            self.addmoreBtn.isHidden = false;
        } else {
            self.previewImg.isHidden = false;
            self.addmoreBtn.isHidden = true;
            
            let imageDefault = #imageLiteral(resourceName: "not_finishIcon")
            self.previewImg.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: imageDefault, options: .progressiveLoad, progress: nil, completed: nil)
        }
    }
    @IBAction func addImageBtnClicked(_ sender: Any) {
        delegate?.wantToPickImage(thisCell: self)
    }
    
}
