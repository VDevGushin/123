//
//  PersonStatisticControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 30/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate extension Array where Element == Person {
    func clearAll() {
        self.forEach {
            $0.statistic.clearAll()
        }
    }
}

class PersonStatisticControl: UIView {
    private let xibName = String(describing: StatisticControl.self)
    private var view: UIView!
    @IBOutlet weak var collection: UITableView!
    fileprivate let mode = PercentagesControlMode.single
    private var source = [Person]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func update(source: [Person]) {
        self.source = source
        self.collection.reloadData()
    }

    func clear() {
        self.source.clearAll()
        self.collection.reloadData()
    }
}

fileprivate extension PersonStatisticControl {
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
        self.collection.backgroundColor = UIColor.clear
        self.collection.register(PersonStatisticCell.self)
        self.collection.separatorStyle = .none
        self.collection.rowHeight = 100
        self.collection.showsHorizontalScrollIndicator = false
        self.collection.showsVerticalScrollIndicator = false
        self.collection.delegate = self
        self.collection.dataSource = self
    }
}

extension PersonStatisticControl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: PersonStatisticCell.self, indexPath: indexPath)
        cell?.setup(with: self.source[indexPath.item])
        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.count
    }
}
