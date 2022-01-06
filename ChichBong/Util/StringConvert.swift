//
//  StringConvert.swift
//  ChichBong
//
//  Created by autm on 24/12/2021.
//

import UIKit

class Util {
    static let share = Util()
    
    func matchesReplaceHtml(in text: String) -> String {
        let regex = try! NSRegularExpression(pattern: "<[^>]*>", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, text.count)
        let modString = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        print(modString)
        return modString
    }
}
