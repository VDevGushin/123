//
//  CaptchaTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CaptchaTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var isValid: Bool = true
    
    func check() {
        self.inputEditAction(with: input.text)
    }
    
    var action: ActionsForStaticCells?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captcha: CaptchaView!
    @IBOutlet weak var input: UITextField!

    func config(value: String, action: ActionsForStaticCells) {
        self.titleLabel.text = value
        self.isValid = true
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
            handler(.captcha(with: result))
        default:
            break
        }
    }

    @discardableResult
    func validResult(string: String?, action: ActionsForStaticCells) -> String? {
        guard let string = string else { return "" }
        switch action {
        case .setCaptcha:
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
