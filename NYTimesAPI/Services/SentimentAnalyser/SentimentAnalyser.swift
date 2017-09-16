//
//  SentimentAnalyzer.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import PromiseKit
import CoreML

protocol SentimentAnalyzer {
    func analyze(timesArticles: [TimesArticle]) -> Promise<[Sentiment]>
}

extension SentimentPolarityOutput {
    var sentiment: Sentiment {
        switch self.classLabel {
        case "Pos":
            return .good
        case "Neg":
            return .bad
        default:
            return .neutral
        }
    }
}

extension SentimentAnalyzer {
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

class SentimentAnalyzerImplementation: SentimentAnalyzer {
    
    //*****using model and some code from https://github.com/cocoa-ai/SentimentCoreMLDemo *******
    var model: SentimentPolarity = SentimentPolarity()
    private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
    private lazy var tagger: NSLinguisticTagger = .init(
        tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
        options: Int(self.options.rawValue)
    )
    
    func analyze(timesArticle: TimesArticle) -> Sentiment {
        let text = timesArticle.headline + " " + timesArticle.snippet
        do {
            let inputFeatures = features(from: text)
            // Make prediction only with 2 or more words
            guard inputFeatures.count > 1 else {
                return .neutral
            }
            
            let output = try model.prediction(input: inputFeatures)
            return output.sentiment
        } catch {
            return .neutral
        }
    }
    
    func analyze(timesArticles: [TimesArticle]) -> Promise<[Sentiment]> {
        let (promise, fulfill, _) = Promise<[Sentiment]>.pending()
        var sentiments: [Sentiment] = []
        DispatchQueue.global(qos: .background).async {
            sentiments = timesArticles.map({
                return self.analyze(timesArticle: $0)
            })
            fulfill(sentiments)
        }
        return promise
    }
    
    func features(from text: String) -> [String: Double] {
        var wordCounts = [String: Double]()
        
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // Tokenize and count the sentence
        tagger.enumerateTags(in: range,
                             scheme: .nameType,
                             options: options) { _, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange).lowercased()
            // Skip small words
            guard token.count >= 3 else {
                return
            }
            
            if let value = wordCounts[token] {
                wordCounts[token] = value + 1.0
            } else {
                wordCounts[token] = 1.0
            }
        }
        
        return wordCounts
    }
}

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