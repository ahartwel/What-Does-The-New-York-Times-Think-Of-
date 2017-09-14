//
//  TimesArticleApiDefinition.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum TimesArticleAPIDefinition {
    case getArticles(byTag: TimesTag)
}

extension TimesArticleAPIDefinition: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.nytimes.com")!
    }

    var path: String {
        switch self {
        case .getArticles:
            return "/svc/search/v2/articlesearch.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArticles:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        params["api-key"] = "22a446284ae54d38815727523d44acb4"
        switch self {
        case .getArticles(let tag):
            params["q"] = tag.fullTag
            params["fl"] = "snippet, headline" //we only want the api to return the headline and the snippet
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
