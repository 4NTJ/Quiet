//
//  ColDescInfo.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

/// 도시 환경 데이터 13번 column - 소음
/// 유동 인구 데이터 7번 column - 방문자 수

struct ColDescInfoDTO: Codable {
    let datasetNo: String?
    let dataNo: String?
    let resultData: [ColDescInfo]
    let resultCode: String?
    let resultMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case datasetNo = "dataset_no"
        case dataNo = "data_no"
        case resultData = "result_data"
        case resultCode = "result_code"
        case resultMsg = "result_msg"
    }
}

struct ColDescInfo: Codable {
    let colNo: Int?
    let colType: String?
    let colNM: String?
    let colLen: Int?
    let colUnit: String?
    let colCtgr: String?
    let colDesc: String?
    let publicType: String?
    
    enum CodingKeys: String, CodingKey {
        case colNo = "col_no"
        case colType = "col_type"
        case colNM = "col_nm"
        case colLen = "col_len"
        case colUnit = "col_unit"
        case colCtgr = "col_ctgr"
        case colDesc = "col_desc"
        case publicType = "public_type"
    }
}
