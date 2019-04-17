//
//  LogicControllers.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 13/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
//Идея - избалвение от массивного контроллера
//Разбиение его на дочерние контроллеры
fileprivate struct User {

}

fileprivate enum ProfileState {
    case loading
    case presenting(User)
    case failed(Error)
}

// Это логический контроллер, в который вынесена часть логики
fileprivate final class ProfileLogicController {
    typealias Handler = (ProfileState) -> Void

    func load(then handler: @escaping Handler) {
//        let cacheKey = "user"
//
//        if let existingUser: User = cache.object(forKey: cacheKey) {
//            handler(.presenting(existingUser))
//            return
//        }
//
//        dataLoader.loadData(from: .currentUser) { [cache] result in
//            switch result {
//            case .success(let user):
//                cache.insert(user, forKey: cacheKey)
//                handler(.presenting(user))
//            case .failure(let error):
//                handler(.failed(error))
//            }
//        }
    }

    func changeDisplayName(to name: String, then handler: @escaping Handler) {

    }

    func changeProfilePhoto(to photo: UIImage, then handler: @escaping Handler) {

    }

    func logout() {

    }
}

//Используем локический контроллер в контроллере представления
/*Прелесть этого подхода в том, что нашему контроллеру представления не нужно знать, как было загружено его состояние, ему просто нужно принять любое состояние, которое ему дает логический контроллер, и отобразить его. Благодаря отделению нашей логики от нашего кода пользовательского интерфейса, это также становится намного проще для тестирования. Чтобы протестировать описанный выше метод загрузки, все, что нам нужно сделать, - это смоделировать загрузчик данных и кеш и утверждать, что в ситуациях с кэшированием, успешностью и ошибкой возвращается правильное состояние.*/
fileprivate final class ProfileViewController: UIViewController {
    private let logicController: ProfileLogicController

    init(logicController: ProfileLogicController) {
        self.logicController = logicController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render(.loading)
        logicController.load { [weak self] state in
            self?.render(state)
        }
    }

    func render(_ state: ProfileState) {
        switch state {
        case .loading: break
            // Show a loading spinner, for example using a child view controller
        case .presenting: break
            // Bind the user model to the view controller's views
        case .failed: break
            // Show an error view, for example using a child view controller
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newDisplayName = textField.text else {
            return
        }

        logicController.changeDisplayName(to: newDisplayName) { [weak self] state in
            self?.render(state)
        }
    }
}
