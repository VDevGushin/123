//
//  HandlingNon-OptionalOptionals .swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 16/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct ViewModel { }
/*
 По сути, мы говорим здесь о том, стоит ли заниматься защитным программированием. Мы пытаемся восстановиться из неопределенного состояния, или мы просто сдаемся и терпим крах?
 */
fileprivate class TableViewController: UIViewController {
    var tableView: UITableView? // мы точно знаем, что таблица есть - так зачем ее анврапить?

    //Один из способов - использовать ленивую инициализацию
    lazy var tableView2 = UITableView()

    /*
     Правильное управление зависимостями лучше, чем необязательные опции
     Другое распространенное использование опций - это нарушение циклических зависимостей. Иногда вы можете попасть в ситуации, когда A зависит от B, но B также зависит от A. Как в этой настройке:
 */

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds)
        tableView2.frame = view.bounds
        view.addSubview(tableView!)
    }

    func viewModelDidUpdate(_ viewModel: ViewModel) {
        tableView?.reloadData()
        tableView2.reloadData()
    }
}

/*
 Правильное управление зависимостями лучше, чем необязательные опции
 
 Другое распространенное использование опций - это нарушение циклических зависимостей. Иногда вы можете попасть в ситуации, когда A зависит от B, но B также зависит от A. Как в этой настройке:
 */

fileprivate struct Comment {
    let text: String
}
fileprivate struct User {
    var totalNumberOfComments: Int = 0
    func logOut() { }
}

fileprivate class UserManager {
    private weak var commentManager: CommentManager?
    lazy var user = User()
    func userDidPostComment(_ comment: Comment) {
        user.totalNumberOfComments += 1
    }

    func logOutCurrentUser() {
        user.logOut()
        commentManager?.clearCache()
    }
}

fileprivate class CommentManager {
    private weak var userManager: UserManager?

    func composer(_ composer: CommentComposer, didPostComment comment: Comment) {
        userManager?.userDidPostComment(comment)
        handle(comment)
    }

    func clearCache() { }
    func handle(_ comment: Comment) { }
}

fileprivate class CommentComposer {
    private let commentManager: CommentManager
    private let userManager: UserManager
    private lazy var textView = UITextView()

    init(commentManager: CommentManager, userManager: UserManager) {
        self.commentManager = commentManager
        self.userManager = userManager
    }

    func postComment() {
        let comment = Comment(text: textView.text)
        commentManager.handle(comment)
        userManager.userDidPostComment(comment)
    }
}
