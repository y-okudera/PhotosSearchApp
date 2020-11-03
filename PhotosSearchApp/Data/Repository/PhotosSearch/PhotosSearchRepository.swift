//
//  PhotosSearchRepository.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Foundation
import RxSwift

enum PhotosSearchRepositoryProvider {

    static func provide() -> PhotosSearchRepository {
        return PhotosSearchRepositoryImpl(apiDataStore: PhotosSearchAPIDataStoreProvider.provide())
    }
}

protocol PhotosSearchRepository {
    func get(searchWord: String, page: Int, perPage: Int) -> Single<PhotosSearchResponse>
}

private final class PhotosSearchRepositoryImpl: PhotosSearchRepository {

    private let apiDataStore: PhotosSearchAPIDataStore

    init(apiDataStore: PhotosSearchAPIDataStore) {
        self.apiDataStore = apiDataStore
    }

    func get(searchWord: String, page: Int, perPage: Int) -> Single<PhotosSearchResponse> {
        return self.apiDataStore.get(searchWord: searchWord, page: page, perPage: perPage)
    }
}
