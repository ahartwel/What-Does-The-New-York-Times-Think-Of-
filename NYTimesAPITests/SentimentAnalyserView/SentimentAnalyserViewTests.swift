//
//  SentimentAnalyserViewTests.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/16/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase

class SentimentAnalyserViewTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = false
        self.usesDrawViewHierarchyInRect = true
    }
    
    func testInitialStateAfterSelectingTag() {
        let exp = self.expectation(description: "view will layout properly")
        let view = SentimentAnalysisView()
        let viewModelDelegate = SentimentAnalyzerViewModelDelegateStub()
        let viewModel = SentimentAnalyzerViewModel(withDelegate: viewModelDelegate)
        view.bind(to: viewModel, withActions: viewModel)
        view.onKeyboardClose() //the view isn't visible until the keyboard is closed
        viewModel.set(tag: TimesTag(fullTag: "testing"))
        view.frame = CGRect(x: 0, y: 0, width: 350, height: 500)
        DispatchQueue.main.async {
            self.FBSnapshotVerifyView(view)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testStateWhileAnalysingArticles() {
        let exp = self.expectation(description: "view will layout properly")
        let view = SentimentAnalysisView()
        let viewModelDelegate = SentimentAnalyzerViewModelDelegateStub()
        sentimentAnalyzerStub.delayforAnalyze = 3
        timesArticleApiStub.getArticlesDelay = 10
        let viewModel = SentimentAnalyzerViewModel(withDelegate: viewModelDelegate)
        view.bind(to: viewModel, withActions: viewModel)
        view.onKeyboardClose() //the view isn't visible until the keyboard is closed
        viewModel.set(tag: TimesTag(fullTag: "testing"))
        viewModel.articles.value = [
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet")
        ]
        view.frame = CGRect(x: 0, y: 0, width: 350, height: 500)
        DispatchQueue.main.async {
            self.FBSnapshotVerifyView(view)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 1.6, handler: nil)
    }
    
    func testStateAfterAnalysingArticles() {
        let exp = self.expectation(description: "view will layout properly")
        let view = SentimentAnalysisView()
        let viewModelDelegate = SentimentAnalyzerViewModelDelegateStub()
        let viewModel = SentimentAnalyzerViewModel(withDelegate: viewModelDelegate)
        sentimentAnalyzerStub.delayforAnalyze = 0
        sentimentAnalyzerStub.analyzeReturn = [
            .good,
            .bad,
            .unknown,
            .good,
            .bad,
            .bad,
            .good,
            .good,
            .good,
            .bad
        ]
        view.bind(to: viewModel, withActions: viewModel)
        view.onKeyboardClose() //the view isn't visible until the keyboard is closed
        viewModel.articles.value = [
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet"),
            TimesArticle(headline: "headline wooh yeah", snippet: "this is a text snippet")
        ]
        view.frame = CGRect(x: 0, y: 0, width: 350, height: 500)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.FBSnapshotVerifyView(view)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 1.6, handler: nil)
    }
    
}
