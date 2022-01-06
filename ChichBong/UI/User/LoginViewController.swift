//
//  LoginViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/5/21.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentLogin: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var fbContentView: UIView!
    
    var popTipView:CMPopTipView? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func segmentDidchanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
                case 0:
                    phoneNumLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    phoneNumField.isUserInteractionEnabled = false;
                    
                    usernameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    usernameField.isUserInteractionEnabled = true;
                    break;
                case 1:
                    usernameLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    usernameField.isUserInteractionEnabled = false;
                    
                    phoneNumLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    phoneNumField.isUserInteractionEnabled = true;
                    break;
                default:
                    usernameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    usernameField.isUserInteractionEnabled = true;
                    
                    phoneNumLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    phoneNumField.isUserInteractionEnabled = true;
                    break;
                }
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension LoginViewController: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        self.popTipView = nil;
    }
}

extension LoginViewController {
    // private warning function
    private func notifyError(field: UITextField, message: String) {
        popTipView = CMPopTipView.init(title: "Lỗi", message: message)
        
        popTipView!.delegate = self;
        
        let backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1);
        popTipView!.backgroundColor = backgroundColor;
        popTipView!.textColor = UIColor.white;
        
        popTipView!.animation = CMPopTipAnimation.init(rawValue: 1)!
        popTipView!.has3DStyle = true;
        
        popTipView!.dismissTapAnywhere = true;
        popTipView!.autoDismiss(animated: true, atTimeInterval: 8);
        
        popTipView!.presentPointing(at: field, in: self.view, animated: true)
    }
     
}


import ObjectMapper

class LoginResult: Mappable {
    var token:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        token <- map["Data"]
    }
}
