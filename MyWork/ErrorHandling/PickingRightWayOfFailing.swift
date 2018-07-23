//
//  PickingRightWayOfFailing.swift
//  MyWork
//
//  Created by Vladislav Gushin on 23/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

//In this case, since we’re dealing with an asynchronous task, returning nil or an error enum case is probably the best choice, like this:
class DataLoader {
    enum Result {
        case success(Data)
        case failure(Error?)
    }

    func loadData(from url: URL,
                  completionHandler: @escaping (Result) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completionHandler(.failure(error))
                return
            }

            completionHandler(.success(data))
        }

        task.resume()
    }
}

//For synchronous APIs, throwing is a great option — as it “forces” our API users to handle the error in an appropriate way:
class StringFormatter {
    enum Error: Swift.Error {
        case emptyString
    }
    
    func format(_ string: String) throws -> String {
        guard !string.isEmpty else {
            throw Error.emptyString
        }
        
        return string.replacingOccurrences(of: "\n", with: " ")
    }
}
