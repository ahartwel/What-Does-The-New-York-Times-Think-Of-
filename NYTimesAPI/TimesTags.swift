//
//  TimesTags.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

struct TimesTag {
    var fullTag: String
    // tags are returned with (Per)/(Des)/etc at the end to show what it is
    // lets expose a computed property that strips that away
    var prettyTag: String? {
        return fullTag.components(separatedBy: " (").first
    }
}
