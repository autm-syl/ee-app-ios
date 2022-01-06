//
//  NewsViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/16/21.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager
import WebKit
import Toast_Swift

class NewsViewController: UIViewController {
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var wkwebView: WKWebView!
    @IBOutlet weak var downLoadBtn: UIButton!
    
    
    var contentHtmlString:[String] = []
    var staticLink:String = ""
    var documentype:Int = 0
    var isStaticLink:Bool = true
    var reamlDocument:Documentation?
    
    open var headerTitleSet:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
        self.tabBarController?.tabBar.isHidden = false
    }

    func setupView() {
        self.wkwebView.apply {
            $0.isOpaque = false
            $0.scrollView.isScrollEnabled = true
            $0.navigationDelegate = self
            $0.load(URLRequest.init(url: URL(string: staticLink)!))
        }
        print("static link load:", staticLink, "\n")
        self.headerTitle.apply {
            $0.text = headerTitleSet
        }
        
        if documentype == DocumentType.html || documentype == DocumentType.CaseStudy {
            self.downLoadBtn.isHidden = false
        } else {
            self.downLoadBtn.isHidden = true
        }

    }
    

    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func downloadBtnClicked(_ sender: Any) {
        if let obj = reamlDocument {
            Globalvariables.shareInstance.saveDocument(doc: obj)
        }
        
        self.ShowBottomToastWith(mess: "Đã được lưu trữ", messColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func ShowBottomToastWith(mess: String, messColor: UIColor) {
        var style = ToastStyle()
        style.messageColor = messColor
        
        if let keyWindow = UIWindow.key {
            keyWindow.makeToast(mess, duration: 8.0, position: .center, title: "🪴", image: nil, style: style, completion: nil)
            ToastManager.shared.isTapToDismissEnabled = true
            ToastManager.shared.isQueueEnabled = true
        }
    }
}

extension NewsViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription);
        //
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load content");
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish load content");
        SVProgressHUD.dismiss()
        
        // tracking view this document
        if reamlDocument != nil {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) { [self] in
                Globalvariables.shareInstance.sendUserWatch(objectId: reamlDocument!.id, watch_type: WatchType.Documentation)
            }
        }
        
    }
}
