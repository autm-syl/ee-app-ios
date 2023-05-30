//
//  ThirdViewController.swift
//  ChichBong
//
//  Created by autm on 08/06/2021.
//

import UIKit

import SVProgressHUD
import IQKeyboardManager
import OneSignal

class ThirdViewController: UIViewController {

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
    @IBAction func backBtnClicked(_ sender: Any) {
    }
    @IBAction func HNBtnClicked(_ sender: Any) {
        updateLocationUser(location: "Hà Nội")
    }
    @IBAction func HCMBtnClicked(_ sender: Any) {
        updateLocationUser(location: "Hồ Chí Minh")
    }
    @IBAction func OTHERBtnClicked(_ sender: Any) {
        updateLocationUser(location: "Khu vực khách")
    }
    
    func updateLocationUser(location: String) {
        NotificationCenter.default.post(name:.goIntoApp, object: nil);
        OneSignal.sendTag("location", value: location);

    }
    
}
