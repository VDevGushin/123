//
//  HowToUse.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct PostForApiClient: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

func testApiClient() {
    let request = APIRequest(method: .get, path: "posts")

    APIClient().perform(request) { (result) in
        switch result {
        case .success(let response):
            if let response = try? response.decode(to: [PostForApiClient].self) {
                let posts = response.body
                print("Received posts: \(posts.first?.title ?? "")")
            } else {
                print("Failed to decode response")
            }
        case .failure:
            print("Error perform network request")
        }
    }
}
