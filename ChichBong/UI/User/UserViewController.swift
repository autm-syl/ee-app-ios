//
//  UserViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/2/21.
//

import UIKit
import SVProgressHUD
import VKPinCodeView


class UserViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var area1: UIView!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var area2: UIView!
    @IBOutlet weak var adress1: UITextView!
    @IBOutlet weak var phoneNum: UITextView!
    @IBOutlet weak var area3: UIView!
    @IBOutlet weak var bottomContentConstraints: NSLayoutConstraint!
    @IBOutlet weak var routerView: UIView!
    @IBOutlet weak var linkFbAccountLbl: UILabel!
    @IBOutlet weak var pinCodeLbl: UILabel!
    @IBOutlet weak var updateAddressBtn: UIButton!
    @IBOutlet weak var updatePhoneNumBtn: UIButton!
    @IBOutlet weak var updateUserNameBtn: UIButton!
    
    @IBOutlet weak var fbzoneView: UIView!
    @IBOutlet weak var vkpincodeview: UIView!
    
    @IBOutlet weak var pin1: UILabel!
    @IBOutlet weak var pin2: UILabel!
    @IBOutlet weak var pin3: UILabel!
    @IBOutlet weak var pin4: UILabel!
    
    var popTipView:CMPopTipView? = nil;
    var pincode:String = ""
    
    let phonePlacehold = "Số điện thoại là bắt buộc"
    let addressPlaceHold = "Địa chỉ nhận hàng mặc định"

    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        phoneNum.delegate = self;
        adress1.delegate = self;
        usernameField.delegate = self;
        
        // check type
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize.init(width: self.scrollView.frame.size.width, height: 714);
        bottomContentConstraints.constant = 714
    }

    private func validator(_ code: String) -> Bool {
        return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
    }
}

extension UserViewController: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        self.popTipView = nil;
    }
}

extension UserViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == usernameField) {
            updateUserNameBtn.isHidden = false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
        if (textField == usernameField) {
            let username = usernameField.text
            if username == "" || username == Globalvariables.shareInstance.user_name {
                updateUserNameBtn.isHidden = true
            } else {
                updateUserNameBtn.isHidden = false
            }
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let pass = textField.text
//        if (pass == "") {
//            notifyErrorPincode(field: textField, message: "Bạn chưa nhập mã PIN")
//            return true;
//        }
//        if pass!.count < 4 {
//            notifyErrorPincode(field: textField, message: "Mã PIN gồm 4 chữ số!")
//            textField.text = ""
//            return true;
//        }
//        pincode = pass!
//        Globalvariables.shareInstance.setPincode(pincode: pincode)
//        updateUserProfile(Adr1: "", Adr2: "", Birthday: "", Device_id: "", Device_name: "", Fb_id: "", Gender: 0, Name: "", Old: 0, Phone_num: "", User_name: "", Pass: pincode )
//
//        return true
//    }
}

extension UserViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
        if textView == phoneNum {
            if textView.text == phonePlacehold {
                textView.text = ""
            }
            updatePhoneNumBtn.isHidden = false
        }
        if textView == adress1 {
            if textView.text == addressPlaceHold {
                textView.text = ""
            }
            updateAddressBtn.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == phoneNum {
            // placehold
            if (textView.text == "") {
                textView.text = phonePlacehold
            }
            
            
            let phone = textView.text
            if phone == "" {
                notifyWarning(field: textView, message: "Bạn chưa nhập số điện thoại!")
                return;
            }
            
            if !phone!.isValidPhone() {
                notifyWarning(field: textView, message: "Số điện thoại chưa chính xác. vui lòng xem lại!")
                return;
            }
            
           
            
        }
        
        if textView == adress1 {
            if (textView.text == "") {
                textView.text = addressPlaceHold
            }
            
            let address1 = textView.text
            if address1 == "" {
                notifyWarning(field: textView, message: "Địa chỉ đang để trống!")
                return;
            }
        }
    }
    
    private func notifyError(field: UITextView, message: String) {
        popTipView = CMPopTipView.init(title: "Lỗi", message: message)
        
        popTipView!.delegate = self;
        
        let backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1);
        popTipView!.backgroundColor = backgroundColor;
        popTipView!.textColor = UIColor.white;
        
        popTipView!.animation = CMPopTipAnimation.init(rawValue: 1)!
        popTipView!.has3DStyle = true;
        
        popTipView!.dismissTapAnywhere = true;
        popTipView!.autoDismiss(animated: true, atTimeInterval: 5);
        
        popTipView!.presentPointing(at: field, in: self.view, animated: true)
    }
    
    private func notifyErrorPincode(field: UITextField, message: String) {
        popTipView = CMPopTipView.init(title: "Lỗi", message: message)
        
        popTipView!.delegate = self;
        
        let backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1);
        popTipView!.backgroundColor = backgroundColor;
        popTipView!.textColor = UIColor.white;
        
        popTipView!.animation = CMPopTipAnimation.init(rawValue: 1)!
        popTipView!.has3DStyle = true;
        
        popTipView!.dismissTapAnywhere = true;
        popTipView!.autoDismiss(animated: true, atTimeInterval: 5);
        
        popTipView!.presentPointing(at: field, in: self.view, animated: true)
    }
    
    private func notifyWarning(field: UITextView, message: String) {
        popTipView = CMPopTipView.init(title: "❗️", message: message)
        
        popTipView!.delegate = self;
        
        let backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1);
        popTipView!.backgroundColor = backgroundColor;
        popTipView!.textColor = UIColor.white;
        
        popTipView!.animation = CMPopTipAnimation.init(rawValue: 1)!
        popTipView!.has3DStyle = true;
        
        popTipView!.dismissTapAnywhere = true;
        popTipView!.autoDismiss(animated: true, atTimeInterval: 5);
        
        popTipView!.presentPointing(at: field, in: self.view, animated: true)
    }
}

import ObjectMapper

class UpdateResult: Mappable {
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        message <- map["Message"]
    }
}


extension String {
 
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
 
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}
