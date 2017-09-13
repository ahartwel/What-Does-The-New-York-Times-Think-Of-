//
//  ErrorDelegate.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit

struct NYTimesError: Error {
    var title: String = "There was an error"
    var description: String = "Sorry about that, please try again"
}

protocol ErrorPresenter {
    func show(error: Error)
}

extension ErrorPresenter where Self: UIViewController {
    func show(error: Error) {
        let error = (error as? NYTimesError) ?? NYTimesError()
        let alertController = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: .default, handler: { _ -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
