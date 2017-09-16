//
//  TimesTagAPIInjector.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

protocol TimesTagRequester {
    var timesTagApi: TimesTagAPI { get }
}

extension TimesTagRequester {
    var timesTagApi: TimesTagAPI {
        return mainTimesTagAPI
    }
}

fileprivate var mainTimesTagAPI: TimesTagAPI = {
    return TimesTagApiImplementation()
}()
