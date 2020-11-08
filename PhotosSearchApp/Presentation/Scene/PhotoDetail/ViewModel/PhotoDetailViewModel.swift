//
//  PhotoDetailViewModel.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import Foundation
import RxCocoa
import RxSwift
import Unio

protocol PhotoDetailViewModelType: ViewModelProtocol {
    var input: InputWrapper<PhotoDetailViewModel.Input> { get }
    var output: OutputWrapper<PhotoDetailViewModel.Output> { get }
}

final class PhotoDetailViewModel: UnioStream<PhotoDetailViewModel>, PhotoDetailViewModelType {

    convenience init(extra: Extra) {
        self.init(
            input: Input(),
            state: State(),
            extra: extra
        )
    }

    struct Input: InputType {
        let viewWillAppear = PublishRelay<Void>()
        let tappedClose = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let photo: PublishRelay<PhotosSearchModel.Photo>
    }

    struct State: StateType {
        let photo = PublishRelay<PhotosSearchModel.Photo>()
    }

    struct Extra: ExtraType {
        let wireframe: PhotoDetailWireframe
        let photo: PhotosSearchModel.Photo
    }

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra

        input.viewWillAppear
            .bind(onNext: {
                state.photo.accept(extra.photo)
            })
            .disposed(by: disposeBag)

        input.tappedClose
            .bind(onNext: {
                log?.debug("閉じるボタンタップ")
                extra.wireframe.dismiss {
                    // スワイプで閉じられた場合は、このcompletionは呼ばれない
                    log?.debug("Dismiss completion")
                }
            })
            .disposed(by: disposeBag)

        return Output(
            photo: state.photo
        )
    }
}
