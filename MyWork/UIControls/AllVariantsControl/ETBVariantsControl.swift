//
//  ETBVariantsControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 03/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class VariantModel {
    let variantNumber: String
    let questions: [String]

    init(variantNumber: Int, questions: [String]) {
        self.variantNumber = "Варианте \(variantNumber)"
        self.questions = questions
    }
}

class ETBVariantsControl: UIView {
    @IBOutlet weak var variantsTable: UITableView!
    private var source = [VariantModel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func update(source: [VariantModel]){
        self.source = source
        self.variantsTable.reloadData()
    }
}

fileprivate extension ETBVariantsControl {
    private func setup() {
        guard let view = self.loadFromNib(ETBVariantsControl.self) else { return }
        self.addSubview(view)
        self.setupCollection()
    }

    func setupCollection() {
        self.variantsTable.backgroundColor = UIColor.clear
        self.variantsTable.register(ETBVariantTableViewCell.self)
        self.variantsTable.estimatedRowHeight = 40
        self.variantsTable.rowHeight = UITableView.automaticDimension
        self.variantsTable.showsHorizontalScrollIndicator = false
        self.variantsTable.showsVerticalScrollIndicator = false
        self.variantsTable.delegate = self
        self.variantsTable.dataSource = self
    }
}

extension ETBVariantsControl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ETBVariantTableViewCell.self, indexPath: indexPath)
        let titleValue = self.source[indexPath.section].questions[indexPath.row]
        cell?.title.text = titleValue
        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source[section].questions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
         return self.source.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.source[section].variantNumber
    }
}
