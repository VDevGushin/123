//
//  FeedBackFormViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

enum FeedbackActions {
    case setName((String) -> Void)
    case setOrganisation(FeedBackNavigator, (Organisation) -> Void)
    case setPhone((String) -> Void)
    case setMail((String) -> Void)
    case setTheme(FeedBackNavigator, (FeedbackTheme) -> Void)
    case setCaptcha((String) -> Void)
    case setDetail((String) -> Void)
    case done(() -> Void)
}

class FeedBackFormViewController: FeedBackBaseViewController {
    typealias cellSource = (title: String, cellType: UITableViewCell.Type, action: FeedbackActions)
    typealias doneAction = () -> Void
    @IBOutlet private weak var contentTable: UITableView!
    private var source = [cellSource]()
    private var collectionCells = Set<UITableViewCell>()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(navigator: FeedBackNavigator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: FeedbackStrings.FeedBackView.title.value, nibName: String(describing: FeedBackFormViewController.self), bundle: bundle)
        self.source.append((title: FeedbackStrings.FeedBackView.fullNameTitle.value, cellType: InputTableViewCell.self, action: .setName(self.getName)))
        self.source.append((title: FeedbackStrings.FeedBackView.organisationTitle.value, cellType: SelectionTableViewCell.self, action: .setOrganisation(self.navigator, self.getOrganisation)))
        self.source.append((title: FeedbackStrings.FeedBackView.phoneTitle.value, cellType: InputTableViewCell.self, action: .setPhone(self.getPhone)))
        self.source.append((title: FeedbackStrings.FeedBackView.emailTitle.value, cellType: InputTableViewCell.self, action: .setMail(self.getMail)))
        self.source.append((title: FeedbackStrings.FeedBackView.themeTitle.value, cellType: SelectionTableViewCell.self, action: .setTheme(self.navigator, self.getTheme)))
        self.source.append((title: FeedbackStrings.FeedBackView.detailTitle.value, cellType: MultiIInputTableViewCell.self, action: .setDetail(self.getDetail)))
        self.source.append((title: FeedbackStrings.FeedBackView.captchaTitle.value, cellType: CaptchaTableViewCell.self, action: .setCaptcha(self.getCaptcha)))
        self.source.append((title: "", cellType: DoneTableViewCell.self, action: .done(self.doneAction)))
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

extension FeedBackFormViewController {
    func doneAction() {
        print("done")
    }

    func getName(with: String) {
        dump(with)
    }

    func getPhone(with: String) {
        dump(with)
    }

    func getMail(with: String) {
        dump(with)
    }

    func getCaptcha(with: String) {
        dump(with)
    }

    func getDetail(with: String) {
        dump(with)
    }

    func getOrganisation(with: Organisation) {
        dump(with)
    }

    func getTheme(with: FeedbackTheme) {
        dump(with)
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
        let tableCell = cell as! UITableViewCell
        tableCell.selectionStyle = .none
        self.collectionCells.insert(tableCell)
        return tableCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellSource = self.source[indexPath.item]
        switch cellSource.action {
        case .setCaptcha: return 200
        case .setDetail: return 150
        default: return 86
//        case .setMail: break
//        case .setName: break
//        case .setOrganisation: break
//        case .setPhone: break
//        case .setTheme: break
        }
    }
}

