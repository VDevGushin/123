//
//  ColorTableViewCell.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setColor(with model : ColorInfoModel){
        self.backgroundColor = model.color
        self.colorLabel.text = model.info
    }
    
}
