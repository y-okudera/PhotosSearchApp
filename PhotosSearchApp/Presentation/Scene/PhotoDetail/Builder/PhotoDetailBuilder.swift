//
//  PhotoDetailBuilder.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import UIKit

enum PhotoDetailBuilderProvider {

    static func provide() -> PhotoDetailBuilder {
        return PhotoDetailBuilderImpl(
            wireframe: PhotoDetailWireframeProvider.provide()
        )
    }
}

protocol PhotoDetailBuilder: AnyObject {
    func build(photo: PhotosSearchModel.Photo) -> UIViewController
}

final class PhotoDetailBuilderImpl: PhotoDetailBuilder {

    var wireframe: PhotoDetailWireframe

    init(wireframe: PhotoDetailWireframe) {
        self.wireframe = wireframe
    }

    func build(photo: PhotosSearchModel.Photo) -> UIViewController {
        let viewModel = PhotoDetailViewModel(
            extra: .init(
                wireframe: self.wireframe,
                photo: photo
            )
        )

        let viewController: PhotoDetailViewController = .instantiate(viewModel: viewModel)
        self.wireframe.viewController = viewController

        return viewController
    }
}
