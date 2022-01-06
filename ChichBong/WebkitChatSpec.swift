//
//  WebkitChatSpec.swift
//  ChichBong
//
//  Created by autm on 22/11/2021.
//

import UIKit
import WebKit

class WebkitChatSpec: NSObject {
    var mainChatWk:WKWebView?
    
    func setuupWebChat() {
        mainChatWk = WKWebView.init(frame: CGRect.zero)
        
        mainChatWk!.isOpaque = true;
        mainChatWk!.navigationDelegate = self;
        mainChatWk!.scrollView.isScrollEnabled = false;
        mainChatWk!.configuration.userContentController.add(self, name: "nativeApp")
        
        let url = URL(string: "http://192.168.1.4:8081/webview/chat?token=\(Globalvariables.shareInstance.token_auth)")!
        mainChatWk!.load(URLRequest(url: url))
        mainChatWk!.allowsBackForwardNavigationGestures = true
    }
    
    
}


extension WebkitChatSpec: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //
        print("didReceive from web: ", message)
        
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }
        
        print("Message from web is: ",dict)
    }
}

extension WebkitChatSpec:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription);
        //
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load content");
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish load content");
    }
}
