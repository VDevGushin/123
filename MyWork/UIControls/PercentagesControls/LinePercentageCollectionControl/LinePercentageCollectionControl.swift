//
//  LinePercentageCollectionControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 26/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@IBDesignable
class LinePercentageCollectionControl: UIView {
    @IBOutlet weak var collection: UITableView!
    private let xibName = String(describing: LinePercentageCollectionControl.self)
    private var view: UIView!
    fileprivate var source = [LinePercentagesSource]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func update(source: [LinePercentagesSource]) {
        self.source = source
        self.collection.reloadData()
    }

    func changeMode() {
        for cell in self.collection.visibleCells {
            if let needCell = cell as? LinePercentTableViewCell {
                needCell.lineControl.changeMode()
            }
        }
    }
}

fileprivate extension LinePercentageCollectionControl {
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
        self.collection.dataSource = self
        self.collection.register(LinePercentTableViewCell.self)
        self.collection.separatorStyle = .none
        self.collection.estimatedRowHeight = 30
        self.collection.rowHeight = UITableViewAutomaticDimension
    }
}

extension LinePercentageCollectionControl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let res = self.source[indexPath.item]
        let cell = tableView.dequeueReusableCell(type: LinePercentTableViewCell.self, indexPath: indexPath)
        cell?.lineControl.update(with: res.getSet())
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.count
    }
}
