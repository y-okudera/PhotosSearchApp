//
//  PhotosSearchRequest.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Foundation

/// Flickr写真検索API
final class PhotosSearchRequest: APIRequestable {
    
    typealias Response = PhotosSearchResponse
    typealias ErrorResponse = FlickrErrorResponse
    let baseURL = FlickrRequest.baseURL
    let path: String = FlickrRequest.basePath
    
    private var searchWord: String
    private var page: Int
    private var perPage: Int
    
    lazy var parameters: [String: Any] = {
        var parameters = FlickrRequest.baseParameters(method: "flickr.photos.search")
        parameters["per_page"] = self.perPage
        parameters["page"] = self.page
        parameters["text"] = self.searchWord
        parameters["extras"] = "description"
        return parameters
    }()
    
    init(searchWord: String, page: Int, perPage: Int) {
        self.searchWord = searchWord
        self.page = page
        self.perPage = perPage
    }
}
