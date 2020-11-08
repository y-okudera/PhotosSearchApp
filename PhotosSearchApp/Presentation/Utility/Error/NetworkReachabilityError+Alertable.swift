//
//  NetworkReachabilityError+Alertable.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

extension NetworkReachabilityError: AlertableError {

    var title: String {
        return "通信エラー"
    }

    var message: String {
        switch self {
        case .notReachable:
            return "通信に失敗しました。通信環境の良い場所で再度お試しください。"
        case .onlyViaWiFi:
            return "Wi-Fi接続時に再度お試しください。"
        case .unknown:
            return "通信に失敗しました。"
        }
    }
}
