//
//  Validator.swift
//  ChichBong
//
//  Created by Sylvanas on 4/6/21.
//

import Foundation
import UIKit

class CommonClass {
    static let share = CommonClass()
    
    private init () {
        _ = ""
    }
    
    func IntToStringVnd(input: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: input as NSNumber) {
            return "\(formattedTipAmount)"
        } else {
            return "0 ₫"
        }
    }
}
