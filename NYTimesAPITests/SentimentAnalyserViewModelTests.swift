//
//  SentimentAnalyserViewModelTests.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest

fileprivate var timesArticleApiStub: TimesArticleAPIStub = TimesArticleAPIStub()
fileprivate var sentimentAnalyserStub: SentimentAnalyserStub = SentimentAnalyserStub()
extension SentimentAnalyserViewModel {
    var timesArticleApi: TimesArticleAPI {
        return timesArticleApiStub
    }
    var sentimentAnalyser: SentimentAnalyser {
        return sentimentAnalyserStub
    }
}

class SentimentAnalyserViewModelTests: XCTestCase {
    
    var viewModel: SentimentAnalyserViewModel?
    // swiftlint:disable:next weak_delegate
    var viewModelDelegate: SentimentAnalyserViewModelDelegateStub = SentimentAnalyserViewModelDelegateStub()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = nil
        self.viewModelDelegate = SentimentAnalyserViewModelDelegateStub()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGettingArticlesCalledWhenTagSet() {
        self.viewModel = SentimentAnalyserViewModel(withDelegate: self.viewModelDelegate)
        timesArticleApiStub.getArticlesDelay = 5
        self.viewModel?.set(tag: TimesTag(fullTag: ""))
        
        self.runTestAsync {
            XCTAssertEqual(self.viewModel?.loadingStatus.value, LoadingStatus.gettingArticles)
            XCTAssertEqual(timesArticleApiStub.calledGetArticles, true)
        }
    }
    
    func testCalledSentimentAnalyserOnArticlesSet() {
        sentimentAnalyserStub.delayforAnalyse = 5
        self.viewModel = SentimentAnalyserViewModel(withDelegate: self.viewModelDelegate)
        self.viewModel?.articles.value = [TimesArticle(headline: "", snippet: "")]
        self.runTestAsync {
            XCTAssertEqual(self.viewModel?.loadingStatus.value, LoadingStatus.analysingArticles)
            XCTAssertEqual(sentimentAnalyserStub.calledAnalyse, true)
        }
    }
    
    func testLoadingIsSetToDoneOnSentimentSet() {
        self.viewModel = SentimentAnalyserViewModel(withDelegate: self.viewModelDelegate)
        self.viewModel?.sentiment.value = .good
        self.runTestAsync {
            XCTAssertEqual(self.viewModel?.loadingStatus.value, LoadingStatus.done)
        }
    }
    
}
