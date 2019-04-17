//
//  Bindable values in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 01/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Возможно, одним из наиболее сложных аспектов создания приложений для большинства платформ является обеспечение того, чтобы пользовательский интерфейс, который мы представляем пользователю, всегда синхронизировался с нашими базовыми моделями данных и связанной с ними логикой. Очень часто встречаются ошибки, которые приводят к отображению устаревших данных, или ошибки, возникающие из-за конфликтов между состоянием пользовательского интерфейса и остальной логикой приложения.
 
 Поэтому неудивительно, что было изобретено так много различных шаблонов и методов, чтобы упростить обеспечение актуальности пользовательского интерфейса при изменении его базовой модели - от уведомлений до делегатов и наблюдаемых. На этой неделе давайте рассмотрим один из таких методов, который включает привязку значений нашей модели к нашему пользовательскому интерфейсу.
 
 Один из распространенных способов обеспечения того, чтобы наш пользовательский интерфейс всегда отображал последние доступные данные, - это просто перезагружать базовую модель всякий раз, когда пользовательский интерфейс будет представлен (или повторно представлен) на экране. Например, если мы создаем экран профиля для какой-либо формы приложения для социальных сетей, мы могли бы перезагрузить Пользователя, если профиль вызывается каждый раз, когда viewWillAppear вызывается в нашем ProfileViewController:*/

fileprivate struct UserLoader {
    func load(then handler: (User) -> Void) { handler(User()) }
}
fileprivate struct User {
    let name = "123"
    let followersCount = 1
}
fileprivate class HeaderView: UIView { }

fileprivate class ProfileViewController: UIViewController {
    private let userLoader: UserLoader
    private lazy var nameLabel = UILabel()
    private lazy var headerView = HeaderView()
    private lazy var followersLabel = UILabel()

    init(userLoader: UserLoader) {
        self.userLoader = userLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Here we always reload the logged in user every time
        // our view controller is about to appear on the screen.
        userLoader.load { [weak self] user in
            self?.nameLabel.text = user.name
            self?.followersLabel.text = String(user.followersCount)
        }
    }
}

/*В этом подходе нет ничего плохого, но есть несколько вещей, которые потенциально можно улучшить:
 
 Мы всегда должны сохранять ссылки на наши различные представления в качестве свойств на нашем контроллере представления, поскольку мы не можем назначать наши свойства пользовательского интерфейса, пока не загрузим модель контроллера представления.
 При использовании основанного на замыкании API для получения доступа к загруженной модели мы должны слабо ссылаться на себя (или явно захватывать каждое представление), чтобы избежать циклов сохранения.
 Каждый раз, когда наш контроллер представления отображается на экране, мы перезагружаем модель, даже если прошло всего несколько секунд с тех пор, как мы это делали в последний раз, и даже если другой контроллер представления также перезагружает ту же модель в одно и то же время, что может привести к потере впустую, или, по крайней мере, ненужные сетевые вызовы.
 Один из способов решения некоторых из вышеперечисленных пунктов заключается в использовании другого вида абстракции для предоставления нашему контроллеру доступа доступа к его модели. Как мы и рассмотрели в разделе «Обработка изменчивых моделей в Swift», вместо того, чтобы сам контроллер представления загружал свою модель, мы могли бы использовать что-то вроде UserHolder для передачи видимой оболочки вокруг нашей основной модели User.
 
 Делая это, мы можем инкапсулировать нашу логику перезагрузки и делать все необходимые обновления в одном месте, вне наших контроллеров представления, что приводит к упрощенной реализации ProfileViewController:*/

fileprivate protocol UserHolderObservers {
    func update(with user: User)
}

fileprivate struct UserHolder {
    var observers = [UserHolderObservers]()
    private let userLoader: UserLoader
    mutating func addObserver(with: UserHolderObservers) {
        self.observers.append(with)
    }

    init(userLoader: UserLoader) {
        self.userLoader = userLoader
    }

    func load() {
        userLoader.load { user in
            observers.forEach {
                $0.update(with: user)
            }
        }
    }
}

fileprivate class ProfileViewControllerWithObserver: UIViewController, UserHolderObservers {
    private var userHolder: UserHolder
    private lazy var nameLabel = UILabel()
    private lazy var headerView = HeaderView()
    private lazy var followersLabel = UILabel()

    init(userHolder: UserHolder) {
        self.userHolder = userHolder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userHolder.addObserver(with: self)
    }

    func update(with user: User) {
        self.nameLabel.text = user.name
        self.followersLabel.text = String(user.followersCount)
    }
}
