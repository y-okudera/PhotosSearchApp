//
//  APIError+Alertable.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

import Foundation

extension APIError: AlertableError {

    var title: String {
        switch self {
        case .cancelled:
            return "API Error"
        case .connectionError:
            return "通信エラー"
        case .errorResponse(let errorResponse):
            return errorResponse.title
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
            return errorResponse.message
        case .others(error: let error):
            return error.localizedDescription
        }
    }
}
