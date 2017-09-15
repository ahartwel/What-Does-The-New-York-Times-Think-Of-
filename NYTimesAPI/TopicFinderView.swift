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
        label.text = "What does the NYTimes think of..."
        return label
    }()
    lazy var searchView: UITextField = {
        var view = UITextField()
        view.font = UIConstants.subHeaderFont
        view.placeholder = "Type a topic..."
        view.addTarget(self, action: #selector(self.searchViewChanged), for: UIControlEvents.editingChanged)
        return view
    }()
    var tableViewFullHeight: Constraint?
    var tableViewNoHeight: Constraint?
    lazy var resultsTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
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
        self.listenToKeyboard()
        self.addSubview(self.headerView)
        self.addSubview(self.searchView)
        self.addSubview(self.resultsTableView)
        self.addConstraints()
    }
    
    func listenToKeyboard() {
        NotificationCenter.default.reactive.notification(name: .UIKeyboardWillShow).observeNext(with: { notification in
            self.tableViewNoHeight?.deactivate()
            guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            self.tableViewFullHeight?.activate()
            self.tableViewFullHeight?.update(offset: keyboardFrame.height)
            self.setNeedsUpdateConstraints()
        }).dispose(in: self.bag)
        
        NotificationCenter.default.reactive.notification(name: .UIKeyboardWillHide).observeNext(with: { _ in
            self.tableViewNoHeight?.activate()
            self.tableViewFullHeight?.deactivate()
            self.setNeedsUpdateConstraints()
        }).dispose(in: self.bag)
    }
    
    func bind(to viewModel: TopicFinderBindables, withActions actions: TopicFinderActions) {
        self.actions = actions
        viewModel.currentResults.bind(to: self.resultsTableView, createCell: { models, indexPath, tableView in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
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
            self.tableViewFullHeight = make.height.equalTo(UIConstants.resultsTableHeight).constraint
            self.tableViewNoHeight = make.height.equalTo(0).constraint
            self.tableViewNoHeight?.deactivate()
            make.bottom.equalTo(self)
        })
    }
}

extension TopicFinderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchView.resignFirstResponder()
        self.actions?.selectedTag(atIndex: indexPath.row)
    }
}
