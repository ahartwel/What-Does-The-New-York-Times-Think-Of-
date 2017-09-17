//
//  TopicFinderViewModelTests.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
@testable import NYTimesAPI

class TopicFinderViewModelTests: XCTestCase {
    
    var viewModelDelegateStub: TopicFinderViewModelDelegateStub = TopicFinderViewModelDelegateStub()
    
    var viewModel: TopicFinderViewModel!
    var actions: TopicFinderActions {
        return self.viewModel
    }
    
    override func setUp() {
        super.setUp()
        TestingStubs.timesTagApiStub = TimesTagApiStub()
        self.viewModelDelegateStub = TopicFinderViewModelDelegateStub()
        self.viewModel = TopicFinderViewModel(delegate: self.viewModelDelegateStub)
    }
    
    func testChangeQueryToNonEmptyString() {
        TestingStubs.timesTagApiStub.getTagsReturnValue = [
            TimesTag(fullTag: "test"),
            TimesTag(fullTag: "test"),
            TimesTag(fullTag: "test")
        ]
        
        self.actions.searchQueryChanged(to: "testsestsetsetstetet")
        self.runTestAsync {
            XCTAssertEqual(self.viewModel.currentResults.value.count, 3)
        }
    }
    
    func testChangeQueryToEmptyString() {
        self.actions.searchQueryChanged(to: "")
        self.runTestAsync {
            XCTAssertEqual(self.viewModel.currentResults.value.count, 0)
        }
    }
    
    func testApiError() {
        TestingStubs.timesTagApiStub.getTagsReturnError = NYTimesError(title: "test", description: "testing")
        self.actions.searchQueryChanged(to: "123")
        self.runTestAsync {
            XCTAssertEqual(self.viewModelDelegateStub.calledShowError, true)
        }
    }
    
    func testSelectTagAtIndex() {
        self.viewModel.currentResults.value = [
            TimesTag(fullTag: "test1"),
            TimesTag(fullTag: "test2"),
            TimesTag(fullTag: "test3")
        ]
        let string = self.actions.selectedTag(atIndex: 1)
        XCTAssertEqual(self.viewModelDelegateStub.calledUserSelectedTag, true)
        XCTAssertEqual(self.viewModelDelegateStub.calledUserSelectedTagWithTag?.fullTag, "test2")
        XCTAssertEqual(string, "test2")
    }
    
    func testCallingSelectTagAtNegativeIndex() {
        _ = self.actions.selectedTag(atIndex: -1)
        XCTAssertEqual(self.viewModelDelegateStub.calledUserSelectedTag, false)
    }
    
    func testCallingSelectTagAtIndexOutOfRange() {
        _ = self.actions.selectedTag(atIndex: 1)
        XCTAssertEqual(self.viewModelDelegateStub.calledUserSelectedTag, false)
    }
    
}
