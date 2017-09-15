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
        self.addSubview(self.topicFinderView)
    }
    
    func styleView() {
        self.backgroundColor = UIColor.white
    }
    
    func bind(to viewModel: TopicFinderBindables, withActions actions: TopicFinderActions) {
        self.topicFinderView.bind(to: viewModel, withActions: actions)
    }
    
    override func updateConstraints() {
        self.topicFinderView.snp.remakeConstraints({ make in
            make.top.equalTo(self).offset(UIConstants.padding * 5)
            make.left.right.equalTo(self)
        })
        super.updateConstraints()
    }
    
}
