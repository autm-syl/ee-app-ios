//
//  FirstViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/19/21.
//

import UIKit
import SVProgressHUD
import Toast_Swift

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var thumImg: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var guestJoinBtn: UIButton!
    
    var popTipView:CMPopTipView? = nil;
    var phoneNum:String = ""
    
    let loginViewDataData = LoginViewDataData.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumImg.layer.cornerRadius = 8.0
        phoneField.layer.cornerRadius = 8.0
        passwordField.layer.cornerRadius = 8.0
        nextBtn.layer.cornerRadius = 8.0
        registerBtn.layer.cornerRadius = 8.0
        guestJoinBtn.layer.cornerRadius = 8.0
        
        phoneField.setLeftPaddingPoints(10)
        phoneField.delegate = self
        phoneField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        passwordField.setLeftPaddingPoints(10)
        passwordField.delegate = self
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        // create nsattributed
        descriptionTxt.delegate = self
        descriptionTxt.isEditable = false
        descriptionTxt.isSelectable = true
        descriptionTxt.isUserInteractionEnabled = true
        let attributedString = NSMutableAttributedString(string: "Bằng cách bấm tiếp tục.\nTôi đồng ý với Điều khoản sử dụng của Indust3")
        attributedString.addAttribute(.link, value: "https://www.google.com", range: NSRange(location: 39, length: 10))
        let font = UIFont.systemFont(ofSize: 13)
        let attributes = [NSAttributedString.Key.font: font]
        attributedString.addAttributes(attributes, range: NSRange(location: 39, length: 10))

        descriptionTxt.attributedText = attributedString
    }
    
    @IBAction func cleanUsernameField(_ sender: Any) {
        self.phoneField.text = ""
    }
    
    @IBAction func cleanPassField(_ sender: Any) {
        self.passwordField.text = ""
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        let phone = phoneField.text
        phoneNum = phone!
        
        let pass = passwordField.text
        self.view.endEditing(true)
        
        if (phoneNum == "") {
            // nothing
            self.ShowBottomToastWith(mess: "Bạn chưa nhập tên đăng nhập!", messColor: UIColor.red)
            return;
        } else {
            if pass == "" {
                self.ShowBottomToastWith(mess: "Bạn chưa nhập mật khẩu!", messColor: UIColor.red)
                return;
            }
            SVProgressHUD.show()
            loginViewDataData.login(username: phoneNum, pass: pass!) { [self] user, error in
                SVProgressHUD.dismiss()
                if user != nil {
                    // login success
                    Globalvariables.shareInstance.token_auth = user!.Token
                    Globalvariables.shareInstance.setTokenAuth(token: user!.Token)
                    Globalvariables.shareInstance.setUserName(username: phoneNum)
                    NotificationCenter.default.post(name:.goIntoApp, object: nil);
                } else {
                    // login false
                    self.ShowBottomToastWith(mess: (error?.mErrorMessage)!, messColor: UIColor.red)
                }
            }
            
        }
    }
    @IBAction func registerBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.introNextPage, object: nil);
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
        if textField == phoneField {
            let phone = textField.text
            if (phone == "") {
                notifyError(field: textField, message: "Bạn chưa nhập tên đăng nhập!")
                return;
            }
        }
        if textField == passwordField {
            let pass = textField.text
            if (pass == "") {
                notifyError(field: textField, message: "Bạn chưa nhập mật khẩu!")
                return;
            }
        }
    }
    @IBAction func guestJoinBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.goIntoApp, object: nil);
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        return;
    }
    
    
    private func notifyError(field: UITextField, message: String) {
        popTipView = CMPopTipView.init(title: "Chú ý", message: message)
        
        popTipView!.delegate = self;
        
        let backgroundColor = #colorLiteral(red: 0.6911440492, green: 0.6336520314, blue: 0.4580065012, alpha: 1);
        popTipView!.backgroundColor = backgroundColor;
        popTipView!.textColor = UIColor.white;
        
        popTipView!.animation = CMPopTipAnimation.init(rawValue: 1)!
        popTipView!.has3DStyle = true;
        
        popTipView!.dismissTapAnywhere = true;
        popTipView!.autoDismiss(animated: true, atTimeInterval: 8);
        
        popTipView!.presentPointing(at: field, in: self.view, animated: true)
    }
    
    func ShowBottomToastWith(mess: String, messColor: UIColor) {
        var style = ToastStyle()
        style.messageColor = messColor
        
        if let keyWindow = UIWindow.key {
            // Do something
            keyWindow.makeToast(mess, duration: 10.0, position: .center, title: "Đăng nhập thất bại", image: nil, style: style, completion: nil)
            ToastManager.shared.isTapToDismissEnabled = true
            ToastManager.shared.isQueueEnabled = true
        }
    }
}


extension FirstViewController: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        self.popTipView = nil;
    }
}

extension FirstViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // open 
//        UIApplication.shared.open(URL)
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "https://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights"
        newsController.headerTitleSet = "Điều khoản & điều kiện"
        self.present(newsController, animated: true, completion: nil)
        return false
    }
}

import ObjectMapper

class CheckExistResult: Mappable {
    var exist:Bool = false
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        exist <- map["Data.Exist"]
    }
}


class SystemConfigResult: Mappable {
    var configs:[SystemConfigObj] = []
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        configs <- map["Data.Configs"]
    }
}


class SystemConfigObj: Mappable {
    var Id = 0
    var Key_name = ""
    var Value_config = ""
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        Id <- map["Id"]
        Key_name <- map["Key_name"]
        Value_config <- map["Value_config"]
    }
}
