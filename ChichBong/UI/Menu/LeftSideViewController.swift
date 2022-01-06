//
//  LeftSideViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/16/21.
//

import UIKit

class LeftSideViewController: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var newsBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet weak var aboutUsBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var QuestBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        avatarImg.clipsToBounds = true
//        avatarImg.layer.cornerRadius = 34
//        avatarImg.layer.borderWidth = 0.5
//        avatarImg.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if (Globalvariables.shareInstance.user_name != "") {
            nameLbl.text = Globalvariables.shareInstance.user_name
        } else {
            nameLbl.text = "User"
        }
        
        phoneLbl.text = ""
        
        if Globalvariables.shareInstance.avatar != "" {
            let avatar = Globalvariables.shareInstance.avatar
            avatarImg.sd_setImage(with: URL.init(string: avatar), completed: nil)
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
    @IBAction func profileClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
        NotificationCenter.default.post(name:.goUserTab, object: nil);
    }
    @IBAction func newsBtnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
        NotificationCenter.default.post(name:.goAllNewsPage, object: nil);
    }
    @IBAction func contactUsBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
        NotificationCenter.default.post(name:.goContactUsPage, object: nil);
    }
    @IBAction func aboutUsBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
        NotificationCenter.default.post(name:.goAboutUsPage, object: nil);
    }
    @IBAction func loginbtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
        NotificationCenter.default.post(name:.goUserTab, object: nil);
    }
    
    @IBAction func QuestBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
        NotificationCenter.default.post(name:.goQuestTab, object: nil);
    }
    
}
