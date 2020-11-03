//
//  FlickrRequest.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Foundation

enum FlickrRequest {
    
    static let baseURL = URL(string: "https://www.flickr.com/services/rest/")!
    static let basePath = ""
    
    static func baseParameters(method: String) -> [String: Any] {
        let parameters = [
            "method": method,
            "api_key": "",
            "format": "json",
            "nojsoncallback" : "1"
        ]
        return parameters
    }
}
