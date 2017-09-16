//
//  SentimentAnalyzerViewModel.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import PromiseKit

protocol SentimentAnalyzerActions {
    func set(tag: TimesTag)
}

enum Sentiment {
    case good
    case neutral
    case bad
    case unknown
}
extension Sentiment {
    var emoji: String {
        switch self {
        case .good:
            return "😀"
        case .bad:
            return "😕"
        case .neutral:
            return "😐"
        case .unknown:
            return "🤖"
        }
    }
    var string: String {
        switch self {
        case .good:
            return "good"
        case .bad:
            return "bad"
        case .unknown:
            return ""
        case .neutral:
            return "neutral"
        }
    }
}

enum LoadingStatus {
    case error
    case gettingArticles
    case analysingArticles
    case done
}

extension LoadingStatus {
    var string: String {
        switch self {
        case .error:
            return "Something went wrong"
        case .gettingArticles:
            return "Getting articles..."
        case .analysingArticles:
            return "Analyzing the articles..."
        case .done:
            return ""
        }
    }
}

protocol SentimentAnalyzerBindables {
    var currentTag: Observable<TimesTag?> { get }
    var articles: Observable<[TimesArticle]> { get }
    var sentiment: Observable<Sentiment> { get }
    var sentimentEmojiString: Observable<String> { get }
    var overalSentimentString: Observable<String> { get }
    var loadingStatus: Observable<LoadingStatus> { get }
    var loadingText: Signal<String, NoError> { get }
}

protocol SentimentAnalyzerViewModelDelegate: class, ErrorPresenter {
}

class SentimentAnalyzerViewModel: SentimentAnalyzerBindables, TimesArticleRequester, SentimentAnalyzerRequester {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    //bindable properties
    var currentTag: Observable<TimesTag?> = Observable<TimesTag?>(nil)
    var articles: Property<[TimesArticle]> = Observable<[TimesArticle]>([])
    var sentiment: Property<Sentiment> = Observable<Sentiment>(.unknown)
    var sentimentEmojiString: Observable<String> = Observable<String>("")
    var overalSentimentString: Observable<String> = Observable<String>("")
    var loadingStatus: Property<LoadingStatus> = Observable<LoadingStatus>(.gettingArticles)
    // swiftlint:disable:next line_length
    lazy var loadingText: Signal<String, NoError> = combineLatest(self.sentiment, self.loadingStatus, combine: { (sentiment, status) -> String in
        if sentiment == Sentiment.unknown && status == LoadingStatus.done {
            return ""
        }
        return status.string
    })
    unowned var delegate: SentimentAnalyzerViewModelDelegate
    
    init(withDelegate delegate: SentimentAnalyzerViewModelDelegate) {
        self.delegate = delegate
        self.setUpLoaderBinds()
    }
    
    func setUpLoaderBinds() {
        self.sentiment.observeNext(with: { _ in
            self.loadingStatus.value = .done
        }).dispose(in: self.disposeBag)
        
        self.articles.observeNext(with: { articles in
            self.loadingStatus.value = .analysingArticles
            self.preformSentimentAnalysis(onArticles: articles)
        }).dispose(in: self.disposeBag)
        
        self.currentTag.observeNext(with: { tag in
            guard let tag = tag else {
                return
            }
            self.overalSentimentString.value = Sentiment.unknown.emoji
            self.sentimentEmojiString.value = ""
            self.loadingStatus.value = .gettingArticles
            self.getArticles(forTag: tag)
        }).dispose(in: self.disposeBag)
    
    }
    
    func getArticles(forTag tag: TimesTag) {
        self.timesArticleApi.getArticles(fromTag: tag).then { articles -> Void in
            self.articles.value = articles
        }.catch { error -> Void in
            self.delegate.show(error: error)
            self.loadingStatus.value = .error
        }
    }
    
    func preformSentimentAnalysis(onArticles articles: [TimesArticle]) {
        self.sentimentAnalyzer.analyze(timesArticles: articles).then { sentiments -> Void in
            let sentiment = self.sentimentAnalyzer.mostCommonSentiment(from: sentiments)
            self.sentiment.value = sentiment
            self.animateSentimentsIn(sentiments: sentiments)
            }.catch { error -> Void in
            self.delegate.show(error: error)
            self.loadingStatus.value = .error
        }
    }
    
    func animateSentimentsIn(sentiments: [Sentiment]) {
        self.sentimentEmojiString.value = ""
        
        let delayAddition: TimeInterval = 0.1
        var delay: TimeInterval = 0
        for sentiment in sentiments {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.sentimentEmojiString.value += sentiment.emoji
            }
            delay += delayAddition
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.overalSentimentString.value = self.sentiment.value.emoji
        }
    }
    
}

extension SentimentAnalyzerViewModel: SentimentAnalyzerActions {
    func set(tag: TimesTag) {
        self.currentTag.value = tag
    }
}
