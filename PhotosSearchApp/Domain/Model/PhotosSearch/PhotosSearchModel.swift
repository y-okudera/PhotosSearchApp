//
//  PhotosSearchModel.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Foundation

// MARK: - PhotosSearchModel
struct PhotosSearchModel {

    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photos: [PhotosSearchModel.Photo]

    init(response: PhotosSearchResponse) {
        self.page = response.photos.page
        self.pages = response.photos.pages
        self.perpage = response.photos.perpage
        self.total = Int(response.photos.total) ?? 0
        self.photos = response.photos.photo.map { PhotosSearchModel.Photo(photo: $0) }
    }
}

// MARK: - Photo
extension PhotosSearchModel {

    struct Photo {

        let title: String
        let description: String
        let imageUrlString: String

        init(photo: PhotosSearchResponse.Photo) {
            self.title = photo.title
            self.description = photo.description?._content ?? ""

            /*
             Photo Image URLs
             https://www.flickr.com/services/api/misc.urls.html
             */
            self.imageUrlString = "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_n.jpg"
        }
    }
}
