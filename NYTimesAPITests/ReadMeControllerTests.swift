//
//  ReadMeControllerTests.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/17/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
import Down
@testable import NYTimesAPI
class ReadMeControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTitleIsSet() {
        let controller = ReadMeController()
        controller.loadView()
        XCTAssertEqual(controller.title, "About")
    }
    
    func testViewIsDownView() {
        let controller = ReadMeController()
        controller.loadView()
        XCTAssertEqual(controller.view is DownView, true)
    }
    
    func testNavigationItemIsSet() {
        let controller = ReadMeController()
        controller.viewWillAppear(true)
        XCTAssertNotNil(controller.navigationItem.leftBarButtonItem)
    }
    
    func testDismissIsCalled() {
        let controller = ReadMeController()
        controller.tappedBack()
        XCTAssertEqual(controller.calledDismiss, true)
    }
    
}
