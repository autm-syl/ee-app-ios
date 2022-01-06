//
//  LauncherViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/7/21.
//

import UIKit
import QuartzCore

import SVProgressHUD


let pulsator = Pulsator()

class LauncherViewController: UIViewController, CAAnimationDelegate {
    
    var mask: CALayer?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var testLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.superlayer?.insertSublayer(pulsator, below: imageView.layer)
        setupInitialValues()
        pulsator.start()

//        NotificationCenter.default.post(name:.goMainHome, object: nil);
        if (Globalvariables.shareInstance.token_auth == "") {
            // go introview
            NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
        } else {
            self.perform(#selector(showAppNow), with: nil, afterDelay: 1.25)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = imageView.layer.position
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pulsator.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupInitialValues() {
        pulsator.numPulse = 5
        pulsator.radius = 1000.0
        pulsator.animationDuration = 8.0
        
        pulsator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
//        pulsator.backgroundColor = UIColor(
//            red: CGFloat(31.0/255),
//                    green: CGFloat(146.0/255),
//                    blue: CGFloat(252.0/255),
//            alpha: CGFloat(1.0)).cgColor
    }
    

    @objc func showAppNow() {
        pulsator.stop()
        NotificationCenter.default.post(name:.goIntoApp, object: nil);
    }
    
    func checkToken() {
        
    }
    
    func getFavorite() {
    }

}


import ObjectMapper

class UserInformationResult: Mappable {
    var Profile:UserInformationObj? = nil
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        Profile <- map["Data"]
    }
}

class UserInformationObj: Mappable {
    var Id:Int = 0
    var Fb_id:String = ""
    var Phone_num:String = ""
    var User_name:String = ""
    var Adr1:String = ""
    var Adr2:String = ""
    var Device_id:String = ""
    var Old:String = ""
    var Birthday:String = ""
    var Gender:String = ""
    var Time_reg:String = ""
    var Device_name:String = ""
    var User_type:String = ""
    var Name:String = ""
    var Avatar:String = ""
    
    
    
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        Id <- map["Id"]
        Fb_id <- map["Fb_id"]
        Phone_num <- map["Phone_num"]
        User_name <- map["User_name"]
        Adr1 <- map["Adr1"]
        Adr2 <- map["Adr2"]
        Device_id <- map["Device_id"]
        Old <- map["Old"]
        Birthday <- map["Birthday"]
        Gender <- map["Gender"]
        Time_reg <- map["Time_reg"]
        Device_name <- map["Device_name"]
        User_type <- map["User_type"]
        Name <- map["Name"]
        Avatar <- map["Avatar"]
    }
}

class FavoriteResult: Mappable {
    var favorites:[FavoritesObj] = []
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        favorites <- map["Data.Favorites"]
    }
}

class FavoritesObj: Mappable {
    var id: Int = 0
    var item_id: Int = 0
    var time_like: Int = 0
    var note: String = ""
    
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        id <- map["Id"]
        var item: Any?
        item <- map["Item"]
        if item != nil {
            item_id <- map["Item.Id"]
        }
        
        
        time_like <- map["Time_like"]
        note <- map["Note"]
    }
}
