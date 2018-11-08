//
//  FeedBackFormViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

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
    case name(with: String)
    case surName(with: String)
    case middleName(with: String)
    case organisation(with: Organisation)
    case phone(with: String)
    case mail(with: String)
    case theme(with: FeedbackTheme)
    case captcha(with: String)
    case detail(with: String)
    case done
}

class FeedBackFormViewController: FeedBackBaseViewController {
    typealias cellSource = (title: String,
                            cellType: UITableViewCell.Type,
                            action: ActionsForStaticCells)

    typealias doneAction = () -> Void

    @IBOutlet private weak var contentTable: UITableView!
    private var source = [cellSource]()
    private var collectionCells = Set<UITableViewCell>()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: FeedbackStrings.FeedBackView.title.value, nibName: String(describing: FeedBackFormViewController.self), bundle: bundle)
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTable.reloadData()
    }

    override func buildUI() {
        let types = self.source.map { return $0.cellType }
        FeedBackStyle.tableView(self.contentTable, self, types)

        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(FeedBackFormViewController.keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: self.view.window)
        notifier.addObserver(self,
                             selector: #selector(FeedBackFormViewController.keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: self.view.window)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }


    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShowNotification(_ sender: NSNotification) {

    }

    @objc func keyboardWillHideNotification(_ sender: NSNotification) {

    }
}

extension FeedBackFormViewController {
    func doneAction(_ with: DataFromStaticCells) {
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
        case .setCaptcha: return 206
        case .setDetail: return 150
        default: return 96
//        case .setMail: break
//        case .setName: break
//        case .setOrganisation: break
//        case .setPhone: break
//        case .setTheme: break
        }
    }
}

