//
//  APIError.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Alamofire
import Foundation

enum APIError: Error {
    /// キャンセル
    case cancelled
    /// 通信失敗
    case connectionError
    /// エラーレスポンス
    case errorResponse(APIErrorResponse)
    /// その他
    case others(error: Error)
}

extension APIError {
    init<T: APIRequestable>(afError: AFError, responseData: Data?, request: T) {
        if let data = responseData, afError.isResponseSerializationError {
            if let errorResponse = request.decode(errorResponseData: data) {
                self = .errorResponse(request.convert(errorResponse: errorResponse))
                return
            }
        }

        if afError.isExplicitlyCancelledError {
            self = .cancelled
            return
        }

        if case .sessionTaskFailed(error: let error) = afError, let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                self = .connectionError
                return
            default:
                break
            }
        }
        self = .others(error: afError)
    }
}
