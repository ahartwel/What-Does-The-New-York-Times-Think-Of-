//
//  MainView.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/14/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit
import ionicons

protocol MainViewDelegate: class {
    func tappedHelp()
}

class MainView: UIView {
    weak var delegate: MainViewDelegate?
    lazy var helpButton: UILabel = {
        var button = IonIcons.label(withIcon: ion_information_circled,
                                    size: UIConstants.subHeaderFont.pointSize,
                                    color: .black)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainView.didTapHelp))
        button?.addGestureRecognizer(tap)
        button?.isUserInteractionEnabled = true
        return button!
    }()
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
        self.addSubview(self.helpButton)
    }
    
    func styleView() {
        self.backgroundColor = UIColor.white
    }
    
    func bind(to viewModel: TopicFinderBindables, withActions actions: TopicFinderActions) {
        self.topicFinderView.bind(to: viewModel, withActions: actions)
    }
    
    func bind(to viewModel: SentimentAnalyzerBindables, withActions actions: SentimentAnalyzerActions) {
        self.sentimentAnalysisView.bind(to: viewModel, withActions: actions)
    }
    
    @objc private func didTapHelp() {
        self.delegate?.tappedHelp()
    }
    
    override func updateConstraints() {
        self.topicFinderView.snp.remakeConstraints({ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        })
        self.sentimentAnalysisView.snp.remakeConstraints({ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        })
        self.helpButton.snp.remakeConstraints({ make in
            make.right.bottom.equalTo(self.safeAreaLayoutGuide).inset(UIConstants.padding)
        })
        super.updateConstraints()
    }
    
}
