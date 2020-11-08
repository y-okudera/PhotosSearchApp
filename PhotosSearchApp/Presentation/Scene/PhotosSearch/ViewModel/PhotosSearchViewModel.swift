//
//  PhotosSearchViewModel.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Foundation
import RxCocoa
import RxSwift
import Unio

protocol PhotosSearchViewModelType: ViewModelProtocol {
    var input: InputWrapper<PhotosSearchViewModel.Input> { get }
    var output: OutputWrapper<PhotosSearchViewModel.Output> { get }
}

final class PhotosSearchViewModel: UnioStream<PhotosSearchViewModel>, PhotosSearchViewModelType {

    convenience init(extra: Extra) {
        self.init(
            input: Input(),
            state: State(),
            extra: extra
        )
    }

    struct Input: InputType {
        let searchButtonTapped = PublishRelay<String>()
        let reachedBottom = PublishRelay<Void>()
        let selectedPhoto = PublishRelay<PhotosSearchModel.Photo>()
    }

    struct Output: OutputType {
        let needsScrollingToTop: BehaviorRelay<Bool>
        let photos: BehaviorRelay<[PhotosSearchModel.Photo]>
        let currentPage: BehaviorRelay<Int>
        let initialRequestError: Observable<Error>
        let additionalRequestError: Observable<Error>
    }

    struct State: StateType {
        let needsScrollingToTop = BehaviorRelay<Bool>(value: false)
        /// 検索ワード
        let searchWord = BehaviorRelay<String>(value: "")
        /// 現在のページ数
        let page = BehaviorRelay<Int>(value: 0)
        /// 総ページ数
        let pages = BehaviorRelay<Int>(value: 0)
        /// 取得した写真
        let photos = BehaviorRelay<[PhotosSearchModel.Photo]>(value: [])
        let initialRequestError = BehaviorRelay<Error?>(value: nil)
        let additionalRequestError = BehaviorRelay<Error?>(value: nil)
    }

    struct Extra: ExtraType {
        let wireframe: PhotosSearchWireframe
        let useCase: PhotosSearchUseCase
    }

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra

        input.searchButtonTapped
            .bind(onNext: { searchWord in

                state.needsScrollingToTop.accept(true)
                state.pages.accept(0)
                state.page.accept(0)
                state.photos.accept([])
                state.searchWord.accept(searchWord)

                // PhotosSearch API request.
                extra.useCase.get(searchWord: searchWord, page: state.page.value + 1, perPage: 50)
                    .subscribe(onSuccess: { model in
                        state.pages.accept(model.pages)
                        state.page.accept(model.page)
                        state.photos.accept(model.photos)
                        print("写真検索結果(初回読み込み) pages", model.pages, "page", model.page, "photos", state.photos.value.count)
                    }, onError: { error in
                        state.initialRequestError.accept(error)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)

        input.reachedBottom
            .filter { !state.photos.value.isEmpty }
            .filter { state.page.value < state.pages.value }
            .map { state.searchWord.value }
            .bind(onNext: { searchWord in

                // PhotosSearch API additional request.
                extra.useCase.get(searchWord: searchWord, page: state.page.value + 1, perPage: 50)
                    .subscribe(onSuccess: { model in
                        state.pages.accept(model.pages)
                        state.page.accept(model.page)
                        state.photos.accept(state.photos.value + model.photos)
                        print("写真検索結果(追加読み込み) pages", model.pages, "page", model.page, "photos", state.photos.value.count)
                    }, onError: { error in
                        state.additionalRequestError.accept(error)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)

        input.selectedPhoto
            .bind(onNext: { selectedPhoto in
                extra.wireframe.presentPhotoDetail(photo: selectedPhoto) {
                    print("PresentPhotoDetail completion")
                }
            })
            .disposed(by: disposeBag)

        return Output(
            needsScrollingToTop: state.needsScrollingToTop,
            photos: state.photos,
            currentPage: state.page,
            initialRequestError: state.initialRequestError.filterNil(),
            additionalRequestError: state.additionalRequestError.filterNil()
        )
    }
}
