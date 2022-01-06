//
//  MainTabarViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/7/21.
//

import UIKit
import PTCardTabBar
import Toast_Swift

class MainTabarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.goUserTab), name: .goUserTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goContactUsPage), name: .goContactUsPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goAboutUsPage), name: .goAboutUsPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goQuestTab), name: .goQuestTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goTermCondition), name: .goTermCondition, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goPolicies), name: .goPolicies, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goHomeTab), name: .goMainHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goOrderTab), name: .goOrderTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goAllNewsPage), name: .goAllNewsPage, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadgeFavorite), name: .updateBadgeFavorite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadgeOrder), name: .updateBadgeOrder, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePincodeWarning), name: .updatePincodeWarning, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goCartController), name: .goCartController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showToastNotify(_:)), name: .showToastMessage, object: nil)
        
        
        updateBadgeFavorite()
        updateBadgeOrder()
        updatePincodeWarning()
    }
    
    @objc func showToastNotify(_ notification:Notification) {
        if let data = notification.userInfo as? [String: String] {
            let message = data["message"]
            self.ShowBottomToastWith(mess: message ?? "", messColor: .white)
        }
    }

    @objc func goUserTab() {
        self.selectedIndex = 4
    }
    
    @objc func goHomeTab() {
        self.selectedIndex = 0
    }
    
    @objc func goOrderTab() {
        self.selectedIndex = 3
    }
    
    @objc func openChatView() {
        NotificationCenter.default.post(name:.goChatScreen, object: nil);
    }
    
    @objc func goAllNewsPage() {
        let newsListVC = NewsListViewController(nibName: "NewsListViewController", bundle: nil)
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(newsListVC, animated: true)
    }
    
    @objc func goContactUsPage() {
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL)\(Config.PATH_CONTACT_US)"
        newsController.headerTitleSet = "Liên hệ"
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(newsController, animated: true)
    }
    @objc func goQuestTab() {
        let questController = TrainingCategoriesViewController(nibName: "TrainingCategoriesViewController", bundle: nil)
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(questController, animated: true)
    }
    
    @objc func goAboutUsPage() {
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL)\(Config.PATH_ABOUT_US)"
        newsController.headerTitleSet = "Về chúng tôi"
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(newsController, animated: true)
    }
    
    @objc func goTermCondition() {
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL)\(Config.PATH_TERM_CONDITION)"
        newsController.headerTitleSet = "Điều khoản & điều kiện"
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(newsController, animated: true)
    }
    @objc func goPolicies() {
        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsController.staticLink = "\(Config.BASE_URL)\(Config.PATH_POLICY)"
        newsController.headerTitleSet = "Chính sách bảo mật"
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(newsController, animated: true)
    }
    
    @objc func goCartController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController")
        let currentnav = self.selectedViewController as! UINavigationController
        currentnav.pushViewController(cartVC, animated: true)
    }
    
    @objc func updateBadgeFavorite() {
        
    }
    
    @objc func updateBadgeOrder() {
        if let tabItems = tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            // request count waiting accept order
            
            
        }
    }
    
    @objc func updatePincodeWarning() {
        
    }
    
    @objc
    func ShowBottomToastWith(mess: String, messColor: UIColor) {
        var style = ToastStyle()
        style.messageColor = messColor
        
        if let keyWindow = UIWindow.key {
            keyWindow.makeToast(mess, duration: 10.0, position: .center, title: "ChichBong đã trả lời bạn", image: nil, style: style, completion: nil)
            ToastManager.shared.isTapToDismissEnabled = true
            ToastManager.shared.isQueueEnabled = true
        }
    }
}
