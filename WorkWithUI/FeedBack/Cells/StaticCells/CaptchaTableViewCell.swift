//
//  CaptchaTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CaptchaTableViewCell: UITableViewCell, IFeedbackStaticCell {
    weak var navigator: FeedBackNavigator?
    weak var delegate: IFeedbackStaticCellDelegate?

    var type: StaticCellType?

    var isReady: Bool = false

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captcha: CaptchaView!
    @IBOutlet weak var input: UITextField!

    weak var viewController: UIViewController?

    func config(value: String, type: StaticCellType, viewController: UIViewController, navigator: FeedBackNavigator?, delegate: IFeedbackStaticCellDelegate?) {
        if isReady { return }
        self.isReady.toggle()
        self.navigator = navigator
        self.delegate = delegate
        self.titleLabel.text = value
        self.type = type
        self.normalInputStyle()
        self.viewController = viewController
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
        guard let type = self.type else { return }

        if case .captcha = type {
            let result = self.validResult(string: text, type: type)
            delegate?.cellSource(with: .captcha(id: result.id, text: result.text))
        }
    }

    @discardableResult
    func validResult(string: String?, type: StaticCellType) -> (id: String?, text: String?) {
        guard let string = string, let captchaId = self.captcha.getModel()?.id else { return (nil, nil) }
        if case .captcha = type {
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
