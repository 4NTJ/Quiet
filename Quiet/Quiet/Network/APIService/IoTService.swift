//
//  IoTService.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import Foundation
import Moya

enum IoTService {
    case datasetInfo
    case colDesc(datasetNo: Int)
    case instlInfo(datasetNo: Int)
    case inquiry(datasetNo: Int, modelSerial: String, inqDt: String, currPageNo: Int)
}

extension IoTService: TargetType {
    public var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .datasetInfo:
            return "/datasetInfo/\(GeneralAPI.apiKey)"
        case .colDesc(let datasetNo):
            return "/colDesc/\(GeneralAPI.apiKey)/\(datasetNo)/1"
        case .instlInfo(let datasetNo):
            return "/instlInfo/\(GeneralAPI.apiKey)/\(datasetNo)/1"
        case .inquiry(let datasetNo, _, _, _):
            return "/inquiry/\(GeneralAPI.apiKey)/\(datasetNo)/1"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .inquiry(_, let modelSerial, let inqDt, let currPageNo):
            let query = Inquiry(modelSerial: modelSerial, inqDt: inqDt, currPageNo: currPageNo)
            return .requestParameters(parameters: try! query.asDictionary(), encoding: URLEncoding.default)
        default:
            return.requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

