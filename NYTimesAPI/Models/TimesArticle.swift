//
//  TimesArticle.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

struct TimesArticle {
    var headline: String
    var snippet: String
}

extension TimesArticle {
    func getSentiment() -> Sentiment {
        //TODO: update this to use CoreML
        return Sentiment.good
    }
}
