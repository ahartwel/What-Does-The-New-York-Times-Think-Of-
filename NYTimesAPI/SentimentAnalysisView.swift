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
        view.font = UIConstants.emojiFont
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
        self.addSubview(self.loadingStateIndicator)
        self.addSubview(self.currentSentiment)
    }
    
    func bind(to model: SentimentAnalyserBindables, withActions actions: SentimentAnalyserActions) {
        model.loadingStatus.observeNext(with: { status in
            self.currentSentiment.alpha = {
                switch status {
                case .done, .error:
                    return 1
                default:
                    return 0.4
                }
            }()
            if status == .done {
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentSentiment.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.currentSentiment.transform = CGAffineTransform(scaleX: 0.98, y: 0.8)
                        }, completion: { _ in
                            self.currentSentiment.transform = CGAffineTransform.identity
                        })
                })
            }
        }).dispose(in: self.bag)
        model.loadingText.observeNext(with: { status in
            self.loadingStateIndicator.text = status
        }).dispose(in: self.bag)
        model.sentiment.observeNext(with: { sentiment in
            self.currentSentiment.text = sentiment.emoji
        }).dispose(in: self.bag)
    }
    
    override func updateConstraints() {
        self.currentSentiment.snp.remakeConstraints({ make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.2)
        })
        self.loadingStateIndicator.snp.remakeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(UIConstants.padding)
            make.left.right.equalTo(UIConstants.padding)
        }
        super.updateConstraints()
    }
    
}
