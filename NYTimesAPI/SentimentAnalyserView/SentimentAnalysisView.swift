//
//  SentimentAnalysisView.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/15/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit

class SentimentAnalysisView: UIView {
    
    lazy var overallSentimentLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIConstants.emojiFontBig
        return view
    }()
    lazy var allSentimentsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIConstants.emojiFont
        view.numberOfLines = 2
        return view
    }()
    
    lazy var loadingStateIndicator: UILabel = {
        let view = UILabel()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.didLoad()
    }
    weak var actions: SentimentAnalyzerActions?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didLoad()
    }
    
    func didLoad() {
        self.alpha = 0
        self.setUpKeyboardListeners()
        self.addSubview(self.loadingStateIndicator)
        self.addSubview(self.allSentimentsLabel)
        self.addSubview(self.overallSentimentLabel)
    }
    
    func bind(to model: SentimentAnalyzerBindables, withActions actions: SentimentAnalyzerActions) {
        self.actions = actions
        model.loadingStatusText.observeNext(with: { status in
            self.loadingStateIndicator.text = status
        }).dispose(in: self.bag)
        model.allSentimentsString.observeNext(with: { string in
            self.allSentimentsLabel.text = string
        }).dispose(in: self.bag)
        model.overallSentimentString.observeNext(with: { sentimentEmoji in
            self.overallSentimentLabel.text = sentimentEmoji
        }).dispose(in: self.bag)
        model.overallSentimentString.observeNext(with: { sentiment in
            //we don't want to animate if the sentiment emoj is the robot
            if sentiment == Sentiment.unknown.emoji {
                return
            }
            self.animateOverallSentimentChange()
        }).dispose(in: self.bag)
    }
    
    fileprivate func animateOverallSentimentChange() {
        self.overallSentimentLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 2,
                       animations: {
                        self.overallSentimentLabel.transform = CGAffineTransform.identity
        })
    }
    
    override func updateConstraints() {
        self.allSentimentsLabel.snp.remakeConstraints({ make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.22)
        })
        self.overallSentimentLabel.snp.remakeConstraints({ make in
            make.bottom.equalTo(self.allSentimentsLabel.snp.top).offset(-UIConstants.padding)
            make.left.right.equalTo(self)
        })
        self.loadingStateIndicator.snp.remakeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(UIConstants.padding)
            make.left.right.equalTo(UIConstants.padding)
        }
        super.updateConstraints()
    }
    
}
extension SentimentAnalysisView: KeyboardListener {
    func onKeyboardOpen(withFrame frame: CGRect) {
        //if the keyboard is open, you are searching for a topic, hide this view, it isn't needed and looks bad
        self.alpha = 0
    }
    func onKeyboardClose() {
        self.alpha = 1
    }
}
