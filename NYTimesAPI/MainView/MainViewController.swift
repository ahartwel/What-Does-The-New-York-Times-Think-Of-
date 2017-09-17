//
//  ViewController.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    lazy var mainView: MainView = {
        var view = MainView()
        view.delegate = self
        return view
    }()
    lazy var topicFinderViewModel: TopicFinderViewModel = TopicFinderViewModel(delegate: self)
    lazy var sentimentAnalysisViewModel: SentimentAnalyzerViewModel = SentimentAnalyzerViewModel(withDelegate: self)
    override func loadView() {
        self.view = self.mainView
        self.mainView.bind(to: self.topicFinderViewModel, withActions: self.topicFinderViewModel)
        self.mainView.bind(to: self.sentimentAnalysisViewModel, withActions: self.sentimentAnalysisViewModel)
    }
    
}

extension MainViewController: TopicFinderViewModelDelegate {
    func selected(tag: TimesTag) {
        self.sentimentAnalysisViewModel.set(tag: tag)
    }
}

extension MainViewController: SentimentAnalyzerViewModelDelegate {
    //this is empty because the only method implemented on it has a default implementation for UIViewControllers
}

extension MainViewController: MainViewDelegate {
    func tappedHelp() {
        let readmeController = ReadMeController()
        let navigationController = UINavigationController(rootViewController: readmeController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
