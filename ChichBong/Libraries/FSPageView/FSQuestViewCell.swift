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
    @IBOutlet weak var questContent: UILabel!
    
    @IBOutlet weak var option1Lbl: UILabel!
    @IBOutlet weak var option2Lbl: UILabel!
    @IBOutlet weak var option3Lbl: UILabel!
    @IBOutlet weak var option4Lbl: UILabel!
    @IBOutlet weak var AseBtn: UIButton!
    @IBOutlet weak var BseBtn: UIButton!
    @IBOutlet weak var CseBtn: UIButton!
    @IBOutlet weak var DseBtn: UIButton!
    
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
        
        [option1Lbl, option2Lbl, option3Lbl, option4Lbl].forEach { (current) in
            //
            current.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    func setContentWeb(content: String) {
        questContent.text = content
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
                selected = "option1"
                option1Lbl.textColor = #colorLiteral(red: 0.8488505483, green: 0.5602982044, blue: 0.1878142655, alpha: 1)
                [option2Lbl, option3Lbl, option4Lbl].forEach { (current) in
                    //
                    current.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }
            } else {
                option1Lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            break
        case 2:
            if button.isSelected {
                selected = "option2"
                option2Lbl.textColor = #colorLiteral(red: 0.8488505483, green: 0.5602982044, blue: 0.1878142655, alpha: 1)
                [option1Lbl, option3Lbl, option4Lbl].forEach { (current) in
                    //
                    current.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }
            } else {
                option2Lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            break
        case 3:
            if button.isSelected {
                selected = "option3"
                option3Lbl.textColor = #colorLiteral(red: 0.8488505483, green: 0.5602982044, blue: 0.1878142655, alpha: 1)
                [option2Lbl, option1Lbl, option4Lbl].forEach { (current) in
                    //
                    current.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }
            } else {
                option3Lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            break
        case 4:
            if button.isSelected {
                selected = "option4"
                option4Lbl.textColor = #colorLiteral(red: 0.8488505483, green: 0.5602982044, blue: 0.1878142655, alpha: 1)
                [option2Lbl, option3Lbl, option1Lbl].forEach { (current) in
                    //
                    current.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }
            } else {
                option4Lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
