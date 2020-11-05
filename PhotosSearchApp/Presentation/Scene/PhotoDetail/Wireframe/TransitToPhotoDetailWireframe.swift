//
//  TransitToPhotoDetailWireframe.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import UIKit

/// 写真詳細画面へ遷移するためのWireframe
protocol TransitToPhotoDetailWireframe: AnyObject {
    var viewController: UIViewController? { get set }

    func presentPhotoDetail(photo: PhotosSearchModel.Photo, completion: (() -> Void)?)
}

extension TransitToPhotoDetailWireframe {

    func presentPhotoDetail(photo: PhotosSearchModel.Photo, completion: (() -> Void)? = nil) {
        let photoDetailVC = PhotoDetailBuilderProvider.provide().build(photo: photo)

        if let delegate = self.viewController as? UIAdaptivePresentationControllerDelegate {
            photoDetailVC.presentationController?.delegate = delegate
        }
        self.viewController?.present(photoDetailVC, animated: true, completion: completion)
    }
}
