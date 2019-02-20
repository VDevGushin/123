//
//  PromiseKitDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import PromiseKit

class PromiseKitDataController {

    enum UploadError: Error {
        case failedToUpload, noImage
    }

    enum RegisterError: Error {
        case failedToRegister
    }

    enum LoginError: Error {
        case failedToLogin
    }

    // MARK: - Simple api - обычное апи без использование PromiseKit и демонстрация неудобной работы
    func uploadSimple(image: UIImage?, completion: @escaping (Result<String>) -> Void) {
        guard image != nil else {
            return completion(.rejected(UploadError.noImage))
        }
        completion(.fulfilled("uploadtoken"))
    }

    func registerSimple(credentials: String, completion: @escaping (Result<String>) -> Void) {
        completion(.fulfilled("registertoken"))
    }

    func loginSimple(withToken token: String, completion: @escaping (Result<String>) -> Void) {
        completion(.fulfilled("logintoken"))
    }

    func authWithSimple() {
        let userImage = UIImage(named: "None")
        self.uploadSimple(image: userImage) { uploadResult in
            switch uploadResult {
            case .rejected(let error):
                print(error.localizedDescription)
            case .fulfilled(let token):
                self.registerSimple(credentials: token) { registerResult in
                    switch registerResult {
                    case .rejected(let error):
                        print(error.localizedDescription)
                    case .fulfilled(let result):
                        self.loginSimple(withToken: result) { result in
                            switch result {
                            case .rejected(let error): print(error.localizedDescription)
                            case .fulfilled(let res): print(res)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Promise kit

    //wrappers - мы можем переопределить методы , которые уже были написаны калбэками для нашего приложениея
    func uploadSimplePromiseWrapper(image: UIImage?) -> Promise<String> {
        return Promise {
            self.uploadSimple(image: nil, completion: $0.resolve)
        }
    }

    func registerSimplePromiseWrapper(credentials: String) -> Promise<String> {
        return Promise {
            self.registerSimple(credentials: credentials, completion: $0.resolve)
        }
    }

    func loginSimplePromiseWrapper(withToken token: String) -> Promise<String> {
        return Promise {
            self.loginSimple(withToken: token, completion: $0.resolve)
        }
    }

    //clean code - чистое использование promise kit
    func upload(image: UIImage?) -> Promise<String> {
        return Promise { resolver in
            arc4random() % 2 == 0 ? resolver.fulfill("uploadtoken") : resolver.reject(UploadError.failedToUpload)
        }
    }

    func register(credentials: String) -> Promise<String> {
        return Promise { resolver in
            arc4random() % 2 == 0 ? resolver.fulfill("registertoken") : resolver.reject(RegisterError.failedToRegister)
        }
    }

    func login(withToken token: String) -> Promise<String> {
        return Promise { resolver in
            arc4random() % 2 == 0 ? resolver.fulfill("uploadtlogintokenoken") : resolver.reject(LoginError.failedToLogin)
        }
    }

    //Цепочка операций
    func authWithPrimise() {
        let userImage = UIImage(named: "None")
        firstly {
            upload(image: userImage)
        }.then { token in
            self.register(credentials: token)
        }.then { token in
            self.login(withToken: token)
        }.done { result in
            print(result)
        }.ensure { //handler is always called.
            print("ensure")
        }.catch { error in
            print(error)
        }
    }

    func authWithPrimise() -> Promise<String> {
        let userImage = UIImage(named: "None")
        return firstly {
            upload(image: userImage)
        }.then { token in
            self.register(credentials: token)
        }.then { token in
            self.login(withToken: token)
        }
    }

    //Выполнение операций вместе для получения одновременных операций
    func authWithPrimiseWhenAll() {
        let userImage = UIImage(named: "None")
        firstly {
            when(fulfilled: upload(image: userImage), register(credentials: "token"), login(withToken: "token"))
        }.done { token1, token2, token3 in
            print(token1, token2, token3)
        }.catch { error in
            dump(error)
        }
    }

    // MARK: - Guarantee - гарантия, никогда не кидает ошибку, поэтому нет смысла использовать блок catch
    func loginSimpleGuaranteeWrapper(withToken token: String) -> Guarantee<Result<String>> {
        return Guarantee { reslover in
            self.loginSimple(withToken: token) { result in
                reslover(result)
            }
        }
    }


    // MARK: - map, compactMap
    func testCollection(request: URLRequest) {
        firstly {
            URLSession.shared.dataTask(.promise, with: request)
        }.compactMap {
            try JSONSerialization.jsonObject(with: $0.data) as? [String]
        }.done {
            print($0)
        }.catch { error in
            dump(error)
        }
    }
}

// MARK: - Common Patterns
extension PromiseKitDataController {
    // MARK: APIs That Use Promises
    struct User {
        let imageULR: URL!
        init?(dict: [String: Any]) {
            return nil
        }
    }

    func user(url: URL) -> Promise<User> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.compactMap {
            try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
        }.compactMap { dict in
            User(dict: dict)
        }
    }

    func avatar(url: URL) -> Promise<UIImage> {
        //return user().then { user
        return firstly {
            user(url: url)
        }.then { user in
            URLSession.shared.dataTask(.promise, with: user.imageULR)
        }.compactMap {
            UIImage(data: $0.data)
        }
    }

    // MARK : Background Work
    func avatar2(url: URL) -> Promise<UIImage> {
        let globalQueue = DispatchQueue.global(qos: .userInitiated)
        return firstly {
            user(url: url)
        }.then(on: globalQueue) { user in
            URLSession.shared.dataTask(.promise, with: user.imageULR)
        }.compactMap(on: globalQueue) {
            UIImage(data: $0.data)
        }
    }
}

