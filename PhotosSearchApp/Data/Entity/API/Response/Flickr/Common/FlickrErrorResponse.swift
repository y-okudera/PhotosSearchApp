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
