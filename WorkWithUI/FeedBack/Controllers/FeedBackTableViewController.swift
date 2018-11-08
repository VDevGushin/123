//
//  FeedBackTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Array where Element: CellSource {
    func checkAll() {
        self.forEach {
            if let cell = $0.cell as? IFeedbackStaticCell {
                cell.check()
            }
        }
    }
}

enum ActionsForStaticCells {
    typealias FeedBackHandler = (DataFromStaticCells) -> Void
    case setName(FeedBackHandler)
    case setLastName(FeedBackHandler)
    case setMiddleName(FeedBackHandler)
    case setOrganisation(FeedBackNavigator, FeedBackHandler)
    case setPhone(FeedBackHandler)
    case setMail(FeedBackHandler)
    case setTheme(FeedBackNavigator, FeedBackHandler)
    case setCaptcha(FeedBackHandler)
    case setDetail(FeedBackHandler)
    case done(FeedBackHandler)
}

enum DataFromStaticCells {
    case name(with: String?)
    case lastName(with: String?)
    case middleName(with: String?)
    case organisation(with: Organisation?)
    case phone(with: String?)
    case mail(with: String?)
    case theme(with: FeedbackTheme?)
    case captcha(id: String?, text: String?)
    case detail(with: String?)
    case done
}

final class CellSource {
    let title: String
    let cellType: UITableViewCell.Type
    let action: ActionsForStaticCells
    let cell: UITableViewCell
    init(title: String, cellType: UITableViewCell.Type, action: ActionsForStaticCells, cell: UITableViewCell) {
        self.title = title
        self.cellType = cellType
        self.action = action
        self.cell = cell
    }
}

final class FeedBackTableViewController: UITableViewController {
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: self.view.window)
    }

    typealias doneAction = () -> Void

    private let navigator: FeedBackNavigator
    private var source = [CellSource]()
    private let sendForm = SendForm()
    private var isFirstLoad = true

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator) {
        let bundle = Bundle(for: type(of: self))
        self.navigator = navigator
        super.init(nibName: String(describing: FeedBackTableViewController.self), bundle: bundle)
        self.navigationItem.title = FeedbackStrings.FeedBackView.title.value


        let nameSource = CellSource(title: FeedbackStrings.FeedBackView.name.value,
                                    cellType: InputTableViewCell.self,
                                    action: .setName(self.doneAction),
                                    cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(nameSource)


        let lastNameSource = CellSource(title: FeedbackStrings.FeedBackView.lastName.value,
                                        cellType: InputTableViewCell.self,
                                        action: .setLastName(self.doneAction),
                                        cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(lastNameSource)

        let middleNameSource = CellSource(title: FeedbackStrings.FeedBackView.middleName.value,
                                          cellType: InputTableViewCell.self,
                                          action: .setMiddleName(self.doneAction),
                                          cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(middleNameSource)

        let organisationSource = CellSource(title: FeedbackStrings.FeedBackView.organisationTitle.value,
                                            cellType: InputTableViewCell.self,
                                            action: .setOrganisation(self.navigator, self.doneAction),
                                            cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(organisationSource)

        let phoneSource = CellSource(title: FeedbackStrings.FeedBackView.phoneTitle.value,
                                     cellType: InputTableViewCell.self,
                                     action: .setPhone(self.doneAction),
                                     cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(phoneSource)

        let emailSource = CellSource(title: FeedbackStrings.FeedBackView.emailTitle.value,
                                     cellType: InputTableViewCell.self,
                                     action: .setMail(self.doneAction),
                                     cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(emailSource)

        let themeSource = CellSource(title: FeedbackStrings.FeedBackView.themeTitle.value,
                                     cellType: InputTableViewCell.self,
                                     action: .setTheme(self.navigator, self.doneAction),
                                     cell: Bundle.main.loadNibNamed("InputTableViewCell", owner: self, options: nil)?[0] as! InputTableViewCell)
        self.source.append(themeSource)

        let detailSource = CellSource(title: FeedbackStrings.FeedBackView.detailTitle.value,
                                      cellType: InputTableViewCell.self,
                                      action: .setDetail(self.doneAction),
                                      cell: Bundle.main.loadNibNamed("MultiIInputTableViewCell", owner: self, options: nil)?[0] as! MultiIInputTableViewCell)
        self.source.append(detailSource)

        let captchaSource = CellSource(title: FeedbackStrings.FeedBackView.captchaTitle.value,
                                       cellType: InputTableViewCell.self,
                                       action: .setCaptcha(self.doneAction),
                                       cell: Bundle.main.loadNibNamed("CaptchaTableViewCell", owner: self, options: nil)?[0] as! CaptchaTableViewCell)
        self.source.append(captchaSource)

        let doneSource = CellSource(title: "",
                                    cellType: InputTableViewCell.self,
                                    action: .done(self.doneAction),
                                    cell: Bundle.main.loadNibNamed("DoneTableViewCell", owner: self, options: nil)?[0] as! DoneTableViewCell)
        self.source.append(doneSource)
    }

    func doneAction(_ with: DataFromStaticCells) {
        switch with {
        case .captcha(id: let id, text: let text):
            self.sendForm.captcha = text
            self.sendForm.captchaId = id
        case .detail(with: let value):
            self.sendForm.detail = value
        case .mail(with: let value):
            self.sendForm.mail = value
        case .middleName(with: let value):
            self.sendForm.middleName = value
        case .name(with: let value):
            self.sendForm.name = value
        case .organisation(with: let value):
            self.sendForm.organisation = value
        case .phone(with: let value):
            self.sendForm.phone = value
        case .lastName(with: let value):
            self.sendForm.lastName = value
        case .theme(with: let value):
            self.sendForm.theme = value
        case .done:
            if sendForm.isValid, let sendData = FeedBackSendModel(from: self.sendForm) {
                let data = sendData.encode()
                dump(data)
            } else {
                self.source.checkAll()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    func buildUI() {
        self.view.backgroundColor = FeedBackStyle.whiteColor
        let types = self.source.map { return $0.cellType }
        FeedBackStyle.tableView(self.tableView, self, types)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96
        self.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSource = self.source[indexPath.item]
        let cell = cellSource.cell
        (cell as! IFeedbackStaticCell).config(value: cellSource.title, action: cellSource.action)
        cell.selectionStyle = .none
        return cell
    }
}
