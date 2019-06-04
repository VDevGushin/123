//
//  RealAlamofireDataController+Auth.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire

extension RealAlamofireDataController {
    // MARK - HTTP Basic Authentication
    /*The authenticate method on a Request will automatically provide a URLCredential to a URLAuthenticationChallenge when appropriate:*/
    func makeAuth(with user: String, password: String) {
        AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
            .authenticate(username: user, password: password)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    debugPrint(value)
                case .failure(let error):
                    print(error)
                }
        }
    }
    //В зависимости от реализации вашего сервера может также подойти заголовок авторизации:
    func makeAuthWithHeaders(with user: String, password: String, headers: HTTPHeaders) {
        /*let user = "user"
         let password = "password"
         var headers: HTTPHeaders = [:]
         if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
         headers[authorizationHeader.key] = authorizationHeader.value
         }
         Alamofire.request("https://httpbin.org/basic-auth/user/password", headers: headers)
         .responseJSON { response in
         debugPrint(response)
         }*/
    }

    // Authentication with URLCredential
    func makeAuthWithCredential(with user: String, password: String) {
        let credential = URLCredential(user: user, password: password, persistence: .forSession)
        AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
            .authenticate(with: credential)
            .responseJSON { response in
                debugPrint(response)
        }
    }
    /*Важно отметить, что при использовании URLCredential для аутентификации базовый URLSession фактически завершает выполнение двух запросов, если сервер выдает запрос. Первый запрос не будет включать учетные данные, которые «могут» вызвать запрос с сервера. Затем Alamofire получает запрос, учетные данные добавляются, и запрос повторяется базовым URLSession.*/
}
