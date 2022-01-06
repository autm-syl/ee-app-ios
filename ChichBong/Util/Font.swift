//
//  Font.swift
//  Snolax
//
//  Created by Sylvanas on 7/6/20.
//  Copyright © 2020 Sylvanas. All rights reserved.
//

import UIKit

typealias MainFont = Font.Menlo

enum Font {
    enum Menlo: String {
        case italic = "Italic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case regular = "Regular"
        
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "Menlo-\(rawValue)", size: size)!
        }
    }
}
