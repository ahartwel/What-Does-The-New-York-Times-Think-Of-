//
//  ViewController.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var mainView: MainView = MainView()
    lazy var topicFinderViewModel: TopicFinderViewModel = TopicFinderViewModel(delegate: self)
    lazy var sentimentAnalysisViewModel: SentimentAnalyserViewModel = SentimentAnalyserViewModel(withDelegate: self)
    override func loadView() {
        self.view = self.mainView
        self.mainView.bind(to: self.topicFinderViewModel, withActions: self.topicFinderViewModel)
        self.mainView.bind(to: self.sentimentAnalysisViewModel, withActions: self.sentimentAnalysisViewModel)
    }
    
}

extension ViewController: TopicFinderViewModelDelegate {
    func selected(tag: TimesTag) {
        self.sentimentAnalysisViewModel.set(tag: tag)
    }
}

extension ViewController: SentimentAnalyserViewModelDelegate {
    
}
