//
//  FeedBackTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Dictionary where Value: UITableViewCell {
    func checkAll() {
        self.forEach {
            if let cell = $0.value as? IFeedbackStaticCell {
                cell.check()
            }
        }
    }
}

final class SendForm {
    var name: String?
    var surName: String?
    var lastName: String?
    var organisation: Organisation?
    var phone: String?
    var mail: String?
    var theme: FeedbackTheme?
    var captcha: String?
    var captchaId: String?
    var detail: String?

    var isValid: Bool {
        if name != nil &&
            surName != nil &&
            detail != nil &&
            organisation != nil &&
            mail != nil &&
            theme != nil &&
            captcha != nil &&
            captchaId != nil {
            return true
        }
        return false
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

final class FeedBackTableViewController: UITableViewController {
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: self.view.window)
    }

    typealias cellSource = (title: String,
                            cellType: UITableViewCell.Type,
                            action: ActionsForStaticCells)

    typealias doneAction = () -> Void

    private let navigator: FeedBackNavigator
    private var source = [cellSource]()
    private var collectionCells = [Int: UITableViewCell]()
    private let sendForm = SendForm()
    private var isFirstLoad = true

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator) {
        let bundle = Bundle(for: type(of: self))
        self.navigator = navigator
        super.init(nibName: String(describing: FeedBackTableViewController.self), bundle: bundle)
        self.navigationItem.title = FeedbackStrings.FeedBackView.title.value

        self.source.append((title: FeedbackStrings.FeedBackView.name.value, cellType: InputTableViewCell.self, action: .setName(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.lastName.value, cellType: InputTableViewCell.self, action: .setLastName(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.middleName.value, cellType: InputTableViewCell.self, action: .setMiddleName(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.organisationTitle.value, cellType: InputTableViewCell.self, action: .setOrganisation(self.navigator, self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.phoneTitle.value, cellType: InputTableViewCell.self, action: .setPhone(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.emailTitle.value, cellType: InputTableViewCell.self, action: .setMail(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.themeTitle.value, cellType: InputTableViewCell.self, action: .setTheme(self.navigator, self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.detailTitle.value, cellType: MultiIInputTableViewCell.self, action: .setDetail(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.captchaTitle.value, cellType: CaptchaTableViewCell.self, action: .setCaptcha(self.doneAction)))
        self.source.append((title: "", cellType: DoneTableViewCell.self, action: .done(self.doneAction)))
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
            self.sendForm.lastName = value
        case .name(with: let value):
            self.sendForm.name = value
        case .organisation(with: let value):
            self.sendForm.organisation = value
        case .phone(with: let value):
            self.sendForm.phone = value
        case .lastName(with: let value):
            self.sendForm.surName = value
        case .theme(with: let value):
            self.sendForm.theme = value
        case .done:
            if sendForm.isValid {
                print("!!!!!!!!!!!!!!!!")
            } else {
                self.collectionCells.checkAll()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        self.tableView.reloadData()
    }

    func buildUI() {
        self.view.backgroundColor = FeedBackStyle.whiteColor
        let types = self.source.map { return $0.cellType }
        FeedBackStyle.tableView(self.tableView, self, types)
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

        guard let readyCell = self.collectionCells[indexPath.row] else {
            let cell = tableView.dequeueReusableCell(type: cellSource.cellType, indexPath: indexPath)!
            (cell as! IFeedbackStaticCell).config(value: cellSource.title, action: cellSource.action)
            cell.selectionStyle = .none
            self.collectionCells[indexPath.row] = cell
            return cell
        }
        return readyCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellSource = self.source[indexPath.item]
        switch cellSource.action {
        case .setCaptcha: return 206
        case .setDetail: return 140
        case .done: return 76
        default: return 96
            //        case .setMail: break
            //        case .setName: break
            //        case .setOrganisation: break
            //        case .setPhone: break
            //        case .setTheme: break
        }
    }
}
