//
//  FlickrErrorResponse.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Foundation

struct FlickrErrorResponse: Decodable {
    let stat: String
    let code: Int
    let message: String
}

extension FlickrErrorResponse: ErrorResponseProtocol {

    enum AlertElements: ErrorResponseAlertElements {
        typealias ErrorResponse = FlickrErrorResponse

        static func title(errorResponse: ErrorResponse) -> String {
            return "Flickr Error"
        }

        static func message(errorResponse: ErrorResponse) -> String {
            return "code: \(errorResponse.code)\n" + errorResponse.message
        }
    }
}
