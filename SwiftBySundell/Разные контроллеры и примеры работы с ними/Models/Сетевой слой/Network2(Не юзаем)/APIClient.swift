//
//  APIClient.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

class APIClient {
    typealias APIClientCompletion = (Swift.Result<APIResponse<Data?>, APIError>) -> Void

    private enum Status {
        case normal, request
    }

    var id: Int = 0
    private var status: Status

    private let session = URLSession.shared
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!

    init() {
        self.status = .normal
        self.id = ObjectIdentifier(self).hashValue
    }

    func perform(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {

        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems

        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL)); return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

        self.status = .request
        let task = session.dataTask(with: url) { [weak self](data, response, error) in
            self?.status = .request
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(nil))); return
            }
            completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
    }

    func cancelRequest() {
        if case .request = self.status {
            self.status = .normal
            self.session.invalidateAndCancel()
        }
    }
}
