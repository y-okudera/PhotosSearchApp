//
//  PhotosSearchResponse.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Foundation

struct PhotosSearchResponse: Decodable {
    let photos: Photos
    let stat: String
}

extension PhotosSearchResponse {

    struct Photos: Decodable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: String
        let photo: [Photo]
    }

    struct Photo: Decodable {
        let id: String
        let server: String
        let secret: String
        let title: String
        let description: Description?
    }

    struct Description: Decodable {
        let _content: String
    }
}
