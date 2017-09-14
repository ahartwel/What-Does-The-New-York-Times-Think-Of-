//
//  TimesArticleAPIDependencyInjector.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

protocol TimesArticleRequester {
    var timesArticleApi: TimesArticleAPI { get }
}

extension TimesArticleRequester {
    var timesArticleApi: TimesArticleAPI {
        return mainTimesArticleAPI
    }
}

fileprivate var mainTimesArticleAPI: TimesArticleAPI = {
    return TimesArticleAPIImplementation()
}()
