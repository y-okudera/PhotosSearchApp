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

    /// OKボタンで閉じるのみのエラーダイアログを表示
    /// - Parameter appError: エラーオブジェクト
    func showErrorAlert(_ appError: AppError) {
        // スタックトレースを出力する
        self.displayStackSymbols()

        let underlyingError = appError.underlyingError
        print("Error", underlyingError)

        if let alertableError = underlyingError as? AlertableError {
            self.showAlert(title: alertableError.title, message: alertableError.message)
            return
        }

        // 特定のエラーではない場合は、エラーオブジェクトの内容を表示する
        self.showDefaultErrorAlert(error: underlyingError as NSError)
    }

    /// リトライ可能なエラーダイアログを表示
    /// - Parameters:
    ///   - appError: エラーオブジェクト
    ///   - retryAction: リトライボタンタップ時のアクション
    func showRetryableErrorAlert(_ appError: AppError, retryAction: @escaping(AlertActionHandler)) {
        // スタックトレースを出力する
        self.displayStackSymbols()

        let underlyingError = appError.underlyingError
        print("Error", underlyingError)

        if let alertableError = underlyingError as? AlertableError {
            self.showRetryAlert(title: alertableError.title, message: alertableError.message, retryAction: retryAction)
            return
        }

        // 特定のエラーではない場合は、エラーオブジェクトの内容を表示する。リトライはさせない。
        self.showDefaultErrorAlert(error: underlyingError as NSError)
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
