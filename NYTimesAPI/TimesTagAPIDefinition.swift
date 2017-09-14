//
//  TimesTagAPI.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum TimesTagAPIDefinition {
    case getTags(query: String)
}

extension TimesTagAPIDefinition: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.nytimes.com")!
    }
    
    var path: String {
        switch self {
            case .getTags:
                return "/svc/suggest/v1/timestags"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTags:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        params["api-key"] = "22a446284ae54d38815727523d44acb4"
        switch self {
            case .getTags(let query):
            params["query"] = query
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
    
}
