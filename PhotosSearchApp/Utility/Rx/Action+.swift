//
//  Action+.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

import Action
import RxSwift

extension Action {

    var underlyingError: Observable<Error> {
        return self.errors
            .flatMap { actionError -> Observable<Error> in
                switch actionError {
                case .underlyingError(let error):
                    return Observable.of(error)
                case .notEnabled:
                    return .empty()
                }
            }
    }
}

