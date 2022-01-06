//
//  FSPageControlNumber.swift
//  Snolax
//
//  Created by Sylvanas on 6/10/20.
//  Copyright © 2020 Sylvanas. All rights reserved.
//

import UIKit

class FSPageControlNumber: UIPageControl {
    
    open var list_choose:[Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
   
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            if self.list_choose.contains(i) {
                view.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.6844499144);
            } else {
                view.backgroundColor = #colorLiteral(red: 0.8556079268, green: 0.86251086, blue: 0.8736756444, alpha: 1);
            }
            
            if i == self.currentPage {
                view.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.3803921569, blue: 0.3058823529, alpha: 0.6759417808);
            }
            
            if let number = self.numberForSubview(view) {
                number.text = "\(i + 1)"
            } else {
                let number = UILabel.init(frame: view.bounds)
//                number.font = UIFont.init(descriptor: ., size: <#T##CGFloat#>)
                number.textAlignment = .center
                number.font = number.font.withSize(5)
                number.text = "\(i + 1)"
                view.clipsToBounds = false
                view.addSubview(number)
            }
            i = i + 1
        }
    }

    fileprivate func numberForSubview(_ view:UIView) -> UILabel? {
        var dot:UILabel?

        if let dotNumber = view as? UILabel {
            dot = dotNumber
        } else {
            for foundView in view.subviews {
                if let dotNumber = foundView as? UILabel {
                    dot = dotNumber
                    break
                }
            }
        }

        return dot
    }

}
