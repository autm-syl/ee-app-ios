//
//  AppDelegate.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import UIKit
import IQKeyboardManager
import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static var standard: AppDelegate {
       return UIApplication.shared.delegate as! AppDelegate
   }
    
    var drawerContainer: MMDrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let is1stOpen = Globalvariables.shareInstance.isFirstOpen
        UNUserNotificationCenter.current().delegate = self
            
        // keyboard
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
                
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerOpenLeftMenu), name: .toggleLeftMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goMainApp), name: .goIntoApp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goIntoIntroview), name: .goIntoIntroview, object: nil)
        
        if (is1stOpen) {
            showIntroView()
        } else {
            showMainAppRouter()
        }
        
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // record start time
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // stop time
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // stop time
        
    }

    // UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            // background
            completionHandler([.badge, .sound, .alert])
        } else if state == .active {
            // foreground
            completionHandler([])
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //
    }
    
    
    func buildNavigationDrawer() {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        let mainPage:MainTabarViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabarViewController") as! MainTabarViewController
        let leftSideMenu:LeftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
        
        let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
        drawerContainer = MMDrawerController(center: mainPage, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: nil)
        drawerContainer!.modalPresentationStyle = .overFullScreen
        drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.custom
        drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
        drawerContainer!.showsShadow = false
        drawerContainer!.centerHiddenInteractionMode = .full
        
        AppDelegate.standard.window?.rootViewController = drawerContainer
     }

    @objc func observerOpenLeftMenu() {
        drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    @objc func goMainApp() {
        buildNavigationDrawer()
    }
    
    func showIntroView() {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Introview", bundle: nil)

        let initialViewController = storyboard.instantiateViewController(withIdentifier: "RootIntroViewController")

        AppDelegate.standard.window?.rootViewController = initialViewController
        AppDelegate.standard.window?.makeKeyAndVisible()
    }
    
    func showMainAppRouter() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LauncherViewController")

        AppDelegate.standard.window?.rootViewController = initialViewController
        AppDelegate.standard.window?.makeKeyAndVisible()
    }
    
    @objc func goIntoIntroview() {
        let storyboard = UIStoryboard(name: "Introview", bundle: nil)

        let initialViewController = storyboard.instantiateViewController(withIdentifier: "RootIntroViewController")

        AppDelegate.standard.window?.rootViewController = initialViewController
    }
}
