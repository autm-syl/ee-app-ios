//
//  ProfileViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/20/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var fbIconImg: UIImageView!
    @IBOutlet weak var linkfbLbl: UILabel!
    @IBOutlet weak var buttonLinkfbBtn: UIButton!
    
    var timerRunlac:Timer?
    var countRunlac:Int = 2200
    
    var tableData:[String] = ["Thông tin", "Nhận thông báo", "Liên hệ", "Chính sách bảo mật", "Điều khoản & điều kiện", "Về chúng tôi", "Đăng xuất"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.separatorColor = .clear
        mainTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        mainTableView.reloadData()
        
        fbIconImg.isHidden = true
        linkfbLbl.isHidden = true
        buttonLinkfbBtn.isHidden = true
       
        
        avatarUser.layer.cornerRadius = avatarUser.frame.size.width/2
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        countRunlac = 0
        if ((timerRunlac?.isValid) != nil) {
            timerRunlac?.invalidate()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func menuClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
    }
    @IBAction func linkWithFbBtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showContactInformation", sender: nil )
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

extension ProfileViewController {
    
    func openContactInformation() {
        self.performSegue(withIdentifier: "showContactInformation", sender: nil )
    }
    func openContactUsPage() {
        NotificationCenter.default.post(name:.goContactUsPage, object: nil);
    }
    func openPoliciesPage() {
        NotificationCenter.default.post(name:.goPolicies, object: nil);
    }
    func openTermConditionPage() {
        NotificationCenter.default.post(name:.goTermCondition, object: nil);
    }
    func openAboutUsPage() {
        NotificationCenter.default.post(name:.goAboutUsPage, object: nil);
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
        
        self.present(alert, animated: true, completion: nil)
    }
}
