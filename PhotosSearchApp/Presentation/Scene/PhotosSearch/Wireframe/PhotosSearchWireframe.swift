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

/// 写真一覧画面から他の画面へ遷移するためのWireframe
protocol PhotosSearchWireframe: TransitToPhotoDetailWireframe {}

final class PhotosSearchWireframeImpl: PhotosSearchWireframe {

    weak var viewController: UIViewController?
}

