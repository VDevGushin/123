//
//  SourceTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    
    func setSource(with: ISource) {
        DispatchQueue.main.async {
            self.title.text = with.innerTitle
        }
    }
}
