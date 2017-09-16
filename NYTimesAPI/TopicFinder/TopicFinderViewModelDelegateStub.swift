//
//  TopicFinderViewModelDelegateStub.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

class TopicFinderViewModelDelegateStub: TopicFinderViewModelDelegate {
    var calledShowError: Bool = false
    var calledShowErrorWithError: Error?
    func show(error: Error) {
        self.calledShowError = true
        self.calledShowErrorWithError = error
    }
    
    var calledUserSelectedTag: Bool = false
    var calledUserSelectedTagWithTag: TimesTag?
    func selected(tag: TimesTag) {
        self.calledUserSelectedTag = true
        self.calledUserSelectedTagWithTag = tag
    }
}
