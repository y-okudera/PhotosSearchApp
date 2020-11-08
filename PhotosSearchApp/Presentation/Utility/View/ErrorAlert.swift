//
//  ErrorAlert.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import UIKit

protocol AlertableError: Error {
    var title: String { get }
    var message: String { get }
}

protocol ErrorAlert {}

extension ErrorAlert where Self: UIViewController {
    func showErrorAlert(_ error: Error) {
        // スタックトレースを出力する
        self.displayStackSymbols()

        print("Error", error)

        if let alertableError = error as? AlertableError {
            self.showAlert(title: alertableError.title, message: alertableError.message)
            return
        }

        // 特定のエラーではない場合は、エラーオブジェクトの内容を表示する
        self.showDefaultErrorAlert(error: error as NSError)
    }

    private func showDefaultErrorAlert(error: NSError) {
        print("NSError", error)
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

    /// スタックトレースをコンソールに出力する
    private func displayStackSymbols() {
        print("【Stack symbols】---")
        Thread.callStackSymbols.forEach {
            print($0)
        }
        print("---【Stack symbols】")
    }
}
