////
////  PromiseKitDataController.swift
////  SwiftBySundell
////
////  Created by Vladislav Gushin on 19/02/2019.
////  Copyright © 2019 Vladislav Gushin. All rights reserved.
////
//
//import UIKit
//import PromiseKit
//
//struct AuthData {
//    struct User {
//        let id: Int
//        let name: String
//    }
//
//    let user: User
//}
//
//class PromiseKitDataController {
//    func downloadAvatar(then handler: @escaping (UIImage?) -> Void) {
//        firstly {
//            login()
//        }.then { data in
//
//        }.done {
//
//        }
////        self.login { creds, error in
////            if let creds = creds {
////                self.fetch(avatar: creds.user) { image in
////                    handler(image)
////                }
////            }
////        }
//    }
//
//    func login() -> Promise<AuthData> {
//
//        func getAuthData() -> AuthData {
//            sleep(15)
//            return AuthData(user: .init(id: 1, name: "Vlad"))
//        }
//
//        return Promise<AuthData> { fulfill in
//            fulfill.fulfill(getAuthData())
//        }
//    }
//
//    func fetch(avatar: AuthData.User, then handler: @escaping (UIImage) -> Void) {
//        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/8f/Whole_world_-_land_and_oceans_12000.jpg")!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                handler(image)
//            }
//        }.resume()
//
//    }
//}
