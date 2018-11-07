//
//  FeedBackFormViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

enum FeedbackActions {
    case setName
    case setOrganisation
    case setPhone
    case setMail
    case setTheme
    case setCaptcha
}

class FeedBackFormViewController: FeedBackBaseViewController {

    typealias cellSource = (title: String, cellType: UITableViewCell.Type, action: FeedbackActions)
    // @IBOutlet private weak var keyBoardView: UIView!
    @IBOutlet private weak var contentTable: UITableView!
    private var source = [cellSource]()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(navigator: FeedBackNavigator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: FeedbackStrings.FeedBackView.title.value, nibName: String(describing: FeedBackFormViewController.self), bundle: bundle)

        self.source.append((title: FeedbackStrings.FeedBackView.fullNameTitle.value, cellType: InputTableViewCell.self, action: .setName))
        self.source.append((title: FeedbackStrings.FeedBackView.organisationTitle.value, cellType: SelectionTableViewCell.self, action: .setOrganisation))
        self.source.append((title: FeedbackStrings.FeedBackView.phoneTitle.value, cellType: InputTableViewCell.self, action: .setPhone))
        self.source.append((title: FeedbackStrings.FeedBackView.emailTitle.value, cellType: InputTableViewCell.self, action: .setMail))
        self.source.append((title: FeedbackStrings.FeedBackView.themeTitle.value, cellType: SelectionTableViewCell.self, action: .setTheme))
        //   self.source.append((title: FeedbackStrings.FeedBackView.detailTitle.value, cellType: MultiIInputTableViewCell.self))
        //  self.source.append((title: FeedbackStrings.FeedBackView.captchaTitle.value, cellType: CaptchaTableViewCell.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTable.reloadData()
    }

    override func buildUI() {
        let types = self.source.map { return $0.cellType }
        FeedBackStyle.tableView(self.contentTable, self, types)
    }
}

extension FeedBackFormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSource = self.source[indexPath.item]
        let cell = tableView.dequeueReusableCell(type: cellSource.cellType, indexPath: indexPath) as! IFeedbackStaticCell
        cell.config(value: cellSource.title, action: cellSource.action)
        (cell as! UITableViewCell).selectionStyle = .none
        return cell as! UITableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

