//
//  ReadMeController.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/16/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit
import Down
import ionicons

//wrap loading the readme so it loads right away and is available without loading when the help controller is presented
class ReadMeWrapper {
    static var readme: String = {
        // yeah force casting is bad, but this should never fail, it is in the bundle
        let path = Bundle.main.path(forResource: "readme", ofType: "md")!
        // swiftlint:disable:next force_try
        let content = try! NSString(contentsOfFile: path, encoding: 0) as String
        return content
    }()
    static var readmeView: UIView = {
        // swiftlint:disable:next force_try
        return try! DownView(frame: UIScreen.main.bounds, markdownString: ReadMeWrapper.readme)
    }()
}

class ReadMeController: UIViewController {
    #if TESTING
    var calledDismiss: Bool = false
    #endif
    override func loadView() {
        self.title = "About"
        self.view = ReadMeWrapper.readmeView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let downImage = IonIcons.image(withIcon: ion_chevron_down, size: 18, color: .black)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: downImage,
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(self.tappedBack))
    }
    @objc func tappedBack() {
        self.dismiss(animated: true)
    }
}

#if TESTING
    extension ReadMeController {
        override func dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
            super.dismiss(animated: true)
            self.calledDismiss = true
        }
    
    }
#endif
