//
//  Encodable+Extension.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { throw NSError() }
        return dictionary
    }
}
