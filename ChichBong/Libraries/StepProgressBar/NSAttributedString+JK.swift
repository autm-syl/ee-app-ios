//
//  NSAttributedString+JK.swift
//  ChichBong
//
//  Created by Sylvanas on 4/14/21.
//

import Foundation

extension NSAttributedString {
    func draw(center: CGPoint) {
        var rect = self.boundingRect(with: CGSize(width: 1000, height: 1000),
                                     options: [.usesFontLeading, .usesLineFragmentOrigin],
                                     context: nil)
        let size = rect.size
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        rect.origin = origin
        self.draw(in: rect)
    }
}
