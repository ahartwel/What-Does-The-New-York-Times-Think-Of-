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
    
    override func loadView() {
        self.view = self.mainView
        self.mainView.bind(to: self.topicFinderViewModel, withActions: self.topicFinderViewModel)
    }
    
}

extension ViewController: TopicFinderViewModelDelegate {
    func selected(tag: TimesTag) {
        
    }
}
