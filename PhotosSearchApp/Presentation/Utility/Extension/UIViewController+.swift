//
//  UIViewController+.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

extension UIViewController {

    class func instantiate<T: UIViewController>() -> T {
        let viewControllerName = String(describing: T.self)
        let storyboard = UIStoryboard(name: viewControllerName, bundle: Bundle(for: self))
        guard let viewController = storyboard.instantiateViewController(identifier: viewControllerName) as? T else {
            fatalError("\(viewControllerName) not Found.")
        }
        return viewController
    }

    class func instantiate<V: ViewProtocol>(viewModel: V.ViewModel) -> V {
        let viewController: V = .instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension UIViewController {

    /// OKボタンのみのダイアログを表示
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - okAction: OKボタンタップ時のアクション
    func showAlert(title: String = "", message: String, okAction: AlertActionHandler? = nil) {
        let alert = UIAlertController.make(
            title: title,
            message: message,
            positiveButtonTitle: "OK",
            negativeButtonTitle: nil,
            positiveAction: okAction,
            negativeAction: nil
        )
        self.present(alert, animated: true)
    }

    /// リトライ・キャンセルボタンのダイアログを表示
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - retryAction: リトライボタンタップ時のアクション
    ///   - cancelAction: キャンセルボタンタップ時のアクション
    func retryAlert(title: String = "", message: String, retryAction: AlertActionHandler?, cancelAction: AlertActionHandler? = nil) {
        let alert = UIAlertController.make(
            title: title,
            message: message,
            positiveButtonTitle: "リトライ",
            negativeButtonTitle: "キャンセル",
            positiveAction: retryAction,
            negativeAction: cancelAction
        )
        self.present(alert, animated: true)
    }

    /// OK・キャンセルボタンのダイアログを表示
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - okAction: OKボタンタップ時のアクション
    ///   - cancelAction: キャンセルボタンタップ時のアクション
    func showConfirm(title: String = "", message: String, okAction: AlertActionHandler?, cancelAction: AlertActionHandler? = nil) {
        let alert = UIAlertController.make(
            title: title,
            message: message,
            positiveButtonTitle: "OK",
            negativeButtonTitle: "キャンセル",
            positiveAction: okAction,
            negativeAction: cancelAction
        )
        self.present(alert, animated: true)
    }
}
