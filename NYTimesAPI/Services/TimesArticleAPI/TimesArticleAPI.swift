//
//  TimesArticleAPI.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import PromiseKit

protocol TimesArticleAPI {
    func getArticles(fromTag tag: TimesTag) -> Promise<[TimesArticle]>
}

class TimesArticleAPIImplementation: TimesArticleAPI {
    
    lazy var baseService: BaseService<TimesArticleAPIDefinition> = {
        return BaseService<TimesArticleAPIDefinition>()
    }()
    
    func getArticles(fromTag tag: TimesTag) -> Promise<[TimesArticle]> {
        return self.baseService.makeRequest(target: .getArticles(byTag: tag)).then { json -> [TimesArticle] in
            let response = json["response"]
            guard let data = response["docs"].array else {
                throw NSError(domain: "Couldn't load NYTimes articles", code: 100, userInfo: nil)
            }
            return data.flatMap({
                if let title = $0["headline"]["main"].string, let snippet = $0["snippet"].string {
                    return TimesArticle(headline: title, snippet: snippet)
                }
                return nil
            })
        }
    }
}

class TimesArticleAPIStub: TimesArticleAPI {
    
    var calledGetArticles: Bool = false
    var getArticlesReturnValue: [TimesArticle]?
    var getArticlesReturnError: Swift.Error?
    var getArticlesDelay: Double = 0
    func getArticles(fromTag tag: TimesTag) -> Promise<[TimesArticle]> {
        let (promise, fulfill, reject) = Promise<[TimesArticle]>.pending()
        self.calledGetArticles = true
        if let error = self.getArticlesReturnError {
            reject(error)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.getArticlesDelay, execute: {
                fulfill(self.getArticlesReturnValue ?? [])
            })
        }
        return promise
    }
}
