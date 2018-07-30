//
//  LinePercentageCollectionControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 26/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Array where Element == LinePercentagesSource {
    func clearAll() {
        self.forEach {
            $0.clearAll()
        }
    }
}

class StatisticControl: UIView {
    enum HeaderText {
        case globalTitle
        case globalSubTitle
        case title
        case subTitle
        func getValue(mode: PercentagesControlMode) -> String {
            switch mode {
            case .multiple:
                switch self {
                case .globalSubTitle: return "Процентное соотношение по ответам на задания теста"
                case .globalTitle: return "Динамика ответов по классу"
                case .subTitle: return "Процентное соотношение по ответам на задания теста по вариантам"
                case .title: return "Динамика ответов по вариантам"
                }
            case .single:
                switch self {
                case .globalSubTitle: return "Процент учащихся, которые завершили выполнение теста"
                case .globalTitle: return "Динамика выполнения по классу"
                case .subTitle: return "Процент учащихся по вариантам, которые завершили выполнение теста"
                case .title: return "Динамика выполнения по вариантов"
                }
            }
        }
    }

    @IBOutlet weak var collection: UITableView!
    private let colorSource = UIColor.linePercentCollectionColorSource
    private var gloabalSource = RoundPercentagesSource()
    private let xibName = String(describing: StatisticControl.self)
    private var view: UIView!
    fileprivate var source = [LinePercentagesSource]()
    fileprivate var mode = PercentagesControlMode.multiple {
        didSet {
            self.collection.reloadData()
        }
    }
    fileprivate var needToClear = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func updateVariants(source: [LinePercentagesSource]) {
        self.source = source
        self.collection.reloadData()
    }

    func updateGlobal(source: RoundPercentagesSource) {
        self.gloabalSource = source
    }

    func changeMode(with new: PercentagesControlMode) {
        self.mode = new
    }

    func clear() {
        self.source.clearAll()
        self.needToClear = true
        self.collection.reloadData()
    }
}

fileprivate extension StatisticControl {
    func setup() {
        self.view = loadFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.setupCollection()
    }

    func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }

    func setupCollection() {
        self.collection.delegate = self
        self.collection.backgroundColor = UIColor.clear
        self.collection.dataSource = self
        self.collection.register(StatisticCell.self)
        self.collection.registerFooterHeader(StatisticHeader.self)
        self.collection.registerFooterHeader(StatisticFooter.self)
        self.collection.separatorStyle = .none
        self.collection.estimatedRowHeight = 30
        self.collection.rowHeight = UITableViewAutomaticDimension
        self.collection.sectionHeaderHeight = UITableViewAutomaticDimension
        self.collection.estimatedSectionHeaderHeight = 250
        self.collection.sectionFooterHeight = UITableViewAutomaticDimension
        self.collection.estimatedSectionFooterHeight = 250
        self.collection.showsHorizontalScrollIndicator = false
        self.collection.showsVerticalScrollIndicator = false
        self.clear()
    }
}

extension StatisticControl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let res = self.source[indexPath.item]
        let cell = tableView.dequeueReusableCell(type: StatisticCell.self, indexPath: indexPath)
        cell?.lineControl.update(with: res.getSet())
        cell?.lineControl.setColor(colorSource[indexPath.item % 5])
        cell?.lineControl.changeMode(with: self.mode)
        cell?.lineControl.setVariant(value: .value(indexPath.item + 1))
        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.count
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if case .multiple = self.mode, let footerView = tableView.dequeueReusableHeaderFooter(type: StatisticFooter.self) {
            footerView.setup()
            return footerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooter(type: StatisticHeader.self) {
            headerView.setMode(new: self.mode)
            if self.needToClear {
                self.gloabalSource.clearAll()
                self.needToClear = !self.needToClear
            }
            headerView.update(source: self.gloabalSource)
            headerView.globalTitle.text = HeaderText.globalTitle.getValue(mode: self.mode)
            headerView.globalSubTitle.text = HeaderText.globalSubTitle.getValue(mode: self.mode)
            headerView.title.text = HeaderText.title.getValue(mode: self.mode)
            headerView.subTitle.text = HeaderText.subTitle.getValue(mode: self.mode)
            return headerView
        }
        return nil
    }
}
