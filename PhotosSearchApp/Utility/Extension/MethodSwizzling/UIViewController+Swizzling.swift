//
//  UIViewController+Swizzling.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/05.
//

import UIKit

extension UIViewController {

    static func methodSwizzling() {
        // dismiss(animated:completion:)メソッドを入れ替え
        if let from = class_getInstanceMethod(self, #selector(dismiss(animated:completion:))) {
            if let to = class_getInstanceMethod(self, #selector(swizzlingDismiss(animated:completion:))) {
                method_exchangeImplementations(from, to)
            }
        }
    }

    /// dismiss(animated:completion:)に入れ替えるメソッド
    /// - Parameters:
    ///   - flag: Pass true to animate the transition.
    ///   - completion: The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    ///
    /// - Note: dismissの前後にpresentationControllerWillDismiss, presentationControllerDidDismissを呼び出す
    @objc private func swizzlingDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let presentationController = self.presentationController else {
            self.swizzlingDismiss(animated: flag, completion: completion)
            return
        }

        presentationController.delegate?.presentationControllerWillDismiss?(presentationController)
        self.swizzlingDismiss(animated: flag, completion: completion)
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
