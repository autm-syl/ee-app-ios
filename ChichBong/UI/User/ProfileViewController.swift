//
//  ProfileViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/20/21.
//

import UIKit
import SDWebImage
import SVProgressHUD

class ProfileViewController: BaseViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    var isNotiEnable: Bool = false
    
    var tableData:[String] = ["Thông tin", "Nhận thông báo", "Liên hệ", "Chính sách bảo mật", "Điều khoản & điều kiện", "Về chúng tôi", "Đăng xuất"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.separatorColor = .clear
        mainTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { [self] (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                isNotiEnable = false
            } else if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                isNotiEnable = false
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                isNotiEnable = true
                
            }
            mainTableView.reloadData()
        })
              
        avatarUser.layer.cornerRadius = avatarUser.frame.size.width/2
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUIInformation()
        mainTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func updateAvatarBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Cập nhật ảnh đại diện", message: "Chọn ảnh để cập nhật ảnh đại diện của bạn", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "photo allbum", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = sender as? UIView
                popoverPresentationController.sourceRect = (sender as! UIButton).bounds
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - private funtion
    
    private
    func setupUIInformation() {
        
        let username = Globalvariables.shareInstance.thisUserOnDevice?.Username ?? " - "
        let fullname = Globalvariables.shareInstance.thisUserOnDevice?.Fullname ?? " - "
        
        self.userNameLbl.text = "\(username) (\(fullname)"
        
        if Globalvariables.shareInstance.thisUserOnDevice != nil && Globalvariables.shareInstance.thisUserOnDevice?.Avatar != "" {
            self.avatarUser.sd_setImage(with: URL(string: Globalvariables.shareInstance.thisUserOnDevice!.Avatar), completed: nil)
        }
    }
    
    private
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.image"]
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            imagePickerController.videoQuality = UIImagePickerController.QualityType(rawValue: 100)!
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    private
    func uploadImage(image : UIImage) {
        SVProgressHUD.show()
        MonConnection.UploadImageFile(fileData: image.pngData()!) { [self] result, error in
            //
            SVProgressHUD.dismiss()
            if error != nil {
              // loi
              showError(mess: "Up ảnh thất bại")
                
                if error?.mErrorCode == 401 {
                    self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                }
                
              return;
            }
            let uploadResult = UploadImageResult.init(JSON: result!)
            if uploadResult?.Data != "" {
                showNotify(mess: "Up ảnh thành công")
                self.updateAvatar(avatar: uploadResult!.Data)
            } else {
                showError(mess: "Có lỗi xảy ra")
            }
        }
    }
    
    private
    func updateAvatar(avatar: String) {
        SVProgressHUD.show()
        MonConnection.requestCustom(APIRouter.updateProfile(user_id: Globalvariables.shareInstance.thisUserOnDevice?.Id ?? 0, mail: "", avatar: avatar, name: "", fullname: "", department: "", address: "", phone: "", birthday: "")) { [self] result, error in
            SVProgressHUD.dismiss()
            if error == nil {
                // xu ly result
                SVProgressHUD.showSuccess(withStatus: "Cập nhật thành công")
                SVProgressHUD.dismiss(withDelay: 2.0)
                avatarUser.sd_setImage(with: URL(string: avatar), completed: nil)
                
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        let titlecell = tableData[indexPath.row]
        cell.titleCell.text = titlecell
        cell.setTypeOfCell(type: indexPath.row)
        
        switch indexPath.row {
        case 0:
            cell.iconsmall.image = UIImage.init(named: "1")
            break
        case 1:
            cell.iconsmall.image = UIImage.init(named: "2")
            break
        case 2:
            cell.iconsmall.image = UIImage.init(named: "3")
            break
        case 3:
            cell.iconsmall.image = UIImage.init(named: "4")
            break
        case 4:
            cell.iconsmall.image = UIImage.init(named: "5")
            break
        case 5:
            cell.iconsmall.image = UIImage.init(named: "6")
            break
        case 6:
            cell.iconsmall.image = UIImage.init(named: "7")
            break
        default:
            break
        }
        
        cell.isNotiEnable(self.isNotiEnable)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        switch indexPath.row {
        case 0:
            openContactInformation()
            break
        case 1:
            
            break
        case 2:
            openContactUsPage()
            break
        case 3:
            openPoliciesPage()
            break
        case 4:
            openTermConditionPage()
            break
        case 5:
            openAboutUsPage()
        case 6:
            logout()
        default:
            break
        }
    }
}
extension ProfileViewController : ProfileTableViewCellProtocol {
    func didClickedNoti() {
        self.dismiss(animated: true) {
            //
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                    
                }
            }
        }
        
    }
}

extension ProfileViewController {
    
    func openContactInformation() {
        self.performSegue(withIdentifier: "showContactInformation", sender: nil )
    }
    func openContactUsPage() {
//        NotificationCenter.default.post(name:.goContactUsPage, object: nil);
        
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL_STATIC)\(Config.PATH_CONTACT_US)"
        newsController.headerTitleSet = "Liên hệ"
        newsController.isStaticPageLoad = true
        present(newsController, animated: true, completion: nil)
    }
    func openPoliciesPage() {
//        NotificationCenter.default.post(name:.goPolicies, object: nil);
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL_STATIC)\(Config.PATH_POLICY)"
        newsController.headerTitleSet = "Chính sách bảo mật"
        newsController.isStaticPageLoad = true
        present(newsController, animated: true, completion: nil)
    }
    func openTermConditionPage() {
//        NotificationCenter.default.post(name:.goTermCondition, object: nil);
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL_STATIC)\(Config.PATH_TERM_CONDITION)"
        newsController.headerTitleSet = "Điều khoản & điều kiện"
        newsController.isStaticPageLoad = true
        present(newsController, animated: true, completion: nil)
    }
    func openAboutUsPage() {
//        NotificationCenter.default.post(name:.goAboutUsPage, object: nil);
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL_STATIC)\(Config.PATH_ABOUT_US)"
        newsController.headerTitleSet = "Về chúng tôi"
        newsController.isStaticPageLoad = true
        present(newsController, animated: true, completion: nil)
    }
    
    func logout() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Xoá tất cả thông tin trên thiết bị này!", preferredStyle: .alert)
        
        let actionDe = UIAlertAction.init(title: "Xoá", style: .default) { [self] (action) in
            //

            MonConnection.requestCustom(APIRouter.logout(deviceToken: Globalvariables.shareInstance.push_token)) { result, err in
                //
                Globalvariables.shareInstance.clearAllData()
                NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
            }

        }
        
        let actionCancle = UIAlertAction.init(title: "Thôi", style: .cancel)
        alert.addAction(actionCancle)
        alert.addAction(actionDe)
        
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            let cell = mainTableView.cellForRow(at: IndexPath(row: 6, section: 0))
            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = cell! as UIView
                popoverPresentationController.sourceRect = cell?.bounds ?? self.view.bounds
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            let imagePick = info[.originalImage] as? UIImage
            let image = imagePick?.fixOrientation();
   
            uploadImage(image: imagePick!)
        } else {
            showError(mess: "File lỗi")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        dismiss(animated: true, completion: nil)
    }
    
    
}
