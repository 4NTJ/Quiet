//
//  InstallInfo.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

struct InstallInfoDTO: Codable {
    let datasetNo: String?
    let dataNo: String?
    let resultData: [InstallInfo]
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

struct InstallInfo: Codable {
    let modlSerial: String?
    let postNO: String?
    let address: String?
    let addressDtl: String?
    let crdntType: String?
    let latitude: String?
    let longitude: String?
    let antcty: Int?
    let buldNM: String?
    let instlFloor: Int?
    let instlRoomNo: Int?
    let useYN: String?
    
    enum CodingKeys: String, CodingKey {
        case modlSerial = "modl_serial"
        case postNO = "post_no"
        case addressDtl = "address_dtl"
        case crdntType = "crdnt_type"
        case latitude = "la"
        case longitude = "lo"
        case buldNM = "buld_nm"
        case instlFloor = "instl_floor"
        case instlRoomNo = "instl_room_no"
        case useYN = "use_yn"
        case address = "address"
        case antcty = "antcty"
    }
}
