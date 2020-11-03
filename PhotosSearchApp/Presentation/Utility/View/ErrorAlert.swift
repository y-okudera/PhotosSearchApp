//
//  ErrorAlert.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import UIKit

protocol ErrorAlert {}

extension ErrorAlert where Self: UIViewController {
    func showErrorAlert(_ error: Error) {
        if let apiError = error as? APIError<PhotosSearchRequest> {
            if case .errorResponse(let errorResponse) = apiError {
                self.showAlert(title: "Flickr Error", message: "code: \(errorResponse.code)\n" + errorResponse.message)
                return
            }
        }
        self.showDefaultErrorAlert(error: error as NSError)
    }

    private func showDefaultErrorAlert(error: NSError) {
        var title = "Error"
        var message = error.localizedDescription
        var buttonTitle = "OK"

        if let recoverySuggestion = error.localizedRecoverySuggestion {
            title = recoverySuggestion
        }

        if let failureReason = error.localizedFailureReason {
            message = failureReason
        }

        if let recoveryOptions = error.localizedRecoveryOptions, !recoveryOptions.isEmpty {
            buttonTitle = recoveryOptions[0]
        }

        let alert = UIAlertController.make(title: title, message: message, positiveButtonTitle: buttonTitle)
        self.present(alert, animated: true)
    }
}
