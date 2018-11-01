//
//  AddChatViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 01/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class AddChatViewController: ChatBaseViewController {
    @IBOutlet private weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentTable: UITableView!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var chatName: UITextField!
    @IBOutlet private weak var createButton: UIButton!


    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: ChatCoordinator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: "Создать чат", nibName: String(describing: AddChatViewController.self), bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func buildUI() {
        ChatStyle.sendButton(self.createButton)
        ChatStyle.defaultBackground(self.backView)
        ChatStyle.tableView(self.contentTable, self, [MessageTableViewCell.self])

        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(AddChatViewController.keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: self.view.window)
        notifier.addObserver(self,
                             selector: #selector(AddChatViewController.keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: self.view.window)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Table view delegate
extension AddChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(type: ChatTableViewCell.self, indexPath: indexPath)!
//        cell.setChat(with: self.source[indexPath.item])
//        cell.selectionStyle = .none
//        return cell
        return UITableViewCell()
    }
}

// MARK: - Work with keyboard
fileprivate extension AddChatViewController {
    @objc func keyboardWillShowNotification(_ sender: NSNotification) {
        adjustingHeight(true, notification: sender)
    }

    @objc func keyboardWillHideNotification(_ sender: NSNotification) {
        adjustingHeight(false, notification: sender)
    }

    private func adjustingHeight(_ show: Bool, notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrameBeginUserInfoKey = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }

        let keyboardFrame: CGRect = keyboardFrameBeginUserInfoKey.cgRectValue

        var safeArea: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            safeArea = window?.safeAreaInsets.bottom ?? 0.0
        }

        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if !show {
                self.keyboardConstraint.constant = 0.0
            } else {
                self.keyboardConstraint.constant = keyboardFrame.height - safeArea
            }
        })
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
