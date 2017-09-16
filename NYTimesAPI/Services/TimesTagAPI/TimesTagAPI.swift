//
//  TimesTagAPI.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import PromiseKit

protocol TimesTagAPI {
    func getTags(wihQuery query: String) -> Promise<[TimesTag]>
}

class TimesTagApiImplementation: TimesTagAPI {
    
    lazy var baseService: BaseService<TimesTagAPIDefinition> = {
        return BaseService<TimesTagAPIDefinition>()
    }()
    
    func getTags(wihQuery query: String) -> Promise<[TimesTag]> {
        return self.baseService.makeRequest(target: .getTags(query: query)).then { json -> [TimesTag] in
            // the api gives a really wierd response an array where the first item is your query
            // and the second item is the responses
            // [the query, [the responses]]
            guard let array = json.array, let tagArray = array[1].array else {
                throw NSError(domain: "Expecting JSON Array in Times Tag API Response", code: 100, userInfo: nil)
            }
            return tagArray.flatMap({
                if let fullTag = $0.string {
                    return TimesTag(fullTag: fullTag)
                }
                return nil
            })
        }
    }
}

class TimesTagApiStub: TimesTagAPI {
    
    var calledGetTags: Bool = false
    var getTagsReturnValue: [TimesTag]?
    var getTagsReturnError: Swift.Error?
    
    func getTags(wihQuery query: String) -> Promise<[TimesTag]> {
        let (promise, fulfill, reject) = Promise<[TimesTag]>.pending()
        self.calledGetTags = true
        if let error = self.getTagsReturnError {
            reject(error)
        } else {
            fulfill(self.getTagsReturnValue ?? [])
        }
        return promise
    }
}
