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
        self.recordMode = true
        self.usesDrawViewHierarchyInRect = true
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInitialState() {
        let view = TopicFinderView()
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
        FBSnapshotVerifyView(view)
    }

}
