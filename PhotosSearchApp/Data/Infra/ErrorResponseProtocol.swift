//
//  ErrorResponseProtocol.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

protocol ErrorResponseProtocol: Decodable {
    associatedtype AlertElements: ErrorResponseAlertElements
}

protocol ErrorResponseAlertElements {
    associatedtype ErrorResponse: ErrorResponseProtocol
    static func title(errorResponse: ErrorResponse) -> String
    static func message(errorResponse: ErrorResponse) -> String
}
