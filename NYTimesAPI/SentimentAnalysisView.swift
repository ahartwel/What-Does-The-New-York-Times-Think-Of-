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
    
    lazy var currentSentiment: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIConstants.emojiFontBig
        return view
    }()
    lazy var allSentiments: UILabel = {
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didLoad()
    }
    
    func didLoad() {
        self.alpha = 0
        self.setUpKeyboardListeners()
        self.addSubview(self.loadingStateIndicator)
        self.addSubview(self.allSentiments)
        self.addSubview(self.currentSentiment)
    }
    
    func bind(to model: SentimentAnalyzerBindables, withActions actions: SentimentAnalyzerActions) {
        model.loadingText.observeNext(with: { status in
            self.loadingStateIndicator.text = status
        }).dispose(in: self.bag)
        model.sentimentEmojiString.observeNext(with: { string in
            self.allSentiments.text = string
        }).dispose(in: self.bag)
        model.overalSentimentString.observeNext(with: { sentimentEmoji in
            self.currentSentiment.text = sentimentEmoji
        }).dispose(in: self.bag)
        model.overalSentimentString.observeNext(with: { sentiment in
            //we don't want to animate if the sentiment emoj is the robot
            if sentiment == Sentiment.unknown.emoji {
                return
            }
            self.currentSentiment.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 2,
                           animations: {
                            self.currentSentiment.transform = CGAffineTransform.identity
            })
        }).dispose(in: self.bag)
    }
    
    override func updateConstraints() {
        self.allSentiments.snp.remakeConstraints({ make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.22)
        })
        self.currentSentiment.snp.remakeConstraints({ make in
            make.bottom.equalTo(self.allSentiments.snp.top).offset(-UIConstants.padding)
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
