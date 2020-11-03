//
//  PhotosSearchWireframe.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

enum PhotosSearchWireframeProvider {

    static func provide() -> PhotosSearchWireframe {
        return PhotosSearchWireframeImpl()
    }
}

protocol PhotosSearchWireframe {

    var viewController: UIViewController? { get set }
    /* 次の画面へ遷移する処理を実装 */
//    func pushXXX()
}

final class PhotosSearchWireframeImpl: PhotosSearchWireframe {

    weak var viewController: UIViewController?

//    func pushXXX() {
//        let nextVC = NextBuilder()
//        self.viewController?.navigationController?.pushViewController(nextVC, animated: true)
//    }
}

