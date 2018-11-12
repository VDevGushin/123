//
//  FeedBackTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class FeedBackTableViewController: UITableViewController {
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: self.view.window)
    }

    typealias doneAction = () -> Void

    private let navigator: FeedBackNavigator
    private var source = [CellSource]()
    private lazy var reporter = FeedBackReportWorker()
    private var feedBackFrom: FeedBackInitFrom?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator, initFormData: FeedBackInitFrom?) {
        self.feedBackFrom = initFormData
        let bundle = Bundle(for: type(of: self))
        self.navigator = navigator
        super.init(nibName: String(describing: FeedBackTableViewController.self), bundle: bundle)
        self.navigationItem.title = FeedbackStrings.FeedBackView.title.value
        self.source = self.initDataSource()
    }

    override func viewDidLoad() {
        defer { self.source.initStartSource(from: self.feedBackFrom) }
        super.viewDidLoad()
        buildUI()
    }

    func buildUI() {
        self.view.backgroundColor = FeedBackStyle.whiteColor
        let types = self.source.map { return $0.cellType }
        FeedBackStyle.tableView(self.tableView, self, types)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        self.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    //Перенести в обработчик
    func doneAction(_ with: FeedBackCellIncomeData) {
        self.reporter.sendAction(with) { result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    switch error {
                    case FeedBackError.captcha: self.source.resetCaptcha(with: "")
                    case FeedBackError.invalidModel: self.source.checkAll()
                    default: break
                    }
                case .result:
                    break
                }
            }
        }
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


//MARK: - Make source
fileprivate extension FeedBackTableViewController {
    func getFromNib<T:AnyObject>() -> T { return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?[0] as! T }
    
    func initDataSource() -> [CellSource] {
        var source = [CellSource]()

        let nameCell: InputTableViewCell = self.getFromNib()
        let nameSource = CellSource(title: FeedbackStrings.FeedBackView.name.value,
                                    cellType: InputTableViewCell.self,
                                    action: .setName(self.doneAction),
                                    cell: nameCell)
        source.append(nameSource)


        let lastNameCell: InputTableViewCell = self.getFromNib()
        let lastNameSource = CellSource(title: FeedbackStrings.FeedBackView.lastName.value,
                                        cellType: InputTableViewCell.self,
                                        action: .setLastName(self.doneAction),
                                        cell: lastNameCell)
        source.append(lastNameSource)


        let middleNameCell: InputTableViewCell = self.getFromNib()
        let middleNameSource = CellSource(title: FeedbackStrings.FeedBackView.middleName.value,
                                          cellType: InputTableViewCell.self,
                                          action: .setMiddleName(self.doneAction),
                                          cell: middleNameCell)
        source.append(middleNameSource)


        let organisationCell: InputTableViewCell = self.getFromNib()
        let organisationSource = CellSource(title: FeedbackStrings.FeedBackView.organisationTitle.value,
                                            cellType: InputTableViewCell.self,
                                            action: .setOrganisation(self.navigator, self.doneAction),
                                            cell: organisationCell)
        source.append(organisationSource)


        let phoneCell: InputTableViewCell = self.getFromNib()
        let phoneSource = CellSource(title: FeedbackStrings.FeedBackView.phoneTitle.value,
                                     cellType: InputTableViewCell.self,
                                     action: .setPhone(self.doneAction),
                                     cell: phoneCell)
        source.append(phoneSource)


        let emailCell: InputTableViewCell = self.getFromNib()
        let emailSource = CellSource(title: FeedbackStrings.FeedBackView.emailTitle.value,
                                     cellType: InputTableViewCell.self,
                                     action: .setMail(self.doneAction),
                                     cell: emailCell)
        source.append(emailSource)

        let themeCell: InputTableViewCell = self.getFromNib()
        let themeSource = CellSource(title: FeedbackStrings.FeedBackView.themeTitle.value,
                                     cellType: InputTableViewCell.self,
                                     action: .setTheme(self.navigator, self.doneAction),
                                     cell: themeCell)
        source.append(themeSource)

        let detailCell: MultiIInputTableViewCell = self.getFromNib()
        let detailSource = CellSource(title: FeedbackStrings.FeedBackView.detailTitle.value,
                                      cellType: InputTableViewCell.self,
                                      action: .setDetail(self.doneAction),
                                      cell: detailCell)
        source.append(detailSource)
        
        let attachCell: AttachTableViewCell = self.getFromNib()
        let attachlSource = CellSource(title: FeedbackStrings.FeedBackView.attachTitle.value,
                                      cellType: AttachTableViewCell.self,
                                      action: .setDetail(self.doneAction),
                                      cell: attachCell)
        source.append(attachlSource)

        let captchaCell: CaptchaTableViewCell = self.getFromNib()
        let captchaSource = CellSource(title: FeedbackStrings.FeedBackView.captchaTitle.value,
                                       cellType: InputTableViewCell.self,
                                       action: .setCaptcha(self.doneAction),
                                       cell: captchaCell)
        source.append(captchaSource)

        let doneCell: DoneTableViewCell = self.getFromNib()
        let doneSource = CellSource(title: "",
                                    cellType: InputTableViewCell.self,
                                    action: .done(self.doneAction),
                                    cell: doneCell)
        source.append(doneSource)
        return source
    }
}

