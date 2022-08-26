//
//  InquiryQuery.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

struct InquiryQuery: Codable {
    let modelSerial: String
    let inqDt: String
    let currPageNo: Int
}
