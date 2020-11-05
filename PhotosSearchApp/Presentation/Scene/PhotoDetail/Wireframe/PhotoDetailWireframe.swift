//
//  PhotoDetailWireframe.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import UIKit

enum PhotoDetailWireframeProvider {

    static func provide() -> PhotoDetailWireframe {
        return PhotoDetailWireframeImpl()
    }
}

/// 写真詳細画面から他の画面へ遷移するためのWireframe
protocol PhotoDetailWireframe {

    var viewController: UIViewController? { get set }

    func dismiss(completion: (() -> Void)?)
}

final class PhotoDetailWireframeImpl: PhotoDetailWireframe {

    weak var viewController: UIViewController?

    func dismiss(completion: (() -> Void)?) {
        self.viewController?.dismiss(animated: true, completion: completion)
    }
}
