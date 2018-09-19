//
//  TrimmingLongArgumentLists.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

private struct Animation {
    var duration: TimeInterval = 0.3
    var curve = UIView.AnimationCurve.easeInOut
    var completionHandler: (() -> Void)?
}

private struct Friend {
    enum Group { case a }
}

private class TestTrim {
    func presentProfile(animated: Bool) {

    }

    func presentProfile(animated: Bool,
                        duration: TimeInterval = 0.3,
                        curve: UIView.AnimationCurve = .easeInOut,
                        completionHandler: (() -> Void)? = nil) {
    }

    //Более понятный и чистый вызов функции
    func presentProfile(with animation: Animation? = nil) {
    }

    func loadFriends(matching query: String,
                     limit: Int? = nil,
                     sorted: Bool = false,
                     filteredByGroup group: Friend.Group? = nil,
                     handler: @escaping (Result<[Friend]>) -> Void) {

    }

    func testLoadFriend() {
        let query = ""
        loadFriends(matching: query) { [weak self] result in
            switch result {
            case .result(let friends):
                break
                // self?.render(friends.filtered(by: group).sorted())
            case .error(let error):
                break
                //  self?.render(error)
            }
        }
    }
}

class DialogOutcome { }

extension UIViewController {
    func presentDialog(withTitle title: String,
                       message: String,
                       acceptTitle: String,
                       rejectTitle: String,
                       handler: @escaping (DialogOutcome) -> Void) {

    }
}

struct DialogPresenter {
    typealias Handler = (DialogOutcome) -> Void

    let title: String
    let message: String
    let acceptTitle: String
    let rejectTitle: String
    let handler: Handler

    func present(in viewController: UIViewController) {
    }
}
