//
//  MainView.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/14/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView {
    
    lazy var topicFinderView: TopicFinderView = TopicFinderView()
    lazy var sentimentAnalysisView: SentimentAnalysisView = SentimentAnalysisView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didLoad()
    }
    
    func didLoad() {
        self.styleView()
        self.addSubview(self.sentimentAnalysisView)
        self.addSubview(self.topicFinderView)
    }
    
    func styleView() {
        self.backgroundColor = UIColor.white
    }
    
    func bind(to viewModel: TopicFinderBindables, withActions actions: TopicFinderActions) {
        self.topicFinderView.bind(to: viewModel, withActions: actions)
    }
    
    func bind(to viewModel: SentimentAnalyserBindables, withActions actions: SentimentAnalyserActions) {
        self.sentimentAnalysisView.bind(to: viewModel, withActions: actions)
    }
    
    override func updateConstraints() {
        self.topicFinderView.snp.remakeConstraints({ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        })
        self.sentimentAnalysisView.snp.remakeConstraints({ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        })
        super.updateConstraints()
    }
    
}
