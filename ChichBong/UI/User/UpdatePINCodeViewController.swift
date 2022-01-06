//
//  UpdatePINCodeViewController.swift
//  ChichBong
//
//  Created by autm on 18/06/2021.
//

import UIKit
import VKPinCodeView
import SVProgressHUD

class UpdatePINCodeViewController: UIViewController {
    
    @IBOutlet weak var pincodeVie: VKPinCodeView!
    @IBOutlet weak var updateBtn: UIButton!
    
    var pincode:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configurePinView()
        
        updateBtn.isUserInteractionEnabled = false
    }
    
    func configurePinView() {
        pincodeVie.onSettingStyle = {
 
            VKPINStyleShit(textColor: #colorLiteral(red: 0.1447098255, green: 0.1566933095, blue: 0.1691914201, alpha: 1), lineColor: #colorLiteral(red: 0.6269054413, green: 0.6429443955, blue: 0.6595547795, alpha: 1), selectedLineColor: #colorLiteral(red: 0.122458227, green: 0.5704800487, blue: 0.9898548722, alpha: 1), lineWidth: 2)
                }

        pincodeVie.onComplete = { [self] code, pinView in
            self.pincode = code
            updateBtn.isUserInteractionEnabled = true
        }

        pincodeVie.validator = validator(_:)
        
        pincodeVie.becomeFirstResponder()
    }
    
    private func validator(_ code: String) -> Bool {
       return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
   }
  

    @IBAction func updateBtnClicked(_ sender: Any) {
        if pincode == "" {
            return
        }
        
        SVProgressHUD.show()
        MonConnection.requestCustom(APIRouter.updateProfile(Adr1: "", Adr2: "", Birthday: "", Device_id: "", Device_name: "", Fb_id: "", Gender: 0, Name: "", Old: 0, Phone_num: "", User_name: "", Pass: pincode, User_location: "", Avatar: "")) { [self] (result, error) in
            //
            if error == nil {
                // xu ly result
                let update_result = UpdateResult.init(JSON: result!)
                
                guard let mes = update_result?.message else {
                    SVProgressHUD.showError(withStatus: "Có lỗi!\nKhông thể cập nhật thông tin vào lúc này!")
                    SVProgressHUD.dismiss(withDelay: 4.0)
                    return;
                }
                if (mes == "Success") {
                    SVProgressHUD.showSuccess(withStatus: "Cập nhật thành công")
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    
                   
                    
                    self.dismiss(animated: true, completion: nil)
                } else {
                    SVProgressHUD.showError(withStatus: "Có lỗi!\nKhông thể cập nhật thông tin vào lúc này!")
                    SVProgressHUD.dismiss(withDelay: 4.0)
                }
            } else {
                // loi
                // no live header.
                SVProgressHUD.showError(withStatus: "Có lỗi xảy ra trong quá trình cập nhật\n Vui lòng thử lại sau!")
                SVProgressHUD.dismiss(withDelay: 4.0)
            }
        }
    }
}
