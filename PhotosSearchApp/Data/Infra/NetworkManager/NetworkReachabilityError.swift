//
//  NetworkReachabilityError.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

import Foundation

enum NetworkReachabilityError: Error {
    case notReachable
    case onlyViaWiFi
    case unknown
}
