//
//  FSQuestViewCell.swift
//  Snolax
//
//  Created by Sylvanas on 6/3/20.
//  Copyright © 2020 Sylvanas. All rights reserved.
//

import UIKit
import WebKit

protocol FSQuestViewCellDelegate {
    func selectedBtn(selected: String, index: Int) -> Void
    func cleanSelect(index: Int) -> Void
}

open class FSQuestViewCell: UICollectionViewCell {
    @IBOutlet weak var nameQuest: UITextView!
    @IBOutlet weak var areaDescription: UIView!
    @IBOutlet weak var heighContraistDescription: NSLayoutConstraint!
    @IBOutlet weak var AseBtn: UIButton!
    @IBOutlet weak var BseBtn: UIButton!
    @IBOutlet weak var CseBtn: UIButton!
    @IBOutlet weak var DseBtn: UIButton!
    @IBOutlet weak var contentWebView: WKWebView!
    @IBOutlet weak var contentHeightContraints: NSLayoutConstraint!
    
    open var indexQuest:Int = 0;
    var delegate: FSQuestViewCellDelegate?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // set shadow
//        AseBtn.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
//        BseBtn.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
//        CseBtn.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
//        DseBtn.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
    }
    
    open func clean(){
        AseBtn.isSelected = false;
        BseBtn.isSelected = false;
        CseBtn.isSelected = false;
        DseBtn.isSelected = false;
    }
    
    func setContentWeb(content: String) {
        contentWebView.scrollView.isScrollEnabled = true
//        contentWebView.navigationDelegate = self
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title></title></head><body>\(content)</body></html>"
        contentWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }

    @IBAction func ChoosedBtnClicked(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        [AseBtn, BseBtn, CseBtn, DseBtn].forEach { (currentBtn) in
            //
            if (currentBtn != button){
                currentBtn!.isSelected = false;
                print("false")
            } else {
                print("no day")
            }
        }
        
        if button.isSelected {
            button.isSelected = false
        } else {
            button.isSelected = true
        }
        
        var selected:String? = nil;

        switch button.tag {
        case 1:
            // Change to English
            if button.isSelected {
                selected = AseBtn.titleLabel?.text
            }
            break
        case 2:
            if button.isSelected {
                selected = BseBtn.titleLabel?.text
            }
            break
        case 3:
            if button.isSelected {
                selected = CseBtn.titleLabel?.text
            }
            break
        case 4:
            if button.isSelected {
                selected = DseBtn.titleLabel?.text
            }
            break
        default:
            print("Unknown language")
            return
        }
        
        if selected == nil {
            delegate?.cleanSelect(index: self.indexQuest)
        } else {
            delegate?.selectedBtn(selected: selected!, index: self.indexQuest)
        }
        
    }
}
