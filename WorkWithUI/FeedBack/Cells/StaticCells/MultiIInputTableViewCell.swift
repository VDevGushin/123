//
//  MultiIInputTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class MultiIInputTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var initialSource: FeedBackCellIncomeData?
    
    var isReady: Bool = false
    
    var action: FeedBackCellAction?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textInput: UITextView!

    func config(value: String, action: FeedBackCellAction) {
        if isReady { return }
        self.isReady.toggle()
        self.titleLabel.text = value
        self.action = action
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
    
    func setValue(with: String){
        
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
    func validResult(string: String?, action: FeedBackCellAction) -> String? {
        guard let string = string else { return nil }
        if case .setDetail = action {
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
