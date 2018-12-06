//
//  PreventingViewsFromBeingModelAware.swift
//  MyWork
//
//  Created by Vladislav Gushin on 04/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//Предотвращение представлений от модели Aware
//Первый легкий вариант
private class UserTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        let image = self.imageView!
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = image.bounds.height / 2
    }

    func configure(with user: User) {
        textLabel?.text = user.firstName
        imageView?.image = user.profileImage
    }
}

// MARK: - more clear code
// Добавляется варинат специфичного поведения с условиями

extension UserTableViewCell {
    func configureIsFriend(with user: User) {
        textLabel?.text = user.firstName
        imageView?.image = user.profileImage

        if !user.isFriend {
            let addFriendButton = AddFriendButton(frame: CGRect.zero)
            addFriendButton.closure = {
                //logic
            }
            accessoryView = addFriendButton
        } else {
            accessoryView = nil
        }
    }
}

private class AddFriendButton: UIButton {
    var closure: (() -> Void)?
}

// MARK: - new logic
private class RoundedImageTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        let imageView = self.imageView!
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
}

private class FriendManager { }

private class UserTableViewCellConfigurator {
    private let friendManager: FriendManager

    init(friendManager: FriendManager) {
        self.friendManager = friendManager
    }

    func configure(_ cell: UITableViewCell, forDisplay user: User) {
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.imageView?.image = user.profileImage

        if !user.isFriend {
            // We create a local reference to the friend manager so that
            // the button doesn't have to capture the configurator.
            let friendManager = self.friendManager
            let addFriendButton = AddFriendButton()

            addFriendButton.closure = {
                //friendManager.addUserAsFriend(user)
            }
            cell.accessoryView = addFriendButton
        } else {
            cell.accessoryView = nil
        }
    }
}

// using UserTableViewCellConfigurator

private class UserListViewController: UITableViewController {
    fileprivate let configurator = UserTableViewCellConfigurator(friendManager: FriendManager())
    let users = [User]()
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        configurator.configure(cell, forDisplay: user)
        return cell
    }
}

// MARK: - View factories
private struct Message {
    let title: String
    let text: String
    let icon: UIImage
}

fileprivate final class SampleTextView: UIView {
    weak var titleLabel: UILabel?
    weak var textLabel: UILabel?
    weak var imageView: UIImageView?
}

private class MessageViewFactory {
    func makeView(for message: Message) -> UIView {
        let view = SampleTextView()

        view.titleLabel?.text = message.title
        view.textLabel?.text = message.text
        view.imageView?.image = message.icon

        return view
    }
}
