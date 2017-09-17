//
//  MainViewControllerTests.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/17/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
@testable import NYTimesAPI

class MainViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimesTagIsPassedToSentimentAnalyzerViewModelProperly() {
        let mainController = MainViewController()
        mainController.selected(tag: TimesTag(fullTag: "tag, tag, tag"))
        XCTAssertEqual(mainController.sentimentAnalysisViewModel.currentTag.value?.fullTag, "tag, tag, tag")
    }
    
    func testViewIsSet() {
        let mainController = MainViewController()
        mainController.loadView()
        XCTAssertEqual(mainController.view is MainView, true)
    }
    
    func testViewModelsArePassedToViews() {
        let mainController = MainViewController()
        mainController.loadView()
        XCTAssertNotNil(mainController.mainView.topicFinderView.actions)
        XCTAssertNotNil(mainController.mainView.sentimentAnalysisView.actions)
    }
    
    func testReadmeIsPresented() {
        let mainController = MainViewController()
        mainController.loadView()
        mainController.tappedHelp()
        XCTAssertEqual(mainController.calledPresentViewController, true)
        XCTAssertEqual(mainController.calledPresentViewControllerWithController is UINavigationController, true)
    }
    
}
