//
//  UIView+.swift
//  ChichBong
//
//  Created by autm on 16/12/2021.
//

import Foundation
import UIKit

extension UIView {
    
    func getSelectedTextField() -> UITextField? {

        let totalTextFields = getTextFieldsInView(view: self)

        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }

        return nil

    }

    func getTextFieldsInView(view: UIView) -> [UITextField] {

        var totalTextFields = [UITextField]()

        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }

        return totalTextFields
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

public protocol Applicable {}

public extension Applicable {
    @discardableResult
    func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

public protocol Runnable {}

public extension Runnable {
    @discardableResult
    func run<T>(closure: (Self) -> T) -> T {
        closure(self)
    }
}

extension NSObject: Applicable {}
extension NSObject: Runnable {}
