//
//  Common.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import Foundation
import UIKit
import RealmSwift

extension UIButton {
  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.cornerRadius = 2.0
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
    
    func findDifferenElements(with other: [Element]) -> [ Element ] {
        var different:[Element] = [];
        self.forEach { (element) in
            //
            if !other.contains(element) {
                different.append(element)
            }
        }
        return different;
    }
    
}

extension UITextView {
  // OUTPUT 1
 
    func trueOption() {
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        
        self.textColor = #colorLiteral(red: 0.01568627451, green: 0.3803921569, blue: 0.3058823529, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.8029057384, green: 0.8030222058, blue: 0.8028802276, alpha: 0.5)
    }
    
    func falseOption() {
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        
        self.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func userChoosedOption() {
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        
        self.textColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.8029057384, green: 0.8030222058, blue: 0.8028802276, alpha: 0.5)
    }
    
    func choosedCorrectOption() {
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        
        self.textColor = #colorLiteral(red: 0.01568627451, green: 0.3803921569, blue: 0.3058823529, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
    }
}

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}

extension Array {
    func clone() -> Self {
        return self;
    }
    
    func intArrayOverlapElement(input: [Int]) -> Array {
        let output = self.filter{ input.contains($0 as! Int)}
        return output
    }
}

extension List {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap {$0 as? T}
    }
    
    
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
