//
//  PreventingМiewsFromBeingModelAware.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Help classes
fileprivate struct User {
    let firstName: String
    let lastName: String
    let profileImage: UIImage
    var isFriend: Bool
}

fileprivate class AddFriendButton: UIButton {
    var closure: (() -> Void)?
}
fileprivate class FriendManager {
    public static let shared = FriendManager()
    private init() { }
    func addUserAsFriend(_ f: User) { }
}

// MARK: - Example
/*рассмотрим несколько различных способов, которыми мы можем отделить
 наш код пользовательского интерфейса от кода модели, а также некоторые преимущества этого.
 Хотя все примеры кода в этом посте будут относиться к iOS, принципы должны быть применимы к любому виду кода Swift UI.
  Допустим, мы хотим отобразить список пользователей в табличном представлении и хотим настроить округление изображения каждой ячейки. Распространенный способ сделать это - создать новый подкласс ячейки, который специализируется на визуализации пользователя, например:
 */
fileprivate class UserTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageView = self.imageView!
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }

    func configure(with user: User) {
        textLabel?.text = "\(user.firstName) \(user.lastName)"
        imageView?.image = user.profileImage
    }
}

/*Выполнение чего-либо подобного выше может показаться безвредным,
 но технически мы начали просачивать детали слоя модели в наш слой представления. Наш класс UserTableViewCell теперь не только специализирован для отдельного случая использования, но также осведомлен о самой модели User.
 Поначалу это не может быть проблемой, но если мы продолжим идти по этому пути, легко получить код представления, который содержит важные части логики нашего приложения:
 */
//Этой логике не должно быть в cell
extension UserTableViewCell {
    func configure1(with user: User) {
        textLabel?.text = "\(user.firstName) \(user.lastName)"
        imageView?.image = user.profileImage

        // Since this is where we do our model->view binding,
        // it may seem like the natural place for setting up
        // UI events and responding to them.
        if !user.isFriend {
            let addFriendButton = AddFriendButton()
            addFriendButton.closure = {
                FriendManager.shared.addUserAsFriend(user)
            }
            accessoryView = addFriendButton
        } else {
            accessoryView = nil
        }
    }
}
/*Написание кода пользовательского интерфейса, как описано выше, может показаться очень удобным, но обычно это приводит к тому,
 что приложение действительно сложно тестировать и поддерживать.
 С помощью описанной выше настройки нам необходимо создать специальные специализированные представления для всех моделей нашего приложения
 (даже если они имеют много общего или выглядят одинаково), что значительно усложняет внедрение новых функций для всего приложения или выполнение рефакторинга в будущее.*/

// MARK: - Generalized views
/*
 Обобщенные взгляды
 Одно из решений вышеупомянутой проблемы - придерживаться более строгого разделения между нашим представлением и кодом модели.
 При этом мы должны не только исключить использование типов моделей из нашего кода пользовательского интерфейса, но и концептуально разделить два уровня.
 
 Давайте вернемся и снова посмотрим на нашу UserTableViewCell. Вместо того, чтобы сильно связывать это с рендерингом пользователя,
 мы могли бы вместо этого назвать его, чтобы описать, что он на самом деле делает, что делает его изображение круговым. Давайте назовем его RoundedImageTableViewCell и удалим его метод configure, который был строго привязан к типу User:
 */

fileprivate class RoundedImageTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageView = self.imageView!
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
}
/*
 Большим преимуществом внесения вышеуказанных изменений является то, что теперь мы можем легко повторно использовать этот тип ячейки для любых других моделей, которые мы хотим визуализировать с округленным изображением. Наш код пользовательского интерфейса теперь также не делает каких-либо жестких предположений о том, что он отображает, он просто отображает то, что ему было сказано, что обычно хорошо.
 
 Однако, обобщая и отделяя код нашей модели от кода нашего представления, мы также сделали его менее удобным для использования. Раньше мы могли просто вызвать configure (с помощью :), чтобы начать рендеринг модели User, но теперь, когда этот метод пропал, нам нужно найти новый способ сделать это (без необходимости дублировать один и тот же код привязки данных во всем нашем приложении).
 
 Вместо этого мы можем создать выделенный объект, который настраивает ячейки для отображения пользователей. В этом случае мы назовем его UserTableViewCellConfigurator, но в зависимости от выбранного вами архитектурного шаблона вы можете вместо этого назвать его Presenter или Adapter (мы рассмотрим различные такие шаблоны в будущих публикациях). В любом случае, вот как может выглядеть такой объект:
 */

fileprivate class UserTableViewCellConfigurator {
    private let friendManager: FriendManager

    init(friendManager: FriendManager) {
        self.friendManager = friendManager
    }

    func configure(_ cell: UITableViewCell, forDisplaying user: User) {
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.imageView?.image = user.profileImage

        if !user.isFriend {
            // We create a local reference to the friend manager so that
            // the button doesn't have to capture the configurator.
            let friendManager = self.friendManager

            let addFriendButton = AddFriendButton()

            addFriendButton.closure = {
                friendManager.addUserAsFriend(user)
            }

            cell.accessoryView = addFriendButton
        } else {
            cell.accessoryView = nil
        }
    }
}

// MARK: - Using
fileprivate class UserListViewController: UITableViewController {
    private let users = [User]()
    private let configurator = UserTableViewCellConfigurator(friendManager: .shared)
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        configurator.configure(cell, forDisplaying: user)
        return cell
    }
}
