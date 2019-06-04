//
//  RealAlamofireDataController+Enconding.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire

extension RealAlamofireDataController {
    // MARK: - Parameter Encoding
    /*Alamofire поддерживает три типа кодирования параметров, включая: URL, JSON и PropertyList. Он также может поддерживать любую пользовательскую кодировку, соответствующую протоколу ParameterEncoding.*/

    //URL Encoding
    /*The URLEncoding type creates a url-encoded query string to be set as or appended to any existing URL query string or set as the HTTP body of the URL request.
     Whether the query string is set or appended to any existing URL query string or set as the HTTP body depends on the Destination of the encoding. The Destination enumeration has three cases:
     
     .methodDependent - Applies encoded query string result to existing query string for GET, HEAD and DELETE requests and sets as the HTTP body for requests with any other HTTP method.
     .queryString - Sets or appends encoded query string result to existing query string.
     .httpBody - Sets encoded query string result as the HTTP body of the URL request.
     The Content-Type HTTP header field of an encoded request with HTTP body is set to application/x-www-form-urlencoded; charset=utf-8. Since there is no published specification for how to encode collection types, the convention of appending [] to the key for array values (foo[]=1&foo[]=2), and appending the key surrounded by square brackets for nested dictionary values (foo[bar]=baz).*/

    func requestWithURLEncodedParameters(with parameters: Parameters) {
        // MARK: - GET Request With URL-Encoded Parameters
        // encoding defaults to `URLEncoding.default`
        AF.request("https://httpbin.org/get", parameters: parameters).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }

        AF.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }

        AF.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding(destination: .methodDependent)).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }

        // MARK: - POST Request With URL-Encoded Parameters
        let parametersForPost: Parameters = [
            "foo": "bar",
            "baz": ["a", 1],
            "qux": [
                "x": 1,
                "y": 2,
                "z": 3
            ]
        ]

        // All three of these calls are equivalent
        AF.request("https://httpbin.org/post", method: .post, parameters: parametersForPost).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }
        AF.request("https://httpbin.org/post", method: .post, parameters: parametersForPost, encoding: URLEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }
        // HTTP body: foo=bar&baz[]=a&baz[]=1&qux[x]=1&qux[y]=2&qux[z]=3
        AF.request("https://httpbin.org/post", method: .post, parameters: parametersForPost, encoding: URLEncoding.httpBody).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }

        // MARK: - Configuring the Encoding of Bool Parameter
        /*The URLEncoding.BoolEncoding enumeration provides the following methods for encoding Bool parameters:
         .numeric - Encode true as 1 and false as 0.
         .literal - Encode true and false as string literals.
         By default, Alamofire uses the .numeric encoding.
         You can create your own URLEncoding and specify the desired Bool encoding in the initializer:*/
        let _ = URLEncoding(boolEncoding: .literal)

        // MARK: - Configuring the Encoding of Array Parameters
        /*The URLEncoding.ArrayEncoding enumeration provides the following methods for encoding Array parameters:
         .brackets - An empty set of square brackets is appended to the key for every value.
         .noBrackets - No brackets are appended. The key is encoded as is.
         By default, Alamofire uses the .brackets encoding, where foo=[1,2] is encoded as foo[]=1&foo[]=2.
         Using the .noBrackets encoding will encode foo=[1,2] as foo=1&foo=2.
         You can create your own URLEncoding and specify the desired Array encoding in the initializer:*/
        let _ = URLEncoding(arrayEncoding: .noBrackets)

        // MARK: -  JSON Encoding
        /*The JSONEncoding type creates a JSON representation of the parameters object, which is set as the HTTP body of the request. The Content-Type HTTP header field of an encoded request is set to application/json.*/
        let parametersJSONEncoding: Parameters = [
            "foo": [1, 2, 3],
            "bar": [
                "baz": "qux"
            ]
        ]

        // Both calls are equivalent
        AF.request("https://httpbin.org/post", method: .post, parameters: parametersJSONEncoding, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }
        AF.request("https://httpbin.org/post", method: .post, parameters: parametersJSONEncoding, encoding: JSONEncoding(options: [])).responseData { response in
            switch response.result {
            case .failure(let error): break
            case .success(let result):
                print("JSON: \(result)") // serialized json response
            }
        }//// HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}

        // MARK: - Property List Encoding
        /*The PropertyListEncoding uses PropertyListSerialization to create a plist representation of the parameters object, according to the associated format and write options values, which is set as the body of the request. The Content-Type HTTP header field of an encoded request is set to application/x-plist.*/

        // MARK: - Manual Parameter Encoding of a URLRequest
        //The ParameterEncoding APIs can be used outside of making network requests.
        func manualURLRequest()throws -> URLRequest {
            let url = URL(string: "https://httpbin.org/get")!
            let urlRequest = URLRequest(url: url)

            let parameters: Parameters = ["foo": "bar"]
            let encodedURLRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            return encodedURLRequest
        }
    }
}

// MARK - Custom Encoding
fileprivate struct JSONStringArrayEncoding: ParameterEncoding {
    private let array: [String]

    init(array: [String]) {
        self.array = array
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        let data = try JSONSerialization.data(withJSONObject: array, options: [])

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest.httpBody = data

        return urlRequest
    }
}
