//
//  Интеграционное тестирование для проверки на наличие утечки памяти.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 15/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate protocol UseCaseDelegate: class {
    func operationDidComplete()
}

fileprivate class ServiceResponse { }

fileprivate class Service {
    func makeRequest(_ handle: (ServiceResponse) -> Void) { }
}

//Тут есть утечка памяти
fileprivate final class UseCase {
    weak var delegate: UseCaseDelegate?
    private let service: Service

    init(service: Service) {
        self.service = service
    }

    func run() {
        //Утечка захвата self
        service.makeRequest(handleResponse)
    }

    private func handleResponse(response: ServiceResponse) {
        // some business logic and then...
        delegate?.operationDidComplete()
    }
}
