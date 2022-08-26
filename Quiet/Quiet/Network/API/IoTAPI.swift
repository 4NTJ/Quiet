//
//  IoTAPI.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Moya

protocol IoTAPIType {
    func fetchDatasetInfo()
    func fetchColDesc(datasetNo: Int)
    func fetchInstlInfo(datasetNo: Int)
    func fetchInquiry(datasetNo: Int, modelSerial: String, inqDt: String, currPageNo: Int)
}

final class IoTAPI: IoTAPIType {
    
    private let provider = MoyaProvider<IoTService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func fetchDatasetInfo() {
        provider.request(.datasetInfo, callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                print(response)
            case .failure(let err):
                print(err.errorDescription)
            }
        }
    }
    
    func fetchColDesc(datasetNo: Int) {
        provider.request(.colDesc(datasetNo: datasetNo), callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                print(response)
            case .failure(let err):
                print(err.errorDescription)
            }
        }
    }
    
    func fetchInstlInfo(datasetNo: Int) {
        provider.request(.instlInfo(datasetNo: datasetNo), callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                print(response)
            case .failure(let err):
                print(err.errorDescription)
            }
        }
    }
    
    func fetchInquiry(datasetNo: Int, modelSerial: String, inqDt: String, currPageNo: Int) {
        provider.request(.inquiry(datasetNo: datasetNo, modelSerial: modelSerial, inqDt: inqDt, currPageNo: currPageNo), callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                print(response)
            case .failure(let err):
                print(err.errorDescription)
            }
        }
    }
}
