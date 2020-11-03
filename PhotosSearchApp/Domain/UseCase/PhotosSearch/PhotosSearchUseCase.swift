//
//  PhotosSearchUseCase.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

enum PhotosSearchUseCaseProvider {

    static func provide() -> PhotosSearchUseCase {
        return PhotosSearchUseCaseImpl(
            repository: PhotosSearchRepositoryProvider.provide(),
            translator: PhotosSearchTranslatorProvider.provide()
        )
    }
}

protocol PhotosSearchUseCase: AnyObject {
    func get(searchWord: String, page: Int, perPage: Int) -> Single<PhotosSearchModel>
}

private final class PhotosSearchUseCaseImpl: PhotosSearchUseCase {

    let repository: PhotosSearchRepository
    let translator: PhotosSearchTranslator

    init(repository: PhotosSearchRepository, translator: PhotosSearchTranslator) {
        self.repository = repository
        self.translator = translator
    }

    func get(searchWord: String, page: Int, perPage: Int) -> Single<PhotosSearchModel> {
        self.repository.get(searchWord: searchWord, page: page, perPage: perPage)
            .flatMap { response in
                return Single<PhotosSearchModel>.create { singleObserver in
                    singleObserver(.success(PhotosSearchModel(response: response)))
                    return Disposables.create()
                }
            }
    }
}
