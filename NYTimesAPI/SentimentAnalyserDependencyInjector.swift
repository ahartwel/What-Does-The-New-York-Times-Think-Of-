//
//  SentimentAnalyserDependencyInjector.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

protocol SentimentAnalyserRequester {
    var sentimentAnalyser: SentimentAnalyser { get }
}

extension SentimentAnalyserRequester {
    var sentimentAnalyser: SentimentAnalyser {
        return mainSentimentAnalyser
    }
}

fileprivate var mainSentimentAnalyser = SentimentAnalyserImplementation()
