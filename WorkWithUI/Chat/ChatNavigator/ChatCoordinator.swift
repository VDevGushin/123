//
//  ChatCoordinator.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class ChatCoordinator {
    var chatCreated = true
    enum Destination {
        case allChats
        case chatMessages(chat: Chat)
        case createChat
        case chatCreated(chat: Chat)
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
            return AddChatViewController(navigator: self)
        case .chatCreated(chat: let chat):
            if var navigationArray = self.navigationController?.viewControllers {
                navigationArray.remove(at: navigationArray.count - 1) // To remove previous UIViewController
                self.navigationController?.viewControllers = navigationArray
            }
            self.chatCreated = true
            return MessageViewController(navigator: self, chat: chat)
        }
    }

    static func chatNavigation() -> UINavigationController {
        let navigationViewController = UINavigationController()
        ChatStyle.navigationBar(navigationViewController.navigationBar)
        let navigator = ChatCoordinator(navigationController: navigationViewController)
        navigator.navigate(to: .allChats)
        return navigationViewController
    }
}
