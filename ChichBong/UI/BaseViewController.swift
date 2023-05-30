//
//  BaseViewController.swift
//  ChichBong
//
//  Created by autm on 10/01/2022.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func showError(mess:String) {
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        style.messageColor = .red

        // present the toast with the new style
        self.view.makeToast(mess, duration: 3.0, position: .bottom, style: style)
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
    }
    
    func showNotify(mess:String) {
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        style.messageColor = .green

        // present the toast with the new style
        self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
    }
}
