//
//  PhotosSearchBuilder.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

enum PhotosSearchBuilderProvider {

    static func provide() -> PhotosSearchBuilder {
        return PhotosSearchBuilderImpl(
            wireframe: PhotosSearchWireframeProvider.provide(),
            useCase: PhotosSearchUseCaseProvider.provide()
        )
    }
}

protocol PhotosSearchBuilder: AnyObject {
    func build() -> UIViewController
}

final class PhotosSearchBuilderImpl: PhotosSearchBuilder {
    
    var wireframe: PhotosSearchWireframe
    var useCase: PhotosSearchUseCase
    
    init(wireframe: PhotosSearchWireframe, useCase: PhotosSearchUseCase) {
        self.wireframe = wireframe
        self.useCase = useCase
    }
    
    func build() -> UIViewController {
        let viewModel = PhotosSearchViewModel(
            extra: .init(
                wireframe: self.wireframe,
                useCase: self.useCase
            )
        )
        
        let viewController: PhotosSearchViewController = .instantiate(viewModel: viewModel)
        self.wireframe.viewController = viewController
        
        return viewController
    }
}
