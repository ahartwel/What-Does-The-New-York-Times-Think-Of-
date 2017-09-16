//
//  SentimentAnalyzerViewModelTests.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest

var timesArticleApiStub: TimesArticleAPIStub = TimesArticleAPIStub()
var sentimentAnalyzerStub: SentimentAnalyzerStub = SentimentAnalyzerStub()
extension SentimentAnalyzerViewModel {
    var timesArticleApi: TimesArticleAPI {
        return timesArticleApiStub
    }
    var sentimentAnalyzer: SentimentAnalyzer {
        return sentimentAnalyzerStub
    }
}

class SentimentAnalyzerViewModelTests: XCTestCase {
    
    var viewModel: SentimentAnalyzerViewModel?
    // swiftlint:disable:next weak_delegate
    var viewModelDelegate: SentimentAnalyzerViewModelDelegateStub = SentimentAnalyzerViewModelDelegateStub()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = nil
        self.viewModelDelegate = SentimentAnalyzerViewModelDelegateStub()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGettingArticlesCalledWhenTagSet() {
        self.viewModel = SentimentAnalyzerViewModel(withDelegate: self.viewModelDelegate)
        timesArticleApiStub.getArticlesDelay = 5
        self.viewModel?.set(tag: TimesTag(fullTag: ""))
        
        self.runTestAsync {
            XCTAssertEqual(self.viewModel?.loadingStatus.value, LoadingStatus.gettingArticles)
            XCTAssertEqual(timesArticleApiStub.calledGetArticles, true)
        }
    }
    
    func testCalledSentimentAnalyzerOnArticlesSet() {
        sentimentAnalyzerStub.delayforAnalyze = 5
        self.viewModel = SentimentAnalyzerViewModel(withDelegate: self.viewModelDelegate)
        self.viewModel?.articles.value = [TimesArticle(headline: "", snippet: "")]
        self.runTestAsync {
            XCTAssertEqual(self.viewModel?.loadingStatus.value, LoadingStatus.analysingArticles)
            XCTAssertEqual(sentimentAnalyzerStub.calledAnalyze, true)
        }
    }
    
    func testLoadingIsSetToDoneOnSentimentSet() {
        self.viewModel = SentimentAnalyzerViewModel(withDelegate: self.viewModelDelegate)
        self.viewModel?.sentiment.value = .good
        self.runTestAsync {
            XCTAssertEqual(self.viewModel?.loadingStatus.value, LoadingStatus.done)
        }
    }
    
}
