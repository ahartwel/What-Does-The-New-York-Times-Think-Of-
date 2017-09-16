//
//  TopicFinderViewModel.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import PromiseKit

typealias TopicQuery = String
protocol TopicFinderActions: class {
    func searchQueryChanged(to string: String)
    func selectedTag(atIndex index: Int) -> TopicQuery?
}

protocol TopicFinderBindables {
    var currentQuery: Observable<String> { get }
    var currentResults: Observable<[TimesTag]> { get }
}

//The view controller will conform to this protocol, that way if errors happen in the view model the controller
//can present them/ the controller can present any views that branch off of this screen
protocol TopicFinderViewModelDelegate: class, ErrorPresenter {
    func selected(tag: TimesTag)
}

class TopicFinderViewModel: TopicFinderBindables, TimesTagRequester {
   
    //Bindable Properties
    var currentQuery: Observable<String> = Observable<String>("")
    var currentResults: Observable<[TimesTag]> = Observable<[TimesTag]>([])
    
    //View Model Properties
    var bag: DisposeBag = DisposeBag()
    
    unowned var delegate: TopicFinderViewModelDelegate
    
    init(delegate: TopicFinderViewModelDelegate) {
        self.delegate = delegate
        self.setUpCurrentQueryListeners()
    }
    
    func setUpCurrentQueryListeners() {
        self.currentQuery.observeNext(with: { query -> Void in
            self.makeApiQuery(with: query)
        }).dispose(in: self.bag)
    }
    
    func makeApiQuery(with query: String) {
        if query.isEmpty {
            self.currentResults.value = []
            return
        }
        self.timesTagApi.getTags(wihQuery: query).then { tags -> Void in
            self.currentResults.value = tags
        }.catch { error -> Void in
            self.delegate.show(error: error)
        }
    }
}

extension TopicFinderViewModel: TopicFinderActions {

    func searchQueryChanged(to string: String) {
        self.currentQuery.value = string
    }
    
    func selectedTag(atIndex index: Int) -> TopicQuery? {
        //lets just ignore this if this method is called with an invalid index
        if !self.currentResults.value.indices.contains(index) {
            return nil
        }
        let selectedTag = self.currentResults.value[index]
        self.delegate.selected(tag: selectedTag)
        self.currentResults.value = []
        return selectedTag.fullTag
    }
    
}
