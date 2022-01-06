//
//  ProfileTableViewCell.swift
//  ChichBong
//
//  Created by Sylvanas on 4/20/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var detailCell: UILabel!
    @IBOutlet weak var notiState: UISwitch!
    @IBOutlet weak var extensionBtn: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var iconsmall: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkIsTokenPushNotify()
    }
    
    func checkIsTokenPushNotify() {
        if (Globalvariables.shareInstance.push_token == "") {
            notiState.isOn = false
            notiState.isEnabled = true;
        } else {
            notiState.isOn = true;
        }
    }
    
    @IBAction func notifySwitched(_ sender: UISwitch) {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected states
        if (selected == true) {
            setSelected(false, animated: false)
        }
    }
    
    func setTypeOfCell(type: Int) {
        switch type {
        case 0:
            detailCell.isHidden = false
            notiState.isHidden = true
            extensionBtn.isHidden = false
            break
        case 1:
            detailCell.isHidden = true
            notiState.isHidden = false
            extensionBtn.isHidden = true
            break
        case 2, 3, 4, 5, 6:
            detailCell.isHidden = true
            notiState.isHidden = true
            extensionBtn.isHidden = false
            break
        default:
            //
            detailCell.isHidden = true
            notiState.isHidden = true
            extensionBtn.isHidden = false
            break
        }
    }
    
}
