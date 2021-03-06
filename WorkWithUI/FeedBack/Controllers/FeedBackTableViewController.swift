//
//  FeedBackTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class FeedBackTableViewController: UITableViewController, IFeedbackStaticCellDelegate {
    typealias doneAction = () -> Void
    private let navigator: FeedBackNavigator
    private var source = [CellSource]()
    private lazy var reporter = FeedBackReportWorker()
    private var feedBackFrom: FeedBackInitFrom?

    deinit {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }

    private var loadingView: UIView? = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.color = FeedBackStyle.styleColor
        indicator.startAnimating()
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        if let delegateView = (UIApplication.shared.delegate as? AppDelegate)?.window {
            delegateView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalTo: delegateView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: delegateView.heightAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: delegateView.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: delegateView.rightAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: delegateView.bottomAnchor).isActive = true
            view.topAnchor.constraint(equalTo: delegateView.topAnchor).isActive = true
        }

        return view
    }()

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
        self.loading(false)
    }

    private func loading(_ show: Bool) {
        self.loadingView?.isHidden = !show
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }


    func cellSource(with: FeedBackCellIncomeData) {
        if case .done = with { self.loading(true) }

        self.reporter.tryToSendReport(with) { result in
            DispatchQueue.main.async {
                self.loading(false)
                switch result {
                case .error(let error):
                    switch error {
                    case FeedBackError.captcha: self.source.resetCaptcha(with: "")
                    case FeedBackError.invalidModel: self.source.checkAll()
                    default: break
                    }
                case .result:
                    self.source.removeAll()
                    self.navigator.close()
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
        let specialCell = cell as! IFeedbackStaticCell
        if !specialCell.isReady {
            specialCell.config(value: cellSource.title, type: cellSource.type, viewController: self, navigator: self.navigator, delegate: self)
        }
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
                                    type: .name,
                                    cell: nameCell)
        source.append(nameSource)

        let lastNameCell: InputTableViewCell = self.getFromNib()
        let lastNameSource = CellSource(title: FeedbackStrings.FeedBackView.lastName.value,
                                        cellType: InputTableViewCell.self,
                                        type: .lastName,
                                        cell: lastNameCell)
        source.append(lastNameSource)


        let middleNameCell: InputTableViewCell = self.getFromNib()
        let middleNameSource = CellSource(title: FeedbackStrings.FeedBackView.middleName.value,
                                          cellType: InputTableViewCell.self,
                                          type: .middleName,
                                          cell: middleNameCell)
        source.append(middleNameSource)


        let organisationCell: InputTableViewCell = self.getFromNib()
        let organisationSource = CellSource(title: FeedbackStrings.FeedBackView.organisationTitle.value,
                                            cellType: InputTableViewCell.self,
                                            type: .organisation,
                                            cell: organisationCell)
        source.append(organisationSource)


        let phoneCell: InputTableViewCell = self.getFromNib()
        let phoneSource = CellSource(title: FeedbackStrings.FeedBackView.phoneTitle.value,
                                     cellType: InputTableViewCell.self,
                                     type: .phone,
                                     cell: phoneCell)
        source.append(phoneSource)


        let emailCell: InputTableViewCell = self.getFromNib()
        let emailSource = CellSource(title: FeedbackStrings.FeedBackView.emailTitle.value,
                                     cellType: InputTableViewCell.self,
                                     type: .mail,
                                     cell: emailCell)
        source.append(emailSource)

        let themeCell: InputTableViewCell = self.getFromNib()
        let themeSource = CellSource(title: FeedbackStrings.FeedBackView.themeTitle.value,
                                     cellType: InputTableViewCell.self,
                                     type: .theme,
                                     cell: themeCell)
        source.append(themeSource)

        let detailCell: MultiIInputTableViewCell = self.getFromNib()
        let detailSource = CellSource(title: FeedbackStrings.FeedBackView.detailTitle.value,
                                      cellType: InputTableViewCell.self,
                                      type: .detail,
                                      cell: detailCell)
        source.append(detailSource)

        let attachCell: AttachTableViewCell = self.getFromNib()
        let attachlSource = CellSource(title: FeedbackStrings.FeedBackView.attachTitle.value,
                                       cellType: AttachTableViewCell.self,
                                       type: .attach,
                                       cell: attachCell)
        source.append(attachlSource)

        let captchaCell: CaptchaTableViewCell = self.getFromNib()
        let captchaSource = CellSource(title: FeedbackStrings.FeedBackView.captchaTitle.value,
                                       cellType: InputTableViewCell.self,
                                       type: .captcha,
                                       cell: captchaCell)
        source.append(captchaSource)

        let doneCell: DoneTableViewCell = self.getFromNib()
        let doneSource = CellSource(title: "",
                                    cellType: InputTableViewCell.self,
                                    type: .done,
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
        if let cell: CaptchaTableViewCell = getNeedCell(cellType: .captcha) {
            (cell as IFeedbackStaticCell).setValue(with: with)
            (cell as IFeedbackStaticCell).check()
        }
    }

    func setPhone(with: String?) {
        guard let with = with else { return }
        if let cell: InputTableViewCell = getNeedCell(cellType: .phone) {
            (cell as IFeedbackStaticCell).setValue(with: with)
        }
    }

    func setMail(with: String?) {
        guard let with = with else { return }
        if let cell: InputTableViewCell = getNeedCell(cellType: .mail) {
            (cell as IFeedbackStaticCell).setValue(with: with)
        }
    }

    func setName(with: (firstName: String?,
                        lastName: String?,
                        middleName: String?)) {
        if let firstName = with.firstName, let cell: InputTableViewCell = getNeedCell(cellType: .name) {
            (cell as IFeedbackStaticCell).setValue(with: firstName)
        }

        if let lastName = with.lastName, let cell: InputTableViewCell = getNeedCell(cellType: .lastName) {
            (cell as IFeedbackStaticCell).setValue(with: lastName)
        }

        if let middleName = with.middleName, let cell: InputTableViewCell = getNeedCell(cellType: .middleName) {
            (cell as IFeedbackStaticCell).setValue(with: middleName)
        }
    }

    private func getNeedCell<T: UITableViewCell>(cellType: StaticCellType) -> T? {
        let capchaSource = self.first {
            if $0.cell is T && $0.type.rawValue == cellType.rawValue {
                return true
            }
            return false
        }
        guard let capcha = capchaSource else { return nil }
        return capcha.cell as? T
    }
}
