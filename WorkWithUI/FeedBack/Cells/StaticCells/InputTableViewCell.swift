//
//  InputTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell, IFeedbackStaticCell {
    weak var navigator: FeedBackNavigator?
    weak var delegate: IFeedbackStaticCellDelegate?
    weak var viewController: UIViewController?
    var type: StaticCellType?
    var isReady: Bool = false

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet weak var actionBitton: UIButton!

    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!

    func config(value: String, type: StaticCellType, viewController: UIViewController, navigator: FeedBackNavigator?, delegate: IFeedbackStaticCellDelegate?) {
        if isReady { return }
        self.isReady.toggle()
        self.navigator = navigator
        self.delegate = delegate
        self.titleLabel.text = value
        self.type = type
        self.normalInputStyle()
        self.actionBitton.isHidden = true
        self.inputField.delegate = self
        if let type = self.type {
            switch type {
            case .organisation, .theme:
                self.actionBitton.isHidden = false
            case .phone:
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

    func check() {
        self.inputEditAction(with: inputField.text)
    }

    @IBAction func openSelectionAction(_ sender: Any) {
        guard let type = self.type else { return }

        if case .organisation = type {
            self.navigator?.navigate(to: .selection(title: titleLabel.text!, worker: OrganisationWorker(), delegate: self))
        }

        if case .theme = type {
            let title = titleLabel.text!.replacingOccurrences(of: "*", with: "")
            self.navigator?.navigate(to: .selection(title: title, worker: ThemesWorker(), delegate: self))
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

    func setValue(with: String) {
        self.inputField.text = with
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
        guard let type = self.type else { return false }
        switch type {
        case .organisation, .theme: return false
        default: return true
        }
    }

    func inputEditAction(with text: String?) {
        guard let type = self.type else { return }
        switch type {
        case .name:
            let result = self.validResult(string: text)
            delegate?.cellSource(with: .name(with: result))
        case .lastName:
            let result = self.validResult(string: text)
            delegate?.cellSource(with: .lastName(with: result))

        case .middleName:
            let result = self.validResult(string: text)
            delegate?.cellSource(with: .middleName(with: result))

        case .detail:
            let result = self.validResult(string: text)
            delegate?.cellSource(with: .detail(with: result))

        case .mail:
            let result = self.validResult(string: text)
            delegate?.cellSource(with: .mail(with: result))

        case .phone:
            let result = self.validResult(string: text)
            delegate?.cellSource(with: .phone(with: result))

        case .organisation, .theme:
            self.validResult(string: text)
        default:
            break
        }
    }

    @discardableResult
    func validResult(string: String?) -> String? {
        guard let string = string , let type = self.type else { return nil }
        switch type {
        case .mail:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: string) {
                self.normalInputStyle()
                return string
            }
            self.wrongInputStyle()
            return nil
        case .name, .lastName, .organisation, .theme:
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
        guard let type = self.type else { return }

        if case .organisation = type, let model = selected as? Organisation {
            self.inputField.text = model.shortTitle
            delegate?.cellSource(with: .organisation(with: model))
        }

        if case .theme = type, let model = selected as? FeedbackTheme {
            self.inputField.text = model.title
            delegate?.cellSource(with: .theme(with: model))
        }

        validResult(string: self.inputField.text)
    }
}
