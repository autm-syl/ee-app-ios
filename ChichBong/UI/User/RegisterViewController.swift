//
//  RegisterViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/5/21.
//

import UIKit
import SVProgressHUD

class RegisterViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentRegister: UISegmentedControl!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var repassField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var fbContentView: UIView!
    
    var popTipView:CMPopTipView? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
   
    @IBAction func segmentDidChangeed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
                case 0:
                    //mac dinh tat ca
                    userNameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    userNameField.isUserInteractionEnabled = true;
                    phoneLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    phoneField.isUserInteractionEnabled = true;
                    break;
                case 1:
                    // dung user name
                    phoneLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    phoneField.isUserInteractionEnabled = false;
                    
                    userNameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    userNameField.isUserInteractionEnabled = true;
                    
                    break;
                case 2:
                    // dung sdt
                    userNameLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    userNameField.isUserInteractionEnabled = false;
                    
                    phoneLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    phoneField.isUserInteractionEnabled = true;
                    break;
                default:
                    userNameLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    userNameField.isUserInteractionEnabled = true;
                    phoneLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    phoneField.isUserInteractionEnabled = true;
                    break;
                }
    }
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        
    }
    @IBAction func backbtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension RegisterViewController: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        self.popTipView = nil;
    }
}

extension RegisterViewController {
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

class RegisterResult: Mappable {
    var token:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        token <- map["Data"]
    }
}
