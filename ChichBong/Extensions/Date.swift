//
//  Date.swift
//  ChichBong
//
//  Created by Sylvanas on 4/27/21.
//

import Foundation
import UIKit

extension Date {
    func getElapsedInterval() -> String {

        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "năm trước" :
                "\(year)" + " " + "năm trước"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "tháng trước" :
                "\(month)" + " " + "tháng trước"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "ngày trước" :
                "\(day)" + " " + "ngày trước"
        } else {
            return "mới gần đây"

        }

    }
}
