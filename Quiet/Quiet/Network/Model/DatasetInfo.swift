//
//  DatasetInfo.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation

struct DatasetInfoDTO: Codable {
    let resultData: [DatasetInfo]
    
    enum CodingKeys: String, CodingKey {
        case resultData = "result_data"
    }
}

struct DatasetInfo: Codable {
    let datasetNo: Int?
    let dataNo: Int?
    let datasetNM: String?
    let organNM: String?
    let hctgrNM: String?
    let lctgrNM: String?
    let datasetDesc: String?
    let datasetStat: String?
    let dataCnt: Int?
    let modlInstlCnt: Int?
    
    enum CodingKeys: String, CodingKey {
        case datasetNo = "dataset_no"
        case dataNo = "data_no"
        case datasetNM = "dataset_nm"
        case organNM = "organ_nm"
        case hctgrNM = "hctgr_nm"
        case lctgrNM = "lctgr_nm"
        case datasetDesc = "dataset_desc"
        case datasetStat = "dataset_stat"
        case dataCnt = "data_cnt"
        case modlInstlCnt = "modl_instl_cnt"
    }
}
