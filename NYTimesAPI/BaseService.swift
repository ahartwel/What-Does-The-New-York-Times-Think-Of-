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

class BaseService<T: TargetType> {
    
    lazy var provider: MoyaProvider<T> = {
        let provider = MoyaProvider<T>()
        return provider
    }()
    
    func makeRequest(target: T) -> Promise<JSON> {
        let (promise, fulfill, reject) = Promise<JSON>.pending()
        self.provider.request(target, completion: { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                fulfill(json)
            case let .failure(error):
                reject(error)
            }
            
        })
        return promise
    }
}
