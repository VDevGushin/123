//
//  LogicControllers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 29/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {
}

struct DataLoaderForLogicViewController {
    func loadItems(callBack: (String) -> Void) {
        callBack("test")
    }
}

final class ListViewController: UITableViewController {
    let dataLoader = DataLoaderForLogicViewController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadItems()
    }

    private func loadItems () {
        let loadingViewController = LoadingViewController()
        add(loadingViewController)

        dataLoader.loadItems { [weak self] result in
            loadingViewController.remove()
            self?.handle(result)
        }
    }

    fileprivate func handle(_ res: String) { }
}

// MARK: - Logic controllers
enum ProfileState {
    case loading
    case presenting(User)
    case failed(Error)
}

final class ProfileLogicController {
    typealias Handler = (ProfileState) -> Void
    let dataLoader = DataLoaderForLogicViewController()
    func load(then handler: @escaping Handler) {

    }

    func changeDisplayName(to name: String, then handler: @escaping Handler) {

    }

    func changeProfilePhone(to phone: UIImage, then handler: @escaping Handler) {

    }

    func logout() {

    }
}

// MARK: - Using
final class ProfileViewControler: UIViewController {
    private let logicController: ProfileLogicController

    init(logicController: ProfileLogicController) {
        self.logicController = logicController
        super.init(nibName: "name", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func render(_ type: ProfileState) {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render(.loading)
        logicController.load { [weak self] state in
            self?.render(state)
        }
    }
}

extension ProfileViewControler: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let newDisplayName = textField.text else {
            return
        }

        logicController.changeDisplayName(to: newDisplayName) { [weak self] state in
            self?.render(state)
        }
    }
}
