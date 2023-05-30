//
//  ChangePassViewController.swift
//  ChichBong
//
//  Created by autm on 02/03/2022.
//

import UIKit
import SVProgressHUD

class ChangePassViewController: BaseViewController {
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var rePassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func updateBtnClicked(_ sender: Any) {
        let pass = self.newPassField.text
        let repass = self.rePassField.text
        if pass != "" && pass != repass {
            self.showError(mess: "Mật khẩu không trùng khớp!")
            return;
        }
        if  pass == "" {
            self.showError(mess: "Mật khẩu đang trống!")
            return;
        }
        if  pass!.count < 6 {
            self.showError(mess: "Mật khẩu quá ngắn, vui lòng nhập ít nhất 6 ký tự")
            return;
        }
        
        
        SVProgressHUD.show()
        MonConnection.requestCustom(APIRouter.updatePassword(password: pass ?? "", user_id: Globalvariables.shareInstance.thisUserOnDevice?.Id ?? 0)) { [self] result, error in
            SVProgressHUD.dismiss()
            if error == nil {
                // xu ly result
                SVProgressHUD.showSuccess(withStatus: "Cập nhật thành công")
                SVProgressHUD.dismiss(withDelay: 2.0)
                
                self.newPassField.text = ""
                self.rePassField.text = ""
                
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
    
}
