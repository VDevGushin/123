//
//  DependencyInjectionUsingFactories.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 24/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate class DataLoader { }
fileprivate class Database { }
fileprivate class Cache { }
fileprivate class Keychain { }
fileprivate class TokenManager { }
fileprivate class Message { }
fileprivate class MessageLoader { }
fileprivate class MessageSender { }
fileprivate class NetworkManager { }
/*
Внедрение зависимостей также может стать довольно большой проблемой, когда широко используется в проекте.
 По мере роста числа зависимостей для данного объекта его инициализация может стать довольно сложной задачей.
 */

fileprivate class DIVc: UIViewController {
    //Плохой конструктор - слишком много зависимостей - большая заргузка
    init(dataLoader: DataLoader, database: Database, cache: Cache,
         keychain: Keychain, tokenManager: TokenManager) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Passing dependencies around

fileprivate class MessageListViewController: UITableViewController {
    private let loader: MessageLoader

    init(loader: MessageLoader) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class MessageViewController: UIViewController { }

// MARK: - Factory
//Попробуем разгрузить view controller и использовать фабрику
fileprivate protocol ViewControllerFactory {
    func makeMessageListViewController() -> MessageListViewController
    func makeMessageViewController(for message: Message) -> MessageViewController
}

fileprivate protocol MessageLoaderFactory {
    func makeMessageLoader() -> MessageLoader
}

fileprivate class MessageListViewControllerFactorys: UITableViewController {
    typealias Factory = MessageLoaderFactory & ViewControllerFactory

    private let factory: Factory
    // We can now lazily create our MessageLoader using the injected factory.
    private lazy var loader = factory.makeMessageLoader()
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - A single dependency

fileprivate class DependencyContainer {
    private lazy var messageSender = MessageSender()
    private lazy var networkManager = NetworkManager()
}
