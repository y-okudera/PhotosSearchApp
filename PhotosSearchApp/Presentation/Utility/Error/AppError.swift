//
//  AppError.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

import Foundation

enum AppError: Error {
    case apiError(APIError)
    case networkReachabilityError(NetworkReachabilityError)
    case unknown(Error)

    init(error: Error) {
        if let apiError = error as? APIError {
            self = .apiError(apiError)
        } else if let networkReachabilityError = error as? NetworkReachabilityError {
            self = .networkReachabilityError(networkReachabilityError)
        } else {
            self = .unknown(error)
        }
    }
}

extension AppError {

    /// リトライ可能かどうか
    var isRetryable: Bool {
        switch self {
        case .apiError(let apiError):
            // サーバからエラーレスポンスを受け取っている場合はリトライ不可にする
            if case .errorResponse = apiError {
                return false
            }
            return true
        case .networkReachabilityError:
            return true
        case .unknown:
            return false
        }
    }

    /// 根本的なエラー
    var underlyingError: Error {
        switch self {
        case .apiError(let apiError):
            return apiError
        case .networkReachabilityError(let networkReachabilityError):
            return networkReachabilityError
        case .unknown(let error):
            return error
        }
    }
}
