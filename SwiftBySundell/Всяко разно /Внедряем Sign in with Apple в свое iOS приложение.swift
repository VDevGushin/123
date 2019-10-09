//
//  Внедряем Sign in with Apple в свое iOS приложение.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/10/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import AuthenticationServices

/**На WWDC 2019 Apple в очередной раз нарушила покой iOS разработчиков — представила новую систему авторизации пользователей Sign in with Apple. Теперь все iOS приложения, которые используют сторонние системы авторизации (Facebook, Twitter, etc.), должны в обязательном порядке реализовать Sign in with Apple, иначе выгонят из AppStore. Мы решили не испытывать судьбу и побежали внедрять эту фичу. Как именно мы это сделали — узнаете под катом. */

enum AuthToken {
    case apple(code: String, name: String)
}

protocol AuthProviderProtocol {
    @available(iOS 13.0, *)
    func login()
    func logout()
}

class AppleAuthService: NSObject, AuthProviderProtocol {
    @available(iOS 13.0, *)
    func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func logout() {
        /**У Sign in with Apple нету функции logout в классическом понимании этого слова. Библиотека не хранит никакие данные, в отличие от других библиотек входа, поэтому нет необходимости стирать данные, полученные при логине*/
    }
}

@available(iOS 13.0, *)
extension AppleAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.authorizationCode,
            let token = String(data: tokenData, encoding: .utf8)
            else { return }

        let firstName = credential.fullName?.givenName ?? ""
        let lastName = credential.fullName?.familyName ?? ""

        print(firstName, lastName, token)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
