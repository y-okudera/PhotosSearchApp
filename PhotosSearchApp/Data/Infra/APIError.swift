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
    /// 通信失敗
    case connectionError
    /// エラーレスポンス
    case errorResponse(T.ErrorResponse)
    /// その他
    case others(error: Error)
}

extension APIError {
    init(afError: AFError, responseData: Data?, request: T) {
        if let data = responseData, afError.isResponseSerializationError {
            if let errorResponse = request.decode(errorResponseData: data) {
                self = .errorResponse(errorResponse)
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

extension APIError: AlertableError {

    private typealias ErrorResponseAlertElements = T.ErrorResponse.AlertElements

    var title: String {
        switch self {
        case .cancelled:
            return "API Error"
        case .connectionError:
            return "通信エラー"
        case .errorResponse(let errorResponse):
            return self.title(from: errorResponse)
        case .others(error: let error):
            return (error as NSError).localizedRecoverySuggestion ?? "API Error"
        }
    }

    var message: String {
        switch self {
        case .cancelled:
            return "キャンセルされました。"
        case .connectionError:
            return "通信に失敗しました。通信環境の良い場所で再度お試しください。"
        case .errorResponse(let errorResponse):
            return self.message(from: errorResponse)
        case .others(error: let error):
            return error.localizedDescription
        }
    }

    private func title(from errorResponse: T.ErrorResponse) -> String {
        guard let alertableErrorResponse = self.convert(from: errorResponse) else {
            return "エラー"
        }
        return ErrorResponseAlertElements.title(errorResponse: alertableErrorResponse)
    }

    private func message(from errorResponse: T.ErrorResponse) -> String {
        guard let alertableErrorResponse = self.convert(from: errorResponse) else {
            return "エラーが発生しました。"
        }
        return ErrorResponseAlertElements.message(errorResponse: alertableErrorResponse)
    }

    private func convert(from errorResponse: T.ErrorResponse) -> ErrorResponseAlertElements.ErrorResponse? {
        if let alertableErrorResponse = errorResponse as? ErrorResponseAlertElements.ErrorResponse {
            return alertableErrorResponse
        } else {
            let expectedType = String(describing: T.ErrorResponse.AlertElements.ErrorResponse.self)
            assertionFailure("Illegal argument exception. (expect type is \(expectedType))")
            return nil
        }
    }
}
