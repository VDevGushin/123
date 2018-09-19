//
//  EarlyReturningFunctions.swift
//  MyWork
//
//  Created by Vladislav Gushin on 03/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate final class ThisDataBase {
    func loadNote(withID: Int) -> Any? {
        return nil
    }
}

// MARK: - Return early, return often
fileprivate final class NoteListViewController: UIViewController {
    let dataBase = ThisDataBase()

    @objc func handlerChangeNotificationV1(_ notification: Notification) {
        let noteInfo = notification.userInfo?["note"] as? [String: Any]
        if let id = noteInfo?["id"] as? Int {
            if let note = dataBase.loadNote(withID: id) {
                //logic
            }
        }
    }

    @objc func handlerChangeNotificationV2(_ notification: Notification) {
        let noteInfo = notification.userInfo?["note"] as? [String: Any]
        guard let id = noteInfo?["id"] as? Int else {
            return
        }
        guard let note = dataBase.loadNote(withID: id) else {
            return
        }

        //work with note
    }

    //work with more simple code
    @objc func handlerChangeNotificationV3(_ notification: Notification) {

        guard let id = notification.noteID else {
            return
        }
        guard let note = dataBase.loadNote(withID: id) else {
            return
        }
        //work with note
    }
}

//Функции выше можно переписать в более удобной форме
extension Notification {
    var noteID: Int? {
        let info = userInfo?["note"] as? [String: Any]
        return info?["id"] as? Int
    }
}

//TODO: -Conditional construction

/*class CommentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //проблемное место
        if comment.authorID == user.id {
            if comment.replies.isEmpty {
                if !comment.edited {
                    let editButton = UIButton()
                        ...
                        view.addSubview(editButton)
                }
            }
        }
        
        ...
    }
}
 
 исправляем проблемное место
 extension Comment {
 func canBeEdited(by user: User) -> Bool {
 guard authorID == user.id else {
 return false
 }
 
 guard comment.replies.isEmpty else {
 return false
 }
 
 return !edited
 }
 }
 
 используем
 class CommentViewController: UIViewController {
 override func viewDidLoad() {
 super.viewDidLoad()
 
 if comment.canBeEdited(by: user) {
 let editButton = UIButton()
 ...
 view.addSubview(editButton)
 }
 
 ...
 }
 }
 
 */
