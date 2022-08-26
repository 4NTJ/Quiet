//
//  InquiryInfo.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

struct InquiryInfoDTO: Codable {
    let datasetNo: String?
    let dataNo: String?
    let totRowCnt: Int?
    let maxRowPerPage: Int?
    let totalPageNo: Int?
    let currentRowCnt: Int?
    let currentPageNo: Int?
    let resultData: [InquiryInfo]
    let resultCode: String?
    let resultMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case datasetNo = "dataset_no"
        case dataNo = "data_no"
        case totRowCnt = "tot_row_cnt"
        case maxRowPerPage = "max_row_per_page"
        case totalPageNo = "tot_page_no"
        case currentRowCnt = "curr_row_cnt"
        case currentPageNo = "curr_page_no"
        case resultData = "result_data"
        case resultCode = "result_code"
        case resultMsg = "result_msg"
    }
}

struct InquiryInfo: Codable {
    let modlSerial: String?
    let seq: Int?
    let column1: String?
    let column2: String?
    let column3: String?
    let column4: String?
    let column5: String?
    let column6: String?
    let column7: String?
    let column8: String?
    let column9: String?
    let column10: String?
    let column11: String?
    let column12: String?
    let column13: String?
    let column14: String?
    let column15: String?
    let column16: String?
    let column17: String?
    let column18: String?
    let column19: String?
    let column20: String?
    let column21: String?
    let column22: String?
    let column23: String?
    let column24: String?
    let column25: String?
    let column26: String?
    let column27: String?
    let column28: String?
    let column29: String?
    let column30: String?
    let column31: String?
    
    enum CodingKeys: String, CodingKey {
        case modlSerial = "modl_serial"
        case seq, column1, column2, column3, column4, column5, column6
        case column7, column8, column9, column10, column11, column12
        case column13, column14, column15, column16, column17, column18
        case column19, column20, column21, column22, column23, column24, column25
        case column26, column27, column28, column29, column30, column31
    }
}

