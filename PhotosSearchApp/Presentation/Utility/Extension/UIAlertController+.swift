//
//  UIAlertController+.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

typealias AlertActionHandler = ((UIAlertAction) -> Void)

extension UIAlertController {

    class func make(title: String? = "",
                    message: String,
                    positiveButtonTitle: String = "OK",
                    negativeButtonTitle: String? = nil,
                    positiveAction: AlertActionHandler? = nil,
                    negativeAction: AlertActionHandler? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(
            .init(title: positiveButtonTitle, style: .default, handler: positiveAction)
        )

        // If the negativeButtonTitle is nil, it will display an alert with single buttons.
        // If it is not nil, it will display an alert with two buttons.
        if let negativeButtonTitle = negativeButtonTitle {
            alert.addAction(
                .init(title: negativeButtonTitle, style: .cancel, handler: negativeAction)
            )
        }
        return alert
    }
}
