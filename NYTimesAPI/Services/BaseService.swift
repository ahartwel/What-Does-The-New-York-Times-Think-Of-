//
//  BaseService.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import SwiftyJSON

class ServiceSettings {
    static var stubRequests: Bool = false
}

class BaseService<T: TargetType> {
    
    lazy var provider: MoyaProvider<T> = {
        let provider = MoyaProvider<T>(stubClosure: { _ -> Moya.StubBehavior in
            if ServiceSettings.stubRequests {
                return .immediate
            }
            return .never
        })
        return provider
    }()
    
    func makeRequest(target: T) -> Promise<JSON> {
        let (promise, fulfill, reject) = Promise<JSON>.pending()
        self.provider.request(target, completion: { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                if let string = String.init(data: data, encoding: .utf8) {
                    let json = JSON(parseJSON: string)
                    return fulfill(json)
                }
                let json = JSON(data)
                fulfill(json)
            case let .failure(error):
                reject(error)
            }
            
        })
        return promise
    }
}
