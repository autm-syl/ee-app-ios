//
//  Device.swift
//  ChichBong
//
//  Created by Sylvanas on 3/29/21.
//

import Device


extension Device {
    
    public static func isIPhoneXSimilar() -> Bool {
        switch Device.size() {
        case .screen5_8Inch, .screen6_1Inch, .screen6_5Inch:
            return true
        default:
            return false
        }
    }
    
    public static func isIPadScreen() -> Bool {
        switch Device.size() {
        case .screen7_9Inch,
             .screen9_7Inch,
             .screen10_2Inch,
             .screen10_5Inch,
             .screen11Inch,
             .screen12_9Inch:
            return true
        default:
            return Device.isPad()
        }
    }
}


