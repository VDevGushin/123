//
//  Usage.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire

fileprivate class Usage {
    func makeSimpleRequest() {
        AF.request("https://httpbin.org/get").validate().responseJSON { response in
            print("Request: \(String(describing: response.request))") // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")

            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                print("JSON: \(data)")
            }
        }
    }
}

