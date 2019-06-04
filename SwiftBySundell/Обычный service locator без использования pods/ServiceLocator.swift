//
//  ServiceLocator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 13/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate final class GlobalServiceLocator {
    lazy var service1: GloblaServ = GlobalServClass()
}

fileprivate final class LocalServiceLocator {
    private var registry: [String: Any] = [:]

    func registerService<T>(service: T) {
        let key = "\(T.self)"
        registry[key] = service
    }

    func tryGetService<T>() -> T? {
        let key = "\(T.self)"
        return registry[key] as? T
    }

    func getService<T>() -> T {
        let key = "\(T.self)"
        return registry[key] as! T
    }
}

fileprivate final class ServiceLocator {
    private var _global = GlobalServiceLocator() //глобальные сервисы
    private var _local = LocalServiceLocator() //локальные конкретные сервисы

    private static let shared = ServiceLocator()
    private init() { }

    class var global: GlobalServiceLocator {
        return ServiceLocator.shared._global
    }

    class var local: LocalServiceLocator {
        return ServiceLocator.shared._local
    }
}

fileprivate protocol GloblaServ { }
fileprivate class GlobalServClass: GloblaServ { }

fileprivate protocol ICat {
    func meow() -> String
}

fileprivate protocol IDog {
    func bark() -> String
}


fileprivate class Murzik: ICat {
    @discardableResult
    func meow() -> String {
        return "Meeooow"
    }
}

fileprivate class Muhtar: IDog {
    @discardableResult
    func bark() -> String {
        return "Woof"
    }
}

fileprivate func test() {

    ServiceLocator.local.registerService(service: Murzik() as ICat)
    ServiceLocator.local.registerService(service: Muhtar() as IDog)

    let cat: ICat? = ServiceLocator.local.tryGetService()
    let dog: IDog = ServiceLocator.local.getService()
    _ = cat?.meow()
    _ = dog.bark()

    let _ = ServiceLocator.global.service1
}
