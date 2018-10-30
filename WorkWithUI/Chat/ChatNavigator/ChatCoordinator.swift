//
//  ChatCoordinator.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class ChatCoordinator {
    enum Destination {
        case allChats
        case chatMessages(chat: Chat)
        case createChat
    }

    func close() {
        self.navigationController?.dismiss(animated: true)
    }

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .allChats:
            return ChatsViewController(navigator: self)
        case .chatMessages(let chat):
            return MessageViewController(navigator: self, chat: chat)
        case .createChat:
            fatalError()
        }
    }

    static func chatNavigation() -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.barTintColor = ChatResources.styleColor
        navigationViewController.navigationBar.tintColor = ChatResources.whiteColor
        navigationViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ChatResources.whiteColor]
        let navigator = ChatCoordinator(navigationController: navigationViewController)
        navigator.navigate(to: .allChats)
        return navigationViewController
    }
}
