//
//  SelectPresenter.swift
//  UIPart
//
//  Created by Vladislav Gushin on 27/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct SelectPresenter {
    typealias ActionClosure = () -> Void
    typealias ActionModel = (title: String, action: ActionClosure)

    let actions: [ActionModel]
    let message: String
    let title: String

    func present(in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for action in actions {
            let newAlertAction = UIAlertAction(title: action.title, style: .default) { _ in
                action.action()
            }
            alert.addAction(newAlertAction)
        }

        let rejectAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(rejectAction)
        viewController.present(alert, animated: true)
    }
}
