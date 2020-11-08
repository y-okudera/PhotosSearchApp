//
//  APIClient.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import Alamofire
import Foundation

final class APIClient {

    private init() {}
    static let shared = APIClient()

    static func defaultDataDecoder() -> DataDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoder: DataDecoder = jsonDecoder
        return decoder
    }

    /// API Request
    func request<T: APIRequestable>(_ request: T,
                                    queue: DispatchQueue = .main,
                                    decoder: DataDecoder = defaultDataDecoder(),
                                    completion: @escaping(Swift.Result<T.Response, APIError>) -> Void) {

        AF.request(request.makeURLRequest())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.Response.self, queue: queue, decoder: decoder) { dataResponse in
                log?.debug("【API Response Description】\n\(dataResponse.debugDescription)")

                switch dataResponse.result {
                case .success(let response):
                    completion(.success(response))

                case .failure(let afError):
                    let apiError = APIError(afError: afError, responseData: dataResponse.data, request: request)
                    completion(.failure(apiError))
                }
            }
    }
}
