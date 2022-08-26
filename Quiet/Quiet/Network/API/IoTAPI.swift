//
//  IoTAPI.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Moya

protocol IoTAPIType {
    func fetchDatasetInfo(completion: @escaping (([DatasetInfo]) -> ()))
    func fetchColDesc(datasetNo: Int, completion: @escaping (([ColDescInfo]) -> ()))
    func fetchInstlInfo(datasetNo: Int, completion: @escaping (([InstallInfo]) -> ()))
    func fetchInquiry(datasetNo: Int, modelSerial: String, inqDt: String, currPageNo: Int, completion: @escaping (([InquiryInfo]) -> ()))
}

final class IoTAPI: IoTAPIType {
    
    private let provider = MoyaProvider<IoTService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private var datasetInfoResponse: DatasetInfoDTO?
    private var colDescInfoResponse: ColDescInfoDTO?
    private var installInfoResponse: InstallInfoDTO?
    private var inquiryInfoResponse: InquiryInfoDTO?
    
    func fetchDatasetInfo(completion: @escaping (([DatasetInfo]) -> ())) {
        provider.request(.datasetInfo, callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                do {
                    self.datasetInfoResponse = try data.map(DatasetInfoDTO.self)
                    dump(self.datasetInfoResponse?.resultData)
                    completion(self.datasetInfoResponse?.resultData ?? [])
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchColDesc(datasetNo: Int, completion: @escaping (([ColDescInfo]) -> ())) {
        provider.request(.colDesc(datasetNo: datasetNo), callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                do {
                    self.colDescInfoResponse = try data.map(ColDescInfoDTO.self)
                    dump(self.colDescInfoResponse?.resultData)
                    completion(self.colDescInfoResponse?.resultData ?? [])
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchInstlInfo(datasetNo: Int, completion: @escaping (([InstallInfo]) -> ())) {
        provider.request(.instlInfo(datasetNo: datasetNo), callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                do {
                    self.installInfoResponse = try data.map(InstallInfoDTO.self)
                    completion(self.installInfoResponse?.resultData ?? [])
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchInquiry(datasetNo: Int, modelSerial: String, inqDt: String, currPageNo: Int, completion: @escaping (([InquiryInfo]) -> ())) {
        provider.request(.inquiry(datasetNo: datasetNo, modelSerial: modelSerial, inqDt: inqDt, currPageNo: currPageNo), callbackQueue: .global()) { response in
            switch response {
            case .success(let data):
                do {
                    self.inquiryInfoResponse = try data.map(InquiryInfoDTO.self)
                    completion(self.inquiryInfoResponse?.resultData ?? [])
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
