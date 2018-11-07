//
//  SelectionTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell, IFeedbackStaticCell, FeedBackSearchViewControllerDelegate {
    var action: FeedbackActions?
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet private weak var selectionButton: UIButton!

    @IBAction private func selectionAction(_ sender: Any) {
        guard let action = self.action else { return }

        if case FeedbackActions.setOrganisation(let navigator, _) = action {
            navigator.navigate(to: .selection(title: titleLabel.text!, worker: OrganisationWorker(), delegate: self))
        }

        if case FeedbackActions.setTheme(let navigator, _) = action {
            navigator.navigate(to: .selection(title: titleLabel.text!, worker: ThemesWorker(), delegate: self))
        }
    }

    func selectSource<T>(selected: T) {
        guard let action = self.action else { return }

        if case FeedbackActions.setOrganisation(_, let then) = action, let model = selected as? Organisation {
            self.selectionButton.setTitle(model.shortTitle, for: .normal)
            then(model)
        }

        if case FeedbackActions.setTheme(_, let then) = action, let model = selected as? FeedbackTheme {
            self.selectionButton.setTitle(model.title, for: .normal)
            then(model)
        }
    }
}
