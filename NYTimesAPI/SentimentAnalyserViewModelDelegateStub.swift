//
//  SentimentAnalyserViewModelDelegateStub.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

class SentimentAnalyserViewModelDelegateStub: SentimentAnalyserViewModelDelegate {
    
    var calledShowError: Bool = false
    var calledShowErrorWithError: Error?
    func show(error: Error) {
        self.calledShowError = true
        self.calledShowErrorWithError = error
    }
    
    var calledGoBackToLastScreen: Bool = false
    func goBackToLastScreen() {
        self.calledGoBackToLastScreen = true
    }
}
