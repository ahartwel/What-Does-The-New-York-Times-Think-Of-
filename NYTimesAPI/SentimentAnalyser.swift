//
//  SentimentAnalyser.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import PromiseKit

protocol SentimentAnalyser {
    func analyse(timesArticles: [TimesArticle]) -> Promise<[Sentiment]>
}

extension SentimentAnalyser {
    func mostCommonSentiment(from sentiments: [Sentiment]) -> Sentiment {
        var counts: [Sentiment: Int] = [:]
        for sentiment in sentiments {
            if counts[sentiment] == nil {
                counts[sentiment] = 1
                continue
            }
            counts[sentiment]? += 1
        }
        var highest: (sentiment: Sentiment, count: Int) = (.unknown, -1)
        for (sentiment, count) in counts {
            // swiftlint:disable:next for_where
            if count > highest.count {
                highest = (sentiment: sentiment, count: count)
            }
        }
        return highest.sentiment
    }
}

class SentimentAnalyserImplementation: SentimentAnalyser {
    func analyse(timesArticle: TimesArticle) -> Sentiment {
        return .good
    }
    
    func analyse(timesArticles: [TimesArticle]) -> Promise<[Sentiment]> {
        let (promise, fulfill, _) = Promise<[Sentiment]>.pending()
        var sentiments: [Sentiment] = []
        DispatchQueue.global(qos: .background).async {
            sentiments = timesArticles.map({
                return self.analyse(timesArticle: $0)
            })
            fulfill(sentiments)
        }
        return promise
    }
}

class SentimentAnalyserStub: SentimentAnalyser {
    
    var calledAnalyse: Bool = false
    var calledAnalyseWithArticles: [TimesArticle]?
    var analyseReturn: [Sentiment] = []
    var delayforAnalyse: Double = 0
    func analyse(timesArticles: [TimesArticle]) -> Promise<[Sentiment]> {
        self.calledAnalyse = true
        let (promise, fulfill, _) = Promise<[Sentiment]>.pending()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + self.delayforAnalyse) {
            DispatchQueue.main.async {
             fulfill(self.analyseReturn)   
            }
        }
        return promise
    }
    
}
