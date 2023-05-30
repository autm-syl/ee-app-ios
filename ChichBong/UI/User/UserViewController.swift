//
//  UserViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/2/21.
//

import UIKit
import SVProgressHUD
import VKPinCodeView


class UserViewController: BaseViewController {
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
    
    let phonePlacehold = "Số điện thoại xác thực"
    let addressPlaceHold = "Phòng ban (vị trí)"

    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        phoneNum.delegate = self;
        adress1.delegate = self;
        usernameField.delegate = self;
        
        setupUIInformation()
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
    @IBAction func updateUseFullNameBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        let fullname = usernameField.text;
        if fullname == "" {
            notifyWarning(field: usernameField, message: "Họ tên đang trống. vui lòng xem lại!")
            return;
        }
        
        self.updateProfile(mail: "", avatar: "", name: "", fullname: fullname ?? "", department: "", address: "", phone: "", birthday: "")
    }
    @IBAction func updateAddressBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        let department = adress1.text;
        if department == "" {
            notifyWarning(field: adress1, message: "Phòng ban (vị trí) đang trống. vui lòng xem lại!")
            return;
        }
        
        self.updateProfile(mail: "", avatar: "", name: "", fullname: "", department: department ?? "", address: "", phone: "", birthday: "")
    }
    @IBAction func updatePhoneNumBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        let phone = phoneNum.text;
        if phone == "" {
            notifyWarning(field: phoneNum, message: "Số điện thoại đang trống. vui lòng xem lại!")
            return;
        }
        
        self.updateProfile(mail: "", avatar: "", name: "", fullname: "", department: "", address: "", phone: phone ?? "", birthday: "")
    }
    @IBAction func changePassBtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "changePass", sender: nil)
    }
    
    // MARK: - private function
    
    private
    func setupUIInformation() {
        if Globalvariables.shareInstance.thisUserOnDevice != nil && Globalvariables.shareInstance.thisUserOnDevice?.Phone != "" {
            self.phoneNum.text = Globalvariables.shareInstance.thisUserOnDevice!.Phone
        }
        
        if Globalvariables.shareInstance.thisUserOnDevice != nil && Globalvariables.shareInstance.thisUserOnDevice?.Department != "" {
            self.adress1.text = Globalvariables.shareInstance.thisUserOnDevice!.Department
        }
        
        if Globalvariables.shareInstance.thisUserOnDevice != nil && Globalvariables.shareInstance.thisUserOnDevice?.Fullname != "" {
            self.usernameField.text = Globalvariables.shareInstance.thisUserOnDevice!.Fullname
        }
    }
    
    private
    func updateProfile(mail: String, avatar: String, name: String, fullname: String, department: String, address: String, phone: String, birthday: String) {
        SVProgressHUD.show()
        MonConnection.requestCustom(APIRouter.updateProfile(user_id: Globalvariables.shareInstance.thisUserOnDevice?.Id ?? 0, mail: mail, avatar: avatar, name: name, fullname: fullname, department: department, address: address, phone: phone, birthday: birthday)) { [self] result, error in
            SVProgressHUD.dismiss()
            if error == nil {
                // xu ly result
                SVProgressHUD.showSuccess(withStatus: "Cập nhật thành công")
                SVProgressHUD.dismiss(withDelay: 2.0)
                self.getMyInformation { success in
                    //
                    self.showNotify(mess: "Đồng bộ thông tin người dùng thành công")
                }
            } else {
                // loi
                // no live header.
                SVProgressHUD.showError(withStatus: "Có lỗi xảy ra trong quá trình cập nhật\n Vui lòng thử lại sau!")
                SVProgressHUD.dismiss(withDelay: 4.0)
                
                if error?.mErrorCode == 401 {
                    self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                }
            }
        }
    }
    
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
            updateAddressBtn.isHidden = true
            updatePhoneNumBtn.isHidden = true
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

}

extension UserViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
        if textView == phoneNum {
            if textView.text == phonePlacehold {
                textView.text = ""
            }
            updatePhoneNumBtn.isHidden = false
            phoneNum.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if textView == adress1 {
            if textView.text == addressPlaceHold {
                textView.text = ""
            }
            updateAddressBtn.isHidden = false
            adress1.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == phoneNum {
            // placehold
            if (textView.text == "") {
                textView.text = phonePlacehold
                phoneNum.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
            
            let phone = textView.text
            
            if !phone!.isValidPhone() {
                notifyWarning(field: textView, message: "Số điện thoại chưa chính xác. vui lòng xem lại!")
                return;
            }
        }
        
        
        if textView == adress1 {
            if (textView.text == "") {
                textView.text = addressPlaceHold
                adress1.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
            
            let address1 = textView.text
            if address1 == "" {
                notifyWarning(field: textView, message: "Đang để trống!")
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
    
    private func notifyWarning(field: UIView, message: String) {
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
