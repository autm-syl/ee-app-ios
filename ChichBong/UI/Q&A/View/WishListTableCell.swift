//
//  CartTableCell.swift
//  ChichBong
//
//  Created by Sylvanas on 4/5/21.
//

import UIKit
import WebKit

class WishListTableCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var createByAtLbl: UILabel!
    @IBOutlet weak var contentWebView: WKWebView!
    
    var thisCellIndex:Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _ = WKWebViewConfiguration.init();
        // init & load webview
        contentWebView.isOpaque = true;
//        contentWebView.navigationDelegate = self;
        contentWebView.scrollView.isScrollEnabled = false;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func webviewLoadHtml(html:String) {
        // load html
        let htmlBody = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title></title></head><body>\(html)</body></html>"
        contentWebView.loadHTMLString(htmlBody, baseURL: Bundle.main.bundleURL)
    }
}
