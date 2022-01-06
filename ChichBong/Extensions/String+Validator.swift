//
//  String+Validator.swift
//  ChichBong
//
//  Created by Sylvanas on 4/6/21.
//

import Foundation
import UIKit

extension String {
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
}
