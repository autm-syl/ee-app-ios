//
//  LauncherViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/7/21.
//

import UIKit
import QuartzCore

import SVProgressHUD
import Toast_Swift


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

        if (Globalvariables.shareInstance.token_auth == "") {
            // go introview
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
            }
        } else {
            getMyInformation { [self] success in
                if success {
                    self.perform(#selector(showAppNow), with: nil, afterDelay: 0.25)
                } else {
                    var style = ToastStyle()
                    style.messageColor = #colorLiteral(red: 0.8487177491, green: 0.3503796458, blue: 0.3862038851, alpha: 1)
                    self.view.makeToast("Có ai đó đã đăng nhập trên một thiết bị khác!", duration: 5.0, position: .bottom, title: "Xác thực tài khoản thất bại", image: nil, style: style) { didTap in
                        //
                        NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
                    }
                    
                    ToastManager.shared.isTapToDismissEnabled = true
                    ToastManager.shared.isQueueEnabled = true
                }
            }
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
    }
    

    @objc func showAppNow() {
        pulsator.stop()
        NotificationCenter.default.post(name:.goIntoApp, object: nil);
    }
    
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
