//
//  Constants.swift
//  ChichBong
//
//  Created by Sylvanas on 3/29/21.
//

import UIKit
import Device


struct Constants {
    static let loginViaFacebook = 1
    static let loginByUserName = 2
    static let loginByPhoneNumber = 3
    static let loginByDevice = 4
    
    
    struct Numbers {
        static var topSafeAreaHeight: CGFloat {
            if Device.isIPhoneXSimilar() {
                return 20
            }
            return 0
        }
        static var statusBarHeight: CGFloat {
            return 20 + topSafeAreaHeight
        }
        static let navBarContentHeight: CGFloat = 40
        static var navBarHeight: CGFloat {
            return statusBarHeight + navBarContentHeight
        }
        static var bottomSafeAreaHeight: CGFloat {
            if Device.isIPhoneXSimilar() {
                return 34
            }
            return 0
        }
        static let tabBarContentHeight: CGFloat = 49
        static var tabBarHeight: CGFloat {
            return bottomSafeAreaHeight + tabBarContentHeight
        }
    }
}

