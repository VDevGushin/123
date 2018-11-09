//
//  InputTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell, IFeedbackStaticCell {
    func clear() {

    }

    var initialSource: StaticCellsSource?
    var isReady: Bool = false
    var action: ActionsForStaticCells?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet weak var actionBitton: UIButton!

    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!

    func config(value: String, action: ActionsForStaticCells) {
        if isReady { return }
        self.isReady.toggle()

        self.titleLabel.text = value
        self.action = action
        self.normalInputStyle()
        self.actionBitton.isHidden = true
        if let action = self.action {
            switch action {
            case .setOrganisation, .setTheme:
                self.actionBitton.isHidden = false
            case .setPhone:
                self.inputField.keyboardType = .numberPad
                self.actionBitton.isHidden = true
            default:
                self.actionBitton.isHidden = true
            }
        }
    }

    @IBAction func textChange(_ sender: Any) {
        self.inputEditAction(with: inputField.text)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.inputField.delegate = self
    }

    func check() {
        self.inputEditAction(with: inputField.text)
    }

    @IBAction func openSelectionAction(_ sender: Any) {
        guard let action = self.action else { return }
        if case ActionsForStaticCells.setOrganisation(let navigator, _) = action {
            navigator.navigate(to: .selection(title: titleLabel.text!, worker: OrganisationWorker(), delegate: self))
        }

        if case ActionsForStaticCells.setTheme(let navigator, _) = action {
            let title = titleLabel.text!.replacingOccurrences(of: "*", with: "")
            navigator.navigate(to: .selection(title: title, worker: ThemesWorker(), delegate: self))
        }
    }

    func wrongInputStyle() {
        FeedBackStyle.titleLabelWithError(self.titleLabel)
        FeedBackStyle.textFieldWithError(self.inputField)
    }

    func normalInputStyle() {
        FeedBackStyle.titleLabel(self.titleLabel)
        FeedBackStyle.textField(self.inputField)
    }
}

extension InputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inputEditAction(with: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let action = self.action {
            if case ActionsForStaticCells.setOrganisation = action {
                return false
            }

            if case ActionsForStaticCells.setTheme = action {
                self.inputEditAction(with: textField.text)
                return false
            }
        }
        return true
    }

    func inputEditAction(with text: String?) {
        guard let action = self.action else { return }
        switch action {
        case .setName(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.name(with: result))

        case .setLastName(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.lastName(with: result))

        case .setMiddleName(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.middleName(with: result))

        case .setDetail(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.detail(with: result))

        case .setMail(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.mail(with: result))

        case .setPhone(let handler):
            let result = self.validResult(string: text, action: action)
            handler(.phone(with: result))

        case .setOrganisation, .setTheme:
            self.validResult(string: text, action: action)
        default:
            break
        }
    }

    @discardableResult
    func validResult(string: String?, action: ActionsForStaticCells) -> String? {
        guard let string = string else { return nil }
        switch action {
        case .setMail:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: string) {
                self.normalInputStyle()
                return string
            }
            self.wrongInputStyle()
            return nil
        case .setName, .setLastName, .setOrganisation, .setTheme:
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.normalInputStyle()
                return string
            }
            self.wrongInputStyle()
            return nil
        default:
            return string
        }
    }
}

extension InputTableViewCell: FeedBackSearchViewControllerDelegate {
    func selectSource<T>(selected: T) {
        guard let action = self.action else { return }

        if case ActionsForStaticCells.setOrganisation(_, let then) = action, let model = selected as? Organisation {
            self.inputField.text = model.shortTitle
            then(StaticCellsSource.organisation(with: model))
        }

        if case ActionsForStaticCells.setTheme(_, let then) = action, let model = selected as? FeedbackTheme {
            self.inputField.text = model.title
            then(StaticCellsSource.theme(with: model))
        }

        validResult(string: self.inputField.text, action: action)
    }
}
