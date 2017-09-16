//
//  TopicFinderJSONParsingTest.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/14/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
import SwiftyJSON

class TopicFinderJSONParsingTest: XCTestCase {

    func testStringToJSON() {
        // swiftlint:disable:next line_length
        let string = "[\"t\",[\"Mightier Than the Sword: Uncle Tom Cabin and the Battle for America (Book) (Ttl)\",\"New York State (Geo)\",\"Television (Des)\",\"Taxation (Des)\",\"Travel and Vacations (Des)\",\"Economic Conditions and Trends (Des)\",\"Theater (Des)\",\"Terrorism (Des)\",\"Tennis (Des)\",\"International Trade and World Market (Des)\"]]"
        // swiftlint:disable:next force_try
        let json = JSON.init(parseJSON: string)
        XCTAssertNotNil(json.array)
    }
    
    func testTimesTagsAreParsedProperly() {
        let exp = self.expectation(description: "times tags are parsed properly")
        ServiceSettings.stubRequests = true
        let timesTagApi = TimesTagApiImplementation()
        _ = timesTagApi.getTags(wihQuery: "").then { tags -> Void in
            print(tags)
            XCTAssertEqual(tags.count, 10)
            XCTAssertEqual(tags[0].fullTag, "Mightier Than the Sword: Uncle Tom Cabin and the Battle for America (Book) (Ttl)")
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 0.3, handler: nil)
    }
    
}
