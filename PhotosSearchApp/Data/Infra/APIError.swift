//
//  APIError.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Alamofire
import Foundation

enum APIError<T: APIRequestable>: Error {
    /// キャンセル
    case cancelled
    /// 接続エラー(オフライン)
    case connectionError
    /// タイムアウト
    case timedOut
    /// レスポンスのデコード失敗
    case decodeError
    /// エラーレスポンス
    case errorResponse(T.ErrorResponse)
    /// 無効なレスポンス
    case invalidResponse
    /// その他
    case others(error: Error)
}

extension APIError {
    init(afError: AFError, responseData: Data?, request: T) {
        if let data = responseData, afError.isResponseSerializationError {
            if let errorResponse = request.decode(errorResponseData: data) {
                self = .errorResponse(errorResponse)
            } else {
                self = .decodeError
            }
            return
        }

        if afError.isExplicitlyCancelledError {
            self = .cancelled
            return
        }

        if case .sessionTaskFailed(error: let error) = afError, let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                self = .connectionError
                return
            case .timedOut:
                self = .timedOut
                return
            default:
                break
            }
        }
        self = .others(error: afError)
    }
}

extension APIError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "APIError cancelled"
        case .connectionError:
            return "APIError connectionError"
        case .timedOut:
            return "APIError timedOut"
        case .decodeError:
            return "APIError decodeError"
        case .errorResponse:
            // The API error message is defined in the error response.
            return nil
        case .invalidResponse:
            return "APIError invalidResponse"
        case .others:
            return "APIError others"
        }
    }
}
