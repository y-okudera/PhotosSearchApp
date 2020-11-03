//
//  PhotosSearchAPIDataStore.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Foundation
import RxSwift

enum PhotosSearchAPIDataStoreProvider {

    static func provide() -> PhotosSearchAPIDataStore {
        return PhotosSearchAPIDataStoreImpl()
    }
}

protocol PhotosSearchAPIDataStore {
    func get(searchWord: String, page: Int, perPage: Int) -> Single<PhotosSearchResponse>
}

private final class PhotosSearchAPIDataStoreImpl: PhotosSearchAPIDataStore {

    var apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func get(searchWord: String, page: Int, perPage: Int) -> Single<PhotosSearchResponse> {
        return self.apiClient.rx.request(PhotosSearchRequest(searchWord: searchWord, page: page, perPage: perPage))
    }
}