//MARK: - Source data manager
fileprivate extension Array where Element: CellSource {
    func checkAll() {
        self.forEach {
            if let cell = $0.cell as? IFeedbackStaticCell {
                cell.check()
            }
        }
    }

    func initStartSource(from: FeedBackInitFrom?) {
        guard let from = from else { return }
        self.setName(with: (from.name, from.lastName, from.middleName))
        self.setMail(with: from.mail)
        self.setPhone(with: from.phone)
    }

    func resetCaptcha(with: String?) {
        guard let with = with else { return }
        if let cell: CaptchaTableViewCell = getNeedCell(cellType: FeedBackCellAction.StaticCellType.captcha) {
            (cell as IFeedbackStaticCell).setValue(with: with)
            (cell as IFeedbackStaticCell).check()
        }
    }

    func setPhone(with: String?) {
        guard let with = with else { return }
        if let cell: InputTableViewCell = getNeedCell(cellType: FeedBackCellAction.StaticCellType.phone) {
            (cell as IFeedbackStaticCell).setValue(with: with)
        }
    }

    func setMail(with: String?) {
        guard let with = with else { return }
        if let cell: InputTableViewCell = getNeedCell(cellType: FeedBackCellAction.StaticCellType.mail) {
            (cell as IFeedbackStaticCell).setValue(with: with)
        }
    }

    func setName(with: (firstName: String?,
                        lastName: String?,
                        middleName: String?)) {
        if let firstName = with.firstName, let cell: InputTableViewCell = getNeedCell(cellType: FeedBackCellAction.StaticCellType.name) {
            (cell as IFeedbackStaticCell).setValue(with: firstName)
        }

        if let lastName = with.lastName, let cell: InputTableViewCell = getNeedCell(cellType: FeedBackCellAction.StaticCellType.lastName) {
            (cell as IFeedbackStaticCell).setValue(with: lastName)
        }

        if let middleName = with.middleName, let cell: InputTableViewCell = getNeedCell(cellType: FeedBackCellAction.StaticCellType.middleName) {
            (cell as IFeedbackStaticCell).setValue(with: middleName)
        }
    }

    private func getNeedCell<T: UITableViewCell>(cellType: FeedBackCellAction.StaticCellType) -> T? {
        let capchaSource = self.first {
            if $0.cell is T && $0.action.id == cellType.rawValue {
                return true
            }
            return false
        }
        guard let capcha = capchaSource else { return nil }
        return capcha.cell as? T
    }
}
