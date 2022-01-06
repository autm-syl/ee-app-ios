//
//  NotificationEx.swift
//  ChichBong
//
//  Created by Sylvanas on 4/16/21.
//

import UIKit

extension Notification.Name {
    static let toggleLeftMenu = Notification.Name("toggleLeftMenu")
    static let goIntoApp = Notification.Name("goIntoApp")
    static let goIntoIntroview = Notification.Name("goIntoIntroview")
    static let goUserTab = Notification.Name("goUserTab")
    static let goContactUsPage = Notification.Name("goContactUsPage")
    static let goAboutUsPage = Notification.Name("goAboutUsPage")
    static let goTermCondition = Notification.Name("goTermCondition")
    static let goPolicies = Notification.Name("goPolicies")
    static let goQuestTab = Notification.Name("goQuestTab")
}

extension Notification.Name {
    static let introNextPage = Notification.Name("introNextPage")
    static let introBackPage = Notification.Name("introBackPage")
}

extension Notification.Name {
    static let goMainHome = Notification.Name("goMainHome")
    static let goOrderTab = Notification.Name("goOrderTab")
    static let goAllNewsPage = Notification.Name("goAllNewsPage")
    static let goChatScreen = Notification.Name("goChatScreen")
    static let showToastMessage = Notification.Name("showToastMessage")
    
    static let goCartController = Notification.Name("goCartController")
}

extension Notification.Name {
    static let updateBadgeFavorite = Notification.Name("updateBadgeFavorite")
    static let updateBadgeOrder = Notification.Name("updateBadgeOrder")
    static let updatePincodeWarning = Notification.Name("updatePincodeWarning")
}

extension Notification.Name {
    static let gotUnreadMessage = Notification.Name("gotUnreadMessage")
    static let clearUnreadMessage = Notification.Name("clearUnreadMessage")
}
