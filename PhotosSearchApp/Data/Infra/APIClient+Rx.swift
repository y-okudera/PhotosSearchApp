//
//  APIClient+Rx.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Alamofire
import Foundation
import RxSwift

extension APIClient: ReactiveCompatible {}

extension Reactive where Base: APIClient {
    
    /// API Request
    func request<T: APIRequestable>(_ request: T,
                                    queue: DispatchQueue = .main,
                                    decoder: DataDecoder = Base.defaultDataDecoder()) -> Single<T.Response> {
        return Single.create { [weak base] singleObserver -> Disposable in
            base?.request(request, queue: queue, decoder: decoder) { result in
                switch result {
                case .success(let response):
                    singleObserver(.success(response))
                case .failure(let apiError):
                    singleObserver(.error(apiError))
                }
            }
            return Disposables.create {}
        }
    }
}
