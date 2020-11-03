//
//  PhotosSearchTranslator.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Foundation

enum PhotosSearchTranslatorProvider {

    static func provide() -> PhotosSearchTranslator {
        return PhotosSearchTranslatorImpl()
    }
}

protocol PhotosSearchTranslator {
    func convert(from response: PhotosSearchResponse) -> PhotosSearchModel
}

private struct PhotosSearchTranslatorImpl: PhotosSearchTranslator {

    func convert(from response: PhotosSearchResponse) -> PhotosSearchModel {
        return PhotosSearchModel(response: response)
    }
}
