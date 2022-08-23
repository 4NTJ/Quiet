//
//  NSObject+Extension.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
