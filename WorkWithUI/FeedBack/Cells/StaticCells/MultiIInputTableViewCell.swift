//
//  MultiIInputTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class MultiIInputTableViewCell: UITableViewCell, IFeedbackStaticCell {
    weak var navigator: FeedBackNavigator?
    weak var delegate: IFeedbackStaticCellDelegate?
    var type: StaticCellType?
    var isReady: Bool = false

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textInput: UITextView!

    weak var viewController: UIViewController?
    func config(value: String, type: StaticCellType, viewController: UIViewController, navigator: FeedBackNavigator?, delegate: IFeedbackStaticCellDelegate?) {
        if isReady { return }
        self.isReady.toggle()
        self.delegate = delegate
        self.navigator = navigator
        self.titleLabel.text = value
        self.type = type
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

    func check() {
        self.inputEditAction(with: textInput.text)
    }

    func setValue(with: String) { }
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
        if let type = self.type, case .detail = type {
            let result = self.validResult(string: text, type: type)
            delegate?.cellSource(with: .detail(with: result))
        }
    }

    @discardableResult
    func validResult(string: String?, type: StaticCellType) -> String? {
        guard let string = string else { return nil }
        if case .detail = type {
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.normalInputStyle()
                return string
            }
            self.wrongInputStyle()
            return nil
        }
        return string
    }
}
