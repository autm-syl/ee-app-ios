//
//  WebViewStaticHTMLViewController.swift
//  ChichBong
//
//  Created by autm on 23/12/2021.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewStaticHTMLViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var contentHtmlString:String = ""
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

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupView() {
        self.webView.apply {
            $0.isOpaque = false
            $0.scrollView.isScrollEnabled = true
            $0.navigationDelegate = self
            let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title></title></head><body>\(contentHtmlString)</body></html>"
            $0.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }
        
        self.titleLbl.apply {
            $0.text = headerTitleSet
        }

    }
}

extension WebViewStaticHTMLViewController:WKNavigationDelegate {
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
    }
}
