//
//  SecondViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/19/21.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager
import OneSignal
import Toast_Swift

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    var popTipView:CMPopTipView? = nil;
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var repassField: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var registerBtn: UIButton!
    
    let regsterViewDataData = LoginViewDataData.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.layer.cornerRadius = 8.0
        passField.layer.cornerRadius = 8.0
        repassField.layer.cornerRadius = 8.0
        registerBtn.layer.cornerRadius = 8.0
        
        userNameField.setLeftPaddingPoints(10)
        userNameField.delegate = self
        userNameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        passField.setLeftPaddingPoints(10)
        passField.delegate = self
        passField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        repassField.setLeftPaddingPoints(10)
        repassField.delegate = self
        repassField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        // create nsattributed
        let TERM_CONDITION = "\(Config.BASE_URL_STATIC)\(Config.PATH_TERM_CONDITION)"
        
        descriptionTxt.delegate = self
        descriptionTxt.isEditable = false
        descriptionTxt.isSelectable = true
        descriptionTxt.isUserInteractionEnabled = true
        let attributedString = NSMutableAttributedString(string: "Bằng cách bấm tiếp tục.\nTôi đồng ý với Điều khoản sử dụng của EVNBOOK")
        attributedString.addAttribute(.link, value: TERM_CONDITION, range: NSRange(location: 39, length: 10))
        let font = UIFont.systemFont(ofSize: 13)
        let attributes = [NSAttributedString.Key.font: font]
        attributedString.addAttributes(attributes, range: NSRange(location: 39, length: 10))

        descriptionTxt.attributedText = attributedString

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
  
    
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true;
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
   
    
    @IBAction func backBtnCicked(_ sender: Any) {
        NotificationCenter.default.post(name:.introBackPage, object: nil);
    }
    @IBAction func registerBtnClicked(_ sender: Any) {
        let username = userNameField.text
        if (username == "") {
            self.ShowBottomToastWith(mess: "Bạn chưa nhập tên đăng nhập!", messColor: UIColor.red)
            return
        }
        let pass = passField.text
        if (pass == "") {
            self.ShowBottomToastWith(mess: "Bạn chưa nhập mật khẩu!", messColor: UIColor.red)
            return
        }
        let repass = repassField.text
        if (repass != pass) {
            self.ShowBottomToastWith(mess: "Mật khẩu không trùng nhau!", messColor: UIColor.red)
            return
        }
        
        SVProgressHUD.show()
        regsterViewDataData.register(username: username!, pass: pass!) { [self] user, error in
            
            if user != nil {
                // login success
                Globalvariables.shareInstance.token_auth = user!.Token
                Globalvariables.shareInstance.setTokenAuth(token: user!.Token)
                Globalvariables.shareInstance.setUserName(username: username!)
                
                
                self.getMyInformation { success in
                    //
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name:.goIntoApp, object: nil);
                }
            } else {
                // login false
                SVProgressHUD.dismiss()
                self.ShowBottomToastWith(mess: (error?.mErrorMessage)!, messColor: UIColor.red)
            }
            
        }
    }
    
    // MARK: -
    private
    func getMyInformation( completion: @escaping(Bool) -> Void) {
        MonConnection.requestCustom(APIRouter.me) { result, error in
            //
            if error != nil {
                completion(false)
                return;
            }
            
            let user = UserResult.init(JSON: result!)
            
            if user!.message == "Success" {
                Globalvariables.shareInstance.thisUserOnDevice = user!.user
                completion(true)
                return;
            } else {
                completion(false)
                return;
            }
        }
    }
    
    
    @IBAction func cleanUsernameField(_ sender: Any) {
        self.userNameField.text = ""
    }
    @IBAction func cleanPassField(_ sender: Any) {
        self.passField.text = ""
    }
    @IBAction func cleanRepassField(_ sender: Any) {
        self.repassField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
        if textField == userNameField {
            let phone = textField.text
            if (phone == "") {
                notifyError(field: textField, message: "Bạn chưa nhập tên đăng nhập!")
                return;
            }
        }
        if textField == passField {
            let pass = textField.text
            if (pass == "") {
                notifyError(field: textField, message: "Bạn chưa nhập mật khẩu!")
                return;
            }
        }
        
        if textField == repassField {
            let repass = textField.text
            if (repass == "") {
                notifyError(field: textField, message: "Mật khẩu không trùng nhau!")
                return;
            }
            
            if repass != passField.text {
                notifyError(field: textField, message: "Mật khẩu không trùng nhau!")
                return;
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        return;
    }

    private func notifyError(field: UITextField, message: String) {
        popTipView = CMPopTipView.init(title: "Chú ý", message: message)
        
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
    
  
    func ShowBottomToastWith(mess: String, messColor: UIColor) {
        var style = ToastStyle()
        style.messageColor = messColor
        
        if let keyWindow = UIWindow.key {
            // Do something
            keyWindow.makeToast(mess, duration: 10.0, position: .center, title: "Đăng ký thất bại", image: nil, style: style, completion: nil)
            ToastManager.shared.isTapToDismissEnabled = true
            ToastManager.shared.isQueueEnabled = true
        }
    }
}

extension SecondViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // open
//        UIApplication.shared.open(URL)
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL_STATIC)\(Config.PATH_TERM_CONDITION)"
        newsController.headerTitleSet = "Điều khoản & điều kiện"
        newsController.isStaticPageLoad = true
        self.present(newsController, animated: true, completion: nil)
        return false
    }
}

extension SecondViewController: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        self.popTipView = nil;
    }
}
