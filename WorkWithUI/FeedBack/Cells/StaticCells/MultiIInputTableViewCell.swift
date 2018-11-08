//
//  MultiIInputTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class MultiIInputTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var isValid: Bool = true

    func check() {
        self.inputEditAction(with: textInput.text)
    }

    var action: ActionsForStaticCells?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textInput: UITextView!

    func config(value: String, action: ActionsForStaticCells) {
        self.titleLabel.text = value
        self.action = action
        isValid = true
        normalInputStyle()
        textInput.delegate = self
    }

    func wrongInputStyle() {
        FeedBackStyle.titleLabelWithError(self.titleLabel)
        FeedBackStyle.textViewWithError(self.textInput)
    }

    func normalInputStyle() {
        FeedBackStyle.titleLabel(self.titleLabel)
        FeedBackStyle.textView(self.textInput)
    }
}

extension MultiIInputTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.inputEditAction(with: textView.text)
    }

    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    func inputEditAction(with text: String?) {
        guard let action = self.action else { return }
        switch action {
        case .setDetail(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.detail(with: result))
        default:
            break
        }
    }

    @discardableResult
    func validResult(string: String?, action: ActionsForStaticCells) -> String? {
        guard let string = string else { return nil }
        switch action {
        case .setDetail:
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.normalInputStyle()
                self.isValid = true
                return string
            }
            self.wrongInputStyle()
            self.isValid = false
            return nil
        default:
            return string
        }
    }
}
