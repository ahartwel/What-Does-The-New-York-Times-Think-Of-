//
//  SentimentAnalyzerStub.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/16/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import PromiseKit

class SentimentAnalyzerStub: SentimentAnalyzer {
    
    var calledAnalyze: Bool = false
    var calledAnalyzeWithArticles: [TimesArticle]?
    var analyzeReturn: [Sentiment] = []
    var delayforAnalyze: Double = 0
    func analyze(timesArticles: [TimesArticle]) -> Promise<[Sentiment]> {
        self.calledAnalyze = true
        let (promise, fulfill, _) = Promise<[Sentiment]>.pending()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + self.delayforAnalyze) {
            DispatchQueue.main.async {
                fulfill(self.analyzeReturn)
            }
        }
        return promise
    }
    
}
