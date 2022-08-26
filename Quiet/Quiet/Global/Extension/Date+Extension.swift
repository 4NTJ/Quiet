//
//  Date+Extension.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

extension Date {
    static func getCurrentDate(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko")
        let currentTimeString = formatter.string(from: Date())
        return currentTimeString
    }
}
