//
//  GNetworkTool.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import Foundation
import Moya

enum GNetworkTool{
    enum GNteworkCategory :String {
        case all = "all"
        case android = "Android"
        case ios = "iOS"
        case welfare = "福利"
    }
    case data(type:GNteworkCategory, size:Int, index: Int)
}

extension GNetworkTool:TargetType{
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "http://gank.io/api/data/")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .data(let type, let size, let index):
            return "\(type.rawValue)/\(size)/\(index)"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "feng".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .request
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
}

let GNetTool = RxMoyaProvider<GNetworkTool>()
