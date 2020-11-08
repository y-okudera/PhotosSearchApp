//
//  NetworkManager.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

import Alamofire
import Foundation
import RxSwift

final class NetworkManager {

}

extension NetworkManager: ReactiveCompatible {}

extension Reactive where Base: NetworkManager {

    static func reachability(onlyViaWiFi: Bool = false) -> Single<Void> {
        return Single.create { singleObserver -> Disposable in
            Alamofire.NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { networkReachabilityStatus in
                switch networkReachabilityStatus {
                case .notReachable:
                    singleObserver(.error(NetworkReachabilityError.notReachable))
                case .reachable(let connectionType):

                    if case .cellular = connectionType, onlyViaWiFi {
                        singleObserver(.error(NetworkReachabilityError.onlyViaWiFi))
                    } else {
                        singleObserver(.success(()))
                    }

                case .unknown:
                    singleObserver(.error(NetworkReachabilityError.unknown))
                }
            })

            return Disposables.create {
                Alamofire.NetworkReachabilityManager.default?.stopListening()
            }
        }
    }
}
