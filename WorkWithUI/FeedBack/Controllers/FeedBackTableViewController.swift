//
//  FeedBackTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class SendForm {
    var name: String?
    var surName: String?
    var middleName: String?
    var organisation: Organisation?
    var phone: String?
    var mail: String?
    var theme: FeedbackTheme?
    var captcha: String?
    var detail: String?

    var isValid: Bool {
        if name != nil &&
            surName != nil &&
            detail != nil &&
            organisation != nil &&
            mail != nil &&
            theme != nil &&
            captcha != nil {
            return true
        }
        return false
    }
}

enum ActionsForStaticCells {
    typealias FeedBackHandler = (DataFromStaticCells) -> Void
    case setName(FeedBackHandler)
    case setSurName(FeedBackHandler)
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
    case surName(with: String?)
    case middleName(with: String?)
    case organisation(with: Organisation?)
    case phone(with: String?)
    case mail(with: String?)
    case theme(with: FeedbackTheme?)
    case captcha(with: String?)
    case detail(with: String?)
    case done
}

final class FeedBackTableViewController: UITableViewController {
    typealias cellSource = (title: String,
                            cellType: UITableViewCell.Type,
                            action: ActionsForStaticCells)

    typealias doneAction = () -> Void

    private let navigator: FeedBackNavigator
    private var source = [cellSource]()
    private var collectionCells = Set<UITableViewCell>()
    private let sendForm = SendForm()
    private var isFirstLoad = true

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator) {
        let bundle = Bundle(for: type(of: self))
        self.navigator = navigator
        super.init(nibName: String(describing: FeedBackTableViewController.self), bundle: bundle)
        self.navigationItem.title = FeedbackStrings.FeedBackView.title.value

        self.source.append((title: FeedbackStrings.FeedBackView.name.value, cellType: InputTableViewCell.self, action: .setName(self.doneAction)))
        self.source.append((title: FeedbackStrings.FeedBackView.surname.value, cellType: InputTableViewCell.self, action: .setSurName(self.doneAction)))
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
        case .captcha(with: let value):
            self.sendForm.captcha = value
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
        case .surName(with: let value):
            self.sendForm.surName = value
        case .theme(with: let value):
            self.sendForm.theme = value
        case .done:
            if sendForm.isValid {
                print("!!!!!!!!!!!!!!!!")
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
        let cell = tableView.dequeueReusableCell(type: cellSource.cellType, indexPath: indexPath)!
        
        if let inputTableViewCell = cell as? InputTableViewCell {
           inputTableViewCell.config(value: cellSource.title, action: cellSource.action)
        }
        
        if let captchaTableViewCell = cell as? CaptchaTableViewCell {
            captchaTableViewCell.config(value: cellSource.title, action: cellSource.action)
        }
        
        if let multiIInputTableViewCell = cell as? MultiIInputTableViewCell {
            multiIInputTableViewCell.config(value: cellSource.title, action: cellSource.action)
        }
        
        cell.selectionStyle = .none
        self.collectionCells.insert(cell)
        return cell
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
