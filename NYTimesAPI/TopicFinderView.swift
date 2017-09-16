//
//  TopicFinderView.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/14/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TopicFinderView: UIView {
    lazy var headerView: UILabel = {
       var label = UILabel()
        label.numberOfLines = 2
        label.font = UIConstants.headerFont
        label.text = "What does the NYTimes think of"
        return label
    }()
    
    lazy var searchView: UITextField = {
        var view = UITextField()
        view.font = UIConstants.subHeaderFont
        view.delegate = self
        view.placeholder = "Find a topic"
        view.addTarget(self, action: #selector(self.searchViewChanged), for: UIControlEvents.editingChanged)
        return view
    }()
    
    var resultsTableViewBottomConstraint: Constraint?
    lazy var resultsTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: TopicTableViewCell.reuseIdentifier ?? "")
        tableView.delegate = self
        tableView.alpha = 0
        tableView.contentInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    weak var actions: TopicFinderActions?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didLoad()
    }
    
    func didLoad() {
        self.setUpKeyboardListeners()
        self.addSubview(self.headerView)
        self.addSubview(self.searchView)
        self.addSubview(self.resultsTableView)
        self.addConstraints()
    }
    
    func bind(to viewModel: TopicFinderBindables, withActions actions: TopicFinderActions) {
        self.actions = actions
        viewModel.currentResults.bind(to: self.resultsTableView, createCell: { models, indexPath, tableView in
            //swiftlint:disable:next line_length
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.reuseIdentifier ?? "") else {
                fatalError("Couldn't create cell, something has gone terribly wrong")
            }
            cell.textLabel?.text = models[indexPath.row].fullTag
            return cell
        }).dispose(in: self.bag)
    }

    @objc func searchViewChanged(_ textField: UITextField) {
        self.actions?.searchQueryChanged(to: textField.text ?? "")
    }
    
    func addConstraints() {
        self.headerView.snp.remakeConstraints({ make in
            make.top.left.right.equalTo(self).inset(UIConstants.padding)
        })
        self.searchView.snp.remakeConstraints({ make in
            make.top.equalTo(self.headerView.snp.bottom).offset(UIConstants.padding)
            make.left.right.equalTo(self).inset(UIConstants.padding)
            make.height.equalTo(self.searchView.font!.lineHeight * 1.25)
        })
        self.resultsTableView.snp.remakeConstraints({ make in
            make.top.equalTo(self.searchView.snp.bottom).offset(UIConstants.padding)
            make.left.right.equalTo(self).inset(UIConstants.padding)
            self.resultsTableViewBottomConstraint = make.bottom.equalTo(self).inset(0).constraint
        })
    }
}

extension TopicFinderView: KeyboardListener {
    func onKeyboardClose() {
        self.resultsTableView.alpha = 0
    }
    
    func onKeyboardOpen(withFrame frame: CGRect) {
        self.resultsTableView.alpha = 1
        self.resultsTableViewBottomConstraint?.update(inset: frame.height)
        self.setNeedsUpdateConstraints()
    }
}

extension TopicFinderView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

extension TopicFinderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchView.resignFirstResponder()
        if let tagString = self.actions?.selectedTag(atIndex: indexPath.row) {
            self.searchView.text = tagString
        }
    }
}
