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
    // swiftlint:disable:next line_length
    /// Shows a UIAlertController with information from the Error instance
    ///
    /// - Parameter error: the error to display (will try to convert it to a NYTimesError and display the title and description, otherwise will show default)
    func show(error: Error)
}
// swiftlint:disable:next line_length
// When a ViewController conforms to error presenter it can take an error and automatically display an alert informing the user about it
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
