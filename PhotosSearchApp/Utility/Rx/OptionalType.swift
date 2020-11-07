//
//  OptionalType.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { return self }
}

extension ObservableType where Element: OptionalType {

    /// Unwraps and filters out `nil` elements.
    /// - Returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}
