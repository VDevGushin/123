//
//  CaptchaTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CaptchaTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var initialSource: StaticCellsSource?
    var isReady: Bool = false

    var action: ActionsForStaticCells?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captcha: CaptchaView!
    @IBOutlet weak var input: UITextField!

    func config(value: String, action: ActionsForStaticCells) {
        if isReady { return }
        self.isReady.toggle()
        self.titleLabel.text = value
        self.action = action
        self.normalInputStyle()
        self.input.delegate = self
    }

    func wrongInputStyle() {
        FeedBackStyle.titleLabelWithError(self.titleLabel)
        FeedBackStyle.textFieldWithError(self.input)
    }

    func normalInputStyle() {
        FeedBackStyle.titleLabel(self.titleLabel)
        FeedBackStyle.textField(self.input)
    }

    @IBAction func textChange(_ sender: Any) {
        self.inputEditAction(with: input.text)
    }

    func check() {
        self.inputEditAction(with: input.text)
    }

    func setValue(with: String) {
        self.input.text = with
        self.input.endEditing(true)
    }
}

extension CaptchaTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inputEditAction(with: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func inputEditAction(with text: String?) {
        guard let action = self.action else { return }
        switch action {
        case .setCaptcha(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.captcha(id: result.id, text: result.text))
        default:
            break
        }
    }

    @discardableResult
    func validResult(string: String?, action: ActionsForStaticCells) -> (id: String?, text: String?) {
        guard let string = string, let captchaId = self.captcha.model?.id else { return (nil, nil) }
        if case .setCaptcha = action {
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !captchaId.isEmpty {
                self.normalInputStyle()
                return (captchaId, string)
            }
            self.wrongInputStyle()
            return (nil, nil)
        }
        return (nil, string)
    }
}
