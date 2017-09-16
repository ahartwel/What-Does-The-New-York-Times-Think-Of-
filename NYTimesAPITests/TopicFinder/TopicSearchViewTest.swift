//
//  TopicSearchViewTest.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/14/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase

class TopicSearchViewTest: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = false
        self.usesDrawViewHierarchyInRect = true
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInitialState() {
        let view = TopicFinderView()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 500)
        FBSnapshotVerifyView(view)
    }
    
    func testStateWithResults() {
        let exp = self.expectation(description: "view will layout properly")
        let view = TopicFinderView()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 500)
        let viewModel = TopicFinderViewModel(delegate: TopicFinderViewModelDelegateStub())
        view.bind(to: viewModel, withActions: viewModel)
        view.onKeyboardOpen(withFrame: CGRect.zero)
        viewModel.currentResults.value = [
            TimesTag(fullTag: "testing"),
            TimesTag(fullTag: "testing2"),
            TimesTag(fullTag: "testing3"),
            TimesTag(fullTag: "testing4"),
            TimesTag(fullTag: "testing5")
        ]
        DispatchQueue.main.async {
            self.FBSnapshotVerifyView(view)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testTextFieldIsUpdatedAfterSelectedTag() {
        let exp = self.expectation(description: "view will layout properly")
        let view = TopicFinderView()
        let viewModelDelegate = TopicFinderViewModelDelegateStub()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 500)
        let viewModel = TopicFinderViewModel(delegate: viewModelDelegate)
        view.bind(to: viewModel, withActions: viewModel)
        view.onKeyboardOpen(withFrame: CGRect.zero) //make sure the view gets laid out properly
        viewModel.currentResults.value = [
            TimesTag(fullTag: "testing"),
            TimesTag(fullTag: "testing2"),
            TimesTag(fullTag: "testing3"),
            TimesTag(fullTag: "testing4"),
            TimesTag(fullTag: "testing5")
        ]
        DispatchQueue.main.async {
            view.tableView(view.resultsTableView, didSelectRowAt: IndexPath.init(row: 0, section: 0))
            DispatchQueue.main.async {
                self.FBSnapshotVerifyView(view)
                exp.fulfill()
            }
        }
        self.waitForExpectations(timeout: 0.3, handler: nil)
    }
    
}
