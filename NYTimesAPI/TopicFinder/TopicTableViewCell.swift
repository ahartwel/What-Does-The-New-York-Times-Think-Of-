//
//  TopicTableViewCell.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/16/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit

class TopicTableViewCell: UITableViewCell {
    static var reuseIdentifier: String? {
        return "TopicTableViewCell"
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.didLoad()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didLoad()
    }
    func didLoad() {
        self.textLabel?.text = ""
        self.textLabel?.font = UIConstants.listFont
        self.layoutMargins = UIEdgeInsets.zero
        self.contentView.layoutMargins = UIEdgeInsets.zero
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.setNeedsUpdateConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setNeedsUpdateConstraints()
    }
    override func updateConstraints() {
        self.textLabel?.snp.remakeConstraints({ make in
            make.left.right.equalTo(self.contentView)
            make.top.bottom.equalTo(self.contentView).inset(UIConstants.padding)
        })
        super.updateConstraints()
    }
}
